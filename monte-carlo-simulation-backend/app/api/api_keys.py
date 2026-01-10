"""
API Key Management Endpoints
Generate, list, and revoke API keys
"""

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List

from app.database import get_db
from app.schemas.api_key import ApiKeyCreate, ApiKeyResponse, ApiKeyListItem, ApiKeyRevoke
from app.services.api_key_service import ApiKeyService
from app.middleware.auth_middleware import get_current_user
from app.models.user import User


router = APIRouter(prefix="/api-keys", tags=["API Keys"])


@router.post(
    "/generate",
    response_model=ApiKeyResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Generate new API key",
    description="""
    Generate a new API key for the authenticated user.

    **Authentication Required:** JWT token

    **Business Rules:**
    - Maximum 10 active API keys per user
    - Keys expire after 30 days
    - **IMPORTANT:** Full key is only shown once during creation!
    - Store the key securely - you won't see it again

    **Key Format:** `mk_live_XXXXXXXXXXXXXXXXXXXXXXXX` (32 characters)

    **Returns:**
    - Complete API key details (full key shown only once)

    **Errors:**
    - 400: Maximum active keys (10) reached
    - 401: Invalid or expired JWT token
    - 500: Server error
    """
)
async def generate_api_key(
    key_data: ApiKeyCreate,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
) -> ApiKeyResponse:
    """
    Generate new API key

    WARNING: The full API key is only returned in this response.
    Make sure to save it securely. You won't be able to see it again.
    """
    return await ApiKeyService.create_api_key(current_user.id, key_data, db)


@router.get(
    "/list",
    response_model=List[ApiKeyListItem],
    summary="List user's API keys",
    description="""
    List all API keys for the authenticated user.

    **Authentication Required:** JWT token

    **Returns:**
    - List of API keys (keys are masked for security)
    - Shows: key preview (last 4 chars), name, status, expiry, usage

    **Key Preview Format:** `mk_live_****...xyz0`

    **Errors:**
    - 401: Invalid or expired JWT token
    - 500: Server error
    """
)
async def list_api_keys(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
) -> List[ApiKeyListItem]:
    """
    List all API keys for current user

    Keys are masked for security (only last 4 characters shown)
    """
    return await ApiKeyService.list_user_api_keys(current_user.id, db)


@router.post(
    "/revoke",
    summary="Revoke API key",
    description="""
    Revoke an API key (permanently disable it).

    **Authentication Required:** JWT token

    **Business Rules:**
    - Must maintain minimum 2 active API keys
    - Cannot revoke if it would leave < 2 active keys
    - Revoked keys cannot be reactivated

    **Returns:**
    - Success message

    **Errors:**
    - 400: Would leave < 2 active keys (create new key first)
    - 403: Don't have permission to revoke this key
    - 404: API key not found
    - 401: Invalid or expired JWT token
    - 500: Server error
    """
)
async def revoke_api_key(
    revoke_data: ApiKeyRevoke,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
) -> dict:
    """
    Revoke an API key

    Business Rule: Users must maintain at least 2 active API keys
    to prevent complete lockout from the API.

    If you only have 2 active keys, create a new one before revoking.
    """
    return await ApiKeyService.revoke_api_key(
        current_user.id,
        revoke_data.api_key_id,
        db
    )


@router.get(
    "/count",
    summary="Get active API keys count",
    description="""
    Get count of active API keys for the current user.

    **Authentication Required:** JWT token

    **Returns:**
    - Count of active API keys

    **Errors:**
    - 401: Invalid or expired JWT token
    """
)
async def get_active_keys_count(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
) -> dict:
    """
    Get count of active API keys

    Useful for checking if user can create more keys (max 10)
    or if they can safely revoke a key (min 2)
    """
    count = await ApiKeyService.get_user_active_keys_count(current_user.id, db)

    return {
        "active_keys_count": count,
        "max_allowed": ApiKeyService.MAX_ACTIVE_KEYS,
        "min_required": ApiKeyService.MIN_ACTIVE_KEYS,
        "can_create_more": count < ApiKeyService.MAX_ACTIVE_KEYS,
        "can_revoke": count > ApiKeyService.MIN_ACTIVE_KEYS
    }
