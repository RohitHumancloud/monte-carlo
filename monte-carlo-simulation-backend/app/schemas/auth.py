"""
Authentication Schemas
Pydantic models for JWT tokens and authentication responses
"""

from pydantic import BaseModel, Field


class Token(BaseModel):
    """
    JWT token response schema
    Returned after successful login
    """
    access_token: str = Field(..., description="JWT access token")
    token_type: str = Field(default="bearer", description="Token type (always 'bearer')")

    model_config = {
        "json_schema_extra": {
            "examples": [{
                "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
                "token_type": "bearer"
            }]
        }
    }


class TokenData(BaseModel):
    """
    JWT token payload schema
    Contains decoded token data
    """
    user_id: int = Field(..., description="User ID from token")
    email: str = Field(..., description="User email from token")

    model_config = {
        "json_schema_extra": {
            "examples": [{
                "user_id": 123,
                "email": "user@example.com"
            }]
        }
    }
