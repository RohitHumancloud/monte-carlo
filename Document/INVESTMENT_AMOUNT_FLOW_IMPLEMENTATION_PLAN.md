# Investment Amount Flow - Complete Implementation Plan

**Date**: January 8, 2026
**Purpose**: Implement realistic investment execution flow with asset value tracking for demo
**Status**: Ready for Implementation

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Research Summary - 2026 Updates](#2-research-summary---2026-updates)
3. [Business Requirements](#3-business-requirements)
4. [System Architecture](#4-system-architecture)
5. [Database Schema Extensions](#5-database-schema-extensions)
6. [Demo Scenario - 10 Customers](#6-demo-scenario---10-customers)
7. [Investment Execution Flow](#7-investment-execution-flow)
8. [Asset Value Tracking & NAV Updates](#8-asset-value-tracking--nav-updates)
9. [Backend API Specifications](#9-backend-api-specifications)
10. [Frontend Dashboard Requirements](#10-frontend-dashboard-requirements)
11. [Implementation Phases](#11-implementation-phases)
12. [Testing Strategy](#12-testing-strategy)
13. [Production Transition Plan](#13-production-transition-plan)

---

## 1. Executive Summary

### 1.1 Overview

This implementation plan details the **Investment Amount Flow** - the critical post-proposal execution phase where:
- Customer approves RM's proposal
- Funds are invested into selected mutual funds
- Asset values are tracked over time with NAV changes
- Customers see real-time portfolio value with growth/decline percentages

### 1.2 Key Objectives

**For Demo (Phase 1)**:
- ✅ Simulate realistic investment behavior for 10 customers
- ✅ Track asset purchases and value changes over time
- ✅ Show growth/decline based on simulated market conditions
- ✅ Provide complete audit trail and reconciliation
- ✅ Create impressive customer dashboard with live portfolio valuation

**For Production (Phase 2)**:
- 🔄 Replace mock custodian with client's real custodian API
- 🔄 Integrate with actual NAV data provider
- 🔄 Implement compliance and regulatory checks
- 🔄 Add real settlement and clearing processes

### 1.3 Solution Approach

**Hybrid Architecture**: Internal Mock Custodian + External NAV Data

```
┌──────────────────────────────────────────────────────────────┐
│                  GBS Application                              │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  Investment Execution Engine (Your Implementation)           │
│  ├─ Order Management                                         │
│  ├─ Mock Custodian (Simulated Execution)                     │
│  ├─ Holdings Tracker                                         │
│  └─ Portfolio Valuation Service                              │
│         │                  │                                  │
│         ↓                  ↓                                  │
│  ┌─────────────┐    ┌──────────────────┐                    │
│  │ Transaction │    │  NAV Data Feed   │                    │
│  │  Database   │    │ (Free API/Mock)  │                    │
│  └─────────────┘    └──────────────────┘                    │
│                                                               │
└──────────────────────────────────────────────────────────────┘
```

---

## 2. Research Summary - 2026 Updates

### 2.1 Custodian Services & Reconciliation

Based on latest 2026 research:

**Key Findings**:

1. **Automated Reconciliation** ([Finartis Prospero](https://www.finartis.com/product-features/custodian-interfaces-reconciliation-4/))
   - Prospero automatically consolidates data from thousands of custodians
   - Enables automatic reconciliation and posting
   - Streamlines trade settlement, deal confirmation, and position reconciliation

2. **Global Custodian Capabilities** ([BNY Custody](https://www.bny.com/corporate/global/en/solutions/platforms/custody-solutions.html))
   - Real-time data insights with settlement process guidance
   - Contractual settlement models reduce intraday risk
   - Automated FX capabilities enhance funding and execution

3. **Investment Reconciliation Process** ([Limina](https://www.limina.com/blog/investment-reconciliation))
   - Ensures internal portfolio views match custodian records
   - Three-way reconciliation: Asset Manager ↔ Fund Admin ↔ Custodian
   - Focus on trade, position, cash, and NAV reconciliation

4. **NAV and P&L Reconciliation** ([Limina NAV Guide](https://www.limina.com/blog/pnl-and-nav-reconciliation-guide))
   - Daily NAV calculation verification
   - Ensure pricing accuracy and corporate actions are reflected
   - Automated break detection and resolution

**Regulatory Note**: FCA has unveiled new rules for stablecoins and crypto custody in 2026, requiring firms to prepare for higher capital requirements and strengthen safeguarding controls.

### 2.2 NAV Data APIs (2026 Options)

#### Production-Grade APIs

1. **FactSet Funds API** ([FactSet Developer](https://developer.factset.com/api-catalog/factset-funds-api))
   - Fund Prices (NAV) for requested date ranges
   - Fund NAV Returns over time-series
   - Professional-grade, enterprise solution

2. **Xignite NAVs API** ([Xignite Mutual Funds](https://www.xignite.com/Product/mutual-fund-navs))
   - Daily end-of-day NAV data for U.S. mutual funds
   - Accurate pricing for portfolio valuation
   - Research and analysis support
   - **Test capability available**

3. **QUODD NAVs API** ([QUODD Mutual Funds](https://www.quodd.com/mutual-funds-data/))
   - Daily end-of-day NAV updates
   - Portfolio pricing and performance analysis
   - **Test API access for integration testing**

#### Free/Demo APIs (Recommended for Demo)

4. **MFapi.in** ([India Mutual Funds](https://www.mfapi.in/))
   - ✅ **FREE** - No API key required
   - ✅ Historical NAV data for all Indian mutual funds
   - ✅ Daily automatic updates
   - ✅ Simple REST API with JSON responses
   - ✅ Interactive Swagger UI for testing
   - **Perfect for demo with Indian mutual fund data**

5. **RapidAPI - Mutual Fund NAV** ([RapidAPI MF NAV](https://rapidapi.com/deep_var35/api/mutual-fund-nav-info-and-historic-data))
   - Latest NAV and historic data
   - Response time in milliseconds
   - Scheme-based queries with date support

6. **RapidAPI - Latest Mutual Fund NAV** ([RapidAPI Latest NAV](https://rapidapi.com/suneetk92/api/latest-mutual-fund-nav/details))
   - Latest NAV data for Indian mutual funds
   - Simple integration

### 2.3 Real-Time Portfolio Tracking APIs

Based on 2026 research ([Top Free APIs](https://steadyapi.com/blogs/top-8-free-financial-data-apis-for-building-a-powerful-stock-portfolio)):

1. **SteadyAPI**
   - Real-time and historical market data
   - Options data, technical indicators
   - Well-documented API

2. **Polygon.io** (now **Massive**) ([Stock API](https://polygon.io/))
   - Real-time and historical tick data
   - Unlimited usage via REST/WebSockets
   - Free tier with instant access
   - JSON and CSV formats

3. **Finnhub**
   - Real-time data for major exchanges
   - API Explorer for testing
   - International market coverage

4. **Marketstack**
   - Real-time and historical data
   - Broad exchange coverage
   - Scalable plans

**Key Capabilities** for portfolio tracking:
- Real-time stock data for live monitoring
- Historical prices for performance analysis
- Portfolio analysis for diversified holdings
- Most trackers refresh every 30-60 seconds during market hours

### 2.4 Recommendation for Demo

**Primary Approach**:
- ✅ Use **MFapi.in** for Indian mutual fund NAV data (FREE, no auth required)
- ✅ Build **internal mock custodian** for order execution simulation
- ✅ Store **NAV price history** in database
- ✅ Create **holdings tracker** with FIFO/Average cost calculation
- ✅ Implement **daily NAV update job** to fetch latest prices

**Why This Works**:
- No cost for demo
- Real mutual fund data (not completely fake)
- Simple integration
- Can be replaced with client's custodian in production
- Complete control over execution flow

---

## 3. Business Requirements

### 3.1 User Story

**As a Customer**, after my RM's proposal is approved:
- I want to see my investment being executed into the recommended mutual funds
- I want to track my portfolio value as it changes with market conditions
- I want to see my gains/losses in both absolute amount and percentage
- I want to see breakdown by fund, asset class, and goal

**As an RM**, after customer approves my proposal:
- I want to execute the investment orders on behalf of the customer
- I want to track order execution status and settlement
- I want to see customer's portfolio performance
- I want to reconcile holdings with fund house records

### 3.2 Detailed Requirements

#### Demo Requirements (10 Customers)

| Customer # | Proposal Approved | Investment Started | Initial Investment | Monthly SIP | Portfolio Type |
|------------|-------------------|-------------------|-------------------|-------------|----------------|
| 1 | 2025-01-01 | 2025-01-05 | $100,000 | $1,000 | Balanced |
| 2 | 2025-01-05 | 2025-01-10 | $150,000 | $2,000 | Aggressive |
| 3 | 2025-01-08 | 2025-01-12 | $80,000 | $1,500 | Conservative |
| 4 | 2025-01-10 | 2025-01-15 | $200,000 | $3,000 | Aggressive |
| 5 | 2025-01-12 | 2025-01-18 | $120,000 | $1,200 | Balanced |
| 6 | 2025-01-15 | 2025-01-20 | $90,000 | $1,000 | Income |
| 7 | 2025-01-18 | 2025-01-22 | $110,000 | $1,500 | Balanced |
| 8 | 2025-01-20 | 2025-01-25 | $75,000 | $800 | Conservative |
| 9 | 2025-01-22 | 2025-01-28 | $180,000 | $2,500 | Aggressive |
| 10 | 2025-01-25 | 2025-02-01 | $130,000 | $1,800 | Balanced |

**Total**: $1,335,000 initial + $16,300/month

#### Asset Value Tracking Requirements

1. **Purchase Tracking**:
   - Record NAV at time of purchase
   - Track quantity of units purchased
   - Calculate average cost per unit
   - Store transaction date and amount

2. **NAV Updates**:
   - Fetch latest NAV daily (or use mock data)
   - Update current value of all holdings
   - Calculate unrealized gains/losses
   - Track percentage changes

3. **Dashboard Display**:
   - Current portfolio value (live)
   - Total invested amount
   - Absolute gain/loss (current - invested)
   - Percentage gain/loss ((current - invested) / invested × 100)
   - Breakdown by:
     - Individual fund
     - Asset class (Equity, Debt, Gold)
     - Goal
   - Time-series chart showing portfolio growth

### 3.3 Example Scenario

**Customer: Sujit Rujuk**
- **Proposal Approved**: Jan 1, 2025
- **Investment Date**: Jan 5, 2025
- **Initial Investment**: $100,000
- **Monthly SIP**: $1,000 (starts Feb 5, 2025)

**Purchases on Jan 5, 2025**:
| Fund | Amount | NAV on Jan 5 | Units |
|------|--------|--------------|-------|
| HDFC Top 100 | $30,000 | $500 | 60 |
| ICICI Bluechip | $25,000 | $250 | 100 |
| SBI Debt Fund | $40,000 | $100 | 400 |
| Gold ETF | $5,000 | $50 | 100 |

**NAV on March 5, 2025** (2 months later):
| Fund | NAV on Mar 5 | Units | Current Value | Invested | Gain/Loss | % Change |
|------|--------------|-------|---------------|----------|-----------|----------|
| HDFC Top 100 | $550 | 60 | $33,000 | $30,000 | +$3,000 | +10% |
| ICICI Bluechip | $275 | 100 | $27,500 | $25,000 | +$2,500 | +10% |
| SBI Debt Fund | $103 | 400 | $41,200 | $40,000 | +$1,200 | +3% |
| Gold ETF | $52 | 100 | $5,200 | $5,000 | +$200 | +4% |
| **Total** | - | - | **$106,900** | **$100,000** | **+$6,900** | **+6.9%** |

**Including Monthly SIPs** (Feb 5 + Mar 5):
- Feb 5: Invested $1,000 (purchased at Feb 5 NAVs)
- Mar 5: Invested $1,000 (purchased at Mar 5 NAVs)
- **Total Invested**: $102,000
- **Current Value**: $107,800 (example)
- **Gain**: +$5,800 (+5.69%)

---

## 4. System Architecture

### 4.1 High-Level Architecture

```
┌────────────────────────────────────────────────────────────────────┐
│                         Frontend (Angular 19)                       │
├────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Customer Portal                    RM Portal                      │
│  ├─ Portfolio Dashboard             ├─ Order Execution Dashboard   │
│  ├─ Holdings View                   ├─ Customer Portfolio View     │
│  ├─ Transaction History             ├─ Order Management            │
│  └─ Performance Charts              └─ Reconciliation Dashboard    │
│                                                                     │
└──────────────────┬──────────────────────────────────┬──────────────┘
                   │                                  │
                   │ REST APIs                        │
                   ↓                                  ↓
┌────────────────────────────────────────────────────────────────────┐
│                    Backend (Spring Boot)                            │
├────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌──────────────────────────────────────────────────────────────┐ │
│  │           Investment Execution Service                        │ │
│  │  • Order Creation & Validation                                │ │
│  │  • Mock Custodian Integration                                 │ │
│  │  • Holdings Management                                        │ │
│  │  • Portfolio Valuation                                        │ │
│  └──────────────────────────────────────────────────────────────┘ │
│                   │              │              │                  │
│                   ↓              ↓              ↓                  │
│  ┌─────────────────┐  ┌──────────────────┐  ┌─────────────────┐  │
│  │  Order Service  │  │ Holdings Service  │  │ Valuation Svc  │  │
│  └─────────────────┘  └──────────────────┘  └─────────────────┘  │
│                   │              │              │                  │
│                   ↓              ↓              ↓                  │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │               PostgreSQL Database                           │  │
│  │  • investment_orders        • holdings                      │  │
│  │  • order_executions         • fund_nav_history             │  │
│  │  • transactions             • reconciliation_log            │  │
│  └────────────────────────────────────────────────────────────┘  │
│                   │                              │                 │
└───────────────────┼──────────────────────────────┼─────────────────┘
                    │                              │
                    ↓                              ↓
        ┌───────────────────────┐    ┌────────────────────────┐
        │  Mock Custodian API   │    │  NAV Data Provider     │
        │  (Your Implementation)│    │  (MFapi.in or Mock)    │
        │  • Instant Execution  │    │  • Daily NAV Updates   │
        │  • Confirmations      │    │  • Historical Data     │
        └───────────────────────┘    └────────────────────────┘
```

### 4.2 Component Responsibilities

#### 4.2.1 Order Service
- Create investment orders from approved proposals
- Validate order prerequisites (funds, limits, compliance)
- Submit orders to Mock Custodian
- Track order lifecycle (Created → Executed → Settled)
- Generate confirmations

#### 4.2.2 Mock Custodian Service
- Simulate instant order execution (for demo)
- Return execution confirmation with:
  - Execution ID
  - Executed NAV
  - Units purchased
  - Transaction ID
  - Timestamp
- Provide settlement confirmation (T+0 for demo, T+1 for realism)

#### 4.2.3 Holdings Service
- Maintain customer holdings by fund
- Track quantity, average cost, current value
- Support FIFO or Average Cost method
- Update holdings on every transaction
- Calculate unrealized gains/losses

#### 4.2.4 Valuation Service
- Fetch latest NAV from data provider
- Update current value of all holdings
- Calculate portfolio-level metrics:
  - Total invested
  - Current value
  - Absolute gain/loss
  - Percentage gain/loss
- Breakdown by fund, asset class, goal

#### 4.2.5 NAV Data Service
- Fetch NAV from MFapi.in or other provider
- Cache NAV data
- Store historical NAV for backtesting
- Scheduled job: Daily NAV update (9 PM IST)

#### 4.2.6 Reconciliation Service
- Compare internal holdings vs custodian records
- Flag discrepancies
- Generate reconciliation reports
- For demo: Mock custodian = internal, so always matches

---

## 5. Database Schema Extensions

### 5.1 New Tables for Investment Execution

```sql
-- ============================================================================
-- INVESTMENT EXECUTION MODULE
-- ============================================================================

-- Investment Orders
CREATE TABLE investment_orders (
    id BIGSERIAL PRIMARY KEY,
    order_code VARCHAR(50) UNIQUE NOT NULL,

    -- References
    proposal_id BIGINT REFERENCES proposals(id),
    goal_id BIGINT REFERENCES customer_goals(id),
    customer_id BIGINT NOT NULL REFERENCES customers(id),
    rm_id BIGINT NOT NULL REFERENCES relationship_managers(id),
    portfolio_id BIGINT REFERENCES modern_portfolios(id),

    -- Order Details
    order_type VARCHAR(20) NOT NULL CHECK (order_type IN ('LUMPSUM', 'SIP')),
    total_amount DECIMAL(15,2) NOT NULL,
    order_status VARCHAR(30) NOT NULL DEFAULT 'CREATED',

    -- Timestamps
    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    executed_at TIMESTAMP,
    settled_at TIMESTAMP,

    -- Audit
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_order_status CHECK (
        order_status IN ('CREATED', 'VALIDATED', 'SUBMITTED', 'EXECUTED',
                         'PARTIALLY_EXECUTED', 'SETTLED', 'FAILED', 'CANCELLED')
    ),
    CONSTRAINT chk_total_amount CHECK (total_amount > 0)
);

CREATE INDEX idx_investment_orders_customer ON investment_orders(customer_id);
CREATE INDEX idx_investment_orders_status ON investment_orders(order_status);
CREATE INDEX idx_investment_orders_proposal ON investment_orders(proposal_id);

-- Order Executions (Individual fund purchases within an order)
CREATE TABLE order_executions (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES investment_orders(id) ON DELETE CASCADE,

    -- Fund Details
    fund_id BIGINT REFERENCES portfolio_securities(id),
    fund_code VARCHAR(50) NOT NULL,
    fund_name VARCHAR(255) NOT NULL,
    fund_isin VARCHAR(50),
    asset_class_id BIGINT REFERENCES asset_classes(id),

    -- Execution Details
    execution_id VARCHAR(100) UNIQUE NOT NULL,  -- From custodian
    allocation_percentage DECIMAL(5,2) NOT NULL,
    invested_amount DECIMAL(15,2) NOT NULL,
    executed_nav DECIMAL(15,4) NOT NULL,  -- NAV at execution time
    units_purchased DECIMAL(15,4) NOT NULL,

    -- Fees & Charges
    brokerage DECIMAL(10,2) DEFAULT 0,
    gst DECIMAL(10,2) DEFAULT 0,
    stamp_duty DECIMAL(10,2) DEFAULT 0,
    total_charges DECIMAL(10,2) DEFAULT 0,
    net_amount DECIMAL(15,2) NOT NULL,  -- invested_amount + charges

    -- Status
    execution_status VARCHAR(20) NOT NULL DEFAULT 'EXECUTED',
    settlement_status VARCHAR(20) NOT NULL DEFAULT 'PENDING',

    -- Custodian Details
    transaction_id VARCHAR(100),
    confirmation_number VARCHAR(100),
    custodian_reference VARCHAR(100),

    -- Timestamps
    execution_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    settlement_date DATE,
    settled_at TIMESTAMP,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_execution_status CHECK (
        execution_status IN ('EXECUTED', 'PARTIALLY_EXECUTED', 'FAILED')
    ),
    CONSTRAINT chk_settlement_status CHECK (
        settlement_status IN ('PENDING', 'IN_PROGRESS', 'SETTLED', 'FAILED')
    ),
    CONSTRAINT chk_allocation CHECK (allocation_percentage >= 0 AND allocation_percentage <= 100),
    CONSTRAINT chk_invested_amount CHECK (invested_amount > 0),
    CONSTRAINT chk_executed_nav CHECK (executed_nav > 0),
    CONSTRAINT chk_units CHECK (units_purchased > 0)
);

CREATE INDEX idx_executions_order ON order_executions(order_id);
CREATE INDEX idx_executions_fund ON order_executions(fund_code);
CREATE INDEX idx_executions_customer_fund ON order_executions(fund_code, execution_time);

-- Holdings (Current positions)
CREATE TABLE holdings (
    id BIGSERIAL PRIMARY KEY,

    -- References
    customer_id BIGINT NOT NULL REFERENCES customers(id),
    goal_id BIGINT REFERENCES customer_goals(id),
    fund_code VARCHAR(50) NOT NULL,
    fund_name VARCHAR(255) NOT NULL,
    fund_isin VARCHAR(50),
    asset_class_id BIGINT REFERENCES asset_classes(id),
    portfolio_id BIGINT REFERENCES modern_portfolios(id),

    -- Holdings Data
    total_units DECIMAL(15,4) NOT NULL DEFAULT 0,
    average_nav DECIMAL(15,4) NOT NULL,  -- Average purchase price per unit
    total_invested DECIMAL(15,2) NOT NULL,  -- Total amount invested

    -- Current Valuation (updated daily)
    current_nav DECIMAL(15,4),  -- Latest NAV
    current_value DECIMAL(15,2),  -- total_units × current_nav

    -- Gains/Losses
    unrealized_gain DECIMAL(15,2),  -- current_value - total_invested
    unrealized_gain_percentage DECIMAL(8,4),  -- (unrealized_gain / total_invested) × 100

    -- Metadata
    first_purchase_date DATE NOT NULL,
    last_purchase_date DATE,
    last_nav_update_date DATE,
    purchase_count INT DEFAULT 0,

    -- Audit
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_units CHECK (total_units >= 0),
    CONSTRAINT chk_invested CHECK (total_invested >= 0),
    CONSTRAINT uq_customer_fund_goal UNIQUE (customer_id, fund_code, goal_id)
);

CREATE INDEX idx_holdings_customer ON holdings(customer_id);
CREATE INDEX idx_holdings_fund ON holdings(fund_code);
CREATE INDEX idx_holdings_goal ON holdings(goal_id);
CREATE INDEX idx_holdings_customer_goal ON holdings(customer_id, goal_id);

-- Transactions (Complete audit trail)
CREATE TABLE transactions (
    id BIGSERIAL PRIMARY KEY,
    transaction_code VARCHAR(50) UNIQUE NOT NULL,

    -- References
    customer_id BIGINT NOT NULL REFERENCES customers(id),
    goal_id BIGINT REFERENCES customer_goals(id),
    order_id BIGINT REFERENCES investment_orders(id),
    execution_id BIGINT REFERENCES order_executions(id),
    holding_id BIGINT REFERENCES holdings(id),

    -- Transaction Details
    transaction_type VARCHAR(20) NOT NULL,
    transaction_date DATE NOT NULL,
    transaction_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Fund Details
    fund_code VARCHAR(50) NOT NULL,
    fund_name VARCHAR(255) NOT NULL,

    -- Amounts
    units DECIMAL(15,4),
    nav DECIMAL(15,4),
    amount DECIMAL(15,2) NOT NULL,
    charges DECIMAL(10,2) DEFAULT 0,
    net_amount DECIMAL(15,2),

    -- Status
    status VARCHAR(20) NOT NULL,

    -- Audit
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_transaction_type CHECK (
        transaction_type IN ('BUY', 'SELL', 'DIVIDEND', 'BONUS',
                             'SPLIT', 'MERGER', 'SWITCH', 'SIP')
    ),
    CONSTRAINT chk_transaction_status CHECK (
        status IN ('PENDING', 'CONFIRMED', 'SETTLED', 'FAILED', 'CANCELLED')
    )
);

CREATE INDEX idx_transactions_customer ON transactions(customer_id);
CREATE INDEX idx_transactions_fund ON transactions(fund_code);
CREATE INDEX idx_transactions_date ON transactions(transaction_date DESC);
CREATE INDEX idx_transactions_type ON transactions(transaction_type);

-- Fund NAV History (For historical tracking and charts)
CREATE TABLE fund_nav_history (
    id BIGSERIAL PRIMARY KEY,

    -- Fund Details
    fund_code VARCHAR(50) NOT NULL,
    fund_name VARCHAR(255) NOT NULL,
    fund_isin VARCHAR(50),
    scheme_type VARCHAR(50),  -- EQUITY, DEBT, HYBRID, etc.

    -- NAV Data
    nav_date DATE NOT NULL,
    nav DECIMAL(15,4) NOT NULL,

    -- Data Source
    data_source VARCHAR(50) DEFAULT 'MFAPI',  -- MFAPI, AMFI, MANUAL, etc.
    fetched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Audit
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_nav CHECK (nav > 0),
    CONSTRAINT uq_fund_date UNIQUE (fund_code, nav_date)
);

CREATE INDEX idx_nav_history_fund ON fund_nav_history(fund_code);
CREATE INDEX idx_nav_history_date ON fund_nav_history(nav_date DESC);
CREATE INDEX idx_nav_history_fund_date ON fund_nav_history(fund_code, nav_date DESC);

-- Reconciliation Log
CREATE TABLE reconciliation_log (
    id BIGSERIAL PRIMARY KEY,
    reconciliation_date DATE NOT NULL,
    reconciliation_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Scope
    customer_id BIGINT REFERENCES customers(id),
    fund_code VARCHAR(50),

    -- Comparison
    entity_type VARCHAR(30) NOT NULL,  -- HOLDINGS, TRANSACTIONS, NAV
    internal_value DECIMAL(15,4),
    custodian_value DECIMAL(15,4),
    variance DECIMAL(15,4),
    variance_percentage DECIMAL(8,4),

    -- Status
    status VARCHAR(20) NOT NULL,
    break_reason TEXT,
    resolution_notes TEXT,
    resolved_by BIGINT REFERENCES users(id),
    resolved_at TIMESTAMP,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_recon_entity CHECK (
        entity_type IN ('HOLDINGS', 'TRANSACTIONS', 'NAV', 'CASH')
    ),
    CONSTRAINT chk_recon_status CHECK (
        status IN ('MATCHED', 'BREAK', 'INVESTIGATING', 'RESOLVED', 'EXCEPTION')
    )
);

CREATE INDEX idx_recon_date ON reconciliation_log(reconciliation_date DESC);
CREATE INDEX idx_recon_status ON reconciliation_log(status);
CREATE INDEX idx_recon_customer ON reconciliation_log(customer_id);

-- SIP Schedules (For recurring investments)
CREATE TABLE sip_schedules (
    id BIGSERIAL PRIMARY KEY,
    sip_code VARCHAR(50) UNIQUE NOT NULL,

    -- References
    customer_id BIGINT NOT NULL REFERENCES customers(id),
    goal_id BIGINT REFERENCES customer_goals(id),
    portfolio_id BIGINT REFERENCES modern_portfolios(id),
    source_order_id BIGINT REFERENCES investment_orders(id),

    -- SIP Details
    sip_amount DECIMAL(15,2) NOT NULL,
    sip_date INT NOT NULL,  -- Day of month (1-28)
    frequency VARCHAR(20) NOT NULL DEFAULT 'MONTHLY',

    -- Schedule
    start_date DATE NOT NULL,
    end_date DATE,
    next_execution_date DATE NOT NULL,

    -- Status
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    pause_reason TEXT,
    cancelled_reason TEXT,

    -- Execution Tracking
    total_installments_executed INT DEFAULT 0,
    total_amount_invested DECIMAL(15,2) DEFAULT 0,
    last_execution_date DATE,

    -- Audit
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_sip_date CHECK (sip_date >= 1 AND sip_date <= 28),
    CONSTRAINT chk_sip_frequency CHECK (
        frequency IN ('MONTHLY', 'QUARTERLY', 'SEMI_ANNUAL', 'ANNUAL')
    ),
    CONSTRAINT chk_sip_status CHECK (
        status IN ('ACTIVE', 'PAUSED', 'CANCELLED', 'COMPLETED')
    ),
    CONSTRAINT chk_sip_amount CHECK (sip_amount > 0)
);

CREATE INDEX idx_sip_customer ON sip_schedules(customer_id);
CREATE INDEX idx_sip_status ON sip_schedules(status);
CREATE INDEX idx_sip_next_execution ON sip_schedules(next_execution_date)
    WHERE status = 'ACTIVE';
```

### 5.2 Schema Summary

**New Tables**: 7
1. `investment_orders` - Order headers
2. `order_executions` - Individual fund purchases
3. `holdings` - Current positions with valuations
4. `transactions` - Complete audit trail
5. `fund_nav_history` - Historical NAV data
6. `reconciliation_log` - Reconciliation tracking
7. `sip_schedules` - Recurring investment automation

**Total Columns**: ~130 across all tables

---

## 6. Demo Scenario - 10 Customers

### 6.1 Customer Selection

Select 10 diverse customers from seed data with different risk profiles and portfolios:

| # | Customer Name | Risk Score | Risk Category | Portfolio | Goal Type | Proposal Date | Investment Date |
|---|---------------|------------|---------------|-----------|-----------|---------------|-----------------|
| 1 | Sujit Rujuk | 28 | AGGRESSIVE | Aggressive Growth | Retirement | 2025-01-01 | 2025-01-05 |
| 2 | Priya Sharma | 35 | AGGRESSIVE | Speculative | Education | 2025-01-05 | 2025-01-10 |
| 3 | Amit Verma | 15 | CONSERVATIVE | Conservative Income | Home Purchase | 2025-01-08 | 2025-01-12 |
| 4 | Ravi Kumar | 40 | SPECULATIVE | Speculative | Wealth Creation | 2025-01-10 | 2025-01-15 |
| 5 | Neha Patel | 26 | BALANCE | Balanced | Retirement | 2025-01-12 | 2025-01-18 |
| 6 | Arjun Singh | 20 | INCOME | Income Focus | Debt Repayment | 2025-01-15 | 2025-01-20 |
| 7 | Kavita Desai | 30 | AGGRESSIVE | Aggressive Growth | Marriage | 2025-01-18 | 2025-01-22 |
| 8 | Rajesh Iyer | 12 | CONSERVATIVE | Secure | Emergency Fund | 2025-01-20 | 2025-01-25 |
| 9 | Sneha Reddy | 38 | AGGRESSIVE | Speculative | Business | 2025-01-22 | 2025-01-28 |
| 10 | Vikram Malhotra | 24 | BALANCE | Balanced | Vehicle | 2025-01-25 | 2025-02-01 |

### 6.2 Portfolio Allocations

Example: **Customer 1 - Sujit Rujuk (Aggressive Portfolio)**

**Initial Investment**: ₹1,00,000
**Monthly SIP**: ₹1,000
**Portfolio**: Aggressive (80% Equity / 20% Debt)

| Fund | Category | Allocation % | Amount (₹) | NAV on Jan 5 | Units |
|------|----------|--------------|-----------|--------------|-------|
| HDFC Top 100 Fund | Large Cap Equity | 30% | 30,000 | 500.00 | 60.0000 |
| ICICI Pru Bluechip | Large Cap Equity | 25% | 25,000 | 250.00 | 100.0000 |
| Axis Midcap Fund | Mid Cap Equity | 15% | 15,000 | 150.00 | 100.0000 |
| SBI Small Cap Fund | Small Cap Equity | 10% | 10,000 | 100.00 | 100.0000 |
| HDFC Corporate Bond | Debt | 15% | 15,000 | 50.00 | 300.0000 |
| Kotak Liquid Fund | Debt | 5% | 5,000 | 25.00 | 200.0000 |
| **Total** | | **100%** | **₹1,00,000** | | |

### 6.3 NAV Movement Simulation

**Simulated NAV Changes (Jan 5 to Mar 8, 2025)**:

```
Date Range: Jan 5 → Mar 8 (2 months)
Market Scenario: Moderate Bull Run
Equity Gain: +8% to +12%
Debt Gain: +2% to +4%
```

| Fund | NAV Jan 5 | NAV Mar 8 | Change % | Sujit's Units | Invested | Current Value | Gain |
|------|-----------|-----------|----------|---------------|----------|---------------|------|
| HDFC Top 100 | 500.00 | 555.00 | +11% | 60.0000 | 30,000 | 33,300 | +3,300 |
| ICICI Bluechip | 250.00 | 275.00 | +10% | 100.0000 | 25,000 | 27,500 | +2,500 |
| Axis Midcap | 150.00 | 168.00 | +12% | 100.0000 | 15,000 | 16,800 | +1,800 |
| SBI Small Cap | 100.00 | 108.00 | +8% | 100.0000 | 10,000 | 10,800 | +800 |
| HDFC Corp Bond | 50.00 | 51.50 | +3% | 300.0000 | 15,000 | 15,450 | +450 |
| Kotak Liquid | 25.00 | 25.75 | +3% | 200.0000 | 5,000 | 5,150 | +150 |
| **Total** | | | **+9.0%** | | **₹1,00,000** | **₹1,09,000** | **+₹9,000** |

**Including 2 SIP Installments** (Feb 5 + Mar 5):
- Feb 5 SIP: ₹1,000 (purchased at higher NAVs)
- Mar 5 SIP: ₹1,000 (purchased at even higher NAVs)
- **Total Invested**: ₹1,02,000
- **Current Value**: ₹1,10,500 (example with SIP added)
- **Gain**: +₹8,500 (+8.33%)

### 6.4 Complete Demo Data Timeline

```
2025-01-01: Customer 1 - Proposal Approved
2025-01-05: Customer 1 - Initial Investment ₹1,00,000 executed
            Customer 2 - Proposal Approved
2025-01-08: Customer 3 - Proposal Approved
2025-01-10: Customer 2 - Initial Investment ₹1,50,000 executed
            Customer 4 - Proposal Approved
2025-01-12: Customer 3 - Initial Investment ₹80,000 executed
            Customer 5 - Proposal Approved
2025-01-15: Customer 4 - Initial Investment ₹2,00,000 executed
            Customer 6 - Proposal Approved
2025-01-18: Customer 5 - Initial Investment ₹1,20,000 executed
            Customer 7 - Proposal Approved
2025-01-20: Customer 6 - Initial Investment ₹90,000 executed
            Customer 8 - Proposal Approved
2025-01-22: Customer 7 - Initial Investment ₹1,10,000 executed
            Customer 9 - Proposal Approved
2025-01-25: Customer 8 - Initial Investment ₹75,000 executed
            Customer 10 - Proposal Approved
2025-01-28: Customer 9 - Initial Investment ₹1,80,000 executed
2025-02-01: Customer 10 - Initial Investment ₹1,30,000 executed

2025-02-05: Customer 1 - First SIP ₹1,000
2025-02-10: Customer 2 - First SIP ₹2,000
... (and so on)

Daily: NAV updates fetched (or mock data inserted)
Daily: Portfolio valuations recalculated
```

---

## 7. Investment Execution Flow

### 7.1 Complete Workflow

```
┌─────────────────────────────────────────────────────────────────────┐
│                    INVESTMENT EXECUTION WORKFLOW                     │
└─────────────────────────────────────────────────────────────────────┘

Step 1: PROPOSAL ACCEPTED
    │
    ├─ Customer clicks "Accept Proposal" in portal
    ├─ Proposal.status: PENDING → ACCEPTED
    ├─ Proposal.responded_at: <timestamp>
    └─ Trigger: Investment workflow starts
        │
        ↓
Step 2: ORDER CREATION (Automatic or RM-triggered)
    │
    ├─ Create InvestmentOrder:
    │   • customer_id, goal_id, proposal_id
    │   • order_type: LUMPSUM (initial) or SIP (recurring)
    │   • total_amount: From proposal
    │   • order_status: CREATED
    │   • order_date: <current_timestamp>
    │
    ├─ Extract fund allocations from proposal.distribution_data
    │
    └─ For each fund in distribution:
        └─ Create OrderExecution (sub-order):
            • fund_code, fund_name, allocation_percentage
            • invested_amount: total × allocation %
            • execution_status: PENDING
        │
        ↓
Step 3: ORDER VALIDATION
    │
    ├─ Pre-execution checks:
    │   ✓ Customer has sufficient funds in bank account?
    │   ✓ Funds are valid and available for purchase?
    │   ✓ Order complies with regulatory limits?
    │   ✓ Proposal is still valid (not expired)?
    │
    ├─ If validation fails:
    │   └─ order_status: CREATED → FAILED
    │       rejection_reason: <error message>
    │       Send notification to RM
    │
    └─ If validation passes:
        └─ order_status: CREATED → VALIDATED
        │
        ↓
Step 4: ORDER EXECUTION (Mock Custodian)
    │
    ├─ For each OrderExecution:
    │   │
    │   ├─ Fetch current NAV:
    │   │   • Query fund_nav_history for latest NAV
    │   │   • If not found, fetch from MFapi.in
    │   │   • Store in fund_nav_history
    │   │
    │   ├─ Calculate units:
    │   │   units = invested_amount / NAV
    │   │
    │   ├─ Call Mock Custodian API:
    │   │   POST /api/custodian/execute
    │   │   {
    │   │     "orderId": "ORD-123",
    │   │     "fundCode": "HDFC_TOP100",
    │   │     "amount": 30000,
    │   │     "nav": 500.00
    │   │   }
    │   │
    │   └─ Mock Custodian responds:
    │       {
    │         "executionId": "EXE-456",
    │         "status": "EXECUTED",
    │         "executedNav": 500.00,
    │         "units": 60.0000,
    │         "executionTime": "2025-01-05T10:30:00Z",
    │         "transactionId": "TXN-789",
    │         "confirmationNumber": "CONF-2025-789"
    │       }
    │   │
    │   ├─ Update OrderExecution:
    │   │   • execution_id: "EXE-456"
    │   │   • executed_nav: 500.00
    │   │   • units_purchased: 60.0000
    │   │   • execution_status: EXECUTED
    │   │   • transaction_id: "TXN-789"
    │   │   • confirmation_number: "CONF-2025-789"
    │   │   • execution_time: <timestamp>
    │   │
    │   └─ Create Transaction record:
    │       • transaction_type: BUY
    │       • fund_code, units, nav, amount
    │       • status: CONFIRMED
    │
    └─ Update InvestmentOrder:
        • order_status: VALIDATED → EXECUTED
        • executed_at: <timestamp>
        │
        ↓
Step 5: SETTLEMENT (Simulated T+0 for demo, T+1 for realism)
    │
    ├─ For demo: Instant settlement (T+0)
    ├─ For realism: Schedule settlement for T+1
    │
    ├─ Update OrderExecution:
    │   • settlement_status: PENDING → SETTLED
    │   • settlement_date: <T+1 date>
    │   • settled_at: <timestamp>
    │
    └─ Update InvestmentOrder:
        • order_status: EXECUTED → SETTLED
        • settled_at: <timestamp>
        │
        ↓
Step 6: UPDATE HOLDINGS
    │
    ├─ For each OrderExecution:
    │   │
    │   ├─ Check if Holding exists:
    │   │   WHERE customer_id = X
    │   │     AND fund_code = Y
    │   │     AND goal_id = Z
    │   │
    │   ├─ If exists (subsequent purchase):
    │   │   │
    │   │   ├─ Calculate new average NAV:
    │   │   │   new_avg = (old_invested + new_invested) / (old_units + new_units)
    │   │   │
    │   │   └─ UPDATE holdings:
    │   │       • total_units += new_units
    │   │       • total_invested += invested_amount
    │   │       • average_nav = new_avg
    │   │       • last_purchase_date = <today>
    │   │       • purchase_count += 1
    │   │
    │   └─ If not exists (first purchase):
    │       │
    │       └─ INSERT holding:
    │           • customer_id, goal_id, fund_code, fund_name
    │           • total_units = purchased_units
    │           • average_nav = executed_nav
    │           • total_invested = invested_amount
    │           • first_purchase_date = <today>
    │           • last_purchase_date = <today>
    │           • purchase_count = 1
    │
    └─ Holdings table now reflects updated positions
        │
        ↓
Step 7: VALUATION UPDATE (Triggered by NAV update or on-demand)
    │
    ├─ For each Holding:
    │   │
    │   ├─ Fetch latest NAV from fund_nav_history
    │   │
    │   ├─ Calculate current value:
    │   │   current_value = total_units × current_nav
    │   │
    │   ├─ Calculate unrealized gain:
    │   │   unrealized_gain = current_value - total_invested
    │   │   gain_pct = (unrealized_gain / total_invested) × 100
    │   │
    │   └─ UPDATE holding:
    │       • current_nav = <latest_nav>
    │       • current_value = <calculated>
    │       • unrealized_gain = <calculated>
    │       • unrealized_gain_percentage = <calculated>
    │       • last_nav_update_date = <today>
    │
    └─ Portfolio valuation is now up-to-date
        │
        ↓
Step 8: NOTIFICATIONS & CONFIRMATIONS
    │
    ├─ Send to Customer:
    │   • Email: "Investment Confirmed - ₹1,00,000 invested"
    │   • SMS: "Your investment is confirmed. Track in portal."
    │   • In-app notification
    │
    ├─ Send to RM:
    │   • Notification: "Customer Sujit's investment executed"
    │   • Dashboard update
    │
    └─ Generate documents:
        • Investment confirmation PDF
        • Transaction statement
        │
        ↓
Step 9: SIP SETUP (If applicable)
    │
    ├─ If order_type = LUMPSUM and customer wants monthly SIP:
    │   │
    │   └─ Create SIP Schedule:
    │       • customer_id, goal_id, portfolio_id
    │       • sip_amount: From proposal
    │       • sip_date: 5 (of every month)
    │       • start_date: 2025-02-05
    │       • frequency: MONTHLY
    │       • status: ACTIVE
    │       • next_execution_date: 2025-02-05
    │
    └─ Scheduled job will execute SIPs automatically
        │
        ↓
Step 10: RECONCILIATION (Daily batch job)
    │
    ├─ Compare internal holdings vs custodian records:
    │   • For demo: Mock custodian = internal system
    │   • Always matches (for demo purposes)
    │
    ├─ Create ReconciliationLog:
    │   • entity_type: HOLDINGS
    │   • internal_value: 60.0000 units
    │   • custodian_value: 60.0000 units
    │   • variance: 0
    │   • status: MATCHED
    │
    └─ Flag any discrepancies for investigation
```

### 7.2 State Machine

```
InvestmentOrder Status Flow:
────────────────────────────

CREATED
  ↓
VALIDATED (validation passed)
  ↓
SUBMITTED (sent to custodian - optional for demo)
  ↓
EXECUTED (all funds purchased)
  ↓
SETTLED (settlement complete)

Alternative Paths:
──────────────────
CREATED → FAILED (validation failed)
VALIDATED → CANCELLED (RM cancelled)
EXECUTED → PARTIALLY_EXECUTED (some funds failed)
SETTLED → FAILED (settlement issue)
```

---

## 8. Asset Value Tracking & NAV Updates

### 8.1 NAV Data Provider Integration

#### Option 1: MFapi.in (FREE - Recommended for Demo)

**API Documentation**: https://www.mfapi.in/

**Example Request**:
```http
GET https://api.mfapi.in/mf/{scheme_code}

Example:
GET https://api.mfapi.in/mf/120503
```

**Response**:
```json
{
  "meta": {
    "fund_house": "HDFC Mutual Fund",
    "scheme_type": "Open Ended Schemes",
    "scheme_category": "Equity Scheme - Large Cap Fund",
    "scheme_code": "120503",
    "scheme_name": "HDFC Top 100 Fund - Direct Plan - Growth"
  },
  "data": [
    {
      "date": "08-01-2026",
      "nav": "555.00"
    },
    {
      "date": "07-01-2026",
      "nav": "553.50"
    },
    {
      "date": "06-01-2026",
      "nav": "550.00"
    }
  ],
  "status": "SUCCESS"
}
```

**Implementation**:

```java
// NAVDataService.java

@Service
public class NAVDataService {

    private static final String MFAPI_BASE_URL = "https://api.mfapi.in/mf";

    @Autowired
    private RestTemplate restTemplate;

    @Autowired
    private FundNavHistoryRepository navHistoryRepo;

    /**
     * Fetch latest NAV from MFapi.in
     */
    public BigDecimal fetchLatestNAV(String schemeCode) {
        String url = MFAPI_BASE_URL + "/" + schemeCode;

        try {
            MFApiResponse response = restTemplate.getForObject(url, MFApiResponse.class);

            if (response != null && "SUCCESS".equals(response.getStatus())
                && response.getData() != null && !response.getData().isEmpty()) {

                NavData latestNav = response.getData().get(0);

                // Save to database
                saveFundNavHistory(response.getMeta(), latestNav);

                return new BigDecimal(latestNav.getNav());
            }
        } catch (Exception e) {
            log.error("Failed to fetch NAV for scheme {}: {}", schemeCode, e.getMessage());
        }

        return null;
    }

    /**
     * Fetch historical NAV for a date range
     */
    public List<FundNavHistory> fetchHistoricalNAV(String schemeCode,
                                                     LocalDate fromDate,
                                                     LocalDate toDate) {
        String url = MFAPI_BASE_URL + "/" + schemeCode;

        try {
            MFApiResponse response = restTemplate.getForObject(url, MFApiResponse.class);

            if (response != null && response.getData() != null) {
                List<FundNavHistory> navList = new ArrayList<>();

                for (NavData navData : response.getData()) {
                    LocalDate navDate = parseDate(navData.getDate());

                    if (!navDate.isBefore(fromDate) && !navDate.isAfter(toDate)) {
                        FundNavHistory nav = new FundNavHistory();
                        nav.setFundCode(schemeCode);
                        nav.setFundName(response.getMeta().getSchemeName());
                        nav.setNavDate(navDate);
                        nav.setNav(new BigDecimal(navData.getNav()));
                        nav.setDataSource("MFAPI");

                        navList.add(nav);
                    }
                }

                // Batch save
                navHistoryRepo.saveAll(navList);

                return navList;
            }
        } catch (Exception e) {
            log.error("Failed to fetch historical NAV: {}", e.getMessage());
        }

        return Collections.emptyList();
    }

    /**
     * Get NAV from database or fetch if not available
     */
    public BigDecimal getNAV(String fundCode, LocalDate date) {
        // First check database
        Optional<FundNavHistory> navOpt = navHistoryRepo
            .findByFundCodeAndNavDate(fundCode, date);

        if (navOpt.isPresent()) {
            return navOpt.get().getNav();
        }

        // If not in DB, fetch from API
        fetchLatestNAV(fundCode);

        // Try again
        navOpt = navHistoryRepo.findByFundCodeAndNavDate(fundCode, date);
        return navOpt.map(FundNavHistory::getNav).orElse(null);
    }
}
```

#### Option 2: Mock NAV Data (Fallback)

For funds not available in MFapi.in, generate realistic mock data:

```java
@Service
public class MockNAVGenerator {

    /**
     * Generate realistic NAV movements
     * Based on asset class volatility
     */
    public BigDecimal generateMockNAV(String fundCode,
                                       String assetClass,
                                       LocalDate date,
                                       BigDecimal baseNAV) {

        // Volatility by asset class (annual)
        double volatility = switch (assetClass) {
            case "EQUITY_LARGE_CAP" -> 0.15;  // 15% annual volatility
            case "EQUITY_MID_CAP" -> 0.20;    // 20%
            case "EQUITY_SMALL_CAP" -> 0.25;  // 25%
            case "DEBT" -> 0.03;              // 3%
            case "GOLD" -> 0.12;              // 12%
            default -> 0.10;
        };

        // Daily volatility
        double dailyVolatility = volatility / Math.sqrt(252);  // 252 trading days

        // Random walk (Geometric Brownian Motion)
        Random random = new Random(date.toEpochDay() + fundCode.hashCode());
        double randomReturn = random.nextGaussian() * dailyVolatility;

        // Expected return (annual)
        double expectedReturn = switch (assetClass) {
            case "EQUITY_LARGE_CAP" -> 0.12;  // 12% expected return
            case "EQUITY_MID_CAP" -> 0.14;
            case "EQUITY_SMALL_CAP" -> 0.15;
            case "DEBT" -> 0.07;
            case "GOLD" -> 0.08;
            default -> 0.10;
        };

        double dailyExpectedReturn = expectedReturn / 252;

        // New NAV = Old NAV × (1 + drift + random shock)
        double newNav = baseNAV.doubleValue()
            * (1 + dailyExpectedReturn + randomReturn);

        return BigDecimal.valueOf(newNav).setScale(4, RoundingMode.HALF_UP);
    }

    /**
     * Seed NAV history for backfill
     */
    public void seedNAVHistory(String fundCode,
                                String assetClass,
                                LocalDate startDate,
                                LocalDate endDate,
                                BigDecimal startingNAV) {

        LocalDate currentDate = startDate;
        BigDecimal currentNAV = startingNAV;

        while (!currentDate.isAfter(endDate)) {
            // Skip weekends
            if (currentDate.getDayOfWeek() != DayOfWeek.SATURDAY
                && currentDate.getDayOfWeek() != DayOfWeek.SUNDAY) {

                FundNavHistory nav = new FundNavHistory();
                nav.setFundCode(fundCode);
                nav.setNavDate(currentDate);
                nav.setNav(currentNAV);
                nav.setDataSource("MOCK");

                navHistoryRepo.save(nav);

                // Generate next day's NAV
                currentNAV = generateMockNAV(fundCode, assetClass,
                                              currentDate, currentNAV);
            }

            currentDate = currentDate.plusDays(1);
        }
    }
}
```

### 8.2 Daily NAV Update Job

```java
@Service
public class DailyNAVUpdateJob {

    @Autowired
    private HoldingsRepository holdingsRepo;

    @Autowired
    private NAVDataService navService;

    @Autowired
    private PortfolioValuationService valuationService;

    /**
     * Scheduled job: Daily NAV update at 9 PM IST
     */
    @Scheduled(cron = "0 0 21 * * *", zone = "Asia/Kolkata")
    public void updateDailyNAVs() {
        log.info("Starting daily NAV update job...");

        LocalDate today = LocalDate.now();

        // Get all unique funds from holdings
        List<String> fundCodes = holdingsRepo.findDistinctFundCodes();

        log.info("Fetching NAVs for {} funds", fundCodes.size());

        for (String fundCode : fundCodes) {
            try {
                // Fetch latest NAV
                BigDecimal latestNAV = navService.fetchLatestNAV(fundCode);

                if (latestNAV != null) {
                    log.debug("Updated NAV for {}: {}", fundCode, latestNAV);
                } else {
                    log.warn("Failed to fetch NAV for {}", fundCode);
                }

                // Rate limiting: Sleep 100ms between API calls
                Thread.sleep(100);

            } catch (Exception e) {
                log.error("Error updating NAV for {}: {}", fundCode, e.getMessage());
            }
        }

        log.info("NAV update complete. Now updating portfolio valuations...");

        // Update all customer portfolio valuations
        valuationService.updateAllPortfolioValuations(today);

        log.info("Daily NAV update job completed successfully");
    }

    /**
     * On-demand NAV refresh (e.g., when customer views dashboard)
     */
    public void refreshNAVForCustomer(Long customerId) {
        List<String> customerFunds = holdingsRepo
            .findFundCodesByCustomerId(customerId);

        for (String fundCode : customerFunds) {
            navService.fetchLatestNAV(fundCode);
        }

        valuationService.updateCustomerPortfolioValuation(customerId);
    }
}
```

### 8.3 Portfolio Valuation Service

```java
@Service
public class PortfolioValuationService {

    @Autowired
    private HoldingsRepository holdingsRepo;

    @Autowired
    private FundNavHistoryRepository navHistoryRepo;

    /**
     * Update valuations for all customers
     */
    @Transactional
    public void updateAllPortfolioValuations(LocalDate asOfDate) {
        List<Holdings> allHoldings = holdingsRepo.findAll();

        for (Holdings holding : allHoldings) {
            updateHoldingValuation(holding, asOfDate);
        }

        log.info("Updated {} holdings valuations", allHoldings.size());
    }

    /**
     * Update valuation for a specific customer
     */
    @Transactional
    public void updateCustomerPortfolioValuation(Long customerId) {
        LocalDate today = LocalDate.now();
        List<Holdings> customerHoldings = holdingsRepo
            .findByCustomerId(customerId);

        for (Holdings holding : customerHoldings) {
            updateHoldingValuation(holding, today);
        }
    }

    /**
     * Update a single holding's valuation
     */
    private void updateHoldingValuation(Holdings holding, LocalDate asOfDate) {
        // Fetch latest NAV
        Optional<FundNavHistory> navOpt = navHistoryRepo
            .findByFundCodeAndNavDate(holding.getFundCode(), asOfDate);

        if (navOpt.isEmpty()) {
            // Try previous trading day
            asOfDate = getPreviousTradingDay(asOfDate);
            navOpt = navHistoryRepo.findByFundCodeAndNavDate(
                holding.getFundCode(), asOfDate);
        }

        if (navOpt.isPresent()) {
            BigDecimal currentNAV = navOpt.get().getNav();

            // Calculate current value
            BigDecimal currentValue = holding.getTotalUnits()
                .multiply(currentNAV)
                .setScale(2, RoundingMode.HALF_UP);

            // Calculate unrealized gain
            BigDecimal unrealizedGain = currentValue
                .subtract(holding.getTotalInvested());

            // Calculate percentage
            BigDecimal gainPercentage = unrealizedGain
                .divide(holding.getTotalInvested(), 4, RoundingMode.HALF_UP)
                .multiply(BigDecimal.valueOf(100));

            // Update holding
            holding.setCurrentNav(currentNAV);
            holding.setCurrentValue(currentValue);
            holding.setUnrealizedGain(unrealizedGain);
            holding.setUnrealizedGainPercentage(gainPercentage);
            holding.setLastNavUpdateDate(asOfDate);

            holdingsRepo.save(holding);
        } else {
            log.warn("No NAV found for {} on {}",
                holding.getFundCode(), asOfDate);
        }
    }

    /**
     * Get portfolio summary for customer
     */
    public PortfolioSummaryDto getPortfolioSummary(Long customerId) {
        List<Holdings> holdings = holdingsRepo.findByCustomerId(customerId);

        BigDecimal totalInvested = BigDecimal.ZERO;
        BigDecimal currentValue = BigDecimal.ZERO;

        for (Holdings holding : holdings) {
            totalInvested = totalInvested.add(holding.getTotalInvested());
            currentValue = currentValue.add(holding.getCurrentValue());
        }

        BigDecimal totalGain = currentValue.subtract(totalInvested);
        BigDecimal gainPercentage = totalGain
            .divide(totalInvested, 4, RoundingMode.HALF_UP)
            .multiply(BigDecimal.valueOf(100));

        return PortfolioSummaryDto.builder()
            .customerId(customerId)
            .totalInvested(totalInvested)
            .currentValue(currentValue)
            .absoluteGain(totalGain)
            .percentageGain(gainPercentage)
            .holdingsCount(holdings.size())
            .lastUpdated(LocalDate.now())
            .build();
    }
}
```

---

## 9. Backend API Specifications

### 9.1 Investment Order APIs

#### Create Investment Order (After Proposal Acceptance)

```http
POST /api/v1/investment/orders/create-from-proposal
Authorization: Bearer {jwt}
Content-Type: application/json

Request:
{
  "proposalId": 123,
  "customerId": 456,
  "executionDate": "2025-01-05",
  "autoExecute": true
}

Response (201 Created):
{
  "orderId": 1001,
  "orderCode": "ORD-2025-001001",
  "proposalId": 123,
  "customerId": 456,
  "goalId": 50,
  "portfolioId": 10,
  "orderType": "LUMPSUM",
  "totalAmount": 100000.00,
  "orderStatus": "CREATED",
  "orderDate": "2025-01-05T10:00:00Z",
  "fundOrders": [
    {
      "fundCode": "HDFC_TOP100",
      "fundName": "HDFC Top 100 Fund",
      "allocationPercentage": 30.0,
      "investedAmount": 30000.00,
      "status": "PENDING"
    },
    {
      "fundCode": "ICICI_BLUECHIP",
      "fundName": "ICICI Prudential Bluechip",
      "allocationPercentage": 25.0,
      "investedAmount": 25000.00,
      "status": "PENDING"
    }
  ]
}
```

#### Execute Investment Order

```http
POST /api/v1/investment/orders/{orderId}/execute
Authorization: Bearer {jwt}

Response (200 OK):
{
  "orderId": 1001,
  "orderStatus": "EXECUTED",
  "executedAt": "2025-01-05T10:30:00Z",
  "executions": [
    {
      "executionId": "EXE-2025-456",
      "fundCode": "HDFC_TOP100",
      "fundName": "HDFC Top 100 Fund",
      "investedAmount": 30000.00,
      "executedNAV": 500.00,
      "unitsPurchased": 60.0000,
      "executionStatus": "EXECUTED",
      "transactionId": "TXN-789",
      "confirmationNumber": "CONF-2025-789"
    }
  ],
  "message": "Order executed successfully. Settlement on T+1."
}
```

#### Get Customer's Investment Orders

```http
GET /api/v1/investment/orders/customer/{customerId}
Query Parameters:
  - status (optional): CREATED, EXECUTED, SETTLED
  - fromDate (optional): 2025-01-01
  - toDate (optional): 2025-03-08
  - page (default: 0)
  - size (default: 20)

Response (200 OK):
{
  "content": [
    {
      "orderId": 1001,
      "orderCode": "ORD-2025-001001",
      "orderType": "LUMPSUM",
      "totalAmount": 100000.00,
      "orderStatus": "SETTLED",
      "orderDate": "2025-01-05T10:00:00Z",
      "executedAt": "2025-01-05T10:30:00Z",
      "settledAt": "2025-01-06T11:00:00Z",
      "fundsCount": 6,
      "goalName": "Retirement Planning"
    }
  ],
  "page": 0,
  "size": 20,
  "totalElements": 3,
  "totalPages": 1
}
```

### 9.2 Holdings APIs

#### Get Customer Holdings

```http
GET /api/v1/investment/holdings/customer/{customerId}
Query Parameters:
  - goalId (optional): Filter by goal
  - asOfDate (optional): Valuation date (default: today)

Response (200 OK):
{
  "customerId": 456,
  "customerName": "Sujit Rujuk",
  "asOfDate": "2025-03-08",

  "summary": {
    "totalInvested": 102000.00,
    "currentValue": 110500.00,
    "absoluteGain": 8500.00,
    "percentageGain": 8.33,
    "holdingsCount": 6
  },

  "holdings": [
    {
      "fundCode": "HDFC_TOP100",
      "fundName": "HDFC Top 100 Fund - Direct Growth",
      "assetClass": "EQUITY_LARGE_CAP",
      "totalUnits": 60.0000,
      "averageNAV": 500.00,
      "totalInvested": 30000.00,
      "currentNAV": 555.00,
      "currentValue": 33300.00,
      "unrealizedGain": 3300.00,
      "unrealizedGainPercentage": 11.00,
      "firstPurchaseDate": "2025-01-05",
      "lastPurchaseDate": "2025-01-05",
      "purchaseCount": 1
    },
    {
      "fundCode": "ICICI_BLUECHIP",
      "fundName": "ICICI Prudential Bluechip - Direct Growth",
      "assetClass": "EQUITY_LARGE_CAP",
      "totalUnits": 100.0000,
      "averageNAV": 250.00,
      "totalInvested": 25000.00,
      "currentNAV": 275.00,
      "currentValue": 27500.00,
      "unrealizedGain": 2500.00,
      "unrealizedGainPercentage": 10.00,
      "firstPurchaseDate": "2025-01-05",
      "lastPurchaseDate": "2025-01-05",
      "purchaseCount": 1
    }
  ],

  "assetClassBreakdown": [
    {
      "assetClass": "EQUITY_LARGE_CAP",
      "invested": 55000.00,
      "currentValue": 60800.00,
      "gain": 5800.00,
      "gainPercentage": 10.55,
      "allocationPercentage": 55.0
    },
    {
      "assetClass": "DEBT",
      "invested": 20000.00,
      "currentValue": 20600.00,
      "gain": 600.00,
      "gainPercentage": 3.00,
      "allocationPercentage": 18.64
    }
  ]
}
```

#### Get Portfolio Performance Chart Data

```http
GET /api/v1/investment/portfolio/{customerId}/performance
Query Parameters:
  - period: 1M, 3M, 6M, 1Y, 3Y, 5Y, ALL (default: 3M)
  - interval: DAILY, WEEKLY, MONTHLY (default: DAILY)

Response (200 OK):
{
  "customerId": 456,
  "period": "3M",
  "interval": "DAILY",

  "chartData": [
    {
      "date": "2025-01-05",
      "invested": 100000.00,
      "currentValue": 100000.00,
      "gain": 0.00,
      "gainPercentage": 0.00
    },
    {
      "date": "2025-01-06",
      "invested": 100000.00,
      "currentValue": 100500.00,
      "gain": 500.00,
      "gainPercentage": 0.50
    },
    {
      "date": "2025-03-08",
      "invested": 102000.00,
      "currentValue": 110500.00,
      "gain": 8500.00,
      "gainPercentage": 8.33
    }
  ],

  "statistics": {
    "maxGain": 9200.00,
    "maxGainDate": "2025-03-05",
    "maxDrawdown": -1200.00,
    "maxDrawdownDate": "2025-02-12",
    "volatility": 4.25,
    "sharpeRatio": 1.85
  }
}
```

### 9.3 Transaction History APIs

```http
GET /api/v1/investment/transactions/customer/{customerId}
Query Parameters:
  - transactionType (optional): BUY, SELL, DIVIDEND, SIP
  - fundCode (optional)
  - fromDate (optional)
  - toDate (optional)
  - page, size

Response (200 OK):
{
  "content": [
    {
      "transactionId": 1,
      "transactionCode": "TXN-789",
      "transactionType": "BUY",
      "transactionDate": "2025-01-05",
      "fundCode": "HDFC_TOP100",
      "fundName": "HDFC Top 100 Fund",
      "units": 60.0000,
      "nav": 500.00,
      "amount": 30000.00,
      "charges": 0.00,
      "netAmount": 30000.00,
      "status": "SETTLED",
      "confirmationNumber": "CONF-2025-789"
    }
  ],
  "page": 0,
  "totalElements": 15
}
```

### 9.4 NAV Data APIs

```http
GET /api/v1/investment/nav/{fundCode}/latest
Response:
{
  "fundCode": "HDFC_TOP100",
  "fundName": "HDFC Top 100 Fund - Direct Growth",
  "navDate": "2025-03-08",
  "nav": 555.00,
  "dataSource": "MFAPI",
  "fetchedAt": "2025-03-08T21:05:00Z"
}

GET /api/v1/investment/nav/{fundCode}/history
Query Parameters:
  - fromDate: 2025-01-01
  - toDate: 2025-03-08

Response:
{
  "fundCode": "HDFC_TOP100",
  "data": [
    { "date": "2025-03-08", "nav": 555.00 },
    { "date": "2025-03-07", "nav": 553.50 },
    { "date": "2025-03-06", "nav": 550.00 }
  ]
}
```

### 9.5 Dashboard Summary APIs

```http
GET /api/v1/investment/dashboard/customer/{customerId}

Response (200 OK):
{
  "customerId": 456,
  "customerName": "Sujit Rujuk",

  "portfolioSummary": {
    "totalInvested": 102000.00,
    "currentValue": 110500.00,
    "absoluteGain": 8500.00,
    "percentageGain": 8.33,
    "todayChange": 450.00,
    "todayChangePercentage": 0.41
  },

  "goalsSummary": [
    {
      "goalId": 50,
      "goalName": "Retirement Planning",
      "targetAmount": 5000000.00,
      "currentValue": 110500.00,
      "progressPercentage": 2.21,
      "invested": 102000.00,
      "gain": 8500.00,
      "gainPercentage": 8.33
    }
  ],

  "assetAllocation": {
    "equity": {
      "percentage": 80.0,
      "value": 88400.00,
      "gain": 7100.00,
      "gainPercentage": 8.73
    },
    "debt": {
      "percentage": 20.0,
      "value": 22100.00,
      "gain": 1400.00,
      "gainPercentage": 6.76
    }
  },

  "topPerformers": [
    {
      "fundName": "HDFC Top 100 Fund",
      "gain": 3300.00,
      "gainPercentage": 11.00
    }
  ],

  "recentTransactions": [
    {
      "date": "2025-03-05",
      "type": "SIP",
      "fundName": "HDFC Top 100 Fund",
      "amount": 300.00,
      "units": 0.5405
    }
  ],

  "upcomingSIPs": [
    {
      "nextDate": "2025-04-05",
      "amount": 1000.00,
      "fundsCount": 6
    }
  ]
}
```

---

## 10. Frontend Dashboard Requirements

### 10.1 Customer Dashboard

**Route**: `/client/dashboard`

**Layout**:

```
┌─────────────────────────────────────────────────────────────────┐
│  Customer Dashboard - Sujit Rujuk                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │  Portfolio Overview                     As of: 08-Mar-2025│ │
│  ├───────────────────────────────────────────────────────────┤ │
│  │                                                            │ │
│  │  Total Invested       Current Value      Total Gain       │ │
│  │  ₹1,02,000           ₹1,10,500          +₹8,500          │ │
│  │                                          +8.33%           │ │
│  │                                                            │ │
│  │  Today's Change: +₹450 (+0.41%)                          │ │
│  │                                                            │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  Portfolio Value Chart (Last 3 Months)                     │ │
│  │  ┌───────────────────────────────────────────────────┐   │ │
│  │  │                                    ╱              │   │ │
│  │  │                              ╱╲   ╱               │   │ │
│  │  │                         ╱╲  ╱  ╲ ╱                │   │ │
│  │  │                    ╱╲  ╱  ╲╱    ╳                 │   │ │
│  │  │               ╱╲  ╱  ╲╱         ╱ ╲                │   │ │
│  │  │          ╱╲  ╱  ╲╱             ╱   ╲               │   │ │
│  │  │     ╱╲  ╱  ╲╱                 ╱     ╲              │   │ │
│  │  │────╱──╲╱────────────────────────────────────────  │   │ │
│  │  │   Jan    Feb    Mar                               │   │ │
│  │  │                                                    │   │ │
│  │  │  ── Invested Amount    ── Current Value           │   │ │
│  │  └───────────────────────────────────────────────────┘   │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│  ┌───────────────┬────────────────────────────────────────────┐ │
│  │ Asset         │                                             │ │
│  │ Allocation    │  Holdings Breakdown                         │ │
│  ├───────────────┤                                             │ │
│  │               │  Fund                   Value    Gain       │ │
│  │  ●━━━ 80%     │  HDFC Top 100          ₹33,300  +11%   ↑  │ │
│  │   Equity      │  ICICI Bluechip        ₹27,500  +10%   ↑  │ │
│  │               │  Axis Midcap           ₹16,800  +12%   ↑  │ │
│  │  ●━━━ 20%     │  SBI Small Cap         ₹10,800   +8%   ↑  │ │
│  │   Debt        │  HDFC Corp Bond        ₹15,450   +3%   ↑  │ │
│  │               │  Kotak Liquid          ₹5,150    +3%   ↑  │ │
│  └───────────────┴────────────────────────────────────────────┘ │
│                                                                  │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  Recent Transactions                [View All]             │ │
│  ├────────────────────────────────────────────────────────────┤ │
│  │  Date        Type  Fund             Amount      Units      │ │
│  ├────────────────────────────────────────────────────────────┤ │
│  │  05-Mar-25   SIP   HDFC Top 100     ₹300       0.5405     │ │
│  │  05-Mar-25   SIP   ICICI Bluechip   ₹250       0.9091     │ │
│  │  05-Feb-25   SIP   HDFC Top 100     ₹300       0.5660     │ │
│  │  05-Jan-25   BUY   HDFC Top 100     ₹30,000    60.0000    │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│  ┌──────────────────────────┬────────────────────────────────┐ │
│  │  Upcoming SIPs            │  Goals Progress                │ │
│  ├──────────────────────────┼────────────────────────────────┤ │
│  │  Next SIP: 05-Apr-2025   │  Retirement Planning           │ │
│  │  Amount: ₹1,000          │  Target: ₹50,00,000            │ │
│  │  Funds: 6                │  Current: ₹1,10,500            │ │
│  │                           │  Progress: ━━░░░░░░░░ 2.21%  │ │
│  └──────────────────────────┴────────────────────────────────┘ │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

### 10.2 Holdings Detail View

**Route**: `/client/holdings`

```
┌─────────────────────────────────────────────────────────────────┐
│  My Holdings                               As of: 08-Mar-2025   │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Filters:  [All Goals ▼]  [All Asset Classes ▼]  [Export PDF]  │
│                                                                  │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  HDFC Top 100 Fund - Direct Growth                         │ │
│  │  Large Cap Equity | ISIN: INF179K01YM1                     │ │
│  ├────────────────────────────────────────────────────────────┤ │
│  │  Units: 60.0000      Avg NAV: ₹500.00    Invested: ₹30,000│ │
│  │  Current NAV: ₹555.00                    Value: ₹33,300   │ │
│  │  Unrealized Gain: +₹3,300 (+11.00%)                 ↑     │ │
│  │                                                             │ │
│  │  Purchase History:                                         │ │
│  │  • 05-Jan-2025: 60.0000 units @ ₹500.00                  │ │
│  │                                                             │ │
│  │  NAV Chart (3M):  ____/‾‾‾‾                                │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│  [Similar cards for other 5 funds]                              │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

### 10.3 Transaction History

**Route**: `/client/transactions`

```
┌─────────────────────────────────────────────────────────────────┐
│  Transaction History                                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Filters:  [All Types ▼]  [All Funds ▼]  [Last 3 Months ▼]     │
│                                                                  │
│  Date        Type  Fund              Units      NAV      Amount │
│  ─────────────────────────────────────────────────────────────  │
│  08-Mar-25   SIP   HDFC Top 100     0.5405    ₹555.00   ₹300   │
│  08-Mar-25   SIP   ICICI Bluechip   1.0909    ₹275.00   ₹300   │
│  05-Feb-25   SIP   HDFC Top 100     0.5660    ₹530.00   ₹300   │
│  05-Jan-25   BUY   HDFC Top 100    60.0000    ₹500.00  ₹30,000 │
│  05-Jan-25   BUY   ICICI Bluechip 100.0000    ₹250.00  ₹25,000 │
│  ...                                                             │
│                                                                  │
│  [Pagination: 1 2 3 ... 10]                                     │
│  [Download Statement]                                            │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

### 10.4 Angular Components

#### Dashboard Component

```typescript
// portfolio-dashboard.component.ts

export class PortfolioDashboardComponent implements OnInit {
  portfolioSummary$: Observable<PortfolioSummary>;
  performanceChart$: Observable<ChartData>;
  holdings$: Observable<Holding[]>;
  recentTransactions$: Observable<Transaction[]>;

  constructor(
    private investmentService: InvestmentService,
    private authService: AuthService
  ) {}

  ngOnInit() {
    const customerId = this.authService.getCurrentUserId();

    // Load portfolio data
    this.portfolioSummary$ = this.investmentService
      .getPortfolioSummary(customerId);

    this.performanceChart$ = this.investmentService
      .getPerformanceChartData(customerId, '3M', 'DAILY');

    this.holdings$ = this.investmentService
      .getCustomerHoldings(customerId);

    this.recentTransactions$ = this.investmentService
      .getRecentTransactions(customerId, 5);

    // Refresh data every 5 minutes during market hours
    this.scheduleRefresh();
  }

  scheduleRefresh() {
    // Refresh at 9:30 PM IST daily (after NAV update)
    // Also allow manual refresh
  }

  onRefreshClick() {
    const customerId = this.authService.getCurrentUserId();
    this.investmentService.refreshPortfolioValuation(customerId)
      .subscribe(() => {
        // Reload data
        this.ngOnInit();
      });
  }
}
```

#### Investment Service

```typescript
// investment.service.ts

@Injectable({ providedIn: 'root' })
export class InvestmentService {
  private baseUrl = '/api/v1/investment';

  constructor(private http: HttpClient) {}

  getPortfolioSummary(customerId: number): Observable<PortfolioSummary> {
    return this.http.get<PortfolioSummary>(
      `${this.baseUrl}/dashboard/customer/${customerId}`
    );
  }

  getCustomerHoldings(customerId: number): Observable<Holding[]> {
    return this.http.get<HoldingsResponse>(
      `${this.baseUrl}/holdings/customer/${customerId}`
    ).pipe(
      map(response => response.holdings)
    );
  }

  getPerformanceChartData(
    customerId: number,
    period: string,
    interval: string
  ): Observable<ChartData> {
    return this.http.get<ChartData>(
      `${this.baseUrl}/portfolio/${customerId}/performance`,
      { params: { period, interval } }
    );
  }

  getRecentTransactions(
    customerId: number,
    limit: number
  ): Observable<Transaction[]> {
    return this.http.get<TransactionResponse>(
      `${this.baseUrl}/transactions/customer/${customerId}`,
      { params: { size: limit.toString() } }
    ).pipe(
      map(response => response.content)
    );
  }

  refreshPortfolioValuation(customerId: number): Observable<void> {
    return this.http.post<void>(
      `${this.baseUrl}/portfolio/${customerId}/refresh`,
      {}
    );
  }
}
```

---

## 11. Implementation Phases

### Phase 1: Foundation (Week 1-2)

**Backend**:
- ✅ Create database schema (7 new tables)
- ✅ Create JPA entities
- ✅ Implement repositories
- ✅ Build Mock Custodian service
- ✅ Implement NAV data service (MFapi.in integration)

**Testing**:
- Unit tests for services
- Integration tests for repositories

### Phase 2: Investment Execution (Week 3-4)

**Backend**:
- ✅ Order Service (create, validate, execute)
- ✅ Holdings Service (CRUD, valuation update)
- ✅ Transaction Service (audit trail)
- ✅ Portfolio Valuation Service

**APIs**:
- Investment order APIs
- Holdings APIs
- Transaction history APIs

**Testing**:
- API integration tests
- End-to-end order execution flow

### Phase 3: Demo Data Seeding (Week 5)

**Backend**:
- ✅ Create seed script for 10 customers
- ✅ Generate proposals and approvals
- ✅ Execute initial investments
- ✅ Create SIP schedules
- ✅ Seed historical NAV data (Jan 1 - Mar 8)
- ✅ Backfill holdings valuations

**Testing**:
- Verify all 10 customers have complete data
- Test valuation calculations

### Phase 4: NAV Updates & Automation (Week 6)

**Backend**:
- ✅ Daily NAV update job (scheduled)
- ✅ Portfolio valuation update job
- ✅ SIP execution job (monthly)
- ✅ Reconciliation job

**Testing**:
- Test scheduled jobs
- Verify NAV data accuracy

### Phase 5: Frontend Dashboard (Week 7-8)

**Frontend**:
- ✅ Portfolio dashboard component
- ✅ Holdings detail component
- ✅ Transaction history component
- ✅ Performance charts (Chart.js / ApexCharts)
- ✅ Asset allocation pie chart
- ✅ Responsive design

**Testing**:
- Component unit tests
- E2E tests with Cypress/Playwright

### Phase 6: RM Portal (Week 9)

**Frontend**:
- ✅ Order execution dashboard (RM view)
- ✅ Customer portfolio view (RM)
- ✅ Reconciliation dashboard
- ✅ Order management

**Testing**:
- RM workflow tests

### Phase 7: Integration & UAT (Week 10)

**Testing**:
- Full end-to-end testing
- User acceptance testing
- Performance testing
- Security testing

**Documentation**:
- User guides
- API documentation (Swagger)

### Phase 8: Demo Preparation (Week 11)

**Demo**:
- Prepare demo script
- Create presentation materials
- Record demo video
- Client training

---

## 12. Testing Strategy

### 12.1 Unit Tests

```java
// HoldingsServiceTest.java

@SpringBootTest
class HoldingsServiceTest {

    @Autowired
    private HoldingsService holdingsService;

    @MockBean
    private FundNavHistoryRepository navRepo;

    @Test
    void testUpdateHoldingValuation() {
        // Given
        Holdings holding = createSampleHolding();
        BigDecimal newNAV = new BigDecimal("555.00");

        when(navRepo.findByFundCodeAndNavDate(any(), any()))
            .thenReturn(Optional.of(createNavHistory(newNAV)));

        // When
        holdingsService.updateHoldingValuation(holding, LocalDate.now());

        // Then
        assertEquals(newNAV, holding.getCurrentNav());
        assertEquals(new BigDecimal("33300.00"), holding.getCurrentValue());
        assertEquals(new BigDecimal("3300.00"), holding.getUnrealizedGain());
        assertEquals(new BigDecimal("11.00"), holding.getUnrealizedGainPercentage());
    }

    @Test
    void testCalculateAverageNAVOnSecondPurchase() {
        // Given
        Holdings holding = createHoldingWith60Units();
        BigDecimal newPurchaseAmount = new BigDecimal("30000.00");
        BigDecimal newPurchaseNAV = new BigDecimal("600.00");
        BigDecimal newUnits = newPurchaseAmount.divide(newPurchaseNAV, 4, HALF_UP);

        // When
        holdingsService.addPurchase(holding, newPurchaseAmount, newPurchaseNAV, newUnits);

        // Then
        // Old: 60 units @ 500 = 30000
        // New: 50 units @ 600 = 30000
        // Total: 110 units @ avg 545.45 = 60000
        assertEquals(new BigDecimal("110.0000"), holding.getTotalUnits());
        assertEquals(new BigDecimal("545.45"), holding.getAverageNav());
        assertEquals(new BigDecimal("60000.00"), holding.getTotalInvested());
    }
}
```

### 12.2 Integration Tests

```java
// InvestmentOrderIntegrationTest.java

@SpringBootTest
@AutoConfigureMockMvc
class InvestmentOrderIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private OrderRepository orderRepo;

    @Autowired
    private HoldingsRepository holdingsRepo;

    @Test
    @WithMockUser(roles = "RM")
    void testCompleteInvestmentFlow() throws Exception {
        // Step 1: Create order from proposal
        String createRequest = """
            {
              "proposalId": 123,
              "customerId": 456,
              "autoExecute": true
            }
            """;

        MvcResult result = mockMvc.perform(
            post("/api/v1/investment/orders/create-from-proposal")
                .contentType(APPLICATION_JSON)
                .content(createRequest)
        )
        .andExpect(status().isCreated())
        .andExpect(jsonPath("$.orderId").exists())
        .andReturn();

        Long orderId = JsonPath.read(result.getResponse().getContentAsString(), "$.orderId");

        // Step 2: Execute order
        mockMvc.perform(
            post("/api/v1/investment/orders/{orderId}/execute", orderId)
        )
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.orderStatus").value("EXECUTED"));

        // Step 3: Verify order in database
        InvestmentOrder order = orderRepo.findById(orderId).orElseThrow();
        assertEquals(OrderStatus.EXECUTED, order.getOrderStatus());
        assertNotNull(order.getExecutedAt());

        // Step 4: Verify holdings created
        List<Holdings> holdings = holdingsRepo.findByCustomerId(456L);
        assertFalse(holdings.isEmpty());

        BigDecimal totalInvested = holdings.stream()
            .map(Holdings::getTotalInvested)
            .reduce(BigDecimal.ZERO, BigDecimal::add);

        assertEquals(new BigDecimal("100000.00"), totalInvested);
    }
}
```

### 12.3 E2E Tests (Cypress)

```typescript
// portfolio-dashboard.cy.ts

describe('Customer Portfolio Dashboard', () => {
  beforeEach(() => {
    cy.login('sujit.rujuk@email.com', 'password');
    cy.visit('/client/dashboard');
  });

  it('should display portfolio summary with correct values', () => {
    cy.get('[data-cy=total-invested]').should('contain', '₹1,02,000');
    cy.get('[data-cy=current-value]').should('contain', '₹1,10,500');
    cy.get('[data-cy=total-gain]').should('contain', '+₹8,500');
    cy.get('[data-cy=gain-percentage]').should('contain', '+8.33%');
  });

  it('should show holdings breakdown', () => {
    cy.get('[data-cy=holdings-table]').within(() => {
      cy.get('tr').should('have.length', 6);

      // Check HDFC Top 100 fund
      cy.contains('HDFC Top 100').parent('tr').within(() => {
        cy.get('[data-cy=current-value]').should('contain', '₹33,300');
        cy.get('[data-cy=gain-percentage]').should('contain', '+11%');
      });
    });
  });

  it('should display performance chart', () => {
    cy.get('[data-cy=performance-chart]').should('be.visible');
    cy.get('canvas').should('exist');
  });

  it('should refresh portfolio on button click', () => {
    cy.intercept('POST', '/api/v1/investment/portfolio/*/refresh').as('refresh');

    cy.get('[data-cy=refresh-button]').click();

    cy.wait('@refresh').its('response.statusCode').should('eq', 200);
    cy.get('[data-cy=current-value]').should('be.visible');
  });
});
```

---

## 13. Production Transition Plan

### 13.1 Demo vs Production Differences

| Component | Demo Implementation | Production Implementation |
|-----------|---------------------|---------------------------|
| **Custodian** | Mock internal service | Client's custodian API (BNY Mellon, State Street, etc.) |
| **NAV Data** | MFapi.in (free) or mock | Enterprise NAV provider (FactSet, Xignite) |
| **Settlement** | T+0 (instant) | T+1 or T+2 (realistic) |
| **Compliance** | Basic checks | Full regulatory compliance (SEBI, MiFID II, FINRA) |
| **Reconciliation** | Internal only | Multi-party (custodian, fund admin, asset manager) |
| **Order Execution** | Instant | Real market execution with price slippage |
| **Security** | Standard auth | Multi-factor auth, encryption, audit logs |

### 13.2 Migration Steps

**Step 1**: Replace Mock Custodian with Real Custodian API
- Implement adapter pattern for custodian integration
- Add error handling and retry logic
- Implement proper settlement tracking (T+1/T+2)

**Step 2**: Integrate Enterprise NAV Provider
- Subscribe to FactSet or Xignite
- Replace MFapi.in calls with enterprise API
- Add caching and fallback mechanisms

**Step 3**: Add Compliance Layer
- Implement pre-trade compliance checks
- Add regulatory reporting
- Integrate with compliance systems (e.g., Bloomberg AIM)

**Step 4**: Enhance Reconciliation
- Implement three-way reconciliation
- Add break management workflow
- Integrate with fund administrator systems

**Step 5**: Security Hardening
- Add encryption for sensitive data
- Implement audit logging
- Add fraud detection
- Penetration testing

### 13.3 Configuration Management

Use Spring profiles to manage demo vs production configs:

```yaml
# application-demo.yml
investment:
  custodian:
    type: mock
    instant-settlement: true
  nav-provider:
    type: mfapi
    base-url: https://api.mfapi.in/mf
    auth-required: false
  compliance:
    enabled: false

# application-prod.yml
investment:
  custodian:
    type: bny-mellon
    base-url: https://api.bnymellon.com/custody
    api-key: ${BNY_MELLON_API_KEY}
    settlement-days: 1  # T+1
  nav-provider:
    type: factset
    base-url: https://api.factset.com
    api-key: ${FACTSET_API_KEY}
  compliance:
    enabled: true
    mifid2-checks: true
    sebi-checks: true
```

---

## Sources & References

### Custodian Services & Reconciliation (2026):
- [Finartis Prospero - Custodian Interfaces & Reconciliation](https://www.finartis.com/product-features/custodian-interfaces-reconciliation-4/)
- [BNY Custody Solutions](https://www.bny.com/corporate/global/en/solutions/platforms/custody-solutions.html)
- [Brown Brothers Harriman - Custody & Fund Services](https://www.bbh.com/us/en/what-we-do/investor-services/asset-servicing-and-global-markets/custody-and-fund-services.html)
- [Limina - Investment Reconciliation Guide](https://www.limina.com/blog/investment-reconciliation)
- [Limina - NAV and P&L Reconciliation](https://www.limina.com/blog/pnl-and-nav-reconciliation-guide)

### NAV Data Providers (2026):
- [FactSet Funds API](https://developer.factset.com/api-catalog/factset-funds-api)
- [QUODD NAVs API](https://www.quodd.com/mutual-funds-data/)
- [Xignite Mutual Fund NAVs](https://www.xignite.com/Product/mutual-fund-navs)
- [MFapi.in - Free India Mutual Fund API](https://www.mfapi.in/)
- [RapidAPI - Mutual Fund NAV Info](https://rapidapi.com/deep_var35/api/mutual-fund-nav-info-and-historic-data)
- [Finvesto - Mutual Fund APIs](https://finvesto.in/)

### Portfolio Tracking & Real-Time Data (2026):
- [SteadyAPI - Top 8 Free Financial Data APIs](https://steadyapi.com/blogs/top-8-free-financial-data-apis-for-building-a-powerful-stock-portfolio)
- [SteadyAPI - 10+ Best Real-Time Stock Data APIs](https://steadyapi.com/blogs/10-best-real-time-stock-data-apis-2026)
- [Polygon.io Stock Market API](https://polygon.io/)

---

**END OF IMPLEMENTATION PLAN**

**Document Version**: 1.0
**Last Updated**: January 8, 2026
**Status**: Ready for Implementation
**Prepared By**: Claude AI (Sonnet 4.5)
