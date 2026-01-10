# Investment Order Flow & Custodian Integration Research

> **Author:** Claude AI
> **Version:** 1.0
> **Date:** January 2026
> **Purpose:** Research document for implementing investment order flow after proposal acceptance

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Industry Standard Concepts](#2-industry-standard-concepts)
3. [Order Management System (OMS) Architecture](#3-order-management-system-oms-architecture)
4. [Custodian Integration Patterns](#4-custodian-integration-patterns)
5. [Reconciliation Process](#5-reconciliation-process)
6. [Recommended Demo Implementation](#6-recommended-demo-implementation)
7. [Entity Design](#7-entity-design)
8. [API Flow Design](#8-api-flow-design)
9. [Production Considerations](#9-production-considerations)
10. [References](#10-references)

---

## 1. Executive Summary

### Current State
After a customer accepts a proposal in the GBS system, the RM needs to execute investments according to the selected Model Portfolio's asset allocation. Currently, there's no mechanism to:
- Place investment orders
- Track which assets were bought
- Maintain transaction records
- Simulate custodian interaction

### Proposed Solution
Implement a **Mock Custodian System** that simulates real-world investment order flow for demo purposes. This includes:
- Order creation and placement
- Trade execution simulation
- Position tracking
- Reconciliation workflow
- Transaction history

### Key Benefits
- Demonstrates complete investment lifecycle for client demos
- Provides blueprint for production custodian integration
- Maintains audit trail of all investment activities
- Supports future reconciliation and reporting requirements

---

## 2. Industry Standard Concepts

### 2.1 Order Management System (OMS)

An **Order Management System (OMS)** is a digital platform for executing and tracking securities trades throughout their lifecycle.

**Core Capabilities:**
- Order creation and entry
- Routing to exchanges/venues
- Execution monitoring
- Trade confirmation
- Settlement processing
- Position keeping

> *"The OMS seamlessly integrates with post-trade systems to swiftly and accurately complete the settlement process after each trade. It also reconciles trades with counterparties and custodians, ensuring alignment across parties and minimizing risk."*
> — [SS&C Eze](https://www.ezesoft.com/insights/blog/what-is-an-order-management-system)

### 2.2 Custodian

A **Custodian** is a financial institution that holds customers' securities for safekeeping to minimize the risk of theft or loss. Key responsibilities:
- Safekeeping of assets
- Settlement of trades
- Corporate actions processing
- Income collection (dividends, interest)
- Tax reporting
- Valuation and NAV calculation

**Major Custodians:**
- State Street Corporation
- BNY Mellon
- JPMorgan Chase
- Citibank
- HSBC Securities Services
- Northern Trust

### 2.3 Reconciliation

**Reconciliation** is the process of comparing two sets of records to verify alignment:

1. **Trade Reconciliation**: Matching trade details between OMS and custodian
2. **Position Reconciliation**: Comparing internal positions with custodian statements
3. **Cash Reconciliation**: Verifying cash balances across systems

> *"Platforms provide comprehensive multi-currency, multi-asset class and multi-market support using automatic trade transmission reconciliation between back offices and custodians/brokers, processing daily movements (securities, cash and contracts) and positions to ensure the system is 100% reconciled."*
> — [Finartis](https://www.finartis.com/product-features/custodian-interfaces-reconciliation/)

### 2.4 Investment Book of Record (IBOR)

The **IBOR** is the authoritative record of all investment positions and transactions. It provides:
- Real-time position visibility
- Transaction-level detail
- Multi-source data aggregation
- Golden source of truth

### 2.5 Trade Lifecycle

```
┌──────────────────────────────────────────────────────────────────────────┐
│                        TRADE LIFECYCLE                                    │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  1. PRE-TRADE                                                            │
│     ├─ Portfolio Analysis                                                │
│     ├─ Order Generation (from allocation %)                             │
│     ├─ Compliance Check                                                  │
│     └─ Order Approval                                                    │
│           │                                                              │
│           ▼                                                              │
│  2. TRADE EXECUTION                                                      │
│     ├─ Order Submission                                                  │
│     ├─ Routing to Exchange/Broker                                       │
│     ├─ Execution (Fill)                                                 │
│     └─ Confirmation                                                      │
│           │                                                              │
│           ▼                                                              │
│  3. POST-TRADE                                                           │
│     ├─ Trade Matching                                                    │
│     ├─ Settlement (T+1 or T+2)                                          │
│     ├─ Custody Transfer                                                 │
│     └─ Position Update                                                   │
│           │                                                              │
│           ▼                                                              │
│  4. ONGOING                                                              │
│     ├─ Reconciliation                                                    │
│     ├─ Valuation                                                        │
│     ├─ Reporting                                                        │
│     └─ Corporate Actions                                                 │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
```

---

## 3. Order Management System (OMS) Architecture

### 3.1 Key Components

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         OMS ARCHITECTURE                                 │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐    │
│  │  Order Entry    │    │  Order Router   │    │  Execution      │    │
│  │  Module         │───▶│  Module         │───▶│  Engine         │    │
│  └─────────────────┘    └─────────────────┘    └────────┬────────┘    │
│                                                          │              │
│                                                          ▼              │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐    │
│  │  Position       │◀───│  Settlement     │◀───│  Trade          │    │
│  │  Manager        │    │  Engine         │    │  Matching       │    │
│  └─────────────────┘    └─────────────────┘    └─────────────────┘    │
│          │                                                              │
│          ▼                                                              │
│  ┌─────────────────────────────────────────────────────────────────┐  │
│  │                    CUSTODIAN INTERFACE                           │  │
│  │  • Trade Instructions  • Settlement Confirmation  • Positions   │  │
│  └─────────────────────────────────────────────────────────────────┘  │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 3.2 Order States

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         ORDER STATE MACHINE                              │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│                           ┌──────────┐                                  │
│                           │  DRAFT   │                                  │
│                           └────┬─────┘                                  │
│                                │ Submit                                 │
│                                ▼                                        │
│                           ┌──────────┐                                  │
│                   ┌───────│ PENDING  │───────┐                          │
│                   │       │ APPROVAL │       │                          │
│                   │       └──────────┘       │                          │
│              Reject                      Approve                        │
│                   │                          │                          │
│                   ▼                          ▼                          │
│              ┌──────────┐           ┌──────────────┐                    │
│              │ REJECTED │           │   APPROVED   │                    │
│              └──────────┘           └──────┬───────┘                    │
│                                            │ Submit to Execution        │
│                                            ▼                            │
│                                    ┌──────────────┐                     │
│                   ┌────────────────│  SUBMITTED   │────────────────┐    │
│                   │                └──────────────┘                │    │
│              Cancel                        │ Execute           Fail     │
│                   │                        ▼                      │     │
│                   ▼                ┌──────────────┐               ▼     │
│              ┌──────────┐         │  EXECUTING   │         ┌─────────┐  │
│              │ CANCELLED│         └──────┬───────┘         │ FAILED  │  │
│              └──────────┘                │                 └─────────┘  │
│                                          │ All Fills                    │
│                               ┌──────────┴──────────┐                   │
│                               │                     │                   │
│                               ▼                     ▼                   │
│                      ┌──────────────┐      ┌──────────────┐            │
│                      │PARTIALLY_FILL│      │    FILLED    │            │
│                      └──────────────┘      └──────┬───────┘            │
│                                                   │ Settle              │
│                                                   ▼                     │
│                                           ┌──────────────┐              │
│                                           │   SETTLED    │              │
│                                           └──────────────┘              │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 3.3 Trade States

```
PENDING → MATCHED → AFFIRMED → SETTLED
                 ↘ UNMATCHED → BREAK

Trade Matching:
- Internal record matches external confirmation
- Price, quantity, counterparty, settlement date verified
```

---

## 4. Custodian Integration Patterns

### 4.1 Communication Methods

| Method | Description | Use Case |
|--------|-------------|----------|
| **FIX Protocol** | Financial Information eXchange - industry standard messaging | Real-time trade submission |
| **SWIFT** | Society for Worldwide Interbank Financial Telecommunication | Cross-border settlements |
| **REST API** | Modern HTTP-based integration | Position queries, reconciliation |
| **File Transfer** | CSV/XML batch files via SFTP | End-of-day statements |

### 4.2 Standard Message Types

```
┌────────────────────────────────────────────────────────────────────────┐
│                     CUSTODIAN MESSAGE FLOW                              │
├────────────────────────────────────────────────────────────────────────┤
│                                                                        │
│  GBS SYSTEM                                           CUSTODIAN        │
│                                                                        │
│  ┌──────────────────┐                    ┌──────────────────┐         │
│  │ Trade Instruction │ ──────────────▶   │ Receive Order    │         │
│  │ (BUY/SELL order)  │   MT502/MT515    │ Validate & Queue │         │
│  └──────────────────┘                    └────────┬─────────┘         │
│                                                   │                    │
│                                                   ▼                    │
│  ┌──────────────────┐                    ┌──────────────────┐         │
│  │ Receive Confirm  │ ◀──────────────    │ Execute Trade    │         │
│  │ Update Position  │   MT544/MT545     │ Send Confirmation │         │
│  └──────────────────┘                    └────────┬─────────┘         │
│                                                   │                    │
│                                                   ▼                    │
│  ┌──────────────────┐                    ┌──────────────────┐         │
│  │ Settlement Notif │ ◀──────────────    │ Settle Trade     │         │
│  │ Record Complete  │   MT548           │ Transfer Assets   │         │
│  └──────────────────┘                    └──────────────────┘         │
│                                                                        │
│  Daily:                                                                │
│  ┌──────────────────┐                    ┌──────────────────┐         │
│  │ Receive Statement│ ◀──────────────    │ Generate Report  │         │
│  │ Reconcile        │   MT535 (Position) │ Send Statements  │         │
│  └──────────────────┘   MT536 (Cash)     └──────────────────┘         │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
```

### 4.3 Multi-Custodian Support

> *"LSEG AlphaDesk offers an order management system (OMS) and portfolio management system (PMS) that is multi-asset class, multi-currency and multi-custodian, with flexible workflow functionality."*
> — [LSEG](https://www.lseg.com/en/data-analytics/trading-solutions/alphadesk-order-management)

**Design Consideration:** Build abstraction layer to support multiple custodian integrations:

```
┌──────────────────────────────────────────────────────────────────────┐
│                    CUSTODIAN ABSTRACTION LAYER                        │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │                  CustodianService Interface                  │    │
│  │  + submitOrder(order: Order): TradeConfirmation             │    │
│  │  + getPositions(accountId: String): List<Position>          │    │
│  │  + getTransactions(query: TransactionQuery): List<Txn>      │    │
│  │  + reconcile(date: LocalDate): ReconciliationResult         │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                              △                                       │
│                              │ implements                            │
│        ┌─────────────────────┼─────────────────────┐                │
│        │                     │                     │                │
│        ▼                     ▼                     ▼                │
│  ┌───────────┐        ┌───────────┐        ┌───────────┐           │
│  │   Mock    │        │  BNY      │        │ JPMorgan  │           │
│  │ Custodian │        │  Mellon   │        │  Chase    │           │
│  │ (Demo)    │        │ Adapter   │        │  Adapter  │           │
│  └───────────┘        └───────────┘        └───────────┘           │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 5. Reconciliation Process

### 5.1 Reconciliation Types

| Type | Frequency | Description |
|------|-----------|-------------|
| **Trade Reconciliation** | T+0 to T+1 | Match executed trades with custodian confirms |
| **Position Reconciliation** | Daily | Compare holdings with custodian statement |
| **Cash Reconciliation** | Daily | Verify cash balances and movements |
| **NAV Reconciliation** | Daily | Validate portfolio valuations |

### 5.2 Reconciliation Workflow

```
┌──────────────────────────────────────────────────────────────────────┐
│                     RECONCILIATION WORKFLOW                           │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  1. DATA COLLECTION                                                  │
│     ├─ Pull internal positions from OMS                             │
│     ├─ Receive custodian statement (MT535/API)                      │
│     └─ Get NAV from pricing service                                  │
│                                                                      │
│  2. MATCHING                                                         │
│     ├─ Match by: Security ID + Account + Quantity + Settlement Date │
│     ├─ Identify: MATCHED, UNMATCHED, BREAKS                         │
│     └─ Calculate: Variances                                          │
│                                                                      │
│  3. BREAK INVESTIGATION                                              │
│     ├─ Timing differences (T+1 vs T+2)                              │
│     ├─ Corporate actions (splits, dividends)                        │
│     ├─ Failed trades                                                 │
│     └─ Data entry errors                                             │
│                                                                      │
│  4. RESOLUTION                                                       │
│     ├─ Auto-resolve minor variances                                  │
│     ├─ Escalate significant breaks                                   │
│     └─ Adjust positions if needed                                    │
│                                                                      │
│  5. REPORTING                                                        │
│     ├─ Reconciliation summary                                        │
│     ├─ Break report                                                  │
│     └─ Audit trail                                                   │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

### 5.3 Reconciliation Status

```
PENDING → IN_PROGRESS → MATCHED / UNMATCHED
                               ↓
                     BREAK → INVESTIGATING → RESOLVED
```

---

## 6. Recommended Demo Implementation

### 6.1 Mock Custodian Approach

For demo purposes, we'll implement a **simulated custodian** that:
- Accepts trade instructions
- Simulates execution with configurable delay
- Generates trade confirmations
- Updates positions automatically
- Provides statement generation
- Supports reconciliation workflows

> *"BridgeFT provides realistic test data for use in the API sandbox environment. Sandbox users can leverage this data to put their wealth management applications through real-world scenarios."*
> — [BridgeFT](https://www.bridgeft.com/fintech-developer-sandbox-empowers-innovation-with-direct-access-to-apis/)

### 6.2 Demo Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    DEMO INVESTMENT FLOW ARCHITECTURE                     │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌────────────────────────────────────────────────────────────────┐    │
│  │                      GBS BACKEND                                │    │
│  ├────────────────────────────────────────────────────────────────┤    │
│  │                                                                  │    │
│  │  ┌──────────────┐   ┌──────────────┐   ┌──────────────┐        │    │
│  │  │ Proposal     │──▶│ Investment   │──▶│ Trade        │        │    │
│  │  │ (APPROVED)   │   │ Order Service│   │ Execution    │        │    │
│  │  └──────────────┘   └──────────────┘   └──────┬───────┘        │    │
│  │                                               │                  │    │
│  │                                               ▼                  │    │
│  │  ┌──────────────┐   ┌──────────────┐   ┌──────────────┐        │    │
│  │  │ Position     │◀──│ Settlement   │◀──│ Mock         │        │    │
│  │  │ Manager      │   │ Service      │   │ Custodian    │        │    │
│  │  └──────────────┘   └──────────────┘   └──────────────┘        │    │
│  │         │                                                        │    │
│  │         ▼                                                        │    │
│  │  ┌──────────────┐   ┌──────────────┐                            │    │
│  │  │ Reconcilia-  │   │ Transaction  │                            │    │
│  │  │ tion Service │   │ History      │                            │    │
│  │  └──────────────┘   └──────────────┘                            │    │
│  │                                                                  │    │
│  └────────────────────────────────────────────────────────────────┘    │
│                                                                         │
│  ┌────────────────────────────────────────────────────────────────┐    │
│  │                      DATABASE                                    │    │
│  ├────────────────────────────────────────────────────────────────┤    │
│  │  investment_orders | trades | positions | transactions         │    │
│  │  reconciliation_records | custodian_statements                  │    │
│  └────────────────────────────────────────────────────────────────┘    │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 6.3 Key Features for Demo

1. **Order Creation from Approved Proposal**
   - Auto-generate orders based on portfolio allocation
   - Calculate units based on current NAV/price
   - Support both lumpsum and SIP orders

2. **Trade Execution Simulation**
   - Configurable execution delay (instant to realistic T+0/T+1)
   - Random price variance (±0.5% for realism)
   - Partial fills simulation option

3. **Position Tracking**
   - Real-time position updates
   - Average cost calculation
   - Unrealized P&L tracking

4. **Transaction History**
   - Complete audit trail
   - Downloadable statements
   - PDF generation

5. **Reconciliation Dashboard**
   - View matched/unmatched trades
   - Position comparison
   - Break investigation UI

---

## 7. Entity Design

### 7.1 Core Entities

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        ENTITY RELATIONSHIP DIAGRAM                       │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌────────────────┐                                                     │
│  │    Proposal    │ (APPROVED)                                          │
│  │ ───────────────│                                                     │
│  │ portfolioId    │                                                     │
│  │ totalInvestment│                                                     │
│  └───────┬────────┘                                                     │
│          │ 1                                                            │
│          │                                                              │
│          ▼ *                                                            │
│  ┌────────────────┐                                                     │
│  │InvestmentOrder │                                                     │
│  │ ───────────────│                                                     │
│  │ orderId        │───────────────────────────────────────────┐        │
│  │ proposalId     │                                           │        │
│  │ customerId     │                                           │        │
│  │ orderType      │ (LUMPSUM/SIP)                             │        │
│  │ totalAmount    │                                           │        │
│  │ status         │                                           │        │
│  │ executedAt     │                                           │        │
│  └───────┬────────┘                                           │        │
│          │ 1                                                  │        │
│          │                                                    │ 1      │
│          ▼ *                                                  │        │
│  ┌────────────────┐         ┌────────────────┐        ┌───────┴───────┐│
│  │   OrderItem    │         │    Trade       │        │  Transaction  ││
│  │ ───────────────│  1    * │ ───────────────│  1   * │ ──────────────││
│  │ assetClassId   │─────────│ tradeId        │────────│ transactionId ││
│  │ targetAmount   │         │ orderItemId    │        │ tradeId       ││
│  │ targetPercent  │         │ executionPrice │        │ orderId       ││
│  │ units          │         │ quantity       │        │ type          ││
│  │ status         │         │ status         │        │ amount        ││
│  └────────────────┘         │ settlementDate │        │ units         ││
│                             │ custodianRef   │        │ timestamp     ││
│                             └───────┬────────┘        └───────────────┘│
│                                     │ 1                                 │
│                                     │                                   │
│                                     ▼ *                                 │
│                             ┌────────────────┐                          │
│                             │   Position     │                          │
│                             │ ───────────────│                          │
│                             │ customerId     │                          │
│                             │ goalId         │                          │
│                             │ assetClassId   │                          │
│                             │ totalUnits     │                          │
│                             │ averageCost    │                          │
│                             │ currentValue   │                          │
│                             │ unrealizedPnL  │                          │
│                             └────────────────┘                          │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 7.2 Entity Definitions

#### InvestmentOrder
```java
@Entity
@Table(name = "investment_orders")
public class InvestmentOrder {
    @Id
    private Long id;

    private Long proposalId;
    private Long customerId;
    private Long goalId;
    private Long portfolioId;

    @Enumerated(EnumType.STRING)
    private OrderType orderType; // LUMPSUM, SIP

    private BigDecimal totalAmount;

    @Enumerated(EnumType.STRING)
    private OrderStatus status; // DRAFT, PENDING_APPROVAL, APPROVED, SUBMITTED,
                                // EXECUTING, PARTIALLY_FILLED, FILLED, SETTLED,
                                // CANCELLED, FAILED

    private String custodianOrderRef;
    private LocalDateTime submittedAt;
    private LocalDateTime executedAt;
    private LocalDateTime settledAt;

    @OneToMany(mappedBy = "order")
    private List<OrderItem> items;
}
```

#### OrderItem
```java
@Entity
@Table(name = "order_items")
public class OrderItem {
    @Id
    private Long id;

    @ManyToOne
    private InvestmentOrder order;

    @ManyToOne
    private AssetClass assetClass;

    private BigDecimal targetAllocationPercentage;
    private BigDecimal targetAmount;
    private BigDecimal executedAmount;
    private BigDecimal units;
    private BigDecimal executionPrice; // NAV or market price

    @Enumerated(EnumType.STRING)
    private OrderItemStatus status; // PENDING, EXECUTING, FILLED, FAILED
}
```

#### Trade
```java
@Entity
@Table(name = "trades")
public class Trade {
    @Id
    private Long id;

    @ManyToOne
    private OrderItem orderItem;

    private String tradeReference;
    private String custodianTradeRef;

    @Enumerated(EnumType.STRING)
    private TradeType type; // BUY, SELL

    @Enumerated(EnumType.STRING)
    private TradeStatus status; // PENDING, MATCHED, AFFIRMED, SETTLED, FAILED

    private BigDecimal quantity;
    private BigDecimal executionPrice;
    private BigDecimal grossAmount;
    private BigDecimal fees;
    private BigDecimal netAmount;

    private LocalDate tradeDate;
    private LocalDate settlementDate; // T+1 or T+2

    private LocalDateTime executedAt;
    private LocalDateTime settledAt;
}
```

#### Position
```java
@Entity
@Table(name = "customer_positions")
public class Position {
    @Id
    private Long id;

    private Long customerId;
    private Long goalId;

    @ManyToOne
    private AssetClass assetClass;

    private BigDecimal totalUnits;
    private BigDecimal averageCost;
    private BigDecimal currentNav;
    private BigDecimal currentValue;
    private BigDecimal unrealizedPnL;
    private BigDecimal unrealizedPnLPercentage;

    private LocalDateTime lastUpdatedAt;
}
```

#### Transaction
```java
@Entity
@Table(name = "investment_transactions")
public class Transaction {
    @Id
    private Long id;

    private Long customerId;
    private Long goalId;
    private Long orderId;
    private Long tradeId;

    @Enumerated(EnumType.STRING)
    private TransactionType type; // BUY, SELL, DIVIDEND, SWITCH_IN, SWITCH_OUT

    @ManyToOne
    private AssetClass assetClass;

    private BigDecimal units;
    private BigDecimal pricePerUnit;
    private BigDecimal grossAmount;
    private BigDecimal fees;
    private BigDecimal netAmount;

    private String custodianRef;
    private LocalDateTime transactionDate;

    // For audit
    private String createdBy;
}
```

#### ReconciliationRecord
```java
@Entity
@Table(name = "reconciliation_records")
public class ReconciliationRecord {
    @Id
    private Long id;

    private LocalDate reconciliationDate;

    @Enumerated(EnumType.STRING)
    private ReconciliationType type; // POSITION, TRADE, CASH

    @Enumerated(EnumType.STRING)
    private ReconciliationStatus status; // PENDING, MATCHED, UNMATCHED,
                                         // INVESTIGATING, RESOLVED

    private Long customerId;
    private Long assetClassId;

    // Internal (OMS) values
    private BigDecimal internalQuantity;
    private BigDecimal internalValue;

    // External (Custodian) values
    private BigDecimal custodianQuantity;
    private BigDecimal custodianValue;

    // Variance
    private BigDecimal quantityVariance;
    private BigDecimal valueVariance;

    private String breakReason;
    private String resolution;
    private LocalDateTime resolvedAt;
}
```

---

## 8. API Flow Design

### 8.1 Investment Order Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    INVESTMENT ORDER API FLOW                             │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  Step 1: Create Investment Order (after proposal acceptance)           │
│  ─────────────────────────────────────────────────────────────         │
│  POST /api/v1/rm/orders                                                 │
│  {                                                                      │
│    "proposalId": 123,                                                   │
│    "orderType": "LUMPSUM",                                              │
│    "amount": 100000                                                     │
│  }                                                                      │
│                                                                         │
│  Response:                                                              │
│  {                                                                      │
│    "orderId": 456,                                                      │
│    "status": "DRAFT",                                                   │
│    "items": [                                                           │
│      { "assetClassCode": "EQUITY_LARGE_CAP", "amount": 30000 },        │
│      { "assetClassCode": "DEBT_GOVT_SEC", "amount": 40000 },           │
│      ...                                                                │
│    ]                                                                    │
│  }                                                                      │
│                                                                         │
│  ─────────────────────────────────────────────────────────────         │
│  Step 2: Submit Order for Execution                                     │
│  ─────────────────────────────────────────────────────────────         │
│  POST /api/v1/rm/orders/{orderId}/submit                               │
│                                                                         │
│  Response:                                                              │
│  {                                                                      │
│    "orderId": 456,                                                      │
│    "status": "SUBMITTED",                                               │
│    "custodianOrderRef": "CUST-2026-001234",                            │
│    "submittedAt": "2026-01-04T10:30:00"                                │
│  }                                                                      │
│                                                                         │
│  ─────────────────────────────────────────────────────────────         │
│  Step 3: Check Execution Status (polling or webhook)                   │
│  ─────────────────────────────────────────────────────────────         │
│  GET /api/v1/rm/orders/{orderId}/status                                │
│                                                                         │
│  Response:                                                              │
│  {                                                                      │
│    "orderId": 456,                                                      │
│    "status": "FILLED",                                                  │
│    "trades": [                                                          │
│      {                                                                  │
│        "tradeId": 789,                                                  │
│        "assetClassCode": "EQUITY_LARGE_CAP",                           │
│        "quantity": 245.678,                                            │
│        "executionPrice": 122.15,                                       │
│        "status": "SETTLED"                                             │
│      },                                                                 │
│      ...                                                                │
│    ]                                                                    │
│  }                                                                      │
│                                                                         │
│  ─────────────────────────────────────────────────────────────         │
│  Step 4: View Updated Positions                                         │
│  ─────────────────────────────────────────────────────────────         │
│  GET /api/v1/customer/{customerId}/positions?goalId=123                │
│                                                                         │
│  Response:                                                              │
│  {                                                                      │
│    "customerId": 51,                                                    │
│    "goalId": 25,                                                        │
│    "positions": [                                                       │
│      {                                                                  │
│        "assetClassCode": "EQUITY_LARGE_CAP",                           │
│        "assetClassName": "Large Cap Equity",                           │
│        "units": 245.678,                                               │
│        "averageCost": 122.15,                                          │
│        "currentNav": 125.30,                                           │
│        "currentValue": 30786.46,                                       │
│        "unrealizedPnL": 773.87,                                        │
│        "unrealizedPnLPct": 2.58                                        │
│      },                                                                 │
│      ...                                                                │
│    ],                                                                   │
│    "totalValue": 101234.56,                                            │
│    "totalInvested": 100000.00,                                         │
│    "totalPnL": 1234.56                                                 │
│  }                                                                      │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 8.2 API Endpoints Summary

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/v1/rm/orders` | Create investment order from proposal |
| `GET` | `/api/v1/rm/orders/{id}` | Get order details |
| `POST` | `/api/v1/rm/orders/{id}/submit` | Submit order for execution |
| `POST` | `/api/v1/rm/orders/{id}/cancel` | Cancel pending order |
| `GET` | `/api/v1/rm/orders/{id}/status` | Check execution status |
| `GET` | `/api/v1/rm/orders/{id}/trades` | Get trades for order |
| `GET` | `/api/v1/customer/{id}/positions` | Get customer positions |
| `GET` | `/api/v1/customer/{id}/transactions` | Get transaction history |
| `GET` | `/api/v1/admin/reconciliation` | Run/view reconciliation |
| `POST` | `/api/v1/admin/reconciliation/resolve/{id}` | Resolve break |

---

## 9. Production Considerations

### 9.1 Real Custodian Integration

When moving to production, the Mock Custodian can be replaced with real adapters:

```java
// Configuration-driven custodian selection
@Configuration
public class CustodianConfig {

    @Bean
    @ConditionalOnProperty(name = "custodian.type", havingValue = "mock")
    public CustodianService mockCustodian() {
        return new MockCustodianService();
    }

    @Bean
    @ConditionalOnProperty(name = "custodian.type", havingValue = "bny-mellon")
    public CustodianService bnyMellonCustodian() {
        return new BnyMellonCustodianAdapter();
    }

    @Bean
    @ConditionalOnProperty(name = "custodian.type", havingValue = "jpmorgan")
    public CustodianService jpmorganCustodian() {
        return new JpmorganCustodianAdapter();
    }
}
```

### 9.2 Security Considerations

- **API Authentication**: OAuth 2.0 / JWT for custodian APIs
- **Data Encryption**: TLS 1.3 for transit, AES-256 for storage
- **Audit Logging**: All operations logged with user context
- **Rate Limiting**: Protect against DDoS and API abuse
- **IP Whitelisting**: Restrict custodian communication to known IPs

### 9.3 Compliance Requirements

- **MiFID II**: Best execution reporting
- **GDPR**: Data privacy for EU customers
- **SOC 2**: Security controls audit
- **KYC/AML**: Transaction monitoring

---

## 10. References

### 10.1 Web Sources

1. [SS&C Eze - What is an OMS?](https://www.ezesoft.com/insights/blog/what-is-an-order-management-system)
2. [LSEG AlphaDesk - Multi-Custodian OMS](https://www.lseg.com/en/data-analytics/trading-solutions/alphadesk-order-management)
3. [Finartis - Custodian Interfaces & Reconciliation](https://www.finartis.com/product-features/custodian-interfaces-reconciliation/)
4. [BridgeFT - WealthTech API](https://www.bridgeft.com/wealthtech-api/)
5. [Landytech - Wealth Management API Benefits](https://www.landytech.com/blog/5-reasons-why-apis-are-the-new-benchmark-in-investment-portfolio-management)
6. [Masttro - Best Wealth Reporting Software](https://masttro.com/insights/best-wealth-reporting-software)

### 10.2 Industry Standards

- **FIX Protocol**: [https://www.fixtrading.org/](https://www.fixtrading.org/)
- **SWIFT Standards**: [https://www.swift.com/](https://www.swift.com/)
- **ISO 20022**: [https://www.iso20022.org/](https://www.iso20022.org/)

### 10.3 Leading Platforms (2025-2026)

- **Charles River IMS**: Front-to-back investment management
- **BlackRock Aladdin**: Risk analytics and trading
- **Bloomberg AIM**: Multi-asset class OMS
- **SimCorp Dimension**: Investment management platform

---

## Summary

This research document provides the foundation for implementing a complete investment order flow in the GBS system. The recommended approach:

1. **Start with Mock Custodian** for demo purposes
2. **Build abstraction layer** for easy production migration
3. **Implement core entities**: Orders, Trades, Positions, Transactions
4. **Add reconciliation** for data integrity
5. **Design for multi-custodian** future expansion

The next step is to create detailed implementation specifications in the plan file.

---

**Document Status:** Complete
**Next Steps:** Implementation Planning
