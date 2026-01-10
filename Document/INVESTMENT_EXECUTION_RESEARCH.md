# Investment Execution Flow - Research & Implementation Plan

**Date**: January 6, 2026
**Purpose**: Post-proposal investment execution with custodian integration
**Status**: Research Complete - Ready for Implementation

---

## Executive Summary

After an RM's proposal is accepted by a customer, the system needs to execute the actual investment orders - purchasing the specified funds/assets from the selected model portfolio. This document outlines the complete order execution lifecycle, custodian integration options, reconciliation processes, and a recommended implementation approach for demo purposes.

---

## Table of Contents

1. [Understanding Key Concepts](#1-understanding-key-concepts)
2. [Order Execution Lifecycle](#2-order-execution-lifecycle)
3. [Custodian Services](#3-custodian-services)
4. [Reconciliation Process](#4-reconciliation-process)
5. [Available Sandbox/Demo APIs](#5-available-sandboxdemo-apis)
6. [Recommended Solution for Demo](#6-recommended-solution-for-demo)
7. [Implementation Architecture](#7-implementation-architecture)
8. [Data Model Design](#8-data-model-design)
9. [API Endpoints](#9-api-endpoints)
10. [UI/UX Design](#10-uiux-design)
11. [Sources](#11-sources)

---

## 1. Understanding Key Concepts

### 1.1 Custodian Services

**Definition**: A custodian (typically a bank or specialized financial institution) is an entity that holds and safeguards financial assets on behalf of clients. They provide security, record-keeping, and transaction processing services.

**Key Functions**:

- **Asset Safekeeping**: Physical/electronic custody of securities
- **Settlement Services**: Processing buy/sell transactions
- **Record Keeping**: Maintaining accurate transaction records
- **Reconciliation**: Matching internal records with external sources
- **Reporting**: Providing statements and regulatory reports
- **Corporate Actions**: Processing dividends, splits, mergers

**Major Players**:

- Bank of New York Mellon (BNY Mellon)
- State Street Corporation
- J.P. Morgan Chase
- Citibank
- Northern Trust

### 1.2 Order Management System (OMS)

**Definition**: Software platform designed to streamline the entire lifecycle of trade orders from entry to settlement.

**Core Capabilities**:

- Order creation and routing
- Trade execution tracking
- Compliance monitoring
- Real-time position tracking
- Multi-asset class support
- Integration with EMS (Execution Management System)

### 1.3 Reconciliation

**Definition**: Process of comparing and matching transaction records between different systems to ensure data consistency and accuracy.

**Types**:

- **Trade Reconciliation**: Match executed trades with order records
- **Position Reconciliation**: Verify holdings match custodian records
- **Cash Reconciliation**: Match cash balances and movements
- **NAV Reconciliation**: Verify Net Asset Value calculations

---

## 2. Order Execution Lifecycle

The complete trade lifecycle consists of three main phases:

### Phase 1: Front Office - Trade Execution

**Steps**:

1. **Order Initiation**: RM/System creates order based on approved proposal
2. **Pre-Trade Validation**:
   - Compliance checks (suitability, limits)
   - Availability of funds
   - Trading restrictions
3. **Order Routing**: Send order to broker/custodian
4. **Execution**: Trade executed at market/limit price
5. **Confirmation**: Receive execution confirmation with:
   - Execution price
   - Quantity filled
   - Transaction ID
   - Timestamp

### Phase 2: Middle Office - Validation & Risk

**Steps**:

1. **Trade Capture**: Record executed trade details
2. **Affirmation**: Both parties agree on trade details
3. **Enrichment**: Add missing data (commissions, fees)
4. **Validation**: Check for errors/exceptions
5. **Risk Analysis**: Update risk metrics
6. **Compliance Check**: Ensure regulatory compliance

### Phase 3: Back Office - Settlement & Clearing

**Steps**:

1. **Clearing**: Determine obligations (who owes what)
2. **Settlement Instruction**: Send to custodian/clearing house
3. **Settlement**:
   - **T+1 (US)**: Trade date + 1 business day
   - **T+2 (Europe)**: Trade date + 2 business days
4. **Asset Transfer**: Securities delivered to buyer's account
5. **Cash Transfer**: Payment transferred to seller
6. **Confirmation**: Final settlement confirmation
7. **Reconciliation**: Match all records

**Timeline**:

```
Day 0 (T):    Trade Execution
Day 1 (T+1):  Trade Affirmation & Enrichment
Day 2 (T+2):  Settlement (for most markets)
Day 3 (T+3):  Reconciliation & Reporting
```

---

## 3. Custodian Services

### 3.1 Mutual Fund Custodians

Specialized custodians for mutual fund assets that:

- Secure securities in which mutual funds invest
- Manage settlements for fund transactions
- Track investor transactions
- Ensure proper fund deposits/distributions
- Maintain records for regulatory compliance

**Reference**: [PL Capital - What is Mutual Fund Custodian](https://www.plindia.com/blogs/what-is-mutual-fund-custodian/)

### 3.2 API-Enabled Custody (Modern Approach)

**Seccl Tech**: UK-based FCA-regulated custodian offering:

- Advanced automation
- API-first architecture
- Direct CREST membership (UK securities depository)
- No third-party sub-custodians
- Real-time data access

**Reference**: [Seccl Tech - Custody & Investment Infrastructure](https://seccl.tech/services/custody-investment-infrastructure/)

### 3.3 Integration Models

**Model 1: Direct Custodian Integration**

```
Your System → API → Custodian → Market
```

- Pros: Full control, real-time data
- Cons: Complex integration, costly

**Model 2: Broker-Dealer Integration**

```
Your System → API → Broker → Custodian → Market
```

- Pros: Simplified, broker handles custody
- Cons: Less control, additional layer

**Model 3: Aggregation Platform**

```
Your System → API → Aggregator → Multiple Custodians/Brokers
```

- Pros: Single API, multiple destinations
- Cons: Platform dependency

---

## 4. Reconciliation Process

### 4.1 Investment Reconciliation Workflow

**Source**: [Limina - Investment Reconciliation Guide](https://www.limina.com/blog/investment-reconciliation)

**Daily Reconciliation Steps**:

1. **Position Reconciliation** (Morning)

   ```
   Internal System Positions
   ↕️ (Compare)
   Custodian Position Report

   → Identify breaks (discrepancies)
   → Investigate reasons
   → Resolve differences
   ```

2. **Trade Reconciliation** (Intraday)

   ```
   Order Management System Trades
   ↕️ (Match)
   Broker/Custodian Trade Confirmations

   → Match by: Trade Date, ISIN, Quantity, Price
   → Flag unmatched trades
   → Resolve within T+1
   ```

3. **Cash Reconciliation** (End of Day)

   ```
   Internal Cash Ledger
   ↕️ (Reconcile)
   Bank/Custodian Cash Statement

   → Match settlements
   → Verify fees/commissions
   → Adjust for timing differences
   ```

4. **NAV Reconciliation** (Daily)

   ```
   Internal NAV Calculation
   ↕️ (Verify)
   Fund Administrator NAV

   → Ensure pricing accuracy
   → Verify corporate actions
   → Confirm valuations
   ```

### 4.2 AI-Powered Reconciliation (2026 Trend)

**Modern Features**:

- AI algorithms infer break reasons
- ML recommends next steps
- Automated comment suggestions
- Reduces investigation time by 60-80%

**Vendors**: AutoRek, BlackLine, Trintech

**Reference**: [Gartner - Financial Reconciliation Solutions](https://www.gartner.com/reviews/market/financial-reconciliation-solutions)

### 4.3 Best Practices

1. **Automation**: Use APIs for data synchronization
2. **Real-time Validation**: Check trades immediately
3. **Exception Management**: Flag and route breaks automatically
4. **Audit Trail**: Maintain complete history
5. **Scalability**: Handle high transaction volumes
6. **Integration**: Connect OMS ↔ Accounting ↔ Custodian

**Reference**: [SolveXia - Finance Reconciliation Best Practices](https://www.solvexia.com/blog/finance-reconciliation-how-to-step-by-step-process)

---

## 5. Available Sandbox/Demo APIs

### 5.1 Recommended: Alpaca Markets

**Website**: [Alpaca Markets](https://alpaca.markets/)

**Why Alpaca?**

- ✅ **Paper Trading API**: No real money, perfect for demo
- ✅ **Full Broker API**: Complete trading lifecycle
- ✅ **Extensive Documentation**: Easy to integrate
- ✅ **Sandbox Environment**: Safe testing
- ✅ **Professional Support**: Active community
- ✅ **Free Tier**: No cost for development

**Capabilities**:

- Order placement (market, limit, stop orders)
- Real-time quotes and market data
- Portfolio tracking
- Transaction history
- Account management
- Webhooks for event notifications

**API Example**:

```javascript
// Place buy order
POST https://paper-api.alpaca.markets/v2/orders
{
  "symbol": "AAPL",
  "qty": 10,
  "side": "buy",
  "type": "market",
  "time_in_force": "day"
}

// Response
{
  "id": "61e69015-8549-4bfd-b9c3-01e75843f47d",
  "status": "filled",
  "filled_avg_price": "150.00",
  "filled_qty": "10",
  ...
}
```

### 5.2 Alternative: Financial Modeling Prep (FMP)

**Website**: [FMP Developer Portal](https://site.financialmodelingprep.com/developer/docs)

**Features**:

- Mutual fund data (200,000+ funds)
- Real-time quotes
- Historical prices
- Fund holdings
- Performance metrics

**Use Case**: Data provider (not execution)

**Reference**: [FMP Free Stock Market API](https://site.financialmodelingprep.com/developer/docs)

### 5.3 Alternative: Twelve Data

**Website**: [Twelve Data - Mutual Funds APIs](https://twelvedata.com/news/introducing-mutual-funds-apis)

**Features**:

- 200,000+ international mutual funds
- 50+ countries coverage
- End-of-day quotes
- Performance & risk data
- Holdings information
- Sustainability metrics

**Use Case**: Mutual fund data enrichment

### 5.4 Alternative: OpenWealth Sandbox

**Website**: [OpenWealth Association](https://openwealth.ch/)

**Features**:

- Industry-standard API for wealth management
- Order placement for listed instruments
- Real-time order status
- Developer portal with test client
- Secure sandbox environment

**Use Case**: Enterprise-grade integration (complex setup)

**Reference**: [Synpulse8 - OpenWealth Sandbox](https://synpulse8.com/our-solutions/openwealth-sandbox)

### 5.5 Mock/Testing Tools

**MockBank** ([MockBank.io](https://www.mockbank.io/))

- Open Banking & PSD2 sandbox
- Model any customer/account/transaction
- Admin console + internal API
- No real bank limitations

**GitHub Mock Trading APIs**:

- [mock-trading-api](https://github.com/dmitriz/mock-trading-api) - Pure functions for testing
- [Mock-Stocks](https://github.com/JackyTea/Mock-Stocks) - Full simulated trading app

---

## 6. Recommended Solution for Demo

### 6.1 Hybrid Approach: Internal Mock + External Data

**Architecture**:

```
┌─────────────────────────────────────────────────────────┐
│                    GBS Application                       │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌────────────────────────────────────────────────┐    │
│  │         Investment Execution Module             │    │
│  │  (Your Custom Implementation)                   │    │
│  └────────────────────────────────────────────────┘    │
│           │                     │                        │
│           ↓                     ↓                        │
│  ┌─────────────────┐   ┌─────────────────────┐        │
│  │  Mock Custodian │   │   Real Market Data   │        │
│  │   (Internal)    │   │  (Alpaca/FMP/12Data) │        │
│  │                 │   │                       │        │
│  │ - Trade Exec    │   │ - Prices             │        │
│  │ - Settlement    │   │ - Fund Info          │        │
│  │ - Confirmations │   │ - Historical Data    │        │
│  └─────────────────┘   └─────────────────────┘        │
│           │                     │                        │
│           ↓                     ↓                        │
│  ┌─────────────────────────────────────────────────┐  │
│  │         Transaction Record Database              │  │
│  │  - Orders | Executions | Settlements | Holdings │  │
│  └─────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

### 6.2 Why This Approach?

**For Demo**:

- ✅ Full control over execution flow
- ✅ No external dependencies for core functionality
- ✅ Realistic data from market APIs
- ✅ Complete audit trail
- ✅ Fast development
- ✅ Cost-effective (free tier APIs)

**For Production**:

- 🔄 Replace mock custodian with client's real custodian API
- 🔄 Keep transaction database schema
- 🔄 Keep reconciliation logic
- 🔄 Add real compliance checks
- 🔄 Integrate with actual settlement system

### 6.3 Demo vs Production Comparison

| Component           | Demo Implementation      | Production Implementation                    |
| ------------------- | ------------------------ | -------------------------------------------- |
| **Order Execution** | Simulated (instant fill) | Real broker API (market execution)           |
| **Market Data**     | Alpaca/FMP (real prices) | Client's market data feed                    |
| **Settlement**      | Mock (instant T+0)       | Real settlement (T+1/T+2)                    |
| **Custodian**       | Internal mock service    | BNY Mellon / State Street / Client custodian |
| **Reconciliation**  | Automated (same system)  | Multi-party reconciliation                   |
| **Compliance**      | Basic checks             | Full regulatory compliance                   |
| **Reporting**       | Standard reports         | Client-specific + regulatory reports         |

---

## 7. Implementation Architecture

### 7.1 High-Level Component Design

```
┌─────────────────────────────────────────────────────────────────┐
│                        Frontend (Angular)                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │  Order Execution │  │  Order History   │  │ Reconciliation│ │
│  │     Dashboard    │  │     & Status     │  │    Reports    │ │
│  └──────────────────┘  └──────────────────┘  └──────────────┘ │
│           │                     │                     │          │
└───────────┼─────────────────────┼─────────────────────┼──────────┘
            │                     │                     │
            ↓                     ↓                     ↓
┌─────────────────────────────────────────────────────────────────┐
│                      Backend (Spring Boot)                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌────────────────────────────────────────────────────────┐    │
│  │              Investment Execution Service               │    │
│  │                                                          │    │
│  │  • Order Creation & Validation                          │    │
│  │  • Order Routing                                        │    │
│  │  • Execution Simulation                                 │    │
│  │  • Settlement Processing                                │    │
│  │  • Position Management                                  │    │
│  └────────────────────────────────────────────────────────┘    │
│           │                 │                 │                  │
│           ↓                 ↓                 ↓                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐    │
│  │   Order      │  │  Execution   │  │  Reconciliation  │    │
│  │  Repository  │  │  Repository  │  │   Repository     │    │
│  └──────────────┘  └──────────────┘  └──────────────────┘    │
│           │                 │                 │                  │
└───────────┼─────────────────┼─────────────────┼──────────────────┘
            │                 │                 │
            ↓                 ↓                 ↓
┌─────────────────────────────────────────────────────────────────┐
│                    PostgreSQL Database                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  • investment_order         (order details)                     │
│  • order_execution          (execution records)                 │
│  • settlement               (settlement tracking)               │
│  • holding                  (current positions)                 │
│  • reconciliation_log       (reconciliation records)            │
│  • transaction_audit        (complete audit trail)              │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
            │                                      │
            ↓ (Optional for Demo)                  ↓
┌─────────────────────────────┐      ┌───────────────────────────┐
│    External Market Data     │      │   Mock Custodian Service  │
│   (Alpaca/FMP/TwelveData)   │      │      (Your Own API)       │
│                             │      │                           │
│  • Real-time prices         │      │  • Instant execution      │
│  • Fund information         │      │  • Confirmations          │
│  • Historical data          │      │  • Settlement simulation  │
└─────────────────────────────┘      └───────────────────────────┘
```

### 7.2 Process Flow: Order to Settlement

```
Step 1: PROPOSAL ACCEPTED
  │
  ├─ Customer accepts proposal in their portal
  ├─ Proposal.status: NEW → ACCEPTED
  └─ Trigger: Create investment orders
      │
      ↓
Step 2: ORDER CREATION
  │
  ├─ For each fund allocation in proposal:
  │   └─ Create InvestmentOrder
  │       • Goal ID
  │       • Proposal ID
  │       • Fund ID (HDFC Top 100, ICICI Bluechip, etc.)
  │       • Target Amount
  │       • Order Type (BUY)
  │       • Status: PENDING
  │
  └─ RM reviews orders in "Order Execution Dashboard"
      │
      ↓
Step 3: ORDER VALIDATION
  │
  ├─ Pre-execution checks:
  │   • Customer has available funds?
  │   • Fund is available for purchase?
  │   • Complies with suitability?
  │   • Within investment limits?
  │
  ├─ If validation fails:
  │   └─ Order.status: REJECTED + reason
  │
  └─ If validation passes:
      └─ Order.status: PENDING → VALIDATED
          │
          ↓
Step 4: ORDER ROUTING & EXECUTION (Mock Custodian)
  │
  ├─ Send order to Mock Custodian API
  │   POST /api/custodian/execute-order
  │   {
  │     "orderId": "ORD-123",
  │     "fundISIN": "INF204K01YM1",
  │     "fundName": "HDFC Top 100 Fund",
  │     "quantity": 100,  // units
  │     "amount": 500000
  │   }
  │
  ├─ Mock Custodian response (simulated):
  │   {
  │     "executionId": "EXE-456",
  │     "status": "FILLED",
  │     "executedPrice": 5000,  // NAV per unit
  │     "executedQuantity": 100,
  │     "executedAmount": 500000,
  │     "executionTime": "2026-01-06T10:30:00Z",
  │     "transactionId": "TXN-789"
  │   }
  │
  └─ Create OrderExecution record
      • Link to InvestmentOrder
      • Execution details
      • Status: EXECUTED
      │
      ↓
Step 5: SETTLEMENT PROCESSING
  │
  ├─ Create Settlement record:
  │   • Execution ID
  │   • Settlement Date (T+1 for demo, instant for simplicity)
  │   • Status: PENDING → SETTLED
  │   • Custodian Confirmation Number
  │
  └─ Update account holdings:
      • Create/Update Holding record
      • Fund: HDFC Top 100
      • Quantity: 100 units
      • Average Cost: 5000/unit
      • Current Value: 500000
      │
      ↓
Step 6: RECONCILIATION
  │
  ├─ Daily reconciliation job:
  │   • Compare internal holdings vs custodian report
  │   • Match order executions
  │   • Verify cash movements
  │
  └─ Create ReconciliationLog:
      • Date
      • Status: MATCHED / BREAK
      • Discrepancies (if any)
      • Resolution notes
      │
      ↓
Step 7: REPORTING & NOTIFICATIONS
  │
  ├─ Generate reports:
  │   • Order execution summary
  │   • Settlement confirmation
  │   • Updated portfolio statement
  │
  └─ Send notifications:
      • Email to customer: "Your investment of ₹5,00,000 in HDFC Top 100 is confirmed"
      • SMS confirmation
      • Update customer portal dashboard
```

### 7.3 State Machine: Order Status

```
CREATED
  ↓
VALIDATED (pre-execution checks passed)
  ↓
SUBMITTED (sent to custodian)
  ↓
PARTIALLY_FILLED (partial execution)
  ↓
FILLED (fully executed)
  ↓
SETTLING (settlement in progress)
  ↓
SETTLED (settlement complete)

Alternative paths:
CREATED → REJECTED (validation failed)
SUBMITTED → CANCELLED (cancelled by RM)
FILLED → SETTLEMENT_FAILED → PENDING_INVESTIGATION
```

---

## 8. Data Model Design

### 8.1 Entity Relationship Diagram

```
┌──────────────────┐
│      Goal        │
└──────────────────┘
         │ 1
         │
         │ *
┌──────────────────┐
│    Proposal      │
└──────────────────┘
         │ 1
         │
         │ *
┌──────────────────────────┐
│   InvestmentOrder        │  (New Entity)
│                          │
│  • id                    │
│  • proposalId (FK)       │
│  • goalId (FK)           │
│  • customerId (FK)       │
│  • rmId (FK)             │
│  • fundId (FK)           │
│  • orderType             │  (BUY, SELL)
│  • orderStatus           │  (CREATED, VALIDATED, SUBMITTED...)
│  • targetAmount          │
│  • targetQuantity        │
│  • orderDate             │
│  • validUntil            │
│  • externalOrderId       │  (from custodian)
│  • createdAt             │
│  • updatedAt             │
└──────────────────────────┘
         │ 1
         │
         │ 1
┌──────────────────────────┐
│   OrderExecution         │  (New Entity)
│                          │
│  • id                    │
│  • orderId (FK)          │
│  • executionId           │  (from custodian)
│  • executedPrice         │  (NAV per unit)
│  • executedQuantity      │
│  • executedAmount        │
│  • executionTime         │
│  • executionStatus       │  (FILLED, PARTIAL, FAILED)
│  • transactionId         │
│  • brokerage             │
│  • taxes                 │
│  • otherCharges          │
│  • totalCost             │
│  • confirmationNumber    │
│  • createdAt             │
└──────────────────────────┘
         │ 1
         │
         │ 1
┌──────────────────────────┐
│     Settlement           │  (New Entity)
│                          │
│  • id                    │
│  • executionId (FK)      │
│  • settlementDate        │
│  • settlementStatus      │  (PENDING, SETTLED, FAILED)
│  • custodianReference    │
│  • clearingHouse         │
│  • settledAmount         │
│  • settledQuantity       │
│  • settledAt             │
│  • createdAt             │
└──────────────────────────┘
         │ 1
         │
         │ *
┌──────────────────────────┐
│       Holding            │  (New Entity)
│                          │
│  • id                    │
│  • customerId (FK)       │
│  • goalId (FK)           │
│  • fundId (FK)           │
│  • quantity              │
│  • averageCost           │
│  • currentValue          │
│  • unrealizedGain        │
│  • lastUpdated           │
│  • createdAt             │
└──────────────────────────┘
         │ *
         │
         │ *
┌──────────────────────────┐
│   ReconciliationLog      │  (New Entity)
│                          │
│  • id                    │
│  • reconciliationDate    │
│  • entityType            │  (ORDER, POSITION, CASH)
│  • entityId              │
│  • internalValue         │
│  • custodianValue        │
│  • variance              │
│  • status                │  (MATCHED, BREAK, RESOLVED)
│  • breakReason           │
│  • resolutionNotes       │
│  • resolvedBy            │
│  • resolvedAt            │
│  • createdAt             │
└──────────────────────────┘
```

### 8.2 SQL Schema

```sql
-- Investment Order table
CREATE TABLE investment_order (
    id BIGSERIAL PRIMARY KEY,
    proposal_id BIGINT NOT NULL REFERENCES proposal(id),
    goal_id BIGINT NOT NULL REFERENCES goal(id),
    customer_id BIGINT NOT NULL REFERENCES users(id),
    rm_id BIGINT NOT NULL REFERENCES users(id),
    fund_id BIGINT NOT NULL REFERENCES fund(id),

    order_type VARCHAR(10) NOT NULL CHECK (order_type IN ('BUY', 'SELL')),
    order_status VARCHAR(30) NOT NULL DEFAULT 'CREATED'
        CHECK (order_status IN ('CREATED', 'VALIDATED', 'SUBMITTED', 'PARTIALLY_FILLED',
                                'FILLED', 'SETTLING', 'SETTLED', 'REJECTED', 'CANCELLED', 'FAILED')),

    target_amount DECIMAL(15, 2) NOT NULL,
    target_quantity DECIMAL(15, 4),

    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valid_until TIMESTAMP,

    external_order_id VARCHAR(100),  -- Custodian's order ID

    rejection_reason TEXT,
    cancellation_reason TEXT,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_proposal FOREIGN KEY (proposal_id) REFERENCES proposal(id),
    CONSTRAINT fk_goal FOREIGN KEY (goal_id) REFERENCES goal(id),
    CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES users(id),
    CONSTRAINT fk_rm FOREIGN KEY (rm_id) REFERENCES users(id),
    CONSTRAINT fk_fund FOREIGN KEY (fund_id) REFERENCES fund(id)
);

CREATE INDEX idx_order_proposal ON investment_order(proposal_id);
CREATE INDEX idx_order_goal ON investment_order(goal_id);
CREATE INDEX idx_order_customer ON investment_order(customer_id);
CREATE INDEX idx_order_status ON investment_order(order_status);
CREATE INDEX idx_order_date ON investment_order(order_date);

-- Order Execution table
CREATE TABLE order_execution (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES investment_order(id),

    execution_id VARCHAR(100) NOT NULL UNIQUE,  -- From custodian

    executed_price DECIMAL(15, 4) NOT NULL,  -- NAV per unit
    executed_quantity DECIMAL(15, 4) NOT NULL,
    executed_amount DECIMAL(15, 2) NOT NULL,

    execution_time TIMESTAMP NOT NULL,
    execution_status VARCHAR(20) NOT NULL CHECK (execution_status IN ('FILLED', 'PARTIAL', 'FAILED')),

    transaction_id VARCHAR(100),  -- Custodian transaction ID

    -- Charges
    brokerage DECIMAL(10, 2) DEFAULT 0,
    taxes DECIMAL(10, 2) DEFAULT 0,
    other_charges DECIMAL(10, 2) DEFAULT 0,
    total_cost DECIMAL(15, 2) NOT NULL,  -- executed_amount + charges

    confirmation_number VARCHAR(100),

    notes TEXT,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES investment_order(id)
);

CREATE INDEX idx_execution_order ON order_execution(order_id);
CREATE INDEX idx_execution_time ON order_execution(execution_time);
CREATE INDEX idx_execution_status ON order_execution(execution_status);

-- Settlement table
CREATE TABLE settlement (
    id BIGSERIAL PRIMARY KEY,
    execution_id BIGINT NOT NULL REFERENCES order_execution(id),

    settlement_date DATE NOT NULL,  -- T+1, T+2, etc.
    settlement_status VARCHAR(20) NOT NULL DEFAULT 'PENDING'
        CHECK (settlement_status IN ('PENDING', 'IN_PROGRESS', 'SETTLED', 'FAILED', 'INVESTIGATING')),

    custodian_reference VARCHAR(100),
    clearing_house VARCHAR(100),

    settled_amount DECIMAL(15, 2),
    settled_quantity DECIMAL(15, 4),
    settled_at TIMESTAMP,

    failure_reason TEXT,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_execution FOREIGN KEY (execution_id) REFERENCES order_execution(id)
);

CREATE INDEX idx_settlement_execution ON settlement(execution_id);
CREATE INDEX idx_settlement_date ON settlement(settlement_date);
CREATE INDEX idx_settlement_status ON settlement(settlement_status);

-- Holding table (current positions)
CREATE TABLE holding (
    id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT NOT NULL REFERENCES users(id),
    goal_id BIGINT NOT NULL REFERENCES goal(id),
    fund_id BIGINT NOT NULL REFERENCES fund(id),

    quantity DECIMAL(15, 4) NOT NULL DEFAULT 0,
    average_cost DECIMAL(15, 4) NOT NULL,  -- Average purchase price per unit

    current_nav DECIMAL(15, 4),  -- Current NAV per unit (updated daily)
    current_value DECIMAL(15, 2),  -- quantity * current_nav

    invested_amount DECIMAL(15, 2) NOT NULL,  -- Total amount invested
    unrealized_gain DECIMAL(15, 2),  -- current_value - invested_amount
    unrealized_gain_percentage DECIMAL(8, 4),  -- (unrealized_gain / invested_amount) * 100

    last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_holding_customer FOREIGN KEY (customer_id) REFERENCES users(id),
    CONSTRAINT fk_holding_goal FOREIGN KEY (goal_id) REFERENCES goal(id),
    CONSTRAINT fk_holding_fund FOREIGN KEY (fund_id) REFERENCES fund(id),
    CONSTRAINT unique_holding UNIQUE (customer_id, goal_id, fund_id)
);

CREATE INDEX idx_holding_customer ON holding(customer_id);
CREATE INDEX idx_holding_goal ON holding(goal_id);
CREATE INDEX idx_holding_fund ON holding(fund_id);

-- Reconciliation Log table
CREATE TABLE reconciliation_log (
    id BIGSERIAL PRIMARY KEY,
    reconciliation_date DATE NOT NULL,

    entity_type VARCHAR(20) NOT NULL CHECK (entity_type IN ('ORDER', 'EXECUTION', 'POSITION', 'CASH')),
    entity_id BIGINT NOT NULL,  -- ID of the entity being reconciled

    internal_value DECIMAL(15, 4),
    custodian_value DECIMAL(15, 4),
    variance DECIMAL(15, 4),  -- internal_value - custodian_value
    variance_percentage DECIMAL(8, 4),

    status VARCHAR(20) NOT NULL DEFAULT 'PENDING'
        CHECK (status IN ('MATCHED', 'BREAK', 'INVESTIGATING', 'RESOLVED', 'EXCEPTION')),

    break_reason TEXT,
    resolution_notes TEXT,

    resolved_by BIGINT REFERENCES users(id),
    resolved_at TIMESTAMP,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_recon_date ON reconciliation_log(reconciliation_date);
CREATE INDEX idx_recon_status ON reconciliation_log(status);
CREATE INDEX idx_recon_entity ON reconciliation_log(entity_type, entity_id);

-- Transaction Audit table (immutable audit trail)
CREATE TABLE transaction_audit (
    id BIGSERIAL PRIMARY KEY,
    transaction_type VARCHAR(30) NOT NULL,  -- ORDER_CREATED, EXECUTION, SETTLEMENT, etc.
    reference_id BIGINT NOT NULL,  -- ID of related entity
    reference_type VARCHAR(30) NOT NULL,  -- ORDER, EXECUTION, SETTLEMENT, etc.

    event_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    user_id BIGINT REFERENCES users(id),
    user_role VARCHAR(20),

    before_state JSONB,  -- State before the change
    after_state JSONB,   -- State after the change

    metadata JSONB,  -- Additional context (IP, browser, etc.)

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_audit_type ON transaction_audit(transaction_type);
CREATE INDEX idx_audit_ref ON transaction_audit(reference_type, reference_id);
CREATE INDEX idx_audit_timestamp ON transaction_audit(event_timestamp);
CREATE INDEX idx_audit_user ON transaction_audit(user_id);
```

---

## 9. API Endpoints

### 9.1 Order Management APIs

#### Create Investment Orders (After Proposal Acceptance)

```http
POST /api/v1/investment/orders/create-from-proposal
Authorization: Bearer {token}
Content-Type: application/json

Request:
{
  "proposalId": 123,
  "customerId": 456,
  "rmId": 789
}

Response (201 Created):
{
  "success": true,
  "message": "Investment orders created successfully",
  "data": {
    "ordersCreated": 5,
    "orders": [
      {
        "id": 1001,
        "fundId": 10,
        "fundName": "HDFC Top 100 Fund",
        "fundCode": "HDFC_TOP100",
        "targetAmount": 500000,
        "targetQuantity": 100,
        "orderStatus": "CREATED",
        "orderDate": "2026-01-06T10:00:00Z"
      },
      {
        "id": 1002,
        "fundId": 11,
        "fundName": "ICICI Prudential Bluechip",
        "fundCode": "ICICI_BLUECHIP",
        "targetAmount": 300000,
        "targetQuantity": 60,
        "orderStatus": "CREATED",
        "orderDate": "2026-01-06T10:00:00Z"
      }
      // ... more orders
    ]
  }
}
```

#### Get Order by ID

```http
GET /api/v1/investment/orders/{orderId}
Authorization: Bearer {token}

Response (200 OK):
{
  "success": true,
  "data": {
    "id": 1001,
    "proposalId": 123,
    "goalId": 50,
    "customerId": 456,
    "customerName": "Sujit Rujuk",
    "rmId": 789,
    "rmName": "Rajesh Kumar",
    "fundId": 10,
    "fundName": "HDFC Top 100 Fund",
    "fundCode": "HDFC_TOP100",
    "fundISIN": "INF204K01YM1",
    "orderType": "BUY",
    "orderStatus": "VALIDATED",
    "targetAmount": 500000,
    "targetQuantity": 100,
    "orderDate": "2026-01-06T10:00:00Z",
    "validUntil": "2026-01-06T18:00:00Z",
    "externalOrderId": null,
    "createdAt": "2026-01-06T10:00:00Z",
    "updatedAt": "2026-01-06T10:05:00Z",

    // Nested execution if exists
    "execution": null
  }
}
```

#### Get All Orders for Proposal

```http
GET /api/v1/investment/orders/proposal/{proposalId}
Authorization: Bearer {token}

Response (200 OK):
{
  "success": true,
  "data": {
    "proposalId": 123,
    "totalOrders": 5,
    "totalTargetAmount": 3500000,
    "statusSummary": {
      "CREATED": 2,
      "VALIDATED": 2,
      "SUBMITTED": 1,
      "FILLED": 0,
      "SETTLED": 0
    },
    "orders": [
      {
        "id": 1001,
        "fundName": "HDFC Top 100 Fund",
        "targetAmount": 500000,
        "orderStatus": "VALIDATED"
      }
      // ... more orders
    ]
  }
}
```

#### Get All Orders for Customer

```http
GET /api/v1/investment/orders/customer/{customerId}
Authorization: Bearer {token}
Query Parameters:
  - status (optional): CREATED, VALIDATED, FILLED, SETTLED
  - fromDate (optional): 2026-01-01
  - toDate (optional): 2026-01-31
  - page (default: 0)
  - size (default: 20)

Response (200 OK):
{
  "success": true,
  "data": {
    "content": [
      {
        "id": 1001,
        "proposalId": 123,
        "goalName": "Retirement Planning",
        "fundName": "HDFC Top 100 Fund",
        "orderType": "BUY",
        "orderStatus": "SETTLED",
        "targetAmount": 500000,
        "executedAmount": 500000,
        "orderDate": "2026-01-06T10:00:00Z",
        "executionTime": "2026-01-06T10:30:00Z",
        "settlementDate": "2026-01-07"
      }
    ],
    "page": 0,
    "size": 20,
    "totalElements": 50,
    "totalPages": 3
  }
}
```

### 9.2 Order Execution APIs

#### Validate Order (Pre-execution checks)

```http
POST /api/v1/investment/orders/{orderId}/validate
Authorization: Bearer {token}

Response (200 OK):
{
  "success": true,
  "data": {
    "orderId": 1001,
    "validationStatus": "PASSED",
    "checks": [
      {
        "checkType": "FUNDS_AVAILABILITY",
        "status": "PASSED",
        "message": "Customer has sufficient funds"
      },
      {
        "checkType": "FUND_AVAILABILITY",
        "status": "PASSED",
        "message": "Fund is available for purchase"
      },
      {
        "checkType": "SUITABILITY_COMPLIANCE",
        "status": "PASSED",
        "message": "Investment complies with customer suitability"
      },
      {
        "checkType": "INVESTMENT_LIMITS",
        "status": "PASSED",
        "message": "Within investment limits"
      }
    ],
    "validatedAt": "2026-01-06T10:05:00Z"
  }
}

Response (if validation fails - 400 Bad Request):
{
  "success": false,
  "message": "Order validation failed",
  "data": {
    "orderId": 1001,
    "validationStatus": "FAILED",
    "checks": [
      {
        "checkType": "FUNDS_AVAILABILITY",
        "status": "FAILED",
        "message": "Insufficient funds. Available: ₹300,000, Required: ₹500,000"
      }
    ],
    "validatedAt": "2026-01-06T10:05:00Z"
  }
}
```

#### Execute Order (Submit to mock custodian)

```http
POST /api/v1/investment/orders/{orderId}/execute
Authorization: Bearer {token}

Response (200 OK):
{
  "success": true,
  "message": "Order executed successfully",
  "data": {
    "orderId": 1001,
    "executionId": "EXE-456",
    "executionStatus": "FILLED",
    "executedPrice": 5000,  // NAV per unit
    "executedQuantity": 100,
    "executedAmount": 500000,
    "brokerage": 250,
    "taxes": 90,
    "otherCharges": 50,
    "totalCost": 500390,
    "executionTime": "2026-01-06T10:30:00Z",
    "confirmationNumber": "CONF-789",
    "transactionId": "TXN-123"
  }
}

Response (if execution fails - 400 Bad Request):
{
  "success": false,
  "message": "Order execution failed",
  "error": {
    "code": "EXECUTION_FAILED",
    "reason": "Market is closed",
    "details": "Trading hours: 9:15 AM - 3:30 PM IST"
  }
}
```

#### Get Execution Details

```http
GET /api/v1/investment/executions/{executionId}
Authorization: Bearer {token}

Response (200 OK):
{
  "success": true,
  "data": {
    "id": 456,
    "executionId": "EXE-456",
    "orderId": 1001,
    "orderDetails": {
      "fundName": "HDFC Top 100 Fund",
      "orderType": "BUY"
    },
    "executedPrice": 5000,
    "executedQuantity": 100,
    "executedAmount": 500000,
    "brokerage": 250,
    "taxes": 90,
    "otherCharges": 50,
    "totalCost": 500390,
    "executionTime": "2026-01-06T10:30:00Z",
    "executionStatus": "FILLED",
    "confirmationNumber": "CONF-789",
    "transactionId": "TXN-123",

    // Settlement info if exists
    "settlement": {
      "id": 789,
      "settlementDate": "2026-01-07",
      "settlementStatus": "SETTLED",
      "custodianReference": "CUST-REF-456"
    }
  }
}
```

### 9.3 Settlement APIs

#### Get Settlement Status

```http
GET /api/v1/investment/settlements/execution/{executionId}
Authorization: Bearer {token}

Response (200 OK):
{
  "success": true,
  "data": {
    "id": 789,
    "executionId": 456,
    "settlementDate": "2026-01-07",
    "settlementStatus": "SETTLED",
    "custodianReference": "CUST-REF-456",
    "clearingHouse": "NSDL",
    "settledAmount": 500390,
    "settledQuantity": 100,
    "settledAt": "2026-01-07T11:00:00Z",
    "createdAt": "2026-01-06T10:30:00Z"
  }
}
```

#### Trigger Settlement (Manual - for demo)

```http
POST /api/v1/investment/settlements/execute/{executionId}
Authorization: Bearer {token}

Response (200 OK):
{
  "success": true,
  "message": "Settlement processed successfully",
  "data": {
    "settlementId": 789,
    "executionId": 456,
    "settlementStatus": "SETTLED",
    "settledAt": "2026-01-07T11:00:00Z"
  }
}
```

### 9.4 Holdings APIs

#### Get Customer Holdings

```http
GET /api/v1/investment/holdings/customer/{customerId}
Authorization: Bearer {token}
Query Parameters:
  - goalId (optional): 50

Response (200 OK):
{
  "success": true,
  "data": {
    "customerId": 456,
    "customerName": "Sujit Rujuk",
    "totalInvestedAmount": 3500000,
    "totalCurrentValue": 3850000,
    "totalUnrealizedGain": 350000,
    "totalUnrealizedGainPercentage": 10,
    "lastUpdated": "2026-01-06T18:00:00Z",

    "holdings": [
      {
        "id": 1,
        "goalId": 50,
        "goalName": "Retirement Planning",
        "fundId": 10,
        "fundName": "HDFC Top 100 Fund",
        "fundCode": "HDFC_TOP100",
        "quantity": 100,
        "averageCost": 5000,
        "currentNAV": 5500,
        "currentValue": 550000,
        "investedAmount": 500000,
        "unrealizedGain": 50000,
        "unrealizedGainPercentage": 10,
        "lastUpdated": "2026-01-06T18:00:00Z"
      },
      {
        "id": 2,
        "goalId": 50,
        "goalName": "Retirement Planning",
        "fundId": 11,
        "fundName": "ICICI Prudential Bluechip",
        "fundCode": "ICICI_BLUECHIP",
        "quantity": 60,
        "averageCost": 5000,
        "currentNAV": 5400,
        "currentValue": 324000,
        "investedAmount": 300000,
        "unrealizedGain": 24000,
        "unrealizedGainPercentage": 8,
        "lastUpdated": "2026-01-06T18:00:00Z"
      }
      // ... more holdings
    ]
  }
}
```

#### Get Holdings by Goal

```http
GET /api/v1/investment/holdings/goal/{goalId}
Authorization: Bearer {token}

Response (200 OK):
{
  "success": true,
  "data": {
    "goalId": 50,
    "goalName": "Retirement Planning",
    "totalInvestedAmount": 3500000,
    "totalCurrentValue": 3850000,
    "totalUnrealizedGain": 350000,
    "totalUnrealizedGainPercentage": 10,

    "holdings": [
      // Same structure as above
    ]
  }
}
```

### 9.5 Reconciliation APIs

#### Run Reconciliation (Daily batch job trigger)

```http
POST /api/v1/investment/reconciliation/run
Authorization: Bearer {token}
Content-Type: application/json

Request:
{
  "reconciliationDate": "2026-01-06",
  "entityTypes": ["ORDER", "EXECUTION", "POSITION", "CASH"]
}

Response (200 OK):
{
  "success": true,
  "message": "Reconciliation completed",
  "data": {
    "reconciliationDate": "2026-01-06",
    "totalRecords": 150,
    "matched": 148,
    "breaks": 2,
    "summary": {
      "ORDER": { "total": 50, "matched": 50, "breaks": 0 },
      "EXECUTION": { "total": 50, "matched": 50, "breaks": 0 },
      "POSITION": { "total": 40, "matched": 38, "breaks": 2 },
      "CASH": { "total": 10, "matched": 10, "breaks": 0 }
    },
    "breaks": [
      {
        "id": 1,
        "entityType": "POSITION",
        "entityId": 1,
        "internalValue": 100,
        "custodianValue": 99.5,
        "variance": 0.5,
        "status": "BREAK",
        "breakReason": "Quantity mismatch - likely due to corporate action"
      },
      {
        "id": 2,
        "entityType": "POSITION",
        "entityId": 5,
        "internalValue": 200,
        "custodianValue": 202,
        "variance": -2,
        "status": "BREAK",
        "breakReason": "Value mismatch - NAV difference"
      }
    ],
    "completedAt": "2026-01-06T20:00:00Z"
  }
}
```

#### Get Reconciliation Report

```http
GET /api/v1/investment/reconciliation/report
Authorization: Bearer {token}
Query Parameters:
  - fromDate: 2026-01-01
  - toDate: 2026-01-07
  - status (optional): MATCHED, BREAK, RESOLVED

Response (200 OK):
{
  "success": true,
  "data": {
    "fromDate": "2026-01-01",
    "toDate": "2026-01-07",
    "totalRecords": 1050,
    "matched": 1045,
    "breaks": 3,
    "resolved": 2,
    "pending": 1,

    "dailySummary": [
      {
        "date": "2026-01-06",
        "total": 150,
        "matched": 148,
        "breaks": 2
      }
      // ... more days
    ],

    "unresolvedBreaks": [
      {
        "id": 2,
        "reconciliationDate": "2026-01-06",
        "entityType": "POSITION",
        "breakReason": "Value mismatch - NAV difference",
        "variance": -2,
        "status": "INVESTIGATING"
      }
    ]
  }
}
```

#### Resolve Reconciliation Break

```http
POST /api/v1/investment/reconciliation/{reconciliationId}/resolve
Authorization: Bearer {token}
Content-Type: application/json

Request:
{
  "resolutionNotes": "Corporate action - bonus shares issued. Updated internal records to match custodian.",
  "resolvedBy": 789
}

Response (200 OK):
{
  "success": true,
  "message": "Reconciliation break resolved",
  "data": {
    "id": 1,
    "status": "RESOLVED",
    "resolvedBy": 789,
    "resolvedAt": "2026-01-06T21:00:00Z",
    "resolutionNotes": "Corporate action - bonus shares issued. Updated internal records to match custodian."
  }
}
```

### 9.6 Dashboard/Summary APIs

#### RM Order Execution Dashboard

```http
GET /api/v1/investment/dashboard/rm/{rmId}
Authorization: Bearer {token}

Response (200 OK):
{
  "success": true,
  "data": {
    "rmId": 789,
    "rmName": "Rajesh Kumar",

    "summary": {
      "totalOrders": 250,
      "pendingOrders": 10,
      "filledToday": 15,
      "settledToday": 12,
      "totalValueExecuted": 125000000,  // ₹12.5 Cr
      "totalValueSettled": 100000000    // ₹10 Cr
    },

    "recentOrders": [
      {
        "id": 1001,
        "customerName": "Sujit Rujuk",
        "fundName": "HDFC Top 100 Fund",
        "targetAmount": 500000,
        "orderStatus": "FILLED",
        "orderDate": "2026-01-06T10:00:00Z"
      }
      // ... more recent orders
    ],

    "pendingOrders": [
      {
        "id": 1005,
        "customerName": "Amit Sharma",
        "fundName": "SBI Bluechip Fund",
        "targetAmount": 300000,
        "orderStatus": "VALIDATED",
        "orderDate": "2026-01-06T14:00:00Z"
      }
      // ... more pending orders
    ],

    "reconciliationAlerts": {
      "unresolvedBreaks": 2,
      "lastReconciliation": "2026-01-05"
    }
  }
}
```

#### Customer Portfolio Summary

```http
GET /api/v1/investment/dashboard/customer/{customerId}
Authorization: Bearer {token}

Response (200 OK):
{
  "success": true,
  "data": {
    "customerId": 456,
    "customerName": "Sujit Rujuk",

    "portfolioSummary": {
      "totalInvested": 3500000,
      "currentValue": 3850000,
      "totalGain": 350000,
      "totalGainPercentage": 10,
      "lastUpdated": "2026-01-06T18:00:00Z"
    },

    "goalSummary": [
      {
        "goalId": 50,
        "goalName": "Retirement Planning",
        "goalType": "RETIREMENT",
        "invested": 3500000,
        "currentValue": 3850000,
        "gain": 350000,
        "gainPercentage": 10,
        "fundsCount": 5
      }
    ],

    "recentTransactions": [
      {
        "date": "2026-01-06",
        "type": "BUY",
        "fundName": "HDFC Top 100 Fund",
        "amount": 500000,
        "status": "SETTLED"
      }
      // ... more transactions
    ]
  }
}
```

---

## 10. UI/UX Design

### 10.1 RM Order Execution Dashboard

**Route**: `/rm/order-execution/dashboard`

**Layout**:

```
┌─────────────────────────────────────────────────────────────┐
│  Navbar (Logo | Order Execution | Customers | Goals | ...)  │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌────────────────────────────────────────────────────────┐│
│  │         Order Execution Dashboard                       ││
│  │         Today: January 6, 2026                          ││
│  └────────────────────────────────────────────────────────┘│
│                                                              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │  Total   │  │ Pending  │  │  Filled  │  │ Settled  │  │
│  │  Orders  │  │  Orders  │  │  Today   │  │  Today   │  │
│  │   250    │  │    10    │  │    15    │  │    12    │  │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘  │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐│
│  │  Pending Orders Requiring Action                       ││
│  ├────────────────────────────────────────────────────────┤│
│  │ Customer       │ Fund           │ Amount    │ Actions  ││
│  ├────────────────────────────────────────────────────────┤│
│  │ Sujit Rujuk    │ HDFC Top 100  │ ₹5,00,000 │ [Execute]││
│  │ Amit Sharma    │ SBI Bluechip  │ ₹3,00,000 │ [Execute]││
│  │ Priya Kapoor   │ Axis Midcap   │ ₹2,00,000 │ [Execute]││
│  └────────────────────────────────────────────────────────┘│
│                                                              │
│  ┌─────────────────────┐  ┌──────────────────────────────┐│
│  │ Recent Executions   │  │ Reconciliation Status        ││
│  ├─────────────────────┤  ├──────────────────────────────┤│
│  │ 10:30 - Sujit ...  │  │ Last Run: Jan 5, 2026        ││
│  │ 10:45 - Amit  ...  │  │ Status: 2 Breaks Pending     ││
│  │ 11:00 - Priya ...  │  │ [View Report] [Run Now]      ││
│  └─────────────────────┘  └──────────────────────────────┘│
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### 10.2 Order Execution Flow (RM)

**Step 1: Proposal Accepted → Auto-create Orders**

```
Customer accepts proposal
  ↓
System automatically creates orders
  ↓
RM receives notification:
  "New orders created for Sujit Rujuk - 5 funds, ₹35,00,000"
  [View Orders]
```

**Step 2: Review & Validate Orders**

```
┌─────────────────────────────────────────────────────────────┐
│  Order Execution - Sujit Rujuk                              │
│  Proposal ID: 123 | Goal: Retirement Planning               │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌────────────────────────────────────────────────────────┐│
│  │ Order #1001                               [Validated ✓] ││
│  ├────────────────────────────────────────────────────────┤│
│  │ Fund: HDFC Top 100 Fund                                ││
│  │ Target Amount: ₹5,00,000                               ││
│  │ Estimated Units: 100 @ ₹5,000/unit                     ││
│  │ Status: VALIDATED                                       ││
│  │                                                          ││
│  │ Pre-execution Checks:                                   ││
│  │  ✓ Funds Available                                     ││
│  │  ✓ Fund Available for Purchase                         ││
│  │  ✓ Suitability Compliant                               ││
│  │  ✓ Within Investment Limits                            ││
│  │                                                          ││
│  │ [Execute Order]  [View Details]  [Cancel]              ││
│  └────────────────────────────────────────────────────────┘│
│                                                              │
│  ┌────────────────────────────────────────────────────────┐│
│  │ Order #1002                               [Validated ✓] ││
│  │ Fund: ICICI Prudential Bluechip                        ││
│  │ Target Amount: ₹3,00,000                               ││
│  │ [Execute Order]  [View Details]  [Cancel]              ││
│  └────────────────────────────────────────────────────────┘│
│                                                              │
│  ... (3 more orders)                                        │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐│
│  │ Total: 5 Orders | ₹35,00,000                           ││
│  │ [Execute All Orders]  [Cancel All]                     ││
│  └────────────────────────────────────────────────────────┘│
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**Step 3: Order Execution**

```
RM clicks [Execute Order]
  ↓
Loading modal: "Submitting order to custodian..."
  ↓
Success modal:
┌─────────────────────────────────────────────┐
│  ✓ Order Executed Successfully               │
│                                              │
│  Execution ID: EXE-456                      │
│  Fund: HDFC Top 100 Fund                    │
│  Executed Quantity: 100 units               │
│  Executed Price: ₹5,000/unit                │
│  Total Amount: ₹5,00,390                    │
│    (includes ₹250 brokerage + ₹90 taxes)   │
│                                              │
│  Confirmation: CONF-789                     │
│  Execution Time: 10:30 AM                   │
│                                              │
│  Settlement Date: Jan 7, 2026 (T+1)         │
│                                              │
│  [Download Confirmation]  [Close]           │
└─────────────────────────────────────────────┘
```

**Step 4: Settlement Tracking**

```
┌─────────────────────────────────────────────────────────────┐
│  Order #1001 - Settlement Status                            │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌─────────────────────────────────────────────────────┐  │
│  │  Timeline                                            │  │
│  │  ●───●───●───○                                       │  │
│  │  Order Execution Settlement Confirmed                │  │
│  │  Created      (T+1)                                  │  │
│  │  10:00 AM 10:30 AM  [Pending]                        │  │
│  └─────────────────────────────────────────────────────┘  │
│                                                              │
│  Execution Details:                                         │
│  • Executed: 100 units @ ₹5,000/unit                       │
│  • Total: ₹5,00,390                                        │
│  • Confirmation: CONF-789                                  │
│                                                              │
│  Settlement Details:                                        │
│  • Expected Date: Jan 7, 2026                              │
│  • Status: Pending                                         │
│  • Custodian Ref: (Will be updated on T+1)                │
│                                                              │
│  [Refresh Status]  [Download Report]                       │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### 10.3 Customer Portfolio View

**Route**: `/client/portfolio`

```
┌─────────────────────────────────────────────────────────────┐
│  My Portfolio                                               │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Total Invested       Current Value      Total Gain   │  │
│  │  ₹35,00,000          ₹38,50,000         ₹3,50,000    │  │
│  │                                          +10%         │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐│
│  │  Retirement Planning                                    ││
│  │  Invested: ₹35,00,000 | Current: ₹38,50,000 | +10%    ││
│  ├────────────────────────────────────────────────────────┤│
│  │                                                          ││
│  │  Fund Holdings:                                         ││
│  │  ┌────────────────────────────────────────────────┐   ││
│  │  │ HDFC Top 100 Fund                              │   ││
│  │  │ 100 units @ ₹5,000 avg                         │   ││
│  │  │ Current NAV: ₹5,500                            │   ││
│  │  │ Value: ₹5,50,000 | Gain: +₹50,000 (+10%)      │   ││
│  │  └────────────────────────────────────────────────┘   ││
│  │                                                          ││
│  │  ┌────────────────────────────────────────────────┐   ││
│  │  │ ICICI Prudential Bluechip                      │   ││
│  │  │ 60 units @ ₹5,000 avg                          │   ││
│  │  │ Current NAV: ₹5,400                            │   ││
│  │  │ Value: ₹3,24,000 | Gain: +₹24,000 (+8%)       │   ││
│  │  └────────────────────────────────────────────────┘   ││
│  │                                                          ││
│  │  ... (3 more funds)                                    ││
│  │                                                          ││
│  └────────────────────────────────────────────────────────┘│
│                                                              │
│  ┌────────────────────────────────────────────────────────┐│
│  │  Recent Transactions                                    ││
│  ├────────────────────────────────────────────────────────┤│
│  │ Date        │ Type │ Fund           │ Amount    │Status││
│  ├────────────────────────────────────────────────────────┤│
│  │ Jan 6, 2026 │ BUY  │ HDFC Top 100  │ ₹5,00,000 │Settled││
│  │ Jan 6, 2026 │ BUY  │ ICICI Bluechip│ ₹3,00,000 │Settled││
│  │ ...                                                     ││
│  └────────────────────────────────────────────────────────┘│
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### 10.4 Reconciliation Dashboard (RM/Admin)

**Route**: `/rm/reconciliation`

```
┌─────────────────────────────────────────────────────────────┐
│  Reconciliation Dashboard                                   │
│  Last Run: January 5, 2026, 8:00 PM                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │  Total   │  │ Matched  │  │  Breaks  │  │ Resolved │  │
│  │  Records │  │          │  │          │  │          │  │
│  │   150    │  │   148    │  │     2    │  │     0    │  │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘  │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐│
│  │  Reconciliation Breaks Requiring Action                ││
│  ├────────────────────────────────────────────────────────┤│
│  │ ID │ Type     │ Entity      │ Variance │ Reason       ││
│  ├────────────────────────────────────────────────────────┤│
│  │ 1  │ POSITION │ Holding #1  │ +0.5     │ Qty mismatch ││
│  │    │          │ HDFC Top100 │          │ [Investigate]││
│  ├────────────────────────────────────────────────────────┤│
│  │ 2  │ POSITION │ Holding #5  │ -2.0     │ Value diff   ││
│  │    │          │ SBI Equity  │          │ [Investigate]││
│  └────────────────────────────────────────────────────────┘│
│                                                              │
│  ┌─────────────────────┐  ┌──────────────────────────────┐│
│  │ Reconciliation      │  │ Actions                      ││
│  │ History (7 days)    │  │                              ││
│  ├─────────────────────┤  │ [Run Reconciliation Now]     ││
│  │ Jan 5: 148/150 ✓    │  │ [Download Report]            ││
│  │ Jan 4: 140/142 ✓    │  │ [View Audit Trail]           ││
│  │ Jan 3: 135/135 ✓✓   │  │ [Export to Excel]            ││
│  │ ...                 │  │                              ││
│  └─────────────────────┘  └──────────────────────────────┘│
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### 10.5 Components to Build

**Frontend (Angular 19)**:

1. **OrderExecutionDashboardComponent** - Main dashboard
2. **OrderListComponent** - List of orders with filters
3. **OrderExecutionComponent** - Execute single/multiple orders
4. **OrderDetailsComponent** - View order execution details
5. **SettlementTrackingComponent** - Track settlement status
6. **HoldingsComponent** - Display customer holdings
7. **ReconciliationDashboardComponent** - Reconciliation overview
8. **ReconciliationBreakComponent** - Investigate/resolve breaks
9. **TransactionHistoryComponent** - Order/execution history

**Backend (Spring Boot)**:

1. **InvestmentOrderController** - Order CRUD APIs
2. **OrderExecutionController** - Execution APIs
3. **SettlementController** - Settlement tracking APIs
4. **HoldingController** - Holdings APIs
5. **ReconciliationController** - Reconciliation APIs
6. **MockCustodianService** - Simulate custodian responses
7. **ReconciliationService** - Reconciliation logic
8. **OrderValidationService** - Pre-execution validation

---

## 11. Sources

### Custodian Services

- [Straits Financial - Understanding Custody Fund Services](https://www.straitsfinancial.com/insights/understanding-custody-fund-services)
- [PL Capital - What is Mutual Fund Custodian](https://www.plindia.com/blogs/what-is-mutual-fund-custodian/)
- [Seccl Tech - Custody & Investment Infrastructure](https://seccl.tech/services/custody-investment-infrastructure/)
- [Paystand - What is a Custodian in Finance](https://www.paystand.com/blog/what-is-a-custodian-in-finance)
- [SuperMoney - Mutual Fund Custodians](https://www.supermoney.com/encyclopedia/fund-custodian)
- [Callan - Role of Custodians in Institutional Investing](https://www.callan.com/blog/custodian-primer/)

### Reconciliation & Order Management

- [Gartner - Financial Reconciliation Solutions](https://www.gartner.com/reviews/market/financial-reconciliation-solutions)
- [Limina - Investment Reconciliation Guide](https://www.limina.com/blog/investment-reconciliation)
- [Limina - NAV and P&L Reconciliation](https://www.limina.com/blog/pnl-and-nav-reconciliation-guide)
- [SolveXia - Finance Reconciliation Best Practices](https://www.solvexia.com/blog/finance-reconciliation-how-to-step-by-step-process)
- [SolveXia - 12 Best Reconciliation Tools 2026](https://www.solvexia.com/blog/5-best-reconciliation-tools-complete-guide)
- [FRS - Reconciliations for Wealth Management](https://frsltd.com/wealth-management/reconciliations/)
- [AutoRek - Reconciliation Platform](https://www.autorek.com/)
- [Trintech - Financial Close Software](https://www.trintech.com/)

### Order Management Systems

- [United Fintech - Order Management Systems](https://unitedfintech.com/order-management-systems/)
- [IMTC - OMS for Fixed Income](https://imtc.com/products/order-management/)
- [INDATA - Trade Order Management](https://www.indataipm.com/trade-order-management/)
- [INDATA - OMS vs EMS](https://www.indataipm.com/order-management-system-vs-execution-management-system-whats-the-difference/)
- [SS&C Eze - What is an OMS](https://www.ezesoft.com/insights/blog/what-is-an-order-management-system)
- [Limina - Trade Order Management System](https://www.limina.com/solutions/trade-order-management-system)
- [Charles River Development - Order and Execution Management](https://www.crd.com/solutions/charles-river-trader)

### Trading APIs & Sandboxes

- [Alpaca Markets](https://alpaca.markets/) - **Recommended for demo**
- [Financial Modeling Prep (FMP)](https://site.financialmodelingprep.com/developer/docs)
- [Twelve Data - Mutual Funds APIs](https://twelvedata.com/news/introducing-mutual-funds-apis)
- [Alpha Vantage](https://www.alphavantage.co/)
- [MockBank](https://www.mockbank.io/)
- [GitHub - mock-trading-api](https://github.com/dmitriz/mock-trading-api)
- [GitHub - Mock-Stocks](https://github.com/JackyTea/Mock-Stocks)
- [Mockoon - Financial API Samples](https://mockoon.com/mock-samples/category/financial/)

### Wealth Management APIs

- [WealthOS API](https://wos-gb.sandbox.wealthos.cloud/admin/documentation)
- [OpenWealth Association](https://openwealth.ch/)
- [Synpulse8 - OpenWealth Sandbox](https://synpulse8.com/our-solutions/openwealth-sandbox)
- [Goldman Sachs Developer](https://developer.gs.com/docs/)
- [FasterCapital - Wealth Management APIs](https://www.fastercapital.com/content/Wealth-Management-APIs--The-Power-of-Connectivity--Leveraging-APIs-for-Enhanced-Wealth-Management.html)
- [InvestSuite - APIs in WealthTech](https://www.investsuite.com/insights/blogs/the-future-is-now-how-apis-are-revolutionizing-wealthtech-infrastructure)
- [Velexa - Investment API](https://velexa.com/investment-api/)

### Trade Lifecycle

- [The Wealth Mosaic - Trade Processing Systems](https://www.thewealthmosaic.com/vendors/corfinancial/blogs/enhancing-operational-efficiency-the-role-of-trade/)
- [Intuition - Trade Life Cycle 5 Key Stages](https://www.intuition.com/the-lifecycle-of-a-trade-5-key-stages/)
- [IBCA - Trade Life Cycle in Investment Banking](https://www.investmentbankingcouncil.org/blog/trade-life-cycle-in-investment-banking-and-its-stages)
- [ProSchoolOnline - What is Trade Life Cycle](https://proschoolonline.com/blog/what-is-trade-life-cycle)
- [Loffa Interactive - Trade Lifecycle in T+1 Era](https://loffacorp.com/from-execution-to-settlement-demystifying-the-trade-lifecycle-in-t1-era/)
- [Limina - Guide to Post Trade Management](https://www.limina.com/blog/guide-post-trade-management-software)

---

## Next Steps

1. ✅ **Research Complete** - Document saved
2. ⏳ **Design Approval** - Review architecture with team
3. ⏳ **Backend Implementation**:
   - Create database schema
   - Implement entities & repositories
   - Build REST APIs
   - Create Mock Custodian Service
4. ⏳ **Frontend Implementation**:
   - Build Angular components
   - Integrate with backend APIs
   - Add real-time updates
5. ⏳ **Testing**:
   - End-to-end flow testing
6. ⏳ **Demo Preparation**:
   - Seed data
   - Mock scenarios
   - User guides

---

**Document Version**: 1.0
**Last Updated**: January 6, 2026
**Author**: Claude (AI Research Assistant)
**Status**: Ready for Implementation
