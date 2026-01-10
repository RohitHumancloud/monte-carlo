"""
Application Configuration
Manages environment variables and application settings using Pydantic Settings
"""

from pydantic_settings import BaseSettings
from typing import List
import os


class Settings(BaseSettings):
    """
    Application settings loaded from environment variables

    Usage:
        from app.config import settings
        print(settings.DATABASE_URL)
    """

    # ============================================
    # Application Settings
    # ============================================
    APP_NAME: str = "Monte Carlo Simulation"
    APP_VERSION: str = "1.0.0"
    DEBUG: bool = False
    ENVIRONMENT: str = "development"

    # ============================================
    # Database Configuration
    # ============================================
    DATABASE_URL: str  # Required - postgresql://user:pass@host:port/db
    DATABASE_URL_ASYNC: str  # Required - postgresql+asyncpg://user:pass@host:port/db
    DB_POOL_SIZE: int = 10
    DB_MAX_OVERFLOW: int = 20

    # ============================================
    # JWT Authentication
    # ============================================
    JWT_SECRET_KEY: str  # Required - generate with: openssl rand -hex 32
    JWT_ALGORITHM: str = "HS256"
    JWT_EXPIRATION_HOURS: int = 24

    # ============================================
    # API Key Configuration
    # ============================================
    API_KEY_PREFIX: str = "mk_live_"
    API_KEY_LENGTH: int = 24  # Characters after prefix
    API_KEY_EXPIRY_DAYS: int = 30  # 30-day free trial

    # ============================================
    # CORS Settings
    # ============================================
    CORS_ORIGINS: str = "http://localhost:3000,http://localhost:5173"

    @property
    def cors_origins_list(self) -> List[str]:
        """Convert comma-separated CORS origins to list"""
        return [origin.strip() for origin in self.CORS_ORIGINS.split(",")]

    # ============================================
    # Bloomberg Integration
    # ============================================
    BLOOMBERG_ENABLED: bool = False
    BLOOMBERG_API_KEY: str = ""

    # ============================================
    # Server Configuration
    # ============================================
    HOST: str = "0.0.0.0"
    PORT: int = 8000

    # ============================================
    # Logging
    # ============================================
    LOG_LEVEL: str = "INFO"
    LOG_FORMAT: str = "json"

    # ============================================
    # Security
    # ============================================
    BCRYPT_ROUNDS: int = 12

    class Config:
        """Pydantic configuration"""
        env_file = ".env"
        env_file_encoding = "utf-8"
        case_sensitive = True


# Global settings instance
settings = Settings()


# Validation on import
def validate_settings():
    """Validate critical settings on application startup"""

    # Check JWT secret key length
    if len(settings.JWT_SECRET_KEY) < 32:
        raise ValueError(
            "JWT_SECRET_KEY must be at least 32 characters. "
            "Generate one with: openssl rand -hex 32"
        )

    # Check database URLs are provided
    if not settings.DATABASE_URL or not settings.DATABASE_URL_ASYNC:
        raise ValueError(
            "DATABASE_URL and DATABASE_URL_ASYNC must be set in .env file"
        )

    # Warn if using default values in production
    if settings.ENVIRONMENT == "production":
        if settings.DEBUG:
            print("WARNING: DEBUG=True in production environment")

        if "your_password_here" in settings.DATABASE_URL:
            raise ValueError("Change default database password in production!")

        if "your_super_secret" in settings.JWT_SECRET_KEY:
            raise ValueError("Change default JWT secret key in production!")


# Run validation if not in test environment
if os.getenv("TESTING") != "true":
    try:
        validate_settings()
    except Exception as e:
        print(f"Configuration Error: {e}")
        print("Please check your .env file and ensure all required variables are set.")
        # Don't exit here - let FastAPI startup handle it
