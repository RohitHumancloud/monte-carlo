# SCB Wealth Platform - Goal-Based Advisory (GBA) System

## Project Overview

This is a **Goal-Based Advisory (GBA) wealth management platform** for Standard Chartered Bank (SCB) that helps clients set financial goals and provides investment recommendations to achieve them through intelligent portfolio management and simulation.

**Project Information:**
- **Client:** Standard Chartered Bank (SCB)
- **Consultant:** Synpulse (Thailand) Co., Ltd.
- **Solution Lead:** Adrien Thonet
- **Stream Lead:** Nedy Lanto
- **Workshop Date:** December 19, 2025

---

## Table of Contents

1. [System Architecture](#system-architecture)
2. [Key Use Cases](#key-use-cases)
3. [Core Features](#core-features)
4. [Technical Implementation](#technical-implementation)
5. [Data Requirements](#data-requirements)
6. [Open Action Points](#open-action-points)
7. [System Limitations](#system-limitations)
8. [Next Steps](#next-steps)

---

## System Architecture

### Three Main Components

#### 1. **Front End** (SCB EASY / wPlan)
- Client-facing application
- Goal creation and management
- Investment proposal display and editing
- Simulation results visualization
- Client decision handling
- Notification management

**Data Responsibilities:**
- Goal details (amount, duration, DCA, initial investment)
- User interface and client interactions

#### 2. **Avaloq** (Core Banking Platform)
- Automated investment proposal generation
- Strategy management (TAA & MPF)
- Goal translation into MPF and Asset Allocation
- Portfolio rebalancing
- Client goal linkage
- PDF report generation

**Data Responsibilities:**
- Strategy (TAA & Model Portfolio Framework)

#### 3. **Avaloq Human Cloud**
- Backend calculation engine
- Monte Carlo simulation processing
- Provides Low/Medium/High outcome projections
- Does NOT maintain goals or strategies
- Computation and feedback only

**Data Responsibilities:**
- Simulation results only

**Important Notes:**
- Crisis-based scenarios are NOT supported
- Human Cloud is purely computational - no data storage

---

## Key Use Cases

### UC01: New Client Sets Goal

**Workflow:**
1. Client creates a goal via Front End
2. Avaloq translates goals into MPF and Asset Allocation
3. Goals are linked to the client profile

**Front End Inputs Required:**
- Goal Types (Retirement, Education, etc.)
- Target Amount
- Target Date
- Initial Investment
- Time Horizon
- DCA (Dollar Cost Averaging) & Frequency
- Risk Tolerance
- Investment Strategy

---

### UC02: Investment Proposal

**7-Step Workflow:**

| Step | Component | Action |
|------|-----------|--------|
| 1 | Front End / SCB | Trigger the Investment Proposal |
| 2 | Avaloq | Generate proposal to send to FE |
| 3 | Front End / SCB | User can manually edit the numbers |
| 4 | Front End / SCB | User simulates outcome |
| 5 | Human Cloud | HC provided Low/Medium/High projections |
| 6 | Front End / SCB | User finalizes the allocation and generate the trades |
| 7 | Front End / SCB | Trades are submitted to distinct trading systems |

---

### UC03: Tracking/Portfolio Monitoring

**Workflow:**

| Step | Component | Action |
|------|-----------|--------|
| 1 | Front End | RM checks if portfolio is on track |
| 2 | Human Cloud | HC provides Low/Medium/High projections |

---

### UC04: Rebalancing

#### Monthly (Batch Process)

| Step | Component | Action |
|------|-----------|--------|
| 1 | Avaloq | Batch: Avaloq generates proposal to send to FE |
| 2 | Front End | RM reviews proposal and notify clients (SCB EASY/Wplan) |
| 3 | Front End | Client Decision: Skip/No Action/Accept |
| 4 | Front End | Order execution via Trading System |

#### Ad-Hoc Rebalancing

| Step | Component | Action |
|------|-----------|--------|
| 1 | Front End | User triggers rebalancing |
| 2 | Avaloq | Avaloq generates proposal to send to FE |
| 3 | Front End | RM reviews proposal and notify clients (SCB EASY/Wplan) |
| 4 | Front End | Client Decision: Skip/No Action/Accept |
| 5 | Front End | Order execution via Trading System |

---

## Core Features

### 1. Portfolio Advisory Recommendations (CIO Tools)

**Requirements:**
- Preset investment plans based on customer profile category
- Allow CIO to adjust allocations across asset classes, sectors, and individual securities

**Solution:**
- Avaloq TAA (Tactical Asset Allocation) & Model Portfolio framework
- Container-based classification (e.g., Wealth Transfer, Low Risk Investor)
- Customizable asset allocation strategies

**Return & Deviation Display:**
- Conservative: Return 2.00%, Deviation 0.21%
- Moderate to Conservative: Return 5.18%, Deviation 0.31%
- Moderate to Aggressive: Return 3.66%, Deviation 1.67%

---

### 2. Portfolio Simulation & Scenario Analysis

**Requirements:**
- Monte Carlo simulation (projection)
- Customizable parameters
- Performance metrics
- Visualization tools
- Goal achievement analysis

**Solution:**
- Avaloq Human Cloud UC02 Investment Proposal supports simulation process
- Displays: Best/Base/Worst case scenarios
- Shows Annual Expected Return
- Shows Deviation percentages

---

### 3. What-If Simulation ⚠️ NOT SUPPORTED IN PHASE 1

**Requirements:**
- Simulate customer portfolio in case market sentiment changes
- Example: "If NASDAQ lost 10%, how will customer's portfolio be impacted?"
- Identify top 10 most impacted portfolios

**Status:**
- ❌ Not feasible with Avaloq Human Cloud
- ❌ Can only be supported by BlackRock Aladdin
- ❌ Not included in Phase 1 scope

---

### 4. Alerts and Rebalancing (Manual/AI-driven)

**Requirements:**
- Notify alerts on portfolio rebalancing
- Investment Proposition Notification

**Solution: Restriction-Based Approach**

**Example Logic:**
Every 3 months, if the client's portfolio weight deviates by more than target portfolio weight, it will proceed to rebalance. For example, if it deviates 5% from target which exceeds the 4% deviation limit, the following will need to happen:

1. Generate notification including proposed investment action (e.g., buy A sell B)
2. Send notification to client via SCB EASY & Wplan
3. Users notification and can have 3 options: **Skip, No Action, or Accept**
4. Skip and no action will lead no rebalance and portfolio remain the same allocation
5. Accept will then proceed to rebalance the proposed portfolio

**Workflow:**

| Step | Component | Action |
|------|-----------|--------|
| 1 | Avaloq | Batch: Restriction Evaluation to identify portfolios drifted from target allocation |
| 2 | Avaloq | Batch: Generation of investment proposals for portfolios exceeding thresholds |
| 3 | Front End | RM reviews proposal and notify clients (SCB ESAY/Wplan) |
| 4 | Front End | Client Decision: Skip/No Action/Accept |
| 5 | Front End | Order execution via Trading System |

---

### 5. Real-time Monitoring

**Requirements:**
Track portfolio features such as:
- Asset allocation
- Performance (total return basis):
  - Unrealized gains/losses
  - Realized gains/losses
  - Dividend & interest received
  - Other income
- Portfolio risk metrics
- Alignment with client's financial goals

**Solution:**
- Avaloq provides real-time portfolio monitoring capabilities
- Dashboard displays all performance details
- Cross-asset aggregation supported

---

## Technical Implementation

### What Needs to Be Built

#### 1. Front-End Application

**Components:**
- Goal creation interface with form inputs
- Investment proposal review & editing screens
- Simulation results visualization
  - Charts showing Best/Base/Worst case scenarios
  - Line graphs for projection over time
  - Deviation and return metrics
- Client notification system
- Portfolio monitoring dashboard
- Real-time performance tracking
- Rebalancing proposal review interface

**Technologies to Consider:**
- Modern web framework (React, Angular, Vue.js)
- Charting libraries (D3.js, Chart.js, Highcharts)
- Responsive design for mobile and desktop
- Real-time data updates (WebSockets)

---

#### 2. Integration Layer

**Required Integrations:**
- Front End ↔ Avaloq APIs
- Avaloq ↔ Human Cloud APIs
- Trading system integration
- Report generation system
- Notification services

**API Endpoints Needed:**
- `POST /goals` - Create new goal
- `PUT /goals/{id}` - Update goal
- `GET /goals/{clientId}` - Retrieve client goals
- `POST /proposals` - Generate investment proposal
- `POST /simulations` - Request simulation
- `GET /simulations/{id}/results` - Get simulation results
- `POST /rebalancing/trigger` - Trigger rebalancing
- `GET /portfolio/{clientId}/performance` - Get performance data
- `POST /trades/submit` - Submit trades to trading system

---

#### 3. Backend Services

**Services to Implement:**
- Goal management service
- Simulation orchestration service
- Rebalancing engine (batch jobs)
- Alert/notification service
- Portfolio calculation engine
- License validation service
- Report generation service

---

#### 4. Data Management

**Database Schema Requirements:**
- Client profiles
- Goal definitions and tracking
- Model portfolio templates
- Asset allocation configurations
- Performance history
- Transaction records
- Simulation results
- Rebalancing proposals
- Notification logs

---

#### 5. Reporting System

**Report Types:**
- Investment Proposal PDFs (customized)
- Portfolio Statements
  - Ad-hoc generation
  - Scheduled generation (Weekly/Monthly/Quarterly)
- Performance reports
- Rebalancing proposals

**Report Customization:**
- Use Avaloq baseline as starting point
- Apply SCB branding and theme
- Enhanced reports sent after client confirmation

---

## Data Requirements

### Data SCB Needs to Provide to Avaloq

#### 1. Asset Allocation (AA) Data
- Asset class definitions
- Allocation percentages
- Risk bands
- Rebalancing thresholds

#### 2. Model Portfolio Framework (MPF)
- Portfolio series definitions
- Asset group mappings
- Benchmark indices
- Reference summaries
- Validity dates
- Business units

#### 3. Investment Universe
- Approved securities list
- Asset classifications
- Risk ratings
- Liquidity data

#### 4. Client Data
- Risk profiles
- Investment objectives
- Portfolio holdings
- Transaction history

---

## Open Action Points

### 1. Upload of AA/Model Portfolio

**Question:** How will Avaloq handle model portfolio, AA creation, maintenance, and integration?

**Solution Options:**

| # | Option | Description | Maintenance Process | High Level Solution | Effort |
|---|--------|-------------|---------------------|---------------------|--------|
| 1.1 | Baseline Solution (Key-in) | Manual (Key-in): Strategies are keyed directly into Avaloq one by one. Create New and Delete | Manual | N/A | None |
| 1.2 | Baseline Solution (Excel Upload) | Manual (Excel Upload): User to import the excel file and upload into Avaloq. Modify Existing Only | Manual | N/A | None |
| 2 | Batch / API (Interface) | Automate maintenance via batch files. Modify Existing Only | Automated | 1. Batch Creation<br/>2. File Transfer and Upload | Small |
| 3 | Full automation (End to End) | Fully automated creation and maintenance of all objects. Create New, Delete, and Modify | Automated | 1. MPF and AA upload enhancement<br/>2. Batch Creation<br/>3. File Transfer and Upload | Large |
| 4 | Migration | Automate maintenance via migration. Create New, Delete, and Modify | Automated | 1. Leverage migration scripts for creation, deletion, and modification<br/>2. File transfer and upload of input files<br/>3. Scheduler to be implemented by SCB to pickup files from server and run the migration scripts | Medium |

**Decision Pending:** Asset class definitions will be discussed in SDA Session.

---

### 2. Values Definition in PFM

**Question:** List of values defined in PFM system

**Requirements:**
- Define all code table values
- Asset structure classifications
- Asset types
- Asset groups
- Investment risk country mappings
- PFM cluster definitions
- PFM categories and classes
- PFM market and rating

**Status:** Awaiting SCB input on complete value definitions

---

### 3. Mirroring Closed Position

**Question:** How to handle closed positions of transactions that occurred before Avaloq go-live? This impacts historical performance calculation.

**Option 1 - Current Migration Plan (In Scope):**
- Avaloq will only calculate and send performance data starting from the point Avaloq goes live
- No historical performance will be migrated
- ✅ No additional effort required

**Option 2 - Migrate Historical Performance:**
- Migrate historical performance on Portfolio level
- Dependency on availability of historical performance data from SCB
- ⚠️ Not part of original scope - may need to review effort before proceeding

**Decision Required:** Which approach should be taken?

---

### 4. PDF Report Proposal

**Question:** What level of customization is needed for investment proposal reports?

**Current Approach:**
- Investment proposition to client will use the Avaloq baseline report
- After client confirms the proposal, enhanced themed report will be sent out

**Solution:**
- Avaloq can customize the report
- Need SCB branding guidelines
- Need to define all report sections and data points

**Deliverables:**
- Avaloq Baseline template
- SCB customized proposal report template

---

### 5. IC License Validation

**Requirement:**
As part of the investment proposition generation process, the system will perform a validation check to ensure the Relationship Manager (RM) holds the necessary licensing credentials to recommend the specific underlying assets.

**Question:**
If it is determined that the RM lacks the required credentials for any proposed product, what should happen?

**Options:**
1. Remove products from Investment Proposal list?
2. Show warning but allow to proceed?
3. Prevent proposal generation?
4. Other action?

**Decision Required:** Define exact behavior when RM lacks license for proposed products.

---

### 6. Consolidated Portfolio Generation

**Question:** How is portfolio statement currently generated in Front End?

#### Ad-hoc Generation
**Inputs:**
- Reporting Period (date from and date to)
- Client account (one account or multiple account)
- Ability to generate from previous months
- Trigger source: Front End

#### Scheduled Statement Generation
**Configuration:**
- Frequency (Weekly/Monthly/Quarterly)
- Trigger Source: Avaloq

#### Data Scope
- Cross-asset aggregation

#### Output & Delivery
- Physical Statement
- Digital Copy (PDF)

**Status:** Awaiting SCB confirmation on current process and requirements

---

### 7. Trade Confirmation of Goal-Based Advisory

**Question:** Can Avaloq OOTB provide transaction details of securities transactions if they are successful, pending, or failed? SCB wants this to be shown on wPlan / EOD email.

**Answer:**
- ❌ Avaloq would not have the relevant data points to support that requirement
- Avaloq only receives EOD mirroring of holdings (open trades not reflected)
- ✅ Trade confirmation should use existing SCB trading systems

**Recommendation:**
- Use existing SCB trade confirmation infrastructure
- Display real-time trade status on wPlan
- Send EOD confirmation emails from existing system

---

## System Limitations

### Known Constraints

| # | Feature | Status | Alternative Solution |
|---|---------|--------|---------------------|
| 1 | What-If / Crisis Scenarios | ❌ NOT SUPPORTED | Requires BlackRock Aladdin (not in scope) |
| 2 | Real-time Trade Confirmation | ❌ NOT SUPPORTED | Use existing SCB trade confirmation system |
| 3 | Historical Performance (pre go-live) | ⚠️ OPTIONAL | Only if migration Option 2 is chosen |
| 4 | Crisis-based Simulation | ❌ NOT SUPPORTED | Not supported by Avaloq Human Cloud |
| 5 | Full Probability Distribution | ⚠️ LIMITED | Only High/Medium/Low scenarios provided |

---

## Next Steps

### Immediate Actions Required

#### Phase 1: Requirements Finalization
- [ ] Finalize asset class definitions in SDA session
- [ ] Decide on Model Portfolio upload solution (Options 1-4)
- [ ] Clarify IC License validation requirements and behavior
- [ ] Confirm historical performance migration approach (Option 1 or 2)
- [ ] Define PDF report customization requirements
- [ ] Confirm consolidated portfolio generation process
- [ ] Validate trade confirmation approach

#### Phase 2: Technical Planning
- [ ] Map out complete integration architecture
- [ ] Define API specifications for all integrations
- [ ] Design database schema
- [ ] Define data migration strategy
- [ ] Create detailed technical design document

#### Phase 3: Design & Development
- [ ] Create UI/UX mockups for all screens
- [ ] Design simulation visualization components
- [ ] Build Front End application
- [ ] Develop integration layer
- [ ] Implement backend services
- [ ] Configure Avaloq workflows

#### Phase 4: Testing & Deployment
- [ ] Unit testing
- [ ] Integration testing
- [ ] User acceptance testing (UAT)
- [ ] Performance testing
- [ ] Security testing
- [ ] Data migration execution
- [ ] Production deployment

---

## Project Team

### Synpulse
- **Solution Lead:** Adrien Thonet
- **Stream Lead:** Nedy Lanto

### Contact Information
**Synpulse (Thailand) Co., Ltd.**
- Address: 281/19-23 NST One Tower, 6th Floor, Room No. 604
- Location: Soi Silom 1, Silom Road, Silom, Bang Rak
- City: Bangkok 10500
- Country: Thailand

---

## Document Version

- **Version:** 0.1
- **Document Code:** GBA_D_01 – Deep Dive - GBA
- **Date:** December 19, 2025
- **Status:** Draft - For Discussion

---

## Glossary

| Term | Definition |
|------|------------|
| **GBA** | Goal-Based Advisory |
| **TAA** | Tactical Asset Allocation |
| **MPF** | Model Portfolio Framework |
| **AA** | Asset Allocation |
| **DCA** | Dollar Cost Averaging |
| **RM** | Relationship Manager |
| **CIO** | Chief Investment Officer |
| **IC** | Investment Consultant |
| **PFM** | Portfolio Management |
| **SCB EASY** | SCB mobile/web application |
| **wPlan** | Wealth planning application |
| **EOD** | End of Day |
| **OOTB** | Out of the Box |

---

## Additional Resources

- Workshop presentation: `SCB-SYN-GBA Deep Dive 1_Workshop_V0.1.pdf`
- Technical documentation: To be provided
- API specifications: To be defined
- Design mockups: To be created

---

**© 2025 Synpulse. Private & confidential.**
