"""
API Key Schemas
Pydantic models for API key management
"""

from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime


class ApiKeyCreate(BaseModel):
    """
    Schema for creating new API key

    Business Rules:
        - Name is required and user-friendly
        - Key is generated server-side (not provided by user)
        - Expires automatically after 30 days
    """
    name: str = Field(
        ...,
        min_length=1,
        max_length=100,
        description="User-friendly name for the API key",
        examples=["Production API Key", "Development Key", "Mobile App Key"]
    )

    model_config = {
        "json_schema_extra": {
            "examples": [{
                "name": "Production API Key"
            }]
        }
    }


class ApiKeyResponse(BaseModel):
    """
    Schema for API key response (full key shown)
    WARNING: Full key is only shown during creation!
    Store it securely - you won't see it again.
    """
    id: int
    key: str = Field(..., description="Full API key (mk_live_XXXXXXXX...)")
    name: Optional[str]
    status: str
    created_at: datetime
    expires_at: datetime
    last_used_at: Optional[datetime]

    model_config = {
        "from_attributes": True,
        "json_schema_extra": {
            "examples": [{
                "id": 123,
                "key": "mk_live_aB3cD4eF5gH6iJ7kL8mN9oP",
                "name": "Production API Key",
                "status": "active",
                "created_at": "2024-01-01T00:00:00",
                "expires_at": "2024-01-31T00:00:00",
                "last_used_at": None
            }]
        }
    }


class ApiKeyListItem(BaseModel):
    """
    Schema for API key in list view (key masked for security)
    Only shows preview: mk_live_****...xyz0
    """
    id: int
    key_preview: str = Field(..., description="Masked key preview (last 4 chars)")
    name: Optional[str]
    status: str
    created_at: datetime
    expires_at: datetime
    last_used_at: Optional[datetime]
    is_expired: bool = Field(..., description="Whether key has expired")
    days_until_expiry: int = Field(..., description="Days remaining until expiration")

    model_config = {
        "from_attributes": True,
        "json_schema_extra": {
            "examples": [{
                "id": 123,
                "key_preview": "mk_live_****...9oP",
                "name": "Production API Key",
                "status": "active",
                "created_at": "2024-01-01T00:00:00",
                "expires_at": "2024-01-31T00:00:00",
                "last_used_at": "2024-01-15T10:30:00",
                "is_expired": False,
                "days_until_expiry": 16
            }]
        }
    }


class ApiKeyRevoke(BaseModel):
    """Schema for revoking API key"""
    api_key_id: int = Field(..., description="ID of the API key to revoke")

    model_config = {
        "json_schema_extra": {
            "examples": [{
                "api_key_id": 123
            }]
        }
    }
