# Investment Flow Research & Custodian Integration Guide

**Date**: January 9, 2026  
**Purpose**: Research on custodian services, reconciliation, record keeping for investment execution flow

---

## Table of Contents

1. [Key Concepts](#1-key-concepts)
2. [Custodian Services](#2-custodian-services)
3. [Record Keeping Best Practices](#3-record-keeping-best-practices)
4. [Reconciliation Process](#4-reconciliation-process)
5. [NAV Data APIs](#5-nav-data-apis)
6. [Demo Implementation Approach](#6-demo-implementation-approach)
7. [Production Transition Plan](#7-production-transition-plan)

---

## 1. Key Concepts

### 1.1 Custodian

**Definition**: A custodian is a financial institution (typically a bank or specialized firm) that holds and safeguards financial assets on behalf of clients.

**Key Functions**:

- **Asset Safekeeping**: Physical/electronic custody of securities
- **Settlement Services**: Processing buy/sell transactions
- **Record Keeping**: Maintaining accurate transaction records
- **Reconciliation**: Matching internal records with external sources
- **Corporate Actions**: Processing dividends, splits, mergers
- **Reporting**: Providing statements and regulatory reports

**Major Global Custodians**:
| Custodian | AUM (2024) | Key Markets |
|-----------|------------|-------------|
| BNY Mellon | $47T+ | Global |
| State Street | $42T+ | Global |
| J.P. Morgan | $32T+ | Global |
| Citibank | $25T+ | Global |
| Northern Trust | $15T+ | Global |

### 1.2 Order Management System (OMS)

**Definition**: Software platform that manages the complete lifecycle of trade orders from entry to settlement.

**Core Capabilities**:

- Order creation and routing
- Trade execution tracking
- Compliance monitoring
- Real-time position tracking
- Multi-asset class support

### 1.3 Settlement

**Definition**: The final step where securities and cash are exchanged between buyer and seller.

**Settlement Cycles**:
| Market | Cycle | Description |
|--------|-------|-------------|
| US Equities | T+1 | Trade date + 1 business day |
| Europe | T+2 | Trade date + 2 business days |
| India (MF) | T+1/T+3 | Typically T+1 for redemption |

---

## 2. Custodian Services

### 2.1 Modern API-Enabled Custody

The wealth management industry is rapidly adopting API-first custody solutions:

**Benefits of API Integration**:

- Real-time data access instead of batch file processing
- Automated portfolio rebalancing
- Faster product development
- Reduced manual errors
- Enhanced compliance automation

**Key Vendors (2024-2025)**:

| Vendor     | Type             | Features                               |
| ---------- | ---------------- | -------------------------------------- |
| Alpaca     | API-First Broker | Paper trading, real-time quotes        |
| Seccl Tech | UK Custodian     | Direct CREST access, no sub-custodians |
| WealthArc  | Data Aggregator  | Multi-custodian consolidation          |
| Altruist   | RIA Platform     | Zero-fee custody, digital-first        |

### 2.2 Custody Integration Models

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

**Model 3: Mock Custodian (Demo)**

```
Your System → Mock API → Simulated Execution
```

- Pros: Zero cost, full control
- Cons: Not real execution
- **Recommended for Demo**

---

## 3. Record Keeping Best Practices

### 3.1 Regulatory Requirements

**SEC Rule 17a-4**: Investment advisers must retain records for:

- 5 years minimum
- First 2 years in easily accessible location

**Required Records**:

- Trade confirmations
- Client ledgers
- Securities journals
- Written communications
- Marketing materials

### 3.2 Database Schema Requirements

Our implementation should track:

| Entity               | Purpose           | Key Fields                                |
| -------------------- | ----------------- | ----------------------------------------- |
| `investment_order`   | Order instruction | customer_id, fund_id, amount, type        |
| `order_execution`    | Execution details | executed_price, quantity, timestamp       |
| `holding`            | Current positions | units, average_cost, current_value        |
| `transaction_audit`  | Complete trail    | all transaction details                   |
| `fund_nav_history`   | Historical NAV    | fund_code, date, nav_value                |
| `reconciliation_log` | Recon records     | internal_value, custodian_value, variance |

### 3.3 Audit Trail Requirements

Every transaction should log:

```json
{
  "transactionId": "TXN-2024-001234",
  "customerId": "CUS-2024-001",
  "orderId": "ORD-2024-001234",
  "type": "BUY",
  "fundCode": "HDFC_TOP100",
  "amount": 30000.0,
  "units": 60.0,
  "nav": 500.0,
  "executedAt": "2024-03-18T10:30:00Z",
  "settledAt": "2024-03-19T10:30:00Z",
  "status": "SETTLED",
  "createdBy": "SYSTEM",
  "createdAt": "2024-03-18T10:30:00Z"
}
```

---

## 4. Reconciliation Process

### 4.1 Types of Reconciliation

| Type                        | Frequency | Purpose                                  |
| --------------------------- | --------- | ---------------------------------------- |
| **Trade Reconciliation**    | Intraday  | Match executed trades with order records |
| **Position Reconciliation** | Daily     | Verify holdings match custodian records  |
| **Cash Reconciliation**     | Daily     | Match cash balances and movements        |
| **NAV Reconciliation**      | Daily     | Verify Net Asset Value calculations      |

### 4.2 Three-Way Reconciliation

In production, positions are verified across three parties:

```
┌────────────────────┐
│   Asset Manager    │ (Your System)
│   Holdings: 100    │
└─────────┬──────────┘
          │
          ▼ (Match?)
┌────────────────────┐
│  Fund Admin/RTA    │ (CAMS, KFintech)
│   Holdings: 100    │
└─────────┬──────────┘
          │
          ▼ (Match?)
┌────────────────────┐
│     Custodian      │ (Bank)
│   Holdings: 100    │
└────────────────────┘

Result: All match ✅ No breaks
```

### 4.3 Break Management

When discrepancies are found:

1. **Identify**: Automated comparison flags differences
2. **Categorize**: Timing, pricing, corporate action, error
3. **Investigate**: Research root cause
4. **Resolve**: Adjust records or escalate
5. **Document**: Log resolution for audit

### 4.4 For Demo Implementation

Since we use a **Mock Custodian**, reconciliation is simplified:

- Internal records = Custodian records (always match)
- No breaks expected
- Focus on demonstrating the UI and process flow

---

## 5. NAV Data APIs

### 5.1 Free APIs (Recommended for Demo)

#### MFapi.in (Indian Mutual Funds)

```
Base URL: https://api.mfapi.in/mf/
Auth: None required ✅
Rate Limit: Generous
Data: All Indian mutual funds

Example:
GET https://api.mfapi.in/mf/119551
Response:
{
  "meta": {
    "fund_house": "HDFC Mutual Fund",
    "scheme_name": "HDFC Top 100 Fund - Direct Growth"
  },
  "data": [
    {"date": "08-01-2026", "nav": "810.5400"},
    {"date": "07-01-2026", "nav": "808.2300"}
  ]
}
```

#### Alpha Vantage (US Stocks)

```
Base URL: https://www.alphavantage.co/query
Auth: Free API key
Rate Limit: 25 requests/day (free tier)
Data: US stocks, ETFs, forex
```

### 5.2 Production-Grade APIs

| Provider  | Cost | Coverage              |
| --------- | ---- | --------------------- |
| FactSet   | $$$  | Global, comprehensive |
| Xignite   | $$   | Good, well-documented |
| Bloomberg | $$$$ | Best, most complete   |

### 5.3 Our Approach

**For Demo**:

1. Seed historical NAV data in database
2. No external API calls needed
3. Data is realistic but static

**For Production (Future)**:

1. Integrate with MFapi.in or client's data provider
2. Daily scheduled job to fetch NAVs
3. Update holdings valuations automatically

---

## 6. Demo Implementation Approach

### 6.1 Architecture

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
│           ▼                     ▼                        │
│  ┌─────────────────┐   ┌─────────────────────┐        │
│  │  Mock Custodian │   │   Seeded NAV Data    │        │
│  │   (Internal)    │   │    (Database)        │        │
│  │                 │   │                       │        │
│  │ - Instant Exec  │   │ - Historical NAVs    │        │
│  │ - Confirmations │   │ - 23 months data     │        │
│  └─────────────────┘   └─────────────────────┘        │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

### 6.2 Why This Works

| Aspect          | Demo           | Production      |
| --------------- | -------------- | --------------- |
| Order Execution | Mock (instant) | Real broker API |
| NAV Data        | Seeded         | Real-time API   |
| Settlement      | Instant (T+0)  | T+1 or T+2      |
| Reconciliation  | Always matches | Real comparison |
| Compliance      | Basic          | Full regulatory |

### 6.3 Data Flow

```
1. Proposal Approved →
2. Investment Orders Created →
3. Mock Custodian Executes (instant) →
4. Holdings Updated →
5. NAVs Applied from Seed Data →
6. Current Values Calculated →
7. Dashboard Shows Results
```

---

## 7. Production Transition Plan

When client is ready for production:

### Phase 1: Custodian Integration

- Replace Mock Custodian with real custodian API
- Implement authentication and security
- Add error handling for failed trades
- Implement settlement waiting period (T+1)

### Phase 2: NAV Data Integration

- Replace seeded data with live NAV feed
- Add scheduled job for daily updates
- Implement NAV validation checks
- Handle missing/delayed data

### Phase 3: Compliance & Audit

- Add regulatory compliance checks
- Implement comprehensive audit logging
- Add reconciliation break handling
- Generate regulatory reports

### Phase 4: Scaling

- Add support for multiple custodians
- Implement failover mechanisms
- Add performance monitoring
- Scale database for high volume

---

## Sources

1. [BNY Mellon Custody Solutions](https://www.bny.com/corporate/global/en/solutions/platforms/custody-solutions.html)
2. [Limina Investment Reconciliation](https://www.limina.com/blog/investment-reconciliation)
3. [Alpaca Markets API](https://alpaca.markets/)
4. [MFapi.in - Free Mutual Fund API](https://www.mfapi.in/)
5. [SEC Recordkeeping Requirements](https://www.sec.gov/rules/final/ia-2256.htm)
6. [Seccl Tech Custody](https://seccl.tech/services/custody-investment-infrastructure/)
7. [BridgeFT API Integration](https://bridgeft.com/api-integration/)
8. [FinTech Global - Trading APIs](https://fintech.global/)

---

## Appendix: Sample SQL Schema

```sql
-- Holdings table with valuation fields
CREATE TABLE holding (
    id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    goal_id BIGINT NOT NULL,
    fund_id BIGINT NOT NULL,
    quantity DECIMAL(15,4) NOT NULL,
    average_cost DECIMAL(15,4) NOT NULL,
    current_nav DECIMAL(15,4),
    current_value DECIMAL(15,2),
    invested_amount DECIMAL(15,2) NOT NULL,
    unrealized_gain DECIMAL(15,2),
    unrealized_gain_percentage DECIMAL(8,4),
    last_updated TIMESTAMP NOT NULL,
    UNIQUE(customer_id, goal_id, fund_id)
);

-- NAV History for historical tracking
CREATE TABLE fund_nav_history (
    id BIGSERIAL PRIMARY KEY,
    fund_id BIGINT NOT NULL,
    nav_date DATE NOT NULL,
    nav_value DECIMAL(15,4) NOT NULL,
    data_source VARCHAR(50),
    fetched_at TIMESTAMP,
    UNIQUE(fund_id, nav_date)
);

-- Reconciliation log
CREATE TABLE reconciliation_log (
    id BIGSERIAL PRIMARY KEY,
    reconciliation_date DATE NOT NULL,
    entity_type VARCHAR(30) NOT NULL,
    entity_id BIGINT,
    internal_value DECIMAL(15,4),
    custodian_value DECIMAL(15,4),
    variance DECIMAL(15,4),
    status VARCHAR(20) NOT NULL,
    break_reason TEXT,
    resolved_at TIMESTAMP
);
```
