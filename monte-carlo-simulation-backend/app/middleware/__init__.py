"""
Middleware Package
FastAPI dependencies and middleware for authentication and request handling
"""

from app.middleware.auth_middleware import get_current_user, get_current_api_key

__all__ = [
    'get_current_user',       # JWT authentication dependency
    'get_current_api_key',    # API key authentication dependency
]
