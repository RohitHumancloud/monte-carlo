# Investment Execution - Complete End-to-End Implementation Walkthrough

**Date**: January 8, 2026
**Purpose**: Detailed walkthrough of investment execution from proposal to portfolio valuation
**Audience**: Development Team

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Scenario: Customer Journey](#2-scenario-customer-journey)
3. [Step-by-Step Implementation](#3-step-by-step-implementation)
4. [Database State Evolution](#4-database-state-evolution)
5. [Code Implementation Examples](#5-code-implementation-examples)
6. [API Flow Examples](#6-api-flow-examples)
7. [Frontend Integration](#7-frontend-integration)
8. [Daily Operations](#8-daily-operations)
9. [Testing Scenarios](#9-testing-scenarios)

---

## 1. Introduction

This document walks through the COMPLETE implementation of investment execution using a real example. We'll follow **Priya Sharma** from proposal acceptance through 22 months of SIP investments to current portfolio valuation.

### 1.1 Timeline Overview

```
March 15, 2024: Proposal Accepted
      ↓
March 18, 2024: Initial Investment ₹1,00,000 executed
      ↓
April 18, 2024: First SIP ₹2,000
      ↓
May 18, 2024: Second SIP ₹2,000
      ↓
... (every month)
      ↓
January 8, 2026: Current Date (22 months later)
      ↓
Total Invested: ₹1,44,000
Current Value: ₹1,87,500 (example)
Gain: +₹43,500 (+30.2%)
```

---

## 2. Scenario: Customer Journey

### 2.1 Customer Profile

**Name**: Priya Sharma
**Customer ID**: CUS-2024-001
**RM**: Rajesh Kumar (RM-001)
**Goal**: Child Education Fund
**Target Amount**: ₹50,00,000
**Time Horizon**: 12 years
**Risk Profile**: Aggressive (Score: 38/52)
**Portfolio**: Aggressive Growth Portfolio

### 2.2 Portfolio Allocation

**Aggressive Growth Portfolio** (80% Equity / 20% Debt)

| Fund | Asset Class | Allocation % | Initial Amount (₹) | Monthly SIP (₹) |
|------|-------------|--------------|-------------------|----------------|
| HDFC Top 100 Fund | Large Cap Equity | 30% | 30,000 | 600 |
| ICICI Pru Bluechip | Large Cap Equity | 25% | 25,000 | 500 |
| Axis Midcap Fund | Mid Cap Equity | 15% | 15,000 | 300 |
| SBI Small Cap Fund | Small Cap Equity | 10% | 10,000 | 200 |
| HDFC Corp Bond Fund | Debt | 15% | 15,000 | 300 |
| Kotak Liquid Fund | Debt | 5% | 5,000 | 100 |
| **Total** | | **100%** | **₹1,00,000** | **₹2,000** |

### 2.3 Investment Timeline

```
2024-03-15: Proposal approved by Priya
2024-03-18: Initial investment ₹1,00,000 executed
2024-04-18: SIP #1: ₹2,000
2024-05-18: SIP #2: ₹2,000
2024-06-18: SIP #3: ₹2,000
... continues monthly ...
2025-12-18: SIP #21: ₹2,000
2026-01-08: Current Date (no SIP yet, next is 2026-01-18)

Total SIPs executed: 21
Total SIP amount: 21 × ₹2,000 = ₹42,000
Total Invested: ₹1,00,000 + ₹42,000 = ₹1,42,000
```

---

## 3. Step-by-Step Implementation

### Step 1: Proposal Acceptance

**User Action**: Priya logs into customer portal and clicks "Accept Proposal"

**Frontend (Angular)**:
```typescript
// proposal-detail.component.ts

acceptProposal(proposalId: number) {
  const dialogRef = this.dialog.open(ConfirmDialogComponent, {
    data: {
      title: 'Accept Investment Proposal',
      message: 'Are you sure you want to accept this proposal and proceed with investment?',
      confirmText: 'Yes, Accept'
    }
  });

  dialogRef.afterClosed().subscribe(result => {
    if (result) {
      this.proposalService.acceptProposal(proposalId)
        .subscribe({
          next: (response) => {
            this.snackBar.open('Proposal accepted! Investment will be processed.', 'Close');
            this.router.navigate(['/client/dashboard']);
          },
          error: (error) => {
            this.snackBar.open('Failed to accept proposal', 'Close');
          }
        });
    }
  });
}
```

**Backend API Request**:
```http
PUT /api/v1/customer/proposals/123/accept
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
Content-Type: application/json

{
  "note": "I accept this proposal. Please proceed with investment."
}
```

**Backend Controller**:
```java
// CustomerProposalController.java

@PutMapping("/{id}/accept")
public ResponseEntity<ProposalDto> acceptProposal(
    @PathVariable Long id,
    @RequestBody(required = false) ProposalActionRequest request,
    Authentication auth) {

    Long customerId = getCurrentUserId(auth);

    // 1. Update proposal status
    Proposal proposal = proposalService.acceptProposal(id, customerId, request);

    // 2. Trigger investment workflow (async)
    investmentWorkflowService.initiateInvestment(proposal);

    // 3. Send notification to RM
    notificationService.notifyProposalAccepted(proposal);

    return ResponseEntity.ok(proposalMapper.toDto(proposal));
}
```

**Service Layer**:
```java
// ProposalService.java

@Transactional
public Proposal acceptProposal(Long proposalId, Long customerId, ProposalActionRequest request) {
    // Validate
    Proposal proposal = proposalRepository.findById(proposalId)
        .orElseThrow(() -> new ResourceNotFoundException("Proposal not found"));

    if (!proposal.getCustomerId().equals(customerId)) {
        throw new ForbiddenException("Not authorized");
    }

    if (proposal.getStatus() != ProposalStatus.PENDING) {
        throw new BadRequestException("Proposal is not in PENDING status");
    }

    if (proposal.getExpiresAt() != null &&
        proposal.getExpiresAt().isBefore(LocalDateTime.now())) {
        throw new BadRequestException("Proposal has expired");
    }

    // Update proposal
    proposal.setStatus(ProposalStatus.ACCEPTED);
    proposal.setRespondedAt(LocalDateTime.now());
    proposal.setUpdatedAt(LocalDateTime.now());

    if (request != null && request.getNote() != null) {
        proposal.setCustomerNote(request.getNote());
    }

    return proposalRepository.save(proposal);
}
```

**Database Changes**:
```sql
-- Before
SELECT id, status, responded_at FROM proposals WHERE id = 123;
-- | id  | status  | responded_at |
-- | 123 | PENDING | NULL         |

-- After
-- | id  | status   | responded_at         |
-- | 123 | ACCEPTED | 2024-03-15 14:30:00 |
```

---

### Step 2: Investment Workflow Initiation

**Async Workflow Service**:
```java
// InvestmentWorkflowService.java

@Service
public class InvestmentWorkflowService {

    @Async
    @Transactional
    public void initiateInvestment(Proposal proposal) {
        log.info("Initiating investment for proposal {}", proposal.getId());

        try {
            // Step 1: Create investment order
            InvestmentOrder order = createOrderFromProposal(proposal);

            // Step 2: Validate order
            validateOrder(order);

            // Step 3: Schedule execution (can be immediate or scheduled)
            if (proposal.getExecutionDate() == null ||
                proposal.getExecutionDate().isBefore(LocalDate.now())) {
                // Execute immediately
                executeOrder(order);
            } else {
                // Schedule for future date
                scheduleOrderExecution(order, proposal.getExecutionDate());
            }

        } catch (Exception e) {
            log.error("Failed to initiate investment: {}", e.getMessage());
            handleInvestmentFailure(proposal, e);
        }
    }

    private InvestmentOrder createOrderFromProposal(Proposal proposal) {
        log.info("Creating investment order from proposal {}", proposal.getId());

        InvestmentOrder order = new InvestmentOrder();
        order.setOrderCode(generateOrderCode());
        order.setProposalId(proposal.getId());
        order.setGoalId(proposal.getGoalId());
        order.setCustomerId(proposal.getCustomerId());
        order.setRmId(proposal.getRmId());
        order.setPortfolioId(extractPortfolioId(proposal));
        order.setOrderType(OrderType.LUMPSUM);
        order.setTotalAmount(extractTotalAmount(proposal));
        order.setOrderStatus(OrderStatus.CREATED);
        order.setOrderDate(LocalDateTime.now());

        order = orderRepository.save(order);

        // Create order executions for each fund
        createOrderExecutions(order, proposal);

        return order;
    }

    private void createOrderExecutions(InvestmentOrder order, Proposal proposal) {
        // Parse distribution data from proposal
        JsonNode distributionData = proposal.getDistributionData();
        JsonNode allocations = distributionData.get("allocations");

        for (JsonNode allocation : allocations) {
            OrderExecution execution = new OrderExecution();
            execution.setOrderId(order.getId());
            execution.setFundCode(allocation.get("fundCode").asText());
            execution.setFundName(allocation.get("fundName").asText());
            execution.setFundIsin(allocation.get("isin").asText());
            execution.setAssetClassId(allocation.get("assetClassId").asLong());
            execution.setAllocationPercentage(
                new BigDecimal(allocation.get("allocationPercentage").asText())
            );
            execution.setInvestedAmount(
                order.getTotalAmount()
                    .multiply(execution.getAllocationPercentage())
                    .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP)
            );
            execution.setExecutionStatus(ExecutionStatus.PENDING);

            executionRepository.save(execution);
        }

        log.info("Created {} order executions for order {}",
            allocations.size(), order.getId());
    }
}
```

**Database State After Order Creation**:
```sql
-- investment_orders table
INSERT INTO investment_orders VALUES (
    1001,                          -- id
    'ORD-2024-001001',            -- order_code
    123,                           -- proposal_id
    50,                            -- goal_id
    101,                           -- customer_id (Priya)
    201,                           -- rm_id (Rajesh)
    10,                            -- portfolio_id (Aggressive)
    'LUMPSUM',                     -- order_type
    100000.00,                     -- total_amount
    'CREATED',                     -- order_status
    '2024-03-15 14:35:00',        -- order_date
    NULL,                          -- executed_at
    NULL,                          -- settled_at
    '2024-03-15 14:35:00',        -- created_at
    '2024-03-15 14:35:00'         -- updated_at
);

-- order_executions table (6 rows, one per fund)
INSERT INTO order_executions VALUES (
    2001,                          -- id
    1001,                          -- order_id
    501,                           -- fund_id
    'HDFC_TOP100',                -- fund_code
    'HDFC Top 100 Fund - Direct Growth',  -- fund_name
    'INF179K01YM1',               -- fund_isin
    1,                             -- asset_class_id (Large Cap Equity)
    'EXE-2024-002001',            -- execution_id (generated)
    30.00,                         -- allocation_percentage
    30000.00,                      -- invested_amount
    NULL,                          -- executed_nav (will be filled)
    NULL,                          -- units_purchased (will be filled)
    0.00,                          -- brokerage
    0.00,                          -- gst
    0.00,                          -- stamp_duty
    0.00,                          -- total_charges
    30000.00,                      -- net_amount
    'PENDING',                     -- execution_status
    'PENDING',                     -- settlement_status
    NULL,                          -- transaction_id
    NULL,                          -- confirmation_number
    NULL,                          -- custodian_reference
    '2024-03-15 14:35:00',        -- execution_time
    NULL,                          -- settlement_date
    NULL,                          -- settled_at
    '2024-03-15 14:35:00'         -- created_at
);

-- (Similar INSERTs for other 5 funds: ICICI_BLUECHIP, AXIS_MIDCAP,
--  SBI_SMALLCAP, HDFC_CORPBOND, KOTAK_LIQUID)
```

---

### Step 3: Order Validation

**Validation Service**:
```java
// OrderValidationService.java

@Service
public class OrderValidationService {

    public ValidationResult validateOrder(InvestmentOrder order) {
        log.info("Validating order {}", order.getOrderCode());

        ValidationResult result = new ValidationResult();

        // Check 1: Customer has sufficient funds
        result.addCheck(validateCustomerFunds(order));

        // Check 2: All funds are available for purchase
        result.addCheck(validateFundsAvailability(order));

        // Check 3: Compliance checks
        result.addCheck(validateCompliance(order));

        // Check 4: Investment limits
        result.addCheck(validateInvestmentLimits(order));

        // Check 5: Proposal validity
        result.addCheck(validateProposalValidity(order));

        if (result.isAllPassed()) {
            order.setOrderStatus(OrderStatus.VALIDATED);
            orderRepository.save(order);
            log.info("Order {} validated successfully", order.getOrderCode());
        } else {
            order.setOrderStatus(OrderStatus.FAILED);
            order.setRejectionReason(result.getFailureReasons());
            orderRepository.save(order);
            log.warn("Order {} validation failed: {}",
                order.getOrderCode(), result.getFailureReasons());
        }

        return result;
    }

    private ValidationCheck validateCustomerFunds(InvestmentOrder order) {
        // In demo: Always pass
        // In production: Check bank account balance via API

        return ValidationCheck.builder()
            .checkType("FUNDS_AVAILABILITY")
            .passed(true)
            .message("Customer has sufficient funds")
            .build();
    }

    private ValidationCheck validateFundsAvailability(InvestmentOrder order) {
        List<OrderExecution> executions = executionRepository.findByOrderId(order.getId());

        for (OrderExecution execution : executions) {
            // Check if fund exists and is active
            Optional<Fund> fundOpt = fundRepository.findByFundCode(execution.getFundCode());

            if (fundOpt.isEmpty() || !fundOpt.get().isActive()) {
                return ValidationCheck.builder()
                    .checkType("FUND_AVAILABILITY")
                    .passed(false)
                    .message("Fund " + execution.getFundCode() + " is not available")
                    .build();
            }
        }

        return ValidationCheck.builder()
            .checkType("FUND_AVAILABILITY")
            .passed(true)
            .message("All funds are available for purchase")
            .build();
    }

    private ValidationCheck validateCompliance(InvestmentOrder order) {
        // Check suitability
        CustomerSuitability suitability = suitabilityRepository
            .findLatestByCustomerId(order.getCustomerId());

        if (suitability == null || suitability.getStatus() != SuitabilityStatus.SUITABLE) {
            return ValidationCheck.builder()
                .checkType("SUITABILITY_COMPLIANCE")
                .passed(false)
                .message("Customer suitability check required")
                .build();
        }

        // Check risk profile alignment
        // (Implementation details...)

        return ValidationCheck.builder()
            .checkType("SUITABILITY_COMPLIANCE")
            .passed(true)
            .message("Compliance checks passed")
            .build();
    }
}
```

**Database Update After Validation**:
```sql
UPDATE investment_orders
SET order_status = 'VALIDATED',
    updated_at = '2024-03-15 14:36:00'
WHERE id = 1001;
```

---

### Step 4: Order Execution

**Execution Service** (Most Critical Part):
```java
// OrderExecutionService.java

@Service
public class OrderExecutionService {

    @Autowired
    private MockCustodianService custodianService;

    @Autowired
    private NAVDataService navService;

    @Autowired
    private HoldingsService holdingsService;

    @Autowired
    private TransactionService transactionService;

    @Transactional
    public ExecutionResult executeOrder(InvestmentOrder order) {
        log.info("Executing order {}", order.getOrderCode());

        ExecutionResult result = new ExecutionResult();
        List<OrderExecution> executions = executionRepository.findByOrderId(order.getId());

        // Set execution date (for demo: immediate, for realism: T+0 or T+1)
        LocalDate executionDate = getExecutionDate();
        LocalDateTime executionTime = LocalDateTime.now();

        for (OrderExecution execution : executions) {
            try {
                // Step 1: Fetch current NAV
                BigDecimal currentNAV = navService.getNAV(
                    execution.getFundCode(),
                    executionDate
                );

                if (currentNAV == null) {
                    log.warn("NAV not found for {}, using default",
                        execution.getFundCode());
                    currentNAV = getDefaultNAV(execution.getFundCode());
                }

                // Step 2: Calculate units
                BigDecimal units = execution.getInvestedAmount()
                    .divide(currentNAV, 4, RoundingMode.HALF_UP);

                // Step 3: Call Mock Custodian
                CustodianExecutionResponse custodianResponse =
                    custodianService.executePurchase(
                        execution.getFundCode(),
                        execution.getInvestedAmount(),
                        currentNAV,
                        units
                    );

                // Step 4: Update execution record
                execution.setExecutedNav(currentNAV);
                execution.setUnitsPurchased(units);
                execution.setExecutionStatus(ExecutionStatus.EXECUTED);
                execution.setTransactionId(custodianResponse.getTransactionId());
                execution.setConfirmationNumber(custodianResponse.getConfirmationNumber());
                execution.setCustodianReference(custodianResponse.getCustodianReference());
                execution.setExecutionTime(executionTime);

                executionRepository.save(execution);

                // Step 5: Update holdings
                holdingsService.addPurchase(
                    order.getCustomerId(),
                    order.getGoalId(),
                    execution.getFundCode(),
                    execution.getFundName(),
                    execution.getFundIsin(),
                    execution.getAssetClassId(),
                    order.getPortfolioId(),
                    units,
                    currentNAV,
                    execution.getInvestedAmount(),
                    executionDate
                );

                // Step 6: Create transaction record
                transactionService.recordTransaction(
                    order.getCustomerId(),
                    order.getGoalId(),
                    order.getId(),
                    execution.getId(),
                    TransactionType.BUY,
                    execution.getFundCode(),
                    execution.getFundName(),
                    units,
                    currentNAV,
                    execution.getInvestedAmount(),
                    executionDate,
                    executionTime
                );

                result.addSuccessfulExecution(execution);

            } catch (Exception e) {
                log.error("Failed to execute {} for order {}: {}",
                    execution.getFundCode(), order.getOrderCode(), e.getMessage());

                execution.setExecutionStatus(ExecutionStatus.FAILED);
                execution.setFailureReason(e.getMessage());
                executionRepository.save(execution);

                result.addFailedExecution(execution, e.getMessage());
            }
        }

        // Update order status
        if (result.isAllSuccessful()) {
            order.setOrderStatus(OrderStatus.EXECUTED);
            order.setExecutedAt(executionTime);
        } else if (result.hasPartialSuccess()) {
            order.setOrderStatus(OrderStatus.PARTIALLY_EXECUTED);
            order.setExecutedAt(executionTime);
        } else {
            order.setOrderStatus(OrderStatus.FAILED);
        }

        orderRepository.save(order);

        log.info("Order {} execution complete: {}/{} successful",
            order.getOrderCode(),
            result.getSuccessfulCount(),
            executions.size());

        return result;
    }

    private LocalDate getExecutionDate() {
        // For demo: Use scheduled date or current date
        // For production: Consider market hours, holidays, etc.
        LocalDate today = LocalDate.now();

        // Check if market is open (simplified)
        if (today.getDayOfWeek() == DayOfWeek.SATURDAY ||
            today.getDayOfWeek() == DayOfWeek.SUNDAY) {
            // Next Monday
            return today.plusDays(
                8 - today.getDayOfWeek().getValue()
            );
        }

        return today;
    }
}
```

**Mock Custodian Service**:
```java
// MockCustodianService.java

@Service
public class MockCustodianService {

    public CustodianExecutionResponse executePurchase(
        String fundCode,
        BigDecimal amount,
        BigDecimal nav,
        BigDecimal units) {

        log.info("Mock Custodian: Executing purchase of {} units of {} @ {}",
            units, fundCode, nav);

        // Simulate custodian processing (instant for demo)
        // In production: This would be an HTTP call to real custodian API

        String transactionId = generateTransactionId();
        String confirmationNumber = generateConfirmationNumber(fundCode);
        String custodianReference = generateCustodianReference();

        // Simulate small delay
        try {
            Thread.sleep(100);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        CustodianExecutionResponse response = new CustodianExecutionResponse();
        response.setStatus("SUCCESS");
        response.setTransactionId(transactionId);
        response.setConfirmationNumber(confirmationNumber);
        response.setCustodianReference(custodianReference);
        response.setExecutedNAV(nav);
        response.setExecutedUnits(units);
        response.setExecutedAmount(amount);
        response.setExecutionTime(LocalDateTime.now());
        response.setMessage("Order executed successfully");

        log.info("Mock Custodian: Execution successful - TXN: {}, CONF: {}",
            transactionId, confirmationNumber);

        return response;
    }

    private String generateTransactionId() {
        return "TXN-" + LocalDate.now().format(DateTimeFormatter.BASIC_ISO_DATE)
            + "-" + RandomStringUtils.randomNumeric(6);
    }

    private String generateConfirmationNumber(String fundCode) {
        return "CONF-" + fundCode + "-" + System.currentTimeMillis();
    }

    private String generateCustodianReference() {
        return "CUST-REF-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }
}
```

**NAV Data Service**:
```java
// NAVDataService.java

@Service
public class NAVDataService {

    private static final String MFAPI_BASE_URL = "https://api.mfapi.in/mf";

    @Autowired
    private RestTemplate restTemplate;

    @Autowired
    private FundNavHistoryRepository navHistoryRepo;

    @Autowired
    private MockNAVGenerator mockNAVGenerator;

    /**
     * Get NAV for a specific date
     * Priority: 1) Database cache, 2) MFapi.in, 3) Mock generation
     */
    public BigDecimal getNAV(String fundCode, LocalDate date) {
        // Try database first
        Optional<FundNavHistory> cachedNav = navHistoryRepo
            .findByFundCodeAndNavDate(fundCode, date);

        if (cachedNav.isPresent()) {
            log.debug("Found NAV in cache for {} on {}: {}",
                fundCode, date, cachedNav.get().getNav());
            return cachedNav.get().getNav();
        }

        // If recent date (within 7 days), try MFapi.in
        if (date.isAfter(LocalDate.now().minusDays(7))) {
            BigDecimal liveNAV = fetchFromMFApi(fundCode, date);
            if (liveNAV != null) {
                return liveNAV;
            }
        }

        // Fallback: Generate mock NAV
        log.info("Generating mock NAV for {} on {}", fundCode, date);
        return mockNAVGenerator.generateNAV(fundCode, date);
    }

    private BigDecimal fetchFromMFApi(String fundCode, LocalDate date) {
        try {
            // Map internal fund code to MFapi scheme code
            String schemeCode = mapToSchemeCode(fundCode);
            if (schemeCode == null) {
                return null;
            }

            String url = MFAPI_BASE_URL + "/" + schemeCode;

            MFApiResponse response = restTemplate.getForObject(url, MFApiResponse.class);

            if (response != null && "SUCCESS".equals(response.getStatus())) {
                // Find NAV for the date
                for (NavData navData : response.getData()) {
                    LocalDate navDate = parseDate(navData.getDate());
                    if (navDate.equals(date)) {
                        BigDecimal nav = new BigDecimal(navData.getNav());

                        // Save to cache
                        saveFundNavHistory(fundCode, navDate, nav, "MFAPI");

                        return nav;
                    }
                }
            }
        } catch (Exception e) {
            log.error("Failed to fetch NAV from MFapi: {}", e.getMessage());
        }

        return null;
    }

    private String mapToSchemeCode(String fundCode) {
        // Map internal codes to MFapi scheme codes
        Map<String, String> mapping = Map.of(
            "HDFC_TOP100", "120503",
            "ICICI_BLUECHIP", "120305",
            "AXIS_MIDCAP", "120510"
            // ... more mappings
        );

        return mapping.get(fundCode);
    }
}
```

**Holdings Service - Add Purchase**:
```java
// HoldingsService.java

@Service
public class HoldingsService {

    @Transactional
    public Holdings addPurchase(
        Long customerId,
        Long goalId,
        String fundCode,
        String fundName,
        String fundIsin,
        Long assetClassId,
        Long portfolioId,
        BigDecimal units,
        BigDecimal nav,
        BigDecimal investedAmount,
        LocalDate purchaseDate) {

        log.info("Adding purchase: customer={}, fund={}, units={}, nav={}",
            customerId, fundCode, units, nav);

        // Check if holding exists
        Optional<Holdings> existingOpt = holdingsRepo
            .findByCustomerIdAndFundCodeAndGoalId(customerId, fundCode, goalId);

        if (existingOpt.isPresent()) {
            // Update existing holding
            Holdings holding = existingOpt.get();

            // Calculate new average NAV (weighted average)
            BigDecimal oldTotalInvested = holding.getTotalInvested();
            BigDecimal oldTotalUnits = holding.getTotalUnits();

            BigDecimal newTotalInvested = oldTotalInvested.add(investedAmount);
            BigDecimal newTotalUnits = oldTotalUnits.add(units);

            // Weighted average NAV = Total Invested / Total Units
            BigDecimal newAverageNAV = newTotalInvested
                .divide(newTotalUnits, 4, RoundingMode.HALF_UP);

            holding.setTotalUnits(newTotalUnits);
            holding.setAverageNav(newAverageNAV);
            holding.setTotalInvested(newTotalInvested);
            holding.setLastPurchaseDate(purchaseDate);
            holding.setPurchaseCount(holding.getPurchaseCount() + 1);
            holding.setUpdatedAt(LocalDateTime.now());

            // Update current value (using latest NAV)
            BigDecimal currentValue = newTotalUnits.multiply(nav)
                .setScale(2, RoundingMode.HALF_UP);
            holding.setCurrentNav(nav);
            holding.setCurrentValue(currentValue);

            // Calculate gain
            BigDecimal unrealizedGain = currentValue.subtract(newTotalInvested);
            BigDecimal gainPercentage = unrealizedGain
                .divide(newTotalInvested, 4, RoundingMode.HALF_UP)
                .multiply(BigDecimal.valueOf(100));

            holding.setUnrealizedGain(unrealizedGain);
            holding.setUnrealizedGainPercentage(gainPercentage);
            holding.setLastNavUpdateDate(purchaseDate);

            log.info("Updated holding: totalUnits={}, avgNAV={}, totalInvested={}",
                newTotalUnits, newAverageNAV, newTotalInvested);

            return holdingsRepo.save(holding);

        } else {
            // Create new holding
            Holdings holding = new Holdings();
            holding.setCustomerId(customerId);
            holding.setGoalId(goalId);
            holding.setFundCode(fundCode);
            holding.setFundName(fundName);
            holding.setFundIsin(fundIsin);
            holding.setAssetClassId(assetClassId);
            holding.setPortfolioId(portfolioId);

            holding.setTotalUnits(units);
            holding.setAverageNav(nav);
            holding.setTotalInvested(investedAmount);

            holding.setCurrentNav(nav);
            holding.setCurrentValue(investedAmount);  // Initially same as invested

            holding.setUnrealizedGain(BigDecimal.ZERO);  // No gain on day 1
            holding.setUnrealizedGainPercentage(BigDecimal.ZERO);

            holding.setFirstPurchaseDate(purchaseDate);
            holding.setLastPurchaseDate(purchaseDate);
            holding.setLastNavUpdateDate(purchaseDate);
            holding.setPurchaseCount(1);

            holding.setCreatedAt(LocalDateTime.now());
            holding.setUpdatedAt(LocalDateTime.now());

            log.info("Created new holding: units={}, nav={}, invested={}",
                units, nav, investedAmount);

            return holdingsRepo.save(holding);
        }
    }
}
```

**Database State After Execution** (March 18, 2024):

```sql
-- order_executions updated with NAV and units
UPDATE order_executions
SET executed_nav = 500.00,
    units_purchased = 60.0000,
    execution_status = 'EXECUTED',
    transaction_id = 'TXN-20240318-123456',
    confirmation_number = 'CONF-HDFC_TOP100-1710758400000',
    custodian_reference = 'CUST-REF-A1B2C3D4',
    execution_time = '2024-03-18 10:30:00'
WHERE id = 2001 AND fund_code = 'HDFC_TOP100';

-- Similar updates for other 5 funds with their respective NAVs:
-- ICICI_BLUECHIP: NAV 250.00, Units 100.0000
-- AXIS_MIDCAP: NAV 150.00, Units 100.0000
-- SBI_SMALLCAP: NAV 100.00, Units 100.0000
-- HDFC_CORPBOND: NAV 50.00, Units 300.0000
-- KOTAK_LIQUID: NAV 25.00, Units 200.0000

-- investment_orders updated
UPDATE investment_orders
SET order_status = 'EXECUTED',
    executed_at = '2024-03-18 10:30:00',
    updated_at = '2024-03-18 10:30:00'
WHERE id = 1001;

-- holdings table (6 new rows created)
INSERT INTO holdings VALUES
(1, 101, 50, 'HDFC_TOP100', 'HDFC Top 100 Fund - Direct Growth',
 'INF179K01YM1', 1, 10,
 60.0000, 500.00, 30000.00,
 500.00, 30000.00,
 0.00, 0.00,
 '2024-03-18', '2024-03-18', '2024-03-18', 1,
 '2024-03-18 10:30:00', '2024-03-18 10:30:00');

-- (Similar rows for other 5 funds)

-- transactions table (6 new rows)
INSERT INTO transactions VALUES
(3001, 'TXN-2024-003001', 101, 50, 1001, 2001, 1,
 'BUY', '2024-03-18', '2024-03-18 10:30:00',
 'HDFC_TOP100', 'HDFC Top 100 Fund - Direct Growth',
 60.0000, 500.00, 30000.00, 0.00, 30000.00,
 'SETTLED', '2024-03-18 10:30:00');

-- (Similar rows for other 5 funds)
```

---

### Step 5: Settlement

**Settlement Service** (For Demo: Immediate T+0, For Realism: T+1):
```java
// SettlementService.java

@Service
public class SettlementService {

    @Transactional
    public void settleOrder(InvestmentOrder order) {
        log.info("Settling order {}", order.getOrderCode());

        List<OrderExecution> executions = executionRepository
            .findByOrderIdAndExecutionStatus(order.getId(), ExecutionStatus.EXECUTED);

        LocalDate settlementDate = calculateSettlementDate(order.getExecutedAt());

        for (OrderExecution execution : executions) {
            execution.setSettlementStatus(SettlementStatus.SETTLED);
            execution.setSettlementDate(settlementDate);
            execution.setSettledAt(LocalDateTime.now());

            executionRepository.save(execution);
        }

        order.setOrderStatus(OrderStatus.SETTLED);
        order.setSettledAt(LocalDateTime.now());
        orderRepository.save(order);

        log.info("Order {} settled successfully on {}",
            order.getOrderCode(), settlementDate);
    }

    private LocalDate calculateSettlementDate(LocalDateTime executionTime) {
        // For demo: T+0 (same day)
        // For realism: T+1 (next business day)

        boolean useRealisticSettlement = false;  // Config flag

        if (!useRealisticSettlement) {
            return executionTime.toLocalDate();  // T+0
        }

        // T+1 logic
        LocalDate settlementDate = executionTime.toLocalDate().plusDays(1);

        // Skip weekends
        while (settlementDate.getDayOfWeek() == DayOfWeek.SATURDAY ||
               settlementDate.getDayOfWeek() == DayOfWeek.SUNDAY) {
            settlementDate = settlementDate.plusDays(1);
        }

        return settlementDate;
    }
}
```

**Database Update**:
```sql
UPDATE order_executions
SET settlement_status = 'SETTLED',
    settlement_date = '2024-03-18',
    settled_at = '2024-03-18 10:31:00'
WHERE order_id = 1001;

UPDATE investment_orders
SET order_status = 'SETTLED',
    settled_at = '2024-03-18 10:31:00'
WHERE id = 1001;
```

---

### Step 6: SIP Schedule Creation

**SIP Service**:
```java
// SIPService.java

@Service
public class SIPService {

    @Transactional
    public SipSchedule createSIPFromOrder(InvestmentOrder order,
                                           BigDecimal sipAmount,
                                           int sipDate,
                                           LocalDate startDate) {
        log.info("Creating SIP schedule for order {}", order.getOrderCode());

        SipSchedule sip = new SipSchedule();
        sip.setSipCode(generateSIPCode());
        sip.setCustomerId(order.getCustomerId());
        sip.setGoalId(order.getGoalId());
        sip.setPortfolioId(order.getPortfolioId());
        sip.setSourceOrderId(order.getId());

        sip.setSipAmount(sipAmount);
        sip.setSipDate(sipDate);
        sip.setFrequency(SipFrequency.MONTHLY);

        sip.setStartDate(startDate);
        sip.setEndDate(null);  // Perpetual until cancelled
        sip.setNextExecutionDate(calculateNextExecutionDate(startDate, sipDate));

        sip.setStatus(SipStatus.ACTIVE);
        sip.setTotalInstallmentsExecuted(0);
        sip.setTotalAmountInvested(BigDecimal.ZERO);

        sip.setCreatedAt(LocalDateTime.now());
        sip.setUpdatedAt(LocalDateTime.now());

        sip = sipRepository.save(sip);

        log.info("SIP created: code={}, amount={}, date={}, next={}",
            sip.getSipCode(), sipAmount, sipDate, sip.getNextExecutionDate());

        return sip;
    }

    private LocalDate calculateNextExecutionDate(LocalDate startDate, int sipDate) {
        LocalDate today = LocalDate.now();

        if (today.isBefore(startDate)) {
            // If start date is in future, use it
            return startDate;
        }

        // Next month's SIP date
        LocalDate nextDate = today.withDayOfMonth(sipDate);
        if (nextDate.isBefore(today) || nextDate.equals(today)) {
            nextDate = nextDate.plusMonths(1);
        }

        // Skip weekends
        while (nextDate.getDayOfWeek() == DayOfWeek.SATURDAY ||
               nextDate.getDayOfWeek() == DayOfWeek.SUNDAY) {
            nextDate = nextDate.plusDays(1);
        }

        return nextDate;
    }
}
```

**Database State**:
```sql
INSERT INTO sip_schedules VALUES (
    5001,                          -- id
    'SIP-2024-005001',            -- sip_code
    101,                           -- customer_id (Priya)
    50,                            -- goal_id
    10,                            -- portfolio_id
    1001,                          -- source_order_id
    2000.00,                       -- sip_amount
    18,                            -- sip_date (18th of each month)
    'MONTHLY',                     -- frequency
    '2024-04-18',                 -- start_date
    NULL,                          -- end_date (perpetual)
    '2024-04-18',                 -- next_execution_date
    'ACTIVE',                      -- status
    NULL,                          -- pause_reason
    NULL,                          -- cancelled_reason
    0,                             -- total_installments_executed
    0.00,                          -- total_amount_invested
    NULL,                          -- last_execution_date
    '2024-03-18 10:32:00',        -- created_at
    '2024-03-18 10:32:00'         -- updated_at
);
```

---

## 4. Database State Evolution

Let me show the complete database state at different points in time:

### March 18, 2024 (Initial Investment Day)

**holdings table**:
```
| id | customer_id | goal_id | fund_code      | total_units | average_nav | total_invested | current_nav | current_value | unrealized_gain | gain_% | first_purchase | last_purchase | purchase_count |
|----|-------------|---------|----------------|-------------|-------------|----------------|-------------|---------------|-----------------|--------|----------------|---------------|----------------|
| 1  | 101         | 50      | HDFC_TOP100    | 60.0000     | 500.00      | 30000.00       | 500.00      | 30000.00      | 0.00            | 0.00   | 2024-03-18     | 2024-03-18    | 1              |
| 2  | 101         | 50      | ICICI_BLUECHIP | 100.0000    | 250.00      | 25000.00       | 250.00      | 25000.00      | 0.00            | 0.00   | 2024-03-18     | 2024-03-18    | 1              |
| 3  | 101         | 50      | AXIS_MIDCAP    | 100.0000    | 150.00      | 15000.00       | 150.00      | 15000.00      | 0.00            | 0.00   | 2024-03-18     | 2024-03-18    | 1              |
| 4  | 101         | 50      | SBI_SMALLCAP   | 100.0000    | 100.00      | 10000.00       | 100.00      | 10000.00      | 0.00            | 0.00   | 2024-03-18     | 2024-03-18    | 1              |
| 5  | 101         | 50      | HDFC_CORPBOND  | 300.0000    | 50.00       | 15000.00       | 50.00       | 15000.00      | 0.00            | 0.00   | 2024-03-18     | 2024-03-18    | 1              |
| 6  | 101         | 50      | KOTAK_LIQUID   | 200.0000    | 25.00       | 5000.00        | 25.00       | 5000.00       | 0.00            | 0.00   | 2024-03-18     | 2024-03-18    | 1              |

Total Invested: ₹1,00,000
Current Value: ₹1,00,000
Gain: ₹0 (0%)
```

### April 18, 2024 (After 1st SIP)

**SIP execution creates 6 new transactions**:
```sql
-- HDFC_TOP100: ₹600 @ NAV 510.00 = 1.1765 units
-- ICICI_BLUECHIP: ₹500 @ NAV 255.00 = 1.9608 units
-- AXIS_MIDCAP: ₹300 @ NAV 153.00 = 1.9608 units
-- SBI_SMALLCAP: ₹200 @ NAV 102.00 = 1.9608 units
-- HDFC_CORPBOND: ₹300 @ NAV 50.50 = 5.9406 units
-- KOTAK_LIQUID: ₹100 @ NAV 25.10 = 3.9841 units
```

**holdings table updated** (with average NAV calculation):
```
| id | customer_id | fund_code      | total_units | average_nav | total_invested | current_nav | current_value | unrealized_gain | gain_% | purchase_count |
|----|-------------|----------------|-------------|-------------|----------------|-------------|---------------|-----------------|--------|----------------|
| 1  | 101         | HDFC_TOP100    | 61.1765     | 500.98      | 30600.00       | 510.00      | 31200.00      | 600.00          | 1.96   | 2              |
| 2  | 101         | ICICI_BLUECHIP | 101.9608    | 250.49      | 25500.00       | 255.00      | 26000.00      | 500.00          | 1.96   | 2              |
```

**Calculation for average NAV** (HDFC_TOP100):
```
Old: 60.0000 units @ 500.00 = ₹30,000
New: 1.1765 units @ 510.00 = ₹600
Total: 61.1765 units, Total Invested: ₹30,600
Average NAV = ₹30,600 / 61.1765 = ₹500.98
```

This continues for 22 months...

I'll continue in the next file with the complete walkthrough including monthly SIPs, daily NAV updates, and current state (Jan 8, 2026).
