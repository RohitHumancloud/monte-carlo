# Comprehensive Seed Data Plan
## GBS (Goal-Based Savings) Demo Data Generation

**Version**: 1.0
**Created**: January 5, 2026
**Purpose**: Generate comprehensive realistic test data for demo and testing

---

## Executive Summary

This document outlines the plan to generate comprehensive seed data for the GBS application to enable:
- Full end-to-end flow testing
- Client demo demonstrations
- Bug identification through diverse data scenarios
- Production-ready data patterns

---

## Data Requirements Summary

| Entity | Count | Notes |
|--------|-------|-------|
| Super Admin | 1 | System administrator |
| Risk Questions | 8 | Real-world industry-standard questions |
| Suitability Questions | 8 | MiFID II compliant questions |
| Risk Categories | 6 | Score range 8-35 (user requested 1-35) |
| Suitability Levels | 5 | NOT_SUITABLE to VERY_HIGH_SUITABILITY |
| Model Portfolios | 30 | 6 risk categories × 5 suitability levels |
| Relationship Managers | 20 | Each manages 5-10 customers |
| Customers | 100 | Diverse profiles |
| Goals | 1000 | ~10 goals per customer |
| Goal Journey Trackings | 1000 | One per goal |
| Customer Risk Profiles | ~500 | Various completion states |
| Customer Suitability Assessments | ~500 | Various completion states |
| Proposals | ~300 | Various statuses |

---

## 1. Super Admin Data

```
Email: admin@gbs.com
Password: Admin@123 (BCrypt hashed)
Role: SUPER_ADMIN
Status: ACTIVE
```

---

## 2. Risk Profile Questions (8 Questions)

Based on industry-standard questionnaires from Vanguard, Schwab, RBC, and CFA Institute.

### Question 1: Age Group
**Code**: `RISK_Q01`
**Type**: SINGLE_SELECT
**Weight**: 1.0

| Option | Points | Text |
|--------|--------|------|
| 1 | 4 | Under 25 years old |
| 2 | 3 | 25-35 years old |
| 3 | 2 | 36-50 years old |
| 4 | 1 | 51-65 years old |
| 5 | 0 | Over 65 years old |

### Question 2: Investment Time Horizon
**Code**: `RISK_Q02`
**Type**: SINGLE_SELECT
**Weight**: 1.5 (Highest - most critical factor)

| Option | Points | Text |
|--------|--------|------|
| 1 | 0 | Less than 3 years |
| 2 | 1 | 3-5 years |
| 3 | 2 | 6-10 years |
| 4 | 3 | 11-15 years |
| 5 | 4 | More than 15 years |

### Question 3: Primary Investment Objective
**Code**: `RISK_Q03`
**Type**: MULTI_SELECT
**Weight**: 1.0
**Max Cap**: 8

| Option | Points | Text |
|--------|--------|------|
| 1 | 1 | Capital preservation (protect what I have) |
| 2 | 2 | Generate regular income |
| 3 | 3 | Long-term capital growth |
| 4 | 3 | Wealth accumulation for retirement |
| 5 | 2 | Save for a major purchase (home, education) |
| 6 | 4 | Speculation / maximize returns |

### Question 4: Emergency Fund Status
**Code**: `RISK_Q04`
**Type**: SINGLE_SELECT
**Weight**: 1.5 (Critical for risk capacity)

| Option | Points | Text |
|--------|--------|------|
| 1 | 0 | No emergency fund, this investment might be needed for emergencies |
| 2 | 1 | Less than 3 months of expenses |
| 3 | 2 | 3-6 months of expenses |
| 4 | 3 | 6-12 months of expenses |
| 5 | 4 | More than 12 months of expenses saved |

### Question 5: Years of Investment Experience
**Code**: `RISK_Q05`
**Type**: SINGLE_SELECT
**Weight**: 1.0

| Option | Points | Text |
|--------|--------|------|
| 1 | 0 | None, I am a first-time investor |
| 2 | 1 | Less than 2 years |
| 3 | 2 | 2-5 years |
| 4 | 3 | 5-10 years |
| 5 | 4 | More than 10 years |

### Question 6: Maximum Acceptable Loss
**Code**: `RISK_Q06`
**Type**: SINGLE_SELECT
**Weight**: 2.0 (Key risk metric)

| Option | Points | Text |
|--------|--------|------|
| 1 | 0 | Any loss makes me very anxious, I would reconsider immediately |
| 2 | 1 | 5% decline |
| 3 | 2 | 10% decline |
| 4 | 3 | 20% decline |
| 5 | 4 | 30% or more decline |

### Question 7: Market Downturn Response
**Code**: `RISK_Q07`
**Type**: SINGLE_SELECT
**Weight**: 2.0 (Best behavioral predictor)

| Option | Points | Text |
|--------|--------|------|
| 1 | 0 | Sell everything immediately to prevent further losses |
| 2 | 1 | Sell 50% to reduce my exposure |
| 3 | 2 | Hold and wait for recovery, but feel very anxious |
| 4 | 3 | Hold and not worry, I'm invested for the long term |
| 5 | 4 | Buy more to take advantage of lower prices |

### Question 8: Recovery Time Acceptance
**Code**: `RISK_Q08`
**Type**: SINGLE_SELECT
**Weight**: 2.0 (Time-risk alignment)

| Option | Points | Text |
|--------|--------|------|
| 1 | 0 | Less than 1 year - I cannot wait for recovery |
| 2 | 1 | 1-2 years |
| 3 | 2 | 3-4 years |
| 4 | 3 | 5-7 years |
| 5 | 4 | More than 7 years - I can wait as long as needed |

### Score Calculation
```
Minimum Possible: 1 (all zeros except Q3 minimum 1 point)
Maximum Practical: 35 (realistic aggressive answers)
Theoretical Maximum: 52 (all max values)

Score Range Distribution:
- SECURE:       8-13  (Very conservative)
- CONSERVATIVE: 14-16 (Conservative)
- INCOME:       17-21 (Income-focused)
- BALANCE:      22-26 (Balanced)
- AGGRESSIVE:   27-31 (Aggressive)
- SPECULATIVE:  32-35 (Highly aggressive)
```

---

## 3. Suitability Assessment Questions (8 Questions)

Based on MiFID II requirements and industry best practices.

### Question 1: Age Group
**Code**: `SUIT_Q01`
**Type**: SINGLE_SELECT
**Dimension**: FINANCIAL_SITUATION
**Weight**: 1.0

| Option | Points | Text |
|--------|--------|------|
| 1 | 4 | Under 25 years |
| 2 | 3 | 25-35 years |
| 3 | 2 | 36-45 years |
| 4 | 2 | 46-55 years |
| 5 | 1 | 56-65 years |
| 6 | 0 | Over 65 years |

### Question 2: Annual Gross Income
**Code**: `SUIT_Q02`
**Type**: SINGLE_SELECT
**Dimension**: FINANCIAL_SITUATION
**Weight**: 1.5

| Option | Points | Text |
|--------|--------|------|
| 1 | 0 | Below ₹3,00,000 |
| 2 | 1 | ₹3,00,000 - ₹6,00,000 |
| 3 | 2 | ₹6,00,000 - ₹12,00,000 |
| 4 | 3 | ₹12,00,000 - ₹25,00,000 |
| 5 | 4 | ₹25,00,000 - ₹50,00,000 |
| 6 | 5 | Above ₹50,00,000 |

### Question 3: Total Net Worth
**Code**: `SUIT_Q03`
**Type**: SINGLE_SELECT
**Dimension**: FINANCIAL_SITUATION
**Weight**: 1.5

| Option | Points | Text |
|--------|--------|------|
| 1 | 0 | Below ₹5,00,000 |
| 2 | 1 | ₹5,00,000 - ₹25,00,000 |
| 3 | 2 | ₹25,00,000 - ₹50,00,000 |
| 4 | 3 | ₹50,00,000 - ₹1,00,00,000 |
| 5 | 4 | ₹1,00,00,000 - ₹5,00,00,000 |
| 6 | 5 | Above ₹5,00,00,000 |

### Question 4: Emergency Fund Status
**Code**: `SUIT_Q04`
**Type**: SINGLE_SELECT
**Dimension**: RISK_CAPACITY
**Weight**: 2.0 (Gate question)

| Option | Points | Text |
|--------|--------|------|
| 1 | 4 | Yes, 6+ months of expenses covered |
| 2 | 3 | Yes, 3-6 months of expenses covered |
| 3 | 1 | Less than 3 months covered |
| 4 | 0 | No emergency fund |

### Question 5: Years of Investment Experience
**Code**: `SUIT_Q05`
**Type**: SINGLE_SELECT
**Dimension**: EXPERIENCE
**Weight**: 1.0

| Option | Points | Text |
|--------|--------|------|
| 1 | 0 | No experience (first-time investor) |
| 2 | 1 | Less than 1 year |
| 3 | 2 | 1-3 years |
| 4 | 3 | 3-5 years |
| 5 | 4 | 5-10 years |
| 6 | 5 | More than 10 years |

### Question 6: Past Performance Behavior
**Code**: `SUIT_Q06`
**Type**: SINGLE_SELECT
**Dimension**: EXPERIENCE
**Weight**: 2.0 (Critical behavioral question)

| Option | Points | Text |
|--------|--------|------|
| 1 | 1 | No, never experienced significant loss |
| 2 | 0 | Yes, and I sold investments during decline |
| 3 | 3 | Yes, and I held investments without selling |
| 4 | 5 | Yes, and I invested more during decline |
| 5 | 1 | Never invested during market volatility |

### Question 7: Investment Knowledge (Self-Assessment)
**Code**: `SUIT_Q07`
**Type**: SINGLE_SELECT
**Dimension**: KNOWLEDGE
**Weight**: 1.5

| Option | Points | Text |
|--------|--------|------|
| 1 | 0 | Basic - I know about savings accounts and FDs only |
| 2 | 1 | Limited - I know about mutual funds but haven't invested |
| 3 | 2 | Moderate - I have invested in mutual funds |
| 4 | 3 | Good - I understand equity, debt, and asset allocation |
| 5 | 4 | Expert - I understand complex products like derivatives, PMS |

### Question 8: Primary Investment Objective
**Code**: `SUIT_Q08`
**Type**: SINGLE_SELECT
**Dimension**: INVESTMENT_OBJECTIVE
**Weight**: 1.5

| Option | Points | Text |
|--------|--------|------|
| 1 | 0 | Capital Preservation (protect what I have) |
| 2 | 1 | Generate Regular Income |
| 3 | 2 | Balanced Growth & Income |
| 4 | 3 | Long-term Capital Growth |
| 5 | 4 | Aggressive Wealth Accumulation |
| 6 | 5 | Speculation / Maximum Returns |

### Suitability Level Calculation
```
Overall Score Range: 0-40 (approximately)

Suitability Levels:
- NOT_SUITABLE:          0-8   (Cannot recommend equity)
- LOW_SUITABILITY:       9-16  (Max 20% equity)
- MODERATE_SUITABILITY:  17-24 (Max 50% equity)
- HIGH_SUITABILITY:      25-32 (Max 75% equity)
- VERY_HIGH_SUITABILITY: 33-40 (Up to 95% equity)
```

---

## 4. Risk Score Categories (6 Categories)

| Code | Name | Min Score | Max Score | Risk Level | Color | Description |
|------|------|-----------|-----------|------------|-------|-------------|
| SECURE | Secure | 8 | 13 | VERY_LOW | #16a34a | Very conservative investors seeking capital preservation |
| CONSERVATIVE | Conservative | 14 | 16 | LOW | #22c55e | Conservative investors with low risk tolerance |
| INCOME | Income | 17 | 21 | MODERATE | #eab308 | Income-focused investors with moderate-low risk |
| BALANCE | Balance | 22 | 26 | MODERATE_HIGH | #f97316 | Balanced investors seeking growth with moderate risk |
| AGGRESSIVE | Aggressive | 27 | 31 | HIGH | #ef4444 | Aggressive investors comfortable with high volatility |
| SPECULATIVE | Speculative | 32 | 35 | VERY_HIGH | #dc2626 | Highly aggressive investors seeking maximum returns |

---

## 5. Model Portfolios (30 Portfolios)

### Portfolio Matrix: Risk Category × Suitability Level

Each portfolio has unique asset allocation based on the combination of risk category and suitability level.

| Risk Category | NOT_SUITABLE | LOW | MODERATE | HIGH | VERY_HIGH |
|---------------|--------------|-----|----------|------|-----------|
| SECURE | SEC-NS-01 | SEC-LOW-01 | SEC-MOD-01 | SEC-HIGH-01 | SEC-VHIGH-01 |
| CONSERVATIVE | CON-NS-01 | CON-LOW-01 | CON-MOD-01 | CON-HIGH-01 | CON-VHIGH-01 |
| INCOME | INC-NS-01 | INC-LOW-01 | INC-MOD-01 | INC-HIGH-01 | INC-VHIGH-01 |
| BALANCE | BAL-NS-01 | BAL-LOW-01 | BAL-MOD-01 | BAL-HIGH-01 | BAL-VHIGH-01 |
| AGGRESSIVE | AGG-NS-01 | AGG-LOW-01 | AGG-MOD-01 | AGG-HIGH-01 | AGG-VHIGH-01 |
| SPECULATIVE | SPE-NS-01 | SPE-LOW-01 | SPE-MOD-01 | SPE-HIGH-01 | SPE-VHIGH-01 |

### Portfolio Details

#### SECURE Portfolios (Risk Score: 8-13)

| Portfolio Code | Suitability | Equity % | Debt % | Gold % | Expected Return | Volatility |
|----------------|-------------|----------|--------|--------|-----------------|------------|
| SEC-NS-01 | NOT_SUITABLE | 0 | 95 | 5 | 5-6% | 2% |
| SEC-LOW-01 | LOW | 5 | 90 | 5 | 5.5-6.5% | 3% |
| SEC-MOD-01 | MODERATE | 10 | 85 | 5 | 6-7% | 4% |
| SEC-HIGH-01 | HIGH | 15 | 80 | 5 | 6.5-7.5% | 5% |
| SEC-VHIGH-01 | VERY_HIGH | 20 | 75 | 5 | 7-8% | 6% |

#### CONSERVATIVE Portfolios (Risk Score: 14-16)

| Portfolio Code | Suitability | Equity % | Debt % | Gold % | Expected Return | Volatility |
|----------------|-------------|----------|--------|--------|-----------------|------------|
| CON-NS-01 | NOT_SUITABLE | 5 | 90 | 5 | 5.5-6.5% | 3% |
| CON-LOW-01 | LOW | 15 | 80 | 5 | 6.5-7.5% | 5% |
| CON-MOD-01 | MODERATE | 25 | 70 | 5 | 7.5-8.5% | 7% |
| CON-HIGH-01 | HIGH | 30 | 65 | 5 | 8-9% | 8% |
| CON-VHIGH-01 | VERY_HIGH | 35 | 60 | 5 | 8.5-9.5% | 9% |

#### INCOME Portfolios (Risk Score: 17-21)

| Portfolio Code | Suitability | Equity % | Debt % | Gold % | Expected Return | Volatility |
|----------------|-------------|----------|--------|--------|-----------------|------------|
| INC-NS-01 | NOT_SUITABLE | 10 | 85 | 5 | 6-7% | 4% |
| INC-LOW-01 | LOW | 25 | 70 | 5 | 7.5-8.5% | 7% |
| INC-MOD-01 | MODERATE | 40 | 55 | 5 | 9-10% | 10% |
| INC-HIGH-01 | HIGH | 45 | 50 | 5 | 9.5-10.5% | 11% |
| INC-VHIGH-01 | VERY_HIGH | 50 | 45 | 5 | 10-11% | 12% |

#### BALANCE Portfolios (Risk Score: 22-26)

| Portfolio Code | Suitability | Equity % | Debt % | Gold % | Expected Return | Volatility |
|----------------|-------------|----------|--------|--------|-----------------|------------|
| BAL-NS-01 | NOT_SUITABLE | 15 | 80 | 5 | 6.5-7.5% | 5% |
| BAL-LOW-01 | LOW | 35 | 60 | 5 | 8.5-9.5% | 9% |
| BAL-MOD-01 | MODERATE | 55 | 40 | 5 | 10.5-11.5% | 13% |
| BAL-HIGH-01 | HIGH | 60 | 35 | 5 | 11-12% | 14% |
| BAL-VHIGH-01 | VERY_HIGH | 65 | 30 | 5 | 11.5-12.5% | 15% |

#### AGGRESSIVE Portfolios (Risk Score: 27-31)

| Portfolio Code | Suitability | Equity % | Debt % | Gold % | Expected Return | Volatility |
|----------------|-------------|----------|--------|--------|-----------------|------------|
| AGG-NS-01 | NOT_SUITABLE | 20 | 75 | 5 | 7-8% | 6% |
| AGG-LOW-01 | LOW | 45 | 50 | 5 | 9.5-10.5% | 11% |
| AGG-MOD-01 | MODERATE | 70 | 25 | 5 | 12-13% | 16% |
| AGG-HIGH-01 | HIGH | 75 | 20 | 5 | 12.5-13.5% | 17% |
| AGG-VHIGH-01 | VERY_HIGH | 80 | 15 | 5 | 13-14% | 18% |

#### SPECULATIVE Portfolios (Risk Score: 32-35)

| Portfolio Code | Suitability | Equity % | Debt % | Gold % | Expected Return | Volatility |
|----------------|-------------|----------|--------|--------|-----------------|------------|
| SPE-NS-01 | NOT_SUITABLE | 25 | 70 | 5 | 7.5-8.5% | 7% |
| SPE-LOW-01 | LOW | 55 | 40 | 5 | 10.5-11.5% | 13% |
| SPE-MOD-01 | MODERATE | 80 | 15 | 5 | 13-14% | 18% |
| SPE-HIGH-01 | HIGH | 85 | 10 | 5 | 13.5-14.5% | 19% |
| SPE-VHIGH-01 | VERY_HIGH | 95 | 0 | 5 | 14-15% | 22% |

---

## 6. Relationship Managers (20 RMs)

### RM Distribution

| RM ID Range | Branch | Specialization | Customer Count |
|-------------|--------|----------------|----------------|
| RM001-RM005 | Mumbai | Wealth Management | 5 each |
| RM006-RM010 | Delhi | Retirement Planning | 5 each |
| RM011-RM015 | Bangalore | Tech Professionals | 5 each |
| RM016-RM020 | Chennai | Conservative Investors | 5 each |

### Sample RM Profiles

```
RM001: Rajesh Kumar
- Email: rajesh.kumar@gbs.com
- Branch: Mumbai Central
- Specialization: HNI Wealth Management
- NISM Certified: Yes
- Experience: 12 years
- Customers: 5

RM002: Priya Sharma
- Email: priya.sharma@gbs.com
- Branch: Mumbai Bandra
- Specialization: Women Investors
- NISM Certified: Yes
- Experience: 8 years
- Customers: 5

... (20 total)
```

---

## 7. Customers (100 Customers)

### Customer Distribution by Status

| Status | Count | Description |
|--------|-------|-------------|
| ACTIVE | 60 | Currently investing |
| PENDING | 20 | Onboarding in progress |
| INACTIVE | 15 | Dormant accounts |
| BLOCKED | 5 | Compliance issues |

### Customer Distribution by Journey Progress

| Journey State | Count | Description |
|---------------|-------|-------------|
| GOAL_CREATION | 10 | Just started, creating goal |
| RISK_PROFILE | 15 | Completing risk assessment |
| SUITABILITY | 15 | Completing suitability assessment |
| FINANCIAL_CALCULATION | 15 | Running financial calculations |
| PORTFOLIO_MATCHING | 15 | Portfolio being matched |
| SIMULATION | 10 | Reviewing projections |
| ORDER_PLACEMENT | 10 | Proposal stage |
| COMPLETED | 10 | Full journey completed |

### Sample Customer Profiles

```
Customer 001: Amit Patel
- Age: 28, Income: ₹15L, Net Worth: ₹25L
- Risk Category: AGGRESSIVE
- Suitability: HIGH
- Goals: 12 (Retirement, Home, Child Education...)
- Status: ACTIVE
- RM: RM001

Customer 002: Meera Iyer
- Age: 45, Income: ₹30L, Net Worth: ₹1.5Cr
- Risk Category: BALANCE
- Suitability: VERY_HIGH
- Goals: 8 (Retirement, Wealth Creation...)
- Status: ACTIVE
- RM: RM001

... (100 total)
```

---

## 8. Goals (1000 Goals)

### Goal Distribution by Type

| Goal Type | Count | Typical Target |
|-----------|-------|----------------|
| RETIREMENT | 200 | ₹2Cr - ₹10Cr |
| EDUCATION | 150 | ₹25L - ₹1Cr |
| HOME_PURCHASE | 100 | ₹50L - ₹2Cr |
| VEHICLE_PURCHASE | 50 | ₹5L - ₹25L |
| MARRIAGE | 100 | ₹10L - ₹50L |
| WEALTH_CREATION | 150 | ₹50L - ₹5Cr |
| VACATION | 50 | ₹2L - ₹10L |
| EMERGENCY_FUND | 100 | ₹3L - ₹20L |
| DEBT_REPAYMENT | 50 | ₹10L - ₹50L |
| BUSINESS_INVESTMENT | 50 | ₹25L - ₹2Cr |

### Goal Distribution by Status

| Status | Count | Description |
|--------|-------|-------------|
| ACTIVE | 600 | In progress |
| PENDING | 200 | Awaiting approval/action |
| COMPLETED | 150 | Goal achieved |
| CANCELLED | 50 | Goal abandoned |

### Goal Journey States

For each goal, corresponding journey tracking records:

| Current Stage | Count | Sub-steps |
|---------------|-------|-----------|
| GOAL_CREATION | 100 | goal_type, goal_name, target_amount |
| RISK_PROFILE | 150 | question_1 to question_8, result |
| SUITABILITY | 150 | question_1 to question_8, result |
| FINANCIAL_CALCULATION | 150 | inputs, projections |
| PORTFOLIO_MATCHING | 150 | matching, distribution |
| SIMULATION | 100 | scenarios |
| ORDER_PLACEMENT | 100 | proposal_draft, proposal_sent |
| COMPLETED | 100 | all_complete |

---

## 9. Customer Risk Profiles (~500 records)

### Distribution by Completion Status

| Status | Count | Description |
|--------|-------|-------------|
| COMPLETED | 300 | Full assessment done |
| IN_PROGRESS | 100 | Partially completed |
| NOT_STARTED | 50 | Journey started but risk not begun |
| EXPIRED | 50 | Assessment older than 12 months |

### Risk Category Distribution

| Risk Category | Count | Score Range |
|---------------|-------|-------------|
| SECURE | 50 | 8-13 |
| CONSERVATIVE | 80 | 14-16 |
| INCOME | 100 | 17-21 |
| BALANCE | 120 | 22-26 |
| AGGRESSIVE | 100 | 27-31 |
| SPECULATIVE | 50 | 32-35 |

---

## 10. Customer Suitability Assessments (~500 records)

### Distribution by Completion Status

| Status | Count | Description |
|--------|-------|-------------|
| COMPLETED | 280 | Full assessment done |
| IN_PROGRESS | 120 | Partially completed |
| NOT_STARTED | 50 | Risk done but suitability not begun |
| BLOCKED | 50 | Cannot proceed (gate question failed) |

### Suitability Level Distribution

| Suitability Level | Count | Max Equity |
|-------------------|-------|------------|
| NOT_SUITABLE | 30 | 10% |
| LOW_SUITABILITY | 70 | 30% |
| MODERATE_SUITABILITY | 100 | 50% |
| HIGH_SUITABILITY | 120 | 75% |
| VERY_HIGH_SUITABILITY | 80 | 95% |

---

## 11. Proposals (~300 records)

### Distribution by Status

| Status | Count | Description |
|--------|-------|-------------|
| DRAFT | 30 | Being prepared by RM |
| PENDING | 100 | Sent, awaiting customer response |
| APPROVED | 100 | Customer accepted |
| REJECTED | 40 | Customer declined |
| EXPIRED | 20 | 30-day validity passed |
| SUPERSEDED | 10 | Replaced by new version |

### Distribution by Type

| Proposal Type | Count |
|---------------|-------|
| RM_TO_CUSTOMER | 250 |
| CUSTOMER_TO_RM | 50 |

---

## 12. Notifications (~1000 records)

| Type | Count |
|------|-------|
| PROPOSAL_RECEIVED | 200 |
| PROPOSAL_APPROVED | 100 |
| PROPOSAL_REJECTED | 40 |
| REVIEW_REQUESTED | 100 |
| GOAL_CREATED | 200 |
| ASSESSMENT_COMPLETED | 200 |
| JOURNEY_MILESTONE | 160 |

---

## 13. Implementation Plan

### Phase 1: Master Data (Run First)
1. Risk Categories (6 records)
2. Asset Classes (11 records)
3. Risk Profile Questions (8 questions + 38 options)
4. Suitability Questions (8 questions + 41 options)
5. Model Portfolios (30 portfolios + strategies + allocations)

### Phase 2: User Data
1. Super Admin (1 record)
2. Relationship Managers (20 records)
3. Customers (100 records)

### Phase 3: Transaction Data
1. Goals (1000 records)
2. Goal Journey Tracking (1000 records)
3. Customer Risk Profiles (500 records)
4. Customer Risk Answers (4000 records)
5. Customer Suitability Assessments (500 records)
6. Customer Suitability Answers (4000 records)
7. Proposals (300 records)
8. Notifications (1000 records)

---

## 14. Data Initializer File Structure

```
/configuration/
├── RiskCategoryDataInitializer.java      (Update)
├── AssetClassDataInitializer.java        (Exists)
├── QuestionDataInitializer.java          (Update - 8 questions)
├── SuitabilityQuestionDataInitializer.java (Update - 8 questions)
├── ModelPortfolioDataInitializer.java    (New - 30 portfolios)
├── SuperAdminDataInitializer.java        (Exists)
├── RmDataInitializer.java                (New - 20 RMs)
├── CustomerDataInitializer.java          (New - 100 customers)
├── GoalDataInitializer.java              (New - 1000 goals)
├── JourneyDataInitializer.java           (New - journey tracking)
├── AssessmentDataInitializer.java        (New - risk & suitability)
├── ProposalDataInitializer.java          (New - proposals)
└── DemoDataCleanupInitializer.java       (New - cleanup old data)
```

---

## 15. Execution Order

```
Order 1: DemoDataCleanupInitializer (deletes existing data)
Order 2: RiskCategoryDataInitializer
Order 3: AssetClassDataInitializer
Order 4: QuestionDataInitializer
Order 5: SuitabilityQuestionDataInitializer
Order 6: ModelPortfolioDataInitializer
Order 7: SuperAdminDataInitializer
Order 8: RmDataInitializer
Order 9: CustomerDataInitializer
Order 10: GoalDataInitializer
Order 11: JourneyDataInitializer
Order 12: AssessmentDataInitializer
Order 13: ProposalDataInitializer
```

---

## 16. Verification Queries

After seed data is loaded, run these queries to verify:

```sql
-- Verify counts
SELECT 'users' as entity, COUNT(*) as count FROM users
UNION ALL SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'relationship_managers', COUNT(*) FROM relationship_managers
UNION ALL SELECT 'goals', COUNT(*) FROM goals
UNION ALL SELECT 'risk_score_categories', COUNT(*) FROM risk_score_categories
UNION ALL SELECT 'questions', COUNT(*) FROM questions
UNION ALL SELECT 'model_portfolios', COUNT(*) FROM modern_portfolios
UNION ALL SELECT 'customer_risk_profiles', COUNT(*) FROM customer_risk_profiles
UNION ALL SELECT 'customer_suitability_assessments', COUNT(*) FROM customer_suitability_assessments
UNION ALL SELECT 'proposals', COUNT(*) FROM proposals
UNION ALL SELECT 'goal_journey_tracking', COUNT(*) FROM goal_journey_tracking;
```

Expected Results:
- users: 121 (1 admin + 20 RMs + 100 customers)
- customers: 100
- relationship_managers: 20
- goals: 1000
- risk_score_categories: 6
- questions: 16 (8 risk + 8 suitability)
- model_portfolios: 30
- customer_risk_profiles: ~500
- customer_suitability_assessments: ~500
- proposals: ~300
- goal_journey_tracking: 1000

---

## 17. Test Scenarios Covered

This seed data enables testing of:

1. **Login Scenarios**
   - Super Admin login
   - RM login with different branches
   - Customer login at various journey stages

2. **Risk Assessment Flow**
   - Complete assessment (all 8 questions)
   - Partial assessment (3 questions answered)
   - Resume from specific question
   - Different risk category outcomes

3. **Suitability Assessment Flow**
   - Complete assessment
   - Gate question blocking (no emergency fund)
   - Different suitability level outcomes

4. **Portfolio Matching**
   - All 30 portfolio combinations
   - Edge cases (NOT_SUITABLE + SPECULATIVE)

5. **Proposal Workflow**
   - RM to Customer proposals
   - Customer to RM proposals
   - Approval/Rejection flows
   - Expired proposals

6. **Journey Tracking**
   - Goals at different stages
   - Resume capability
   - Progress tracking

7. **Customer Portal Views**
   - Risk profile history
   - Suitability history
   - Portfolio details
   - Proposal management

---

**Document Status**: ✅ Complete Plan
**Next Step**: Implement data initializers
**Estimated Implementation Time**: 4-6 hours
