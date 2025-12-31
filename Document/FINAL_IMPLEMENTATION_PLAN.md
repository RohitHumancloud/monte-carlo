# GBA System - Final Implementation Plan
## Goal-Based Advisory Wealth Management Platform

**Version:** 1.0 Final
**Date:** December 24, 2025
**Status:** Ready for Implementation

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [System Overview](#system-overview)
3. [Technical Stack](#technical-stack)
4. [Confirmed Design Decisions](#confirmed-design-decisions)
5. [Database Architecture](#database-architecture)
6. [API Architecture](#api-architecture)
7. [Frontend Architecture](#frontend-architecture)
8. [Core Features Implementation](#core-features-implementation)
9. [Security & Compliance](#security--compliance)
10. [Implementation Phases](#implementation-phases)

---

## Executive Summary

This document provides the **final, complete implementation plan** for the Goal-Based Advisory (GBA) system for Standard Chartered Bank's wealth management platform. All design decisions have been verified through industry research and confirmed with stakeholders.

### Key Highlights

- **Three Personas**: Super Admin, Relationship Manager (RM), Customer/Client
- **Research-Backed**: All implementations based on 2025 industry standards
- **Regulatory Compliance**: MiFID II, FINRA Rule 2111, SEBI guidelines
- **Modern Technology**: Angular 19, Spring Boot 4.0.0, PostgreSQL
- **Configurable**: Risk/Suitability questionnaires, portfolios, weights

---

## System Overview

### Purpose

Enable Relationship Managers to guide customers through a goal-based investment journey:

1. **Goal Creation** → Define financial objectives
2. **Risk Profiling** → Assess risk tolerance (8-35 score)
3. **Suitability Assessment** → Comprehensive evaluation per MiFID II
4. **Financial Calculation** → Determine corpus and required returns
5. **Portfolio Matching** → Match with appropriate model portfolios
6. **Simulation** → Monte Carlo projection of outcomes
7. **Order Placement** → MFA-protected client approval

### System Components

```
┌─────────────────────────────────────────────────────────────┐
│                     Angular 19 Frontend                      │
│  (Super Admin Portal, RM Portal, Customer Portal - Future)  │
└─────────────────────────────────────────────────────────────┘
                              ↓ ↑
                        REST APIs (JWT)
                              ↓ ↑
┌─────────────────────────────────────────────────────────────┐
│              Spring Boot 4.0.0 Backend (Java 21)            │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │   Risk   │  │Suitability│  │Financial │  │Portfolio │   │
│  │ Profile  │  │Assessment │  │Calculator│  │Matching  │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                 │
│  │  Monte   │  │  Order   │  │ Journey  │                 │
│  │  Carlo   │  │Management│  │ Tracking │                 │
│  └──────────┘  └──────────┘  └──────────┘                 │
└─────────────────────────────────────────────────────────────┘
                              ↓ ↑
┌─────────────────────────────────────────────────────────────┐
│                  PostgreSQL Database                         │
└─────────────────────────────────────────────────────────────┘
```

---

## Technical Stack

### Backend

| Component | Technology | Version | Purpose |
|-----------|-----------|---------|---------|
| **Framework** | Spring Boot | 4.0.0 | Application framework |
| **Language** | Java | 21 | Programming language |
| **Database** | PostgreSQL | 16+ | Relational database |
| **Security** | Spring Security + JWT | 6.x | Authentication/Authorization |
| **ORM** | Spring Data JPA | 3.x | Database access |
| **Mapping** | MapStruct | 1.5.x | DTO mapping |
| **Validation** | Hibernate Validator | 8.x | Input validation |
| **Documentation** | SpringDoc OpenAPI | 2.x | API documentation |
| **Lombok** | Lombok | 1.18.x | Boilerplate reduction |

### Frontend

| Component | Technology | Version | Purpose |
|-----------|-----------|---------|---------|
| **Framework** | Angular | 19 | SPA framework |
| **Language** | TypeScript | 5.7 | Programming language |
| **Styling** | Tailwind CSS | v4 | Utility-first CSS |
| **State Management** | Angular Signals | - | Reactive state |
| **HTTP Client** | HttpClient | - | API communication |
| **Forms** | Reactive Forms | - | Form handling |
| **Routing** | Angular Router | - | Navigation |
| **SSR** | Angular SSR | - | Server-side rendering |

### Development Tools

- **Build**: Maven (Backend), npm (Frontend)
- **Version Control**: Git
- **IDE**: IntelliJ IDEA / VS Code
- **Testing**: JUnit 5, Mockito, Jasmine, Karma
- **Code Quality**: SonarQube, ESLint, Prettier

---

## Confirmed Design Decisions

### Decision 1: Risk Score Weighting System

**Selected Option:** Hybrid Approach (Option C)

**Implementation:**
- Hard-coded default weights in database: `1.0` for all questions
- Super Admin can override specific question weights
- Weight range: `0.5` (minimum) to `2.5` (maximum)
- Formula: `Risk Score = Σ (Question Weight × Selected Answer Points)`

**Database Column:**
```sql
questionnaire_questions.weight NUMERIC(3,2) DEFAULT 1.00 CHECK (weight >= 0.5 AND weight <= 2.5)
```

**Source:** [CFA Institute Investment Risk Profiling Guide](https://rpc.cfainstitute.org/sites/default/files/-/media/documents/survey/investment-risk-profiling.pdf)

---

### Decision 2: Multi-Select Scoring with Maximum Caps

**Selected Option:** Option C (Max Caps)

**Implementation:**
- Scoring Method: **SUM** (add all selected option points)
- Maximum Caps per Question:
  - Default: **8 points**
  - Goal-based questions: **8 points**
  - Experience questions: **6 points**
  - Risk tolerance questions: **10 points**
- If sum exceeds cap → clamp to maximum

**Formula:**
```java
int totalPoints = selectedOptions.stream()
    .mapToInt(Option::getPoints)
    .sum();

int finalScore = Math.min(totalPoints, question.getMaxCapPoints());
```

**Database Columns:**
```sql
questionnaire_questions.scoring_method VARCHAR(20) DEFAULT 'SUM'
questionnaire_questions.max_cap_points INT DEFAULT 8
```

**Source:** Psychometric testing standards, FinaMetrica methodology

---

### Decision 3: Question Descriptions & Notes

**Selected Option:** Option A (Single Description for All)

**Implementation:**
- **Description**: Single text shown to ALL personas (RM + Client)
- **RM Notes**: Guidance/coaching notes shown ONLY to RM
- **Client Notes**: Additional context shown ONLY to Client

**Database Schema:**
```sql
ALTER TABLE questionnaire_questions ADD (
    description TEXT,          -- Shown to all personas
    client_notes TEXT,         -- Shown to clients only
    rm_notes TEXT              -- Shown to RMs only (guidance)
);
```

**UI Behavior:**
- Super Admin enters all three fields during question configuration
- RM sees: Description + RM Notes
- Client sees: Description + Client Notes

---

### Decision 4: Financial Calculator Method

**Selected Option:** Option B (Newton-Raphson Method)

**Implementation:**
- **Algorithm**: Newton-Raphson iterative method for IRR calculation
- **Precision**: 0.01% tolerance (0.0001)
- **Max Iterations**: 100
- **Initial Guess**: 10% annual return

**Java Implementation:**
```java
public double calculateRequiredReturn(
    double targetCorpus,
    double initialInvestment,
    double monthlyInvestment,
    int years
) {
    double r = 0.10; // Initial guess: 10%
    int maxIterations = 100;
    double tolerance = 0.0001;

    for (int i = 0; i < maxIterations; i++) {
        double fv = calculateFutureValue(initialInvestment, monthlyInvestment, years, r);
        double error = fv - targetCorpus;

        if (Math.abs(error) < tolerance) {
            return r * 100; // Convert to percentage
        }

        double derivative = calculateDerivative(initialInvestment, monthlyInvestment, years, r);
        r = r - (error / derivative);
    }

    return r * 100;
}

private double calculateFutureValue(double pv, double pmt, int years, double r) {
    int n = years * 12; // Monthly compounding
    double monthlyRate = r / 12;

    // FV of lump sum
    double fvLumpSum = pv * Math.pow(1 + monthlyRate, n);

    // FV of annuity (SIP)
    double fvAnnuity = pmt * ((Math.pow(1 + monthlyRate, n) - 1) / monthlyRate);

    return fvLumpSum + fvAnnuity;
}

private double calculateDerivative(double pv, double pmt, int years, double r) {
    double h = 0.0001;
    double fv1 = calculateFutureValue(pv, pmt, years, r + h);
    double fv2 = calculateFutureValue(pv, pmt, years, r);
    return (fv1 - fv2) / h;
}
```

**Matching Logic (CONFIRMED):**
```
IF Required Return ≤ Portfolio Max Expected Return:
   ✅ MATCH → Proceed with portfolio

IF Required Return > Portfolio Max Expected Return:
   ❌ NO MATCH → Show suggestions:
      1. Retake risk questionnaire (qualify for higher-risk portfolio)
      2. Increase initial investment or monthly SIP
      3. Extend investment tenure
```

**Example:**
```
Risk Score: 20 → Income Category (17-21)
Suitability: Moderate
Modern Portfolio (Income): Expected Return 10-12%

Case 1: Required Return = 9%
  → 9% < 12% (max) → ✅ MATCH

Case 2: Required Return = 13%
  → 13% > 12% (max) → ❌ NO MATCH → Show suggestions
```

**Sources:**
- [Motilal Oswal Goal Calculator](https://www.motilaloswalmf.com/tools/goal-investment-calculator)
- [Freefincal Goal-Based Portfolio Audit Tool](https://freefincal.com/?p=219221)

---

### Decision 5: User & Role Table Structure

**Selected Option:** Option B (User Table + Role Table)

**Implementation:**
```sql
-- Roles table (master data)
CREATE TABLE roles (
    id BIGSERIAL PRIMARY KEY,
    role_code VARCHAR(20) UNIQUE NOT NULL,
    role_name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert default roles
INSERT INTO roles (role_code, role_name, description) VALUES
('SUPER_ADMIN', 'Super Administrator', 'Full system access and configuration'),
('RM', 'Relationship Manager', 'Manage customers and conduct advisory'),
('CUSTOMER', 'Customer/Client', 'Portfolio owner and investor');

-- Users table (all system users)
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role_id BIGINT NOT NULL REFERENCES roles(id),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20),
    is_active BOOLEAN DEFAULT TRUE,
    is_email_verified BOOLEAN DEFAULT FALSE,
    last_login_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Role-specific profile tables
CREATE TABLE relationship_managers (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    employee_id VARCHAR(50) UNIQUE NOT NULL,
    branch_code VARCHAR(20),
    ic_license_number VARCHAR(50),
    ic_license_expiry DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE customers (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    customer_code VARCHAR(50) UNIQUE NOT NULL,
    rm_id BIGINT REFERENCES relationship_managers(id),
    date_of_birth DATE,
    kyc_status VARCHAR(20) DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Spring Security Integration:**
```java
@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        User user = userRepository.findByEmail(email)
            .orElseThrow(() -> new UsernameNotFoundException("User not found"));

        return org.springframework.security.core.userdetails.User
            .withUsername(user.getEmail())
            .password(user.getPasswordHash())
            .authorities("ROLE_" + user.getRole().getRoleCode())
            .accountLocked(!user.getIsActive())
            .build();
    }
}
```

**Sources:**
- [Spring Security Official Documentation](https://docs.spring.io/spring-security/reference/servlet/appendix/database-schema.html)
- [Baeldung: Roles and Privileges for Spring Security](https://www.baeldung.com/role-and-privilege-for-spring-security-registration)

---

### Decision 6: Customer Portal Access

**Selected Option:** Option A (Deferred to Future Phase)

**Phase 1 Scope:**
- ✅ Super Admin Portal (Configuration)
- ✅ RM Portal (Customer management, advisory process)
- ❌ Customer Portal (Self-service) - Future Phase 2

**Rationale:** Focus on core advisory workflow first

---

### Decision 7: Multi-Bank Deployment

**Selected Option:** Option A (Single Bank Deployment)

**Implementation:**
- No multi-tenancy required
- Single database instance
- Bank-specific branding via configuration
- Model portfolios are bank-configured but not isolated

**Database:** No `bank_id` or tenant isolation needed

---

## Database Architecture

### Complete Schema Overview

The database consists of 25+ tables organized into logical modules:

#### 1. **Authentication & Authorization Module**
- `roles` - User role definitions
- `users` - All system users
- `relationship_managers` - RM-specific profile data
- `customers` - Customer-specific profile data

#### 2. **Questionnaire Configuration Module**
- `questionnaire_types` - Risk Profile vs Suitability
- `questionnaire_questions` - Question library
- `question_options` - Answer choices with points
- `question_dependencies` - Conditional logic

#### 3. **Risk & Suitability Module**
- `risk_score_categories` - Score ranges → Categories
- `customer_risk_profiles` - Customer risk assessments
- `customer_risk_answers` - Question responses
- `customer_suitability_assessments` - Suitability evaluations
- `customer_suitability_answers` - Suitability responses

#### 4. **Portfolio Module**
- `modern_portfolios` - Model portfolio definitions
- `portfolio_asset_allocations` - Asset class allocations
- `portfolio_securities` - Underlying securities
- `portfolio_benchmarks` - Performance benchmarks
- `portfolio_rebalancing_rules` - Rebalancing thresholds

#### 5. **Goal & Financial Planning Module**
- `customer_goals` - Financial objectives
- `goal_financial_calculations` - Corpus & return calculations
- `goal_portfolio_matches` - Matched portfolios

#### 6. **Simulation Module**
- `monte_carlo_simulations` - Simulation runs
- `simulation_scenarios` - Best/Base/Worst outcomes

#### 7. **Order Management Module**
- `orders` - Order master
- `order_items` - Securities in order
- `mfa_approvals` - Client MFA confirmations

#### 8. **Journey Tracking Module**
- `customer_journeys` - Journey master
- `journey_stages` - Stage tracking
- `journey_edit_history` - Audit trail

**Full schema provided in DATABASE_SCHEMA.sql**

---

## API Architecture

### API Design Principles

1. **RESTful**: Resource-based URLs, HTTP methods
2. **Stateless**: JWT token authentication
3. **Versioned**: `/api/v1/...` prefix
4. **Consistent**: Standard response format
5. **Documented**: OpenAPI 3.0 specification

### Standard Response Format

```json
{
  "success": true,
  "message": "Operation successful",
  "data": { },
  "timestamp": "2025-12-24T10:30:00Z"
}
```

```json
{
  "success": false,
  "message": "Validation failed",
  "errors": [
    {
      "field": "email",
      "message": "Email is required"
    }
  ],
  "timestamp": "2025-12-24T10:30:00Z"
}
```

### API Endpoint Categories

#### 1. Authentication & User Management (8 endpoints)
```
POST   /api/v1/auth/register
POST   /api/v1/auth/login
POST   /api/v1/auth/refresh-token
POST   /api/v1/auth/logout
GET    /api/v1/users/profile
PUT    /api/v1/users/profile
POST   /api/v1/users/change-password
GET    /api/v1/users/verify-email/:token
```

#### 2. Super Admin - Questionnaire Configuration (15 endpoints)
```
GET    /api/v1/admin/questionnaire-types
POST   /api/v1/admin/questionnaire-types
PUT    /api/v1/admin/questionnaire-types/:id

GET    /api/v1/admin/questions
POST   /api/v1/admin/questions
PUT    /api/v1/admin/questions/:id
DELETE /api/v1/admin/questions/:id
PUT    /api/v1/admin/questions/:id/weight

GET    /api/v1/admin/questions/:id/options
POST   /api/v1/admin/questions/:id/options
PUT    /api/v1/admin/options/:id
DELETE /api/v1/admin/options/:id

GET    /api/v1/admin/questions/:id/dependencies
POST   /api/v1/admin/questions/:id/dependencies
DELETE /api/v1/admin/dependencies/:id
```

#### 3. Super Admin - Portfolio Configuration (12 endpoints)
```
GET    /api/v1/admin/portfolios
POST   /api/v1/admin/portfolios
PUT    /api/v1/admin/portfolios/:id
DELETE /api/v1/admin/portfolios/:id

GET    /api/v1/admin/portfolios/:id/allocations
POST   /api/v1/admin/portfolios/:id/allocations
PUT    /api/v1/admin/allocations/:id
DELETE /api/v1/admin/allocations/:id

GET    /api/v1/admin/portfolios/:id/securities
POST   /api/v1/admin/portfolios/:id/securities
PUT    /api/v1/admin/securities/:id
DELETE /api/v1/admin/securities/:id
```

#### 4. Super Admin - Risk Categories (5 endpoints)
```
GET    /api/v1/admin/risk-categories
POST   /api/v1/admin/risk-categories
PUT    /api/v1/admin/risk-categories/:id
DELETE /api/v1/admin/risk-categories/:id
GET    /api/v1/admin/risk-categories/validate-ranges
```

#### 5. RM - Customer Management (8 endpoints)
```
GET    /api/v1/rm/customers
POST   /api/v1/rm/customers
GET    /api/v1/rm/customers/:id
PUT    /api/v1/rm/customers/:id
DELETE /api/v1/rm/customers/:id
GET    /api/v1/rm/customers/:id/goals
GET    /api/v1/rm/customers/:id/journey
GET    /api/v1/rm/customers/:id/dashboard
```

#### 6. RM - Goal Management (7 endpoints)
```
GET    /api/v1/rm/goals/:customerId
POST   /api/v1/rm/goals
GET    /api/v1/rm/goals/:id
PUT    /api/v1/rm/goals/:id
DELETE /api/v1/rm/goals/:id
GET    /api/v1/rm/goals/:id/progress
POST   /api/v1/rm/goals/:id/revise
```

#### 7. RM - Risk Profile Assessment (6 endpoints)
```
GET    /api/v1/rm/risk-profile/questions
POST   /api/v1/rm/risk-profile/submit
GET    /api/v1/rm/risk-profile/:customerId/latest
GET    /api/v1/rm/risk-profile/:customerId/history
POST   /api/v1/rm/risk-profile/:id/retake
GET    /api/v1/rm/risk-profile/:id/report
```

#### 8. RM - Suitability Assessment (6 endpoints)
```
GET    /api/v1/rm/suitability/questions
POST   /api/v1/rm/suitability/submit
GET    /api/v1/rm/suitability/:customerId/latest
GET    /api/v1/rm/suitability/:customerId/history
POST   /api/v1/rm/suitability/:id/retake
GET    /api/v1/rm/suitability/:id/report
```

#### 9. RM - Financial Calculator (5 endpoints)
```
POST   /api/v1/rm/calculator/corpus
POST   /api/v1/rm/calculator/required-return
POST   /api/v1/rm/calculator/match-portfolio
GET    /api/v1/rm/calculator/:goalId/calculations
POST   /api/v1/rm/calculator/:goalId/recalculate
```

#### 10. RM - Portfolio Simulation (5 endpoints)
```
POST   /api/v1/rm/simulation/run
GET    /api/v1/rm/simulation/:id/status
GET    /api/v1/rm/simulation/:id/results
GET    /api/v1/rm/simulation/:goalId/history
DELETE /api/v1/rm/simulation/:id
```

#### 11. RM - Order Management (7 endpoints)
```
POST   /api/v1/rm/orders
GET    /api/v1/rm/orders/:id
GET    /api/v1/rm/orders/:customerId/list
PUT    /api/v1/rm/orders/:id/cancel
POST   /api/v1/rm/orders/:id/send-for-approval
GET    /api/v1/rm/orders/:id/mfa-status
GET    /api/v1/rm/orders/:id/confirmation
```

#### 12. Journey Tracking (6 endpoints)
```
GET    /api/v1/journey/:customerId/current
POST   /api/v1/journey/:customerId/start
PUT    /api/v1/journey/:customerId/stage
GET    /api/v1/journey/:customerId/history
POST   /api/v1/journey/:customerId/reset
GET    /api/v1/journey/:customerId/audit-trail
```

**Total: 90+ API endpoints**

**Full specification provided in API_SPECIFICATIONS.md**

---

## Frontend Architecture

### Angular 19 Application Structure

```
frontend/src/app/
├── core/                          # Singleton services, guards, interceptors
│   ├── auth/
│   │   ├── auth.service.ts
│   │   ├── auth.guard.ts
│   │   └── jwt.interceptor.ts
│   ├── models/
│   │   ├── user.model.ts
│   │   ├── customer.model.ts
│   │   ├── goal.model.ts
│   │   └── portfolio.model.ts
│   └── services/
│       ├── api.service.ts
│       └── notification.service.ts
│
├── features/                      # Lazy-loaded feature modules
│   ├── super-admin/
│   │   ├── questionnaire-config/
│   │   ├── portfolio-config/
│   │   └── risk-category-config/
│   ├── rm-portal/
│   │   ├── customer-management/
│   │   ├── goal-management/
│   │   ├── risk-assessment/
│   │   ├── suitability-assessment/
│   │   ├── financial-calculator/
│   │   ├── portfolio-simulation/
│   │   └── order-management/
│   └── customer-portal/           # Future Phase 2
│
├── shared/                        # Reusable components
│   ├── components/
│   │   ├── questionnaire-renderer/
│   │   ├── chart-components/
│   │   ├── data-table/
│   │   └── confirmation-dialog/
│   ├── directives/
│   └── pipes/
│
└── layout/                        # Layout components
    ├── header/
    ├── sidebar/
    └── footer/
```

### State Management Pattern

**Using Angular Signals (Modern Approach)**

```typescript
// risk-assessment.service.ts
import { Injectable, signal, computed } from '@angular/core';

@Injectable({ providedIn: 'root' })
export class RiskAssessmentService {
  private readonly apiService = inject(ApiService);

  // State signals
  readonly questions = signal<Question[]>([]);
  readonly answers = signal<Map<number, Answer>>(new Map());
  readonly loading = signal(false);

  // Computed signals
  readonly currentScore = computed(() => {
    let score = 0;
    this.answers().forEach((answer, questionId) => {
      const question = this.questions().find(q => q.id === questionId);
      const weight = question?.weight ?? 1.0;
      score += answer.points * weight;
    });
    return score;
  });

  readonly category = computed(() => {
    const score = this.currentScore();
    return this.getCategoryForScore(score);
  });

  readonly progress = computed(() => {
    const totalQuestions = this.questions().length;
    const answeredQuestions = this.answers().size;
    return (answeredQuestions / totalQuestions) * 100;
  });

  // Methods
  async loadQuestions(): Promise<void> {
    this.loading.set(true);
    const data = await this.apiService.get<Question[]>('/rm/risk-profile/questions');
    this.questions.set(data);
    this.loading.set(false);
  }

  setAnswer(questionId: number, answer: Answer): void {
    this.answers.update(map => {
      const newMap = new Map(map);
      newMap.set(questionId, answer);
      return newMap;
    });
  }
}
```

### Component Pattern (OnPush + Signals)

```typescript
import { Component, ChangeDetectionStrategy, signal, computed, inject } from '@angular/core';

@Component({
  selector: 'app-risk-assessment',
  imports: [CommonModule, QuestionnaireRendererComponent],
  templateUrl: './risk-assessment.component.html',
  styleUrl: './risk-assessment.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class RiskAssessmentComponent {
  // Services
  private readonly riskService = inject(RiskAssessmentService);

  // Inputs
  readonly customerId = input.required<number>();

  // Outputs
  readonly assessmentComplete = output<RiskProfile>();

  // State
  protected readonly currentQuestionIndex = signal(0);

  // Computed
  protected readonly currentQuestion = computed(() => {
    const index = this.currentQuestionIndex();
    return this.riskService.questions()[index];
  });

  protected readonly canProceed = computed(() => {
    const currentId = this.currentQuestion()?.id;
    return currentId ? this.riskService.answers().has(currentId) : false;
  });

  // Methods
  protected nextQuestion(): void {
    if (this.canProceed()) {
      this.currentQuestionIndex.update(i => i + 1);
    }
  }

  protected async submitAssessment(): Promise<void> {
    const result = await this.riskService.submitAssessment(this.customerId());
    this.assessmentComplete.emit(result);
  }
}
```

### Template Pattern (New Control Flow)

```html
<!-- risk-assessment.component.html -->
<div class="container mx-auto p-6">
  <h1 class="text-3xl font-bold mb-6">Risk Profile Assessment</h1>

  <!-- Progress bar -->
  <div class="w-full bg-gray-200 rounded-full h-2.5 mb-6">
    <div
      class="bg-blue-600 h-2.5 rounded-full transition-all"
      [style.width.%]="riskService.progress()"
    ></div>
  </div>

  <!-- Current question -->
  @if (currentQuestion(); as question) {
    <app-questionnaire-renderer
      [question]="question"
      [answer]="riskService.answers().get(question.id)"
      (answerChange)="riskService.setAnswer(question.id, $event)"
    />

    <!-- Navigation -->
    <div class="flex justify-between mt-6">
      <button
        (click)="currentQuestionIndex.update(i => i - 1)"
        [disabled]="currentQuestionIndex() === 0"
        class="px-6 py-2 bg-gray-300 rounded disabled:opacity-50"
      >
        Previous
      </button>

      @if (currentQuestionIndex() < riskService.questions().length - 1) {
        <button
          (click)="nextQuestion()"
          [disabled]="!canProceed()"
          class="px-6 py-2 bg-blue-600 text-white rounded disabled:opacity-50"
        >
          Next
        </button>
      } @else {
        <button
          (click)="submitAssessment()"
          [disabled]="!canProceed()"
          class="px-6 py-2 bg-green-600 text-white rounded disabled:opacity-50"
        >
          Submit Assessment
        </button>
      }
    </div>
  }

  <!-- Score preview -->
  <div class="mt-6 p-4 bg-blue-50 rounded">
    <p class="text-lg">Current Score: <strong>{{ riskService.currentScore() }}</strong></p>
    <p class="text-lg">Category: <strong>{{ riskService.category() }}</strong></p>
  </div>
</div>
```

**Full component specifications provided in FRONTEND_COMPONENTS.md**

---

## Core Features Implementation

### 1. Dynamic Questionnaire Engine

**Requirements:**
- Render any question type: Single Select, Multi-Select, Text Input, Dropdown, Date, Number
- Support conditional logic (show question if previous answer matches condition)
- Real-time score calculation with weights
- Enforce maximum caps for multi-select questions

**Implementation:**

#### Backend: Question Service

```java
@Service
@RequiredArgsConstructor
public class QuestionnaireService {

    private final QuestionRepository questionRepository;
    private final QuestionDependencyRepository dependencyRepository;

    public List<QuestionDTO> getQuestionsForType(String questionnaireType) {
        List<Question> questions = questionRepository
            .findByQuestionnaireTypeCodeAndIsActiveTrue(questionnaireType);

        return questions.stream()
            .map(this::toDTO)
            .sorted(Comparator.comparing(QuestionDTO::getDisplayOrder))
            .collect(Collectors.toList());
    }

    public int calculateScore(List<AnswerSubmission> answers) {
        int totalScore = 0;

        for (AnswerSubmission answer : answers) {
            Question question = questionRepository.findById(answer.getQuestionId())
                .orElseThrow(() -> new NotFoundException("Question not found"));

            int questionScore = 0;

            if (question.getQuestionType().equals("MULTI_SELECT")) {
                // Sum all selected option points
                for (Long optionId : answer.getSelectedOptionIds()) {
                    QuestionOption option = question.getOptions().stream()
                        .filter(o -> o.getId().equals(optionId))
                        .findFirst()
                        .orElseThrow(() -> new NotFoundException("Option not found"));

                    questionScore += option.getPoints();
                }

                // Apply maximum cap
                questionScore = Math.min(questionScore, question.getMaxCapPoints());
            } else {
                // Single select or other types
                QuestionOption selectedOption = question.getOptions().stream()
                    .filter(o -> o.getId().equals(answer.getSelectedOptionIds().get(0)))
                    .findFirst()
                    .orElseThrow(() -> new NotFoundException("Option not found"));

                questionScore = selectedOption.getPoints();
            }

            // Apply weight
            double weight = question.getWeight() != null ? question.getWeight() : 1.0;
            totalScore += (int) Math.round(questionScore * weight);
        }

        return totalScore;
    }

    public List<QuestionDTO> filterByDependencies(
        List<QuestionDTO> allQuestions,
        Map<Long, List<Long>> previousAnswers
    ) {
        return allQuestions.stream()
            .filter(q -> shouldShowQuestion(q, previousAnswers))
            .collect(Collectors.toList());
    }

    private boolean shouldShowQuestion(
        QuestionDTO question,
        Map<Long, List<Long>> previousAnswers
    ) {
        if (question.getDependencies().isEmpty()) {
            return true; // No dependencies, always show
        }

        for (QuestionDependency dep : question.getDependencies()) {
            List<Long> selectedOptions = previousAnswers.get(dep.getDependsOnQuestionId());

            if (selectedOptions == null || selectedOptions.isEmpty()) {
                return false; // Dependent question not answered
            }

            if (!selectedOptions.contains(dep.getRequiredOptionId())) {
                return false; // Required option not selected
            }
        }

        return true; // All dependencies satisfied
    }
}
```

#### Frontend: Questionnaire Renderer Component

```typescript
@Component({
  selector: 'app-questionnaire-renderer',
  imports: [CommonModule, ReactiveFormsModule],
  template: `
    <div class="question-container p-6 bg-white rounded-lg shadow">
      <h3 class="text-xl font-semibold mb-2">{{ question().questionText }}</h3>

      @if (question().description) {
        <p class="text-gray-600 mb-4">{{ question().description }}</p>
      }

      @if (showNotes()) {
        <div class="bg-blue-50 p-3 rounded mb-4">
          <p class="text-sm text-blue-800">{{ notes() }}</p>
        </div>
      }

      @switch (question().questionType) {
        @case ('SINGLE_SELECT') {
          <div class="space-y-2">
            @for (option of question().options; track option.id) {
              <label class="flex items-center p-3 border rounded hover:bg-gray-50 cursor-pointer">
                <input
                  type="radio"
                  [name]="'question-' + question().id"
                  [value]="option.id"
                  (change)="selectSingleOption(option.id)"
                  class="mr-3"
                />
                <span>{{ option.optionText }}</span>
                @if (showPoints()) {
                  <span class="ml-auto text-sm text-gray-500">({{ option.points }} pts)</span>
                }
              </label>
            }
          </div>
        }

        @case ('MULTI_SELECT') {
          <div class="space-y-2">
            @for (option of question().options; track option.id) {
              <label class="flex items-center p-3 border rounded hover:bg-gray-50 cursor-pointer">
                <input
                  type="checkbox"
                  [value]="option.id"
                  (change)="toggleMultiOption(option.id)"
                  [disabled]="isMaxCapReached() && !isOptionSelected(option.id)"
                  class="mr-3"
                />
                <span>{{ option.optionText }}</span>
                @if (showPoints()) {
                  <span class="ml-auto text-sm text-gray-500">({{ option.points }} pts)</span>
                }
              </label>
            }
            @if (isMaxCapReached()) {
              <p class="text-sm text-orange-600">
                Maximum {{ question().maxCapPoints }} points reached
              </p>
            }
          </div>
        }

        @case ('TEXT_INPUT') {
          <input
            type="text"
            (input)="setTextAnswer($event)"
            class="w-full p-3 border rounded"
            [placeholder]="question().placeholder"
          />
        }

        @case ('NUMBER_INPUT') {
          <input
            type="number"
            (input)="setNumberAnswer($event)"
            class="w-full p-3 border rounded"
            [placeholder]="question().placeholder"
          />
        }

        @case ('DROPDOWN') {
          <select
            (change)="selectFromDropdown($event)"
            class="w-full p-3 border rounded"
          >
            <option value="">Select an option</option>
            @for (option of question().options; track option.id) {
              <option [value]="option.id">{{ option.optionText }}</option>
            }
          </select>
        }
      }
    </div>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class QuestionnaireRendererComponent {
  readonly question = input.required<Question>();
  readonly userRole = input<string>('RM');
  readonly showPoints = input<boolean>(false);

  readonly answerChange = output<Answer>();

  protected readonly selectedOptions = signal<Set<number>>(new Set());
  protected readonly textAnswer = signal<string>('');

  protected readonly showNotes = computed(() => {
    return this.question().clientNotes || this.question().rmNotes;
  });

  protected readonly notes = computed(() => {
    return this.userRole() === 'CUSTOMER'
      ? this.question().clientNotes
      : this.question().rmNotes;
  });

  protected readonly currentPoints = computed(() => {
    const selected = this.selectedOptions();
    return Array.from(selected).reduce((sum, optionId) => {
      const option = this.question().options.find(o => o.id === optionId);
      return sum + (option?.points ?? 0);
    }, 0);
  });

  protected readonly isMaxCapReached = computed(() => {
    return this.currentPoints() >= this.question().maxCapPoints;
  });

  protected isOptionSelected(optionId: number): boolean {
    return this.selectedOptions().has(optionId);
  }

  protected selectSingleOption(optionId: number): void {
    const option = this.question().options.find(o => o.id === optionId);
    this.answerChange.emit({
      questionId: this.question().id,
      selectedOptionIds: [optionId],
      points: option?.points ?? 0
    });
  }

  protected toggleMultiOption(optionId: number): void {
    this.selectedOptions.update(set => {
      const newSet = new Set(set);
      if (newSet.has(optionId)) {
        newSet.delete(optionId);
      } else {
        newSet.add(optionId);
      }
      return newSet;
    });

    this.answerChange.emit({
      questionId: this.question().id,
      selectedOptionIds: Array.from(this.selectedOptions()),
      points: Math.min(this.currentPoints(), this.question().maxCapPoints)
    });
  }

  protected setTextAnswer(event: Event): void {
    const value = (event.target as HTMLInputElement).value;
    this.textAnswer.set(value);
    this.answerChange.emit({
      questionId: this.question().id,
      textAnswer: value,
      points: 0
    });
  }
}
```

---

### 2. Financial Calculator with Portfolio Matching

**Requirements:**
- Step 1: Calculate target corpus (inflation-adjusted)
- Step 2: Calculate required return rate (Newton-Raphson)
- Match required return with portfolio expected returns
- Show match status and suggestions

**Implementation:**

#### Backend: Financial Calculator Service

```java
@Service
@Slf4j
public class FinancialCalculatorService {

    private static final double NEWTON_RAPHSON_TOLERANCE = 0.0001;
    private static final int MAX_ITERATIONS = 100;
    private static final double INITIAL_GUESS = 0.10; // 10%

    /**
     * Step 1: Calculate inflation-adjusted target corpus
     */
    public CorpusCalculationResult calculateTargetCorpus(CorpusCalculationRequest request) {
        // Future value calculation
        double fv = request.getGoalAmount() *
            Math.pow(1 + request.getInflationRate(), request.getYears());

        // Tax-adjusted if applicable
        if (request.getTaxRate() != null && request.getTaxRate() > 0) {
            double gains = fv - request.getGoalAmount();
            double taxAdjustedGains = gains * (1 - request.getTaxRate());
            fv = request.getGoalAmount() + taxAdjustedGains;
        }

        return CorpusCalculationResult.builder()
            .targetCorpus(fv)
            .currentAmount(request.getGoalAmount())
            .inflationRate(request.getInflationRate())
            .years(request.getYears())
            .build();
    }

    /**
     * Step 2: Calculate required return rate using Newton-Raphson method
     */
    public RequiredReturnResult calculateRequiredReturn(RequiredReturnRequest request) {
        double targetCorpus = request.getTargetCorpus();
        double initialInvestment = request.getInitialInvestment();
        double monthlyInvestment = request.getMonthlySIP();
        int years = request.getYears();

        double requiredReturn = newtonRaphsonIRR(
            targetCorpus,
            initialInvestment,
            monthlyInvestment,
            years
        );

        return RequiredReturnResult.builder()
            .requiredReturnPercentage(requiredReturn)
            .targetCorpus(targetCorpus)
            .initialInvestment(initialInvestment)
            .monthlyInvestment(monthlyInvestment)
            .years(years)
            .iterations(getLastIterationCount())
            .build();
    }

    /**
     * Newton-Raphson method for IRR calculation
     */
    private double newtonRaphsonIRR(
        double targetCorpus,
        double pv,
        double pmt,
        int years
    ) {
        double r = INITIAL_GUESS;
        int iterations = 0;

        for (int i = 0; i < MAX_ITERATIONS; i++) {
            iterations++;

            double fv = calculateFutureValue(pv, pmt, years, r);
            double error = fv - targetCorpus;

            if (Math.abs(error) < NEWTON_RAPHSON_TOLERANCE) {
                log.debug("Converged in {} iterations", iterations);
                return r * 100; // Convert to percentage
            }

            double derivative = calculateDerivative(pv, pmt, years, r);

            if (Math.abs(derivative) < 1e-10) {
                log.warn("Derivative too small, using fallback");
                break;
            }

            r = r - (error / derivative);

            // Ensure r stays within reasonable bounds
            r = Math.max(0.001, Math.min(r, 0.50)); // 0.1% to 50%
        }

        log.warn("Did not converge after {} iterations", iterations);
        return r * 100;
    }

    private double calculateFutureValue(double pv, double pmt, int years, double r) {
        int n = years * 12; // Monthly compounding
        double monthlyRate = r / 12;

        if (Math.abs(monthlyRate) < 1e-10) {
            // Handle edge case: rate ≈ 0
            return pv + (pmt * n);
        }

        // FV of lump sum
        double fvLumpSum = pv * Math.pow(1 + monthlyRate, n);

        // FV of annuity (SIP)
        double fvAnnuity = pmt * ((Math.pow(1 + monthlyRate, n) - 1) / monthlyRate);

        return fvLumpSum + fvAnnuity;
    }

    private double calculateDerivative(double pv, double pmt, int years, double r) {
        double h = 0.0001;
        double fv1 = calculateFutureValue(pv, pmt, years, r + h);
        double fv2 = calculateFutureValue(pv, pmt, years, r);
        return (fv1 - fv2) / h;
    }

    /**
     * Match required return with suitable portfolios
     */
    public PortfolioMatchResult matchPortfolio(PortfolioMatchRequest request) {
        double requiredReturn = request.getRequiredReturnPercentage();
        int riskScore = request.getRiskScore();
        String suitability = request.getSuitability();

        // Get risk category for score
        RiskScoreCategory category = getCategoryForScore(riskScore);

        // Find portfolios matching risk category and suitability
        List<ModernPortfolio> eligiblePortfolios = portfolioRepository
            .findByRiskCategoryAndSuitability(category.getCode(), suitability);

        // Filter portfolios where required return is achievable
        List<PortfolioMatch> matches = eligiblePortfolios.stream()
            .map(portfolio -> {
                boolean isMatch = requiredReturn <= portfolio.getExpectedReturnMax();
                return PortfolioMatch.builder()
                    .portfolio(portfolio)
                    .isMatch(isMatch)
                    .requiredReturn(requiredReturn)
                    .portfolioReturnMin(portfolio.getExpectedReturnMin())
                    .portfolioReturnMax(portfolio.getExpectedReturnMax())
                    .gap(isMatch ? 0 : requiredReturn - portfolio.getExpectedReturnMax())
                    .build();
            })
            .sorted(Comparator.comparing(PortfolioMatch::isMatch).reversed()
                .thenComparing(m -> Math.abs(m.getRequiredReturn() - m.getPortfolioReturnMax())))
            .collect(Collectors.toList());

        if (matches.isEmpty()) {
            return PortfolioMatchResult.builder()
                .hasMatch(false)
                .message("No portfolios found for risk category: " + category.getName())
                .suggestions(generateSuggestions(requiredReturn, riskScore, category))
                .build();
        }

        PortfolioMatch bestMatch = matches.get(0);

        if (!bestMatch.isMatch()) {
            return PortfolioMatchResult.builder()
                .hasMatch(false)
                .message("Required return exceeds portfolio capabilities")
                .closestPortfolio(bestMatch.getPortfolio())
                .gap(bestMatch.getGap())
                .suggestions(generateSuggestions(requiredReturn, riskScore, category))
                .build();
        }

        return PortfolioMatchResult.builder()
            .hasMatch(true)
            .message("Portfolio match found")
            .matchedPortfolio(bestMatch.getPortfolio())
            .allMatches(matches.stream().filter(PortfolioMatch::isMatch).collect(Collectors.toList()))
            .build();
    }

    private List<String> generateSuggestions(
        double requiredReturn,
        int riskScore,
        RiskScoreCategory category
    ) {
        List<String> suggestions = new ArrayList<>();

        // Suggestion 1: Retake risk questionnaire
        if (category.getMaxScore() < 35) {
            suggestions.add("Retake risk questionnaire to qualify for higher-risk portfolios with better returns");
        }

        // Suggestion 2: Increase investment amount
        suggestions.add("Increase initial investment or monthly SIP to reduce required return rate");

        // Suggestion 3: Extend tenure
        suggestions.add("Extend investment tenure to allow more time for growth");

        // Suggestion 4: Adjust expectations
        suggestions.add("Revise goal amount to align with achievable portfolio returns");

        return suggestions;
    }
}
```

---

### 3. Monte Carlo Simulation

**Requirements:**
- Run 10,000+ simulations
- Generate Best/Base/Worst case scenarios
- Confidence intervals (10th, 50th, 90th percentiles)
- Chart data for visualization

**Implementation:**

#### Backend: Monte Carlo Service

```java
@Service
@Slf4j
public class MonteCarloSimulationService {

    private static final int DEFAULT_SIMULATIONS = 10000;
    private static final Random random = new Random();

    @Autowired
    private SimulationRepository simulationRepository;

    /**
     * Run Monte Carlo simulation
     */
    public MonteCarloResult runSimulation(SimulationRequest request) {
        log.info("Running Monte Carlo simulation with {} iterations", DEFAULT_SIMULATIONS);

        double initialInvestment = request.getInitialInvestment();
        double monthlyInvestment = request.getMonthlySIP();
        int years = request.getYears();
        double expectedReturn = request.getExpectedReturnPercentage() / 100;
        double volatility = request.getVolatilityPercentage() / 100;

        List<Double> finalValues = new ArrayList<>(DEFAULT_SIMULATIONS);

        for (int sim = 0; sim < DEFAULT_SIMULATIONS; sim++) {
            double portfolioValue = initialInvestment;

            for (int month = 1; month <= years * 12; month++) {
                // Generate monthly return using normal distribution
                double monthlyReturn = generateRandomReturn(expectedReturn / 12, volatility / Math.sqrt(12));

                // Apply return to current portfolio
                portfolioValue *= (1 + monthlyReturn);

                // Add monthly SIP
                portfolioValue += monthlyInvestment;
            }

            finalValues.add(portfolioValue);
        }

        // Sort for percentile calculation
        Collections.sort(finalValues);

        // Calculate percentiles
        double worstCase = percentile(finalValues, 10);  // 10th percentile
        double baseCase = percentile(finalValues, 50);   // 50th percentile (median)
        double bestCase = percentile(finalValues, 90);   // 90th percentile

        // Save simulation
        MonteCarloSimulation simulation = MonteCarloSimulation.builder()
            .goalId(request.getGoalId())
            .portfolioId(request.getPortfolioId())
            .initialInvestment(initialInvestment)
            .monthlyInvestment(monthlyInvestment)
            .years(years)
            .expectedReturn(request.getExpectedReturnPercentage())
            .volatility(request.getVolatilityPercentage())
            .iterations(DEFAULT_SIMULATIONS)
            .worstCase(worstCase)
            .baseCase(baseCase)
            .bestCase(bestCase)
            .status("COMPLETED")
            .build();

        simulation = simulationRepository.save(simulation);

        // Generate chart data (monthly projections)
        List<MonthlyProjection> chartData = generateChartData(
            initialInvestment,
            monthlyInvestment,
            years,
            expectedReturn,
            volatility
        );

        return MonteCarloResult.builder()
            .simulationId(simulation.getId())
            .worstCase(worstCase)
            .baseCase(baseCase)
            .bestCase(bestCase)
            .targetCorpus(request.getTargetCorpus())
            .probabilityOfSuccess(calculateProbabilityOfSuccess(finalValues, request.getTargetCorpus()))
            .chartData(chartData)
            .build();
    }

    private double generateRandomReturn(double mean, double stdDev) {
        // Box-Muller transform for normal distribution
        double u1 = random.nextDouble();
        double u2 = random.nextDouble();
        double z = Math.sqrt(-2 * Math.log(u1)) * Math.cos(2 * Math.PI * u2);
        return mean + (z * stdDev);
    }

    private double percentile(List<Double> sortedValues, int percentile) {
        int index = (int) Math.ceil((percentile / 100.0) * sortedValues.size()) - 1;
        return sortedValues.get(Math.max(0, index));
    }

    private double calculateProbabilityOfSuccess(List<Double> finalValues, double targetCorpus) {
        long successfulSimulations = finalValues.stream()
            .filter(value -> value >= targetCorpus)
            .count();
        return (successfulSimulations * 100.0) / finalValues.size();
    }

    private List<MonthlyProjection> generateChartData(
        double initial,
        double sip,
        int years,
        double expectedReturn,
        double volatility
    ) {
        List<MonthlyProjection> projections = new ArrayList<>();

        // Run 100 sample paths for chart
        List<List<Double>> samplePaths = new ArrayList<>();

        for (int i = 0; i < 100; i++) {
            List<Double> path = new ArrayList<>();
            double value = initial;

            for (int month = 0; month <= years * 12; month++) {
                path.add(value);

                if (month < years * 12) {
                    double monthlyReturn = generateRandomReturn(expectedReturn / 12, volatility / Math.sqrt(12));
                    value = value * (1 + monthlyReturn) + sip;
                }
            }

            samplePaths.add(path);
        }

        // Calculate percentiles for each month
        for (int month = 0; month <= years * 12; month++) {
            final int m = month;
            List<Double> monthValues = samplePaths.stream()
                .map(path -> path.get(m))
                .sorted()
                .collect(Collectors.toList());

            projections.add(MonthlyProjection.builder()
                .month(month)
                .worstCase(percentile(monthValues, 10))
                .baseCase(percentile(monthValues, 50))
                .bestCase(percentile(monthValues, 90))
                .build());
        }

        return projections;
    }
}
```

#### Frontend: Simulation Chart Component

```typescript
@Component({
  selector: 'app-simulation-chart',
  imports: [CommonModule],
  template: `
    <div class="chart-container bg-white p-6 rounded-lg shadow">
      <h3 class="text-2xl font-bold mb-4">Monte Carlo Simulation Results</h3>

      <!-- Scenario Cards -->
      <div class="grid grid-cols-3 gap-4 mb-6">
        <div class="p-4 bg-red-50 rounded">
          <p class="text-sm text-gray-600">Worst Case (10th %ile)</p>
          <p class="text-2xl font-bold text-red-600">{{ formatCurrency(result().worstCase) }}</p>
        </div>
        <div class="p-4 bg-blue-50 rounded">
          <p class="text-sm text-gray-600">Base Case (50th %ile)</p>
          <p class="text-2xl font-bold text-blue-600">{{ formatCurrency(result().baseCase) }}</p>
        </div>
        <div class="p-4 bg-green-50 rounded">
          <p class="text-sm text-gray-600">Best Case (90th %ile)</p>
          <p class="text-2xl font-bold text-green-600">{{ formatCurrency(result().bestCase) }}</p>
        </div>
      </div>

      <!-- Success Probability -->
      <div class="mb-6 p-4 rounded" [class]="getProbabilityClass()">
        <p class="text-lg">
          Probability of achieving target:
          <strong>{{ result().probabilityOfSuccess }}%</strong>
        </p>
      </div>

      <!-- Chart (using Chart.js or similar) -->
      <canvas #chartCanvas></canvas>
    </div>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class SimulationChartComponent implements AfterViewInit {
  @ViewChild('chartCanvas') chartCanvas!: ElementRef<HTMLCanvasElement>;

  readonly result = input.required<MonteCarloResult>();

  private chart?: Chart;

  ngAfterViewInit(): void {
    this.renderChart();
  }

  protected formatCurrency(value: number): string {
    return new Intl.NumberFormat('en-IN', {
      style: 'currency',
      currency: 'INR',
      maximumFractionDigits: 0
    }).format(value);
  }

  protected getProbabilityClass(): string {
    const prob = this.result().probabilityOfSuccess;
    if (prob >= 80) return 'bg-green-100 text-green-800';
    if (prob >= 60) return 'bg-yellow-100 text-yellow-800';
    return 'bg-red-100 text-red-800';
  }

  private renderChart(): void {
    const ctx = this.chartCanvas.nativeElement.getContext('2d');
    if (!ctx) return;

    const chartData = this.result().chartData;
    const months = chartData.map(d => d.month);

    this.chart = new Chart(ctx, {
      type: 'line',
      data: {
        labels: months,
        datasets: [
          {
            label: 'Best Case',
            data: chartData.map(d => d.bestCase),
            borderColor: 'rgb(34, 197, 94)',
            backgroundColor: 'rgba(34, 197, 94, 0.1)',
            fill: false,
          },
          {
            label: 'Base Case',
            data: chartData.map(d => d.baseCase),
            borderColor: 'rgb(59, 130, 246)',
            backgroundColor: 'rgba(59, 130, 246, 0.1)',
            fill: false,
            borderWidth: 3,
          },
          {
            label: 'Worst Case',
            data: chartData.map(d => d.worstCase),
            borderColor: 'rgb(239, 68, 68)',
            backgroundColor: 'rgba(239, 68, 68, 0.1)',
            fill: false,
          },
          {
            label: 'Target',
            data: Array(chartData.length).fill(this.result().targetCorpus),
            borderColor: 'rgb(147, 51, 234)',
            borderDash: [10, 5],
            fill: false,
          }
        ]
      },
      options: {
        responsive: true,
        plugins: {
          title: {
            display: true,
            text: 'Portfolio Value Projection Over Time'
          },
          legend: {
            display: true,
            position: 'top',
          }
        },
        scales: {
          x: {
            title: {
              display: true,
              text: 'Month'
            }
          },
          y: {
            title: {
              display: true,
              text: 'Portfolio Value (₹)'
            },
            ticks: {
              callback: (value) => this.formatCurrency(value as number)
            }
          }
        }
      }
    });
  }
}
```

---

### 4. Journey Tracking System

**Requirements:**
- Track customer progress through 8 stages
- Record page navigation within stages
- Store edit history for audit trail
- Track attempt counts (e.g., retake questionnaire)

**Implementation:**

#### Backend: Journey Service

```java
@Service
@RequiredArgsConstructor
public class JourneyTrackingService {

    private final JourneyRepository journeyRepository;
    private final JourneyStageRepository stageRepository;
    private final JourneyEditHistoryRepository historyRepository;

    /**
     * Initialize journey for new customer
     */
    public CustomerJourney initializeJourney(Long customerId) {
        CustomerJourney journey = CustomerJourney.builder()
            .customerId(customerId)
            .currentStage("GOAL_CREATION")
            .status("IN_PROGRESS")
            .build();

        journey = journeyRepository.save(journey);

        // Create initial stage
        createStageRecord(journey.getId(), "GOAL_CREATION", 1);

        return journey;
    }

    /**
     * Update journey stage
     */
    public void updateStage(Long customerId, String newStage) {
        CustomerJourney journey = journeyRepository.findByCustomerId(customerId)
            .orElseThrow(() -> new NotFoundException("Journey not found"));

        String previousStage = journey.getCurrentStage();

        // Complete previous stage
        JourneyStage previousStageRecord = stageRepository
            .findTopByJourneyIdAndStageNameOrderByAttemptNumberDesc(journey.getId(), previousStage)
            .orElseThrow(() -> new NotFoundException("Stage not found"));

        previousStageRecord.setCompletedAt(LocalDateTime.now());
        previousStageRecord.setStatus("COMPLETED");
        stageRepository.save(previousStageRecord);

        // Update journey
        journey.setCurrentStage(newStage);
        journey.setUpdatedAt(LocalDateTime.now());
        journeyRepository.save(journey);

        // Create new stage record
        createStageRecord(journey.getId(), newStage, 1);

        // Log history
        logEditHistory(journey.getId(), "STAGE_CHANGE",
            "Changed from " + previousStage + " to " + newStage, null);
    }

    /**
     * Track page navigation within stage
     */
    public void trackPageNavigation(Long customerId, String pageName) {
        CustomerJourney journey = journeyRepository.findByCustomerId(customerId)
            .orElseThrow(() -> new NotFoundException("Journey not found"));

        JourneyStage currentStage = stageRepository
            .findTopByJourneyIdAndStageNameOrderByAttemptNumberDesc(
                journey.getId(),
                journey.getCurrentStage()
            )
            .orElseThrow(() -> new NotFoundException("Stage not found"));

        currentStage.setCurrentPage(pageName);
        currentStage.setUpdatedAt(LocalDateTime.now());
        stageRepository.save(currentStage);
    }

    /**
     * Log edit/revision
     */
    public void logEdit(Long customerId, String entityType, String action, String details) {
        CustomerJourney journey = journeyRepository.findByCustomerId(customerId)
            .orElseThrow(() -> new NotFoundException("Journey not found"));

        logEditHistory(journey.getId(), entityType, action, details);
    }

    /**
     * Retake assessment (increment attempt)
     */
    public void retakeStage(Long customerId, String stageName) {
        CustomerJourney journey = journeyRepository.findByCustomerId(customerId)
            .orElseThrow(() -> new NotFoundException("Journey not found"));

        // Get max attempt number for this stage
        int maxAttempt = stageRepository
            .findTopByJourneyIdAndStageNameOrderByAttemptNumberDesc(journey.getId(), stageName)
            .map(JourneyStage::getAttemptNumber)
            .orElse(0);

        // Create new attempt
        createStageRecord(journey.getId(), stageName, maxAttempt + 1);

        // Update journey
        journey.setCurrentStage(stageName);
        journey.setUpdatedAt(LocalDateTime.now());
        journeyRepository.save(journey);

        logEditHistory(journey.getId(), "RETAKE", "Retaking " + stageName, null);
    }

    private void createStageRecord(Long journeyId, String stageName, int attemptNumber) {
        JourneyStage stage = JourneyStage.builder()
            .journeyId(journeyId)
            .stageName(stageName)
            .attemptNumber(attemptNumber)
            .status("IN_PROGRESS")
            .build();

        stageRepository.save(stage);
    }

    private void logEditHistory(Long journeyId, String entityType, String action, String details) {
        JourneyEditHistory history = JourneyEditHistory.builder()
            .journeyId(journeyId)
            .entityType(entityType)
            .action(action)
            .details(details)
            .build();

        historyRepository.save(history);
    }

    /**
     * Get complete journey history
     */
    public JourneyHistoryDTO getJourneyHistory(Long customerId) {
        CustomerJourney journey = journeyRepository.findByCustomerId(customerId)
            .orElseThrow(() -> new NotFoundException("Journey not found"));

        List<JourneyStage> stages = stageRepository.findByJourneyIdOrderByCreatedAtAsc(journey.getId());
        List<JourneyEditHistory> history = historyRepository.findByJourneyIdOrderByCreatedAtAsc(journey.getId());

        return JourneyHistoryDTO.builder()
            .journey(journey)
            .stages(stages)
            .editHistory(history)
            .build();
    }
}
```

---

## Security & Compliance

### 1. Authentication & Authorization

**JWT-Based Authentication:**

```java
@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {

    @Autowired
    private CustomUserDetailsService userDetailsService;

    @Autowired
    private JwtAuthenticationFilter jwtAuthFilter;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/v1/auth/**").permitAll()
                .requestMatchers("/api/v1/admin/**").hasRole("SUPER_ADMIN")
                .requestMatchers("/api/v1/rm/**").hasAnyRole("SUPER_ADMIN", "RM")
                .requestMatchers("/api/v1/customer/**").hasAnyRole("SUPER_ADMIN", "RM", "CUSTOMER")
                .anyRequest().authenticated()
            )
            .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            )
            .authenticationProvider(authenticationProvider())
            .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    public AuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
        provider.setUserDetailsService(userDetailsService);
        provider.setPasswordEncoder(passwordEncoder());
        return provider;
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(12);
    }
}
```

### 2. Role-Based Access Control

```java
// Controller example
@RestController
@RequestMapping("/api/v1/admin")
@PreAuthorize("hasRole('SUPER_ADMIN')")
public class AdminController {

    @PostMapping("/portfolios")
    public ResponseEntity<PortfolioDTO> createPortfolio(@Valid @RequestBody CreatePortfolioRequest request) {
        // Only Super Admin can create portfolios
    }
}

@RestController
@RequestMapping("/api/v1/rm")
@PreAuthorize("hasAnyRole('RM', 'SUPER_ADMIN')")
public class RMController {

    @PostMapping("/customers")
    public ResponseEntity<CustomerDTO> createCustomer(@Valid @RequestBody CreateCustomerRequest request) {
        // RM and Super Admin can create customers
    }

    @GetMapping("/customers/{id}")
    @PreAuthorize("@securityService.canAccessCustomer(#id)")
    public ResponseEntity<CustomerDTO> getCustomer(@PathVariable Long id) {
        // RM can only access their own customers
    }
}
```

### 3. Data Validation

```java
public class CreateGoalRequest {

    @NotBlank(message = "Goal name is required")
    @Size(min = 3, max = 100, message = "Goal name must be 3-100 characters")
    private String goalName;

    @NotNull(message = "Goal amount is required")
    @Positive(message = "Goal amount must be positive")
    @DecimalMin(value = "10000", message = "Minimum goal amount is ₹10,000")
    private BigDecimal targetAmount;

    @NotNull(message = "Target date is required")
    @Future(message = "Target date must be in the future")
    private LocalDate targetDate;

    @NotNull(message = "Initial investment is required")
    @PositiveOrZero(message = "Initial investment cannot be negative")
    private BigDecimal initialInvestment;

    @NotNull(message = "Monthly SIP is required")
    @PositiveOrZero(message = "Monthly SIP cannot be negative")
    private BigDecimal monthlyInvestment;

    @AssertTrue(message = "Either initial investment or monthly SIP must be greater than zero")
    public boolean isValidInvestment() {
        return initialInvestment.compareTo(BigDecimal.ZERO) > 0
            || monthlyInvestment.compareTo(BigDecimal.ZERO) > 0;
    }
}
```

### 4. Compliance Requirements

**MiFID II & FINRA Compliance:**
- ✅ Comprehensive suitability assessment
- ✅ Risk tolerance evaluation
- ✅ Investment experience tracking
- ✅ Complete audit trail
- ✅ Client approval with MFA

**SEBI Guidelines:**
- ✅ Risk profiling questionnaire
- ✅ Investment risk disclosure
- ✅ Portfolio suitability matching
- ✅ Regular review and rebalancing

**Data Protection:**
- ✅ Password encryption (BCrypt)
- ✅ JWT token-based authentication
- ✅ Role-based access control
- ✅ Audit logging for all transactions

---

## Implementation Phases

### Phase 1: Foundation (Weeks 1-2)

**Backend:**
- [ ] Setup Spring Boot project structure
- [ ] Configure PostgreSQL database
- [ ] Implement authentication & authorization
- [ ] Create base entities and repositories
- [ ] Setup API response standards

**Frontend:**
- [ ] Setup Angular 19 project
- [ ] Configure Tailwind CSS v4
- [ ] Implement routing structure
- [ ] Create authentication flow
- [ ] Setup HTTP interceptors

### Phase 2: Super Admin Portal (Weeks 3-4)

**Backend:**
- [ ] Questionnaire configuration APIs
- [ ] Portfolio configuration APIs
- [ ] Risk category management APIs

**Frontend:**
- [ ] Question builder interface
- [ ] Portfolio configuration forms
- [ ] Weight management UI
- [ ] Preview functionality

### Phase 3: Risk & Suitability (Weeks 5-6)

**Backend:**
- [ ] Dynamic questionnaire engine
- [ ] Scoring calculation with weights
- [ ] Multi-select capping logic
- [ ] Conditional question logic
- [ ] Report generation

**Frontend:**
- [ ] Questionnaire renderer component
- [ ] Progress tracking
- [ ] Score preview
- [ ] Result display

### Phase 4: Financial Calculator & Matching (Weeks 7-8)

**Backend:**
- [ ] Newton-Raphson IRR calculation
- [ ] Corpus calculation
- [ ] Portfolio matching logic
- [ ] Suggestion engine

**Frontend:**
- [ ] Calculator interfaces
- [ ] Matching results display
- [ ] Suggestion cards
- [ ] Recalculation flows

### Phase 5: Simulation & Orders (Weeks 9-10)

**Backend:**
- [ ] Monte Carlo simulation engine
- [ ] Scenario generation
- [ ] Order management
- [ ] MFA integration

**Frontend:**
- [ ] Simulation visualization
- [ ] Chart components
- [ ] Order placement flow
- [ ] MFA approval UI

### Phase 6: Journey & Integration (Weeks 11-12)

**Backend:**
- [ ] Journey tracking system
- [ ] Edit history logging
- [ ] Dashboard aggregations
- [ ] Reports and exports

**Frontend:**
- [ ] Journey progress UI
- [ ] RM dashboard
- [ ] Customer overview
- [ ] Report viewers

### Phase 7: Testing & Deployment (Weeks 13-14)

- [ ] Unit testing (80%+ coverage)
- [ ] Integration testing
- [ ] End-to-end testing
- [ ] Performance testing
- [ ] Security audit
- [ ] UAT with stakeholders
- [ ] Production deployment

---

## Technology Best Practices

### Backend Best Practices

1. **Layered Architecture**
   - Controller → Service → Repository
   - DTOs for API contracts
   - MapStruct for entity-DTO mapping

2. **Exception Handling**
   ```java
   @RestControllerAdvice
   public class GlobalExceptionHandler {
       @ExceptionHandler(NotFoundException.class)
       public ResponseEntity<ErrorResponse> handleNotFound(NotFoundException ex) {
           return ResponseEntity.status(HttpStatus.NOT_FOUND)
               .body(ErrorResponse.builder()
                   .success(false)
                   .message(ex.getMessage())
                   .timestamp(LocalDateTime.now())
                   .build());
       }
   }
   ```

3. **Transaction Management**
   ```java
   @Transactional
   public void submitRiskAssessment(RiskAssessmentSubmission submission) {
       // All database operations in single transaction
   }
   ```

4. **Audit Logging**
   ```java
   @EntityListeners(AuditingEntityListener.class)
   public abstract class BaseEntity {
       @CreatedDate
       private LocalDateTime createdAt;

       @LastModifiedDate
       private LocalDateTime updatedAt;

       @CreatedBy
       private String createdBy;

       @LastModifiedBy
       private String lastModifiedBy;
   }
   ```

### Frontend Best Practices

1. **OnPush Change Detection** (Always)
   ```typescript
   @Component({
       changeDetection: ChangeDetectionStrategy.OnPush
   })
   ```

2. **Signals for State** (Modern Angular 19)
   ```typescript
   protected readonly data = signal<Data[]>([]);
   protected readonly filtered = computed(() =>
       this.data().filter(d => d.active)
   );
   ```

3. **New Control Flow** (No `*ngIf`, `*ngFor`)
   ```html
   @if (user()) {
       <div>{{ user().name }}</div>
   }

   @for (item of items(); track item.id) {
       <div>{{ item.name }}</div>
   }
   ```

4. **Inject Function** (No Constructor Injection)
   ```typescript
   private readonly service = inject(MyService);
   ```

---

## Next Steps

1. **Review this document** with all stakeholders
2. **Create DATABASE_SCHEMA.sql** with complete executable schema
3. **Create API_SPECIFICATIONS.md** with detailed endpoint documentation
4. **Create FRONTEND_COMPONENTS.md** with component specifications
5. **Create IMPLEMENTATION_ROADMAP.md** with week-by-week tasks
6. **Begin Phase 1 implementation**

---

## References & Sources

### Research Sources

1. **Risk Profiling:**
   - [CFA Institute: Investment Risk Profiling Guide](https://rpc.cfainstitute.org/sites/default/files/-/media/documents/survey/investment-risk-profiling.pdf)
   - [Oxford Risk: Investor Compass](https://www.oxfordrisk.com/solutions/investor-compass-risk-suitability)

2. **Suitability Assessment:**
   - FINRA Rule 2111
   - MiFID II Guidelines
   - [RBC Wealth Management Risk Profile Questionnaire](https://ca.rbcwealthmanagement.com/documents/54275/54295/3.pdf/cd17c4ad-23a4-4767-8ada-781cbf50595d)

3. **Goal-Based Investing:**
   - [Motilal Oswal Goal Calculator](https://www.motilaloswalmf.com/tools/goal-investment-calculator)
   - [Freefincal Portfolio Audit Tool](https://freefincal.com/?p=219221)
   - [Quantum Mutual Fund Goal Calculator](https://www.quantumamc.com/tools-and-calculator/goal-based-calculators)

4. **Portfolio Risk Assessment:**
   - [2025 Portfolio Risk Assessment Guide](https://myriskpredictor.com/articles/how-to-assess-portfolio-risk-2025.html?t=202508251836)
   - [StableBread: Risk-Adjusted Performance](https://stablebread.com/measure-portfolio-risk-adjusted-performance/)

5. **Spring Security:**
   - [Spring Security Official Documentation](https://docs.spring.io/spring-security/reference/servlet/appendix/database-schema.html)
   - [Baeldung: Roles and Privileges](https://www.baeldung.com/role-and-privilege-for-spring-security-registration)
   - [Baeldung: Database-backed UserDetailsService](https://www.baeldung.com/spring-security-authentication-with-a-database)

---

**Document Status:** ✅ **FINAL - Ready for Implementation**

**Last Updated:** December 24, 2025
**Version:** 1.0 Final
