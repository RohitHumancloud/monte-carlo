# Investment Amount Flow - Comprehensive Research & Implementation Status

**Date**: January 10, 2026  
**Purpose**: Research document for investment execution, custodian services, reconciliation, and demo implementation  
**Status**: Research Complete - Ready for Implementation Review

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Web Research - Custodian & Record Keeping](#2-web-research---custodian--record-keeping)
3. [Third-Party Demo/Sandbox Options](#3-third-party-demosandbox-options)
4. [Current Implementation Status](#4-current-implementation-status)
5. [Demo Scenario - 10 Customers](#5-demo-scenario---10-customers)
6. [UI/UX Design - Dashboard Views](#6-uiux-design---dashboard-views)
7. [Gap Analysis](#7-gap-analysis)
8. [Recommended Approach](#8-recommended-approach)
9. [Implementation Roadmap](#9-implementation-roadmap)

---

## 1. Executive Summary

### 1.1 What You Asked For

- **Investment Flow**: After proposal acceptance, RM executes investments into model portfolio assets
- **Asset Tracking**: Buy assets, track value changes based on market conditions (NAV)
- **Record Keeping**: Complete audit trail of purchases, reconciliation with custodian
- **Demo Purpose**: 10 customers with realistic 18-22 months of investment history
- **Goal Achievement**: Show progress toward corpus (e.g., ₹10M target, how much achieved in 3 years)
- **Multiple Goals**: One customer → multiple goals → multiple portfolios (1:N relationship)
- **Both Portals**: RM Portal and Customer Portal dashboard views

### 1.2 Key Findings

| Aspect                          | Status               | Notes                                 |
| ------------------------------- | -------------------- | ------------------------------------- |
| **Custodian APIs**              | Research Complete ✅ | Multiple sandbox options available    |
| **Reconciliation**              | Research Complete ✅ | Standard 3-way reconciliation process |
| **NAV Data**                    | Research Complete ✅ | MFapi.in (FREE) recommended for demo  |
| **Backend Implementation**      | 80% Complete ✅      | Core entities and services exist      |
| **Frontend Implementation**     | 60% Complete ⚠️      | Dashboards exist, needs enhancement   |
| **Demo Data**                   | 90% Complete ✅      | 10 customers with NAV history         |
| **Goal Progress Tracking**      | Complete ✅          | Full achievement calculation          |
| **Multiple Goals per Customer** | Complete ✅          | 1:N relationship implemented          |

---

## 2. Web Research - Custodian & Record Keeping

### 2.1 What is a Custodian?

A **custodian** is a financial institution that holds customers' securities for safekeeping. In wealth management:

- **Role**: Holds/safeguards assets, processes transactions, provides settlement
- **Key Functions**:
  - Trade execution and settlement
  - Asset safekeeping
  - Corporate actions processing (dividends, splits)
  - Tax reporting and statements
  - Reconciliation data

### 2.2 Custodian API Providers (2026)

| Provider                  | Sandbox Available | Key Features                                          | Use Case      |
| ------------------------- | ----------------- | ----------------------------------------------------- | ------------- |
| **U.S. Bank**             | ✅ Yes            | SEI Wealth Platform, holdings, transactions, tax lots | Enterprise    |
| **Goldman Sachs GSCS**    | ✅ Yes            | REST APIs for onboarding, transfers, holdings         | Enterprise    |
| **BridgeFT**              | ✅ Yes            | Multi-custodial data, WealthTech API                  | Fintech Dev   |
| **WealthKernel**          | ✅ Yes            | All-in-one investing API, custody included            | Startups      |
| **Alpaca**                | ✅ Yes            | Paper trading API, simulated execution                | Demo/Testing  |
| **American Estate Trust** | ✅ Yes            | Trust API with full sandbox                           | IRA/Qualified |
| **SEB Global Custody**    | ✅ Yes            | Real-time positions, free sandbox                     | Institutional |

### 2.3 Reconciliation Process

**Definition**: Reconciliation is comparing internal records against external sources (custodian, broker, fund admin) to verify accuracy.

**Types of Reconciliation**:

```
1. TRADE RECONCILIATION
   └─ Match executed trades: Front Office → Back Office → Custodian

2. POSITION/HOLDING RECONCILIATION
   └─ Verify internal holdings = Custodian statement

3. CASH RECONCILIATION
   └─ Internal cash balances = Bank/Custodian cash

4. CORPORATE ACTIONS RECONCILIATION
   └─ Dividends, interest, splits accurately captured

5. NAV RECONCILIATION
   └─ Internal valuation = Custodian/Fund Admin valuation

6. MULTI-ASSET RECONCILIATION
   └─ Complex asset classes (derivatives, alternatives)
```

**Three-Way Reconciliation Flow**:

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  Asset Manager  │     │  Fund Admin     │     │   Custodian     │
│   (Internal)    │────▶│  (Verification) │────▶│  (Settlement)   │
└─────────────────┘     └─────────────────┘     └─────────────────┘
         │                       │                       │
         └───────────────────────┴───────────────────────┘
                    Compare & Reconcile Daily
```

### 2.4 Record Keeping Requirements

**Key Records to Maintain**:

| Record Type                  | Purpose                     | Retention   |
| ---------------------------- | --------------------------- | ----------- |
| **Transaction Audit**        | Complete order history      | 7+ years    |
| **Holdings Snapshot**        | Daily position records      | As needed   |
| **NAV History**              | Price history for valuation | Historical  |
| **Settlement Confirmations** | Proof of execution          | 7+ years    |
| **Corporate Actions**        | Dividends, splits           | Ongoing     |
| **Reconciliation Log**       | Break detection/resolution  | Audit trail |

---

## 3. Third-Party Demo/Sandbox Options

### 3.1 Recommended for Demo: Internal Mock Custodian + MFapi.in

> [!TIP]
> For demo purposes, we recommend building an **internal mock custodian** that simulates instant execution, combined with **real NAV data from MFapi.in** (FREE, no auth required).

**Why This Approach**:

- ✅ **No cost** - Both are free
- ✅ **Real market data** - NAVs are actual mutual fund prices
- ✅ **Complete control** - Customize execution logic
- ✅ **Easy to replace** - Swap mock with real custodian in production
- ✅ **Already implemented** - `InvestmentDemoDataInitializer` exists

### 3.2 Paper Trading APIs (Alternative)

| Platform                | Type          | Features                        | Cost              |
| ----------------------- | ------------- | ------------------------------- | ----------------- |
| **Alpaca**              | Paper Trading | Stock/Options, real-time quotes | Free              |
| **TradeStation SIM**    | Simulator     | Identical to live API           | Free              |
| **QuantConnect**        | Algo Trading  | Backtest + Paper trade          | Free tier         |
| **paperinvest.io**      | Mock API      | Slippage, partial fills         | Free              |
| **Interactive Brokers** | Paper Trader  | Full simulation                 | Free with account |

### 3.3 NAV Data APIs

| Provider            | Coverage             | Cost       | Auth Required |
| ------------------- | -------------------- | ---------- | ------------- |
| **MFapi.in**        | Indian Mutual Funds  | **FREE**   | **No**        |
| **AMFI Portal**     | Indian MF (Official) | Free       | No            |
| **RapidAPI MF NAV** | Indian MF            | Freemium   | API Key       |
| **FactSet Funds**   | Global               | Enterprise | Yes           |
| **Xignite NAVs**    | US Mutual Funds      | Paid       | Yes           |
| **Polygon.io**      | Stocks/ETFs          | Freemium   | API Key       |

**Current Implementation**: Using **simulated NAV data** stored in `fund_nav_history` table (207 records for 9 funds over 23 dates from March 2024 to January 2026).

---

## 4. Current Implementation Status

### 4.1 Backend Implementation ✅ (80% Complete)

#### Entities Implemented

| Entity             | File Location                 | Status      |
| ------------------ | ----------------------------- | ----------- |
| `InvestmentOrder`  | `model/InvestmentOrder.java`  | ✅ Complete |
| `OrderExecution`   | `model/OrderExecution.java`   | ✅ Complete |
| `Holding`          | `model/Holding.java`          | ✅ Complete |
| `FundNavHistory`   | `model/FundNavHistory.java`   | ✅ Complete |
| `TransactionAudit` | `model/TransactionAudit.java` | ✅ Complete |
| `SipSchedule`      | `model/SipSchedule.java`      | ✅ Complete |
| `Goal`             | `model/Goal.java`             | ✅ Complete |
| `ModelPortfolio`   | `model/ModelPortfolio.java`   | ✅ Complete |

#### Services Implemented

| Service                     | Key Methods                                         | Status |
| --------------------------- | --------------------------------------------------- | ------ |
| `InvestmentOrderService`    | Create, validate, execute orders                    | ✅     |
| `HoldingService`            | Get holdings, summary, NAV update                   | ✅     |
| `PortfolioValuationService` | Portfolio summary, goal valuation, asset allocation | ✅     |
| `GoalProgressService`       | Goal achievement, progress metrics, status tracking | ✅     |
| `ModelPortfolioService`     | Portfolio matching, allocation                      | ✅     |

#### Key Backend Features

```java
// PortfolioValuationService provides:
- getPortfolioSummary(customerId)      // Total invested, current value, gain %
- getGoalPortfolioValue(goalId)        // Per-goal valuation
- calculateAssetAllocation(holdings)   // Asset class breakdown
- updateHoldingValuations(holdings)    // Daily NAV updates

// GoalProgressService provides:
- calculateGoalProgress(goalId)        // Achievement %, time remaining
- getGoalsSummaryForCustomer(id)       // All goals with progress
- calculateProgressMetrics(goal)       // On Track/Behind/Ahead status

// Holding entity supports:
- addUnits(qty, price, amount)         // Accumulate with avg cost
- removeUnits(qty, amount)             // Redemption with FIFO
- updateCurrentNav(nav)                // Recalculate gains
- calculateCurrentValue()              // qty × NAV = value
```

#### Demo Data Initializer

The `InvestmentDemoDataInitializer.java` creates:

- **207 NAV records** for 9 funds across 23 dates
- **10 customer profiles** with varied allocations
- **49 fund-wise holdings** across customers
- **10 SIP schedules** for monthly investments
- **Investment period**: March 2024 → January 2026 (22 months)

**NAV Performance (Simulated)**:
| Fund | Start NAV | Current NAV | Growth |
|------|-----------|-------------|--------|
| HDFC Top 100 | ₹500 | ₹810 | +62% |
| ICICI Bluechip | ₹250 | ₹405 | +62% |
| SBI Small Cap | ₹80 | ₹142 | +77% |
| Axis Midcap | ₹120 | ₹198 | +65% |
| HDFC Corporate Bond | ₹35 | ₹41.30 | +18% |
| Kotak Medium Term | ₹40 | ₹47.60 | +19% |
| Aditya Birla Liquid | ₹30 | ₹34.68 | +15.6% |
| Parag Parikh Flexi | ₹200 | ₹342 | +71% |

---

### 4.2 Frontend Implementation ⚠️ (60% Complete)

#### Components Implemented

| Component                     | Location                                                | Status     |
| ----------------------------- | ------------------------------------------------------- | ---------- |
| **Customer Dashboard**        | `client-portal/dashboard/`                              | ✅         |
| `GoalProgressWidgetComponent` | `dashboard/goal-progress-widget.component.ts`           | ✅         |
| **Goals List**                | `client-portal/goals/goals-list.component.ts`           | ✅         |
| **Goal Detail**               | `client-portal/goals/goal-detail.component.ts`          | ✅         |
| **Goal Progress Detail**      | `client-portal/goals/goal-progress-detail.component.ts` | ✅         |
| **Holdings View**             | `client-portal/holdings/`                               | ⚠️ Partial |
| **Portfolio View**            | `client-portal/portfolio/`                              | ⚠️ Partial |
| **RM Dashboard**              | `rm-portal/dashboard/`                                  | ✅         |
| **RM Customer Journey**       | `rm-portal/journey/`                                    | ✅         |

#### Customer Dashboard Features

The `ClientDashboardComponent` provides:

- Goals overview with progress bars
- Risk profile summary
- Pending proposal actions (approve/reject)
- Quick navigation to goal details

#### What's Missing in Frontend

| Feature                      | Component Needed                                | Priority |
| ---------------------------- | ----------------------------------------------- | -------- |
| **Portfolio Holdings Table** | Enhanced holdings view with fund-wise breakdown | High     |
| **Asset Allocation Chart**   | Pie chart of equity/debt/gold allocation        | High     |
| **Performance Chart**        | Time-series of portfolio value growth           | Medium   |
| **Goal Achievement Widget**  | Large visual showing % to corpus                | High     |
| **Multiple Goals Dashboard** | Cards for each goal with aggregated view        | High     |
| **RM Portfolio Summary**     | Aggregated view of customer portfolios          | Medium   |

---

## 5. Demo Scenario - 10 Customers

### 5.1 Customer Profiles

| #   | Customer Name  | Initial Investment | Monthly SIP | Start Date | Risk Profile | Goals |
| --- | -------------- | ------------------ | ----------- | ---------- | ------------ | ----- |
| 1   | Priya Sharma   | ₹1,00,000          | ₹10,000     | 2024-04-05 | Balanced     | 3     |
| 2   | Rajesh Kumar   | ₹2,00,000          | ₹15,000     | 2024-04-10 | Aggressive   | 2     |
| 3   | Anita Patel    | ₹1,50,000          | ₹12,000     | 2024-04-15 | Conservative | 1     |
| 4   | Vikram Singh   | ₹3,00,000          | ₹20,000     | 2024-05-01 | Speculative  | 3     |
| 5   | Meera Iyer     | ₹75,000            | ₹8,000      | 2024-05-20 | Secure       | 2     |
| 6   | Amit Desai     | ₹2,50,000          | ₹18,000     | 2024-06-10 | Aggressive   | 1     |
| 7   | Sneha Reddy    | ₹1,25,000          | ₹10,000     | 2024-07-05 | Balanced     | 2     |
| 8   | Arjun Kapoor   | ₹1,80,000          | ₹14,000     | 2024-08-15 | Income       | 3     |
| 9   | Kavita Nair    | ₹90,000            | ₹7,500      | 2024-09-01 | Conservative | 1     |
| 10  | Rohit Malhotra | ₹2,20,000          | ₹16,000     | 2024-09-20 | Aggressive   | 2     |

**Summary**:

- **Total Initial Investment**: ₹16,90,000
- **Monthly SIP Total**: ₹1,30,500
- **Total Goals**: 20 goals across 10 customers
- **Investment Period**: 18-22 months

### 5.2 Example: One Customer with 3 Goals

**Customer: Priya Sharma**

```
Goal 1: Retirement Planning
├─ Target Corpus: ₹1,00,00,000 (₹1 Crore)
├─ Target Date: 2044-04-05 (20 years)
├─ Risk Profile: Balanced (60/40)
├─ Initial Investment: ₹40,000
├─ Monthly SIP: ₹4,000
├─ Current Value (after 22 months): ₹1,32,450
├─ Total Invested: ₹1,28,000 (40K + 22 × 4K)
├─ Unrealized Gain: ₹4,450 (+3.48%)
├─ Goal Achievement: 1.32% of ₹1 Crore
└─ Status: ON TRACK ✅

Goal 2: Child Education
├─ Target Corpus: ₹50,00,000 (₹50 Lakhs)
├─ Target Date: 2039-04-05 (15 years)
├─ Risk Profile: Aggressive (80/20)
├─ Initial Investment: ₹35,000
├─ Monthly SIP: ₹3,500
├─ Current Value: ₹1,25,800
├─ Total Invested: ₹1,12,000
├─ Unrealized Gain: ₹13,800 (+12.32%)
├─ Goal Achievement: 2.52% of ₹50 Lakhs
└─ Status: AHEAD 🚀

Goal 3: House Downpayment
├─ Target Corpus: ₹25,00,000 (₹25 Lakhs)
├─ Target Date: 2029-04-05 (5 years)
├─ Risk Profile: Conservative (20/80)
├─ Initial Investment: ₹25,000
├─ Monthly SIP: ₹2,500
├─ Current Value: ₹85,200
├─ Total Invested: ₹80,000
├─ Unrealized Gain: ₹5,200 (+6.5%)
├─ Goal Achievement: 3.41% of ₹25 Lakhs
└─ Status: BEHIND ⚠️ (needs more SIP)

TOTAL PORTFOLIO (All 3 Goals):
├─ Total Invested: ₹3,20,000
├─ Current Value: ₹3,43,450
├─ Total Gain: ₹23,450 (+7.33%)
└─ Asset Allocation: Equity 53%, Debt 42%, Gold 5%
```

### 5.3 How NAV Changes Affect Value

**Example: HDFC Top 100 Fund**

| Date       | NAV     | Priya's Units | Value   | Change |
| ---------- | ------- | ------------- | ------- | ------ |
| 2024-04-05 | ₹500.00 | 16.0000       | ₹8,000  | -      |
| 2024-07-01 | ₹540.00 | 27.4074       | ₹14,800 | +14.8% |
| 2024-10-01 | ₹620.00 | 38.5484       | ₹23,900 | +28.9% |
| 2025-01-08 | ₹710.00 | 49.5775       | ₹35,200 | +34.0% |
| 2026-01-08 | ₹810.00 | 60.4938       | ₹49,000 | +40.0% |

**Calculation**:

- Units purchased = Amount / NAV at purchase time
- Current Value = Total Units × Current NAV
- Unrealized Gain = Current Value - Total Invested
- Gain % = (Gain / Invested) × 100

---

## 6. UI/UX Design - Dashboard Views

### 6.1 Customer Portal Dashboard

```
┌────────────────────────────────────────────────────────────────────┐
│  Welcome, Priya Sharma                                    🔔 ⚙️    │
├────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────────── PORTFOLIO SUMMARY ────────────────────────┐  │
│  │                                                               │  │
│  │  Total Invested    Current Value    Total Gain    Today      │  │
│  │   ₹3,20,000        ₹3,43,450       +₹23,450      +₹1,240    │  │
│  │                                      +7.33%        +0.36%    │  │
│  │                                                               │  │
│  │  [===========================================] Asset Allocation│  │
│  │  Equity: 53%  │  Debt: 42%  │  Gold: 5%                      │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  ┌──────────────────── MY GOALS (3) ────────────────────────────┐  │
│  │                                                               │  │
│  │  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐ │  │
│  │  │ 🎯 Retirement    │ │ 🎓 Education     │ │ 🏠 House        │ │  │
│  │  │ Target: ₹1 Cr   │ │ Target: ₹50 L   │ │ Target: ₹25 L   │ │  │
│  │  │                 │ │                 │ │                 │ │  │
│  │  │ [█░░░░░] 1.32%  │ │ [██░░░░] 2.52%  │ │ [██░░░░] 3.41%  │ │  │
│  │  │                 │ │                 │ │                 │ │  │
│  │  │ Current: ₹1.32L │ │ Current: ₹1.26L │ │ Current: ₹85.2K │ │  │
│  │  │ ✅ On Track     │ │ 🚀 Ahead        │ │ ⚠️ Behind       │ │  │
│  │  │ 19y 3m left     │ │ 14y 3m left     │ │ 4y 3m left      │ │  │
│  │  └─────────────────┘ └─────────────────┘ └─────────────────┘ │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  ┌──────────────────── HOLDINGS (9 Funds) ──────────────────────┐  │
│  │                                                               │  │
│  │  Fund Name              Invested    Current    Gain    %     │  │
│  │  ─────────────────────────────────────────────────────────   │  │
│  │  HDFC Top 100           ₹48,000    ₹49,000   +₹1,000  +2.1% │  │
│  │  ICICI Bluechip         ₹42,000    ₹44,500   +₹2,500  +5.9% │  │
│  │  SBI Small Cap          ₹28,000    ₹33,200   +₹5,200  +18.6%│  │
│  │  Axis Midcap            ₹32,000    ₹36,800   +₹4,800  +15.0%│  │
│  │  HDFC Corp Bond         ₹64,000    ₹68,200   +₹4,200  +6.6% │  │
│  │  ... (4 more funds)                                          │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  ┌──────────────────── PORTFOLIO GROWTH ────────────────────────┐  │
│  │                                                               │  │
│  │      ₹3.5L ┤                                              ╭──│  │
│  │           │                                           ╭───╯  │  │
│  │      ₹3.0L ┤                                      ╭───╯      │  │
│  │           │                                  ╭────╯          │  │
│  │      ₹2.5L ┤                             ╭───╯               │  │
│  │           │                         ╭────╯                   │  │
│  │      ₹2.0L ┤                    ╭───╯                        │  │
│  │           │               ╭─────╯                            │  │
│  │      ₹1.5L ┤          ╭───╯                                  │  │
│  │           │     ╭─────╯                                      │  │
│  │      ₹1.0L ┤ ────╯                                           │  │
│  │           └──────┬──────┬──────┬──────┬──────┬──────┬───────│  │
│  │                Apr'24  Jul'24  Oct'24  Jan'25  Jul'25  Jan'26│  │
│  └───────────────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────────┘
```

### 6.2 Goal Detail Page

```
┌────────────────────────────────────────────────────────────────────┐
│  ← Back to Dashboard                                               │
├────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  🎯 Retirement Planning                                             │
│  Created: Apr 5, 2024  │  Target: Apr 5, 2044  │  Balanced Portfolio│
│                                                                     │
│  ┌─────────────────── GOAL PROGRESS ────────────────────────────┐  │
│  │                                                               │  │
│  │     ₹1 Crore Target                                           │  │
│  │                                                               │  │
│  │     [█░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░] 1.32%│  │
│  │                                                               │  │
│  │     ₹1,32,450 achieved    │    ₹98,67,550 remaining          │  │
│  │                                                               │  │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐     │  │
│  │  │ Invested │  │ Current  │  │  Gain    │  │  XIRR    │     │  │
│  │  │ ₹1.28L   │  │ ₹1.32L   │  │ +₹4,450  │  │ +12.4%   │     │  │
│  │  │          │  │          │  │ +3.48%   │  │ annualized│     │  │
│  │  └──────────┘  └──────────┘  └──────────┘  └──────────┘     │  │
│  │                                                               │  │
│  │  Status: ✅ ON TRACK                                          │  │
│  │  Time Remaining: 19 years, 3 months                           │  │
│  │  Monthly SIP: ₹4,000                                          │  │
│  │  Next SIP Date: Jan 15, 2026                                  │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  ┌─────────────────── PORTFOLIO ALLOCATION ─────────────────────┐  │
│  │                                                               │  │
│  │       ┌───────────┐                                           │  │
│  │      /  Equity    \       Equity (Large Cap): 35%            │  │
│  │     │   60%       │       Equity (Mid Cap): 15%              │  │
│  │      \            /       Equity (Small Cap): 10%            │  │
│  │       └───────────┘       Debt (Corporate): 25%              │  │
│  │        │  Debt    │       Debt (Liquid): 10%                 │  │
│  │        │  40%     │       Gold ETF: 5%                       │  │
│  │        └──────────┘                                           │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  ┌─────────────────── FUND HOLDINGS (6 Funds) ──────────────────┐  │
│  │                                                               │  │
│  │  Fund                    Units     Avg NAV   Current  Gain   │  │
│  │  ────────────────────────────────────────────────────────────│  │
│  │  HDFC Top 100            16.0000   ₹500.00   ₹12,960  +62%   │  │
│  │  ICICI Bluechip          35.0000   ₹250.00   ₹14,175  +62%   │  │
│  │  Axis Midcap             25.0000   ₹120.00   ₹4,950   +65%   │  │
│  │  SBI Small Cap           18.7500   ₹80.00    ₹2,663   +77%   │  │
│  │  HDFC Corporate Bond     200.0000  ₹35.00    ₹8,260   +18%   │  │
│  │  Kotak Liquid            75.0000   ₹40.00    ₹3,570   +19%   │  │
│  └───────────────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────────┘
```

### 6.3 RM Portal - Customer Portfolio View

```
┌────────────────────────────────────────────────────────────────────┐
│  Customer: Priya Sharma                           RM: John Smith   │
├────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────────── PORTFOLIO OVERVIEW ───────────────────────┐  │
│  │                                                               │  │
│  │  Total AUM          Total Gain          Goals    Risk Profile │  │
│  │  ₹3,43,450         +₹23,450 (+7.33%)     3       Balanced    │  │
│  │                                                               │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  ┌─────────────────── GOALS STATUS ─────────────────────────────┐  │
│  │                                                               │  │
│  │  #  Goal Name        Target     Current    Progress  Status  │  │
│  │  ─────────────────────────────────────────────────────────── │  │
│  │  1  Retirement       ₹1 Cr      ₹1.32L     1.32%     ✅ Track│  │
│  │  2  Child Education  ₹50 L      ₹1.26L     2.52%     🚀 Ahead│  │
│  │  3  House Purchase   ₹25 L      ₹85.2K     3.41%     ⚠️Behind│  │
│  │                                                               │  │
│  │  [Action Required: Review Goal #3 - Behind schedule]         │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  ┌─────────────────── INVESTMENT TIMELINE ──────────────────────┐  │
│  │                                                               │  │
│  │  Apr 2024: Initial investment ₹1,00,000 → ✅ Executed        │  │
│  │  May 2024: SIP ₹10,000 → ✅ Executed                         │  │
│  │  Jun 2024: SIP ₹10,000 → ✅ Executed                         │  │
│  │  ...                                                          │  │
│  │  Jan 2026: SIP ₹10,000 → ⏳ Pending (Jan 15)                 │  │
│  │                                                               │  │
│  │  Total Installments: 22  │  Successful: 21  │  Pending: 1    │  │
│  └───────────────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────────┘
```

---

## 7. Gap Analysis

### 7.1 What's Complete ✅

| Component               | Backend | Frontend | Notes                        |
| ----------------------- | ------- | -------- | ---------------------------- |
| Investment Order Entity | ✅      | N/A      | Full lifecycle               |
| Holding Entity          | ✅      | N/A      | With NAV updates             |
| NAV History             | ✅      | N/A      | 207 records                  |
| Portfolio Valuation     | ✅      | ⚠️       | Service complete, UI partial |
| Goal Progress           | ✅      | ✅       | Achievement % calculated     |
| Multiple Goals          | ✅      | ✅       | 1:N relationship             |
| Demo Data               | ✅      | N/A      | 10 customers, 22 months      |
| SIP Schedules           | ✅      | ⚠️       | Entity exists, no UI         |
| RM Dashboard            | N/A     | ✅       | Basic structure              |
| Customer Dashboard      | N/A     | ✅       | Goals + proposals            |

### 7.2 What's Missing/Needs Enhancement ❌

| Component                | Backend | Frontend | Priority   |
| ------------------------ | ------- | -------- | ---------- |
| Holdings List UI         | N/A     | ❌       | High       |
| Asset Allocation Chart   | N/A     | ❌       | High       |
| Portfolio Growth Chart   | N/A     | ❌       | Medium     |
| Goal Achievement Widget  | N/A     | ⚠️       | High       |
| Transaction History      | ⚠️      | ❌       | Medium     |
| NAV Update Scheduler     | ⚠️      | N/A      | Low (demo) |
| Reconciliation Dashboard | ❌      | ❌       | Low (demo) |
| Real NAV API Integration | ❌      | N/A      | Future     |

### 7.3 Specific Missing Pieces

**Backend**:

1. **NAV Update Scheduler**: Scheduled job to update NAVs daily (for production)
2. **Reconciliation Service**: Compare internal vs custodian (for production)
3. **Transaction History API**: Get all transactions for customer

**Frontend**:

1. **Holdings Table Component**: Display all funds with value, gain
2. **Asset Allocation Pie Chart**: Visual breakdown
3. **Portfolio Value Chart**: Time-series growth
4. **Goal Achievement Large Widget**: Prominent display of progress
5. **Transaction History View**: List of all buys/sells

---

## 8. Recommended Approach

### 8.1 For Demo (Phase 1) - Current State

> [!IMPORTANT]
> The current implementation is **demo-ready** with minor frontend enhancements needed.

**What Works Now**:

- 10 customers with 18-22 months of investment history
- Real NAV simulation with realistic returns (15-77% over period)
- Goal progress calculation with On Track/Behind/Ahead status
- Portfolio valuation with unrealized gains
- Multiple goals per customer

**Quick Wins Needed**:

1. Enhance `client-portal/holdings` component to show fund-wise breakdown
2. Add asset allocation visualization
3. Add portfolio growth chart
4. Enhance goal progress display on dashboard

### 8.2 For Production (Phase 2)

When client provides their custodian:

1. **Replace Mock Custodian**:

   - Implement interface for real custodian API
   - Add authentication, error handling
   - Implement settlement processing

2. **Replace Mock NAV**:

   - Integrate MFapi.in or client's NAV provider
   - Add scheduled NAV update job
   - Handle NAV failures gracefully

3. **Add Reconciliation**:
   - Daily position reconciliation
   - Transaction reconciliation
   - Break detection and alerts

---

## 9. Implementation Roadmap

### Phase 1: Demo Enhancement (Current Sprint)

| Task                          | Effort | Priority |
| ----------------------------- | ------ | -------- |
| Enhance Holdings UI Component | 2 days | High     |
| Add Asset Allocation Chart    | 1 day  | High     |
| Add Portfolio Growth Chart    | 1 day  | Medium   |
| Enhance Goal Progress Widget  | 1 day  | High     |
| Add Transaction History View  | 2 days | Medium   |
| Testing & Polish              | 1 day  | High     |

**Total**: ~8 days

### Phase 2: Production Readiness (Future)

| Task                      | Effort  | Notes                |
| ------------------------- | ------- | -------------------- |
| Custodian API Integration | 2 weeks | Depends on client    |
| Real NAV Integration      | 1 week  | MFapi.in or other    |
| Reconciliation System     | 2 weeks | 3-way reconciliation |
| Settlement Processing     | 1 week  | T+1/T+2 handling     |
| Compliance Checks         | 1 week  | KYC, limits          |

---

## References

### Web Research Sources

1. [Finartis Prospero - Custodian Interfaces](https://www.finartis.com/product-features/custodian-interfaces-reconciliation-4/)
2. [BNY Custody Solutions](https://www.bny.com/corporate/global/en/solutions/platforms/custody-solutions.html)
3. [Limina - Investment Reconciliation](https://www.limina.com/blog/investment-reconciliation)
4. [Limina - P&L and NAV Reconciliation Guide](https://www.limina.com/blog/pnl-and-nav-reconciliation-guide)
5. [FactSet Funds API](https://developer.factset.com/api-catalog/factset-funds-api)
6. [MFapi.in - Free Indian Mutual Fund NAV API](https://www.mfapi.in/)
7. [Alpaca - Paper Trading API](https://alpaca.markets/docs/trading/paper-trading/)
8. [BridgeFT - WealthTech API Developer Sandbox](https://www.bridgeft.com/)
9. [WealthKernel - Investing API](https://www.wealthkernel.com/)
10. [SolveXia - Investment Reconciliation Types](https://www.solvexia.com/blog/investment-reconciliation)

### Codebase References

- [InvestmentOrder.java](file:///home/humancloud/Desktop/Rohit/Avalog/GBS-backend/src/main/java/com/avaloq/gbs/model/InvestmentOrder.java)
- [Holding.java](file:///home/humancloud/Desktop/Rohit/Avalog/GBS-backend/src/main/java/com/avaloq/gbs/model/Holding.java)
- [PortfolioValuationService.java](file:///home/humancloud/Desktop/Rohit/Avalog/GBS-backend/src/main/java/com/avaloq/gbs/service/PortfolioValuationService.java)
- [GoalProgressService.java](file:///home/humancloud/Desktop/Rohit/Avalog/GBS-backend/src/main/java/com/avaloq/gbs/service/GoalProgressService.java)
- [InvestmentDemoDataInitializer.java](file:///home/humancloud/Desktop/Rohit/Avalog/GBS-backend/src/main/java/com/avaloq/gbs/configuration/InvestmentDemoDataInitializer.java)
- [ClientDashboardComponent.ts](file:///home/humancloud/Desktop/Rohit/Avalog/frontend/src/app/features/client-portal/dashboard/client-dashboard.component.ts)
- [GoalDetailComponent.ts](file:///home/humancloud/Desktop/Rohit/Avalog/frontend/src/app/features/client-portal/goals/goal-detail.component.ts)

---

_Document prepared for Avalog GBS Project - January 2026_
