-- ============================================================================
-- GBA System - PostgreSQL Database Schema
-- Goal-Based Advisory Wealth Management Platform
-- ============================================================================
-- Version: 1.0 Final
-- Date: December 24, 2025
-- Database: PostgreSQL 16+
-- ============================================================================

-- ============================================================================
-- 1. AUTHENTICATION & AUTHORIZATION MODULE
-- ============================================================================

-- Drop tables if exist (reverse order of dependencies)
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS relationship_managers CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS roles CASCADE;

-- Roles table
CREATE TABLE roles (
    id BIGSERIAL PRIMARY KEY,
    role_code VARCHAR(20) UNIQUE NOT NULL,
    role_name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE roles IS 'System role definitions for RBAC';
COMMENT ON COLUMN roles.role_code IS 'Unique role identifier (SUPER_ADMIN, RM, CUSTOMER)';

-- Users table (ALL system users - common fields for Super Admin, RM, Customer)
-- Personal info is stored here, role-specific data goes in respective tables
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255),
    role_id BIGINT NOT NULL REFERENCES roles(id),

    -- Personal Information (common for all roles)
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20),
    date_of_birth DATE,
    gender VARCHAR(20),
    marital_status VARCHAR(20),

    -- Address Information (common for all roles)
    address_line1 VARCHAR(255),
    address_line2 VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100) DEFAULT 'India',
    pincode VARCHAR(20),

    -- Account Status
    status VARCHAR(20) DEFAULT 'PENDING',
    is_active BOOLEAN DEFAULT FALSE,
    is_email_verified BOOLEAN DEFAULT FALSE,

    -- Invite Flow Fields
    invite_token VARCHAR(255),
    invite_token_expires_at TIMESTAMP,
    invited_at TIMESTAMP,
    invited_by BIGINT REFERENCES users(id),

    -- Password Reset Fields
    password_reset_token VARCHAR(255),
    password_reset_expires_at TIMESTAMP,

    -- Tracking
    last_login_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by BIGINT REFERENCES users(id),
    updated_by BIGINT REFERENCES users(id),

    -- Constraints
    CONSTRAINT chk_user_status CHECK (status IN ('PENDING', 'ACTIVE', 'INACTIVE')),
    CONSTRAINT chk_user_gender CHECK (gender IS NULL OR gender IN ('MALE', 'FEMALE', 'OTHER', 'PREFER_NOT_TO_SAY')),
    CONSTRAINT chk_user_marital_status CHECK (marital_status IS NULL OR marital_status IN ('SINGLE', 'MARRIED', 'DIVORCED', 'WIDOWED', 'SEPARATED'))
);

COMMENT ON TABLE users IS 'All system users - common personal info for Super Admin, RM, and Customer';
COMMENT ON COLUMN users.password_hash IS 'BCrypt hashed password - NULL until user sets password via invite';
COMMENT ON COLUMN users.role_id IS 'Foreign key to roles table (SUPER_ADMIN, RM, CUSTOMER)';
COMMENT ON COLUMN users.status IS 'User status: PENDING (invited), ACTIVE (password set), INACTIVE (deactivated)';
COMMENT ON COLUMN users.invite_token IS 'JWT token for invite/password setup';
COMMENT ON COLUMN users.invited_by IS 'User ID who sent the invite';

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role_id ON users(role_id);
CREATE INDEX idx_users_active ON users(is_active);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_users_invite_token ON users(invite_token);

-- Relationship Managers table (RM-specific profile data)
CREATE TABLE relationship_managers (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    employee_id VARCHAR(50) UNIQUE NOT NULL,
    branch_code VARCHAR(20),
    department VARCHAR(100),
    ic_license_number VARCHAR(50),
    ic_license_expiry DATE,
    supervisor_id BIGINT REFERENCES relationship_managers(id),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE relationship_managers IS 'RM-specific profile data';
COMMENT ON COLUMN relationship_managers.ic_license_number IS 'Investment Consultant license number';
COMMENT ON COLUMN relationship_managers.supervisor_id IS 'Hierarchical reporting structure';

CREATE INDEX idx_rm_user_id ON relationship_managers(user_id);
CREATE INDEX idx_rm_employee_id ON relationship_managers(employee_id);
CREATE INDEX idx_rm_active ON relationship_managers(is_active);

-- Customers table (Customer-specific profile data ONLY)
-- Personal info (name, email, phone, address, etc.) is in users table
-- This table only stores customer-specific attributes
CREATE TABLE customers (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    customer_code VARCHAR(50) UNIQUE NOT NULL,
    rm_id BIGINT NOT NULL REFERENCES relationship_managers(id),

    -- Customer-specific fields (not in users table)
    number_of_dependents INT DEFAULT 0,
    occupation VARCHAR(100),
    employment_type VARCHAR(30),

    -- Status
    is_active BOOLEAN DEFAULT TRUE,

    -- Audit (created_by is auto-set by backend from RM's user_id)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Constraints
    CONSTRAINT chk_employment_type CHECK (
        employment_type IS NULL OR
        employment_type IN ('SALARIED', 'SELF_EMPLOYED', 'BUSINESS', 'RETIRED', 'STUDENT', 'HOMEMAKER', 'UNEMPLOYED')
    ),
    CONSTRAINT chk_dependents CHECK (number_of_dependents >= 0)
);

COMMENT ON TABLE customers IS 'Customer-specific profile data - personal info is in users table';
COMMENT ON COLUMN customers.user_id IS 'FK to users table - contains all personal info (name, email, address, etc.)';
COMMENT ON COLUMN customers.rm_id IS 'Assigned Relationship Manager (required - who created/manages this customer)';
COMMENT ON COLUMN customers.number_of_dependents IS 'Number of financial dependents';
COMMENT ON COLUMN customers.occupation IS 'Customer occupation/job title';
COMMENT ON COLUMN customers.employment_type IS 'Employment status: SALARIED, SELF_EMPLOYED, BUSINESS, etc.';

CREATE INDEX idx_customers_user_id ON customers(user_id);
CREATE INDEX idx_customers_rm_id ON customers(rm_id);
CREATE INDEX idx_customers_customer_code ON customers(customer_code);
CREATE INDEX idx_customers_active ON customers(is_active);

-- ============================================================================
-- 2. QUESTIONNAIRE CONFIGURATION MODULE
-- ============================================================================

DROP TABLE IF EXISTS question_dependencies CASCADE;
DROP TABLE IF EXISTS question_options CASCADE;
DROP TABLE IF EXISTS questions CASCADE;
DROP TABLE IF EXISTS questionnaire_types CASCADE;

-- Questionnaire types
CREATE TABLE questionnaire_types (
    id BIGSERIAL PRIMARY KEY,
    type_code VARCHAR(50) UNIQUE NOT NULL,
    type_name VARCHAR(100) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE questionnaire_types IS 'Types of questionnaires (RISK_PROFILE, SUITABILITY)';

-- Questions (Risk Profile and Suitability Assessment)
CREATE TABLE questions (
    id BIGSERIAL PRIMARY KEY,
    questionnaire_type_id BIGINT NOT NULL REFERENCES questionnaire_types(id),
    question_code VARCHAR(50) UNIQUE NOT NULL,
    question_text TEXT NOT NULL,
    description TEXT,
    notes TEXT,
    question_type VARCHAR(30) NOT NULL,
    scoring_method VARCHAR(20) DEFAULT 'SUM',
    max_cap_points INT DEFAULT 8,
    weight NUMERIC(3,2) DEFAULT 1.00,
    is_required BOOLEAN DEFAULT TRUE,
    display_order INT NOT NULL,
    placeholder VARCHAR(255),
    validation_rules JSONB,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_weight_range CHECK (weight >= 0.5 AND weight <= 2.5),
    CONSTRAINT chk_max_cap_positive CHECK (max_cap_points > 0),
    CONSTRAINT chk_question_type CHECK (
        question_type IN ('SINGLE_SELECT', 'MULTI_SELECT', 'TEXT', 'NUMBER', 'DATE', 'BOOLEAN')
    ),
    CONSTRAINT chk_scoring_method CHECK (
        scoring_method IN ('SUM', 'MAX', 'AVERAGE')
    )
);

COMMENT ON TABLE questions IS 'Question library for Risk Profile and Suitability assessments';
COMMENT ON COLUMN questions.description IS 'Description shown to all users';
COMMENT ON COLUMN questions.notes IS 'Internal notes for admin/RM reference';
COMMENT ON COLUMN questions.weight IS 'Multiplier for scoring (0.5 to 2.5), default 1.0';
COMMENT ON COLUMN questions.max_cap_points IS 'Maximum points for multi-select questions';
COMMENT ON COLUMN questions.scoring_method IS 'How to calculate score: SUM, MAX, or AVERAGE';
COMMENT ON COLUMN questions.placeholder IS 'Hint text for TEXT/NUMBER/DATE input fields';
COMMENT ON COLUMN questions.validation_rules IS 'JSON validation constraints (min, max, pattern, etc.)';

CREATE INDEX idx_questions_type_id ON questions(questionnaire_type_id);
CREATE INDEX idx_questions_code ON questions(question_code);
CREATE INDEX idx_questions_active ON questions(is_active);
CREATE INDEX idx_questions_order ON questions(display_order);

-- Question options
CREATE TABLE question_options (
    id BIGSERIAL PRIMARY KEY,
    question_id BIGINT NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    option_text TEXT NOT NULL,
    option_value VARCHAR(255),
    points INT DEFAULT 0,
    display_order INT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE question_options IS 'Answer options for questions';
COMMENT ON COLUMN question_options.points IS 'Points awarded if this option is selected';

CREATE INDEX idx_options_question_id ON question_options(question_id);
CREATE INDEX idx_options_order ON question_options(display_order);

-- Question dependencies (conditional logic)
CREATE TABLE question_dependencies (
    id BIGSERIAL PRIMARY KEY,
    question_id BIGINT NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    depends_on_question_id BIGINT NOT NULL REFERENCES questions(id),
    required_option_id BIGINT NOT NULL REFERENCES question_options(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE question_dependencies IS 'Conditional question logic - show question if dependency is satisfied';
COMMENT ON COLUMN question_dependencies.question_id IS 'Question that depends on another';
COMMENT ON COLUMN question_dependencies.depends_on_question_id IS 'The question this depends on';
COMMENT ON COLUMN question_dependencies.required_option_id IS 'The option that must be selected to show this question';

CREATE INDEX idx_dependencies_question_id ON question_dependencies(question_id);
CREATE INDEX idx_dependencies_depends_on ON question_dependencies(depends_on_question_id);

-- ============================================================================
-- 3. RISK & SUITABILITY MODULE
-- ============================================================================

DROP TABLE IF EXISTS customer_suitability_answers CASCADE;
DROP TABLE IF EXISTS customer_suitability_assessments CASCADE;
DROP TABLE IF EXISTS customer_risk_answers CASCADE;
DROP TABLE IF EXISTS customer_risk_profiles CASCADE;
DROP TABLE IF EXISTS risk_score_categories CASCADE;

-- Risk score categories
CREATE TABLE risk_score_categories (
    id BIGSERIAL PRIMARY KEY,
    category_code VARCHAR(50) UNIQUE NOT NULL,
    category_name VARCHAR(100) NOT NULL,
    min_score INT NOT NULL,
    max_score INT NOT NULL,
    description TEXT,
    risk_level VARCHAR(20) NOT NULL,
    time_horizon_years INT,
    color_code VARCHAR(7),
    icon_name VARCHAR(50),
    display_order INT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_score_range CHECK (min_score <= max_score),
    CONSTRAINT chk_scores_positive CHECK (min_score >= 0),
    CONSTRAINT chk_risk_level CHECK (
        risk_level IN ('VERY_LOW', 'LOW', 'MODERATE', 'MODERATE_HIGH', 'HIGH', 'VERY_HIGH')
    ),
    CONSTRAINT chk_color_code CHECK (color_code IS NULL OR color_code ~ '^#[0-9A-Fa-f]{6}$')
);

COMMENT ON TABLE risk_score_categories IS 'Risk category definitions (Secure, Conservative, Income, Balance, Aggressive, Speculative)';

CREATE INDEX idx_risk_categories_code ON risk_score_categories(category_code);
CREATE INDEX idx_risk_categories_active ON risk_score_categories(is_active);

-- Customer risk profiles
CREATE TABLE customer_risk_profiles (
    id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT NOT NULL REFERENCES customers(id),
    assessment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_score INT NOT NULL,
    risk_category_id BIGINT NOT NULL REFERENCES risk_score_categories(id),
    status VARCHAR(20) DEFAULT 'ACTIVE',
    validity_period_months INT DEFAULT 12,
    valid_until DATE,
    assessment_notes TEXT,
    created_by_rm_id BIGINT REFERENCES relationship_managers(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_risk_status CHECK (
        status IN ('NOT_STARTED', 'IN_PROGRESS', 'COMPLETED', 'EXPIRED', 'INVALIDATED', 'BLOCKED')
    )
);

COMMENT ON TABLE customer_risk_profiles IS 'Customer risk profile assessment results';
COMMENT ON COLUMN customer_risk_profiles.status IS 'NOT_STARTED (initial), IN_PROGRESS (answering questions), COMPLETED (done), EXPIRED (validity passed), INVALIDATED (data changed), BLOCKED (compliance hold)';

CREATE INDEX idx_risk_profiles_customer_id ON customer_risk_profiles(customer_id);
CREATE INDEX idx_risk_profiles_category_id ON customer_risk_profiles(risk_category_id);
CREATE INDEX idx_risk_profiles_status ON customer_risk_profiles(status);
CREATE INDEX idx_risk_profiles_date ON customer_risk_profiles(assessment_date);

-- Customer risk answers
CREATE TABLE customer_risk_answers (
    id BIGSERIAL PRIMARY KEY,
    risk_profile_id BIGINT NOT NULL REFERENCES customer_risk_profiles(id) ON DELETE CASCADE,
    question_id BIGINT NOT NULL REFERENCES questions(id),
    text_answer TEXT,
    numeric_answer NUMERIC(15,2),
    date_answer DATE,
    points_earned INT DEFAULT 0,
    weighted_points NUMERIC(10,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE customer_risk_answers IS 'Individual question answers for risk assessments';
COMMENT ON COLUMN customer_risk_answers.weighted_points IS 'points_earned × question.weight';

CREATE INDEX idx_risk_answers_profile_id ON customer_risk_answers(risk_profile_id);
CREATE INDEX idx_risk_answers_question_id ON customer_risk_answers(question_id);

-- Risk answer selected options (for multi-select)
CREATE TABLE customer_risk_answer_options (
    id BIGSERIAL PRIMARY KEY,
    risk_answer_id BIGINT NOT NULL REFERENCES customer_risk_answers(id) ON DELETE CASCADE,
    option_id BIGINT NOT NULL REFERENCES question_options(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_risk_answer_options_answer_id ON customer_risk_answer_options(risk_answer_id);
CREATE INDEX idx_risk_answer_options_option_id ON customer_risk_answer_options(option_id);

-- Customer suitability assessments
CREATE TABLE customer_suitability_assessments (
    id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT NOT NULL REFERENCES customers(id),
    assessment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    suitability_level VARCHAR(50) NOT NULL,
    investment_objectives TEXT,
    investment_experience_years INT,
    financial_knowledge_level VARCHAR(50),
    risk_capacity VARCHAR(50),
    status VARCHAR(20) DEFAULT 'ACTIVE',
    validity_period_months INT DEFAULT 12,
    valid_until DATE,
    assessment_notes TEXT,
    created_by_rm_id BIGINT REFERENCES relationship_managers(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_suitability_status CHECK (
        status IN ('NOT_STARTED', 'IN_PROGRESS', 'COMPLETED', 'EXPIRED', 'INVALIDATED', 'BLOCKED')
    ),
    CONSTRAINT chk_suitability_level CHECK (
        suitability_level IN ('NOT_SUITABLE', 'LOW_SUITABILITY', 'MODERATE_SUITABILITY', 'HIGH_SUITABILITY', 'VERY_HIGH_SUITABILITY')
    )
);

COMMENT ON TABLE customer_suitability_assessments IS 'MiFID II / FINRA compliant suitability assessments';

CREATE INDEX idx_suitability_customer_id ON customer_suitability_assessments(customer_id);
CREATE INDEX idx_suitability_status ON customer_suitability_assessments(status);
CREATE INDEX idx_suitability_date ON customer_suitability_assessments(assessment_date);

-- Customer suitability answers
CREATE TABLE customer_suitability_answers (
    id BIGSERIAL PRIMARY KEY,
    suitability_assessment_id BIGINT NOT NULL REFERENCES customer_suitability_assessments(id) ON DELETE CASCADE,
    question_id BIGINT NOT NULL REFERENCES questions(id),
    text_answer TEXT,
    numeric_answer NUMERIC(15,2),
    date_answer DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE customer_suitability_answers IS 'Individual question answers for suitability assessments';

CREATE INDEX idx_suitability_answers_assessment_id ON customer_suitability_answers(suitability_assessment_id);
CREATE INDEX idx_suitability_answers_question_id ON customer_suitability_answers(question_id);

-- Suitability answer selected options
CREATE TABLE customer_suitability_answer_options (
    id BIGSERIAL PRIMARY KEY,
    suitability_answer_id BIGINT NOT NULL REFERENCES customer_suitability_answers(id) ON DELETE CASCADE,
    option_id BIGINT NOT NULL REFERENCES question_options(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_suitability_answer_options_answer_id ON customer_suitability_answer_options(suitability_answer_id);
CREATE INDEX idx_suitability_answer_options_option_id ON customer_suitability_answer_options(option_id);

-- ============================================================================
-- 4. PORTFOLIO MODULE
-- ============================================================================

DROP TABLE IF EXISTS portfolio_rebalancing_rules CASCADE;
DROP TABLE IF EXISTS portfolio_benchmarks CASCADE;
DROP TABLE IF EXISTS portfolio_securities CASCADE;
DROP TABLE IF EXISTS portfolio_asset_allocations CASCADE;
DROP TABLE IF EXISTS portfolio_strategies CASCADE;
DROP TABLE IF EXISTS modern_portfolios CASCADE;
DROP TABLE IF EXISTS asset_classes CASCADE;

-- Asset classes
CREATE TABLE asset_classes (
    id BIGSERIAL PRIMARY KEY,
    class_code VARCHAR(50) UNIQUE NOT NULL,
    class_name VARCHAR(100) NOT NULL,
    description TEXT,
    parent_class_id BIGINT REFERENCES asset_classes(id),
    display_order INT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE asset_classes IS 'Asset class hierarchy (Equity, Debt, Commodities, etc.)';

CREATE INDEX idx_asset_classes_code ON asset_classes(class_code);
CREATE INDEX idx_asset_classes_parent ON asset_classes(parent_class_id);

-- Modern portfolios
CREATE TABLE modern_portfolios (
    id BIGSERIAL PRIMARY KEY,
    portfolio_code VARCHAR(50) UNIQUE NOT NULL,
    portfolio_name VARCHAR(100) NOT NULL,
    risk_category_id BIGINT NOT NULL REFERENCES risk_score_categories(id),
    suitability_level VARCHAR(50) NOT NULL,
    expected_return_min NUMERIC(5,2) NOT NULL,
    expected_return_max NUMERIC(5,2) NOT NULL,
    volatility_percentage NUMERIC(5,2) NOT NULL,
    description TEXT,
    investment_strategy TEXT,
    time_horizon_min_years INT,
    time_horizon_max_years INT,
    minimum_investment NUMERIC(15,2),
    risk_score_min INT,
    risk_score_max INT,
    portfolio_type VARCHAR(30),
    key_features TEXT,
    is_default BOOLEAN DEFAULT FALSE,
    notes TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    display_order INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_expected_return_range CHECK (expected_return_min <= expected_return_max),
    CONSTRAINT chk_volatility_positive CHECK (volatility_percentage > 0),
    CONSTRAINT chk_portfolio_type CHECK (
        portfolio_type IS NULL OR portfolio_type IN ('SECURE', 'CONSERVATIVE', 'INCOME', 'BALANCED', 'AGGRESSIVE', 'SPECULATIVE', 'CUSTOM')
    ),
    CONSTRAINT chk_risk_score_range CHECK (risk_score_min IS NULL OR risk_score_max IS NULL OR risk_score_min <= risk_score_max)
);

COMMENT ON TABLE modern_portfolios IS 'Model portfolio definitions (MPF)';
COMMENT ON COLUMN modern_portfolios.expected_return_min IS 'Minimum expected annual return percentage';
COMMENT ON COLUMN modern_portfolios.expected_return_max IS 'Maximum expected annual return percentage';
COMMENT ON COLUMN modern_portfolios.volatility_percentage IS 'Annual volatility (standard deviation)';
COMMENT ON COLUMN modern_portfolios.risk_score_min IS 'Minimum risk score for portfolio matching';
COMMENT ON COLUMN modern_portfolios.risk_score_max IS 'Maximum risk score for portfolio matching';
COMMENT ON COLUMN modern_portfolios.portfolio_type IS 'Portfolio classification: SECURE, CONSERVATIVE, INCOME, BALANCED, AGGRESSIVE, SPECULATIVE, CUSTOM';
COMMENT ON COLUMN modern_portfolios.key_features IS 'Key features and characteristics of the portfolio';
COMMENT ON COLUMN modern_portfolios.is_default IS 'Whether this is the default portfolio for its risk category';
COMMENT ON COLUMN modern_portfolios.notes IS 'Internal notes for admin/RM reference';

CREATE INDEX idx_portfolios_code ON modern_portfolios(portfolio_code);
CREATE INDEX idx_portfolios_risk_category ON modern_portfolios(risk_category_id);
CREATE INDEX idx_portfolios_suitability ON modern_portfolios(suitability_level);
CREATE INDEX idx_portfolios_active ON modern_portfolios(is_active);

-- Portfolio strategies (3-level hierarchy: Portfolio → Strategy → Allocation)
CREATE TABLE portfolio_strategies (
    id BIGSERIAL PRIMARY KEY,
    portfolio_id BIGINT NOT NULL REFERENCES modern_portfolios(id) ON DELETE CASCADE,
    strategy_code VARCHAR(50) NOT NULL,
    strategy_name VARCHAR(100) NOT NULL,
    description TEXT,
    expected_return NUMERIC(5,2),
    volatility_percentage NUMERIC(5,2),
    display_order INT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_portfolio_strategy_code UNIQUE (portfolio_id, strategy_code)
);

COMMENT ON TABLE portfolio_strategies IS 'Investment strategies within a portfolio';
COMMENT ON COLUMN portfolio_strategies.expected_return IS 'Expected annual return percentage for this strategy';
COMMENT ON COLUMN portfolio_strategies.volatility_percentage IS 'Expected volatility for this strategy';

CREATE INDEX idx_strategies_portfolio_id ON portfolio_strategies(portfolio_id);
CREATE INDEX idx_strategies_code ON portfolio_strategies(strategy_code);
CREATE INDEX idx_strategies_active ON portfolio_strategies(is_active);

-- Portfolio asset allocations (supports both 2-level and 3-level hierarchy)
DROP TABLE IF EXISTS portfolio_asset_allocations CASCADE;
CREATE TABLE portfolio_asset_allocations (
    id BIGSERIAL PRIMARY KEY,
    portfolio_id BIGINT REFERENCES modern_portfolios(id) ON DELETE CASCADE,
    strategy_id BIGINT REFERENCES portfolio_strategies(id) ON DELETE CASCADE,
    asset_class_id BIGINT NOT NULL REFERENCES asset_classes(id),

    -- Allocation percentages
    target_allocation_percentage NUMERIC(5,2) NOT NULL,
    min_allocation_percentage NUMERIC(5,2),
    max_allocation_percentage NUMERIC(5,2),
    rebalancing_threshold NUMERIC(5,2) DEFAULT 5.00,

    -- Strategic vs Tactical allocation
    strategic_allocation NUMERIC(5,2),
    tactical_allocation NUMERIC(5,2),

    -- Expected metrics
    expected_return NUMERIC(5,2),
    expected_risk NUMERIC(5,2),

    -- Rationale and recommendations
    allocation_rationale TEXT,
    fund_recommendations TEXT,

    -- Display and status
    display_order INT,
    is_core_holding BOOLEAN DEFAULT TRUE,
    is_satellite_holding BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    notes TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_allocation_percentage CHECK (
        target_allocation_percentage >= 0 AND target_allocation_percentage <= 100
    ),
    CONSTRAINT chk_allocation_range CHECK (
        min_allocation_percentage IS NULL OR max_allocation_percentage IS NULL OR
        min_allocation_percentage <= target_allocation_percentage AND
        target_allocation_percentage <= max_allocation_percentage
    ),
    -- Either portfolio_id or strategy_id must be set (supports 2-level or 3-level hierarchy)
    CONSTRAINT chk_allocation_parent CHECK (
        portfolio_id IS NOT NULL OR strategy_id IS NOT NULL
    ),
    -- Unique allocation per portfolio+asset_class OR strategy+asset_class
    CONSTRAINT uq_portfolio_asset_allocation UNIQUE (portfolio_id, asset_class_id),
    CONSTRAINT uq_strategy_asset_allocation UNIQUE (strategy_id, asset_class_id)
);

COMMENT ON TABLE portfolio_asset_allocations IS 'Asset allocation per portfolio or strategy (supports both 2-level and 3-level hierarchy)';
COMMENT ON COLUMN portfolio_asset_allocations.rebalancing_threshold IS 'Trigger rebalancing if deviation exceeds this';
COMMENT ON COLUMN portfolio_asset_allocations.strategic_allocation IS 'Long-term strategic allocation target';
COMMENT ON COLUMN portfolio_asset_allocations.tactical_allocation IS 'Short-term tactical allocation adjustment';
COMMENT ON COLUMN portfolio_asset_allocations.is_core_holding IS 'Core holdings form the foundation of portfolio';
COMMENT ON COLUMN portfolio_asset_allocations.is_satellite_holding IS 'Satellite holdings for tactical opportunities';

CREATE INDEX idx_allocations_portfolio_id ON portfolio_asset_allocations(portfolio_id);
CREATE INDEX idx_allocations_strategy_id ON portfolio_asset_allocations(strategy_id);
CREATE INDEX idx_allocations_asset_class_id ON portfolio_asset_allocations(asset_class_id);
CREATE INDEX idx_portfolio_allocation ON portfolio_asset_allocations(portfolio_id, asset_class_id);
CREATE INDEX idx_strategy_allocation ON portfolio_asset_allocations(strategy_id, asset_class_id);

-- Portfolio securities
CREATE TABLE portfolio_securities (
    id BIGSERIAL PRIMARY KEY,
    portfolio_id BIGINT NOT NULL REFERENCES modern_portfolios(id) ON DELETE CASCADE,
    asset_class_id BIGINT NOT NULL REFERENCES asset_classes(id),
    security_code VARCHAR(50) NOT NULL,
    security_name VARCHAR(255) NOT NULL,
    isin VARCHAR(50),
    security_type VARCHAR(50) NOT NULL,
    weight_percentage NUMERIC(5,2) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_security_weight CHECK (
        weight_percentage >= 0 AND weight_percentage <= 100
    ),
    CONSTRAINT chk_security_type CHECK (
        security_type IN ('EQUITY', 'BOND', 'MUTUAL_FUND', 'ETF', 'COMMODITY', 'ALTERNATIVE')
    )
);

COMMENT ON TABLE portfolio_securities IS 'Underlying securities within portfolios';

CREATE INDEX idx_securities_portfolio_id ON portfolio_securities(portfolio_id);
CREATE INDEX idx_securities_asset_class_id ON portfolio_securities(asset_class_id);
CREATE INDEX idx_securities_code ON portfolio_securities(security_code);
CREATE INDEX idx_securities_active ON portfolio_securities(is_active);

-- Portfolio benchmarks
CREATE TABLE portfolio_benchmarks (
    id BIGSERIAL PRIMARY KEY,
    portfolio_id BIGINT NOT NULL REFERENCES modern_portfolios(id) ON DELETE CASCADE,
    benchmark_code VARCHAR(50) NOT NULL,
    benchmark_name VARCHAR(255) NOT NULL,
    weight_percentage NUMERIC(5,2) DEFAULT 100.00,
    is_primary BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_benchmark_weight CHECK (
        weight_percentage > 0 AND weight_percentage <= 100
    )
);

COMMENT ON TABLE portfolio_benchmarks IS 'Benchmark indices for portfolio performance comparison';

CREATE INDEX idx_benchmarks_portfolio_id ON portfolio_benchmarks(portfolio_id);
CREATE INDEX idx_benchmarks_code ON portfolio_benchmarks(benchmark_code);

-- Portfolio rebalancing rules
CREATE TABLE portfolio_rebalancing_rules (
    id BIGSERIAL PRIMARY KEY,
    portfolio_id BIGINT NOT NULL REFERENCES modern_portfolios(id) ON DELETE CASCADE,
    rebalancing_frequency VARCHAR(50) NOT NULL,
    deviation_threshold_percentage NUMERIC(5,2) DEFAULT 5.00,
    review_period_months INT DEFAULT 3,
    auto_rebalance BOOLEAN DEFAULT FALSE,
    notification_enabled BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_rebalancing_frequency CHECK (
        rebalancing_frequency IN ('MONTHLY', 'QUARTERLY', 'SEMI_ANNUAL', 'ANNUAL', 'ON_DEVIATION')
    )
);

COMMENT ON TABLE portfolio_rebalancing_rules IS 'Rebalancing rules per portfolio';

CREATE INDEX idx_rebalancing_portfolio_id ON portfolio_rebalancing_rules(portfolio_id);

-- ============================================================================
-- 5. GOAL & FINANCIAL PLANNING MODULE
-- ============================================================================

DROP TABLE IF EXISTS goal_portfolio_matches CASCADE;
DROP TABLE IF EXISTS financial_calculations CASCADE;
DROP TABLE IF EXISTS customer_goals CASCADE;
DROP TABLE IF EXISTS goal_types CASCADE;

-- Goal types
CREATE TABLE goal_types (
    id BIGSERIAL PRIMARY KEY,
    type_code VARCHAR(50) UNIQUE NOT NULL,
    type_name VARCHAR(100) NOT NULL,
    description TEXT,
    icon VARCHAR(100),
    display_order INT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE goal_types IS 'Types of financial goals (Retirement, Education, Marriage, etc.)';

CREATE INDEX idx_goal_types_code ON goal_types(type_code);
CREATE INDEX idx_goal_types_active ON goal_types(is_active);

-- Customer goals (aligned with Backend Goal entity)
CREATE TABLE customer_goals (
    id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT NOT NULL REFERENCES customers(id),
    goal_type_id BIGINT NOT NULL REFERENCES goal_types(id),
    goal_name VARCHAR(255) NOT NULL,
    description TEXT,
    target_amount NUMERIC(15,2) NOT NULL,
    current_amount NUMERIC(15,2) DEFAULT 0,
    target_date DATE NOT NULL,
    time_horizon_years INT GENERATED ALWAYS AS (
        EXTRACT(YEAR FROM AGE(target_date, CURRENT_DATE))
    ) STORED,
    initial_investment NUMERIC(15,2) DEFAULT 0,
    monthly_investment NUMERIC(15,2) DEFAULT 0,
    priority VARCHAR(20) DEFAULT 'MEDIUM',
    status VARCHAR(30) DEFAULT 'DRAFT',
    inflation_rate NUMERIC(5,2) DEFAULT 6.00,
    tax_rate NUMERIC(5,2) DEFAULT 0.00,
    created_by_rm_id BIGINT REFERENCES relationship_managers(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_target_amount_positive CHECK (target_amount > 0),
    CONSTRAINT chk_initial_investment_positive CHECK (initial_investment >= 0),
    CONSTRAINT chk_monthly_investment_positive CHECK (monthly_investment >= 0),
    CONSTRAINT chk_target_date_future CHECK (target_date > CURRENT_DATE),
    CONSTRAINT chk_priority CHECK (
        priority IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')
    ),
    CONSTRAINT chk_goal_status CHECK (
        status IN ('DRAFT', 'PLANNING', 'ASSESSMENT_PENDING', 'PORTFOLIO_RECOMMENDATION',
                   'ACTIVE', 'ON_TRACK', 'OFF_TRACK', 'AT_RISK', 'PAUSED',
                   'COMPLETED', 'CANCELLED', 'EXPIRED')
    )
);

COMMENT ON TABLE customer_goals IS 'Customer financial goals';
COMMENT ON COLUMN customer_goals.time_horizon_years IS 'Auto-calculated years from now to target date';

CREATE INDEX idx_goals_customer_id ON customer_goals(customer_id);
CREATE INDEX idx_goals_goal_type ON customer_goals(goal_type_id);
CREATE INDEX idx_goals_status ON customer_goals(status);
CREATE INDEX idx_goals_target_date ON customer_goals(target_date);

-- Financial calculations (aligned with Backend FinancialCalculation entity)
CREATE TABLE financial_calculations (
    id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT REFERENCES customers(id),
    goal_id BIGINT REFERENCES customer_goals(id) ON DELETE CASCADE,
    rm_id BIGINT REFERENCES relationship_managers(id),

    -- Calculator inputs
    target_amount NUMERIC(15,2),
    tenure_years INT,
    tenure_months INT,
    inflation_rate NUMERIC(5,2),
    monthly_investment NUMERIC(15,2),
    initial_investment NUMERIC(15,2),
    required_return NUMERIC(5,2),
    step_up_percentage NUMERIC(5,2),
    tax_rate NUMERIC(5,2),
    current_value NUMERIC(15,2),

    -- Calculator outputs
    future_value NUMERIC(15,2),
    total_investment NUMERIC(15,2),
    total_returns NUMERIC(15,2),
    absolute_returns NUMERIC(15,2),
    cagr NUMERIC(5,2),
    real_return_rate NUMERIC(5,2),
    required_monthly_sip NUMERIC(15,2),
    required_lumpsum NUMERIC(15,2),
    shortfall_amount NUMERIC(15,2),
    surplus_amount NUMERIC(15,2),
    goal_achievable BOOLEAN DEFAULT FALSE,
    probability_of_success NUMERIC(5,2),

    -- Metadata
    calculation_code VARCHAR(50) UNIQUE,
    calculation_name VARCHAR(200),
    description TEXT,
    calculation_type VARCHAR(50) NOT NULL,
    calculated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    calculated_by VARCHAR(100),
    calculation_version VARCHAR(20) DEFAULT '1.0',
    formula_used TEXT,
    calculation_inputs JSONB,
    calculation_outputs JSONB,
    assumptions JSONB,
    year_wise_breakdown JSONB,
    scenario_type VARCHAR(30) DEFAULT 'BASE_CASE',
    is_simulation BOOLEAN DEFAULT FALSE,
    simulation_iterations INT,
    is_saved BOOLEAN DEFAULT FALSE,
    is_applied_to_goal BOOLEAN DEFAULT FALSE,
    notes TEXT,
    recommendations TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_calculation_type CHECK (
        calculation_type IN (
            'SIP_FUTURE_VALUE', 'SIP_REQUIRED',
            'LUMPSUM_FUTURE_VALUE', 'LUMPSUM_REQUIRED',
            'GOAL_PLANNING', 'CORPUS_CALCULATION',
            'RETIREMENT_PLANNING', 'EDUCATION_PLANNING',
            'MIXED_INVESTMENT', 'WHAT_IF_ANALYSIS',
            'MONTE_CARLO_SIMULATION', 'OTHER'
        )
    ),
    CONSTRAINT chk_scenario_type CHECK (
        scenario_type IN ('BASE_CASE', 'BEST_CASE', 'WORST_CASE', 'MODERATE_CASE', 'CUSTOM')
    )
);

COMMENT ON TABLE financial_calculations IS 'Financial calculator results - aligned with Backend FinancialCalculation entity';
COMMENT ON COLUMN financial_calculations.calculation_type IS 'Type of calculation performed';
COMMENT ON COLUMN financial_calculations.scenario_type IS 'Scenario type for what-if analysis';

CREATE INDEX idx_customer_calculation ON financial_calculations(customer_id, calculation_type);
CREATE INDEX idx_goal_calculation ON financial_calculations(goal_id);
CREATE INDEX idx_calculation_timestamp ON financial_calculations(calculated_at);

-- Goal portfolio matches
CREATE TABLE goal_portfolio_matches (
    id BIGSERIAL PRIMARY KEY,
    goal_id BIGINT NOT NULL REFERENCES customer_goals(id) ON DELETE CASCADE,
    calculation_id BIGINT REFERENCES financial_calculations(id),
    portfolio_id BIGINT NOT NULL REFERENCES modern_portfolios(id),
    match_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_match BOOLEAN NOT NULL,
    match_score NUMERIC(5,2),
    required_return NUMERIC(5,2),
    portfolio_return_min NUMERIC(5,2),
    portfolio_return_max NUMERIC(5,2),
    gap_percentage NUMERIC(5,2),
    suggestions JSONB,
    status VARCHAR(20) DEFAULT 'PROPOSED',
    selected_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_match_status CHECK (
        status IN ('PROPOSED', 'SELECTED', 'REJECTED', 'SUPERSEDED')
    )
);

COMMENT ON TABLE goal_portfolio_matches IS 'Portfolio matching results for goals';
COMMENT ON COLUMN goal_portfolio_matches.gap_percentage IS 'If not matched: required - portfolio max';
COMMENT ON COLUMN goal_portfolio_matches.suggestions IS 'JSON array of suggestion strings';

CREATE INDEX idx_matches_goal_id ON goal_portfolio_matches(goal_id);
CREATE INDEX idx_matches_portfolio_id ON goal_portfolio_matches(portfolio_id);
CREATE INDEX idx_matches_status ON goal_portfolio_matches(status);
CREATE INDEX idx_matches_is_match ON goal_portfolio_matches(is_match);

-- ============================================================================
-- 6. SIMULATION MODULE
-- ============================================================================

DROP TABLE IF EXISTS simulation_scenarios CASCADE;
DROP TABLE IF EXISTS monte_carlo_simulations CASCADE;

-- Monte Carlo simulations
CREATE TABLE monte_carlo_simulations (
    id BIGSERIAL PRIMARY KEY,
    goal_id BIGINT NOT NULL REFERENCES customer_goals(id),
    portfolio_id BIGINT NOT NULL REFERENCES modern_portfolios(id),
    simulation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    initial_investment NUMERIC(15,2) NOT NULL,
    monthly_sip NUMERIC(15,2) NOT NULL,
    years INT NOT NULL,
    expected_return_percentage NUMERIC(5,2) NOT NULL,
    volatility_percentage NUMERIC(5,2) NOT NULL,
    iterations INT DEFAULT 10000,
    worst_case NUMERIC(15,2),
    base_case NUMERIC(15,2),
    best_case NUMERIC(15,2),
    target_corpus NUMERIC(15,2),
    probability_of_success NUMERIC(5,2),
    chart_data JSONB,
    status VARCHAR(20) DEFAULT 'PENDING',
    error_message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,

    CONSTRAINT chk_simulation_status CHECK (
        status IN ('PENDING', 'IN_PROGRESS', 'COMPLETED', 'FAILED')
    ),
    CONSTRAINT chk_years_positive CHECK (years > 0),
    CONSTRAINT chk_iterations_positive CHECK (iterations > 0)
);

COMMENT ON TABLE monte_carlo_simulations IS 'Monte Carlo simulation runs';
COMMENT ON COLUMN monte_carlo_simulations.worst_case IS '10th percentile outcome';
COMMENT ON COLUMN monte_carlo_simulations.base_case IS '50th percentile (median) outcome';
COMMENT ON COLUMN monte_carlo_simulations.best_case IS '90th percentile outcome';
COMMENT ON COLUMN monte_carlo_simulations.chart_data IS 'Monthly projection data for charts';

CREATE INDEX idx_simulations_goal_id ON monte_carlo_simulations(goal_id);
CREATE INDEX idx_simulations_portfolio_id ON monte_carlo_simulations(portfolio_id);
CREATE INDEX idx_simulations_status ON monte_carlo_simulations(status);
CREATE INDEX idx_simulations_date ON monte_carlo_simulations(simulation_date);

-- Simulation scenarios (pre-calculated scenarios)
CREATE TABLE simulation_scenarios (
    id BIGSERIAL PRIMARY KEY,
    simulation_id BIGINT NOT NULL REFERENCES monte_carlo_simulations(id) ON DELETE CASCADE,
    scenario_type VARCHAR(20) NOT NULL,
    final_value NUMERIC(15,2) NOT NULL,
    percentile INT,
    monthly_projections JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_scenario_type CHECK (
        scenario_type IN ('WORST', 'BASE', 'BEST', 'CUSTOM')
    ),
    CONSTRAINT chk_percentile_range CHECK (
        percentile IS NULL OR (percentile >= 0 AND percentile <= 100)
    )
);

COMMENT ON TABLE simulation_scenarios IS 'Individual scenario results from simulations';
COMMENT ON COLUMN simulation_scenarios.monthly_projections IS 'Array of month-by-month values';

CREATE INDEX idx_scenarios_simulation_id ON simulation_scenarios(simulation_id);
CREATE INDEX idx_scenarios_type ON simulation_scenarios(scenario_type);

-- ============================================================================
-- 7. ORDER MANAGEMENT MODULE
-- ============================================================================

DROP TABLE IF EXISTS mfa_approvals CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;

-- Orders
CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    order_code VARCHAR(50) UNIQUE NOT NULL,
    customer_id BIGINT NOT NULL REFERENCES customers(id),
    goal_id BIGINT REFERENCES customer_goals(id),
    portfolio_id BIGINT NOT NULL REFERENCES modern_portfolios(id),
    simulation_id BIGINT REFERENCES monte_carlo_simulations(id),
    order_type VARCHAR(20) NOT NULL,
    total_amount NUMERIC(15,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'DRAFT',
    payment_method VARCHAR(50),
    payment_reference VARCHAR(255),
    notes TEXT,
    created_by_rm_id BIGINT REFERENCES relationship_managers(id),
    approved_by_customer_at TIMESTAMP,
    submitted_to_trading_at TIMESTAMP,
    executed_at TIMESTAMP,
    cancelled_at TIMESTAMP,
    cancellation_reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_order_type CHECK (
        order_type IN ('BUY', 'SELL', 'SIP_SETUP', 'REBALANCE')
    ),
    CONSTRAINT chk_order_status CHECK (
        status IN ('DRAFT', 'PENDING_MFA', 'APPROVED', 'SUBMITTED',
                   'EXECUTED', 'PARTIALLY_EXECUTED', 'FAILED', 'CANCELLED')
    ),
    CONSTRAINT chk_total_amount_positive CHECK (total_amount > 0)
);

COMMENT ON TABLE orders IS 'Investment orders';
COMMENT ON COLUMN orders.status IS 'Order lifecycle status';

CREATE INDEX idx_orders_code ON orders(order_code);
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_goal_id ON orders(goal_id);
CREATE INDEX idx_orders_portfolio_id ON orders(portfolio_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created_at ON orders(created_at);

-- Order items
CREATE TABLE order_items (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    security_id BIGINT REFERENCES portfolio_securities(id),
    security_code VARCHAR(50) NOT NULL,
    security_name VARCHAR(255) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,
    quantity NUMERIC(15,4),
    price NUMERIC(15,4),
    amount NUMERIC(15,2) NOT NULL,
    fees NUMERIC(15,2) DEFAULT 0,
    taxes NUMERIC(15,2) DEFAULT 0,
    net_amount NUMERIC(15,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING',
    execution_reference VARCHAR(255),
    executed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_transaction_type CHECK (
        transaction_type IN ('BUY', 'SELL')
    ),
    CONSTRAINT chk_item_status CHECK (
        status IN ('PENDING', 'EXECUTED', 'FAILED', 'CANCELLED')
    ),
    CONSTRAINT chk_amount_positive CHECK (amount > 0)
);

COMMENT ON TABLE order_items IS 'Individual securities within an order';

CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_security_id ON order_items(security_id);
CREATE INDEX idx_order_items_status ON order_items(status);

-- MFA approvals
CREATE TABLE mfa_approvals (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    customer_id BIGINT NOT NULL REFERENCES customers(id),
    mfa_code VARCHAR(10) NOT NULL,
    mfa_method VARCHAR(20) NOT NULL,
    mfa_sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    mfa_expires_at TIMESTAMP NOT NULL,
    attempts INT DEFAULT 0,
    max_attempts INT DEFAULT 3,
    status VARCHAR(20) DEFAULT 'PENDING',
    verified_at TIMESTAMP,
    ip_address VARCHAR(50),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_mfa_method CHECK (
        mfa_method IN ('SMS', 'EMAIL', 'TOTP', 'BIOMETRIC')
    ),
    CONSTRAINT chk_mfa_status CHECK (
        status IN ('PENDING', 'VERIFIED', 'EXPIRED', 'FAILED', 'BLOCKED')
    ),
    CONSTRAINT chk_attempts_valid CHECK (attempts >= 0 AND attempts <= max_attempts)
);

COMMENT ON TABLE mfa_approvals IS 'Multi-factor authentication for customer order approvals';

CREATE INDEX idx_mfa_order_id ON mfa_approvals(order_id);
CREATE INDEX idx_mfa_customer_id ON mfa_approvals(customer_id);
CREATE INDEX idx_mfa_status ON mfa_approvals(status);
CREATE INDEX idx_mfa_expires_at ON mfa_approvals(mfa_expires_at);

-- ============================================================================
-- 8. JOURNEY TRACKING MODULE
-- ============================================================================

DROP TABLE IF EXISTS journey_edit_history CASCADE;
DROP TABLE IF EXISTS journey_stages CASCADE;
DROP TABLE IF EXISTS customer_journeys CASCADE;

-- Customer journeys
CREATE TABLE customer_journeys (
    id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT UNIQUE NOT NULL REFERENCES customers(id),
    current_stage VARCHAR(50) NOT NULL,
    status VARCHAR(20) DEFAULT 'IN_PROGRESS',
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_journey_stage CHECK (
        current_stage IN ('GOAL_CREATION', 'RISK_PROFILE', 'SUITABILITY',
                         'FINANCIAL_CALCULATION', 'PORTFOLIO_MATCHING',
                         'SIMULATION', 'ORDER_PLACEMENT', 'COMPLETED')
    ),
    CONSTRAINT chk_journey_status CHECK (
        status IN ('IN_PROGRESS', 'COMPLETED', 'CANCELLED', 'ON_HOLD')
    )
);

COMMENT ON TABLE customer_journeys IS 'Customer advisory journey tracking';

CREATE INDEX idx_journeys_customer_id ON customer_journeys(customer_id);
CREATE INDEX idx_journeys_stage ON customer_journeys(current_stage);
CREATE INDEX idx_journeys_status ON customer_journeys(status);

-- Journey stages
CREATE TABLE journey_stages (
    id BIGSERIAL PRIMARY KEY,
    journey_id BIGINT NOT NULL REFERENCES customer_journeys(id) ON DELETE CASCADE,
    stage_name VARCHAR(50) NOT NULL,
    attempt_number INT DEFAULT 1,
    status VARCHAR(20) DEFAULT 'IN_PROGRESS',
    current_page VARCHAR(100),
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    duration_seconds INT GENERATED ALWAYS AS (
        EXTRACT(EPOCH FROM (COALESCE(completed_at, CURRENT_TIMESTAMP) - started_at))::INT
    ) STORED,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_stage_status CHECK (
        status IN ('IN_PROGRESS', 'COMPLETED', 'SKIPPED', 'FAILED')
    ),
    CONSTRAINT chk_attempt_number_positive CHECK (attempt_number > 0)
);

COMMENT ON TABLE journey_stages IS 'Individual stage tracking within journey';
COMMENT ON COLUMN journey_stages.attempt_number IS 'Retake counter (e.g., risk assessment retake)';
COMMENT ON COLUMN journey_stages.current_page IS 'Current page/step within the stage';

CREATE INDEX idx_journey_stages_journey_id ON journey_stages(journey_id);
CREATE INDEX idx_journey_stages_stage_name ON journey_stages(stage_name);
CREATE INDEX idx_journey_stages_status ON journey_stages(status);

-- Journey edit history
CREATE TABLE journey_edit_history (
    id BIGSERIAL PRIMARY KEY,
    journey_id BIGINT NOT NULL REFERENCES customer_journeys(id) ON DELETE CASCADE,
    entity_type VARCHAR(50) NOT NULL,
    entity_id BIGINT,
    action VARCHAR(50) NOT NULL,
    details TEXT,
    changed_by_rm_id BIGINT REFERENCES relationship_managers(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_entity_type CHECK (
        entity_type IN ('GOAL', 'RISK_PROFILE', 'SUITABILITY', 'CALCULATION',
                       'PORTFOLIO_MATCH', 'SIMULATION', 'ORDER', 'STAGE_CHANGE', 'RETAKE')
    )
);

COMMENT ON TABLE journey_edit_history IS 'Audit trail for journey edits and revisions';

CREATE INDEX idx_edit_history_journey_id ON journey_edit_history(journey_id);
CREATE INDEX idx_edit_history_entity_type ON journey_edit_history(entity_type);
CREATE INDEX idx_edit_history_created_at ON journey_edit_history(created_at);

-- ============================================================================
-- 9. INITIAL DATA POPULATION
-- ============================================================================

-- Insert default roles
INSERT INTO roles (role_code, role_name, description) VALUES
('SUPER_ADMIN', 'Super Administrator', 'Full system access - configure questionnaires, portfolios, risk categories'),
('RM', 'Relationship Manager', 'Manage customers and conduct goal-based advisory process'),
('CUSTOMER', 'Customer/Client', 'Portfolio owner and investor - access to approved orders and statements');

-- Insert questionnaire types
INSERT INTO questionnaire_types (type_code, type_name, description) VALUES
('RISK_PROFILE', 'Risk Profile Assessment', 'Evaluate customer risk tolerance and capacity'),
('SUITABILITY', 'Suitability Assessment', 'MiFID II / FINRA compliant comprehensive suitability evaluation');

-- Insert risk score categories (8-35 scale)
INSERT INTO risk_score_categories (category_code, category_name, min_score, max_score, description, risk_level, time_horizon_years, color_code, icon_name, display_order) VALUES
('SECURE', 'Secure', 8, 13, 'Very conservative investors seeking capital preservation', 'VERY_LOW', 1, '#22C55E', 'shield', 1),
('CONSERVATIVE', 'Conservative', 14, 16, 'Conservative investors with low risk tolerance', 'LOW', 3, '#84CC16', 'shield-check', 2),
('INCOME', 'Income', 17, 21, 'Income-focused investors with moderate-low risk', 'MODERATE', 5, '#EAB308', 'trending-up', 3),
('BALANCE', 'Balance', 22, 26, 'Balanced investors seeking growth with moderate risk', 'MODERATE_HIGH', 7, '#F97316', 'scale', 4),
('AGGRESSIVE', 'Aggressive', 27, 31, 'Aggressive investors comfortable with high volatility', 'HIGH', 10, '#EF4444', 'flame', 5),
('SPECULATIVE', 'Speculative', 32, 35, 'Highly aggressive investors seeking maximum returns', 'VERY_HIGH', 15, '#DC2626', 'rocket', 6);

-- Insert goal types (aligned with Backend GoalType enum)
INSERT INTO goal_types (type_code, type_name, description, icon, display_order) VALUES
('RETIREMENT', 'Retirement Planning', 'Plan for a comfortable retirement', 'retirement', 1),
('EDUCATION', 'Education Fund', 'Save for education', 'education', 2),
('HOME_PURCHASE', 'Home Purchase', 'Save for buying a home', 'home', 3),
('VEHICLE_PURCHASE', 'Vehicle Purchase', 'Save for a vehicle', 'vehicle', 4),
('MARRIAGE', 'Marriage/Wedding', 'Plan for wedding expenses', 'marriage', 5),
('WEALTH_CREATION', 'Wealth Creation', 'General wealth accumulation', 'wealth', 6),
('VACATION', 'Vacation', 'Fund travel or vacation', 'travel', 7),
('EMERGENCY_FUND', 'Emergency Fund', 'Build emergency savings', 'emergency', 8),
('DEBT_REPAYMENT', 'Debt Repayment', 'Pay off debts', 'debt', 9),
('BUSINESS_INVESTMENT', 'Business Investment', 'Invest in business', 'business', 10),
('OTHER', 'Other Goal', 'Custom financial goal', 'other', 11);

-- Insert asset classes
INSERT INTO asset_classes (class_code, class_name, description, parent_class_id, display_order) VALUES
('EQUITY', 'Equity', 'Stock market investments', NULL, 1),
('EQUITY_LARGE_CAP', 'Large Cap Equity', 'Large capitalization stocks', 1, 2),
('EQUITY_MID_CAP', 'Mid Cap Equity', 'Mid capitalization stocks', 1, 3),
('EQUITY_SMALL_CAP', 'Small Cap Equity', 'Small capitalization stocks', 1, 4),
('EQUITY_INTERNATIONAL', 'International Equity', 'Foreign market stocks', 1, 5),
('DEBT', 'Debt/Fixed Income', 'Bonds and fixed income securities', NULL, 6),
('DEBT_GOVT', 'Government Bonds', 'Government securities', 6, 7),
('DEBT_CORPORATE', 'Corporate Bonds', 'Corporate debt instruments', 6, 8),
('COMMODITY', 'Commodities', 'Gold, silver, oil, etc.', NULL, 9),
('ALTERNATIVE', 'Alternative Investments', 'Real estate, private equity, etc.', NULL, 10);

-- ============================================================================
-- 10. VIEWS FOR REPORTING
-- ============================================================================

-- Customer dashboard view
CREATE OR REPLACE VIEW vw_customer_dashboard AS
SELECT
    c.id AS customer_id,
    c.customer_code,
    u.first_name || ' ' || u.last_name AS customer_name,
    u.email,
    rm_u.first_name || ' ' || rm_u.last_name AS rm_name,
    COUNT(DISTINCT g.id) AS total_goals,
    COUNT(DISTINCT CASE WHEN g.status = 'IN_PROGRESS' THEN g.id END) AS active_goals,
    SUM(g.goal_amount) AS total_goal_amount,
    SUM(g.current_amount) AS total_current_amount,
    crp.total_score AS risk_score,
    rsc.category_name AS risk_category,
    cj.current_stage AS journey_stage,
    cj.status AS journey_status
FROM customers c
JOIN users u ON c.user_id = u.id
LEFT JOIN relationship_managers rm ON c.rm_id = rm.id
LEFT JOIN users rm_u ON rm.user_id = rm_u.id
LEFT JOIN customer_goals g ON c.id = g.customer_id
LEFT JOIN customer_risk_profiles crp ON c.id = crp.customer_id AND crp.status = 'ACTIVE'
LEFT JOIN risk_score_categories rsc ON crp.risk_category_id = rsc.id
LEFT JOIN customer_journeys cj ON c.id = cj.customer_id
WHERE c.is_active = TRUE
GROUP BY c.id, c.customer_code, u.first_name, u.last_name, u.email,
         rm_u.first_name, rm_u.last_name, crp.total_score, rsc.category_name,
         cj.current_stage, cj.status;

COMMENT ON VIEW vw_customer_dashboard IS 'Customer overview for RM dashboard';

-- Portfolio performance summary view
CREATE OR REPLACE VIEW vw_portfolio_performance AS
SELECT
    mp.id AS portfolio_id,
    mp.portfolio_code,
    mp.portfolio_name,
    rsc.category_name AS risk_category,
    mp.suitability_level,
    mp.expected_return_min,
    mp.expected_return_max,
    mp.volatility_percentage,
    COUNT(DISTINCT gpm.goal_id) AS goals_matched,
    COUNT(DISTINCT o.id) AS orders_placed,
    SUM(o.total_amount) FILTER (WHERE o.status = 'EXECUTED') AS total_invested
FROM modern_portfolios mp
LEFT JOIN risk_score_categories rsc ON mp.risk_category_id = rsc.id
LEFT JOIN goal_portfolio_matches gpm ON mp.id = gpm.portfolio_id AND gpm.status = 'SELECTED'
LEFT JOIN orders o ON mp.id = o.portfolio_id
WHERE mp.is_active = TRUE
GROUP BY mp.id, mp.portfolio_code, mp.portfolio_name, rsc.category_name,
         mp.suitability_level, mp.expected_return_min, mp.expected_return_max,
         mp.volatility_percentage;

COMMENT ON VIEW vw_portfolio_performance IS 'Portfolio usage and performance summary';

-- ============================================================================
-- 11. FUNCTIONS & TRIGGERS
-- ============================================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply updated_at trigger to all relevant tables
DO $$
DECLARE
    t text;
BEGIN
    FOR t IN
        SELECT table_name
        FROM information_schema.columns
        WHERE column_name = 'updated_at'
        AND table_schema = 'public'
    LOOP
        EXECUTE format('
            DROP TRIGGER IF EXISTS trigger_update_updated_at ON %I;
            CREATE TRIGGER trigger_update_updated_at
            BEFORE UPDATE ON %I
            FOR EACH ROW
            EXECUTE FUNCTION update_updated_at_column();
        ', t, t);
    END LOOP;
END $$;

-- Function to auto-expire old risk profiles
CREATE OR REPLACE FUNCTION expire_old_risk_profiles()
RETURNS void AS $$
BEGIN
    UPDATE customer_risk_profiles
    SET status = 'EXPIRED'
    WHERE status = 'ACTIVE'
      AND valid_until < CURRENT_DATE;
END;
$$ LANGUAGE plpgsql;

-- Function to auto-expire old suitability assessments
CREATE OR REPLACE FUNCTION expire_old_suitability_assessments()
RETURNS void AS $$
BEGIN
    UPDATE customer_suitability_assessments
    SET status = 'EXPIRED'
    WHERE status = 'ACTIVE'
      AND valid_until < CURRENT_DATE;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- 12. INDEXES FOR PERFORMANCE
-- ============================================================================

-- Additional composite indexes for common queries
CREATE INDEX idx_risk_profiles_customer_status ON customer_risk_profiles(customer_id, status);
CREATE INDEX idx_suitability_customer_status ON customer_suitability_assessments(customer_id, status);
CREATE INDEX idx_goals_customer_status ON customer_goals(customer_id, status);
CREATE INDEX idx_orders_customer_status ON orders(customer_id, status);
CREATE INDEX idx_simulations_goal_portfolio ON monte_carlo_simulations(goal_id, portfolio_id);

-- Full-text search indexes
CREATE INDEX idx_users_name_search ON users USING gin(to_tsvector('english', first_name || ' ' || last_name));
CREATE INDEX idx_portfolios_name_search ON modern_portfolios USING gin(to_tsvector('english', portfolio_name || ' ' || description));

-- ============================================================================
-- END OF SCHEMA
-- ============================================================================

-- Display table count
SELECT
    schemaname,
    COUNT(*) AS table_count
FROM pg_tables
WHERE schemaname = 'public'
GROUP BY schemaname;

-- Display summary
SELECT
    'Database schema created successfully!' AS status,
    COUNT(*) AS total_tables
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE';
