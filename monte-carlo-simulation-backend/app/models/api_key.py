"""
API Key Model
Represents API keys for programmatic access to simulation endpoints
"""

from sqlalchemy import Column, BigInteger, String, TIMESTAMP, ForeignKey, CheckConstraint
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from app.database import Base
from datetime import datetime, timezone


class ApiKey(Base):
    """
    API Key model for programmatic API access

    Format: mk_live_XXXXXXXXXXXXXXXXXXXXXXXX (32 chars total)

    Relationships:
        - user: Many-to-one relationship with User

    Business Rules:
        - Each user can have max 10 active API keys
        - Keys expire after 30 days (configurable)
        - Users must maintain minimum 2 active keys
        - Status can be: 'active', 'expired', 'revoked'
        - Key is shown only once during creation
    """

    __tablename__ = "api_keys"

    # ============================================
    # Primary Key
    # ============================================
    id = Column(BigInteger, primary_key=True, autoincrement=True)

    # ============================================
    # Foreign Key
    # ============================================
    user_id = Column(
        BigInteger,
        ForeignKey('users.id', ondelete='CASCADE'),
        nullable=False,
        index=True,
        comment="User who owns this API key"
    )

    # ============================================
    # API Key Fields
    # ============================================
    key = Column(
        String(255),
        unique=True,
        nullable=False,
        index=True,
        comment="API key value (mk_live_XXXXXXXX...)"
    )

    name = Column(
        String(100),
        nullable=True,
        comment="User-friendly name for the key"
    )

    # ============================================
    # Status & Timestamps
    # ============================================
    status = Column(
        String(50),
        nullable=False,
        default='active',
        server_default='active',
        index=True,
        comment="Key status: active | expired | revoked"
    )

    created_at = Column(
        TIMESTAMP,
        nullable=False,
        server_default=func.now(),
        comment="Key creation timestamp"
    )

    expires_at = Column(
        TIMESTAMP,
        nullable=False,
        index=True,
        comment="Expiration timestamp (created_at + 30 days)"
    )

    last_used_at = Column(
        TIMESTAMP,
        nullable=True,
        comment="Last time this key was used"
    )

    # ============================================
    # Relationships
    # ============================================
    user = relationship("User", back_populates="api_keys")

    # ============================================
    # Constraints
    # ============================================
    __table_args__ = (
        CheckConstraint(
            "status IN ('active', 'expired', 'revoked')",
            name='api_keys_status_check'
        ),
    )

    def __repr__(self):
        return f"<ApiKey(id={self.id}, key={self.key[:15]}..., status={self.status})>"

    @property
    def is_expired(self) -> bool:
        """Check if API key has expired based on expires_at timestamp"""
        if not self.expires_at:
            return False
        return datetime.now(timezone.utc) > self.expires_at.replace(tzinfo=timezone.utc)

    @property
    def is_valid(self) -> bool:
        """Check if API key is valid (active status and not expired)"""
        return self.status == 'active' and not self.is_expired

    @property
    def key_preview(self) -> str:
        """
        Return masked key for display purposes
        Example: mk_live_****...xyz0
        """
        if len(self.key) <= 12:
            return self.key
        return f"{self.key[:8]}****...{self.key[-4:]}"

    @property
    def days_until_expiry(self) -> int:
        """Calculate days remaining until expiration"""
        if not self.expires_at:
            return -1
        delta = self.expires_at.replace(tzinfo=timezone.utc) - datetime.now(timezone.utc)
        return max(0, delta.days)
