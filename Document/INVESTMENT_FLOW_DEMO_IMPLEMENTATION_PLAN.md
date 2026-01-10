# Investment Flow Demo Implementation Plan

**Date**: 2026-01-08
**Purpose**: End-to-end investment execution flow for 10 demo customers with realistic portfolio tracking
**Duration**: 18-22 months historical data (Jan 2023 - Oct 2024)

---

## Executive Summary

This document outlines the complete implementation plan for demonstrating investment flow from proposal acceptance to portfolio valuation and goal tracking. We will use **real NAV data** from MFapi.in (FREE) with **simulated transactions** (no actual money) to show realistic portfolio behavior.

**Key Features**:
- 10 demo customers with varying investment profiles
- Initial lumpsum + monthly SIP investments
- Real-time portfolio valuation using actual NAV data
- Goal achievement tracking (corpus vs target)
- One-to-many relationship: 1 customer → multiple goals → multiple portfolios
- Both RM Portal and Customer Portal dashboards

---

## Table of Contents

1. [Current Implementation Status](#1-current-implementation-status)
2. [Requirements Analysis](#2-requirements-analysis)
3. [Architecture Overview](#3-architecture-overview)
4. [Database Schema Design](#4-database-schema-design)
5. [Demo Data Specification](#5-demo-data-specification)
6. [Backend Implementation](#6-backend-implementation)
7. [Frontend Implementation](#7-frontend-implementation)
8. [NAV Integration](#8-nav-integration)
9. [Portfolio Valuation Logic](#9-portfolio-valuation-logic)
10. [Goal Achievement Tracking](#10-goal-achievement-tracking)
11. [Dashboard UI/UX Design](#11-dashboard-uiux-design)
12. [Implementation Roadmap](#12-implementation-roadmap)
13. [Testing Strategy](#13-testing-strategy)

---

## 1. Current Implementation Status

### What's Already Implemented ✅

#### Backend (Phase 1 Complete)
```
✅ Goal Creation & Journey Tracking
✅ Risk Profile & Suitability Assessment
✅ Financial Calculator (Corpus + Required Return)
✅ Portfolio Matching Engine
✅ Proposal Generation & Approval Workflow
✅ Notification System

Database Tables:
✅ goals (with customer_id, rm_id, target_amount, target_date)
✅ goal_journey_tracking (progress tracking)
✅ proposals (proposal workflow)
✅ portfolios (6 risk-based portfolios)
✅ portfolio_asset_allocations (asset distribution)
✅ model_portfolio_strategies (strategy mapping)
```

#### Frontend (Phase 1 Partial)
```
✅ Super Admin Portal (100% complete)
✅ RM Portal (80% complete)
   ✅ Customer management
   ✅ Goal creation journey
   ✅ Risk & suitability assessment
   ✅ Proposal generation
   ⚠️ Proposal detail view (partial)
⚠️ Customer Portal (40% complete)
   ✅ Login/authentication
   ✅ Basic dashboard structure
   ❌ Portfolio holdings view
   ❌ Goal tracking view
   ❌ Investment performance charts
```

### What's Missing (Phase 2) ❌

```
❌ Investment Order Execution
❌ Holdings Management
❌ NAV Daily Updates
❌ Portfolio Valuation Engine
❌ SIP Schedule & Execution
❌ Settlement Processing
❌ Reconciliation System
❌ Performance Metrics (XIRR, CAGR, Unrealized Gains)
❌ Customer Dashboard - Holdings View
❌ Customer Dashboard - Goal Progress View
❌ RM Dashboard - Customer Portfolio Summary
```

---

## 2. Requirements Analysis

### User Story 1: Customer Investment Journey

**Scenario**: Priya Sharma (Customer ID: 1)

```
Timeline:
├─ 01-Dec-2024: Proposal approved by customer
├─ 05-Jan-2025: Investment starts
│   ├─ Initial Lumpsum: ₹1,00,000
│   └─ Monthly SIP: ₹10,000 (5th of every month)
├─ 05-Feb-2025: SIP Execution #1
├─ 05-Mar-2025: SIP Execution #2
├─ ... (continues monthly)
└─ 08-Jan-2026: Current date (13 months of data)

Goal:
├─ Target Corpus: ₹10,00,000 (10 million)
├─ Total Invested: ₹2,30,000 (1L + 13 SIPs)
└─ Current Value: ₹2,45,670 (6.8% return)
    ├─ Unrealized Gain: ₹15,670
    ├─ Goal Achievement: 24.57% (of ₹10,00,000)
    └─ Timeline Progress: 8.3% (1 year of 12 years)
```

**Customer Portal View**:
```
Dashboard:
├─ Portfolio Summary Card
│   ├─ Total Invested: ₹2,30,000
│   ├─ Current Value: ₹2,45,670
│   ├─ Unrealized Gain: +₹15,670 (+6.8%)
│   └─ Today's Change: +₹245 (+0.1%)
│
├─ Goals Progress (3 Goals)
│   ├─ Goal 1: Retirement (Target: ₹1 Cr)
│   │   ├─ Progress Bar: [█████░░░░░] 24.57%
│   │   ├─ Time Remaining: 11 years
│   │   └─ Status: On Track ✅
│   │
│   ├─ Goal 2: Child Education (Target: ₹50 L)
│   │   ├─ Progress Bar: [███░░░░░░░] 12.4%
│   │   └─ Status: Behind ⚠️
│   │
│   └─ Goal 3: House Purchase (Target: ₹75 L)
│       ├─ Progress Bar: [████░░░░░░] 18.3%
│       └─ Status: Ahead 🚀
│
└─ Holdings Table (11 Funds)
    ├─ HDFC Top 100 Fund: ₹45,230 (+8.2%)
    ├─ ICICI Bluechip Fund: ₹38,560 (+6.5%)
    └─ ... (9 more funds)
```

### User Story 2: Multiple Goals, Multiple Portfolios

**Scenario**: Rajesh Kumar has 3 goals

```
Customer: Rajesh Kumar (Customer ID: 2)

Goal 1: Retirement (Age 60)
├─ Target: ₹1 Crore
├─ Horizon: 20 years
├─ Risk: Balance (60/40)
└─ Portfolio: 11 funds across 6 asset classes

Goal 2: Child Education (Age 18)
├─ Target: ₹50 Lakhs
├─ Horizon: 10 years
├─ Risk: Aggressive (80/20)
└─ Portfolio: 9 funds, higher equity allocation

Goal 3: House Purchase
├─ Target: ₹75 Lakhs
├─ Horizon: 5 years
├─ Risk: Conservative (20/80)
└─ Portfolio: 7 funds, higher debt allocation

Dashboard View:
├─ Total Portfolio Value: ₹5,67,890
│   └─ Across 3 Goals = 27 mutual funds
├─ Total Invested: ₹5,20,000
├─ Total Gain: ₹47,890 (+9.2%)
└─ Monthly SIP: ₹25,000 (split across 3 goals)
```

### User Story 3: NAV-Based Value Changes

**Scenario**: Asset value changes daily with NAV

```
Date: 05-Jan-2025 (Purchase)
├─ HDFC Top 100 Fund
│   ├─ Amount Invested: ₹20,000
│   ├─ NAV: ₹500.00
│   ├─ Units Allocated: 40.0000
│   └─ Value: ₹20,000 (purchase day)

Date: 08-Feb-2025 (After 1 month)
├─ HDFC Top 100 Fund
│   ├─ NAV: ₹515.50 (+3.1%)
│   ├─ Units: 40.0000 (unchanged)
│   ├─ Current Value: ₹20,620
│   └─ Unrealized Gain: +₹620 (+3.1%)

Date: 08-Jan-2026 (After 13 months)
├─ HDFC Top 100 Fund
│   ├─ NAV: ₹542.30 (+8.46%)
│   ├─ Units: 40.0000 (initial) + 23.4567 (SIPs) = 63.4567
│   ├─ Current Value: ₹34,415
│   └─ Unrealized Gain: +₹2,415 (+7.54%)
```

---

## 3. Architecture Overview

### System Components

```
┌─────────────────────────────────────────────────────────────┐
│                     Frontend Layer                          │
├─────────────────────────────────────────────────────────────┤
│  Customer Portal              │      RM Portal               │
│  ├─ Dashboard                 │      ├─ Customer List        │
│  ├─ Holdings View             │      ├─ Portfolio Summary    │
│  ├─ Goal Tracking             │      └─ Investment Mgmt      │
│  └─ Transaction History       │                              │
└─────────────────────────────────────────────────────────────┘
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    REST API Layer                           │
├─────────────────────────────────────────────────────────────┤
│  /api/v1/customer/portfolio/holdings                        │
│  /api/v1/customer/portfolio/summary                         │
│  /api/v1/customer/goals/{id}/progress                       │
│  /api/v1/holdings/valuations/daily                          │
│  /api/v1/sip/schedules                                      │
└─────────────────────────────────────────────────────────────┘
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                   Service Layer                             │
├─────────────────────────────────────────────────────────────┤
│  PortfolioValuationService  │  GoalProgressService          │
│  NAVProviderService          │  SIPExecutionService          │
│  HoldingsService             │  PerformanceMetricsService    │
└─────────────────────────────────────────────────────────────┘
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                   Data Layer                                │
├─────────────────────────────────────────────────────────────┤
│  Holdings  │  Transactions  │  NAV History  │  SIP Schedule │
└─────────────────────────────────────────────────────────────┘
                            ▼
┌─────────────────────────────────────────────────────────────┐
│               External NAV Provider                         │
├─────────────────────────────────────────────────────────────┤
│  MFapi.in (FREE)  │  AMFI Portal  │  Local Cache (Redis)    │
└─────────────────────────────────────────────────────────────┘
```

### Data Flow

```
1. INVESTMENT ORDER EXECUTION
   Proposal Approved → Order Created → Units Calculated → Holdings Updated

2. DAILY NAV UPDATE (Scheduled Job)
   6:30 PM IST → Fetch NAVs from MFapi.in → Update Local Cache →
   Recalculate Portfolio Values → Notify Threshold Breaches

3. MONTHLY SIP EXECUTION (Scheduled Job)
   5th of Month → Identify Due SIPs → Create Orders → Calculate Units →
   Update Holdings → Send Notifications

4. PORTFOLIO VALUATION (Real-Time)
   User Opens Dashboard → Fetch Holdings → Get Latest NAVs →
   Calculate Current Values → Show Unrealized Gains

5. GOAL PROGRESS TRACKING
   Holdings Valuation → Sum by Goal → Compare with Target →
   Calculate Achievement % → Determine Status (On Track/Behind/Ahead)
```

---

## 4. Database Schema Design

### New Tables Required

#### 4.1 Investment Orders

```sql
CREATE TABLE investment_orders (
    id BIGSERIAL PRIMARY KEY,
    order_number VARCHAR(50) UNIQUE NOT NULL, -- ORD-2025-001234
    customer_id BIGINT NOT NULL REFERENCES customers(id),
    goal_id BIGINT NOT NULL REFERENCES goals(id),
    proposal_id BIGINT REFERENCES proposals(id),
    order_type VARCHAR(20) NOT NULL, -- LUMPSUM, SIP, ADDITIONAL
    order_status VARCHAR(30) NOT NULL, -- PENDING, SUBMITTED, EXECUTED, SETTLED, FAILED
    total_amount NUMERIC(15, 2) NOT NULL,
    order_date TIMESTAMP NOT NULL,
    execution_date TIMESTAMP,
    settlement_date TIMESTAMP,
    bse_order_ref VARCHAR(100), -- BSE StAR MF reference (mock)
    rta_ref VARCHAR(100), -- RTA reference (CAMS/KFintech mock)
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by BIGINT,
    is_deleted BOOLEAN DEFAULT FALSE
);

CREATE INDEX idx_order_customer ON investment_orders(customer_id, order_status);
CREATE INDEX idx_order_goal ON investment_orders(goal_id);
CREATE INDEX idx_order_date ON investment_orders(order_date DESC);
```

#### 4.2 Order Executions (Fund-wise breakdown)

```sql
CREATE TABLE order_executions (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES investment_orders(id),
    fund_id BIGINT REFERENCES mutual_funds(id), -- If you have fund master
    scheme_code VARCHAR(50) NOT NULL, -- AMFI scheme code
    scheme_name VARCHAR(200) NOT NULL,
    isin VARCHAR(20),
    asset_class VARCHAR(50),
    amount NUMERIC(15, 2) NOT NULL,
    nav NUMERIC(10, 4) NOT NULL, -- Purchase NAV
    units NUMERIC(15, 4) NOT NULL, -- Calculated units
    execution_status VARCHAR(30), -- PENDING, FILLED, PARTIAL, REJECTED
    execution_date TIMESTAMP,
    broker_ref VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_execution_order ON order_executions(order_id);
CREATE INDEX idx_execution_scheme ON order_executions(scheme_code);
```

#### 4.3 Holdings

```sql
CREATE TABLE holdings (
    id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT NOT NULL REFERENCES customers(id),
    goal_id BIGINT NOT NULL REFERENCES goals(id),
    scheme_code VARCHAR(50) NOT NULL,
    scheme_name VARCHAR(200) NOT NULL,
    isin VARCHAR(20),
    folio_number VARCHAR(50), -- RTA folio (auto-generated)
    asset_class VARCHAR(50),

    -- Quantity
    quantity NUMERIC(15, 4) NOT NULL, -- Total units held
    available_quantity NUMERIC(15, 4), -- For redemptions

    -- Cost Basis
    average_cost NUMERIC(10, 4) NOT NULL, -- Average purchase NAV
    invested_amount NUMERIC(15, 2) NOT NULL, -- Total money invested

    -- Current Valuation
    current_nav NUMERIC(10, 4), -- Latest NAV
    current_value NUMERIC(15, 2), -- quantity * current_nav
    unrealized_gain NUMERIC(15, 2), -- current_value - invested_amount
    unrealized_gain_percentage NUMERIC(8, 4), -- (gain / invested) * 100

    -- Tracking
    first_purchase_date DATE,
    last_purchase_date DATE,
    last_valuation_date DATE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE INDEX idx_holding_customer ON holdings(customer_id, is_active);
CREATE INDEX idx_holding_goal ON holdings(goal_id, is_active);
CREATE INDEX idx_holding_scheme ON holdings(scheme_code);
CREATE UNIQUE INDEX idx_holding_unique ON holdings(customer_id, goal_id, scheme_code)
    WHERE is_active = TRUE;
```

#### 4.4 NAV History (Cache)

```sql
CREATE TABLE nav_history (
    id BIGSERIAL PRIMARY KEY,
    scheme_code VARCHAR(50) NOT NULL,
    nav_date DATE NOT NULL,
    nav_value NUMERIC(10, 4) NOT NULL,
    data_source VARCHAR(50) DEFAULT 'MFAPI', -- MFAPI, AMFI, MANUAL
    fetched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(scheme_code, nav_date)
);

CREATE INDEX idx_nav_scheme_date ON nav_history(scheme_code, nav_date DESC);
CREATE INDEX idx_nav_date ON nav_history(nav_date DESC);
```

#### 4.5 SIP Schedules

```sql
CREATE TABLE sip_schedules (
    id BIGSERIAL PRIMARY KEY,
    sip_number VARCHAR(50) UNIQUE NOT NULL, -- SIP-2025-001234
    customer_id BIGINT NOT NULL REFERENCES customers(id),
    goal_id BIGINT NOT NULL REFERENCES goals(id),
    portfolio_id BIGINT REFERENCES portfolios(id),
    initial_order_id BIGINT REFERENCES investment_orders(id),

    -- SIP Details
    monthly_amount NUMERIC(15, 2) NOT NULL,
    tenure_months INTEGER NOT NULL,
    frequency VARCHAR(20) DEFAULT 'MONTHLY', -- MONTHLY, QUARTERLY, YEARLY
    execution_day INTEGER DEFAULT 5, -- 5th of every month

    -- Dates
    start_date DATE NOT NULL,
    end_date DATE,
    next_execution_date DATE,

    -- Status
    status VARCHAR(30) NOT NULL, -- ACTIVE, PAUSED, COMPLETED, CANCELLED
    pause_reason TEXT,
    pause_date DATE,

    -- Tracking
    executions_completed INTEGER DEFAULT 0,
    executions_failed INTEGER DEFAULT 0,
    total_invested NUMERIC(15, 2) DEFAULT 0,
    last_execution_date DATE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
);

CREATE INDEX idx_sip_customer ON sip_schedules(customer_id, status);
CREATE INDEX idx_sip_goal ON sip_schedules(goal_id);
CREATE INDEX idx_sip_next_execution ON sip_schedules(next_execution_date, status)
    WHERE status = 'ACTIVE';
```

#### 4.6 Transactions (Audit Trail)

```sql
CREATE TABLE transactions (
    id BIGSERIAL PRIMARY KEY,
    transaction_number VARCHAR(50) UNIQUE NOT NULL, -- TXN-2025-001234
    customer_id BIGINT NOT NULL REFERENCES customers(id),
    goal_id BIGINT REFERENCES goals(id),
    holding_id BIGINT REFERENCES holdings(id),
    order_id BIGINT REFERENCES investment_orders(id),
    sip_schedule_id BIGINT REFERENCES sip_schedules(id),

    -- Transaction Details
    transaction_type VARCHAR(30) NOT NULL, -- PURCHASE, REDEMPTION, SWITCH, DIVIDEND
    transaction_mode VARCHAR(30), -- LUMPSUM, SIP, ADDITIONAL
    scheme_code VARCHAR(50) NOT NULL,
    scheme_name VARCHAR(200),

    -- Financials
    amount NUMERIC(15, 2) NOT NULL,
    units NUMERIC(15, 4),
    nav NUMERIC(10, 4),

    -- Dates
    transaction_date DATE NOT NULL,
    settlement_date DATE,

    -- Status
    status VARCHAR(30) NOT NULL, -- PENDING, SUCCESS, FAILED
    remarks TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_txn_customer ON transactions(customer_id, transaction_date DESC);
CREATE INDEX idx_txn_goal ON transactions(goal_id);
CREATE INDEX idx_txn_scheme ON transactions(scheme_code);
CREATE INDEX idx_txn_date ON transactions(transaction_date DESC);
```

#### 4.7 Portfolio Valuations (Daily Snapshot)

```sql
CREATE TABLE portfolio_valuations (
    id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT NOT NULL REFERENCES customers(id),
    goal_id BIGINT REFERENCES goals(id), -- NULL = entire portfolio
    valuation_date DATE NOT NULL,

    -- Valuation
    total_invested NUMERIC(15, 2) NOT NULL,
    current_value NUMERIC(15, 2) NOT NULL,
    unrealized_gain NUMERIC(15, 2),
    gain_percentage NUMERIC(8, 4),
    day_change NUMERIC(15, 2), -- vs previous day
    day_change_percentage NUMERIC(8, 4),

    -- Returns
    xirr NUMERIC(8, 4), -- Annualized return
    cagr NUMERIC(8, 4), -- Compounded annual growth rate

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(customer_id, goal_id, valuation_date)
);

CREATE INDEX idx_valuation_customer_date ON portfolio_valuations(customer_id, valuation_date DESC);
CREATE INDEX idx_valuation_goal_date ON portfolio_valuations(goal_id, valuation_date DESC);
```

#### 4.8 Mutual Funds Master (Reference Data)

```sql
CREATE TABLE mutual_funds (
    id BIGSERIAL PRIMARY KEY,
    scheme_code VARCHAR(50) UNIQUE NOT NULL, -- AMFI scheme code
    scheme_name VARCHAR(200) NOT NULL,
    isin VARCHAR(20) UNIQUE,
    amc_name VARCHAR(100), -- Asset Management Company
    scheme_type VARCHAR(50), -- EQUITY, DEBT, HYBRID
    asset_class VARCHAR(50), -- LARGE_CAP, MID_CAP, LIQUID, etc.
    scheme_category VARCHAR(100), -- Per SEBI categorization
    risk_level VARCHAR(30), -- LOW, MODERATE, HIGH, VERY_HIGH
    min_investment NUMERIC(15, 2),
    min_sip_amount NUMERIC(15, 2),
    exit_load VARCHAR(200),
    expense_ratio NUMERIC(5, 4),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_fund_code ON mutual_funds(scheme_code);
CREATE INDEX idx_fund_isin ON mutual_funds(isin);
CREATE INDEX idx_fund_amc ON mutual_funds(amc_name);
```

---

## 5. Demo Data Specification

### 10 Demo Customers Profile

| Customer ID | Name | Initial Investment | Monthly SIP | Start Date | Goals | Tenure | Profile |
|------------|------|-------------------|-------------|------------|-------|--------|---------|
| 1 | Priya Sharma | ₹1,00,000 | ₹10,000 | 05-Jan-2023 | 3 | 22 months | Balanced |
| 2 | Rajesh Kumar | ₹2,00,000 | ₹15,000 | 10-Feb-2023 | 2 | 22 months | Aggressive |
| 3 | Anita Patel | ₹1,50,000 | ₹12,000 | 15-Mar-2023 | 1 | 21 months | Conservative |
| 4 | Vikram Singh | ₹3,00,000 | ₹20,000 | 01-Apr-2023 | 3 | 21 months | Speculative |
| 5 | Meera Iyer | ₹75,000 | ₹8,000 | 20-May-2023 | 2 | 20 months | Secure |
| 6 | Amit Desai | ₹2,50,000 | ₹18,000 | 10-Jun-2023 | 1 | 19 months | Aggressive |
| 7 | Sneha Reddy | ₹1,25,000 | ₹10,000 | 05-Jul-2023 | 2 | 18 months | Balanced |
| 8 | Arjun Kapoor | ₹1,80,000 | ₹14,000 | 15-Aug-2023 | 3 | 17 months | Income |
| 9 | Kavita Nair | ₹90,000 | ₹7,500 | 01-Sep-2023 | 1 | 16 months | Conservative |
| 10 | Rohit Malhotra | ₹2,20,000 | ₹16,000 | 20-Sep-2023 | 2 | 16 months | Aggressive |

**Total Demo Portfolio**:
- Total Customers: 10
- Total Goals: 20 goals across 10 customers
- Total Initial Investment: ₹16,90,000
- Total Monthly SIP: ₹1,30,500
- Total Invested (after SIPs): ~₹45,00,000+ (22 months)
- Expected Current Value: ~₹52,00,000 (15-20% growth)

### Sample Goal Distribution

**Customer 1: Priya Sharma (3 Goals)**
```
Goal 1: Retirement Planning
├─ Target: ₹1 Crore
├─ Horizon: 20 years
├─ Risk: Balanced (60/40)
├─ Initial: ₹40,000
├─ SIP: ₹4,000/month
└─ Portfolio: 11 funds

Goal 2: Child Education
├─ Target: ₹50 Lakhs
├─ Horizon: 15 years
├─ Risk: Aggressive (80/20)
├─ Initial: ₹35,000
├─ SIP: ₹3,500/month
└─ Portfolio: 9 funds

Goal 3: House Purchase
├─ Target: ₹75 Lakhs
├─ Horizon: 8 years
├─ Risk: Conservative (20/80)
├─ Initial: ₹25,000
├─ SIP: ₹2,500/month
└─ Portfolio: 7 funds
```

### Fund Allocation Example (Balanced Portfolio)

For Priya Sharma's Retirement Goal (₹40,000 initial):

| Fund Name | Scheme Code | Asset Class | Allocation % | Amount | NAV (Jan'23) | Units |
|-----------|-------------|-------------|--------------|--------|--------------|-------|
| HDFC Top 100 Fund | 119551 | Large Cap Equity | 20% | ₹8,000 | 500.00 | 16.0000 |
| ICICI Bluechip Fund | 120503 | Large Cap Equity | 15% | ₹6,000 | 68.50 | 87.5912 |
| SBI Magnum Mid Cap | 103525 | Mid Cap Equity | 10% | ₹4,000 | 152.30 | 26.2648 |
| Axis Small Cap Fund | 120305 | Small Cap Equity | 10% | ₹4,000 | 58.40 | 68.4932 |
| Mirae Asset Emerging | 119551 | Emerging Markets | 5% | ₹2,000 | 28.60 | 69.9301 |
| HDFC Corp Bond Fund | 100490 | Corporate Debt | 15% | ₹6,000 | 28.85 | 207.9584 |
| ICICI Liquid Fund | 100490 | Liquid | 10% | ₹4,000 | 325.40 | 12.2924 |
| SBI Short Term Debt | 103533 | Short Term Debt | 10% | ₹4,000 | 42.20 | 94.7867 |
| Axis Banking & PSU | 120581 | Debt | 5% | ₹2,000 | 2,145.00 | 0.9324 |

**Total**: 9 funds = ₹40,000 initial investment

**Monthly SIP Distribution** (₹4,000):
Same funds, ₹444/fund each month (proportional)

---

## 6. Backend Implementation

### 6.1 New Entities

#### InvestmentOrder.java

```java
@Entity
@Table(name = "investment_orders")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class InvestmentOrder extends BaseEntity {

    @Column(name = "order_number", unique = true, nullable = false)
    private String orderNumber;

    @Column(name = "customer_id", nullable = false)
    private Long customerId;

    @Column(name = "goal_id", nullable = false)
    private Long goalId;

    @Column(name = "proposal_id")
    private Long proposalId;

    @Enumerated(EnumType.STRING)
    @Column(name = "order_type", nullable = false)
    private OrderType orderType;

    @Enumerated(EnumType.STRING)
    @Column(name = "order_status", nullable = false)
    @Builder.Default
    private OrderStatus orderStatus = OrderStatus.PENDING;

    @Column(name = "total_amount", precision = 15, scale = 2, nullable = false)
    private BigDecimal totalAmount;

    @Column(name = "order_date", nullable = false)
    private LocalDateTime orderDate;

    @Column(name = "execution_date")
    private LocalDateTime executionDate;

    @Column(name = "settlement_date")
    private LocalDateTime settlementDate;

    @Column(name = "bse_order_ref")
    private String bseOrderRef;

    @Column(name = "rta_ref")
    private String rtaRef;

    @Column(name = "notes", columnDefinition = "TEXT")
    private String notes;

    public enum OrderType {
        LUMPSUM,
        SIP,
        ADDITIONAL
    }

    public enum OrderStatus {
        PENDING,
        SUBMITTED,
        EXECUTED,
        SETTLED,
        FAILED,
        CANCELLED
    }
}
```

#### Holding.java

```java
@Entity
@Table(name = "holdings")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Holding extends BaseEntity {

    @Column(name = "customer_id", nullable = false)
    private Long customerId;

    @Column(name = "goal_id", nullable = false)
    private Long goalId;

    @Column(name = "scheme_code", nullable = false)
    private String schemeCode;

    @Column(name = "scheme_name", nullable = false)
    private String schemeName;

    @Column(name = "isin")
    private String isin;

    @Column(name = "folio_number")
    private String folioNumber;

    @Column(name = "asset_class")
    private String assetClass;

    // Quantity
    @Column(name = "quantity", precision = 15, scale = 4, nullable = false)
    private BigDecimal quantity;

    @Column(name = "available_quantity", precision = 15, scale = 4)
    private BigDecimal availableQuantity;

    // Cost Basis
    @Column(name = "average_cost", precision = 10, scale = 4, nullable = false)
    private BigDecimal averageCost;

    @Column(name = "invested_amount", precision = 15, scale = 2, nullable = false)
    private BigDecimal investedAmount;

    // Current Valuation
    @Column(name = "current_nav", precision = 10, scale = 4)
    private BigDecimal currentNav;

    @Column(name = "current_value", precision = 15, scale = 2)
    private BigDecimal currentValue;

    @Column(name = "unrealized_gain", precision = 15, scale = 2)
    private BigDecimal unrealizedGain;

    @Column(name = "unrealized_gain_percentage", precision = 8, scale = 4)
    private BigDecimal unrealizedGainPercentage;

    // Tracking
    @Column(name = "first_purchase_date")
    private LocalDate firstPurchaseDate;

    @Column(name = "last_purchase_date")
    private LocalDate lastPurchaseDate;

    @Column(name = "last_valuation_date")
    private LocalDate lastValuationDate;

    @Column(name = "is_active")
    @Builder.Default
    private Boolean isActive = true;

    // Calculated methods
    public void updateValuation(BigDecimal latestNav) {
        this.currentNav = latestNav;
        this.currentValue = this.quantity.multiply(latestNav)
            .setScale(2, RoundingMode.HALF_UP);
        this.unrealizedGain = this.currentValue.subtract(this.investedAmount)
            .setScale(2, RoundingMode.HALF_UP);
        if (this.investedAmount.compareTo(BigDecimal.ZERO) > 0) {
            this.unrealizedGainPercentage = this.unrealizedGain
                .multiply(new BigDecimal("100"))
                .divide(this.investedAmount, 4, RoundingMode.HALF_UP);
        }
        this.lastValuationDate = LocalDate.now();
    }

    public void addUnits(BigDecimal units, BigDecimal nav, BigDecimal amount) {
        // Update average cost
        BigDecimal totalCost = this.investedAmount.add(amount);
        this.averageCost = totalCost.divide(this.quantity.add(units), 4, RoundingMode.HALF_UP);

        // Update quantities
        this.quantity = this.quantity.add(units);
        this.availableQuantity = this.quantity;
        this.investedAmount = totalCost;

        // Update purchase dates
        this.lastPurchaseDate = LocalDate.now();
        if (this.firstPurchaseDate == null) {
            this.firstPurchaseDate = LocalDate.now();
        }
    }
}
```

#### SipSchedule.java

```java
@Entity
@Table(name = "sip_schedules")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SipSchedule extends BaseEntity {

    @Column(name = "sip_number", unique = true, nullable = false)
    private String sipNumber;

    @Column(name = "customer_id", nullable = false)
    private Long customerId;

    @Column(name = "goal_id", nullable = false)
    private Long goalId;

    @Column(name = "portfolio_id")
    private Long portfolioId;

    @Column(name = "initial_order_id")
    private Long initialOrderId;

    @Column(name = "monthly_amount", precision = 15, scale = 2, nullable = false)
    private BigDecimal monthlyAmount;

    @Column(name = "tenure_months", nullable = false)
    private Integer tenureMonths;

    @Column(name = "frequency")
    @Builder.Default
    private String frequency = "MONTHLY";

    @Column(name = "execution_day")
    @Builder.Default
    private Integer executionDay = 5;

    @Column(name = "start_date", nullable = false)
    private LocalDate startDate;

    @Column(name = "end_date")
    private LocalDate endDate;

    @Column(name = "next_execution_date")
    private LocalDate nextExecutionDate;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    @Builder.Default
    private SipStatus status = SipStatus.ACTIVE;

    @Column(name = "pause_reason", columnDefinition = "TEXT")
    private String pauseReason;

    @Column(name = "pause_date")
    private LocalDate pauseDate;

    @Column(name = "executions_completed")
    @Builder.Default
    private Integer executionsCompleted = 0;

    @Column(name = "executions_failed")
    @Builder.Default
    private Integer executionsFailed = 0;

    @Column(name = "total_invested", precision = 15, scale = 2)
    @Builder.Default
    private BigDecimal totalInvested = BigDecimal.ZERO;

    @Column(name = "last_execution_date")
    private LocalDate lastExecutionDate;

    public enum SipStatus {
        ACTIVE,
        PAUSED,
        COMPLETED,
        CANCELLED
    }

    public void recordExecution(BigDecimal amount) {
        this.executionsCompleted++;
        this.totalInvested = this.totalInvested.add(amount);
        this.lastExecutionDate = LocalDate.now();

        // Calculate next execution date
        this.nextExecutionDate = LocalDate.now().plusMonths(1)
            .withDayOfMonth(this.executionDay);

        // Check if completed
        if (this.executionsCompleted >= this.tenureMonths) {
            this.status = SipStatus.COMPLETED;
            this.nextExecutionDate = null;
        }
    }

    public void pause(String reason) {
        this.status = SipStatus.PAUSED;
        this.pauseReason = reason;
        this.pauseDate = LocalDate.now();
    }

    public void resume() {
        this.status = SipStatus.ACTIVE;
        this.pauseReason = null;
        // Recalculate next execution date
        this.nextExecutionDate = LocalDate.now().plusMonths(1)
            .withDayOfMonth(this.executionDay);
    }
}
```

### 6.2 Service Layer

#### NAVProviderService.java

```java
@Service
@Slf4j
@RequiredArgsConstructor
public class NAVProviderService {

    private static final String MFAPI_BASE_URL = "https://api.mfapi.in/mf/";

    private final NavHistoryRepository navHistoryRepository;
    private final RestTemplate restTemplate;

    /**
     * Fetch latest NAV for a scheme
     * Uses cache-aside pattern with database cache
     */
    @Cacheable(value = "nav-cache", key = "#schemeCode")
    public BigDecimal getLatestNav(String schemeCode) {
        // Check local cache first
        Optional<NavHistory> cached = navHistoryRepository
            .findFirstBySchemeCodeOrderByNavDateDesc(schemeCode);

        if (cached.isPresent() &&
            cached.get().getNavDate().equals(LocalDate.now())) {
            log.debug("Using cached NAV for scheme: {}", schemeCode);
            return cached.get().getNavValue();
        }

        // Fetch from MFapi.in
        log.info("Fetching NAV from MFapi.in for scheme: {}", schemeCode);
        try {
            String url = MFAPI_BASE_URL + schemeCode;
            MFApiResponse response = restTemplate.getForObject(url, MFApiResponse.class);

            if (response != null && !response.getData().isEmpty()) {
                MFApiNavData latestNav = response.getData().get(0);
                BigDecimal nav = new BigDecimal(latestNav.getNav());

                // Save to cache
                NavHistory navHistory = NavHistory.builder()
                    .schemeCode(schemeCode)
                    .navDate(LocalDate.parse(latestNav.getDate(),
                        DateTimeFormatter.ofPattern("dd-MM-yyyy")))
                    .navValue(nav)
                    .dataSource("MFAPI")
                    .build();
                navHistoryRepository.save(navHistory);

                return nav;
            }
        } catch (Exception e) {
            log.error("Failed to fetch NAV for scheme: {}", schemeCode, e);
        }

        // Fallback to last known NAV
        return cached.map(NavHistory::getNavValue)
            .orElseThrow(() -> new RuntimeException("NAV not available for: " + schemeCode));
    }

    /**
     * Scheduled job to sync NAVs for all schemes
     * Runs daily at 6:30 PM IST (after NAVs are published)
     */
    @Scheduled(cron = "0 30 18 * * ?", zone = "Asia/Kolkata")
    @Transactional
    public void syncAllNavs() {
        log.info("Starting daily NAV sync job");

        // Get all unique scheme codes from holdings
        List<String> schemeCodes = holdingRepository.findAllDistinctSchemeCodes();

        int success = 0;
        int failed = 0;

        for (String schemeCode : schemeCodes) {
            try {
                BigDecimal nav = fetchAndCacheNav(schemeCode);
                success++;
                log.debug("Synced NAV for {}: {}", schemeCode, nav);
            } catch (Exception e) {
                failed++;
                log.error("Failed to sync NAV for: {}", schemeCode);
            }

            // Rate limiting
            Thread.sleep(100);
        }

        log.info("NAV sync completed. Success: {}, Failed: {}", success, failed);
    }

    /**
     * Fetch NAV for a specific date (historical)
     */
    public BigDecimal getNavOnDate(String schemeCode, LocalDate date) {
        return navHistoryRepository.findBySchemeCodeAndNavDate(schemeCode, date)
            .map(NavHistory::getNavValue)
            .orElseThrow(() -> new RuntimeException(
                String.format("NAV not available for %s on %s", schemeCode, date)));
    }
}
```

#### InvestmentOrderService.java

```java
@Service
@Slf4j
@RequiredArgsConstructor
public class InvestmentOrderService {

    private final InvestmentOrderRepository orderRepository;
    private final OrderExecutionRepository executionRepository;
    private final HoldingRepository holdingRepository;
    private final NAVProviderService navProvider;
    private final ProposalService proposalService;

    /**
     * Execute initial investment order (after proposal approval)
     */
    @Transactional
    public InvestmentOrder executeProposalOrder(Long proposalId) {
        log.info("Executing investment order for proposal: {}", proposalId);

        // Get proposal with fund distribution
        ProposalDto proposal = proposalService.getProposalById(proposalId);

        // Create investment order
        InvestmentOrder order = InvestmentOrder.builder()
            .orderNumber(generateOrderNumber())
            .customerId(proposal.getCustomerId())
            .goalId(proposal.getGoalId())
            .proposalId(proposalId)
            .orderType(InvestmentOrder.OrderType.LUMPSUM)
            .orderStatus(InvestmentOrder.OrderStatus.PENDING)
            .totalAmount(proposal.getTotalAmount())
            .orderDate(LocalDateTime.now())
            .notes("Initial investment from approved proposal")
            .build();
        order = orderRepository.save(order);

        // Execute fund-wise purchases
        List<OrderExecution> executions = new ArrayList<>();
        for (ProposalFundDto fund : proposal.getFunds()) {
            OrderExecution execution = executeFundPurchase(
                order,
                fund.getSchemeCode(),
                fund.getSchemeName(),
                fund.getAllocatedAmount(),
                fund.getAssetClass()
            );
            executions.add(execution);
        }

        // Update order status
        order.setOrderStatus(InvestmentOrder.OrderStatus.EXECUTED);
        order.setExecutionDate(LocalDateTime.now());
        order.setBseOrderRef("BSE-MOCK-" + System.currentTimeMillis());
        orderRepository.save(order);

        // Schedule settlement (T+1)
        scheduleSettlement(order.getId(), 1);

        log.info("Order {} executed successfully. {} funds purchased.",
            order.getOrderNumber(), executions.size());

        return order;
    }

    /**
     * Execute purchase for a single fund
     */
    private OrderExecution executeFundPurchase(
        InvestmentOrder order,
        String schemeCode,
        String schemeName,
        BigDecimal amount,
        String assetClass
    ) {
        // Fetch latest NAV
        BigDecimal nav = navProvider.getLatestNav(schemeCode);

        // Calculate units
        BigDecimal units = amount.divide(nav, 4, RoundingMode.HALF_DOWN);

        // Create execution record
        OrderExecution execution = OrderExecution.builder()
            .orderId(order.getId())
            .schemeCode(schemeCode)
            .schemeName(schemeName)
            .assetClass(assetClass)
            .amount(amount)
            .nav(nav)
            .units(units)
            .executionStatus("FILLED")
            .executionDate(LocalDateTime.now())
            .brokerRef("EXEC-" + System.currentTimeMillis())
            .build();
        execution = executionRepository.save(execution);

        // Update or create holding
        updateHolding(order.getCustomerId(), order.getGoalId(), execution);

        return execution;
    }

    /**
     * Update holding with new purchase
     */
    private void updateHolding(
        Long customerId,
        Long goalId,
        OrderExecution execution
    ) {
        Optional<Holding> existing = holdingRepository
            .findByCustomerIdAndGoalIdAndSchemeCode(
                customerId, goalId, execution.getSchemeCode());

        Holding holding;
        if (existing.isPresent()) {
            // Add to existing holding
            holding = existing.get();
            holding.addUnits(execution.getUnits(), execution.getNav(), execution.getAmount());
        } else {
            // Create new holding
            holding = Holding.builder()
                .customerId(customerId)
                .goalId(goalId)
                .schemeCode(execution.getSchemeCode())
                .schemeName(execution.getSchemeName())
                .folioNumber(generateFolioNumber())
                .assetClass(execution.getAssetClass())
                .quantity(execution.getUnits())
                .availableQuantity(execution.getUnits())
                .averageCost(execution.getNav())
                .investedAmount(execution.getAmount())
                .firstPurchaseDate(LocalDate.now())
                .lastPurchaseDate(LocalDate.now())
                .isActive(true)
                .build();
        }

        // Update valuation
        holding.updateValuation(execution.getNav());
        holdingRepository.save(holding);

        log.debug("Updated holding for scheme: {}, Units: {}",
            execution.getSchemeCode(), execution.getUnits());
    }

    private String generateOrderNumber() {
        return "ORD-" + LocalDate.now().getYear() + "-" +
            String.format("%06d", orderRepository.count() + 1);
    }

    private String generateFolioNumber() {
        return "FOL-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }
}
```

#### PortfolioValuationService.java

```java
@Service
@Slf4j
@RequiredArgsConstructor
public class PortfolioValuationService {

    private final HoldingRepository holdingRepository;
    private final NAVProviderService navProvider;
    private final PortfolioValuationRepository valuationRepository;

    /**
     * Calculate portfolio summary for a customer
     */
    public PortfolioSummaryDto getPortfolioSummary(Long customerId) {
        log.debug("Calculating portfolio summary for customer: {}", customerId);

        List<Holding> holdings = holdingRepository
            .findByCustomerIdAndIsActive(customerId, true);

        if (holdings.isEmpty()) {
            return PortfolioSummaryDto.empty(customerId);
        }

        // Update all holdings with latest NAVs
        for (Holding holding : holdings) {
            try {
                BigDecimal latestNav = navProvider.getLatestNav(holding.getSchemeCode());
                holding.updateValuation(latestNav);
                holdingRepository.save(holding);
            } catch (Exception e) {
                log.error("Failed to update NAV for holding: {}", holding.getId());
            }
        }

        // Calculate aggregates
        BigDecimal totalInvested = holdings.stream()
            .map(Holding::getInvestedAmount)
            .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal currentValue = holdings.stream()
            .map(Holding::getCurrentValue)
            .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal unrealizedGain = currentValue.subtract(totalInvested);

        BigDecimal gainPercentage = totalInvested.compareTo(BigDecimal.ZERO) > 0
            ? unrealizedGain.multiply(new BigDecimal("100"))
                .divide(totalInvested, 2, RoundingMode.HALF_UP)
            : BigDecimal.ZERO;

        // Get previous day's value for day change
        BigDecimal previousDayValue = getPreviousDayValue(customerId);
        BigDecimal dayChange = currentValue.subtract(previousDayValue);
        BigDecimal dayChangePercentage = previousDayValue.compareTo(BigDecimal.ZERO) > 0
            ? dayChange.multiply(new BigDecimal("100"))
                .divide(previousDayValue, 2, RoundingMode.HALF_UP)
            : BigDecimal.ZERO;

        // Build summary
        return PortfolioSummaryDto.builder()
            .customerId(customerId)
            .totalInvested(totalInvested)
            .currentValue(currentValue)
            .unrealizedGain(unrealizedGain)
            .gainPercentage(gainPercentage)
            .dayChange(dayChange)
            .dayChangePercentage(dayChangePercentage)
            .totalHoldings(holdings.size())
            .asOfDate(LocalDate.now())
            .build();
    }

    /**
     * Calculate portfolio summary for a specific goal
     */
    public PortfolioSummaryDto getGoalPortfolioSummary(Long goalId) {
        List<Holding> holdings = holdingRepository
            .findByGoalIdAndIsActive(goalId, true);

        // Similar logic as above, scoped to goal
        // ... (implementation similar to above)
    }

    /**
     * Get holdings breakdown with current valuations
     */
    public List<HoldingDto> getHoldingsBreakdown(Long customerId) {
        List<Holding> holdings = holdingRepository
            .findByCustomerIdAndIsActive(customerId, true);

        return holdings.stream()
            .map(this::mapToDto)
            .sorted(Comparator.comparing(HoldingDto::getCurrentValue).reversed())
            .collect(Collectors.toList());
    }

    /**
     * Scheduled job: Daily portfolio valuation snapshot
     * Runs at 7 PM IST after NAVs are synced
     */
    @Scheduled(cron = "0 0 19 * * ?", zone = "Asia/Kolkata")
    @Transactional
    public void createDailyValuationSnapshots() {
        log.info("Creating daily portfolio valuation snapshots");

        // Get all active customers with holdings
        List<Long> customerIds = holdingRepository.findAllDistinctCustomerIds();

        for (Long customerId : customerIds) {
            try {
                PortfolioSummaryDto summary = getPortfolioSummary(customerId);

                // Save snapshot
                PortfolioValuation valuation = PortfolioValuation.builder()
                    .customerId(customerId)
                    .valuationDate(LocalDate.now())
                    .totalInvested(summary.getTotalInvested())
                    .currentValue(summary.getCurrentValue())
                    .unrealizedGain(summary.getUnrealizedGain())
                    .gainPercentage(summary.getGainPercentage())
                    .dayChange(summary.getDayChange())
                    .dayChangePercentage(summary.getDayChangePercentage())
                    .build();
                valuationRepository.save(valuation);

                log.debug("Saved valuation snapshot for customer: {}", customerId);
            } catch (Exception e) {
                log.error("Failed to create valuation snapshot for customer: {}",
                    customerId, e);
            }
        }

        log.info("Daily valuation snapshots completed for {} customers",
            customerIds.size());
    }

    private BigDecimal getPreviousDayValue(Long customerId) {
        LocalDate yesterday = LocalDate.now().minusDays(1);
        return valuationRepository
            .findByCustomerIdAndValuationDate(customerId, yesterday)
            .map(PortfolioValuation::getCurrentValue)
            .orElse(BigDecimal.ZERO);
    }

    private HoldingDto mapToDto(Holding holding) {
        return HoldingDto.builder()
            .id(holding.getId())
            .schemeCode(holding.getSchemeCode())
            .schemeName(holding.getSchemeName())
            .assetClass(holding.getAssetClass())
            .quantity(holding.getQuantity())
            .averageCost(holding.getAverageCost())
            .currentNav(holding.getCurrentNav())
            .investedAmount(holding.getInvestedAmount())
            .currentValue(holding.getCurrentValue())
            .unrealizedGain(holding.getUnrealizedGain())
            .unrealizedGainPercentage(holding.getUnrealizedGainPercentage())
            .firstPurchaseDate(holding.getFirstPurchaseDate())
            .lastPurchaseDate(holding.getLastPurchaseDate())
            .build();
    }
}
```

#### SIPExecutionService.java

```java
@Service
@Slf4j
@RequiredArgsConstructor
public class SIPExecutionService {

    private final SipScheduleRepository sipRepository;
    private final InvestmentOrderService orderService;
    private final NotificationService notificationService;

    /**
     * Scheduled job: Execute due SIPs
     * Runs daily at 9:30 AM IST
     */
    @Scheduled(cron = "0 30 9 * * ?", zone = "Asia/Kolkata")
    @Transactional
    public void executeDueSIPs() {
        log.info("Executing due SIPs for date: {}", LocalDate.now());

        List<SipSchedule> dueSips = sipRepository
            .findByStatusAndNextExecutionDate(
                SipSchedule.SipStatus.ACTIVE,
                LocalDate.now()
            );

        log.info("Found {} SIPs due for execution", dueSips.size());

        int success = 0;
        int failed = 0;

        for (SipSchedule sip : dueSips) {
            try {
                executeSIP(sip);
                success++;
            } catch (Exception e) {
                failed++;
                sip.setExecutionsFailed(sip.getExecutionsFailed() + 1);
                log.error("Failed to execute SIP: {}", sip.getSipNumber(), e);
            }
        }

        log.info("SIP execution completed. Success: {}, Failed: {}", success, failed);
    }

    /**
     * Execute a single SIP
     */
    @Transactional
    public void executeSIP(SipSchedule sip) {
        log.info("Executing SIP: {} for amount: {}",
            sip.getSipNumber(), sip.getMonthlyAmount());

        // Get original proposal/order to know fund distribution
        InvestmentOrder initialOrder = orderRepository
            .findById(sip.getInitialOrderId())
            .orElseThrow(() -> new RuntimeException("Initial order not found"));

        // Create SIP order (uses same fund distribution as initial order)
        InvestmentOrder sipOrder = InvestmentOrder.builder()
            .orderNumber(generateSipOrderNumber())
            .customerId(sip.getCustomerId())
            .goalId(sip.getGoalId())
            .orderType(InvestmentOrder.OrderType.SIP)
            .orderStatus(InvestmentOrder.OrderStatus.PENDING)
            .totalAmount(sip.getMonthlyAmount())
            .orderDate(LocalDateTime.now())
            .notes("SIP Execution: " + sip.getSipNumber())
            .build();
        sipOrder = orderRepository.save(sipOrder);

        // Execute purchases (proportional to initial allocation)
        List<OrderExecution> initialExecutions = executionRepository
            .findByOrderId(initialOrder.getId());

        for (OrderExecution initialExec : initialExecutions) {
            // Calculate proportional amount for this fund
            BigDecimal proportion = initialExec.getAmount()
                .divide(initialOrder.getTotalAmount(), 6, RoundingMode.HALF_UP);
            BigDecimal sipFundAmount = sip.getMonthlyAmount()
                .multiply(proportion)
                .setScale(2, RoundingMode.HALF_UP);

            // Execute purchase
            orderService.executeFundPurchase(
                sipOrder,
                initialExec.getSchemeCode(),
                initialExec.getSchemeName(),
                sipFundAmount,
                initialExec.getAssetClass()
            );
        }

        // Update SIP schedule
        sip.recordExecution(sip.getMonthlyAmount());
        sipRepository.save(sip);

        // Update order status
        sipOrder.setOrderStatus(InvestmentOrder.OrderStatus.EXECUTED);
        sipOrder.setExecutionDate(LocalDateTime.now());
        orderRepository.save(sipOrder);

        // Send notification
        notificationService.sendSipExecutionNotification(sip.getCustomerId(), sip);

        log.info("SIP {} executed successfully. Next execution: {}",
            sip.getSipNumber(), sip.getNextExecutionDate());
    }

    private String generateSipOrderNumber() {
        return "SIP-" + LocalDate.now().getYear() + "-" +
            String.format("%06d", orderRepository.countSipOrders() + 1);
    }
}
```

### 6.3 Controller Layer

#### CustomerPortfolioController.java

```java
@RestController
@RequestMapping("/api/v1/customer/portfolio")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Customer Portfolio", description = "Customer portfolio and holdings management")
@SecurityRequirement(name = "bearerAuth")
public class CustomerPortfolioController {

    private final PortfolioValuationService valuationService;
    private final GoalProgressService goalProgressService;
    private final AuthService authService;

    @GetMapping("/summary")
    @PreAuthorize("hasRole('CUSTOMER')")
    @Operation(summary = "Get portfolio summary")
    public ResponseEntity<PortfolioSummaryDto> getPortfolioSummary(
        Authentication authentication
    ) {
        Long customerId = authService.getCurrentCustomerId(authentication);
        PortfolioSummaryDto summary = valuationService.getPortfolioSummary(customerId);
        return ResponseEntity.ok(summary);
    }

    @GetMapping("/holdings")
    @PreAuthorize("hasRole('CUSTOMER')")
    @Operation(summary = "Get all holdings with current valuations")
    public ResponseEntity<List<HoldingDto>> getHoldings(
        Authentication authentication
    ) {
        Long customerId = authService.getCurrentCustomerId(authentication);
        List<HoldingDto> holdings = valuationService.getHoldingsBreakdown(customerId);
        return ResponseEntity.ok(holdings);
    }

    @GetMapping("/goals/{goalId}/holdings")
    @PreAuthorize("hasRole('CUSTOMER')")
    @Operation(summary = "Get holdings for a specific goal")
    public ResponseEntity<List<HoldingDto>> getGoalHoldings(
        @PathVariable Long goalId,
        Authentication authentication
    ) {
        Long customerId = authService.getCurrentCustomerId(authentication);

        // Verify goal belongs to customer
        goalService.verifyGoalOwnership(goalId, customerId);

        List<HoldingDto> holdings = valuationService.getGoalHoldings(goalId);
        return ResponseEntity.ok(holdings);
    }

    @GetMapping("/goals")
    @PreAuthorize("hasRole('CUSTOMER')")
    @Operation(summary = "Get all goals with progress")
    public ResponseEntity<List<GoalProgressDto>> getGoalsProgress(
        Authentication authentication
    ) {
        Long customerId = authService.getCurrentCustomerId(authentication);
        List<GoalProgressDto> goals = goalProgressService.getAllGoalsProgress(customerId);
        return ResponseEntity.ok(goals);
    }

    @GetMapping("/goals/{goalId}/progress")
    @PreAuthorize("hasRole('CUSTOMER')")
    @Operation(summary = "Get detailed progress for a goal")
    public ResponseEntity<GoalProgressDto> getGoalProgress(
        @PathVariable Long goalId,
        Authentication authentication
    ) {
        Long customerId = authService.getCurrentCustomerId(authentication);
        goalService.verifyGoalOwnership(goalId, customerId);

        GoalProgressDto progress = goalProgressService.getGoalProgress(goalId);
        return ResponseEntity.ok(progress);
    }

    @GetMapping("/performance")
    @PreAuthorize("hasRole('CUSTOMER')")
    @Operation(summary = "Get portfolio performance over time")
    public ResponseEntity<PerformanceDto> getPerformance(
        @RequestParam(required = false, defaultValue = "1Y") String period,
        Authentication authentication
    ) {
        Long customerId = authService.getCurrentCustomerId(authentication);
        PerformanceDto performance = valuationService.getPerformance(customerId, period);
        return ResponseEntity.ok(performance);
    }

    @GetMapping("/asset-allocation")
    @PreAuthorize("hasRole('CUSTOMER')")
    @Operation(summary = "Get asset allocation breakdown")
    public ResponseEntity<AssetAllocationDto> getAssetAllocation(
        Authentication authentication
    ) {
        Long customerId = authService.getCurrentCustomerId(authentication);
        AssetAllocationDto allocation = valuationService.getAssetAllocation(customerId);
        return ResponseEntity.ok(allocation);
    }
}
```

---

## 7. Frontend Implementation

### 7.1 Customer Dashboard Component

File: `/frontend/src/app/features/client-portal/dashboard/dashboard.component.ts`

```typescript
import { Component, OnInit, inject, signal, computed } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { LucideAngularModule } from 'lucide-angular';
import { CustomerPortfolioService } from '@core/services/customer-portfolio.service';
import type {
  PortfolioSummary,
  GoalProgress,
  Holding
} from '@core/models/portfolio.model';

@Component({
  selector: 'app-customer-dashboard',
  standalone: true,
  imports: [CommonModule, RouterLink, LucideAngularModule],
  templateUrl: './dashboard.component.html',
  styleUrl: './dashboard.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class CustomerDashboardComponent implements OnInit {
  private readonly portfolioService = inject(CustomerPortfolioService);

  // State
  protected readonly portfolioSummary = signal<PortfolioSummary | null>(null);
  protected readonly goals = signal<GoalProgress[]>([]);
  protected readonly topHoldings = signal<Holding[]>([]);
  protected readonly loading = signal(true);

  // Computed
  protected readonly totalGoals = computed(() => this.goals().length);
  protected readonly onTrackGoals = computed(() =>
    this.goals().filter(g => g.status === 'ON_TRACK').length
  );
  protected readonly behindGoals = computed(() =>
    this.goals().filter(g => g.status === 'BEHIND').length
  );

  ngOnInit(): void {
    this.loadDashboardData();
  }

  private loadDashboardData(): void {
    this.loading.set(true);

    forkJoin({
      summary: this.portfolioService.getPortfolioSummary(),
      goals: this.portfolioService.getGoalsProgress(),
      holdings: this.portfolioService.getHoldings()
    }).subscribe({
      next: ({ summary, goals, holdings }) => {
        this.portfolioSummary.set(summary);
        this.goals.set(goals);
        this.topHoldings.set(holdings.slice(0, 5)); // Top 5
        this.loading.set(false);
      },
      error: (err) => {
        console.error('Failed to load dashboard:', err);
        this.loading.set(false);
      }
    });
  }

  protected getStatusColor(status: string): string {
    switch (status) {
      case 'ON_TRACK': return 'bg-[var(--color-success)]';
      case 'AHEAD': return 'bg-[var(--color-info)]';
      case 'BEHIND': return 'bg-[var(--color-warning)]';
      default: return 'bg-[var(--color-muted)]';
    }
  }

  protected formatCurrency(amount: number): string {
    return new Intl.NumberFormat('en-IN', {
      style: 'currency',
      currency: 'INR',
      maximumFractionDigits: 0
    }).format(amount);
  }
}
```

### 7.2 Customer Dashboard Template

File: `/frontend/src/app/features/client-portal/dashboard/dashboard.component.html`

```html
<div class="min-h-screen bg-[var(--color-quinary)] p-6">
  <!-- Page Header -->
  <div class="mb-8">
    <h1 class="text-3xl font-bold text-[var(--color-primary)]">
      My Portfolio
    </h1>
    <p class="text-[var(--color-tertiary)] mt-2">
      Track your investments and goal progress
    </p>
  </div>

  @if (loading()) {
    <div class="flex justify-center items-center h-64">
      <lucide-icon name="loader-2" class="animate-spin" [size]="32"></lucide-icon>
    </div>
  } @else {
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
      <!-- Portfolio Summary Card -->
      <div class="lg:col-span-2 bg-white rounded-lg shadow p-6">
        <h2 class="text-xl font-semibold mb-4">Portfolio Summary</h2>

        @if (portfolioSummary()) {
          <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
            <!-- Total Invested -->
            <div>
              <p class="text-sm text-[var(--color-tertiary)]">Total Invested</p>
              <p class="text-2xl font-bold text-[var(--color-primary)]">
                {{ formatCurrency(portfolioSummary()!.totalInvested) }}
              </p>
            </div>

            <!-- Current Value -->
            <div>
              <p class="text-sm text-[var(--color-tertiary)]">Current Value</p>
              <p class="text-2xl font-bold text-[var(--color-primary)]">
                {{ formatCurrency(portfolioSummary()!.currentValue) }}
              </p>
            </div>

            <!-- Unrealized Gain -->
            <div>
              <p class="text-sm text-[var(--color-tertiary)]">Total Gain</p>
              <p class="text-2xl font-bold"
                 [ngClass]="{
                   'text-[var(--color-success)]': portfolioSummary()!.unrealizedGain >= 0,
                   'text-[var(--color-error)]': portfolioSummary()!.unrealizedGain < 0
                 }">
                {{ formatCurrency(portfolioSummary()!.unrealizedGain) }}
              </p>
              <p class="text-sm">
                ({{ portfolioSummary()!.gainPercentage.toFixed(2) }}%)
              </p>
            </div>

            <!-- Today's Change -->
            <div>
              <p class="text-sm text-[var(--color-tertiary)]">Today's Change</p>
              <p class="text-lg font-semibold"
                 [ngClass]="{
                   'text-[var(--color-success)]': portfolioSummary()!.dayChange >= 0,
                   'text-[var(--color-error)]': portfolioSummary()!.dayChange < 0
                 }">
                {{ formatCurrency(portfolioSummary()!.dayChange) }}
              </p>
              <p class="text-sm">
                ({{ portfolioSummary()!.dayChangePercentage.toFixed(2) }}%)
              </p>
            </div>
          </div>
        }
      </div>

      <!-- Quick Stats -->
      <div class="bg-white rounded-lg shadow p-6">
        <h2 class="text-xl font-semibold mb-4">Goal Stats</h2>
        <div class="space-y-4">
          <div class="flex justify-between items-center">
            <span class="text-[var(--color-tertiary)]">Total Goals</span>
            <span class="text-2xl font-bold">{{ totalGoals() }}</span>
          </div>
          <div class="flex justify-between items-center">
            <span class="text-[var(--color-tertiary)]">On Track</span>
            <span class="text-xl font-semibold text-[var(--color-success)]">
              {{ onTrackGoals() }}
            </span>
          </div>
          <div class="flex justify-between items-center">
            <span class="text-[var(--color-tertiary)]">Needs Attention</span>
            <span class="text-xl font-semibold text-[var(--color-warning)]">
              {{ behindGoals() }}
            </span>
          </div>
        </div>
      </div>
    </div>

    <!-- Goals Progress -->
    <div class="mt-6 bg-white rounded-lg shadow p-6">
      <div class="flex justify-between items-center mb-4">
        <h2 class="text-xl font-semibold">My Goals</h2>
        <a [routerLink]="['/client/goals']"
           class="text-[var(--color-accent)] hover:underline">
          View All
        </a>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        @for (goal of goals(); track goal.goalId) {
          <div class="border border-[var(--color-quaternary)] rounded-lg p-4
                      hover:shadow-md transition-shadow cursor-pointer"
               [routerLink]="['/client/goals', goal.goalId]">
            <!-- Goal Header -->
            <div class="flex justify-between items-start mb-3">
              <div>
                <h3 class="font-semibold text-[var(--color-primary)]">
                  {{ goal.goalName }}
                </h3>
                <p class="text-sm text-[var(--color-tertiary)]">
                  {{ goal.goalType }}
                </p>
              </div>
              <span class="px-2 py-1 text-xs rounded-full"
                    [ngClass]="getStatusColor(goal.status)">
                {{ goal.status }}
              </span>
            </div>

            <!-- Progress Bar -->
            <div class="mb-3">
              <div class="flex justify-between text-sm mb-1">
                <span>Progress</span>
                <span class="font-semibold">
                  {{ goal.achievementPercentage.toFixed(1) }}%
                </span>
              </div>
              <div class="w-full bg-[var(--color-quaternary)] rounded-full h-2">
                <div class="bg-[var(--color-accent)] h-2 rounded-full"
                     [style.width.%]="goal.achievementPercentage">
                </div>
              </div>
            </div>

            <!-- Goal Stats -->
            <div class="grid grid-cols-2 gap-2 text-sm">
              <div>
                <p class="text-[var(--color-tertiary)]">Target</p>
                <p class="font-semibold">
                  {{ formatCurrency(goal.targetAmount) }}
                </p>
              </div>
              <div>
                <p class="text-[var(--color-tertiary)]">Achieved</p>
                <p class="font-semibold">
                  {{ formatCurrency(goal.currentValue) }}
                </p>
              </div>
              <div>
                <p class="text-[var(--color-tertiary)]">Time Remaining</p>
                <p class="font-semibold">{{ goal.remainingMonths }} months</p>
              </div>
              <div>
                <p class="text-[var(--color-tertiary)]">Monthly SIP</p>
                <p class="font-semibold">
                  {{ formatCurrency(goal.monthlySip) }}
                </p>
              </div>
            </div>
          </div>
        }
      </div>
    </div>

    <!-- Top Holdings -->
    <div class="mt-6 bg-white rounded-lg shadow p-6">
      <div class="flex justify-between items-center mb-4">
        <h2 class="text-xl font-semibold">Top Holdings</h2>
        <a [routerLink]="['/client/holdings']"
           class="text-[var(--color-accent)] hover:underline">
          View All
        </a>
      </div>

      <div class="overflow-x-auto">
        <table class="w-full">
          <thead>
            <tr class="border-b border-[var(--color-quaternary)]">
              <th class="text-left py-2">Fund Name</th>
              <th class="text-right py-2">Invested</th>
              <th class="text-right py-2">Current Value</th>
              <th class="text-right py-2">Returns</th>
            </tr>
          </thead>
          <tbody>
            @for (holding of topHoldings(); track holding.id) {
              <tr class="border-b border-[var(--color-quaternary)] hover:bg-[var(--color-quinary)]">
                <td class="py-3">
                  <div>
                    <p class="font-medium">{{ holding.schemeName }}</p>
                    <p class="text-sm text-[var(--color-tertiary)]">
                      {{ holding.assetClass }}
                    </p>
                  </div>
                </td>
                <td class="text-right">
                  {{ formatCurrency(holding.investedAmount) }}
                </td>
                <td class="text-right font-semibold">
                  {{ formatCurrency(holding.currentValue) }}
                </td>
                <td class="text-right">
                  <span [ngClass]="{
                    'text-[var(--color-success)]': holding.unrealizedGain >= 0,
                    'text-[var(--color-error)]': holding.unrealizedGain < 0
                  }">
                    {{ formatCurrency(holding.unrealizedGain) }}
                    <br/>
                    ({{ holding.unrealizedGainPercentage.toFixed(2) }}%)
                  </span>
                </td>
              </tr>
            }
          </tbody>
        </table>
      </div>
    </div>
  }
</div>
```

---

## 8. NAV Integration

### MFapi.in Integration

**Endpoint**: `https://api.mfapi.in/mf/{schemeCode}`

**Example Response**:
```json
{
  "meta": {
    "fund_house": "HDFC Mutual Fund",
    "scheme_type": "Open Ended Schemes",
    "scheme_category": "Equity Scheme - Large Cap Fund",
    "scheme_code": "119551",
    "scheme_name": "HDFC Top 100 Fund - Direct Plan - Growth"
  },
  "data": [
    {
      "date": "08-01-2026",
      "nav": "542.30"
    },
    {
      "date": "07-01-2026",
      "nav": "540.85"
    }
  ],
  "status": "SUCCESS"
}
```

**Usage in Service**:
```java
@Service
public class MFApiClient {

    private static final String BASE_URL = "https://api.mfapi.in/mf/";

    @Autowired
    private RestTemplate restTemplate;

    public MFApiResponse getSchemeData(String schemeCode) {
        String url = BASE_URL + schemeCode;
        return restTemplate.getForObject(url, MFApiResponse.class);
    }

    public BigDecimal getLatestNav(String schemeCode) {
        MFApiResponse response = getSchemeData(schemeCode);
        if (response != null && !response.getData().isEmpty()) {
            return new BigDecimal(response.getData().get(0).getNav());
        }
        throw new RuntimeException("NAV not available for: " + schemeCode);
    }
}
```

---

## 9. Portfolio Valuation Logic

### Real-Time Valuation Formula

```
For each holding:
  Current Value = Units × Latest NAV
  Unrealized Gain = Current Value - Invested Amount
  Gain % = (Unrealized Gain / Invested Amount) × 100

For portfolio:
  Total Current Value = Σ (All Holdings Current Value)
  Total Invested = Σ (All Holdings Invested Amount)
  Total Unrealized Gain = Total Current Value - Total Invested
  Portfolio Gain % = (Total Unrealized Gain / Total Invested) × 100
```

### XIRR Calculation (Annualized Return)

```
XIRR considers:
- Initial investment date & amount
- Each SIP date & amount
- Current portfolio value as of today

Formula: IRR of irregular cash flows
Implementation: Newton-Raphson method

Example:
05-Jan-2023: -₹1,00,000 (initial investment)
05-Feb-2023: -₹10,000 (SIP)
05-Mar-2023: -₹10,000 (SIP)
... (13 SIPs)
08-Jan-2026: +₹2,45,670 (current value)

XIRR = 8.46% per annum
```

---

## 10. Goal Achievement Tracking

### Progress Calculation Logic

```java
public GoalProgressDto calculateGoalProgress(Long goalId) {
    Goal goal = goalRepository.findById(goalId)
        .orElseThrow(() -> new RuntimeException("Goal not found"));

    // Get current portfolio value for this goal
    PortfolioSummaryDto portfolio = valuationService
        .getGoalPortfolioSummary(goalId);

    // Achievement percentage
    BigDecimal targetAmount = goal.getTargetAmount();
    BigDecimal currentValue = portfolio.getCurrentValue();
    BigDecimal achievementPercentage = currentValue
        .multiply(new BigDecimal("100"))
        .divide(targetAmount, 2, RoundingMode.HALF_UP);

    // Timeline percentage
    LocalDate startDate = goal.getCreatedAt().toLocalDate();
    LocalDate targetDate = goal.getTargetDate();
    LocalDate today = LocalDate.now();

    long totalDays = ChronoUnit.DAYS.between(startDate, targetDate);
    long elapsedDays = ChronoUnit.DAYS.between(startDate, today);
    BigDecimal timelinePercentage = new BigDecimal(elapsedDays)
        .multiply(new BigDecimal("100"))
        .divide(new BigDecimal(totalDays), 2, RoundingMode.HALF_UP);

    // Status determination
    String status;
    BigDecimal progressDifference = achievementPercentage.subtract(timelinePercentage);

    if (progressDifference.compareTo(new BigDecimal("5")) >= 0) {
        status = "AHEAD"; // More than 5% ahead of timeline
    } else if (progressDifference.compareTo(new BigDecimal("-5")) <= 0) {
        status = "BEHIND"; // More than 5% behind timeline
    } else {
        status = "ON_TRACK"; // Within ±5% of timeline
    }

    return GoalProgressDto.builder()
        .goalId(goal.getId())
        .goalName(goal.getGoalName())
        .targetAmount(targetAmount)
        .currentValue(currentValue)
        .achievementPercentage(achievementPercentage)
        .timelinePercentage(timelinePercentage)
        .progressDifference(progressDifference)
        .status(status)
        .remainingMonths((int) ChronoUnit.MONTHS.between(today, targetDate))
        .build();
}
```

### Status Determination

```
Progress Difference = Achievement % - Timeline %

If Progress Difference >= +5%: AHEAD 🚀
If Progress Difference between -5% and +5%: ON_TRACK ✅
If Progress Difference <= -5%: BEHIND ⚠️

Example:
Goal: ₹10 Lakh target in 12 years
Current: 13 months elapsed, ₹2.46 Lakh achieved

Timeline %: (13 / 144 months) = 9.03%
Achievement %: (2.46 / 10) = 24.6%
Progress Difference: 24.6 - 9.03 = +15.57%

Status: AHEAD 🚀 (more than 5% ahead)
```

---

## 11. Dashboard UI/UX Design

### Customer Dashboard Layout

```
┌─────────────────────────────────────────────────────────────┐
│ My Portfolio                                                 │
│ Track your investments and goal progress                     │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│ ┌──────────────────────Portfolio Summary──────────────────┐ │
│ │ Total Invested  Current Value  Total Gain  Today's Change│ │
│ │   ₹2,30,000      ₹2,45,670    +₹15,670       +₹245      │ │
│ │                                 (+6.8%)       (+0.1%)     │ │
│ └──────────────────────────────────────────────────────────┘ │
│                                                              │
│ ┌──────────────────────My Goals──────────────────────────┐  │
│ │                                                          │  │
│ │ Goal 1: Retirement Planning          [ON_TRACK]         │  │
│ │ ▓▓▓▓▓░░░░░ 24.6%                                        │  │
│ │ Target: ₹1 Cr | Achieved: ₹2.46 L | Remaining: 143 mo  │  │
│ │                                                          │  │
│ │ Goal 2: Child Education              [BEHIND]           │  │
│ │ ▓▓▓░░░░░░░ 12.4%                                        │  │
│ │ Target: ₹50 L | Achieved: ₹62 K | Remaining: 179 mo    │  │
│ │                                                          │  │
│ │ Goal 3: House Purchase               [AHEAD]            │  │
│ │ ▓▓▓▓░░░░░░ 18.3%                                        │  │
│ │ Target: ₹75 L | Achieved: ₹1.37 L | Remaining: 95 mo   │  │
│ └──────────────────────────────────────────────────────────┘ │
│                                                              │
│ ┌──────────────────────Top Holdings──────────────────────┐  │
│ │ Fund Name            Invested  Current    Returns       │  │
│ │ HDFC Top 100         ₹45,230   ₹48,940   +₹3,710(+8.2%)│  │
│ │ ICICI Bluechip       ₹38,560   ₹41,065   +₹2,505(+6.5%)│  │
│ │ SBI Magnum Mid Cap   ₹22,340   ₹24,120   +₹1,780(+8.0%)│  │
│ │                                                          │  │
│ │                                         [View All →]     │  │
│ └──────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### RM Dashboard - Customer Portfolio View

```
┌─────────────────────────────────────────────────────────────┐
│ Customer: Priya Sharma (CUST-001)                            │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│ Portfolio Overview:                                          │
│ ├─ Total Value: ₹4,45,670                                   │
│ ├─ Total Invested: ₹3,80,000                                │
│ ├─ Unrealized Gain: +₹65,670 (+17.28%)                      │
│ └─ Active Goals: 3                                           │
│                                                              │
│ ┌────────────────Goal-wise Breakdown───────────────────┐    │
│ │                                                        │    │
│ │ Goal 1: Retirement (Balance 60/40)                    │    │
│ │ ├─ Portfolio Value: ₹2,45,670                         │    │
│ │ ├─ Target: ₹1 Cr (24.6% achieved)                     │    │
│ │ ├─ Status: ON_TRACK ✅                                 │    │
│ │ └─ Holdings: 11 funds                                  │    │
│ │                                                        │    │
│ │ Goal 2: Child Education (Aggressive 80/20)            │    │
│ │ ├─ Portfolio Value: ₹62,000                           │    │
│ │ ├─ Target: ₹50 L (12.4% achieved)                     │    │
│ │ ├─ Status: BEHIND ⚠️                                   │    │
│ │ └─ Holdings: 9 funds                                   │    │
│ │                                                        │    │
│ │ Goal 3: House Purchase (Conservative 20/80)           │    │
│ │ ├─ Portfolio Value: ₹1,38,000                         │    │
│ │ ├─ Target: ₹75 L (18.4% achieved)                     │    │
│ │ ├─ Status: AHEAD 🚀                                    │    │
│ │ └─ Holdings: 7 funds                                   │    │
│ └────────────────────────────────────────────────────────┘    │
│                                                              │
│ Recent Transactions:                                         │
│ ├─ 05-Dec-2025: SIP Execution - ₹10,000 (11 funds)         │
│ ├─ 05-Nov-2025: SIP Execution - ₹10,000 (11 funds)         │
│ └─ 05-Oct-2025: SIP Execution - ₹10,000 (11 funds)         │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 12. Implementation Roadmap

### Phase 2A: Investment Execution (2 weeks)

**Week 1: Backend Foundation**
- [ ] Day 1-2: Database schema implementation (8 new tables)
- [ ] Day 3-4: Entity classes and repositories
- [ ] Day 5-6: NAV Provider Service (MFapi.in integration)
- [ ] Day 7: Investment Order Service (order execution logic)

**Week 2: Backend Services**
- [ ] Day 8-9: Holdings Service (valuation, updates)
- [ ] Day 10-11: SIP Execution Service (scheduled jobs)
- [ ] Day 12-13: Portfolio Valuation Service (XIRR, metrics)
- [ ] Day 14: Goal Progress Service (achievement tracking)

### Phase 2B: Customer Portal (2 weeks)

**Week 3: Core Features**
- [ ] Day 15-16: Dashboard component (portfolio summary)
- [ ] Day 17-18: Holdings view component (table, filters)
- [ ] Day 19-20: Goal progress component (cards, charts)
- [ ] Day 21: Asset allocation chart (pie chart)

**Week 4: Advanced Features**
- [ ] Day 22-23: Performance charts (line charts over time)
- [ ] Day 24-25: Transaction history component
- [ ] Day 26-27: Goal detail view (breakdown, projections)
- [ ] Day 28: Integration testing & bug fixes

### Phase 2C: Demo Data & Testing (1 week)

**Week 5: Data & Polish**
- [ ] Day 29-30: Demo data seed script (10 customers, 18-22 months)
- [ ] Day 31-32: NAV history population (real historical data)
- [ ] Day 33-34: End-to-end testing (all user flows)
- [ ] Day 35: UI/UX refinement, documentation

**Total Duration**: 5 weeks (35 days)

---

## 13. Testing Strategy

### Unit Tests

```java
@Test
public void testHoldingValuation() {
    // Given
    Holding holding = Holding.builder()
        .schemeCode("119551")
        .quantity(new BigDecimal("40.0000"))
        .averageCost(new BigDecimal("500.00"))
        .investedAmount(new BigDecimal("20000"))
        .build();

    BigDecimal latestNav = new BigDecimal("542.30");

    // When
    holding.updateValuation(latestNav);

    // Then
    assertEquals(new BigDecimal("21692.00"), holding.getCurrentValue());
    assertEquals(new BigDecimal("1692.00"), holding.getUnrealizedGain());
    assertEquals(new BigDecimal("8.46"), holding.getUnrealizedGainPercentage());
}

@Test
public void testGoalProgressCalculation() {
    // Test ON_TRACK status
    // Test AHEAD status
    // Test BEHIND status
}

@Test
public void testSipExecution() {
    // Test proportional fund allocation
    // Test unit calculation
    // Test holding update
    // Test schedule update
}
```

### Integration Tests

```java
@SpringBootTest
@AutoConfigureMockMvc
public class CustomerPortfolioIntegrationTest {

    @Test
    @WithMockUser(roles = "CUSTOMER")
    public void testGetPortfolioSummary() throws Exception {
        mockMvc.perform(get("/api/v1/customer/portfolio/summary"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.totalInvested").exists())
            .andExpect(jsonPath("$.currentValue").exists())
            .andExpect(jsonPath("$.unrealizedGain").exists());
    }

    @Test
    public void testDailyNavSync() {
        // Mock MFapi.in response
        // Trigger sync job
        // Verify nav_history records created
    }
}
```

### E2E Testing Scenarios

1. **Customer Views Dashboard**
   - Login as customer
   - Navigate to dashboard
   - Verify portfolio summary displays
   - Verify goals show correct progress
   - Verify holdings table displays

2. **Goal Progress Tracking**
   - Navigate to specific goal
   - Verify achievement percentage
   - Verify timeline progress
   - Verify status badge (ON_TRACK/BEHIND/AHEAD)

3. **Multiple Goals Scenario**
   - Customer with 3 goals
   - Verify each goal shows separate portfolio
   - Verify total portfolio aggregation
   - Verify holdings breakdown by goal

4. **NAV Update Impact**
   - Trigger daily NAV sync
   - Verify portfolio values updated
   - Verify unrealized gains recalculated
   - Verify dashboard reflects changes

5. **SIP Execution**
   - Trigger SIP execution job
   - Verify orders created
   - Verify holdings updated (units added)
   - Verify schedule updated (next execution date)

---

## Summary

This comprehensive implementation plan provides:

✅ **Complete Database Schema** (8 new tables)
✅ **Backend Services** (NAV provider, order execution, valuation, SIP)
✅ **Frontend Components** (dashboard, holdings, goal tracking)
✅ **Real NAV Integration** (MFapi.in FREE API)
✅ **Demo Data Specification** (10 customers, 18-22 months history)
✅ **Goal Achievement Tracking** (ON_TRACK/BEHIND/AHEAD status)
✅ **One-to-Many Support** (1 customer → N goals → N portfolios)
✅ **Both Portal Views** (Customer + RM dashboards)
✅ **Complete Testing Strategy**
✅ **5-Week Implementation Roadmap**

**Next Steps**:
1. Review and approve this plan
2. Start Phase 2A: Backend implementation
3. Create demo data seed script
4. Build customer portal UI
5. End-to-end testing with real NAV data

This will provide a production-ready demo system showcasing realistic investment behavior without spending actual money. 🚀
