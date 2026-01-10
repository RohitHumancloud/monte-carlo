"""
Pydantic Schemas Package
Request/response validation models for API endpoints
"""

from app.schemas.user import UserRegister, UserLogin, UserResponse, UserProfile
from app.schemas.auth import Token, TokenData
from app.schemas.api_key import ApiKeyCreate, ApiKeyResponse, ApiKeyListItem, ApiKeyRevoke
from app.schemas.simulation import (
    Asset,
    Portfolio,
    SimulationParameters,
    SimulationRequest,
    SimulationResponse
)

__all__ = [
    # User schemas
    'UserRegister',
    'UserLogin',
    'UserResponse',
    'UserProfile',
    # Auth schemas
    'Token',
    'TokenData',
    # API Key schemas
    'ApiKeyCreate',
    'ApiKeyResponse',
    'ApiKeyListItem',
    'ApiKeyRevoke',
    # Simulation schemas
    'Asset',
    'Portfolio',
    'SimulationParameters',
    'SimulationRequest',
    'SimulationResponse',
]
