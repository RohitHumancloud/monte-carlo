"""
Authentication Middleware
FastAPI dependencies for JWT and API key authentication
"""

from fastapi import Depends, HTTPException, status, Header
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.ext.asyncio import AsyncSession
from jose import JWTError
from typing import Optional

from app.database import get_db
from app.utils.security import verify_access_token
from app.services.auth_service import AuthService
from app.services.api_key_service import ApiKeyService
from app.models.user import User
from app.models.api_key import ApiKey


# HTTP Bearer scheme for JWT authentication
security = HTTPBearer()


async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: AsyncSession = Depends(get_db)
) -> User:
    """
    FastAPI dependency to get current authenticated user from JWT token

    Usage:
        @app.get("/protected")
        async def protected_route(current_user: User = Depends(get_current_user)):
            return {"user_id": current_user.id, "email": current_user.email}

    Args:
        credentials: HTTP Authorization header with Bearer token
        db: Database session

    Returns:
        User object of authenticated user

    Raises:
        HTTPException 401: If token is invalid, expired, or user not found
        HTTPException 403: If user account is not active
    """
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )

    try:
        # Extract token from credentials
        token = credentials.credentials

        # Verify and decode JWT token
        try:
            payload = verify_access_token(token)
        except JWTError:
            raise credentials_exception

        # Extract user_id from token payload
        user_id: int = payload.get("user_id")
        email: str = payload.get("email")

        if user_id is None or email is None:
            raise credentials_exception

        # Retrieve user from database
        user = await AuthService.get_user_by_id(user_id, db)

        # Check if user account is active
        if user.status != 'active':
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"User account is {user.status}. Please contact support."
            )

        return user

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Authentication failed: {str(e)}"
        )


async def get_current_api_key(
    x_api_key: Optional[str] = Header(None, alias="X-API-Key"),
    db: AsyncSession = Depends(get_db)
) -> ApiKey:
    """
    FastAPI dependency to validate API key from X-API-Key header

    Usage:
        @app.post("/api/v1/simulate")
        async def simulate(
            request: SimulationRequest,
            api_key: ApiKey = Depends(get_current_api_key)
        ):
            # api_key.user_id can be used to identify the user
            # api_key.last_used_at is automatically updated
            return {"user_id": api_key.user_id}

    Args:
        x_api_key: API key from X-API-Key header
        db: Database session

    Returns:
        ApiKey object (with user relationship loaded)

    Raises:
        HTTPException 401: If API key is missing, invalid, expired, or revoked
    """
    if not x_api_key:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="X-API-Key header is required for this endpoint",
            headers={"WWW-Authenticate": "ApiKey"}
        )

    # Validate API key (checks existence, status, expiry)
    # Also updates last_used_at timestamp
    api_key = await ApiKeyService.validate_api_key(x_api_key, db)

    return api_key


async def get_optional_current_user(
    credentials: Optional[HTTPAuthorizationCredentials] = Depends(HTTPBearer(auto_error=False)),
    db: AsyncSession = Depends(get_db)
) -> Optional[User]:
    """
    Optional authentication dependency

    Returns User if valid JWT token is provided, None otherwise
    Useful for endpoints that have different behavior for authenticated vs anonymous users

    Args:
        credentials: Optional HTTP Authorization header
        db: Database session

    Returns:
        User object if authenticated, None otherwise
    """
    if not credentials:
        return None

    try:
        # Verify token
        payload = verify_access_token(credentials.credentials)
        user_id = payload.get("user_id")

        if not user_id:
            return None

        # Get user
        user = await AuthService.get_user_by_id(user_id, db)

        if user.status != 'active':
            return None

        return user

    except:
        return None
