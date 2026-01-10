"""
User Schemas
Pydantic models for user-related API requests and responses
"""

from pydantic import BaseModel, EmailStr, Field, field_validator
from typing import Optional
from datetime import datetime


class UserRegister(BaseModel):
    """
    Schema for user registration

    Validation Rules:
        - Email must be valid format
        - Password min 8 chars, must have uppercase, lowercase, and digit
        - Full name and company are optional
    """
    email: EmailStr = Field(..., description="User email address")
    password: str = Field(..., min_length=8, max_length=100, description="User password")
    full_name: Optional[str] = Field(None, max_length=255, description="User's full name")
    company: Optional[str] = Field(None, max_length=255, description="Company name")

    @field_validator('password')
    @classmethod
    def validate_password(cls, v: str) -> str:
        """
        Password must contain at least one uppercase, lowercase, and digit

        Args:
            v: Password string

        Returns:
            Validated password

        Raises:
            ValueError: If password doesn't meet requirements
        """
        if not any(c.isupper() for c in v):
            raise ValueError('Password must contain at least one uppercase letter')
        if not any(c.islower() for c in v):
            raise ValueError('Password must contain at least one lowercase letter')
        if not any(c.isdigit() for c in v):
            raise ValueError('Password must contain at least one digit')
        return v

    model_config = {
        "json_schema_extra": {
            "examples": [{
                "email": "user@example.com",
                "password": "SecurePass123",
                "full_name": "John Doe",
                "company": "Acme Corp"
            }]
        }
    }


class UserLogin(BaseModel):
    """Schema for user login"""
    email: EmailStr = Field(..., description="User email address")
    password: str = Field(..., description="User password")

    model_config = {
        "json_schema_extra": {
            "examples": [{
                "email": "user@example.com",
                "password": "SecurePass123"
            }]
        }
    }


class UserResponse(BaseModel):
    """
    Schema for user response (no password field)
    Used when returning user data from API
    """
    id: int
    email: str
    full_name: Optional[str]
    company: Optional[str]
    status: str
    created_at: datetime
    last_login_at: Optional[datetime]

    model_config = {
        "from_attributes": True  # Pydantic v2: allows creation from ORM models
    }


class UserProfile(BaseModel):
    """Schema for updating user profile"""
    full_name: Optional[str] = Field(None, max_length=255)
    company: Optional[str] = Field(None, max_length=255)

    model_config = {
        "json_schema_extra": {
            "examples": [{
                "full_name": "Jane Smith",
                "company": "Tech Startup Inc"
            }]
        }
    }
