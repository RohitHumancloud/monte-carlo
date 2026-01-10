"""
Authentication API Endpoints
User registration and login
"""

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.database import get_db
from app.schemas.user import UserRegister, UserLogin, UserResponse
from app.schemas.auth import Token
from app.services.auth_service import AuthService


router = APIRouter(prefix="/auth", tags=["Authentication"])


@router.post(
    "/register",
    response_model=UserResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Register new user",
    description="""
    Create a new user account.

    **Password Requirements:**
    - Minimum 8 characters
    - At least one uppercase letter
    - At least one lowercase letter
    - At least one digit

    **Returns:**
    - User details (without password)

    **Errors:**
    - 400: Email already registered or password requirements not met
    - 500: Server error
    """
)
async def register(
    user_data: UserRegister,
    db: AsyncSession = Depends(get_db)
) -> UserResponse:
    """
    Register a new user account

    Args:
        user_data: User registration data (email, password, full_name, company)
        db: Database session

    Returns:
        UserResponse with user details (no password)
    """
    return await AuthService.register_user(user_data, db)


@router.post(
    "/login",
    response_model=Token,
    summary="User login",
    description="""
    Authenticate user and receive JWT access token.

    **Token Details:**
    - Type: Bearer token
    - Expiry: 24 hours
    - Usage: Add to Authorization header: `Bearer <token>`

    **Returns:**
    - JWT access token

    **Errors:**
    - 401: Invalid email or password
    - 403: User account is inactive or suspended
    - 500: Server error
    """
)
async def login(
    credentials: UserLogin,
    db: AsyncSession = Depends(get_db)
) -> Token:
    """
    Authenticate user and issue JWT token

    Args:
        credentials: User login credentials (email, password)
        db: Database session

    Returns:
        Token with access_token and token_type
    """
    return await AuthService.login_user(credentials, db)


@router.get(
    "/me",
    response_model=UserResponse,
    summary="Get current user",
    description="""
    Get details of the currently authenticated user.

    **Authentication Required:**
    - JWT token in Authorization header

    **Returns:**
    - Current user details

    **Errors:**
    - 401: Invalid or expired token
    - 404: User not found
    """
)
async def get_current_user_info(
    db: AsyncSession = Depends(get_db),
    current_user = Depends(AuthService.get_user_by_id)
) -> UserResponse:
    """
    Get current authenticated user details

    This endpoint can be used to verify token validity
    and retrieve user information
    """
    return UserResponse.model_validate(current_user)
