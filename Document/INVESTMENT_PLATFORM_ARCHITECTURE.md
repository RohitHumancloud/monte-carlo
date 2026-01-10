# Goal-Based Investment Platform - Complete Architecture

## Executive Summary

**You are following the CORRECT industry standard approach!** ✅

Your flow matches how professional robo-advisors and wealth management platforms work.

---

## Your Flow vs Industry Standard

| Your Step                | Industry Term          | Status       |
| ------------------------ | ---------------------- | ------------ |
| 1. Goal creation         | Goal-Based Investing   | ✅ Done      |
| 2. Risk assessment       | Risk Profiling         | ✅ Done      |
| 3. Suitability check     | Suitability Analysis   | ✅ Done      |
| 4. Financial calculator  | Financial Planning     | ✅ Done      |
| 5. Model portfolio match | Portfolio Construction | ✅ Done      |
| 6. Proposal → Approval   | Client Onboarding      | ✅ Done      |
| 7. Execute investment    | Order Execution        | ⚠️ Mock Only |
| 8-9. Goal tracking       | Portfolio Monitoring   | ⚠️ Partial   |

---

## Complete Investment Flow Diagram

```
PHASE 1: ONBOARDING (Done ✅)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
RM creates Goal ──► Risk Assessment ──► Suitability Check
       │                   │                    │
       ▼                   ▼                    ▼
  Goal Entity          RiskScore         SuitabilityLevel

Financial Calculator ──► Model Portfolio Match ──► Proposal
       │                       │                       │
       ▼                       ▼                       ▼
  RateOfReturn            ModelPortfolio          Proposal
                                                     │
                        Customer Approves ◄──────────┘


PHASE 2: ORDER EXECUTION (Needs Work ⚠️)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
RM Clicks "Execute"
       │
       ▼                    ┌────────────────┐
┌─────────────────┐        │    CUSTODIAN   │
│ InvestmentOrder │───────►│    (Alpaca/    │
│ - amount        │  API   │  DriveWealth)  │
│ - allocations   │  Call  │                │
└─────────────────┘        └───────┬────────┘
                                   │
                                   ▼
              ┌─────────────────────────────────────┐
              │         ORDER RESPONSE              │
              │  - orderId: "ORD123456"             │
              │  - status: FILLED                   │
              │  - executedPrice: $150.25           │
              │  - units: 66.556                    │
              │  - settlementDate: T+2              │
              └───────────────┬─────────────────────┘
                              │
                              ▼
              ┌─────────────────────────────────────┐
              │           HOLDING RECORD            │
              │  - customerId: C1001                │
              │  - symbol: SPY                      │
              │  - quantity: 66.556                 │
              │  - averageCost: $150.25             │
              │  - currentValue: $10,000            │
              └─────────────────────────────────────┘


PHASE 3: DAILY OPERATIONS (Needs Work ⚠️)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
┌──────────────┐    ┌──────────────┐    ┌──────────────────┐
│  NAV Update  │───►│ Reconcile    │───►│ Goal Tracking    │
│  (Daily)     │    │ Holdings     │    │ Update Progress  │
│  Finnhub API │    │ vs Custodian │    │ Achievement %    │
└──────────────┘    └──────────────┘    └──────────────────┘
```

---

## What Data We Send to Custodian (JSON)

```json
{
  "orderRequest": {
    "symbol": "SPY",
    "side": "buy",
    "type": "market",
    "notional": "10000",
    "time_in_force": "day",
    "client_order_id": "ORDER-2026-0110-001"
  }
}
```

## What Custodian Returns

```json
{
  "id": "61e69015-8549-4bfd-b9c3-01e75843f47d",
  "client_order_id": "ORDER-2026-0110-001",
  "status": "filled",
  "symbol": "SPY",
  "qty": "66.556",
  "filled_avg_price": "150.25",
  "filled_at": "2026-01-10T09:30:05.123Z"
}
```

---

## Free Services for Development

| Service      | Purpose              | Free Tier                  |
| ------------ | -------------------- | -------------------------- |
| **Alpaca**   | US Stock/ETF Trading | ✅ Paper trading unlimited |
| **Finnhub**  | Market Data/NAV      | ✅ 60 calls/min            |
| **MFapi.in** | Indian MF NAV        | ✅ Unlimited               |

---

## UI Display for Goal Tracking

### Customer Portal Shows:

| Metric            | Value                  |
| ----------------- | ---------------------- |
| **Target**        | ₹50,00,000 by Dec 2035 |
| **Current Value** | ₹2,50,000              |
| **Invested**      | ₹2,30,000              |
| **Gain/Loss**     | +₹20,000 (+8.7%)       |
| **Achievement %** | 5% of target reached   |
| **Timeline %**    | 10% of time elapsed    |
| **Status**        | ✅ AHEAD (by 5%)       |

### Holdings Breakdown:

| Fund | Units | Avg Cost | Current | Value   | Gain  |
| ---- | ----- | -------- | ------- | ------- | ----- |
| SPY  | 66.56 | $150.25  | $155.00 | $10,316 | +$316 |
| VTI  | 45.00 | $220.00  | $225.50 | $10,147 | +$247 |

---

## Confirmation: You Are Doing It Right! ✅

Your approach matches:

- **Wealthfront** (US robo-advisor)
- **Betterment** (goal-based investing)
- **Zerodha Coin** (India MF platform)
- **Scripbox** (India goal-based)
