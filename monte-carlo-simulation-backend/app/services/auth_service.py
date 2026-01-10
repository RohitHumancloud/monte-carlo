"""
Authentication Service
Handles user registration, login, and JWT token management
"""

from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from datetime import datetime, timedelta, timezone
from fastapi import HTTPException, status
from app.models.user import User
from app.schemas.user import UserRegister, UserLogin, UserResponse
from app.schemas.auth import Token, TokenData
from app.utils.security import hash_password, verify_password, create_access_token


class AuthService:
    """
    Authentication service for user registration and login

    Methods:
        - register_user: Create new user account
        - login_user: Authenticate user and issue JWT token
        - get_user_by_email: Retrieve user by email
        - get_user_by_id: Retrieve user by ID
    """

    @staticmethod
    async def register_user(user_data: UserRegister, db: AsyncSession) -> UserResponse:
        """
        Register a new user

        Steps:
            1. Check if email already exists
            2. Hash password using bcrypt (12 rounds)
            3. Create user record in database
            4. Return user data (without password)

        Args:
            user_data: User registration data (email, password, full_name, company)
            db: Database session

        Returns:
            UserResponse with user details (no password)

        Raises:
            HTTPException 400: If email already exists
            HTTPException 500: If database error occurs
        """
        try:
            # Check if email already exists
            stmt = select(User).where(User.email == user_data.email)
            result = await db.execute(stmt)
            existing_user = result.scalar_one_or_none()

            if existing_user:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail=f"Email {user_data.email} is already registered"
                )

            # Hash password
            password_hash = hash_password(user_data.password)

            # Create new user
            new_user = User(
                email=user_data.email,
                password_hash=password_hash,
                full_name=user_data.full_name,
                company=user_data.company,
                status='active',
                created_at=datetime.now(timezone.utc)
            )

            db.add(new_user)
            await db.commit()
            await db.refresh(new_user)

            # Return user data (Pydantic will exclude password)
            return UserResponse.model_validate(new_user)

        except HTTPException:
            raise
        except Exception as e:
            await db.rollback()
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Failed to create user: {str(e)}"
            )

    @staticmethod
    async def login_user(credentials: UserLogin, db: AsyncSession) -> Token:
        """
        Authenticate user and issue JWT token

        Steps:
            1. Find user by email
            2. Verify password
            3. Update last_login_at timestamp
            4. Generate JWT token (24-hour expiry)

        Args:
            credentials: User login credentials (email, password)
            db: Database session

        Returns:
            Token with access_token and token_type

        Raises:
            HTTPException 401: If credentials are invalid
            HTTPException 500: If database error occurs
        """
        try:
            # Find user by email
            stmt = select(User).where(User.email == credentials.email)
            result = await db.execute(stmt)
            user = result.scalar_one_or_none()

            # Check if user exists
            if not user:
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="Invalid email or password",
                    headers={"WWW-Authenticate": "Bearer"}
                )

            # Verify password
            if not verify_password(credentials.password, user.password_hash):
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="Invalid email or password",
                    headers={"WWW-Authenticate": "Bearer"}
                )

            # Check if user is active
            if user.status != 'active':
                raise HTTPException(
                    status_code=status.HTTP_403_FORBIDDEN,
                    detail=f"User account is {user.status}. Please contact support."
                )

            # Update last login timestamp
            user.last_login_at = datetime.now(timezone.utc)
            await db.commit()

            # Create JWT token
            token_data = {
                "user_id": user.id,
                "email": user.email
            }
            access_token = create_access_token(token_data)

            return Token(access_token=access_token, token_type="bearer")

        except HTTPException:
            raise
        except Exception as e:
            await db.rollback()
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Login failed: {str(e)}"
            )

    @staticmethod
    async def get_user_by_email(email: str, db: AsyncSession) -> User:
        """
        Retrieve user by email address

        Args:
            email: User email address
            db: Database session

        Returns:
            User object

        Raises:
            HTTPException 404: If user not found
        """
        stmt = select(User).where(User.email == email)
        result = await db.execute(stmt)
        user = result.scalar_one_or_none()

        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"User with email {email} not found"
            )

        return user

    @staticmethod
    async def get_user_by_id(user_id: int, db: AsyncSession) -> User:
        """
        Retrieve user by ID

        Args:
            user_id: User ID
            db: Database session

        Returns:
            User object

        Raises:
            HTTPException 404: If user not found
        """
        stmt = select(User).where(User.id == user_id)
        result = await db.execute(stmt)
        user = result.scalar_one_or_none()

        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"User with ID {user_id} not found"
            )

        return user

    @staticmethod
    async def update_user_profile(
        user_id: int,
        profile_data: dict,
        db: AsyncSession
    ) -> UserResponse:
        """
        Update user profile (full_name, company)

        Args:
            user_id: User ID
            profile_data: Dictionary with full_name and/or company
            db: Database session

        Returns:
            Updated UserResponse

        Raises:
            HTTPException 404: If user not found
        """
        user = await AuthService.get_user_by_id(user_id, db)

        # Update allowed fields
        if 'full_name' in profile_data:
            user.full_name = profile_data['full_name']
        if 'company' in profile_data:
            user.company = profile_data['company']

        await db.commit()
        await db.refresh(user)

        return UserResponse.model_validate(user)
