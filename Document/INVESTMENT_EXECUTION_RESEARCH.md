# Investment Execution Flow Research Document

## Executive Summary

This document outlines the research and implementation strategy for the **Amount Investment Flow** - the process of executing real asset purchases after a customer accepts a proposal from the Relationship Manager (RM).

**Goal**: Demonstrate end-to-end investment execution for demo purposes, with the flexibility for clients to integrate their own custodian in production.

---

## 1. Investment Execution Terminology

### 1.1 Key Concepts

| Term | Definition |
|------|------------|
| **Custodian** | A financial institution that holds customers' securities and assets for safekeeping, handles settlement, and maintains records of ownership. Examples: BNY Mellon, State Street, Northern Trust. |
| **Execution** | The actual buying/selling of securities on the market at the best available price. |
| **Settlement** | The process of transferring securities from seller to buyer and cash from buyer to seller. In the US, equity settlement is T+1 (trade date + 1 business day). |
| **Reconciliation** | The process of verifying that internal records match external custodian/broker records. Ensures data integrity across positions, cash, and transactions. |
| **Order Lifecycle** | PENDING → SUBMITTED → FILLED (Partially/Fully) → SETTLED |
| **NBBO** | National Best Bid and Offer - the best available ask price when buying and the best available bid price when selling a security. |
| **Fractional Shares** | The ability to buy a portion of a share (e.g., 0.5 shares of a $500 stock). |
| **IBOR** | Investment Book of Record - the authoritative record of all investment positions and transactions. |
| **OMS** | Order Management System - software platform that manages the lifecycle of trades from order creation through execution and settlement. |

### 1.2 Order Status Lifecycle

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   PENDING   │ -> │  SUBMITTED  │ -> │   ACCEPTED  │ -> │   FILLED    │ -> │   SETTLED   │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
                                              │
                                              v
                                      ┌─────────────┐
                                      │  REJECTED   │
                                      └─────────────┘
```

**Status Definitions:**
- **PENDING**: Order created but not yet sent to broker
- **SUBMITTED**: Order sent to broker/exchange
- **ACCEPTED**: Order acknowledged by broker
- **PARTIALLY_FILLED**: Some quantity executed, remaining pending
- **FILLED**: All quantity executed at market
- **SETTLED**: Cash/securities exchanged (T+1 for US equities)
- **REJECTED**: Order rejected by broker
- **CANCELLED**: Order cancelled by user

### 1.3 Trade Lifecycle Structure

The trade lifecycle operates across three divisions:
- **Front Office—Trade Execution**: Implements trades, buying or selling securities at the best available price
- **Middle Office—Risk & Compliance**: Monitors all trades to ensure validity and regulatory compliance
- **Back Office—Settlement & Clearing**: Handles validity checks, discrepancies, and ensures settlements are made on time

---

## 2. Third-Party Trading API Options

### 2.1 Global Platforms Comparison Matrix

| Provider | Type | Sandbox | Fractional | Markets | Best For | Cost |
|----------|------|---------|------------|---------|----------|------|
| **Alpaca** | Broker-Dealer | ✅ Free Paper Trading | ✅ Yes | US Stocks, ETFs, Crypto | Demo/Startup | Free |
| **DriveWealth** | Licensed Broker | ✅ UAT Environment | ✅ Yes (Patented Fracker®) | US Equities, ETFs, MF | Production-grade | Enterprise |
| **Interactive Brokers** | Full Broker | ✅ Paper Trading | ❌ No | Global 160+ Markets | Advanced Trading | Per-trade |
| **WealthKernel** | Custodian API | ✅ Sandbox | ✅ Yes | UK/US Stocks, ETFs, MFs | UK Market | Enterprise |
| **Upvest** | Investment API | ✅ (Contact for access) | ✅ Yes (from €1) | European Stocks, ETFs | Europe | Enterprise |
| **Paper Invest** | Simulation Only | ✅ Free | ❌ No | Simulated | Pure Demo | Free |

### 2.2 India-Specific Platforms

| Provider | Type | Sandbox | Assets | Best For | Cost |
|----------|------|---------|--------|----------|------|
| **Fintech Primitives** | MF API Platform | ✅ Sandbox at s.finprim.com | Mutual Funds | MF Distribution | Pay-as-you-use |
| **Kite Connect (Zerodha)** | Trading API | ✅ (Publisher account) | Stocks, F&O, MF | Indian Stocks | ₹2000/month |
| **Groww API** | Trading API | ✅ Limited | Stocks, F&O, MTF | Algo Trading | ₹499/month |
| **DhanHQ** | Trading API | ✅ Closed Sandbox | Stocks, ETFs, Derivatives | Developers | Free APIs |
| **5paisa** | Trading API | ✅ (UAT) | Equity, Derivatives | Retail Traders | ₹1000/month |
| **ICICI Breeze** | Trading API | ✅ UAT | NSE/BSE Stocks | ICICI Customers | Free |
| **ProStocks Star** | Trading API | ✅ 24x7 UAT | NSE Equity, F&O, Currency | Testing | ₹1000/month |
| **BSE StAR MF** | MF Platform | ✅ Sandbox | Mutual Funds (45+ AMCs) | Distributors | Via RTA |
| **NSE NMF II** | MF Platform | ✅ Sandbox | Mutual Funds | Distributors | Via NSE |

---

## 3. Recommended Platform: Alpaca Markets (Demo)

### 3.1 Why Alpaca is Ideal for Demo

1. **Free Paper Trading**: No cost sandbox with $100,000 virtual cash
2. **Real Market Data**: Simulates real NBBO pricing
3. **Java SDK Available**: `alpaca-java` library on Maven
4. **Commission-Free**: No transaction fees
5. **REST + WebSocket**: Real-time order updates
6. **Fractional Shares**: Buy $100 worth of any stock
7. **Quick Setup**: Account creation in minutes
8. **US Securities**: Stocks, ETFs, Options, Crypto
9. **Global Access**: Anyone globally can create a paper-only account

### 3.2 Alpaca Paper Trading Features

- Real-time simulation environment
- Order fills based on actual NBBO
- Supports Market, Limit, Stop, Stop-Limit orders
- Pattern Day Trader rules simulated
- Real-time position and balance updates
- Up to three paper trading accounts per user
- Different API keys from live account

### 3.3 Alpaca API Endpoints

```
Base URL (Paper): https://paper-api.alpaca.markets
Data URL: https://data.alpaca.markets

Key Endpoints:
- GET  /v2/account          - Get account info
- GET  /v2/positions        - Get all positions
- POST /v2/orders           - Place an order
- GET  /v2/orders/{id}      - Get order status
- GET  /v2/orders           - List all orders
- DELETE /v2/orders/{id}    - Cancel order
```

### 3.4 Order Request Example

```json
POST /v2/orders
{
  "symbol": "AAPL",
  "qty": "10",
  "side": "buy",
  "type": "market",
  "time_in_force": "day",
  "client_order_id": "GBS-JOURNEY-123-AAPL"
}
```

### 3.5 Order Response Example

```json
{
  "id": "61e69015-8549-4bfd-b9c3-01e75843f47d",
  "client_order_id": "GBS-JOURNEY-123-AAPL",
  "created_at": "2021-03-16T18:38:01.942282Z",
  "submitted_at": "2021-03-16T18:38:01.937734Z",
  "filled_at": "2021-03-16T18:38:01.937734Z",
  "symbol": "AAPL",
  "asset_class": "us_equity",
  "qty": "10",
  "filled_qty": "10",
  "filled_avg_price": "125.60",
  "order_type": "market",
  "side": "buy",
  "status": "filled"
}
```

### 3.6 Alpaca Python SDK Example

```python
from alpaca.trading.client import TradingClient
from alpaca.trading.requests import MarketOrderRequest
from alpaca.trading.enums import OrderSide, TimeInForce

trading_client = TradingClient('api-key', 'secret-key', paper=True)
market_order_data = MarketOrderRequest(
    symbol="SPY",
    qty=0.023,
    side=OrderSide.BUY,
    time_in_force=TimeInForce.DAY
)
market_order = trading_client.submit_order(order_data=market_order_data)
```

### 3.7 Alpaca Limitations

- Paper trading account does NOT simulate dividends
- Paper trading account does NOT send order fill emails
- Paper Only Account holders receive IEX market data only
- Non-marketable orders wait until marketable

---

## 4. Alternative: DriveWealth (Production-Grade)

### 4.1 DriveWealth Features

- **Production-replica Sandbox (UAT)**: Test integration during development and after launch
- **Patented Fracker® Technology**: Pioneered fractional share investing
- **Global Platform**: Trading of US equities, mutual funds, ETFs, fixed income, and options
- **Extended Hours**: Fractional equities trading from 4 AM to 8 PM Eastern (16 hours/day)
- **Dollar-Based Trading**: Invest in dollar amounts rather than share quantities

### 4.2 DriveWealth API Features

```
Sandbox Hostname: Different from production (hostname determines environment)
Documentation: https://developer.drivewealth.com/

Key Features:
- OpenAPI-compliant spec available
- Postman collection for testing
- Quick Start guides
- Fractional trading in 0.00000001 share increments
- Market, Stop, MIT, and Limit orders
```

### 4.3 Security Requirements

- All requests over HTTPS (plain HTTP fails)
- API authentication required
- Server-to-server communication only
- Private keys should never be exposed in transit

---

## 5. India Options: Fintech Primitives (Mutual Funds)

### 5.1 Platform Overview

Fintech Primitives simplifies the Indian financial ecosystem into APIs - a cloud-based PaaS for mutual fund distribution.

### 5.2 Sandbox Access

```
Sandbox URL: https://s.finprim.com
Production URL: https://api.fintechprimitives.com
Documentation: https://fintechprimitives.com/docs/api/
```

### 5.3 Key Features

- **Mutual Fund Transaction APIs**: Purchase, Redemption, SIP, STP flows
- **45+ AMC Support**: All major fund houses connected
- **Portfolio Aggregation**: Holdings and transaction history across multiple fund houses
- **Regulatory Compliance**: SEBI and AMFI compliant infrastructure
- **Order Management & Reconciliation**: End-to-end tracking
- **Analytics & Reporting**: Client statements, capital gain summaries

### 5.4 Registration Requirements

- OAuth 2.0 access via email to fpsupport@cybrilla.com
- Enterprise plans include sandbox access, SLA-backed uptime
- For SEBI-regulated institutions

---

## 6. Reconciliation Process

### 6.1 What is Reconciliation?

Reconciliation ensures data consistency between:
- **Internal System** (GBS database)
- **External Broker** (Alpaca/Custodian)
- **Custodian** (holds actual assets)

### 6.2 Three-Way Reconciliation

```
┌─────────────────┐
│   GBS System    │ ←──┐
│  (Our Records)  │    │
└────────┬────────┘    │
         │             │ Compare & Verify
         v             │
┌─────────────────┐    │
│  Broker/API     │ ←──┤
│   (Alpaca)      │    │
└────────┬────────┘    │
         │             │
         v             │
┌─────────────────┐    │
│   Custodian     │ ←──┘
│ (Asset Holder)  │
└─────────────────┘
```

### 6.3 Types of Reconciliation

| Type | Frequency | What to Compare |
|------|-----------|-----------------|
| **Trade Reconciliation** | T+0 to T+1 | Trade ID, Fill Price, Quantity, Timestamp |
| **Position Reconciliation** | Daily | Symbol, Quantity, Market Value |
| **Cash Reconciliation** | Daily | Available Cash, Buying Power, Currency |
| **NAV Reconciliation** | Daily | Portfolio valuations |

### 6.4 Reconciliation Workflow

```
1. DATA COLLECTION
   ├─ Pull internal positions from OMS
   ├─ Receive custodian statement (MT535/API)
   └─ Get NAV from pricing service

2. MATCHING
   ├─ Match by: Security ID + Account + Quantity + Settlement Date
   ├─ Identify: MATCHED, UNMATCHED, BREAKS
   └─ Calculate: Variances

3. BREAK INVESTIGATION
   ├─ Timing differences (T+1 vs T+2)
   ├─ Corporate actions (splits, dividends)
   ├─ Failed trades
   └─ Data entry errors

4. RESOLUTION
   ├─ Auto-resolve minor variances
   ├─ Escalate significant breaks
   └─ Adjust positions if needed

5. REPORTING
   ├─ Reconciliation summary
   ├─ Break report
   └─ Audit trail
```

---

## 7. Implementation Architecture

### 7.1 Database Schema

```sql
-- Investment Order table
CREATE TABLE investment_order (
    id BIGSERIAL PRIMARY KEY,
    journey_tracking_id BIGINT REFERENCES goal_journey_tracking(id),
    proposal_id BIGINT REFERENCES proposal(id),
    customer_id BIGINT REFERENCES customer(id),

    -- Order Details
    order_type VARCHAR(20) NOT NULL, -- MARKET, LIMIT
    side VARCHAR(10) NOT NULL, -- BUY, SELL
    symbol VARCHAR(20) NOT NULL,
    asset_class_id BIGINT REFERENCES asset_class(id),

    -- Quantities
    requested_qty DECIMAL(18,8),
    requested_amount DECIMAL(18,2), -- For fractional/notional orders
    filled_qty DECIMAL(18,8),
    filled_avg_price DECIMAL(18,4),

    -- Status Tracking
    status VARCHAR(30) NOT NULL, -- PENDING, SUBMITTED, FILLED, SETTLED, REJECTED

    -- External References
    broker_order_id VARCHAR(100), -- Alpaca order ID
    client_order_id VARCHAR(100) UNIQUE, -- Our reference

    -- Timestamps
    submitted_at TIMESTAMP,
    filled_at TIMESTAMP,
    settled_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,

    -- Error Handling
    error_message TEXT,
    retry_count INT DEFAULT 0
);

-- Investment Execution Summary (per journey)
CREATE TABLE investment_execution (
    id BIGSERIAL PRIMARY KEY,
    journey_tracking_id BIGINT REFERENCES goal_journey_tracking(id),
    proposal_id BIGINT REFERENCES proposal(id),
    customer_id BIGINT REFERENCES customer(id),
    portfolio_id BIGINT REFERENCES model_portfolio(id),

    -- Investment Summary
    total_investment_amount DECIMAL(18,2) NOT NULL,
    executed_amount DECIMAL(18,2) DEFAULT 0,
    pending_amount DECIMAL(18,2) DEFAULT 0,

    -- Status
    execution_status VARCHAR(30) NOT NULL, -- PENDING, IN_PROGRESS, COMPLETED, FAILED

    -- Broker Info
    broker_account_id VARCHAR(100),

    -- Timestamps
    initiated_at TIMESTAMP,
    completed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Audit
    initiated_by BIGINT REFERENCES users(id)
);

-- Position Snapshot (for reconciliation)
CREATE TABLE position_snapshot (
    id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT REFERENCES customer(id),
    execution_id BIGINT REFERENCES investment_execution(id),

    symbol VARCHAR(20) NOT NULL,
    asset_class_id BIGINT REFERENCES asset_class(id),
    quantity DECIMAL(18,8) NOT NULL,
    avg_cost DECIMAL(18,4),
    market_value DECIMAL(18,2),
    unrealized_pnl DECIMAL(18,2),

    -- Source
    source VARCHAR(20) NOT NULL, -- BROKER, INTERNAL
    snapshot_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Reconciliation Records
CREATE TABLE reconciliation_record (
    id BIGSERIAL PRIMARY KEY,
    reconciliation_date DATE NOT NULL,
    reconciliation_type VARCHAR(20) NOT NULL, -- POSITION, TRADE, CASH
    status VARCHAR(20) NOT NULL, -- PENDING, MATCHED, UNMATCHED, RESOLVED

    customer_id BIGINT REFERENCES customer(id),
    asset_class_id BIGINT REFERENCES asset_class(id),

    -- Internal values
    internal_quantity DECIMAL(18,8),
    internal_value DECIMAL(18,2),

    -- External (Custodian) values
    custodian_quantity DECIMAL(18,8),
    custodian_value DECIMAL(18,2),

    -- Variance
    quantity_variance DECIMAL(18,8),
    value_variance DECIMAL(18,2),

    break_reason TEXT,
    resolution TEXT,
    resolved_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 7.2 Service Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     InvestmentExecutionService                   │
├─────────────────────────────────────────────────────────────────┤
│ + initiateInvestment(proposalId, amount)                        │
│ + executeOrders(executionId)                                     │
│ + getExecutionStatus(executionId)                                │
│ + reconcilePositions(executionId)                                │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ uses
                              v
┌─────────────────────────────────────────────────────────────────┐
│                      BrokerIntegrationService                    │
│                      (Interface - Strategy Pattern)              │
├─────────────────────────────────────────────────────────────────┤
│ + placeOrder(OrderRequest)                                       │
│ + getOrderStatus(orderId)                                        │
│ + cancelOrder(orderId)                                           │
│ + getPositions()                                                 │
│ + getAccountInfo()                                               │
└─────────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┼───────────────┐
              │               │               │
              v               v               v
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
│ AlpacaBroker    │ │ MockBroker      │ │ DriveWealth     │
│ (Paper Trading) │ │ (Local Demo)    │ │ (Production)    │
└─────────────────┘ └─────────────────┘ └─────────────────┘
```

### 7.3 Investment Flow Sequence

```
┌─────────┐     ┌─────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────┐
│Customer │     │   RM    │     │ GBS Backend │     │   Alpaca    │     │   DB    │
└────┬────┘     └────┬────┘     └──────┬──────┘     └──────┬──────┘     └────┬────┘
     │               │                  │                   │                 │
     │  Accept       │                  │                   │                 │
     │  Proposal     │                  │                   │                 │
     │──────────────>│                  │                   │                 │
     │               │                  │                   │                 │
     │               │ Initiate         │                   │                 │
     │               │ Investment       │                   │                 │
     │               │─────────────────>│                   │                 │
     │               │                  │                   │                 │
     │               │                  │ Create Execution  │                 │
     │               │                  │──────────────────────────────────>  │
     │               │                  │                   │                 │
     │               │                  │ Calculate Orders  │                 │
     │               │                  │ (Based on         │                 │
     │               │                  │  Portfolio        │                 │
     │               │                  │  Allocation)      │                 │
     │               │                  │                   │                 │
     │               │                  │ Place Order       │                 │
     │               │                  │ (for each asset)  │                 │
     │               │                  │──────────────────>│                 │
     │               │                  │                   │                 │
     │               │                  │   Order Filled    │                 │
     │               │                  │<──────────────────│                 │
     │               │                  │                   │                 │
     │               │                  │ Save Order Record │                 │
     │               │                  │──────────────────────────────────>  │
     │               │                  │                   │                 │
     │               │                  │ Update Positions  │                 │
     │               │                  │──────────────────────────────────>  │
     │               │                  │                   │                 │
     │               │  Execution       │                   │                 │
     │               │  Complete        │                   │                 │
     │               │<─────────────────│                   │                 │
     │               │                  │                   │                 │
     │  Investment   │                  │                   │                 │
     │  Confirmed    │                  │                   │                 │
     │<──────────────│                  │                   │                 │
```

---

## 8. Demo Implementation Strategy

### 8.1 Phase 1: Mock Broker (Immediate Demo)

For the initial demo, implement a **MockBrokerService** that:
- Simulates order execution instantly
- Uses static/seeded price data
- Returns realistic order responses
- Stores all records in database

**Advantages:**
- No external dependencies
- Works offline
- Fully controlled behavior
- Instant execution

### 8.2 Phase 2: Alpaca Paper Trading (Enhanced Demo)

Integrate Alpaca's paper trading for:
- Real market data
- Realistic order execution
- Actual price movements
- Portfolio tracking

**Setup Required:**
1. Create Alpaca account (free)
2. Get API keys
3. Configure paper trading endpoint
4. Add `alpaca-java` Maven dependency

### 8.3 Phase 3: Production Custodian (Client Integration)

Client provides their custodian integration:
- DriveWealth, Interactive Brokers, etc.
- Custom FIX protocol integration
- Real money transactions

---

## 9. Seed Data Mapping

### 9.1 Asset Class to Trading Symbol Mapping

| Asset Class Code | Asset Class Name | Example Symbols |
|------------------|------------------|-----------------|
| EQ_US_LC | US Large Cap Equity | SPY, QQQ, AAPL, MSFT |
| EQ_US_MC | US Mid Cap Equity | IJH, VO, MDY |
| EQ_US_SC | US Small Cap Equity | IWM, VB, IJR |
| EQ_INTL_DM | International Developed | EFA, VEA, IEFA |
| EQ_INTL_EM | Emerging Markets | VWO, EEM, IEMG |
| FI_GOVT | Government Bonds | TLT, IEF, GOVT |
| FI_CORP_IG | Investment Grade Corp | LQD, VCIT, IGIB |
| FI_CORP_HY | High Yield Bonds | HYG, JNK, USHY |
| RE_GLOBAL | Global Real Estate | VNQ, VNQI, REET |
| CMDTY_GOLD | Gold | GLD, IAU, SGOL |
| CASH | Cash/Money Market | BIL, SHV, SGOV |

### 9.2 Portfolio Allocation Example

**Conservative Portfolio (LOW_RISK):**
```
Total Investment: $10,000

Asset Allocation:
- Government Bonds (40%): $4,000 → Buy TLT
- Investment Grade Corp (25%): $2,500 → Buy LQD
- US Large Cap (15%): $1,500 → Buy SPY
- Cash (10%): $1,000 → Buy BIL
- Gold (10%): $1,000 → Buy GLD
```

---

## 10. API Endpoints Design

### 10.1 Investment Execution Endpoints

```
POST   /api/v1/investment/execute
       Body: { proposalId, investmentAmount }
       Response: { executionId, status, orders[] }

GET    /api/v1/investment/execution/{id}
       Response: { execution, orders[], positions[] }

GET    /api/v1/investment/execution/{id}/orders
       Response: { orders[] }

POST   /api/v1/investment/execution/{id}/reconcile
       Response: { reconciliationResult }

GET    /api/v1/investment/customer/{customerId}/positions
       Response: { positions[] }

GET    /api/v1/investment/customer/{customerId}/transactions
       Response: { transactions[] }
```

---

## 11. Configuration

### 11.1 Application Properties

```yaml
# Broker Configuration
broker:
  provider: mock  # Options: mock, alpaca, drivewealth

# Alpaca Configuration (when provider=alpaca)
alpaca:
  api-key: ${ALPACA_API_KEY}
  secret-key: ${ALPACA_SECRET_KEY}
  base-url: https://paper-api.alpaca.markets
  data-url: https://data.alpaca.markets

# Mock Broker Configuration (for demo)
mock-broker:
  execution-delay-ms: 500
  fill-probability: 0.95
  use-random-prices: false
```

---

## 12. Sources & References

### Trading API Providers (Global)
- [Alpaca Markets](https://alpaca.markets/) - Commission-free trading API
- [Alpaca Paper Trading Docs](https://docs.alpaca.markets/docs/paper-trading)
- [DriveWealth Developer Portal](https://developer.drivewealth.com/)
- [Interactive Brokers TWS API](https://interactivebrokers.github.io/tws-api/)
- [WealthKernel Investing API](https://www.wealthkernel.com/platform/investing-api)
- [Upvest Investment API](https://upvest.co/)

### India Trading APIs
- [Fintech Primitives API Docs](https://fintechprimitives.com/docs/api/)
- [Kite Connect (Zerodha) Mutual Funds API](https://kite.trade/docs/connect/v3/mutual-funds/)
- [Groww Trade API](https://groww.in/trade-api)
- [DhanHQ Trading APIs](https://dhanhq.co/)
- [5paisa Developer APIs](https://www.5paisa.com/technology/developer-apis)
- [ICICI Breeze API](https://www.icicidirect.com/futures-and-options/api/breeze)
- [BSE StAR MF GitHub Library](https://github.com/utkarshohm/mf-platform-bse)
- [MFapi.in - Free India MF API](https://www.mfapi.in/)

### Reconciliation & Settlement
- [Limina - Investment Reconciliation Guide](https://www.limina.com/blog/investment-reconciliation)
- [Limina - Cash Position Reconciliation Guide](https://www.limina.com/blog/cash-position-reconciliation-guide)
- [SS&C Eze - What is an OMS](https://www.ezesoft.com/insights/blog/what-is-an-order-management-system)
- [Investment Banking Reconciliation Explained](https://mentormecareers.com/reconciliation-in-investment-banking/)
- [Trade Life Cycle in Investment Banking](https://www.investmentbankingcouncil.org/blog/trade-life-cycle-in-investment-banking-and-its-stages)

### Paper Trading Platforms
- [Paper Invest API](https://paperinvest.io/paper-trading-api/)
- [QuantConnect Paper Trading](https://www.quantconnect.com/docs/v2/cloud-platform/live-trading/brokerages/quantconnect-paper-trading)
- [TradeStation SIM vs LIVE](https://api.tradestation.com/docs/fundamentals/sim-vs-live/)

### Wealth Management Platforms
- [BridgeFT WealthTech API](https://www.bridgeft.com/wealthtech-api/)
- [FinFolio API](https://www.finfolio.com/api)
- [Empaxis Integration Best Practices](https://www.empaxis.com/blog/asset-management-integration)

---

## 13. Recommended Implementation Path

### For Demo (Today):

1. **Create Database Tables** (30 min)
   - investment_execution
   - investment_order
   - position_snapshot

2. **Implement MockBrokerService** (1 hour)
   - Simulate order placement
   - Return realistic responses
   - Use seeded price data

3. **Implement InvestmentExecutionService** (1.5 hours)
   - initiateInvestment()
   - calculateOrdersFromPortfolio()
   - executeOrders()

4. **Create REST Controllers** (45 min)
   - POST /execute
   - GET /execution/{id}
   - GET /positions

5. **Frontend Integration** (1 hour)
   - Investment confirmation page
   - Order status display
   - Position summary

### Total Estimated Time: 4-5 hours

---

## 14. Conclusion

For the demo, implementing a **Mock Broker Service** with realistic order simulation provides the fastest path to a working demonstration. The architecture is designed with a **Strategy Pattern** allowing seamless switching to Alpaca's paper trading or any production custodian when the client is ready.

The key is to:
1. Build the right database schema now
2. Use interfaces for broker integration
3. Start with mock, upgrade to real APIs later
4. Maintain proper order lifecycle tracking
5. Store all transaction records for audit

This approach demonstrates the full investment flow to clients while keeping the architecture production-ready for their custodian integration.

---

**Document Status:** Updated January 2026
**Next Steps:** Implementation of Mock Broker Service and Database Schema
