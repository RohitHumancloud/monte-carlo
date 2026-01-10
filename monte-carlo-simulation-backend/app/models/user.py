"""
User Model
Represents registered users in the system
"""

from sqlalchemy import Column, BigInteger, String, TIMESTAMP, CheckConstraint
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from app.database import Base


class User(Base):
    """
    User model for authentication and account management

    Relationships:
        - api_keys: One-to-many relationship with ApiKey
        - api_call_logs: One-to-many relationship with ApiCallLog

    Business Rules:
        - Email must be unique
        - Password is stored as bcrypt hash (never plaintext)
        - Status can be: 'active', 'inactive', 'suspended'
        - Users can have multiple API keys (max 10 active)
    """

    __tablename__ = "users"

    # ============================================
    # Primary Key
    # ============================================
    id = Column(BigInteger, primary_key=True, autoincrement=True)

    # ============================================
    # Authentication Fields
    # ============================================
    email = Column(
        String(255),
        unique=True,
        nullable=False,
        index=True,
        comment="User email address (unique identifier)"
    )

    password_hash = Column(
        String(255),
        nullable=False,
        comment="Bcrypt hashed password (12 rounds)"
    )

    # ============================================
    # Profile Fields
    # ============================================
    full_name = Column(
        String(255),
        nullable=True,
        comment="User's full name"
    )

    company = Column(
        String(255),
        nullable=True,
        comment="Company or organization name"
    )

    # ============================================
    # Status & Metadata
    # ============================================
    status = Column(
        String(50),
        nullable=False,
        default='active',
        server_default='active',
        index=True,
        comment="User status: active | inactive | suspended"
    )

    created_at = Column(
        TIMESTAMP,
        nullable=False,
        server_default=func.now(),
        comment="Account creation timestamp"
    )

    last_login_at = Column(
        TIMESTAMP,
        nullable=True,
        comment="Last successful login timestamp"
    )

    # ============================================
    # Relationships
    # ============================================
    api_keys = relationship(
        "ApiKey",
        back_populates="user",
        cascade="all, delete-orphan",
        lazy="selectin"
    )

    api_call_logs = relationship(
        "ApiCallLog",
        back_populates="user",
        cascade="all, delete-orphan",
        lazy="selectin"
    )

    # ============================================
    # Constraints
    # ============================================
    __table_args__ = (
        CheckConstraint(
            "status IN ('active', 'inactive', 'suspended')",
            name='users_status_check'
        ),
    )

    def __repr__(self):
        return f"<User(id={self.id}, email={self.email}, status={self.status})>"

    @property
    def is_active(self) -> bool:
        """Check if user account is active"""
        return self.status == 'active'

    @property
    def active_api_keys_count(self) -> int:
        """Count of active API keys"""
        return len([key for key in self.api_keys if key.status == 'active'])
