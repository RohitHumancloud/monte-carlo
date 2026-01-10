"""
Initial database schema

Revision ID: 001
Revises: None
Create Date: 2026-01-01 00:00:00.000000

Creates tables:
- users: User accounts with authentication
- api_keys: API key management with expiry
- api_call_logs: API usage tracking for analytics and billing

Indexes:
- User email (unique)
- API key (unique)
- API key user_id + status (composite)
- API call log user_id
- API call log created_at
- API call log status_code

Constraints:
- User status: CHECK (active, inactive, suspended)
- API key status: CHECK (active, revoked, expired)
"""

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# Revision identifiers
revision = '001'
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    """
    Create initial database schema

    Tables created:
    1. users - User accounts
    2. api_keys - API key management
    3. api_call_logs - API usage tracking
    """

    # ============================================================================
    # CREATE TABLE: users
    # ============================================================================
    op.create_table(
        'users',
        sa.Column('id', sa.BigInteger(), autoincrement=True, nullable=False),
        sa.Column('email', sa.String(length=255), nullable=False),
        sa.Column('password_hash', sa.String(length=255), nullable=False),
        sa.Column('full_name', sa.String(length=255), nullable=True),
        sa.Column('company', sa.String(length=255), nullable=True),
        sa.Column('status', sa.String(length=50), nullable=False, server_default='active'),
        sa.Column('created_at', sa.TIMESTAMP(timezone=True), nullable=False, server_default=sa.text('CURRENT_TIMESTAMP')),
        sa.Column('updated_at', sa.TIMESTAMP(timezone=True), nullable=False, server_default=sa.text('CURRENT_TIMESTAMP')),

        # Primary Key
        sa.PrimaryKeyConstraint('id', name='pk_users'),

        # Unique Constraints
        sa.UniqueConstraint('email', name='uq_users_email'),

        # Check Constraints
        sa.CheckConstraint(
            "status IN ('active', 'inactive', 'suspended')",
            name='ck_users_status'
        )
    )

    # Indexes for users table
    op.create_index('ix_users_email', 'users', ['email'], unique=True)
    op.create_index('ix_users_status', 'users', ['status'], unique=False)
    op.create_index('ix_users_created_at', 'users', ['created_at'], unique=False)


    # ============================================================================
    # CREATE TABLE: api_keys
    # ============================================================================
    op.create_table(
        'api_keys',
        sa.Column('id', sa.BigInteger(), autoincrement=True, nullable=False),
        sa.Column('user_id', sa.BigInteger(), nullable=False),
        sa.Column('key', sa.String(length=255), nullable=False),
        sa.Column('name', sa.String(length=100), nullable=True),
        sa.Column('status', sa.String(length=50), nullable=False, server_default='active'),
        sa.Column('expires_at', sa.TIMESTAMP(timezone=True), nullable=False),
        sa.Column('last_used_at', sa.TIMESTAMP(timezone=True), nullable=True),
        sa.Column('created_at', sa.TIMESTAMP(timezone=True), nullable=False, server_default=sa.text('CURRENT_TIMESTAMP')),
        sa.Column('updated_at', sa.TIMESTAMP(timezone=True), nullable=False, server_default=sa.text('CURRENT_TIMESTAMP')),

        # Primary Key
        sa.PrimaryKeyConstraint('id', name='pk_api_keys'),

        # Foreign Keys
        sa.ForeignKeyConstraint(
            ['user_id'],
            ['users.id'],
            name='fk_api_keys_user_id',
            ondelete='CASCADE'  # Delete API keys when user is deleted
        ),

        # Unique Constraints
        sa.UniqueConstraint('key', name='uq_api_keys_key'),

        # Check Constraints
        sa.CheckConstraint(
            "status IN ('active', 'revoked', 'expired')",
            name='ck_api_keys_status'
        )
    )

    # Indexes for api_keys table
    op.create_index('ix_api_keys_key', 'api_keys', ['key'], unique=True)
    op.create_index('ix_api_keys_user_id', 'api_keys', ['user_id'], unique=False)
    op.create_index('ix_api_keys_status', 'api_keys', ['status'], unique=False)
    op.create_index('ix_api_keys_expires_at', 'api_keys', ['expires_at'], unique=False)

    # Composite index for common query: active keys by user
    op.create_index(
        'ix_api_keys_user_status',
        'api_keys',
        ['user_id', 'status'],
        unique=False
    )


    # ============================================================================
    # CREATE TABLE: api_call_logs
    # ============================================================================
    op.create_table(
        'api_call_logs',
        sa.Column('id', sa.BigInteger(), autoincrement=True, nullable=False),
        sa.Column('user_id', sa.BigInteger(), nullable=False),
        sa.Column('api_key', sa.String(length=255), nullable=False),
        sa.Column('endpoint', sa.String(length=255), nullable=False),
        sa.Column('method', sa.String(length=10), nullable=False),
        sa.Column('status_code', sa.Integer(), nullable=False),
        sa.Column('execution_time_ms', sa.Float(), nullable=True),
        sa.Column('error_message', sa.Text(), nullable=True),
        sa.Column('created_at', sa.TIMESTAMP(timezone=True), nullable=False, server_default=sa.text('CURRENT_TIMESTAMP')),

        # Primary Key
        sa.PrimaryKeyConstraint('id', name='pk_api_call_logs'),

        # Foreign Keys
        sa.ForeignKeyConstraint(
            ['user_id'],
            ['users.id'],
            name='fk_api_call_logs_user_id',
            ondelete='CASCADE'  # Delete logs when user is deleted
        )
    )

    # Indexes for api_call_logs table
    op.create_index('ix_api_call_logs_user_id', 'api_call_logs', ['user_id'], unique=False)
    op.create_index('ix_api_call_logs_created_at', 'api_call_logs', ['created_at'], unique=False)
    op.create_index('ix_api_call_logs_status_code', 'api_call_logs', ['status_code'], unique=False)
    op.create_index('ix_api_call_logs_endpoint', 'api_call_logs', ['endpoint'], unique=False)

    # Composite index for analytics queries: user + date range
    op.create_index(
        'ix_api_call_logs_user_created',
        'api_call_logs',
        ['user_id', 'created_at'],
        unique=False
    )


def downgrade() -> None:
    """
    Rollback initial schema

    Drops all tables in reverse order to handle foreign key dependencies
    """
    # Drop tables in reverse order (child tables first)
    op.drop_table('api_call_logs')
    op.drop_table('api_keys')
    op.drop_table('users')
