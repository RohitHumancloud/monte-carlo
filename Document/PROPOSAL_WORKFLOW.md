# Proposal & Notification System - Complete Workflow Documentation

> **Author:** Claude AI
> **Version:** 1.0
> **Last Updated:** January 2026
> **Purpose:** Comprehensive documentation for the Proposal and Notification system in the Goal-Based Advisory (GBS) application.

---

## Table of Contents

1. [System Overview](#1-system-overview)
2. [Database Schema](#2-database-schema)
3. [Entity Relationships](#3-entity-relationships)
4. [Proposal Workflows](#4-proposal-workflows)
5. [Notification System](#5-notification-system)
6. [API Reference](#6-api-reference)
7. [Frontend Integration Guide](#7-frontend-integration-guide)
8. [Security Considerations](#8-security-considerations)
9. [Troubleshooting](#9-troubleshooting)

---

## 1. System Overview

### 1.1 What is a Proposal?

A **Proposal** is a formal investment recommendation that captures a complete investment journey snapshot including:
- Goal details (retirement, education, etc.)
- Risk profile assessment results
- Suitability check outcomes
- Investment calculator projections
- Recommended portfolio allocation
- Fund distribution strategy

### 1.2 Two Types of Proposals

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         PROPOSAL TYPES                                       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  1. RM_TO_CUSTOMER (RM sends proposal to Customer)                          │
│     ┌─────┐                                              ┌──────────┐       │
│     │ RM  │ ─────── Creates Journey ──────────────────▶ │ Customer │       │
│     └─────┘         Sends Proposal                       └──────────┘       │
│                     Customer Accepts/Rejects                                 │
│                                                                              │
│  2. CUSTOMER_TO_RM (Customer requests RM review)                            │
│     ┌──────────┐                                         ┌─────┐            │
│     │ Customer │ ─────── Completes Journey ────────────▶ │ RM  │            │
│     └──────────┘         Requests Review                 └─────┘            │
│                          RM Approves/Rejects                                 │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 1.3 Proposal Lifecycle States

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      PROPOSAL STATUS FLOW                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│                            ┌─────────┐                                       │
│                            │  DRAFT  │ (Optional - not used in v1)          │
│                            └────┬────┘                                       │
│                                 │                                            │
│                                 ▼                                            │
│                            ┌─────────┐                                       │
│                      ┌─────│ PENDING │─────┐                                │
│                      │     └────┬────┘     │                                │
│                      │          │          │                                │
│                      ▼          │          ▼                                │
│               ┌──────────┐      │    ┌──────────┐                           │
│               │ APPROVED │      │    │ REJECTED │                           │
│               └──────────┘      │    └──────────┘                           │
│                                 │                                            │
│                      ┌──────────┴──────────┐                                │
│                      ▼                     ▼                                │
│               ┌──────────┐          ┌────────────┐                          │
│               │ EXPIRED  │          │ SUPERSEDED │                          │
│               └──────────┘          └────────────┘                          │
│               (Time-based)          (New proposal                            │
│                                      created)                                │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Database Schema

### 2.1 Proposals Table

```sql
CREATE TABLE proposals (
    -- Primary Key
    id BIGSERIAL PRIMARY KEY,

    -- Relationships
    journey_tracking_id BIGINT NOT NULL REFERENCES goal_journey_tracking(id),
    goal_id BIGINT REFERENCES goals(id),
    customer_id BIGINT NOT NULL REFERENCES users(id),
    rm_id BIGINT NOT NULL REFERENCES users(id),

    -- Proposal Type & Status
    proposal_type VARCHAR(50) NOT NULL,        -- 'RM_TO_CUSTOMER' or 'CUSTOMER_TO_RM'
    status VARCHAR(50) NOT NULL DEFAULT 'PENDING',

    -- Denormalized Display Fields (for quick queries)
    goal_name VARCHAR(255),
    risk_profile VARCHAR(100),
    suitability_status VARCHAR(100),
    target_amount DECIMAL(19,2),
    monthly_investment DECIMAL(19,2),
    portfolio_name VARCHAR(255),

    -- Full Journey Snapshot (JSON)
    goal_data JSONB,           -- Complete goal configuration
    risk_data JSONB,           -- Risk assessment responses
    suitability_data JSONB,    -- Suitability check results
    calculator_data JSONB,     -- Calculator inputs/outputs
    portfolio_data JSONB,      -- Portfolio allocation
    distribution_data JSONB,   -- Fund distribution

    -- Communication
    message TEXT,              -- RM's message to customer
    rejection_reason TEXT,     -- Reason if rejected

    -- Validity Period
    valid_from TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP,
    responded_at TIMESTAMP,

    -- Audit Fields
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by BIGINT REFERENCES users(id),
    updated_by BIGINT REFERENCES users(id),
    is_deleted BOOLEAN DEFAULT FALSE
);
```

### 2.2 Notifications Table

```sql
CREATE TABLE notifications (
    -- Primary Key
    id BIGSERIAL PRIMARY KEY,

    -- Recipient
    user_id BIGINT NOT NULL REFERENCES users(id),

    -- Notification Content
    type VARCHAR(50) NOT NULL,       -- 'PROPOSAL_RECEIVED', 'PROPOSAL_APPROVED', etc.
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,

    -- Reference to Related Entity
    reference_type VARCHAR(50),      -- 'PROPOSAL', 'JOURNEY', etc.
    reference_id BIGINT,

    -- Display Properties
    priority VARCHAR(20) DEFAULT 'NORMAL',  -- 'HIGH', 'NORMAL', 'LOW'
    action_url VARCHAR(500),                -- URL to navigate on click
    metadata JSONB,                         -- Additional display data

    -- Read Status
    is_read BOOLEAN DEFAULT FALSE,
    read_at TIMESTAMP,

    -- Audit Fields
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
);
```

### 2.3 Indexes

```sql
-- Proposal Indexes
CREATE INDEX idx_proposals_customer_id ON proposals(customer_id) WHERE is_deleted = FALSE;
CREATE INDEX idx_proposals_rm_id ON proposals(rm_id) WHERE is_deleted = FALSE;
CREATE INDEX idx_proposals_journey_tracking_id ON proposals(journey_tracking_id);
CREATE INDEX idx_proposals_status ON proposals(status) WHERE is_deleted = FALSE;
CREATE INDEX idx_proposals_type_status ON proposals(proposal_type, status) WHERE is_deleted = FALSE;
CREATE INDEX idx_proposals_expires_at ON proposals(expires_at) WHERE status = 'PENDING';

-- Notification Indexes
CREATE INDEX idx_notifications_user_id ON notifications(user_id) WHERE is_deleted = FALSE;
CREATE INDEX idx_notifications_user_unread ON notifications(user_id, is_read) WHERE is_deleted = FALSE;
CREATE INDEX idx_notifications_reference ON notifications(reference_type, reference_id);
CREATE INDEX idx_notifications_created_at ON notifications(created_at DESC) WHERE is_deleted = FALSE;
```

---

## 3. Entity Relationships

### 3.1 Entity Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         ENTITY RELATIONSHIPS                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│                              ┌───────────────┐                               │
│                              │     User      │                               │
│                              │  (Customer)   │                               │
│                              └───────┬───────┘                               │
│                                      │                                       │
│                         ┌────────────┼────────────┐                          │
│                         │            │            │                          │
│                         ▼            ▼            ▼                          │
│                   ┌──────────┐ ┌──────────┐ ┌──────────────┐                │
│                   │  Goals   │ │ Proposals│ │Notifications │                │
│                   └────┬─────┘ └────┬─────┘ └──────────────┘                │
│                        │            │                                        │
│                        │            │                                        │
│                        ▼            ▼                                        │
│                   ┌────────────────────┐                                     │
│                   │GoalJourneyTracking │                                     │
│                   │  (Stage Data)      │                                     │
│                   └────────────────────┘                                     │
│                              │                                               │
│                              ▼                                               │
│                   ┌────────────────────┐                                     │
│                   │    User (RM)       │                                     │
│                   └────────────────────┘                                     │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 3.2 Java Entity Classes

**Proposal.java:**
```java
@Entity
@Table(name = "proposals")
public class Proposal {
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "journey_tracking_id")
    private GoalJourneyTracking journeyTracking;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id")
    private User customer;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "rm_id")
    private User rm;

    @Enumerated(EnumType.STRING)
    private ProposalStatus status;

    @Enumerated(EnumType.STRING)
    private ProposalType proposalType;
}
```

**Notification.java:**
```java
@Entity
@Table(name = "notifications")
public class Notification {
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @Enumerated(EnumType.STRING)
    private NotificationType type;

    private String referenceType;  // "PROPOSAL"
    private Long referenceId;      // proposal.id
}
```

---

## 4. Proposal Workflows

### 4.1 Workflow 1: RM Creates and Sends Proposal to Customer

```
┌─────────────────────────────────────────────────────────────────────────────┐
│          RM → CUSTOMER PROPOSAL WORKFLOW                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  RM Portal                                          Customer Portal          │
│  ─────────                                          ─────────────           │
│                                                                              │
│  1. Select Customer                                                          │
│      │                                                                       │
│      ▼                                                                       │
│  2. Create Journey                                                           │
│     ├─ Select Goal                                                          │
│     ├─ Risk Assessment                                                      │
│     ├─ Suitability Check                                                    │
│     ├─ Investment Calculator                                                │
│     ├─ Portfolio Selection                                                  │
│     └─ Fund Distribution                                                    │
│      │                                                                       │
│      ▼                                                                       │
│  3. Click "Send Proposal"                                                   │
│      │                                                                       │
│      │  POST /api/v1/rm/proposals                                           │
│      │  {                                                                    │
│      │    "journeyTrackingId": 123,                                         │
│      │    "message": "Please review..."                                     │
│      │  }                                                                    │
│      │                                                                       │
│      ▼                                                                       │
│  4. Backend:                                                                │
│     ├─ Create Proposal (status=PENDING)                                     │
│     ├─ Snapshot journey data                                                │
│     └─ Create Notification ────────────────────────▶ 5. Customer sees       │
│                                                         notification bell    │
│                                                         badge (count)        │
│                                                           │                  │
│                                                           ▼                  │
│                                                      6. Customer clicks      │
│                                                         notification         │
│                                                           │                  │
│                                                           ▼                  │
│                                                      7. Views Proposal       │
│                                                         details              │
│                                                           │                  │
│                                                      ┌────┴────┐             │
│                                                      │         │             │
│                                                      ▼         ▼             │
│  9. RM receives                                 8a. Accept  8b. Reject       │
│     notification ◀───────────────────────────────   │         │             │
│     of result                                        │         │             │
│      │                                               ▼         ▼             │
│      ▼                                          PUT /{id}/  PUT /{id}/       │
│  10. Proposal marked                            accept      reject           │
│      APPROVED or REJECTED                                                    │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 4.2 Workflow 2: Customer Requests RM Review

```
┌─────────────────────────────────────────────────────────────────────────────┐
│          CUSTOMER → RM REVIEW REQUEST WORKFLOW                               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Customer Portal                                    RM Portal                │
│  ───────────────                                    ─────────               │
│                                                                              │
│  1. Customer logs in                                                         │
│      │                                                                       │
│      ▼                                                                       │
│  2. Complete Journey                                                         │
│     ├─ Select Goal                                                          │
│     ├─ Risk Assessment                                                      │
│     ├─ Suitability Check                                                    │
│     ├─ Investment Calculator                                                │
│     ├─ Portfolio Selection                                                  │
│     └─ Fund Distribution                                                    │
│      │                                                                       │
│      ▼                                                                       │
│  3. Click "Send for RM Review"                                              │
│      │                                                                       │
│      │  POST /api/v1/customer/proposals/request-review                      │
│      │  {                                                                    │
│      │    "journeyTrackingId": 456,                                         │
│      │    "note": "Please review my plan"                                   │
│      │  }                                                                    │
│      │                                                                       │
│      ▼                                                                       │
│  4. Backend:                                                                │
│     ├─ Create Proposal (type=CUSTOMER_TO_RM)                                │
│     ├─ Snapshot journey data                                                │
│     └─ Notify RM ──────────────────────────────────▶ 5. RM sees "Pending    │
│                                                         Reviews" badge       │
│                                                           │                  │
│                                                           ▼                  │
│                                                      6. RM clicks review     │
│                                                         in dashboard         │
│                                                           │                  │
│                                                           ▼                  │
│                                                      7. Reviews journey      │
│                                                         details              │
│                                                           │                  │
│                                                      ┌────┴────┐             │
│                                                      │         │             │
│                                                      ▼         ▼             │
│  9. Customer receives                           8a. Approve 8b. Reject       │
│     notification ◀──────────────────────────────    with     with            │
│      │                                              feedback  reason          │
│      │                                                                       │
│      ▼                                                                       │
│  10a. If APPROVED:                                                          │
│       Customer can finalize                                                  │
│                                                                              │
│  10b. If REJECTED:                                                          │
│       Customer revises and                                                   │
│       resubmits                                                              │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 4.3 API Call Sequence Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│          RM SENDS PROPOSAL - API SEQUENCE                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   RM Client              Backend                    Database                 │
│      │                      │                          │                     │
│      │  POST /rm/proposals  │                          │                     │
│      │─────────────────────▶│                          │                     │
│      │  {journeyTrackingId} │                          │                     │
│      │                      │                          │                     │
│      │                      │  SELECT journey_tracking │                     │
│      │                      │─────────────────────────▶│                     │
│      │                      │◀─────────────────────────│                     │
│      │                      │                          │                     │
│      │                      │  INSERT proposal         │                     │
│      │                      │─────────────────────────▶│                     │
│      │                      │◀─────────────────────────│                     │
│      │                      │                          │                     │
│      │                      │  INSERT notification     │                     │
│      │                      │─────────────────────────▶│                     │
│      │                      │◀─────────────────────────│                     │
│      │                      │                          │                     │
│      │  201 Created         │                          │                     │
│      │  ProposalDto         │                          │                     │
│      │◀─────────────────────│                          │                     │
│      │                      │                          │                     │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 5. Notification System

### 5.1 Notification Types

| Type | Trigger | Recipient | Priority | Action URL |
|------|---------|-----------|----------|------------|
| `PROPOSAL_RECEIVED` | RM sends proposal | Customer | HIGH | `/client/proposals/{id}` |
| `PROPOSAL_APPROVED` | Customer accepts | RM | NORMAL | `/rm/proposals/{id}` |
| `PROPOSAL_REJECTED` | Customer rejects | RM | NORMAL | `/rm/proposals/{id}` |
| `REVIEW_REQUESTED` | Customer requests review | RM | HIGH | `/rm/reviews/{id}` |
| `REVIEW_APPROVED` | RM approves review | Customer | NORMAL | `/client/proposals/{id}` |
| `REVIEW_REJECTED` | RM rejects review | Customer | NORMAL | `/client/journey/{id}` |
| `PROPOSAL_EXPIRING` | 7 days before expiry | Customer | HIGH | `/client/proposals/{id}` |
| `PROPOSAL_EXPIRED` | Expiry date passed | Both | LOW | N/A |

### 5.2 Notification Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│          NOTIFICATION CREATION FLOW                                          │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   ProposalService                NotificationService              Database  │
│         │                               │                            │      │
│         │  notifyProposalReceived()     │                            │      │
│         │──────────────────────────────▶│                            │      │
│         │                               │                            │      │
│         │                               │  Build Notification        │      │
│         │                               │  - user = customer         │      │
│         │                               │  - type = PROPOSAL_RECEIVED│      │
│         │                               │  - title = "New Proposal"  │      │
│         │                               │  - message = "John sent..."│      │
│         │                               │  - actionUrl = "/client..."│      │
│         │                               │  - metadata = {goalName,.. │      │
│         │                               │                            │      │
│         │                               │  INSERT notification       │      │
│         │                               │───────────────────────────▶│      │
│         │                               │◀───────────────────────────│      │
│         │◀──────────────────────────────│                            │      │
│         │                               │                            │      │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 5.3 Notification JSON Structure

```json
{
  "id": 1,
  "type": "PROPOSAL_RECEIVED",
  "title": "New Proposal Received",
  "message": "John Smith sent you a proposal for Retirement Planning",
  "referenceType": "PROPOSAL",
  "referenceId": 123,
  "priority": "HIGH",
  "actionUrl": "/client/proposals/123",
  "metadata": {
    "goalName": "Retirement Planning",
    "rmName": "John Smith",
    "proposalId": 123,
    "portfolioName": "Balanced Growth Portfolio"
  },
  "isRead": false,
  "readAt": null,
  "createdAt": "2026-01-03T10:30:00",
  "timeAgo": "5 minutes ago"
}
```

---

## 6. API Reference

### 6.1 RM Proposal APIs

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| `POST` | `/api/v1/rm/proposals` | Create and send proposal to customer | ROLE_RM |
| `GET` | `/api/v1/rm/proposals` | Get all proposals sent by this RM | ROLE_RM |
| `GET` | `/api/v1/rm/proposals/{id}` | Get single proposal details | ROLE_RM |
| `GET` | `/api/v1/rm/proposals/pending-reviews` | Get customer review requests | ROLE_RM |
| `GET` | `/api/v1/rm/proposals/pending-reviews/count` | Count pending reviews (for badge) | ROLE_RM |
| `PUT` | `/api/v1/rm/proposals/{id}/approve` | Approve customer's review | ROLE_RM |
| `PUT` | `/api/v1/rm/proposals/{id}/reject` | Reject customer's review | ROLE_RM |

### 6.2 Customer Proposal APIs

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| `GET` | `/api/v1/customer/proposals` | Get all proposals received | ROLE_USER |
| `GET` | `/api/v1/customer/proposals/pending` | Get pending proposals | ROLE_USER |
| `GET` | `/api/v1/customer/proposals/pending/count` | Count pending (for badge) | ROLE_USER |
| `GET` | `/api/v1/customer/proposals/{id}` | Get single proposal | ROLE_USER |
| `PUT` | `/api/v1/customer/proposals/{id}/accept` | Accept RM's proposal | ROLE_USER |
| `PUT` | `/api/v1/customer/proposals/{id}/reject` | Reject RM's proposal | ROLE_USER |
| `POST` | `/api/v1/customer/proposals/request-review` | Request RM review | ROLE_USER |

### 6.3 Notification APIs

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| `GET` | `/api/v1/notifications` | Get all notifications | Any |
| `GET` | `/api/v1/notifications/recent?limit=10` | Get recent (dropdown) | Any |
| `GET` | `/api/v1/notifications/unread-count` | Get unread count (badge) | Any |
| `GET` | `/api/v1/notifications/{id}` | Get single notification | Any |
| `PUT` | `/api/v1/notifications/{id}/read` | Mark as read | Any |
| `PUT` | `/api/v1/notifications/read-all` | Mark all as read | Any |

### 6.4 Request/Response Examples

**Create Proposal Request (RM):**
```json
POST /api/v1/rm/proposals
Authorization: Bearer <jwt_token>
Content-Type: application/json

{
  "journeyTrackingId": 123,
  "message": "Hi John, I've prepared this investment proposal for your retirement goal. Please review and let me know if you have any questions.",
  "validityDays": 30
}
```

**Create Proposal Response:**
```json
{
  "id": 456,
  "journeyTrackingId": 123,
  "customerId": 2,
  "customerName": "John Doe",
  "rmId": 1,
  "rmName": "Jane Smith",
  "proposalType": "RM_TO_CUSTOMER",
  "status": "PENDING",
  "goalName": "Retirement Planning",
  "riskProfile": "MODERATE",
  "suitabilityStatus": "SUITABLE",
  "targetAmount": 1000000.00,
  "monthlyInvestment": 15000.00,
  "portfolioName": "Balanced Growth Portfolio",
  "message": "Hi John, I've prepared...",
  "validFrom": "2026-01-03T10:30:00",
  "expiresAt": "2026-02-02T10:30:00",
  "createdAt": "2026-01-03T10:30:00"
}
```

**Request Review (Customer):**
```json
POST /api/v1/customer/proposals/request-review
Authorization: Bearer <jwt_token>
Content-Type: application/json

{
  "journeyTrackingId": 789,
  "note": "I've completed my retirement planning journey. Please review when you have time."
}
```

**Accept/Reject Proposal:**
```json
PUT /api/v1/customer/proposals/456/reject
Authorization: Bearer <jwt_token>
Content-Type: application/json

{
  "reason": "I would prefer a more aggressive portfolio allocation for higher returns."
}
```

---

## 7. Frontend Integration Guide

### 7.1 RM Portal Integration

```typescript
// rm-proposal.service.ts

@Injectable({ providedIn: 'root' })
export class RmProposalService {
  private baseUrl = '/api/v1/rm/proposals';

  constructor(private http: HttpClient) {}

  // Create and send proposal
  createProposal(request: CreateProposalRequest): Observable<ProposalDto> {
    return this.http.post<ProposalDto>(this.baseUrl, request);
  }

  // Get all my sent proposals
  getMyProposals(): Observable<ProposalDto[]> {
    return this.http.get<ProposalDto[]>(this.baseUrl);
  }

  // Get pending customer reviews
  getPendingReviews(): Observable<ProposalDto[]> {
    return this.http.get<ProposalDto[]>(`${this.baseUrl}/pending-reviews`);
  }

  // Get pending review count for badge
  getPendingReviewCount(): Observable<{ count: number }> {
    return this.http.get<{ count: number }>(`${this.baseUrl}/pending-reviews/count`);
  }

  // Approve customer's review
  approveReview(id: number, request?: ProposalActionRequest): Observable<ProposalDto> {
    return this.http.put<ProposalDto>(`${this.baseUrl}/${id}/approve`, request || {});
  }

  // Reject customer's review
  rejectReview(id: number, request: ProposalActionRequest): Observable<ProposalDto> {
    return this.http.put<ProposalDto>(`${this.baseUrl}/${id}/reject`, request);
  }
}
```

### 7.2 Customer Portal Integration

```typescript
// customer-proposal.service.ts

@Injectable({ providedIn: 'root' })
export class CustomerProposalService {
  private baseUrl = '/api/v1/customer/proposals';

  constructor(private http: HttpClient) {}

  // Get proposals received from RM
  getMyProposals(): Observable<ProposalDto[]> {
    return this.http.get<ProposalDto[]>(this.baseUrl);
  }

  // Get pending proposals needing action
  getPendingProposals(): Observable<ProposalDto[]> {
    return this.http.get<ProposalDto[]>(`${this.baseUrl}/pending`);
  }

  // Get pending count for badge
  getPendingCount(): Observable<{ count: number }> {
    return this.http.get<{ count: number }>(`${this.baseUrl}/pending/count`);
  }

  // Accept RM's proposal
  acceptProposal(id: number, request?: ProposalActionRequest): Observable<ProposalDto> {
    return this.http.put<ProposalDto>(`${this.baseUrl}/${id}/accept`, request || {});
  }

  // Reject RM's proposal
  rejectProposal(id: number, request: ProposalActionRequest): Observable<ProposalDto> {
    return this.http.put<ProposalDto>(`${this.baseUrl}/${id}/reject`, request);
  }

  // Request RM to review my journey
  requestReview(request: CustomerReviewRequest): Observable<ProposalDto> {
    return this.http.post<ProposalDto>(`${this.baseUrl}/request-review`, request);
  }
}
```

### 7.3 Notification Integration

```typescript
// notification.service.ts

@Injectable({ providedIn: 'root' })
export class NotificationService {
  private baseUrl = '/api/v1/notifications';

  constructor(private http: HttpClient) {}

  // Get unread count (call on app init, show in bell badge)
  getUnreadCount(): Observable<{ count: number }> {
    return this.http.get<{ count: number }>(`${this.baseUrl}/unread-count`);
  }

  // Get recent notifications (when user clicks bell)
  getRecentNotifications(limit: number = 10): Observable<NotificationDto[]> {
    return this.http.get<NotificationDto[]>(`${this.baseUrl}/recent`, {
      params: { limit: limit.toString() }
    });
  }

  // Mark single notification as read (when clicked)
  markAsRead(id: number): Observable<NotificationDto> {
    return this.http.put<NotificationDto>(`${this.baseUrl}/${id}/read`, {});
  }

  // Mark all as read
  markAllAsRead(): Observable<{ success: boolean; count: number }> {
    return this.http.put<{ success: boolean; count: number }>(
      `${this.baseUrl}/read-all`,
      {}
    );
  }
}
```

### 7.4 Notification Bell Component

```typescript
// notification-bell.component.ts

@Component({
  selector: 'app-notification-bell',
  template: `
    <button (click)="toggleDropdown()" class="notification-bell">
      <mat-icon>notifications</mat-icon>
      <span *ngIf="unreadCount > 0" class="badge">{{ unreadCount }}</span>
    </button>

    <div *ngIf="isOpen" class="notification-dropdown">
      <div class="header">
        <span>Notifications</span>
        <button (click)="markAllRead()">Mark all as read</button>
      </div>

      <div class="notification-list">
        <div *ngFor="let n of notifications"
             [class.unread]="!n.isRead"
             (click)="handleClick(n)">
          <div class="title">{{ n.title }}</div>
          <div class="message">{{ n.message }}</div>
          <div class="time">{{ n.timeAgo }}</div>
        </div>
      </div>
    </div>
  `
})
export class NotificationBellComponent implements OnInit {
  unreadCount = 0;
  notifications: NotificationDto[] = [];
  isOpen = false;

  constructor(
    private notificationService: NotificationService,
    private router: Router
  ) {}

  ngOnInit() {
    this.loadUnreadCount();
    // Poll every 30 seconds
    interval(30000).subscribe(() => this.loadUnreadCount());
  }

  loadUnreadCount() {
    this.notificationService.getUnreadCount()
      .subscribe(res => this.unreadCount = res.count);
  }

  toggleDropdown() {
    this.isOpen = !this.isOpen;
    if (this.isOpen) {
      this.loadNotifications();
    }
  }

  loadNotifications() {
    this.notificationService.getRecentNotifications(10)
      .subscribe(notifications => this.notifications = notifications);
  }

  handleClick(notification: NotificationDto) {
    // Mark as read
    this.notificationService.markAsRead(notification.id).subscribe(() => {
      this.loadUnreadCount();
    });

    // Navigate to action URL
    if (notification.actionUrl) {
      this.router.navigateByUrl(notification.actionUrl);
    }

    this.isOpen = false;
  }

  markAllRead() {
    this.notificationService.markAllAsRead().subscribe(() => {
      this.unreadCount = 0;
      this.notifications.forEach(n => n.isRead = true);
    });
  }
}
```

### 7.5 Send Proposal Button (RM Distribution Page)

```typescript
// distribution.component.ts (RM Portal)

@Component({
  selector: 'app-distribution',
  template: `
    <!-- Existing distribution UI -->

    <div class="actions">
      <button mat-raised-button color="primary" (click)="sendProposal()">
        Send Proposal to Customer
      </button>
    </div>
  `
})
export class DistributionComponent {
  journeyTrackingId: number;

  constructor(
    private proposalService: RmProposalService,
    private dialog: MatDialog,
    private snackBar: MatSnackBar
  ) {}

  sendProposal() {
    // Open dialog to add optional message
    const dialogRef = this.dialog.open(SendProposalDialogComponent);

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        const request: CreateProposalRequest = {
          journeyTrackingId: this.journeyTrackingId,
          message: result.message,
          validityDays: result.validityDays || 30
        };

        this.proposalService.createProposal(request).subscribe({
          next: (proposal) => {
            this.snackBar.open('Proposal sent successfully!', 'Close', {
              duration: 3000
            });
          },
          error: (err) => {
            this.snackBar.open('Failed to send proposal', 'Close', {
              duration: 3000
            });
          }
        });
      }
    });
  }
}
```

### 7.6 Request Review Button (Customer Distribution Page)

```typescript
// distribution.component.ts (Customer Portal)

@Component({
  selector: 'app-customer-distribution',
  template: `
    <!-- Existing distribution UI -->

    <div class="actions">
      <button mat-raised-button color="primary" (click)="requestReview()">
        Send for RM Review
      </button>
    </div>
  `
})
export class CustomerDistributionComponent {
  journeyTrackingId: number;

  constructor(
    private proposalService: CustomerProposalService,
    private snackBar: MatSnackBar
  ) {}

  requestReview() {
    const request: CustomerReviewRequest = {
      journeyTrackingId: this.journeyTrackingId,
      note: 'Please review my investment journey.'
    };

    this.proposalService.requestReview(request).subscribe({
      next: (proposal) => {
        this.snackBar.open('Review request sent to your RM!', 'Close', {
          duration: 3000
        });
      },
      error: (err) => {
        this.snackBar.open('Failed to send review request', 'Close', {
          duration: 3000
        });
      }
    });
  }
}
```

---

## 8. Security Considerations

### 8.1 Role-Based Access Control

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    ENDPOINT AUTHORIZATION                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  /api/v1/rm/proposals/**                                                    │
│  └── @PreAuthorize("hasAuthority('ROLE_RM')")                              │
│      Only RMs can access these endpoints                                    │
│                                                                              │
│  /api/v1/customer/proposals/**                                              │
│  └── @PreAuthorize("hasAuthority('ROLE_USER')")                            │
│      Only Customers can access these endpoints                              │
│                                                                              │
│  /api/v1/notifications/**                                                   │
│  └── No role restriction (both RM and Customer)                            │
│      But user can only see their OWN notifications                         │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 8.2 Data Access Validation

Every API validates that the authenticated user has permission to access the requested resource:

```java
// CustomerProposalController.java
@GetMapping("/{id}")
public ResponseEntity<ProposalDto> getProposalById(@PathVariable Long id, Authentication auth) {
    Long customerId = getCurrentUserId(auth);
    ProposalDto proposal = proposalService.getProposalById(id);

    // Validate customer owns this proposal
    if (!proposal.getCustomerId().equals(customerId)) {
        return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
    }

    return ResponseEntity.ok(proposal);
}
```

### 8.3 Important Security Rules

1. **User ID from JWT**: Never trust user ID from request body. Always extract from JWT token.
2. **Ownership Validation**: Always verify user owns the resource before update/delete.
3. **Role Validation**: Use `@PreAuthorize` at controller level for role checks.
4. **Cross-User Access**: RM can access customer data only for assigned customers.

---

## 9. Troubleshooting

### 9.1 Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| 401 Unauthorized | Invalid/expired JWT | Re-login to get new token |
| 403 Forbidden | Wrong role or not owner | Check endpoint role requirement |
| 404 Not Found | Proposal/Notification deleted | Check `is_deleted` flag |
| 400 Bad Request | Invalid status transition | Check current status before action |

### 9.2 Status Transition Errors

```
"Cannot accept proposal - not in PENDING status"
```

This error occurs when trying to accept/reject a proposal that is not in PENDING status. Check:
1. Has the proposal already been accepted/rejected?
2. Has the proposal expired?
3. Was a newer proposal created (superseded)?

### 9.3 Notification Not Appearing

Check:
1. Is `is_deleted = FALSE` for the notification?
2. Is `user_id` correct in the notification?
3. Is the frontend polling for updates?

### 9.4 Debug Queries

```sql
-- Check proposal status
SELECT id, proposal_type, status, customer_id, rm_id, created_at
FROM proposals
WHERE journey_tracking_id = ?;

-- Check notifications for user
SELECT id, type, title, is_read, created_at
FROM notifications
WHERE user_id = ? AND is_deleted = FALSE
ORDER BY created_at DESC;

-- Check pending proposals for customer
SELECT * FROM proposals
WHERE customer_id = ?
AND proposal_type = 'RM_TO_CUSTOMER'
AND status = 'PENDING'
AND is_deleted = FALSE;
```

---

## Appendix A: File Locations

```
GBS-backend/
├── src/main/
│   ├── java/com/avaloq/gbs/
│   │   ├── model/
│   │   │   ├── Proposal.java
│   │   │   ├── ProposalStatus.java
│   │   │   ├── ProposalType.java
│   │   │   ├── Notification.java
│   │   │   └── NotificationType.java
│   │   ├── repository/
│   │   │   ├── ProposalRepository.java
│   │   │   └── NotificationRepository.java
│   │   ├── service/
│   │   │   ├── ProposalService.java
│   │   │   └── NotificationService.java
│   │   ├── controller/
│   │   │   ├── RmProposalController.java
│   │   │   ├── NotificationController.java
│   │   │   └── customer/
│   │   │       └── CustomerProposalController.java
│   │   └── controller/dto/
│   │       ├── ProposalDto.java
│   │       ├── CreateProposalRequest.java
│   │       ├── CustomerReviewRequest.java
│   │       ├── ProposalActionRequest.java
│   │       └── NotificationDto.java
│   └── resources/db/migration/
│       └── V3__create_proposals_and_notifications_tables.sql
└── docs/
    └── PROPOSAL_WORKFLOW.md (this file)
```

---

## Appendix B: Quick Start Checklist

### For Backend Developers:

- [ ] Run Flyway migration: `mvn flyway:migrate`
- [ ] Verify tables created: `proposals`, `notifications`
- [ ] Test with Swagger UI: `http://localhost:8080/swagger-ui.html`
- [ ] Check logs for `[ProposalService]` and `[NotificationService]` entries

### For Frontend Developers:

- [ ] Create Angular services for proposals and notifications
- [ ] Implement notification bell component
- [ ] Add "Send Proposal" button to RM distribution page
- [ ] Add "Request Review" button to customer distribution page
- [ ] Create proposals list/detail views for both portals
- [ ] Handle notification click navigation

### For QA Testing:

- [ ] Test RM creates proposal → Customer receives notification
- [ ] Test Customer accepts proposal → RM receives notification
- [ ] Test Customer rejects proposal → RM receives notification with reason
- [ ] Test Customer requests review → RM receives notification
- [ ] Test RM approves review → Customer receives notification
- [ ] Test RM rejects review → Customer receives notification
- [ ] Test proposal expiration (set short validity for testing)
- [ ] Test unauthorized access returns 403
- [ ] Test invalid operations return appropriate errors

---

**End of Documentation**
