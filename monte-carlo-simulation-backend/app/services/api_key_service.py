"""
API Key Service
Handles API key generation, validation, revocation, and lifecycle management
"""

from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, and_
from datetime import datetime, timedelta, timezone
from fastapi import HTTPException, status
from app.models.api_key import ApiKey
from app.models.user import User
from app.schemas.api_key import ApiKeyCreate, ApiKeyResponse, ApiKeyListItem
from app.utils.security import generate_api_key
from app.config import settings


class ApiKeyService:
    """
    API Key service for managing user API keys

    Business Rules:
        - Each user can have max 10 active API keys
        - Users must maintain minimum 2 active keys (prevents lockout)
        - Keys expire after 30 days (configurable)
        - Full key shown only once during creation
        - Keys can be active, expired, or revoked

    Methods:
        - create_api_key: Generate new API key for user
        - list_user_api_keys: Get all user's API keys (masked)
        - revoke_api_key: Revoke an API key
        - validate_api_key: Check if API key is valid
        - get_api_key_by_value: Retrieve API key by key string
    """

    MAX_ACTIVE_KEYS = 10
    MIN_ACTIVE_KEYS = 2

    @staticmethod
    async def create_api_key(
        user_id: int,
        key_data: ApiKeyCreate,
        db: AsyncSession
    ) -> ApiKeyResponse:
        """
        Generate new API key for user

        Steps:
            1. Check user has < 10 active keys
            2. Generate unique API key (mk_live_XXXXXXXX...)
            3. Set expiry date (30 days from now)
            4. Save to database
            5. Return full key (only time it's shown!)

        Args:
            user_id: User ID
            key_data: API key creation data (name)
            db: Database session

        Returns:
            ApiKeyResponse with full key (only shown once!)

        Raises:
            HTTPException 400: If user already has 10 active keys
            HTTPException 500: If database error occurs
        """
        try:
            # Check if user has reached max active keys
            stmt = select(ApiKey).where(
                and_(
                    ApiKey.user_id == user_id,
                    ApiKey.status == 'active'
                )
            )
            result = await db.execute(stmt)
            active_keys = result.scalars().all()

            if len(active_keys) >= ApiKeyService.MAX_ACTIVE_KEYS:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail=f"Maximum {ApiKeyService.MAX_ACTIVE_KEYS} active API keys reached. "
                           f"Please revoke an old key before creating a new one."
                )

            # Generate unique API key
            api_key_value = generate_api_key()

            # Ensure uniqueness (extremely unlikely collision, but check anyway)
            while await ApiKeyService._key_exists(api_key_value, db):
                api_key_value = generate_api_key()

            # Set expiry date (30 days from now)
            created_at = datetime.now(timezone.utc)
            expires_at = created_at + timedelta(days=settings.API_KEY_EXPIRY_DAYS)

            # Create API key record
            new_key = ApiKey(
                user_id=user_id,
                key=api_key_value,
                name=key_data.name,
                status='active',
                created_at=created_at,
                expires_at=expires_at
            )

            db.add(new_key)
            await db.commit()
            await db.refresh(new_key)

            # Return full key (only shown once!)
            return ApiKeyResponse.model_validate(new_key)

        except HTTPException:
            raise
        except Exception as e:
            await db.rollback()
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Failed to create API key: {str(e)}"
            )

    @staticmethod
    async def list_user_api_keys(user_id: int, db: AsyncSession) -> list[ApiKeyListItem]:
        """
        List all API keys for a user (with masked keys)

        Args:
            user_id: User ID
            db: Database session

        Returns:
            List of ApiKeyListItem (keys are masked)
        """
        stmt = select(ApiKey).where(ApiKey.user_id == user_id).order_by(ApiKey.created_at.desc())
        result = await db.execute(stmt)
        api_keys = result.scalars().all()

        # Convert to response model with masked keys
        return [
            ApiKeyListItem(
                id=key.id,
                key_preview=key.key_preview,  # Property returns masked version
                name=key.name,
                status=key.status,
                created_at=key.created_at,
                expires_at=key.expires_at,
                last_used_at=key.last_used_at,
                is_expired=key.is_expired,  # Property checks if expired
                days_until_expiry=key.days_until_expiry  # Property calculates days
            )
            for key in api_keys
        ]

    @staticmethod
    async def revoke_api_key(user_id: int, api_key_id: int, db: AsyncSession) -> dict:
        """
        Revoke an API key

        Business Rule: Users must maintain minimum 2 active keys

        Args:
            user_id: User ID (for authorization)
            api_key_id: API key ID to revoke
            db: Database session

        Returns:
            Success message

        Raises:
            HTTPException 404: If API key not found
            HTTPException 403: If user doesn't own the key
            HTTPException 400: If revoking would leave < 2 active keys
        """
        try:
            # Find API key
            stmt = select(ApiKey).where(ApiKey.id == api_key_id)
            result = await db.execute(stmt)
            api_key = result.scalar_one_or_none()

            if not api_key:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail=f"API key with ID {api_key_id} not found"
                )

            # Check ownership
            if api_key.user_id != user_id:
                raise HTTPException(
                    status_code=status.HTTP_403_FORBIDDEN,
                    detail="You don't have permission to revoke this API key"
                )

            # Check if already revoked
            if api_key.status == 'revoked':
                return {"message": "API key is already revoked"}

            # Check minimum active keys requirement
            stmt = select(ApiKey).where(
                and_(
                    ApiKey.user_id == user_id,
                    ApiKey.status == 'active',
                    ApiKey.id != api_key_id  # Exclude the key being revoked
                )
            )
            result = await db.execute(stmt)
            remaining_active_keys = result.scalars().all()

            if len(remaining_active_keys) < ApiKeyService.MIN_ACTIVE_KEYS:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail=f"Cannot revoke key. You must maintain at least "
                           f"{ApiKeyService.MIN_ACTIVE_KEYS} active API keys. "
                           f"Create a new key before revoking this one."
                )

            # Revoke the key
            api_key.status = 'revoked'
            await db.commit()

            return {
                "message": f"API key '{api_key.name}' has been revoked successfully",
                "revoked_key_id": api_key.id
            }

        except HTTPException:
            raise
        except Exception as e:
            await db.rollback()
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Failed to revoke API key: {str(e)}"
            )

    @staticmethod
    async def validate_api_key(api_key_value: str, db: AsyncSession) -> ApiKey:
        """
        Validate API key and return associated key object

        Checks:
            1. Key exists in database
            2. Status is 'active'
            3. Not expired (expires_at > now)

        Args:
            api_key_value: API key string (mk_live_XXXXXXXX...)
            db: Database session

        Returns:
            ApiKey object (with user relationship loaded)

        Raises:
            HTTPException 401: If key is invalid, expired, or revoked
        """
        try:
            # Find API key
            stmt = select(ApiKey).where(ApiKey.key == api_key_value)
            result = await db.execute(stmt)
            api_key = result.scalar_one_or_none()

            if not api_key:
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="Invalid API key",
                    headers={"WWW-Authenticate": "ApiKey"}
                )

            # Check if active
            if api_key.status != 'active':
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail=f"API key is {api_key.status}",
                    headers={"WWW-Authenticate": "ApiKey"}
                )

            # Check if expired
            if api_key.is_expired:
                # Auto-update status to expired
                api_key.status = 'expired'
                await db.commit()

                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail=f"API key expired on {api_key.expires_at.strftime('%Y-%m-%d')}. "
                           f"Please generate a new key from your dashboard.",
                    headers={"WWW-Authenticate": "ApiKey"}
                )

            # Update last_used_at timestamp
            api_key.last_used_at = datetime.now(timezone.utc)
            await db.commit()

            return api_key

        except HTTPException:
            raise
        except Exception as e:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"API key validation failed: {str(e)}"
            )

    @staticmethod
    async def _key_exists(api_key_value: str, db: AsyncSession) -> bool:
        """
        Check if API key already exists (internal helper)

        Args:
            api_key_value: API key string
            db: Database session

        Returns:
            True if key exists, False otherwise
        """
        stmt = select(ApiKey).where(ApiKey.key == api_key_value)
        result = await db.execute(stmt)
        return result.scalar_one_or_none() is not None

    @staticmethod
    async def get_user_active_keys_count(user_id: int, db: AsyncSession) -> int:
        """
        Get count of active API keys for a user

        Args:
            user_id: User ID
            db: Database session

        Returns:
            Count of active keys
        """
        stmt = select(ApiKey).where(
            and_(
                ApiKey.user_id == user_id,
                ApiKey.status == 'active'
            )
        )
        result = await db.execute(stmt)
        active_keys = result.scalars().all()
        return len(active_keys)
