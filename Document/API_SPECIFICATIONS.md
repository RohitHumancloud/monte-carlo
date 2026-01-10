# GBA System - API Specifications

## RESTful API Documentation

**Version:** 1.0 Final
**Date:** December 24, 2025
**Base URL:** `/api/v1`
**Authentication:** JWT Bearer Token

---

## Table of Contents

1. [Overview](#overview)
2. [Authentication](#authentication)
3. [Standard Response Format](#standard-response-format)
4. [Error Codes](#error-codes)
5. [API Endpoints](#api-endpoints)
   - [Authentication & User Management](#1-authentication--user-management)
   - [Super Admin - Questionnaire Configuration](#2-super-admin---questionnaire-configuration)
   - [Super Admin - Portfolio Configuration](#3-super-admin---portfolio-configuration)
   - [Super Admin - Risk Categories](#4-super-admin---risk-categories)
   - [RM - Customer Management](#5-rm---customer-management)
   - [RM - Goal Management](#6-rm---goal-management)
   - [RM - Risk Profile Assessment](#7-rm---risk-profile-assessment)
   - [RM - Suitability Assessment](#8-rm---suitability-assessment)
   - [RM - Financial Calculator](#9-rm---financial-calculator)
   - [RM - Portfolio Simulation](#10-rm---portfolio-simulation)
   - [RM - Order Management](#11-rm---order-management)
   - [Journey Tracking](#12-journey-tracking)

---

## Overview

### API Design Principles

- **RESTful**: Resource-based URLs, standard HTTP methods
- **Stateless**: JWT token-based authentication
- **Versioned**: `/api/v1/` prefix for versioning
- **JSON**: All requests and responses use JSON format
- **Consistent**: Standard response structure across all endpoints
- **Documented**: OpenAPI 3.0 compliant

### HTTP Methods

| Method | Usage                                   |
| ------ | --------------------------------------- |
| GET    | Retrieve resources                      |
| POST   | Create new resources                    |
| PUT    | Update existing resources (full update) |
| PATCH  | Partial update of resources             |
| DELETE | Remove resources                        |

### HTTP Status Codes

| Code | Meaning               | Usage                      |
| ---- | --------------------- | -------------------------- |
| 200  | OK                    | Successful GET, PUT, PATCH |
| 201  | Created               | Successful POST            |
| 204  | No Content            | Successful DELETE          |
| 400  | Bad Request           | Validation errors          |
| 401  | Unauthorized          | Missing or invalid token   |
| 403  | Forbidden             | Insufficient permissions   |
| 404  | Not Found             | Resource not found         |
| 409  | Conflict              | Duplicate resource         |
| 422  | Unprocessable Entity  | Business logic error       |
| 500  | Internal Server Error | Server error               |

---

## Authentication

### JWT Token Authentication

All API endpoints (except `/auth/login` and `/auth/register`) require a valid JWT token in the Authorization header.

**Header:**

```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Token Payload:**

```json
{
  "sub": "user@example.com",
  "userId": 123,
  "role": "RM",
  "iat": 1703433600,
  "exp": 1703520000
}
```

**Token Expiry:**

- Access Token: 1 hour
- Refresh Token: 7 days

---

## Standard Response Format

### Success Response

```json
{
  "success": true,
  "message": "Operation successful",
  "data": {
    // Response data
  },
  "timestamp": "2025-12-24T10:30:00Z"
}
```

### Error Response

```json
{
  "success": false,
  "message": "Validation failed",
  "errors": [
    {
      "field": "email",
      "message": "Email is required",
      "code": "REQUIRED_FIELD"
    }
  ],
  "timestamp": "2025-12-24T10:30:00Z"
}
```

### Paginated Response

```json
{
  "success": true,
  "message": "Data retrieved successfully",
  "data": {
    "content": [
      /* array of items */
    ],
    "page": 0,
    "size": 20,
    "totalElements": 150,
    "totalPages": 8,
    "first": true,
    "last": false
  },
  "timestamp": "2025-12-24T10:30:00Z"
}
```

---

## Error Codes

| Code                      | Description                        |
| ------------------------- | ---------------------------------- |
| `REQUIRED_FIELD`          | Required field is missing          |
| `INVALID_FORMAT`          | Field format is invalid            |
| `OUT_OF_RANGE`            | Value is out of acceptable range   |
| `DUPLICATE_ENTRY`         | Resource already exists            |
| `NOT_FOUND`               | Resource not found                 |
| `UNAUTHORIZED`            | Authentication failed              |
| `FORBIDDEN`               | Insufficient permissions           |
| `EXPIRED_TOKEN`           | JWT token has expired              |
| `INVALID_TOKEN`           | JWT token is invalid               |
| `BUSINESS_RULE_VIOLATION` | Business logic constraint violated |

---

## API Endpoints

## 1. Authentication & User Management

### 1.1 Register User

**Endpoint:** `POST /api/v1/auth/register`
**Access:** Public
**Description:** Register a new user (RM or Customer)

**Request Body:**

```json
{
  "email": "rm@scb.com",
  "password": "SecureP@ss123",
  "confirmPassword": "SecureP@ss123",
  "firstName": "John",
  "lastName": "Doe",
  "phoneNumber": "+919876543210",
  "roleCode": "RM",

  // RM-specific fields (if roleCode = RM)
  "employeeId": "EMP001",
  "branchCode": "BR123",
  "icLicenseNumber": "IC12345",
  "icLicenseExpiry": "2026-12-31",

  // Customer-specific fields (if roleCode = CUSTOMER)
  "dateOfBirth": "1990-05-15"
}
```

**Response:** `201 Created`

```json
{
  "success": true,
  "message": "User registered successfully. Please verify your email.",
  "data": {
    "userId": 123,
    "email": "rm@scb.com",
    "role": "RM",
    "emailVerificationSent": true
  },
  "timestamp": "2025-12-24T10:30:00Z"
}
```

**Validation Rules:**

- Email: Valid format, unique
- Password: Min 8 chars, 1 uppercase, 1 lowercase, 1 digit, 1 special char
- Phone: Valid format
- Employee ID (RM): Unique
- PAN Number (Customer): Valid format, unique

---

### 1.2 Login

**Endpoint:** `POST /api/v1/auth/login`
**Access:** Public
**Description:** Authenticate user and receive JWT tokens

**Request Body:**

```json
{
  "email": "rm@scb.com",
  "password": "SecureP@ss123"
}
```

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "tokenType": "Bearer",
    "expiresIn": 3600,
    "user": {
      "id": 123,
      "email": "rm@scb.com",
      "firstName": "John",
      "lastName": "Doe",
      "role": "RM"
    }
  },
  "timestamp": "2025-12-24T10:30:00Z"
}
```

---

### 1.3 Refresh Token

**Endpoint:** `POST /api/v1/auth/refresh-token`
**Access:** Public (requires refresh token)
**Description:** Get new access token using refresh token

**Request Body:**

```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Token refreshed successfully",
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresIn": 3600
  },
  "timestamp": "2025-12-24T10:30:00Z"
}
```

---

### 1.4 Logout

**Endpoint:** `POST /api/v1/auth/logout`
**Access:** Authenticated
**Description:** Invalidate current tokens

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Logged out successfully",
  "timestamp": "2025-12-24T10:30:00Z"
}
```

---

### 1.5 Get User Profile

**Endpoint:** `GET /api/v1/users/profile`
**Access:** Authenticated
**Description:** Get current user's profile

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Profile retrieved successfully",
  "data": {
    "id": 123,
    "email": "rm@scb.com",
    "firstName": "John",
    "lastName": "Doe",
    "phoneNumber": "+919876543210",
    "role": {
      "code": "RM",
      "name": "Relationship Manager"
    },
    "isEmailVerified": true,
    "lastLoginAt": "2025-12-24T09:00:00Z",
    "createdAt": "2025-01-01T10:00:00Z",

    // RM-specific
    "rmProfile": {
      "employeeId": "EMP001",
      "branchCode": "BR123",
      "icLicenseNumber": "IC12345",
      "icLicenseExpiry": "2026-12-31"
    }
  },
  "timestamp": "2025-12-24T10:30:00Z"
}
```

---

### 1.6 Update Profile

**Endpoint:** `PUT /api/v1/users/profile`
**Access:** Authenticated
**Description:** Update current user's profile

**Request Body:**

```json
{
  "firstName": "John",
  "lastName": "Smith",
  "phoneNumber": "+919876543210"
}
```

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Profile updated successfully",
  "data": {
    "id": 123,
    "email": "rm@scb.com",
    "firstName": "John",
    "lastName": "Smith",
    "phoneNumber": "+919876543210"
  },
  "timestamp": "2025-12-24T10:30:00Z"
}
```

---

### 1.7 Change Password

**Endpoint:** `POST /api/v1/users/change-password`
**Access:** Authenticated
**Description:** Change user password

**Request Body:**

```json
{
  "currentPassword": "OldP@ss123",
  "newPassword": "NewP@ss456",
  "confirmNewPassword": "NewP@ss456"
}
```

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Password changed successfully",
  "timestamp": "2025-12-24T10:30:00Z"
}
```

---

### 1.8 Verify Email

**Endpoint:** `GET /api/v1/auth/verify-email/:token`
**Access:** Public
**Description:** Verify email address using token from email

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Email verified successfully",
  "timestamp": "2025-12-24T10:30:00Z"
}
```

---

### 1.9 Forgot Password

**Endpoint:** `POST /api/v1/auth/forgot-password`
**Access:** Public
**Description:** Request password reset email

**Request Body:**

```json
{
  "email": "user@example.com"
}
```

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Password reset email sent successfully. Please check your email.",
  "data": {
    "email": "user@example.com",
    "resetLinkExpiresIn": 3600
  },
  "timestamp": "2025-12-24T10:30:00Z"
}
```

---

### 1.10 Reset Password

**Endpoint:** `POST /api/v1/auth/reset-password/:token`
**Access:** Public
**Description:** Reset password using token from email

**Request Body:**

```json
{
  "newPassword": "NewP@ss123",
  "confirmPassword": "NewP@ss123"
}
```

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Password reset successfully. You can now login with your new password.",
  "timestamp": "2025-12-24T10:30:00Z"
}
```

---

### 1.11 Resend Verification Email

**Endpoint:** `POST /api/v1/auth/resend-verification`
**Access:** Public
**Description:** Resend email verification link

**Request Body:**

```json
{
  "email": "user@example.com"
}
```

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Verification email sent successfully",
  "timestamp": "2025-12-24T10:30:00Z"
}
```

---

### 1.12 Check Email Availability

**Endpoint:** `GET /api/v1/auth/check-email/:email`
**Access:** Public
**Description:** Check if email is already registered

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Email availability checked",
  "data": {
    "email": "test@example.com",
    "available": false
  },
  "timestamp": "2025-12-24T10:30:00Z"
}
```

---

## 2. Super Admin - User Management

### 2.1 Get All Users

**Endpoint:** `GET /api/v1/admin/users`
**Access:** SUPER_ADMIN
**Description:** Get all users with filtering

**Query Parameters:**

- `role` (optional): Filter by role (RM, CUSTOMER)
- `status` (optional): Filter by active/inactive
- `search` (optional): Search by name/email
- `page`, `size`

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Users retrieved successfully",
  "data": {
    "content": [
      {
        "id": 123,
        "email": "rm@scb.com",
        "firstName": "John",
        "lastName": "Doe",
        "role": {
          "code": "RM",
          "name": "Relationship Manager"
        },
        "isActive": true,
        "isEmailVerified": true,
        "lastLoginAt": "2025-12-24T09:00:00Z",
        "createdAt": "2025-01-01T10:00:00Z"
      }
    ],
    "page": 0,
    "size": 20,
    "totalElements": 150
  },
  "timestamp": "2025-12-24T10:30:00Z"
}
```

---

### 2.2 Get User Details

**Endpoint:** `GET /api/v1/admin/users/:id`
**Access:** SUPER_ADMIN
**Description:** Get detailed user information

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "User details retrieved successfully",
  "data": {
    "id": 123,
    "email": "rm@scb.com",
    "firstName": "John",
    "lastName": "Doe",
    "phoneNumber": "+919876543210",
    "role": {
      "code": "RM",
      "name": "Relationship Manager"
    },
    "isActive": true,
    "isEmailVerified": true,
    "lastLoginAt": "2025-12-24T09:00:00Z",
    "createdAt": "2025-01-01T10:00:00Z",
    "rmProfile": {
      "employeeId": "EMP001",
      "branchCode": "BR123",
      "currentCustomerCount": 45,
      "maxCustomers": 100
    }
  },
  "timestamp": "2025-12-24T10:30:00Z"
}
```

---

### 2.3 Update User

**Endpoint:** `PUT /api/v1/admin/users/:id`
**Access:** SUPER_ADMIN
**Description:** Update user details

**Request Body:**

```json
{
  "firstName": "John",
  "lastName": "Smith",
  "phoneNumber": "+919876543210",
  "isActive": true
}
```

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "User updated successfully",
  "data": {
    "id": 123,
    "email": "rm@scb.com",
    "firstName": "John",
    "lastName": "Smith",
    "updatedAt": "2025-12-24T10:35:00Z"
  },
  "timestamp": "2025-12-24T10:35:00Z"
}
```

---

### 2.4 Activate/Deactivate User

**Endpoint:** `PATCH /api/v1/admin/users/:id/status`
**Access:** SUPER_ADMIN
**Description:** Activate or deactivate user account

**Request Body:**

```json
{
  "isActive": false,
  "reason": "Account suspended due to policy violation"
}
```

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "User status updated successfully",
  "data": {
    "id": 123,
    "email": "rm@scb.com",
    "isActive": false,
    "updatedAt": "2025-12-24T10:40:00Z"
  },
  "timestamp": "2025-12-24T10:40:00Z"
}
```

---

### 2.5 Delete User

**Endpoint:** `DELETE /api/v1/admin/users/:id`
**Access:** SUPER_ADMIN
**Description:** Soft delete user (sets isDeleted = true)

**Response:** `204 No Content`

---

### 2.6 Get All RMs

**Endpoint:** `GET /api/v1/admin/rms`
**Access:** SUPER_ADMIN
**Description:** Get all relationship managers

**Query Parameters:**

- `branchCode` (optional)
- `status` (optional)
- `page`, `size`

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Relationship managers retrieved successfully",
  "data": {
    "content": [
      {
        "id": 5,
        "userId": 123,
        "employeeId": "EMP001",
        "name": "John Doe",
        "email": "rm@scb.com",
        "branchCode": "BR123",
        "branchName": "Mumbai Central",
        "currentCustomerCount": 45,
        "maxCustomers": 100,
        "status": "ACTIVE",
        "isActive": true
      }
    ],
    "page": 0,
    "size": 20,
    "totalElements": 25
  },
  "timestamp": "2025-12-24T10:45:00Z"
}
```

---

### 2.7 Get RM Details

**Endpoint:** `GET /api/v1/admin/rms/:id`
**Access:** SUPER_ADMIN
**Description:** Get detailed RM information with customer list

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "RM details retrieved successfully",
  "data": {
    "id": 5,
    "employeeId": "EMP001",
    "name": "John Doe",
    "email": "rm@scb.com",
    "phoneNumber": "+919876543210",
    "branchCode": "BR123",
    "branchName": "Mumbai Central",
    "department": "Wealth Management",
    "designation": "Senior RM",
    "currentCustomerCount": 45,
    "maxCustomers": 100,
    "status": "ACTIVE",
    "customers": [
      {
        "customerId": 50,
        "customerCode": "CUS001",
        "name": "Raj Kumar",
        "email": "raj@email.com",
        "journeyStage": "PORTFOLIO_MATCHING"
      }
    ]
  },
  "timestamp": "2025-12-24T10:50:00Z"
}
```

---

### 2.8 Get Dashboard Statistics

**Endpoint:** `GET /api/v1/admin/dashboard/stats`
**Access:** SUPER_ADMIN
**Description:** Get system-wide statistics

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Dashboard statistics retrieved successfully",
  "data": {
    "totalUsers": 523,
    "totalRMs": 25,
    "totalCustomers": 498,
    "activeCustomers": 450,
    "totalGoals": 1250,
    "activeGoals": 980,
    "totalAssessments": 600,
    "completedAssessments": 520,
    "pendingAssessments": 80,
    "totalInvestment": 250000000,
    "totalOrders": 1500,
    "todayOrders": 25
  },
  "timestamp": "2025-12-24T11:00:00Z"
}
```

---

## 3. Super Admin - Questionnaire Configuration

### 3.1 Get Questionnaire Types

**Endpoint:** `GET /api/v1/admin/questionnaire-types`
**Access:** SUPER_ADMIN
**Description:** Get all questionnaire types

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Questionnaire types retrieved successfully",
  "data": [
    {
      "id": 1,
      "typeCode": "RISK_PROFILE",
      "typeName": "Risk Profile Assessment",
      "description": "Evaluate customer risk tolerance",
      "isActive": true
    },
    {
      "id": 2,
      "typeCode": "SUITABILITY",
      "typeName": "Suitability Assessment",
      "description": "MiFID II compliant suitability evaluation",
      "isActive": true
    }
  ],
  "timestamp": "2025-12-24T10:30:00Z"
}
```

---

### 2.2 Create Questionnaire Type

**Endpoint:** `POST /api/v1/admin/questionnaire-types`
**Access:** SUPER_ADMIN
**Description:** Create new questionnaire type

**Request Body:**

```json
{
  "typeCode": "FINANCIAL_HEALTH",
  "typeName": "Financial Health Check",
  "description": "Comprehensive financial assessment",
  "isActive": true
}
```

**Response:** `201 Created`

```json
{
  "success": true,
  "message": "Questionnaire type created successfully",
  "data": {
    "id": 3,
    "typeCode": "FINANCIAL_HEALTH",
    "typeName": "Financial Health Check",
    "description": "Comprehensive financial assessment",
    "isActive": true,
    "createdAt": "2025-12-24T10:30:00Z"
  },
  "timestamp": "2025-12-24T10:30:00Z"
}
```

---

### 2.3 Update Questionnaire Type

**Endpoint:** `PUT /api/v1/admin/questionnaire-types/:id`
**Access:** SUPER_ADMIN
**Description:** Update existing questionnaire type

**Request Body:**

```json
{
  "typeName": "Financial Health Assessment",
  "description": "Updated description",
  "isActive": true
}
```

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Questionnaire type updated successfully",
  "data": {
    "id": 3,
    "typeCode": "FINANCIAL_HEALTH",
    "typeName": "Financial Health Assessment",
    "description": "Updated description",
    "isActive": true,
    "updatedAt": "2025-12-24T11:00:00Z"
  },
  "timestamp": "2025-12-24T11:00:00Z"
}
```

---

### 2.4 Delete Questionnaire Type

**Endpoint:** `DELETE /api/v1/admin/questionnaire-types/:id`
**Access:** SUPER_ADMIN
**Description:** Delete questionnaire type (soft delete)

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Questionnaire type deleted successfully",
  "timestamp": "2025-12-24T11:00:00Z"
}
```

---

### 2.5 Get Questions

**Endpoint:** `GET /api/v1/admin/questions`
**Access:** SUPER_ADMIN
**Description:** Get all questions with filtering

**Query Parameters:**

- `questionnaireTypeId` (optional): Filter by questionnaire type
- `isActive` (optional): Filter by active status
- `page` (optional): Page number (default: 0)
- `size` (optional): Page size (default: 20)

**Example:** `GET /api/v1/admin/questions?questionnaireTypeId=1&page=0&size=10`

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Questions retrieved successfully",
  "data": {
    "content": [
      {
        "id": 1,
        "questionCode": "AGE_RANGE",
        "questionText": "What is your age?",
        "description": "This helps us understand your investment horizon",
        "clientNotes": "Your age affects your risk capacity",
        "rmNotes": "Younger clients can typically take more risk",
        "questionType": "SINGLE_SELECT",
        "scoringMethod": "SUM",
        "maxCapPoints": 8,
        "weight": 1.0,
        "isRequired": true,
        "displayOrder": 1,
        "options": [
          {
            "id": 1,
            "optionText": "Under 25",
            "points": 4,
            "displayOrder": 1
          },
          {
            "id": 2,
            "optionText": "25-35",
            "points": 3,
            "displayOrder": 2
          }
        ],
        "dependencies": [],
        "isActive": true
      }
    ],
    "page": 0,
    "size": 10,
    "totalElements": 25,
    "totalPages": 3
  },
  "timestamp": "2025-12-24T10:30:00Z"
}
```

---

### 2.4 Create Question

**Endpoint:** `POST /api/v1/admin/questions`
**Access:** SUPER_ADMIN
**Description:** Create new question

**Request Body:**

```json
{
  "questionnaireTypeId": 1,
  "questionCode": "INVESTMENT_HORIZON",
  "questionText": "What is your investment time horizon?",
  "description": "How long do you plan to invest before needing the money?",
  "clientNotes": "Longer horizons allow for more aggressive strategies",
  "rmNotes": "Guide: <5 years = Conservative, 5-10 = Moderate, >10 = Aggressive",
  "questionType": "SINGLE_SELECT",
  "scoringMethod": "SUM",
  "maxCapPoints": 8,
  "weight": 1.5,
  "isRequired": true,
  "displayOrder": 5,
  "placeholder": null,
  "validationRules": null,
  "options": [
    {
      "optionText": "Less than 3 years",
      "points": 1,
      "displayOrder": 1
    },
    {
      "optionText": "3-5 years",
      "points": 2,
      "displayOrder": 2
    },
    {
      "optionText": "5-10 years",
      "points": 3,
      "displayOrder": 3
    },
    {
      "optionText": "More than 10 years",
      "points": 4,
      "displayOrder": 4
    }
  ]
}
```

**Response:** `201 Created`

```json
{
  "success": true,
  "message": "Question created successfully",
  "data": {
    "id": 26,
    "questionCode": "INVESTMENT_HORIZON",
    "questionText": "What is your investment time horizon?",
    "weight": 1.5,
    "displayOrder": 5,
    "options": [
      {
        "id": 101,
        "optionText": "Less than 3 years",
        "points": 1
      }
      // ... other options
    ],
    "createdAt": "2025-12-24T10:30:00Z"
  },
  "timestamp": "2025-12-24T10:30:00Z"
}
```

---

### 2.5 Update Question

**Endpoint:** `PUT /api/v1/admin/questions/:id`
**Access:** SUPER_ADMIN
**Description:** Update existing question

**Request Body:**

```json
{
  "questionText": "Updated question text",
  "description": "Updated description",
  "weight": 2.0,
  "isActive": true
}
```

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Question updated successfully",
  "data": {
    "id": 26,
    "questionText": "Updated question text",
    "weight": 2.0,
    "updatedAt": "2025-12-24T10:35:00Z"
  },
  "timestamp": "2025-12-24T10:35:00Z"
}
```

---

### 2.6 Update Question Weight

**Endpoint:** `PUT /api/v1/admin/questions/:id/weight`
**Access:** SUPER_ADMIN
**Description:** Update question weight (0.5 - 2.5 range)

**Request Body:**

```json
{
  "weight": 1.75
}
```

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Question weight updated successfully",
  "data": {
    "id": 26,
    "questionCode": "INVESTMENT_HORIZON",
    "weight": 1.75,
    "updatedAt": "2025-12-24T10:36:00Z"
  },
  "timestamp": "2025-12-24T10:36:00Z"
}
```

**Validation:**

- Weight must be between 0.5 and 2.5

---

### 2.7 Delete Question

**Endpoint:** `DELETE /api/v1/admin/questions/:id`
**Access:** SUPER_ADMIN
**Description:** Soft delete question (sets isActive = false)

**Response:** `204 No Content`

---

### 2.8 Get Question Options

**Endpoint:** `GET /api/v1/admin/questions/:id/options`
**Access:** SUPER_ADMIN
**Description:** Get all options for a specific question

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Question options retrieved successfully",
  "data": [
    {
      "id": 101,
      "questionId": 26,
      "optionValue": "LT3",
      "optionText": "Less than 3 years",
      "points": 1,
      "displayOrder": 1,
      "isCorrect": false,
      "blocksAssessment": false
    },
    {
      "id": 102,
      "questionId": 26,
      "optionValue": "3TO5",
      "optionText": "3-5 years",
      "points": 2,
      "displayOrder": 2,
      "isCorrect": false,
      "blocksAssessment": false
    }
  ],
  "timestamp": "2025-12-24T10:40:00Z"
}
```

---

### 2.9 Create Question Option

**Endpoint:** `POST /api/v1/admin/questions/:id/options`
**Access:** SUPER_ADMIN
**Description:** Add new option to a question

**Request Body:**

```json
{
  "optionValue": "GT10",
  "optionText": "More than 10 years",
  "points": 4,
  "displayOrder": 4,
  "isCorrect": false,
  "blocksAssessment": false,
  "description": "Long-term investment horizon",
  "warningMessage": null,
  "infoMessage": "Allows for aggressive growth strategies"
}
```

**Response:** `201 Created`

```json
{
  "success": true,
  "message": "Question option created successfully",
  "data": {
    "id": 104,
    "questionId": 26,
    "optionValue": "GT10",
    "optionText": "More than 10 years",
    "points": 4,
    "displayOrder": 4,
    "createdAt": "2025-12-24T10:41:00Z"
  },
  "timestamp": "2025-12-24T10:41:00Z"
}
```

---

### 2.10 Update Question Option

**Endpoint:** `PUT /api/v1/admin/options/:id`
**Access:** SUPER_ADMIN
**Description:** Update existing question option

**Request Body:**

```json
{
  "optionText": "More than 10 years (Aggressive)",
  "points": 5,
  "displayOrder": 4,
  "infoMessage": "Suitable for aggressive long-term growth"
}
```

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Question option updated successfully",
  "data": {
    "id": 104,
    "questionId": 26,
    "optionText": "More than 10 years (Aggressive)",
    "points": 5,
    "displayOrder": 4,
    "updatedAt": "2025-12-24T10:42:00Z"
  },
  "timestamp": "2025-12-24T10:42:00Z"
}
```

---

### 2.11 Delete Question Option

**Endpoint:** `DELETE /api/v1/admin/options/:id`
**Access:** SUPER_ADMIN
**Description:** Delete question option

**Response:** `204 No Content`

---

### 2.12 Get Question Dependencies

**Endpoint:** `GET /api/v1/admin/questions/:id/dependencies`
**Access:** SUPER_ADMIN
**Description:** Get all dependencies for a specific question

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Question dependencies retrieved successfully",
  "data": [
    {
      "id": 1,
      "questionId": 15,
      "dependsOnQuestionId": 10,
      "dependsOnQuestionCode": "INVESTMENT_EXPERIENCE",
      "requiredOptionId": 45,
      "requiredOptionText": "Yes, I have investment experience",
      "createdAt": "2025-11-01T10:00:00Z"
    }
  ],
  "timestamp": "2025-12-24T10:43:00Z"
}
```

---

### 2.13 Add Question Dependency

**Endpoint:** `POST /api/v1/admin/questions/:id/dependencies`
**Access:** SUPER_ADMIN
**Description:** Add conditional logic to question

**Request Body:**

```json
{
  "dependsOnQuestionId": 5,
  "requiredOptionId": 12
}
```

**Response:** `201 Created`

```json
{
  "success": true,
  "message": "Question dependency added successfully",
  "data": {
    "id": 50,
    "questionId": 26,
    "dependsOnQuestionId": 5,
    "requiredOptionId": 12,
    "dependsOnQuestionText": "What is your investment experience?",
    "requiredOptionText": "More than 5 years"
  },
  "timestamp": "2025-12-24T10:37:00Z"
}
```

---

### 2.14 Delete Question Dependency

**Endpoint:** `DELETE /api/v1/admin/dependencies/:id`
**Access:** SUPER_ADMIN
**Description:** Delete question dependency

**Response:** `204 No Content`

---

## 3. Super Admin - Portfolio Configuration

### 3.1 Get Portfolios

**Endpoint:** `GET /api/v1/admin/portfolios`
**Access:** SUPER_ADMIN
**Description:** Get all model portfolios

**Query Parameters:**

- `riskCategoryId` (optional)
- `suitabilityLevel` (optional)
- `isActive` (optional)
- `page`, `size`

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Portfolios retrieved successfully",
  "data": {
    "content": [
      {
        "id": 1,
        "portfolioCode": "INC_MOD_01",
        "portfolioName": "Income Growth - Moderate",
        "riskCategory": {
          "id": 3,
          "code": "INCOME",
          "name": "Income"
        },
        "suitabilityLevel": "MODERATE",
        "expectedReturnMin": 10.0,
        "expectedReturnMax": 12.0,
        "volatilityPercentage": 8.5,
        "minimumInvestment": 50000,
        "isActive": true,
        "assetAllocations": [
          {
            "assetClass": "Equity",
            "targetAllocation": 40.0,
            "minAllocation": 35.0,
            "maxAllocation": 45.0
          },
          {
            "assetClass": "Debt",
            "targetAllocation": 60.0,
            "minAllocation": 55.0,
            "maxAllocation": 65.0
          }
        ]
      }
    ],
    "page": 0,
    "size": 20,
    "totalElements": 15
  },
  "timestamp": "2025-12-24T10:30:00Z"
}
```

---

### 3.2 Create Portfolio

**Endpoint:** `POST /api/v1/admin/portfolios`
**Access:** SUPER_ADMIN
**Description:** Create new model portfolio

**Request Body:**

```json
{
  "portfolioCode": "AGG_HIGH_01",
  "portfolioName": "Aggressive Growth",
  "riskCategoryId": 5,
  "suitabilityLevel": "AGGRESSIVE",
  "expectedReturnMin": 15.0,
  "expectedReturnMax": 18.0,
  "volatilityPercentage": 15.0,
  "description": "High-growth portfolio for aggressive investors",
  "investmentStrategy": "Focus on growth stocks and emerging markets",
  "timeHorizonMinYears": 7,
  "timeHorizonMaxYears": 15,
  "minimumInvestment": 100000,
  "displayOrder": 5
}
```

**Response:** `201 Created`

```json
{
  "success": true,
  "message": "Portfolio created successfully",
  "data": {
    "id": 16,
    "portfolioCode": "AGG_HIGH_01",
    "portfolioName": "Aggressive Growth",
    "expectedReturnMin": 15.0,
    "expectedReturnMax": 18.0,
    "createdAt": "2025-12-24T10:40:00Z"
  },
  "timestamp": "2025-12-24T10:40:00Z"
}
```

**Validation:**

- Portfolio code must be unique
- Expected return min ≤ max
- Volatility > 0

---

### 3.3 Get Portfolio Details

**Endpoint:** `GET /api/v1/admin/portfolios/:id`
**Access:** SUPER_ADMIN
**Description:** Get detailed information about a specific portfolio

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Portfolio details retrieved successfully",
  "data": {
    "id": 16,
    "portfolioCode": "AGG_HIGH_01",
    "portfolioName": "Aggressive Growth",
    "riskCategory": {
      "id": 5,
      "code": "AGGRESSIVE",
      "name": "Aggressive"
    },
    "suitabilityLevel": "AGGRESSIVE",
    "expectedReturnMin": 15.0,
    "expectedReturnMax": 18.0,
    "volatilityPercentage": 15.0,
    "description": "High-growth portfolio for aggressive investors",
    "assetAllocations": [
      {
        "id": 50,
        "assetClass": "Equity",
        "targetAllocation": 80.0,
        "minAllocation": 75.0,
        "maxAllocation": 85.0
      },
      {
        "id": 51,
        "assetClass": "Alternative",
        "targetAllocation": 20.0,
        "minAllocation": 15.0,
        "maxAllocation": 25.0
      }
    ],
    "securities": [
      {
        "id": 1,
        "securityCode": "RELIANCE",
        "securityName": "Reliance Industries Ltd",
        "weightPercentage": 15.0
      }
    ],
    "isActive": true,
    "createdAt": "2025-12-24T10:40:00Z"
  },
  "timestamp": "2025-12-24T11:00:00Z"
}
```

---

### 3.4 Update Portfolio

**Endpoint:** `PUT /api/v1/admin/portfolios/:id`
**Access:** SUPER_ADMIN
**Description:** Update existing portfolio

**Request Body:**

```json
{
  "portfolioName": "Aggressive Growth Plus",
  "expectedReturnMin": 16.0,
  "expectedReturnMax": 19.0,
  "volatilityPercentage": 16.0,
  "description": "Enhanced high-growth portfolio",
  "investmentStrategy": "Updated strategy focusing on tech and emerging markets",
  "minimumInvestment": 100000,
  "isActive": true
}
```

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Portfolio updated successfully",
  "data": {
    "id": 16,
    "portfolioCode": "AGG_HIGH_01",
    "portfolioName": "Aggressive Growth Plus",
    "expectedReturnMin": 16.0,
    "expectedReturnMax": 19.0,
    "updatedAt": "2025-12-24T11:05:00Z"
  },
  "timestamp": "2025-12-24T11:05:00Z"
}
```

---

### 3.5 Delete Portfolio

**Endpoint:** `DELETE /api/v1/admin/portfolios/:id`
**Access:** SUPER_ADMIN
**Description:** Soft delete portfolio (sets isActive = false)

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Portfolio deleted successfully",
  "timestamp": "2025-12-24T11:06:00Z"
}
```

---

### 3.6 Get Portfolio Allocations

**Endpoint:** `GET /api/v1/admin/portfolios/:id/allocations`
**Access:** SUPER_ADMIN
**Description:** Get all asset allocations for a portfolio

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Portfolio allocations retrieved successfully",
  "data": [
    {
      "id": 50,
      "portfolioId": 16,
      "assetClass": {
        "id": 1,
        "assetClassName": "Equity",
        "riskLevel": "HIGH"
      },
      "targetAllocationPercentage": 80.0,
      "minAllocationPercentage": 75.0,
      "maxAllocationPercentage": 85.0,
      "rebalancingThresholdPercentage": 5.0
    },
    {
      "id": 51,
      "portfolioId": 16,
      "assetClass": {
        "id": 6,
        "assetClassName": "Alternative",
        "riskLevel": "VERY_HIGH"
      },
      "targetAllocationPercentage": 20.0,
      "minAllocationPercentage": 15.0,
      "maxAllocationPercentage": 25.0,
      "rebalancingThresholdPercentage": 5.0
    }
  ],
  "timestamp": "2025-12-24T11:07:00Z"
}
```

---

### 3.7 Add Asset Allocation

**Endpoint:** `POST /api/v1/admin/portfolios/:id/allocations`
**Access:** SUPER_ADMIN
**Description:** Add asset allocation to portfolio

**Request Body:**

```json
{
  "assetClassId": 1,
  "targetAllocationPercentage": 80.0,
  "minAllocationPercentage": 75.0,
  "maxAllocationPercentage": 85.0,
  "rebalancingThresholdPercentage": 5.0
}
```

**Response:** `201 Created`

```json
{
  "success": true,
  "message": "Asset allocation added successfully",
  "data": {
    "id": 50,
    "portfolioId": 16,
    "assetClass": "Equity",
    "targetAllocation": 80.0,
    "rebalancingThreshold": 5.0
  },
  "timestamp": "2025-12-24T10:42:00Z"
}
```

**Validation:**

- Sum of all allocations for a portfolio must equal 100%
- Min ≤ Target ≤ Max

---

### 3.8 Update Asset Allocation

**Endpoint:** `PUT /api/v1/admin/allocations/:id`
**Access:** SUPER_ADMIN
**Description:** Update existing asset allocation

**Request Body:**

```json
{
  "targetAllocationPercentage": 75.0,
  "minAllocationPercentage": 70.0,
  "maxAllocationPercentage": 80.0,
  "rebalancingThresholdPercentage": 4.0
}
```

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Asset allocation updated successfully",
  "data": {
    "id": 50,
    "portfolioId": 16,
    "assetClass": "Equity",
    "targetAllocationPercentage": 75.0,
    "minAllocationPercentage": 70.0,
    "maxAllocationPercentage": 80.0,
    "updatedAt": "2025-12-24T11:10:00Z"
  },
  "timestamp": "2025-12-24T11:10:00Z"
}
```

---

### 3.9 Delete Asset Allocation

**Endpoint:** `DELETE /api/v1/admin/allocations/:id`
**Access:** SUPER_ADMIN
**Description:** Remove asset allocation from portfolio

**Response:** `204 No Content`

---

### 3.10 Get Portfolio Securities

**Endpoint:** `GET /api/v1/admin/portfolios/:id/securities`
**Access:** SUPER_ADMIN
**Description:** Get all securities in a portfolio

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Portfolio securities retrieved successfully",
  "data": [
    {
      "id": 200,
      "portfolioId": 16,
      "assetClass": {
        "id": 1,
        "assetClassName": "Equity"
      },
      "securityCode": "RELIANCE",
      "securityName": "Reliance Industries Ltd",
      "isin": "INE002A01018",
      "securityType": "EQUITY",
      "weightPercentage": 15.0
    },
    {
      "id": 201,
      "portfolioId": 16,
      "assetClass": {
        "id": 1,
        "assetClassName": "Equity"
      },
      "securityCode": "TCS",
      "securityName": "Tata Consultancy Services",
      "isin": "INE467B01029",
      "securityType": "EQUITY",
      "weightPercentage": 12.0
    }
  ],
  "timestamp": "2025-12-24T11:12:00Z"
}
```

---

### 3.11 Add Portfolio Securities

**Endpoint:** `POST /api/v1/admin/portfolios/:id/securities`
**Access:** SUPER_ADMIN
**Description:** Add underlying securities to portfolio

**Request Body:**

```json
{
  "assetClassId": 1,
  "securityCode": "RELIANCE",
  "securityName": "Reliance Industries Ltd",
  "isin": "INE002A01018",
  "securityType": "EQUITY",
  "weightPercentage": 15.0
}
```

**Response:** `201 Created`

```json
{
  "success": true,
  "message": "Security added successfully",
  "data": {
    "id": 200,
    "portfolioId": 16,
    "securityCode": "RELIANCE",
    "securityName": "Reliance Industries Ltd",
    "weightPercentage": 15.0
  },
  "timestamp": "2025-12-24T10:45:00Z"
}
```

---

### 3.12 Update Portfolio Security

**Endpoint:** `PUT /api/v1/admin/securities/:id`
**Access:** SUPER_ADMIN
**Description:** Update existing portfolio security

**Request Body:**

```json
{
  "weightPercentage": 18.0,
  "securityName": "Reliance Industries Limited"
}
```

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Security updated successfully",
  "data": {
    "id": 200,
    "portfolioId": 16,
    "securityCode": "RELIANCE",
    "securityName": "Reliance Industries Limited",
    "weightPercentage": 18.0,
    "updatedAt": "2025-12-24T11:15:00Z"
  },
  "timestamp": "2025-12-24T11:15:00Z"
}
```

---

### 3.13 Delete Portfolio Security

**Endpoint:** `DELETE /api/v1/admin/securities/:id`
**Access:** SUPER_ADMIN
**Description:** Remove security from portfolio

**Response:** `204 No Content`

---

## 4. Super Admin - Risk Categories

### 4.1 Get Risk Categories

**Endpoint:** `GET /api/v1/admin/risk-categories`
**Access:** SUPER_ADMIN
**Description:** Get all risk score categories

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Risk categories retrieved successfully",
  "data": [
    {
      "id": 1,
      "categoryCode": "SECURE",
      "categoryName": "Secure",
      "minScore": 8,
      "maxScore": 13,
      "description": "Very conservative investors",
      "recommendedAllocation": "10% Equity / 90% Debt",
      "displayOrder": 1,
      "isActive": true
    }
    // ... other categories
  ],
  "timestamp": "2025-12-24T10:30:00Z"
}
```

---

### 4.2 Update Risk Category

**Endpoint:** `PUT /api/v1/admin/risk-categories/:id`
**Access:** SUPER_ADMIN
**Description:** Update risk category ranges

**Request Body:**

```json
{
  "minScore": 8,
  "maxScore": 14,
  "description": "Updated description"
}
```

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Risk category updated successfully",
  "data": {
    "id": 1,
    "categoryCode": "SECURE",
    "minScore": 8,
    "maxScore": 14,
    "updatedAt": "2025-12-24T10:50:00Z"
  },
  "timestamp": "2025-12-24T10:50:00Z"
}
```

---

### 4.3 Validate Risk Category Ranges

**Endpoint:** `GET /api/v1/admin/risk-categories/validate-ranges`
**Access:** SUPER_ADMIN
**Description:** Validate that all risk categories cover 8-35 without gaps or overlaps

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Risk category ranges validated successfully",
  "data": {
    "isValid": true,
    "coverage": {
      "min": 8,
      "max": 35
    },
    "gaps": [],
    "overlaps": []
  },
  "timestamp": "2025-12-24T10:51:00Z"
}
```

**Error Response (if invalid):** `400 Bad Request`

```json
{
  "success": false,
  "message": "Risk category ranges are invalid",
  "data": {
    "isValid": false,
    "gaps": [
      {
        "start": 14,
        "end": 15,
        "message": "No category covers scores 14-15"
      }
    ],
    "overlaps": []
  },
  "timestamp": "2025-12-24T10:51:00Z"
}
```

---

## 5. RM - Customer Management

### 5.1 Get Customers

**Endpoint:** `GET /api/v1/rm/customers`
**Access:** RM, SUPER_ADMIN
**Description:** Get all customers for logged-in RM

**Query Parameters:**

- `search` (optional): Search by name, email, customer code
- `status` (optional): Filter by active/inactive
- `page`, `size`

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Customers retrieved successfully",
  "data": {
    "content": [
      {
        "id": 50,
        "customerCode": "CUS001",
        "firstName": "Raj",
        "lastName": "Kumar",
        "email": "raj.kumar@email.com",
        "phoneNumber": "+919876543210",
        "dateOfBirth": "1985-03-15",
        "kycStatus": "COMPLETED",
        "totalGoals": 3,
        "activeGoals": 2,
        "riskScore": 24,
        "riskCategory": "Balance",
        "journeyStage": "PORTFOLIO_MATCHING",
        "isActive": true,
        "createdAt": "2025-11-01T10:00:00Z"
      }
    ],
    "page": 0,
    "size": 20,
    "totalElements": 45
  },
  "timestamp": "2025-12-24T10:30:00Z"
}
```

---

### 5.2 Create Customer

**Endpoint:** `POST /api/v1/rm/customers`
**Access:** RM, SUPER_ADMIN
**Description:** Create new customer

**Request Body:**

```json
{
  "email": "customer@email.com",
  "password": "TempP@ss123",
  "firstName": "Priya",
  "lastName": "Sharma",
  "phoneNumber": "+919123456789",
  "dateOfBirth": "1992-07-20",
  "gender": "FEMALE",
  "maritalStatus": "SINGLE"
}
```

**Response:** `201 Created`

```json
{
  "success": true,
  "message": "Customer created successfully",
  "data": {
    "id": 51,
    "customerCode": "CUS046",
    "email": "customer@email.com",
    "firstName": "Priya",
    "lastName": "Sharma",
    "rmId": 5,
    "rmName": "John Doe",
    "journeyInitialized": true,
    "createdAt": "2025-12-24T11:00:00Z"
  },
  "timestamp": "2025-12-24T11:00:00Z"
}
```

---

### 5.3 Get Customer Details

**Endpoint:** `GET /api/v1/rm/customers/:id`
**Access:** RM (own customers), SUPER_ADMIN
**Description:** Get detailed customer information

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Customer details retrieved successfully",
  "data": {
    "id": 50,
    "customerCode": "CUS001",
    "firstName": "Raj",
    "lastName": "Kumar",
    "email": "raj.kumar@email.com",
    "phoneNumber": "+919876543210",
    "dateOfBirth": "1985-03-15",
    "age": 40,
    "gender": "MALE",
    "maritalStatus": "MARRIED",
    "kycStatus": "COMPLETED",
    "kycCompletedAt": "2025-11-02T14:30:00Z",

    "riskProfile": {
      "assessmentDate": "2025-11-05T10:00:00Z",
      "totalScore": 24,
      "category": "Balance",
      "validUntil": "2026-11-05"
    },

    "suitabilityAssessment": {
      "assessmentDate": "2025-11-05T11:00:00Z",
      "suitabilityLevel": "MODERATE",
      "validUntil": "2026-11-05"
    },

    "goals": [
      {
        "id": 10,
        "goalName": "Retirement Fund",
        "goalType": "RETIREMENT",
        "targetAmount": 50000000,
        "targetDate": "2045-03-15",
        "status": "IN_PROGRESS"
      }
    ],

    "journey": {
      "currentStage": "PORTFOLIO_MATCHING",
      "status": "IN_PROGRESS",
      "startedAt": "2025-11-01T10:00:00Z"
    },

    "rm": {
      "id": 5,
      "name": "John Doe",
      "employeeId": "EMP001",
      "email": "john.doe@scb.com"
    },

    "isActive": true,
    "createdAt": "2025-11-01T10:00:00Z"
  },
  "timestamp": "2025-12-24T11:05:00Z"
}
```

---

### 5.4 Get Customer Dashboard

**Endpoint:** `GET /api/v1/rm/customers/:id/dashboard`
**Access:** RM (own customers), SUPER_ADMIN
**Description:** Get customer dashboard summary

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Dashboard data retrieved successfully",
  "data": {
    "customerInfo": {
      "name": "Raj Kumar",
      "customerCode": "CUS001",
      "riskCategory": "Balance",
      "suitability": "MODERATE"
    },
    "goalsSummary": {
      "totalGoals": 3,
      "activeGoals": 2,
      "completedGoals": 0,
      "totalTargetAmount": 75000000,
      "totalCurrentAmount": 5000000,
      "overallProgress": 6.67
    },
    "portfolioSummary": {
      "totalInvestment": 5000000,
      "currentValue": 5250000,
      "totalReturns": 250000,
      "returnsPercentage": 5.0
    },
    "recentActivity": [
      {
        "date": "2025-12-20T10:00:00Z",
        "activity": "Portfolio simulation completed",
        "details": "Monte Carlo simulation for Retirement Fund goal"
      }
    ]
  },
  "timestamp": "2025-12-24T11:10:00Z"
}
```

---

## 6. RM - Goal Management

### 6.1 Get Customer Goals

**Endpoint:** `GET /api/v1/rm/goals/:customerId`
**Access:** RM (own customers), SUPER_ADMIN
**Description:** Get all goals for a customer

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Goals retrieved successfully",
  "data": [
    {
      "id": 10,
      "goalName": "Retirement Fund",
      "goalType": {
        "code": "RETIREMENT",
        "name": "Retirement Planning",
        "icon": "retirement"
      },
      "description": "Build a corpus for comfortable retirement",
      "targetAmount": 50000000,
      "currentAmount": 2000000,
      "targetDate": "2045-03-15",
      "timeHorizonYears": 20,
      "initialInvestment": 500000,
      "monthlyInvestment": 25000,
      "priority": "HIGH",
      "status": "ON_TRACK",
      "inflationRate": 6.0,
      "createdAt": "2025-11-05T09:00:00Z",
      "hasCalculations": true,
      "hasPortfolioMatch": true,
      "hasSimulation": true
    }
  ],
  "timestamp": "2025-12-24T11:15:00Z"
}
```

---

### 6.2 Create Goal

**Endpoint:** `POST /api/v1/rm/goals`
**Access:** RM, SUPER_ADMIN
**Description:** Create new goal for customer

**Request Body:**

```json
{
  "customerId": 50,
  "goalTypeId": 1,
  "goalName": "Child Education Fund",
  "description": "Save for daughter's higher education",
  "targetAmount": 5000000,
  "currentAmount": 100000,
  "targetDate": "2035-06-01",
  "initialInvestment": 100000,
  "monthlyInvestment": 15000,
  "priority": "HIGH",
  "inflationRate": 7.0,
  "taxRate": 0.0
}
```

**Response:** `201 Created`

```json
{
  "success": true,
  "message": "Goal created successfully. Journey stage updated to GOAL_CREATION.",
  "data": {
    "id": 25,
    "goalName": "Child Education Fund",
    "targetAmount": 5000000,
    "targetDate": "2035-06-01",
    "timeHorizonYears": 10,
    "status": "IN_PROGRESS",
    "createdAt": "2025-12-24T11:20:00Z"
  },
  "timestamp": "2025-12-24T11:20:00Z"
}
```

---

### 6.3 Get Goal Details

**Endpoint:** `GET /api/v1/rm/goals/:id`
**Access:** RM (own customers), SUPER_ADMIN
**Description:** Get detailed information about a specific goal

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Goal details retrieved successfully",
  "data": {
    "id": 25,
    "customer": {
      "id": 50,
      "customerCode": "CUS001",
      "name": "Priya Sharma",
      "riskCategory": "BALANCE"
    },
    "goalType": {
      "id": 1,
      "code": "EDUCATION",
      "name": "Child Education"
    },
    "goalName": "Child Education Fund",
    "description": "Save for daughter's higher education",
    "targetAmount": 5000000,
    "currentAmount": 100000,
    "targetDate": "2035-06-01",
    "timeHorizonYears": 10,
    "initialInvestment": 100000,
    "monthlyInvestment": 15000,
    "priority": "HIGH",
    "status": "IN_PROGRESS",
    "inflationRate": 7.0,
    "taxRate": 0.0,
    "createdAt": "2025-12-24T11:20:00Z",
    "updatedAt": "2025-12-24T11:20:00Z",
    "hasCalculations": false,
    "hasPortfolioMatch": false,
    "hasSimulation": false,
    "revisionsCount": 0
  },
  "timestamp": "2025-12-24T11:30:00Z"
}
```

---

### 6.4 Revise Goal

**Endpoint:** `POST /api/v1/rm/goals/:id/revise`
**Access:** RM, SUPER_ADMIN
**Description:** Revise goal parameters and log edit history

**Request Body:**

```json
{
  "targetAmount": 5500000,
  "monthlyInvestment": 18000,
  "revisionReason": "Inflation adjustment and salary increase"
}
```

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Goal revised successfully. Edit history logged.",
  "data": {
    "id": 25,
    "targetAmount": 5500000,
    "monthlyInvestment": 18000,
    "updatedAt": "2025-12-24T11:25:00Z",
    "revisionsCount": 1
  },
  "timestamp": "2025-12-24T11:25:00Z"
}
```

---

## 7. RM - Risk Profile Assessment

### 7.1 Get Risk Profile Questions

**Endpoint:** `GET /api/v1/rm/risk-profile/questions`
**Access:** RM, SUPER_ADMIN
**Description:** Get all active risk profile questions with options

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Risk profile questions retrieved successfully",
  "data": {
    "questionnaireType": {
      "code": "RISK_PROFILE",
      "name": "Risk Profile Assessment"
    },
    "questions": [
      {
        "id": 1,
        "questionCode": "AGE_RANGE",
        "questionText": "What is your age?",
        "description": "This helps us understand your investment horizon",
        "clientNotes": "Your age affects your risk capacity",
        "rmNotes": "Younger clients can typically take more risk",
        "questionType": "SINGLE_SELECT",
        "scoringMethod": "SUM",
        "maxCapPoints": 8,
        "weight": 1.0,
        "isRequired": true,
        "displayOrder": 1,
        "options": [
          {
            "id": 1,
            "optionText": "Under 25",
            "points": 4,
            "displayOrder": 1
          },
          {
            "id": 2,
            "optionText": "25-35",
            "points": 3,
            "displayOrder": 2
          },
          {
            "id": 3,
            "optionText": "35-45",
            "points": 2,
            "displayOrder": 3
          },
          {
            "id": 4,
            "optionText": "45-60",
            "points": 1,
            "displayOrder": 4
          },
          {
            "id": 5,
            "optionText": "Over 60",
            "points": 0,
            "displayOrder": 5
          }
        ],
        "dependencies": []
      }
    ],
    "scoringInfo": {
      "minPossibleScore": 8,
      "maxPossibleScore": 35,
      "categories": [
        {
          "code": "SECURE",
          "name": "Secure",
          "range": "8-13"
        }
        // ... other categories
      ]
    }
  },
  "timestamp": "2025-12-24T11:30:00Z"
}
```

---

### 7.2 Submit Risk Profile Assessment

**Endpoint:** `POST /api/v1/rm/risk-profile/submit`
**Access:** RM, SUPER_ADMIN
**Description:** Submit completed risk profile assessment

**Request Body:**

```json
{
  "customerId": 50,
  "answers": [
    {
      "questionId": 1,
      "selectedOptionIds": [2]
    },
    {
      "questionId": 2,
      "selectedOptionIds": [8, 9, 10]
    },
    {
      "questionId": 3,
      "textAnswer": "Moderate risk with focus on growth"
    }
  ],
  "assessmentNotes": "Customer is comfortable with moderate volatility"
}
```

**Response:** `201 Created`

```json
{
  "success": true,
  "message": "Risk profile assessment completed successfully. Journey stage updated to RISK_PROFILE.",
  "data": {
    "riskProfileId": 15,
    "customerId": 50,
    "assessmentDate": "2025-12-24T11:35:00Z",
    "totalScore": 24,
    "riskCategory": {
      "id": 4,
      "code": "BALANCE",
      "name": "Balance",
      "minScore": 22,
      "maxScore": 26,
      "recommendedAllocation": "60% Equity / 40% Debt"
    },
    "validUntil": "2026-12-24",
    "breakdown": {
      "goalQuestions": 8,
      "experienceQuestions": 6,
      "riskToleranceQuestions": 10
    }
  },
  "timestamp": "2025-12-24T11:35:00Z"
}
```

**Scoring Calculation:**

```
Question 1: Weight 1.0, Selected Option Points: 3, Weighted Points: 3.0
Question 2: Weight 1.0, Selected Options Total: 12, Capped to 8, Weighted: 8.0
Question 3: Non-scoring text answer
... (more questions)
Total Score: 24
```

---

### 7.3 Get Latest Risk Profile

**Endpoint:** `GET /api/v1/rm/risk-profile/:customerId/latest`
**Access:** RM, SUPER_ADMIN
**Description:** Get customer's latest active risk profile

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Latest risk profile retrieved successfully",
  "data": {
    "id": 15,
    "assessmentDate": "2025-12-24T11:35:00Z",
    "totalScore": 24,
    "riskCategory": {
      "code": "BALANCE",
      "name": "Balance",
      "description": "Balanced investors seeking growth with moderate risk"
    },
    "status": "ACTIVE",
    "validUntil": "2026-12-24",
    "assessmentNotes": "Customer is comfortable with moderate volatility",
    "answers": [
      {
        "questionText": "What is your age?",
        "selectedOptions": ["25-35"],
        "pointsEarned": 3,
        "weightedPoints": 3.0
      }
    ],
    "createdBy": {
      "rmId": 5,
      "rmName": "John Doe"
    }
  },
  "timestamp": "2025-12-24T11:40:00Z"
}
```

---

### 7.4 Get Risk Profile History

**Endpoint:** `GET /api/v1/rm/risk-profile/:customerId/history`
**Access:** RM, SUPER_ADMIN
**Description:** Get all risk profile assessments for customer

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Risk profile history retrieved successfully",
  "data": [
    {
      "id": 15,
      "assessmentDate": "2025-12-24T11:35:00Z",
      "totalScore": 24,
      "riskCategory": "Balance",
      "status": "ACTIVE",
      "attemptNumber": 1
    },
    {
      "id": 10,
      "assessmentDate": "2025-11-05T10:00:00Z",
      "totalScore": 20,
      "riskCategory": "Income",
      "status": "SUPERSEDED",
      "attemptNumber": 1
    }
  ],
  "timestamp": "2025-12-24T11:42:00Z"
}
```

---

### 7.5 Retake Risk Profile

**Endpoint:** `POST /api/v1/rm/risk-profile/:id/retake`
**Access:** RM, SUPER_ADMIN
**Description:** Mark current assessment as superseded and allow retake

**Request Body:**

```json
{
  "retakeReason": "Customer's financial situation has changed significantly"
}
```

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Risk profile marked for retake. Journey stage updated with attempt number incremented.",
  "data": {
    "previousAssessmentId": 15,
    "previousAssessmentStatus": "SUPERSEDED",
    "customerId": 50,
    "nextAttemptNumber": 2,
    "journeyStageUpdated": true
  },
  "timestamp": "2025-12-24T11:45:00Z"
}
```

---

### 7.6 Generate Risk Profile Report

**Endpoint:** `GET /api/v1/rm/risk-profile/:id/report`
**Access:** RM, SUPER_ADMIN
**Description:** Generate PDF report of risk profile assessment

**Query Parameters:**

- `format` (optional): `pdf` or `json` (default: `pdf`)

**Response:** `200 OK` (PDF file download)

```
Content-Type: application/pdf
Content-Disposition: attachment; filename="risk_profile_CUS001_20251224.pdf"
```

---

## 8. RM - Suitability Assessment

### 8.1 Get Suitability Questions

**Endpoint:** `GET /api/v1/rm/suitability/questions`
**Access:** RM, SUPER_ADMIN
**Description:** Get all suitability assessment questions

**Response:** Similar to Risk Profile Questions (7.1)

---

### 8.2 Submit Suitability Assessment

**Endpoint:** `POST /api/v1/rm/suitability/submit`
**Access:** RM, SUPER_ADMIN
**Description:** Submit suitability assessment

**Request Body:**

```json
{
  "customerId": 50,
  "answers": [
    {
      "questionId": 50,
      "selectedOptionIds": [201]
    }
  ],
  "investmentObjectives": "Long-term capital growth with moderate income",
  "investmentExperienceYears": 5,
  "financialKnowledgeLevel": "INTERMEDIATE",
  "riskCapacity": "MODERATE",
  "assessmentNotes": "Customer has clear understanding of market risks"
}
```

**Response:** `201 Created`

```json
{
  "success": true,
  "message": "Suitability assessment completed successfully. Journey stage updated to SUITABILITY.",
  "data": {
    "suitabilityAssessmentId": 20,
    "customerId": 50,
    "assessmentDate": "2025-12-24T12:00:00Z",
    "suitabilityLevel": "MODERATE",
    "investmentObjectives": "Long-term capital growth with moderate income",
    "investmentExperienceYears": 5,
    "financialKnowledgeLevel": "INTERMEDIATE",
    "riskCapacity": "MODERATE",
    "validUntil": "2026-12-24",
    "complianceStatus": "COMPLIANT"
  },
  "timestamp": "2025-12-24T12:00:00Z"
}
```

---

### 8.3 Get Latest Suitability Assessment

**Endpoint:** `GET /api/v1/rm/suitability/:customerId/latest`
**Access:** RM, SUPER_ADMIN
**Description:** Get customer's latest active suitability assessment

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Latest suitability assessment retrieved successfully",
  "data": {
    "id": 20,
    "customerId": 50,
    "assessmentDate": "2025-12-24T12:00:00Z",
    "versionNumber": 1,
    "assessmentStatus": "COMPLETED",
    "suitabilityLevel": "MODERATE_SUITABILITY",
    "overallSuitabilityScore": 75.5,
    "knowledgeScore": 78.0,
    "experienceScore": 75.0,
    "riskCapacityScore": 80.0,
    "financialSituationScore": 75.0,
    "knowledgeTestPassed": true,
    "knowledgeTestPercentage": 71.43,
    "knowledgeTestCorrectAnswers": 5,
    "knowledgeTestTotalQuestions": 7,
    "mifidIICompliant": true,
    "appropriatenessTestPassed": true,
    "validUntil": "2026-12-24T12:00:00Z",
    "isCurrentAssessment": true,
    "investmentObjectives": "Long-term capital growth with moderate income",
    "investmentExperienceYears": 5,
    "financialKnowledgeLevel": "INTERMEDIATE",
    "riskCapacity": "MODERATE",
    "assessmentNotes": "Customer has clear understanding of market risks",
    "rmNotes": "Good knowledge test performance",
    "conductedBy": "RM",
    "relationshipManager": {
      "id": 5,
      "name": "John Doe",
      "employeeId": "RM001"
    },
    "dimensionScores": {
      "KNOWLEDGE": 78.0,
      "EXPERIENCE": 75.0,
      "RISK_CAPACITY": 80.0,
      "FINANCIAL_SITUATION": 75.0
    },
    "totalQuestionsAnswered": 8,
    "mandatoryQuestionsAnswered": 8,
    "completionPercentage": 100.0,
    "startedAt": "2025-12-24T11:50:00Z",
    "completedAt": "2025-12-24T12:00:00Z",
    "assessmentDurationMinutes": 10
  },
  "timestamp": "2025-12-24T12:05:00Z"
}
```

**Response when no assessment exists:** `404 Not Found`

```json
{
  "success": false,
  "message": "No suitability assessment found for this customer",
  "timestamp": "2025-12-24T12:05:00Z"
}
```

---

## 9. RM - Financial Calculator

### 9.1 Calculate Corpus

**Endpoint:** `POST /api/v1/rm/calculator/corpus`
**Access:** RM, SUPER_ADMIN
**Description:** Calculate inflation-adjusted target corpus

**Request Body:**

```json
{
  "goalId": 25,
  "targetAmount": 5000000,
  "years": 10,
  "inflationRate": 7.0,
  "taxRate": 0.0
}
```

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Target corpus calculated successfully",
  "data": {
    "goalId": 25,
    "currentAmount": 5000000,
    "inflationAdjustedCorpus": 9835757.5,
    "inflationRate": 7.0,
    "years": 10,
    "calculationDate": "2025-12-24T12:05:00Z",
    "breakdown": {
      "year1": 5350000,
      "year2": 5724500,
      "year3": 6125215,
      // ... years 4-9
      "year10": 9835757.5
    }
  },
  "timestamp": "2025-12-24T12:05:00Z"
}
```

---

### 9.2 Calculate Required Return

**Endpoint:** `POST /api/v1/rm/calculator/required-return`
**Access:** RM, SUPER_ADMIN
**Description:** Calculate required return rate using Newton-Raphson method

**Request Body:**

```json
{
  "goalId": 25,
  "targetCorpus": 9835757.5,
  "initialInvestment": 100000,
  "monthlyInvestment": 15000,
  "years": 10
}
```

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Required return calculated successfully using Newton-Raphson method",
  "data": {
    "goalId": 25,
    "targetCorpus": 9835757.5,
    "initialInvestment": 100000,
    "monthlyInvestment": 15000,
    "years": 10,
    "requiredReturnPercentage": 11.25,
    "calculationMethod": "NEWTON_RAPHSON",
    "iterations": 12,
    "precision": 0.0001,
    "calculationDate": "2025-12-24T12:06:00Z",
    "breakdown": {
      "totalInvestment": 1900000,
      "totalReturns": 7935757.5,
      "returnOnInvestment": 417.67
    }
  },
  "timestamp": "2025-12-24T12:06:00Z"
}
```

---

### 9.3 Match Portfolio

**Endpoint:** `POST /api/v1/rm/calculator/match-portfolio`
**Access:** RM, SUPER_ADMIN
**Description:** Match required return with suitable portfolios

**Request Body:**

```json
{
  "goalId": 25,
  "customerId": 50,
  "requiredReturnPercentage": 11.25,
  "riskScore": 24,
  "suitabilityLevel": "MODERATE"
}
```

**Response:** `200 OK` (Match Found)

```json
{
  "success": true,
  "message": "Portfolio match found",
  "data": {
    "hasMatch": true,
    "matchedPortfolio": {
      "id": 5,
      "portfolioCode": "BAL_MOD_01",
      "portfolioName": "Balanced Growth - Moderate",
      "expectedReturnMin": 10.0,
      "expectedReturnMax": 13.0,
      "volatilityPercentage": 9.5,
      "assetAllocations": [
        {
          "assetClass": "Equity",
          "targetAllocation": 60.0
        },
        {
          "assetClass": "Debt",
          "targetAllocation": 40.0
        }
      ]
    },
    "matchDetails": {
      "requiredReturn": 11.25,
      "portfolioReturnMin": 10.0,
      "portfolioReturnMax": 13.0,
      "matchScore": 95.5,
      "isWithinRange": true,
      "gap": 0
    },
    "alternativeMatches": [
      {
        "portfolioId": 6,
        "portfolioName": "Balanced Growth - High",
        "expectedReturnRange": "11-14%",
        "matchScore": 92.0
      }
    ]
  },
  "timestamp": "2025-12-24T12:10:00Z"
}
```

**Response:** `200 OK` (No Match)

```json
{
  "success": true,
  "message": "No exact match found. Suggestions provided.",
  "data": {
    "hasMatch": false,
    "requiredReturn": 15.5,
    "closestPortfolio": {
      "id": 8,
      "portfolioName": "Aggressive Growth",
      "expectedReturnMax": 14.0
    },
    "gap": 1.5,
    "suggestions": [
      {
        "type": "RETAKE_RISK_ASSESSMENT",
        "title": "Retake Risk Questionnaire",
        "description": "Your current risk score (24 - Balance) may qualify you for higher-risk portfolios with better returns. Consider retaking the risk assessment.",
        "impact": "May qualify for portfolios with up to 18% returns"
      },
      {
        "type": "INCREASE_INVESTMENT",
        "title": "Increase Investment Amount",
        "description": "Increase monthly SIP from ₹15,000 to ₹18,500 to reduce required return to 12.5%",
        "newMonthlySip": 18500,
        "newRequiredReturn": 12.5
      },
      {
        "type": "EXTEND_TENURE",
        "title": "Extend Investment Tenure",
        "description": "Extend goal timeline from 10 years to 12 years to reduce required return to 13.2%",
        "newYears": 12,
        "newRequiredReturn": 13.2
      },
      {
        "type": "REVISE_GOAL",
        "title": "Revise Goal Amount",
        "description": "Reduce goal amount slightly to align with achievable returns",
        "maxAchievableCorpus": 8500000
      }
    ]
  },
  "timestamp": "2025-12-24T12:10:00Z"
}
```

---

## 10. RM - Portfolio Simulation

### 10.1 Run Simulation

**Endpoint:** `POST /api/v1/rm/simulation/run`
**Access:** RM, SUPER_ADMIN
**Description:** Run Monte Carlo simulation

**Request Body:**

```json
{
  "goalId": 25,
  "portfolioId": 5,
  "initialInvestment": 100000,
  "monthlyInvestment": 15000,
  "years": 10,
  "expectedReturnPercentage": 11.5,
  "volatilityPercentage": 9.5,
  "iterations": 10000
}
```

**Response:** `202 Accepted`

```json
{
  "success": true,
  "message": "Simulation started successfully. Processing in background.",
  "data": {
    "simulationId": 50,
    "status": "IN_PROGRESS",
    "estimatedCompletionTime": "2025-12-24T12:12:00Z"
  },
  "timestamp": "2025-12-24T12:11:00Z"
}
```

---

### 10.2 Get Simulation Status

**Endpoint:** `GET /api/v1/rm/simulation/:id/status`
**Access:** RM, SUPER_ADMIN
**Description:** Check simulation processing status

**Response:** `200 OK` (Completed)

```json
{
  "success": true,
  "message": "Simulation completed successfully",
  "data": {
    "simulationId": 50,
    "status": "COMPLETED",
    "startedAt": "2025-12-24T12:11:00Z",
    "completedAt": "2025-12-24T12:11:45Z",
    "durationSeconds": 45
  },
  "timestamp": "2025-12-24T12:12:00Z"
}
```

---

### 10.3 Get Simulation Results

**Endpoint:** `GET /api/v1/rm/simulation/:id/results`
**Access:** RM, SUPER_ADMIN
**Description:** Get simulation results

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Simulation results retrieved successfully. Journey stage updated to SIMULATION.",
  "data": {
    "simulationId": 50,
    "goalId": 25,
    "portfolioId": 5,
    "portfolioName": "Balanced Growth - Moderate",
    "simulationDate": "2025-12-24T12:11:00Z",
    "iterations": 10000,
    "targetCorpus": 9835757.50,

    "scenarios": {
      "worstCase": {
        "finalValue": 7250000,
        "percentile": 10,
        "annualizedReturn": 9.2,
        "meetsGoal": false,
        "shortfall": 2585757.50
      },
      "baseCase": {
        "finalValue": 10500000,
        "percentile": 50,
        "annualizedReturn": 11.5,
        "meetsGoal": true,
        "surplus": 664242.50
      },
      "bestCase": {
        "finalValue": 14200000,
        "percentile": 90,
        "annualizedReturn": 13.8,
        "meetsGoal": true,
        "surplus": 4364242.50
      }
    },

    "probabilityOfSuccess": 68.5,
    "confidenceLevel": "MODERATE",

    "chartData": {
      "months": [0, 12, 24, 36, 48, 60, 72, 84, 96, 108, 120],
      "worstCase": [100000, 380000, 685000, ...],
      "baseCase": [100000, 395000, 720000, ...],
      "bestCase": [100000, 410000, 755000, ...],
      "targetLine": [100000, 820000, 1640000, ..., 9835757.50]
    },

    "insights": [
      {
        "type": "SUCCESS_PROBABILITY",
        "message": "68.5% chance of achieving your goal",
        "severity": "INFO"
      },
      {
        "type": "WORST_CASE_WARNING",
        "message": "In worst case scenario (10th percentile), you may fall short by ₹25.86 lakhs",
        "severity": "WARNING"
      },
      {
        "type": "RECOMMENDATION",
        "message": "Consider increasing monthly SIP by ₹2,000 to improve success probability to 85%",
        "severity": "INFO"
      }
    ]
  },
  "timestamp": "2025-12-24T12:12:00Z"
}
```

---

## 11. RM - Order Management

### 11.1 Create Order

**Endpoint:** `POST /api/v1/rm/orders`
**Access:** RM, SUPER_ADMIN
**Description:** Create investment order

**Request Body:**

```json
{
  "customerId": 50,
  "goalId": 25,
  "portfolioId": 5,
  "simulationId": 50,
  "orderType": "BUY",
  "totalAmount": 100000,
  "paymentMethod": "NEFT",
  "notes": "Initial lump sum investment",
  "items": [
    {
      "securityId": 150,
      "securityCode": "RELIANCE",
      "securityName": "Reliance Industries Ltd",
      "transactionType": "BUY",
      "amount": 30000
    },
    {
      "securityId": 151,
      "securityCode": "TCS",
      "securityName": "Tata Consultancy Services",
      "transactionType": "BUY",
      "amount": 30000
    },
    {
      "securityId": 152,
      "securityCode": "HDFC_BANK",
      "securityName": "HDFC Bank Ltd",
      "transactionType": "BUY",
      "amount": 40000
    }
  ]
}
```

**Response:** `201 Created`

```json
{
  "success": true,
  "message": "Order created successfully. Awaiting customer MFA approval.",
  "data": {
    "orderId": 100,
    "orderCode": "ORD2025001",
    "status": "PENDING_MFA",
    "totalAmount": 100000,
    "itemsCount": 3,
    "createdAt": "2025-12-24T12:20:00Z",
    "mfaDetails": {
      "mfaMethod": "SMS",
      "mfaSentTo": "+919876543210",
      "mfaExpiresAt": "2025-12-24T12:30:00Z"
    }
  },
  "timestamp": "2025-12-24T12:20:00Z"
}
```

---

### 11.2 Send Order for MFA Approval

**Endpoint:** `POST /api/v1/rm/orders/:id/send-for-approval`
**Access:** RM, SUPER_ADMIN
**Description:** Send order to customer for MFA approval

**Request Body:**

```json
{
  "mfaMethod": "SMS"
}
```

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "MFA code sent to customer successfully",
  "data": {
    "orderId": 100,
    "orderCode": "ORD2025001",
    "mfaMethod": "SMS",
    "mfaSentTo": "+919876***210",
    "mfaExpiresAt": "2025-12-24T12:30:00Z"
  },
  "timestamp": "2025-12-24T12:20:00Z"
}
```

---

### 11.3 Get MFA Status

**Endpoint:** `GET /api/v1/rm/orders/:id/mfa-status`
**Access:** RM, SUPER_ADMIN
**Description:** Check MFA approval status

**Response:** `200 OK` (Approved)

```json
{
  "success": true,
  "message": "Customer has approved the order",
  "data": {
    "orderId": 100,
    "orderCode": "ORD2025001",
    "mfaStatus": "VERIFIED",
    "verifiedAt": "2025-12-24T12:22:00Z",
    "orderStatus": "APPROVED",
    "nextStep": "SUBMIT_TO_TRADING_SYSTEM"
  },
  "timestamp": "2025-12-24T12:23:00Z"
}
```

---

### 11.4 Get Order Confirmation

**Endpoint:** `GET /api/v1/rm/orders/:id/confirmation`
**Access:** RM, SUPER_ADMIN
**Description:** Get order confirmation details (after execution)

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Order confirmation retrieved successfully. Journey stage updated to ORDER_PLACEMENT.",
  "data": {
    "orderId": 100,
    "orderCode": "ORD2025001",
    "customerName": "Raj Kumar",
    "goalName": "Child Education Fund",
    "portfolioName": "Balanced Growth - Moderate",
    "status": "EXECUTED",
    "totalAmount": 100000,
    "executedAt": "2025-12-24T12:25:00Z",
    "items": [
      {
        "securityName": "Reliance Industries Ltd",
        "quantity": 150.25,
        "price": 199.67,
        "amount": 30000,
        "fees": 30,
        "taxes": 54,
        "netAmount": 30084,
        "status": "EXECUTED",
        "executionReference": "NSE12345678"
      }
    ],
    "totalFees": 100,
    "totalTaxes": 180,
    "netAmount": 100280,
    "confirmationPdf": "https://cdn.scb.com/confirmations/ORD2025001.pdf"
  },
  "timestamp": "2025-12-24T12:26:00Z"
}
```

---

## 12. Journey Tracking

### 12.1 Get Current Journey

**Endpoint:** `GET /api/v1/journey/:customerId/current`
**Access:** RM, SUPER_ADMIN
**Description:** Get customer's current journey status

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Current journey retrieved successfully",
  "data": {
    "customerId": 50,
    "customerName": "Raj Kumar",
    "currentStage": "SIMULATION",
    "status": "IN_PROGRESS",
    "startedAt": "2025-11-01T10:00:00Z",
    "stageDetails": {
      "stageName": "SIMULATION",
      "attemptNumber": 1,
      "currentPage": "SIMULATION_RESULTS",
      "startedAt": "2025-12-24T12:11:00Z",
      "durationMinutes": 5
    },
    "completedStages": [
      {
        "stageName": "GOAL_CREATION",
        "completedAt": "2025-11-05T09:30:00Z",
        "attemptNumber": 1
      },
      {
        "stageName": "RISK_PROFILE",
        "completedAt": "2025-12-24T11:35:00Z",
        "attemptNumber": 2
      },
      {
        "stageName": "SUITABILITY",
        "completedAt": "2025-12-24T12:00:00Z",
        "attemptNumber": 1
      },
      {
        "stageName": "FINANCIAL_CALCULATION",
        "completedAt": "2025-12-24T12:10:00Z",
        "attemptNumber": 1
      },
      {
        "stageName": "PORTFOLIO_MATCHING",
        "completedAt": "2025-12-24T12:10:00Z",
        "attemptNumber": 1
      }
    ],
    "pendingStages": ["ORDER_PLACEMENT"],
    "overallProgress": 75
  },
  "timestamp": "2025-12-24T12:16:00Z"
}
```

---

### 12.2 Update Journey Stage

**Endpoint:** `PUT /api/v1/journey/:customerId/stage`
**Access:** RM, SUPER_ADMIN
**Description:** Manually update journey stage

**Request Body:**

```json
{
  "newStage": "ORDER_PLACEMENT",
  "reason": "Manual stage update after simulation review"
}
```

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Journey stage updated successfully",
  "data": {
    "customerId": 50,
    "previousStage": "SIMULATION",
    "currentStage": "ORDER_PLACEMENT",
    "updatedAt": "2025-12-24T12:30:00Z"
  },
  "timestamp": "2025-12-24T12:30:00Z"
}
```

---

### 12.3 Get Journey History

**Endpoint:** `GET /api/v1/journey/:customerId/history`
**Access:** RM, SUPER_ADMIN
**Description:** Get complete journey history

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Journey history retrieved successfully",
  "data": {
    "customerId": 50,
    "journeyStartedAt": "2025-11-01T10:00:00Z",
    "stages": [
      {
        "stageName": "GOAL_CREATION",
        "attemptNumber": 1,
        "startedAt": "2025-11-01T10:00:00Z",
        "completedAt": "2025-11-05T09:30:00Z",
        "durationDays": 4,
        "status": "COMPLETED"
      },
      {
        "stageName": "RISK_PROFILE",
        "attemptNumber": 1,
        "startedAt": "2025-11-05T09:30:00Z",
        "completedAt": "2025-11-05T10:30:00Z",
        "durationHours": 1,
        "status": "SUPERSEDED",
        "note": "Retaken due to changed financial situation"
      },
      {
        "stageName": "RISK_PROFILE",
        "attemptNumber": 2,
        "startedAt": "2025-12-24T11:00:00Z",
        "completedAt": "2025-12-24T11:35:00Z",
        "durationMinutes": 35,
        "status": "COMPLETED"
      }
    ],
    "editHistory": [
      {
        "timestamp": "2025-12-24T11:25:00Z",
        "entityType": "GOAL",
        "action": "REVISION",
        "details": "Goal amount revised from ₹50L to ₹55L",
        "changedByRm": "John Doe"
      }
    ]
  },
  "timestamp": "2025-12-24T12:32:00Z"
}
```

---

### 12.4 Get Audit Trail

**Endpoint:** `GET /api/v1/journey/:customerId/audit-trail`
**Access:** RM, SUPER_ADMIN
**Description:** Get complete audit trail of all actions

**Query Parameters:**

- `startDate` (optional)
- `endDate` (optional)
- `entityType` (optional): GOAL, RISK_PROFILE, etc.

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Audit trail retrieved successfully",
  "data": {
    "customerId": 50,
    "customerName": "Raj Kumar",
    "totalEntries": 45,
    "entries": [
      {
        "id": 500,
        "timestamp": "2025-12-24T12:20:00Z",
        "entityType": "ORDER",
        "entityId": 100,
        "action": "ORDER_CREATED",
        "details": "Order ORD2025001 created for ₹1,00,000",
        "changedByRm": {
          "id": 5,
          "name": "John Doe",
          "employeeId": "EMP001"
        },
        "ipAddress": "192.168.1.100",
        "userAgent": "Mozilla/5.0..."
      }
    ]
  },
  "timestamp": "2025-12-24T12:35:00Z"
}
```

---

## Super Admin - Asset Class Management

### Get Asset Classes

**Endpoint:** `GET /api/v1/admin/asset-classes`
**Access:** SUPER_ADMIN
**Description:** Get all asset classes

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Asset classes retrieved successfully",
  "data": [
    {
      "id": 1,
      "assetClassCode": "EQUITY",
      "assetClassName": "Equity",
      "description": "Stocks and equity mutual funds",
      "riskLevel": "HIGH",
      "expectedReturnMin": 12.0,
      "expectedReturnMax": 15.0,
      "liquidity": "MODERATE",
      "volatility": "HIGH",
      "isActive": true
    },
    {
      "id": 2,
      "assetClassCode": "DEBT",
      "assetClassName": "Debt",
      "description": "Bonds, fixed income, debt mutual funds",
      "riskLevel": "LOW",
      "expectedReturnMin": 6.0,
      "expectedReturnMax": 8.0,
      "liquidity": "HIGH",
      "volatility": "LOW",
      "isActive": true
    }
  ],
  "timestamp": "2025-12-24T11:00:00Z"
}
```

---

### Create Asset Class

**Endpoint:** `POST /api/v1/admin/asset-classes`
**Access:** SUPER_ADMIN
**Description:** Create new asset class

**Request Body:**

```json
{
  "assetClassCode": "GOLD",
  "assetClassName": "Gold",
  "description": "Gold ETFs and sovereign gold bonds",
  "riskLevel": "MEDIUM",
  "expectedReturnMin": 8.0,
  "expectedReturnMax": 10.0,
  "liquidity": "HIGH",
  "volatility": "MEDIUM",
  "taxEfficiency": "HIGH",
  "timeHorizonMinYears": 3
}
```

**Response:** `201 Created`

```json
{
  "success": true,
  "message": "Asset class created successfully",
  "data": {
    "id": 3,
    "assetClassCode": "GOLD",
    "assetClassName": "Gold",
    "isActive": true,
    "createdAt": "2025-12-24T11:05:00Z"
  },
  "timestamp": "2025-12-24T11:05:00Z"
}
```

---

### Update Asset Class

**Endpoint:** `PUT /api/v1/admin/asset-classes/:id`
**Access:** SUPER_ADMIN
**Description:** Update asset class

**Request Body:**

```json
{
  "description": "Updated description",
  "expectedReturnMin": 8.5,
  "expectedReturnMax": 10.5
}
```

**Response:** `200 OK`

---

### Delete Asset Class

**Endpoint:** `DELETE /api/v1/admin/asset-classes/:id`
**Access:** SUPER_ADMIN
**Description:** Soft delete asset class

**Response:** `204 No Content`

---

## Customer APIs

### Customer Profile Management

#### Get Customer Profile

**Endpoint:** `GET /api/v1/customer/profile`
**Access:** CUSTOMER
**Description:** Get current customer's profile

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Profile retrieved successfully",
  "data": {
    "id": 50,
    "customerCode": "CUS001",
    "user": {
      "id": 100,
      "email": "raj.kumar@email.com",
      "firstName": "Raj",
      "lastName": "Kumar",
      "phoneNumber": "+919876543210"
    },
    "dateOfBirth": "1985-03-15",
    "age": 40,
    "gender": "MALE",
    "maritalStatus": "MARRIED",
    "numberOfDependents": 2,
    "occupation": "Software Engineer",
    "employmentType": "SALARIED",
    "monthlySurplus": 50000,
    "existingInvestments": 2000000,
    "outstandingLiabilities": 500000,
    "address": {
      "addressLine1": "123 Main Street",
      "city": "Mumbai",
      "state": "Maharashtra",
      "country": "India",
      "pincode": "400001"
    },
    "rm": {
      "id": 5,
      "name": "John Doe",
      "email": "john.doe@scb.com",
      "phoneNumber": "+919876543210"
    },
    "riskProfileCompleted": true,
    "suitabilityCompleted": true,
    "onboardingCompleted": true,
    "createdAt": "2025-11-01T10:00:00Z"
  },
  "timestamp": "2025-12-24T12:00:00Z"
}
```

---

#### Update Customer Profile

**Endpoint:** `PUT /api/v1/customer/profile`
**Access:** CUSTOMER
**Description:** Update customer profile information

**Request Body:**

```json
{
  "phoneNumber": "+919123456789",
  "occupation": "Senior Software Engineer",
  "monthlySurplus": 60000,
  "addressLine1": "456 New Street",
  "city": "Mumbai",
  "state": "Maharashtra",
  "pincode": "400002"
}
```

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Profile updated successfully",
  "data": {
    "id": 50,
    "phoneNumber": "+919123456789",
    "updatedAt": "2025-12-24T12:05:00Z"
  },
  "timestamp": "2025-12-24T12:05:00Z"
}
```

---

### Customer Dashboard

#### Get Customer Dashboard

**Endpoint:** `GET /api/v1/customer/dashboard`
**Access:** CUSTOMER
**Description:** Get customer dashboard summary

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Dashboard data retrieved successfully",
  "data": {
    "welcomeMessage": "Welcome back, Raj!",
    "profileCompletion": 95,
    "riskProfile": {
      "score": 24,
      "category": "BALANCE",
      "categoryName": "Balance",
      "validUntil": "2026-11-05",
      "daysRemaining": 300,
      "needsRetake": false
    },
    "suitabilityAssessment": {
      "level": "MODERATE_SUITABILITY",
      "score": 75,
      "validUntil": "2026-11-05",
      "mifidCompliant": true,
      "knowledgeTestPassed": true
    },
    "goalsSummary": {
      "totalGoals": 3,
      "activeGoals": 2,
      "completedGoals": 0,
      "totalTargetAmount": 75000000,
      "totalCurrentValue": 5000000,
      "overallProgress": 6.67
    },
    "portfolioSummary": {
      "recommendedPortfolio": "Balanced Growth - Moderate",
      "totalInvestment": 5000000,
      "currentValue": 5250000,
      "totalReturns": 250000,
      "returnsPercentage": 5.0
    },
    "journeyStatus": {
      "currentStage": "PORTFOLIO_MATCHING",
      "stageProgress": 75,
      "nextAction": "Review and approve portfolio recommendation"
    },
    "quickActions": [
      {
        "action": "VIEW_GOALS",
        "title": "View My Goals",
        "description": "Track your financial goals"
      },
      {
        "action": "VIEW_PORTFOLIO",
        "title": "View Portfolio",
        "description": "See your recommended portfolio"
      }
    ]
  },
  "timestamp": "2025-12-24T12:10:00Z"
}
```

---

### Customer Risk Profile Assessment

#### Get Risk Profile Questions (Customer View)

**Endpoint:** `GET /api/v1/customer/risk-profile/questions`
**Access:** CUSTOMER
**Description:** Get risk profile questionnaire for self-assessment

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Risk profile questions retrieved successfully",
  "data": {
    "questionnaireInfo": {
      "title": "Risk Profile Assessment",
      "description": "This questionnaire helps us understand your risk tolerance and investment preferences",
      "estimatedTime": "10-15 minutes",
      "totalQuestions": 8
    },
    "questions": [
      {
        "id": 1,
        "questionCode": "AGE_GROUP",
        "questionText": "What is your current age?",
        "questionType": "SINGLE_SELECT",
        "clientNotes": "Your age affects your risk capacity",
        "isRequired": true,
        "displayOrder": 1,
        "options": [
          {
            "id": 1,
            "optionText": "Under 25",
            "displayOrder": 1
          },
          {
            "id": 2,
            "optionText": "25-35",
            "displayOrder": 2
          }
        ]
      }
    ]
  },
  "timestamp": "2025-12-24T12:15:00Z"
}
```

---

#### Submit Risk Profile Assessment (Customer)

**Endpoint:** `POST /api/v1/customer/risk-profile/submit`
**Access:** CUSTOMER
**Description:** Submit risk profile self-assessment

**Request Body:**

```json
{
  "answers": [
    {
      "questionId": 1,
      "selectedOptionIds": [2]
    },
    {
      "questionId": 2,
      "selectedOptionIds": [8]
    }
  ]
}
```

**Response:** `201 Created`

```json
{
  "success": true,
  "message": "Risk profile assessment submitted successfully",
  "data": {
    "riskProfileId": 15,
    "assessmentDate": "2025-12-24T12:20:00Z",
    "totalScore": 24,
    "riskCategory": {
      "code": "BALANCE",
      "name": "Balance",
      "description": "Balanced investors seeking growth with moderate risk",
      "recommendedAllocation": "60% Equity / 40% Debt"
    },
    "validUntil": "2026-12-24",
    "nextStep": "SUITABILITY_ASSESSMENT"
  },
  "timestamp": "2025-12-24T12:20:00Z"
}
```

---

#### Get Customer Risk Profile

**Endpoint:** `GET /api/v1/customer/risk-profile`
**Access:** CUSTOMER
**Description:** Get customer's latest risk profile

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Risk profile retrieved successfully",
  "data": {
    "id": 15,
    "assessmentDate": "2025-12-24T12:20:00Z",
    "totalScore": 24,
    "riskCategory": {
      "code": "BALANCE",
      "name": "Balance",
      "description": "Balanced investors seeking growth with moderate risk"
    },
    "validUntil": "2026-12-24",
    "isActive": true,
    "canRetake": false,
    "answers": [
      {
        "questionText": "What is your current age?",
        "selectedOptions": ["25-35"]
      }
    ]
  },
  "timestamp": "2025-12-24T12:25:00Z"
}
```

---

### Customer Suitability Assessment

#### Get Suitability Questions (Customer View)

**Endpoint:** `GET /api/v1/customer/suitability/questions`
**Access:** CUSTOMER
**Description:** Get suitability questionnaire

**Response:** Similar to Risk Profile Questions structure

---

#### Submit Suitability Assessment (Customer)

**Endpoint:** `POST /api/v1/customer/suitability/submit`
**Access:** CUSTOMER
**Description:** Submit suitability self-assessment

**Request Body:**

```json
{
  "answers": [
    {
      "questionId": 50,
      "selectedOptionIds": [201]
    }
  ]
}
```

**Response:** `201 Created`

```json
{
  "success": true,
  "message": "Suitability assessment submitted successfully",
  "data": {
    "suitabilityAssessmentId": 20,
    "assessmentDate": "2025-12-24T12:30:00Z",
    "overallScore": 75,
    "suitabilityLevel": "HIGH_SUITABILITY",
    "knowledgeScore": 75,
    "experienceScore": 80,
    "riskCapacityScore": 75,
    "financialSituationScore": 80,
    "knowledgeTestPassed": true,
    "knowledgeTestPercentage": 100,
    "mifidIICompliant": true,
    "validUntil": "2026-12-24",
    "nextStep": "GOAL_CREATION"
  },
  "timestamp": "2025-12-24T12:30:00Z"
}
```

---

#### Get Customer Suitability

**Endpoint:** `GET /api/v1/customer/suitability`
**Access:** CUSTOMER
**Description:** Get customer's suitability assessment

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Suitability assessment retrieved successfully",
  "data": {
    "id": 20,
    "assessmentDate": "2025-12-24T12:30:00Z",
    "overallScore": 75,
    "suitabilityLevel": "HIGH_SUITABILITY",
    "knowledgeScore": 75,
    "experienceScore": 80,
    "riskCapacityScore": 75,
    "financialSituationScore": 80,
    "knowledgeTestPassed": true,
    "mifidIICompliant": true,
    "validUntil": "2026-12-24",
    "isBlocked": false
  },
  "timestamp": "2025-12-24T12:35:00Z"
}
```

---

### Customer Goal Management

#### Get Customer Goals

**Endpoint:** `GET /api/v1/customer/goals`
**Access:** CUSTOMER
**Description:** Get all goals for customer

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Goals retrieved successfully",
  "data": [
    {
      "id": 10,
      "goalName": "Retirement Fund",
      "goalType": "RETIREMENT",
      "targetAmount": 50000000,
      "targetDate": "2045-03-15",
      "timeHorizonYears": 20,
      "currentValue": 2000000,
      "progress": 4.0,
      "monthlyInvestment": 25000,
      "lumpsumInvestment": 500000,
      "priority": "HIGH",
      "status": "ACTIVE",
      "recommendedPortfolio": "Balanced Growth - Moderate",
      "achievementProbability": 85.0,
      "isAchievable": true
    }
  ],
  "timestamp": "2025-12-24T12:40:00Z"
}
```

---

#### Get Goal Details

**Endpoint:** `GET /api/v1/customer/goals/:id`
**Access:** CUSTOMER
**Description:** Get detailed goal information

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Goal details retrieved successfully",
  "data": {
    "id": 10,
    "goalName": "Retirement Fund",
    "goalType": "RETIREMENT",
    "description": "Build corpus for comfortable retirement",
    "targetAmount": 50000000,
    "corpusRequiredWithInflation": 214842950,
    "targetDate": "2045-03-15",
    "timeHorizonYears": 20,
    "currentValue": 2000000,
    "progress": 4.0,
    "monthlyInvestment": 25000,
    "lumpsumInvestment": 500000,
    "expectedReturnRate": 11.5,
    "inflationRate": 6.0,
    "priority": "HIGH",
    "status": "ACTIVE",
    "recommendedPortfolio": {
      "id": 5,
      "portfolioName": "Balanced Growth - Moderate",
      "portfolioCode": "BAL_MOD_01",
      "expectedReturnMin": 10.0,
      "expectedReturnMax": 13.0,
      "assetAllocations": [
        {
          "assetClass": "Equity",
          "targetAllocation": 60.0
        },
        {
          "assetClass": "Debt",
          "targetAllocation": 40.0
        }
      ]
    },
    "achievementProbability": 85.0,
    "isAchievable": true,
    "createdAt": "2025-11-05T09:00:00Z"
  },
  "timestamp": "2025-12-24T12:45:00Z"
}
```

---

### Customer Journey Tracking

#### Get Customer Journey

**Endpoint:** `GET /api/v1/customer/journey`
**Access:** CUSTOMER
**Description:** Get customer's journey status

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Journey status retrieved successfully",
  "data": {
    "currentStage": "PORTFOLIO_MATCHING",
    "stageProgress": 75,
    "completedStages": [
      {
        "stageName": "PROFILE_CREATION",
        "stageTitle": "Profile Setup",
        "completedAt": "2025-11-01T10:00:00Z",
        "icon": "user"
      },
      {
        "stageName": "RISK_ASSESSMENT",
        "stageTitle": "Risk Profile",
        "completedAt": "2025-11-05T10:30:00Z",
        "icon": "chart"
      },
      {
        "stageName": "SUITABILITY_ASSESSMENT",
        "stageTitle": "Suitability Check",
        "completedAt": "2025-11-05T11:00:00Z",
        "icon": "checkmark"
      },
      {
        "stageName": "GOAL_DEFINITION",
        "stageTitle": "Goal Setting",
        "completedAt": "2025-11-05T12:00:00Z",
        "icon": "target"
      }
    ],
    "currentStageDetails": {
      "stageName": "PORTFOLIO_MATCHING",
      "stageTitle": "Portfolio Recommendation",
      "description": "Matching your goals with suitable investment portfolios",
      "estimatedTime": "Review with your RM",
      "icon": "briefcase",
      "status": "IN_PROGRESS"
    },
    "pendingStages": [
      {
        "stageName": "INVESTMENT_PROPOSAL",
        "stageTitle": "Investment Proposal",
        "icon": "document"
      }
    ],
    "overallProgress": 75
  },
  "timestamp": "2025-12-24T12:50:00Z"
}
```

---

### Customer Financial Calculator

#### Calculate SIP Future Value

**Endpoint:** `POST /api/v1/customer/calculator/sip`
**Access:** CUSTOMER
**Description:** Calculate SIP future value

**Request Body:**

```json
{
  "monthlyInvestment": 15000,
  "expectedReturnRate": 11.5,
  "years": 10
}
```

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "SIP calculation completed successfully",
  "data": {
    "monthlyInvestment": 15000,
    "expectedReturnRate": 11.5,
    "years": 10,
    "totalInvestment": 1800000,
    "futureValue": 3250000,
    "totalReturns": 1450000,
    "returnPercentage": 80.56
  },
  "timestamp": "2025-12-24T12:55:00Z"
}
```

---

#### Calculate Lumpsum Future Value

**Endpoint:** `POST /api/v1/customer/calculator/lumpsum`
**Access:** CUSTOMER
**Description:** Calculate lumpsum future value

**Request Body:**

```json
{
  "investmentAmount": 100000,
  "expectedReturnRate": 11.5,
  "years": 10
}
```

**Response:** `200 OK`

---

### Customer Portfolio View

#### Get Recommended Portfolio

**Endpoint:** `GET /api/v1/customer/portfolio/recommended`
**Access:** CUSTOMER
**Description:** Get recommended portfolio for customer

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Recommended portfolio retrieved successfully",
  "data": {
    "portfolio": {
      "id": 5,
      "portfolioCode": "BAL_MOD_01",
      "portfolioName": "Balanced Growth - Moderate",
      "description": "Balanced portfolio for long-term wealth creation",
      "expectedReturnMin": 10.0,
      "expectedReturnMax": 13.0,
      "volatilityPercentage": 9.5,
      "timeHorizonMinYears": 5,
      "riskLevel": "MODERATE"
    },
    "assetAllocations": [
      {
        "assetClass": {
          "code": "EQUITY",
          "name": "Equity"
        },
        "targetAllocation": 60.0,
        "minAllocation": 57.0,
        "maxAllocation": 63.0
      },
      {
        "assetClass": {
          "code": "DEBT",
          "name": "Debt"
        },
        "targetAllocation": 40.0,
        "minAllocation": 32.0,
        "maxAllocation": 43.0
      }
    ],
    "matchScore": 95.5,
    "matchReason": "This portfolio aligns with your BALANCE risk profile and 10-11.5% expected return requirement"
  },
  "timestamp": "2025-12-24T13:00:00Z"
}
```

---

### Customer MFA Approval

#### Approve Order with MFA

**Endpoint:** `POST /api/v1/customer/orders/:id/approve`
**Access:** CUSTOMER
**Description:** Approve investment order with MFA code

**Request Body:**

```json
{
  "mfaCode": "123456"
}
```

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Order approved successfully",
  "data": {
    "orderId": 100,
    "orderCode": "ORD2025001",
    "status": "APPROVED",
    "approvedAt": "2025-12-24T13:05:00Z",
    "nextStep": "Order will be submitted to trading system"
  },
  "timestamp": "2025-12-24T13:05:00Z"
}
```

---

#### Reject Order

**Endpoint:** `POST /api/v1/customer/orders/:id/reject`
**Access:** CUSTOMER
**Description:** Reject investment order

**Request Body:**

```json
{
  "reason": "I want to revise the investment amount"
}
```

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Order rejected successfully",
  "data": {
    "orderId": 100,
    "orderCode": "ORD2025001",
    "status": "REJECTED",
    "rejectedAt": "2025-12-24T13:10:00Z",
    "reason": "I want to revise the investment amount"
  },
  "timestamp": "2025-12-24T13:10:00Z"
}
```

---

## Error Response Examples

### 400 Bad Request - Validation Error

```json
{
  "success": false,
  "message": "Validation failed",
  "errors": [
    {
      "field": "targetAmount",
      "message": "Goal amount must be at least ₹10,000",
      "code": "OUT_OF_RANGE",
      "rejectedValue": 5000
    },
    {
      "field": "targetDate",
      "message": "Target date must be in the future",
      "code": "INVALID_FORMAT",
      "rejectedValue": "2023-01-01"
    }
  ],
  "timestamp": "2025-12-24T12:40:00Z"
}
```

### 401 Unauthorized

```json
{
  "success": false,
  "message": "Authentication required",
  "error": {
    "code": "UNAUTHORIZED",
    "details": "JWT token is missing or invalid"
  },
  "timestamp": "2025-12-24T12:41:00Z"
}
```

### 403 Forbidden

```json
{
  "success": false,
  "message": "Access denied",
  "error": {
    "code": "FORBIDDEN",
    "details": "You do not have permission to access this customer's data"
  },
  "timestamp": "2025-12-24T12:42:00Z"
}
```

### 404 Not Found

```json
{
  "success": false,
  "message": "Resource not found",
  "error": {
    "code": "NOT_FOUND",
    "details": "Customer with ID 999 not found"
  },
  "timestamp": "2025-12-24T12:43:00Z"
}
```

### 409 Conflict

```json
{
  "success": false,
  "message": "Resource already exists",
  "error": {
    "code": "DUPLICATE_ENTRY",
    "details": "Email address is already registered",
    "field": "email"
  },
  "timestamp": "2025-12-24T12:44:00Z"
}
```

### 422 Unprocessable Entity

```json
{
  "success": false,
  "message": "Business rule violation",
  "error": {
    "code": "BUSINESS_RULE_VIOLATION",
    "details": "Cannot create order: customer's risk profile has expired. Please retake risk assessment."
  },
  "timestamp": "2025-12-24T12:45:00Z"
}
```

### 500 Internal Server Error

```json
{
  "success": false,
  "message": "Internal server error occurred",
  "error": {
    "code": "INTERNAL_SERVER_ERROR",
    "details": "An unexpected error occurred. Please contact support.",
    "errorId": "ERR-20251224-124600-ABC123"
  },
  "timestamp": "2025-12-24T12:46:00Z"
}
```

---

## Rate Limiting

API endpoints are rate-limited to prevent abuse:

**Limits:**

- Authentication endpoints: 5 requests per minute
- Read operations (GET): 100 requests per minute
- Write operations (POST/PUT/DELETE): 50 requests per minute

**Rate Limit Headers:**

```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 85
X-RateLimit-Reset: 1703520000
```

**Rate Limit Exceeded Response:** `429 Too Many Requests`

```json
{
  "success": false,
  "message": "Rate limit exceeded",
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "details": "Too many requests. Please try again in 30 seconds.",
    "retryAfter": 30
  },
  "timestamp": "2025-12-24T12:47:00Z"
}
```

---

## Pagination

Paginated endpoints support the following query parameters:

**Parameters:**

- `page`: Page number (0-indexed, default: 0)
- `size`: Page size (default: 20, max: 100)
- `sort`: Sort field and direction (e.g., `createdAt,desc`)

**Example:**

```
GET /api/v1/rm/customers?page=0&size=20&sort=createdAt,desc
```

---

## API Documentation & Testing

### Swagger UI

Interactive API documentation available at:

```
http://localhost:8080/swagger-ui/index.html
```

### OpenAPI Specification

JSON specification available at:

```
http://localhost:8080/v3/api-docs
```

---

**Document Status:** ✅ **COMPLETE - Phase 1 Ready**
**Last Updated:** December 26, 2025
**Version:** 2.1 Final (Phase 1 Only - No Order Execution)
**Total Endpoints:** 104

## API Summary by Persona

| Persona              | API Groups                                                                                                                       | Total Endpoints |
| -------------------- | -------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| **Public/Auth**      | Authentication & User Management                                                                                                 | 12              |
| **Super Admin**      | User Management (8), Questionnaire Config (14), Portfolio Config (13), Risk Categories (3), Asset Classes (4), Dashboard (2)     | 44              |
| **RM**               | Customer Management (4), Goals (4), Risk Profile (6), Suitability (3), Calculator (3), Simulation (3), Orders (4)                | 27              |
| **Journey Tracking** | Current, Update, History, Audit Trail (Shared by RM)                                                                             | 4               |
| **Customer**         | Profile (2), Dashboard (1), Risk Profile (3), Suitability (3), Goals (2), Journey (1), Calculator (2), Portfolio (1), Orders (2) | 17              |

**Phase 1 Scope:** Customer Onboarding → Goal Creation → Risk Assessment → Suitability → Calculator → Portfolio Recommendation
**⚠️ Out of Scope (Phase 2):** Order Execution, Order Management, Rebalancing

## Coverage Checklist

### Authentication ✅

- [x] Sign up/Register
- [x] Login
- [x] Logout
- [x] Refresh Token
- [x] Forgot Password
- [x] Reset Password
- [x] Email Verification
- [x] Resend Verification
- [x] Check Email Availability
- [x] Change Password
- [x] Get/Update Profile

### Super Admin ✅

- [x] User Management (List, Get, Update, Delete, Activate/Deactivate)
- [x] RM Management (List, Get Details, Assign Customers)
- [x] Dashboard Statistics
- [x] Questionnaire Management (Types, Questions, Options, Dependencies)
- [x] Question Weight Management
- [x] Portfolio Management (CRUD, Allocations, Securities)
- [x] Risk Category Management
- [x] Asset Class Management (CRUD)

### RM APIs ✅ (Phase 1)

- [x] Customer Management (List, Create, Get Details, Dashboard)
- [x] Goal Management (List, Create, **Get Details**, Revise)
- [x] Risk Profile Assessment (Questions, Submit, **Get Latest**, History, Retake, Report)
- [x] Suitability Assessment (Questions, Submit, **Get Latest**)
- [x] Financial Calculator (Corpus, Required Return, Portfolio Match)
- [x] Portfolio Simulation (Run, Status, Results)
- [x] Order Management (Create, Send for Approval, MFA Status, Confirmation) - **View Only**
- [x] Journey Tracking (Current, Update, History, Audit Trail)

### Customer APIs ✅ (Phase 1 - Read Only)

- [x] Profile Management (Get, Update)
- [x] Dashboard (Summary)
- [x] Risk Profile Self-Assessment (Questions, Submit, Get Results)
- [x] Suitability Self-Assessment (Questions, Submit, Get Results)
- [x] Goal Management (List, Get Details)
- [x] Journey Tracking (Get Status)
- [x] Financial Calculator (SIP, Lumpsum)
- [x] Portfolio View (Recommended Portfolio)
- [x] Order Approval/Rejection (Approve, Reject) - **RM approves on behalf**

## Database Schema Alignment ✅

All APIs align with the database schema created in:

- `/GBS-backend/src/main/java/com/avaloq/gbs/model/`
- Comprehensive seed data in `/GBS-backend/src/main/resources/data.sql`
- 19 JPA entities covering all 6 focus areas:
  1. Risk Profile Questionnaire ✅
  2. Suitability Questionnaire ✅
  3. Model Portfolio ✅
  4. Risk Score ✅
  5. Financial Calculator ✅
  6. Amount Distribution ✅

## Key Features Covered

### Positive Test Cases ✅

- Successful assessments
- Portfolio matching
- Goal achievement
- All risk categories (SECURE to SPECULATIVE)
- MiFID II compliance

### Negative Test Cases ✅

- Failed knowledge test (< 60%)
- Blocked assessments (no emergency fund)
- Incomplete assessments
- Expired assessments
- Goals not achievable
- Low suitability scores

## Next Steps for Implementation

1. **Backend Development Priority:**

   - Implement authentication & authorization
   - Super Admin APIs (questionnaire configuration)
   - RM APIs (customer management, assessments)
   - Customer APIs (self-service assessments)
   - Financial calculator logic
   - Portfolio matching algorithm

2. **Frontend Development Priority:**
   - Admin dashboard & configuration screens
   - RM dashboard & customer management
   - Customer portal (assessments, goals, portfolio view)
   - Journey tracking visualization
   - Financial calculator UI
   - Order approval workflow

---

**Comprehensive API Specifications Complete** ✅

---

## Complete API Endpoint Reference with Line Numbers

All **104 API endpoints** organized by persona with line number citations for easy navigation:

**✨ Phase 1 Complete:** 104 endpoints covering full workflow from customer onboarding to portfolio recommendation.

---

### **1. Authentication & User Management APIs (12 endpoints)**

1. `POST /api/v1/auth/register` - Line 175
2. `POST /api/v1/auth/login` - Line 228
3. `POST /api/v1/auth/refresh-token` - Line 266
4. `POST /api/v1/auth/logout` - Line 295
5. `GET /api/v1/users/profile` - Line 312
6. `PUT /api/v1/users/profile` - Line 351
7. `POST /api/v1/users/change-password` - Line 384
8. `GET /api/v1/auth/verify-email/:token` - Line 410
9. `POST /api/v1/auth/forgot-password` - Line 427
10. `POST /api/v1/auth/reset-password/:token` - Line 455
11. `POST /api/v1/auth/resend-verification` - Line 480
12. `GET /api/v1/auth/check-email/:email` - Line 504

---

### **2. Super Admin APIs (44 endpoints)**

#### User & RM Management (8 endpoints)

13. `GET /api/v1/admin/users` - Line 527
14. `GET /api/v1/admin/users/:id` - Line 571
15. `PUT /api/v1/admin/users/:id` - Line 609
16. `PATCH /api/v1/admin/users/:id/status` - Line 643
17. `DELETE /api/v1/admin/users/:id` - Line 674
18. `GET /api/v1/admin/rms` - Line 684
19. `GET /api/v1/admin/rms/:id` - Line 726
20. `GET /api/v1/admin/dashboard/stats` - Line 766

#### Questionnaire Configuration (14 endpoints)

21. `GET /api/v1/admin/questionnaire-types` - Line 799
22. `POST /api/v1/admin/questionnaire-types` - Line 832
23. ** `PUT /api/v1/admin/questionnaire-types/:id`** - Line 867
24. ** `DELETE /api/v1/admin/questionnaire-types/:id`** - Line 901
25. `GET /api/v1/admin/questions` - Line 917
26. `POST /api/v1/admin/questions` - Line 980
27. `PUT /api/v1/admin/questions/:id` - Line 1055
28. `PUT /api/v1/admin/questions/:id/weight` - Line 1088
29. `DELETE /api/v1/admin/questions/:id` - Line 1121
30. ** `GET /api/v1/admin/questions/:id/options`** - Line 1130
31. ** `POST /api/v1/admin/questions/:id/options`** - Line 1169
32. ** `PUT /api/v1/admin/options/:id`** - Line 1210
33. ** `DELETE /api/v1/admin/options/:id`** - Line 1245
34. ** `GET /api/v1/admin/questions/:id/dependencies`** - Line 1255
35. `POST /api/v1/admin/questions/:id/dependencies` - Line 1283
36. ** `DELETE /api/v1/admin/dependencies/:id`** - Line 1318

#### Portfolio & Risk Configuration (13 endpoints)

37. `GET /api/v1/admin/portfolios` - Line 1330
38. `POST /api/v1/admin/portfolios` - Line 1392
39. ** `GET /api/v1/admin/portfolios/:id`** - Line 1443
40. ** `PUT /api/v1/admin/portfolios/:id`** - Line 1501
41. ** `DELETE /api/v1/admin/portfolios/:id`** - Line 1540
42. ** `GET /api/v1/admin/portfolios/:id/allocations`** - Line 1557
43. `POST /api/v1/admin/portfolios/:id/allocations` - Line 1602
44. ** `PUT /api/v1/admin/allocations/:id`** - Line 1641
45. ** `DELETE /api/v1/admin/allocations/:id`** - Line 1677
46. ** `GET /api/v1/admin/portfolios/:id/securities`** - Line 1687
47. `POST /api/v1/admin/portfolios/:id/securities` - Line 1732
48. ** `PUT /api/v1/admin/securities/:id`** - Line 1768
49. ** `DELETE /api/v1/admin/securities/:id`** - Line 1801
50. `GET /api/v1/admin/risk-categories` - Line 1813
51. `PUT /api/v1/admin/risk-categories/:id` - Line 1844
52. `GET /api/v1/admin/risk-categories/validate-ranges` - Line 1877

#### Asset Class Management (4 endpoints)

53. `GET /api/v1/admin/asset-classes` - Line 3424
54. `POST /api/v1/admin/asset-classes` - Line 3467
55. `PUT /api/v1/admin/asset-classes/:id` - Line 3507
56. `DELETE /api/v1/admin/asset-classes/:id` - Line 3526

---

### **3. Relationship Manager (RM) APIs (31 endpoints)**

#### Customer Management (4 endpoints)

57. `GET /api/v1/rm/customers` - Line 1923
58. `POST /api/v1/rm/customers` - Line 1970
59. `GET /api/v1/rm/customers/:id` - Line 2017
60. `GET /api/v1/rm/customers/:id/dashboard` - Line 2091

#### Goal Management (4 endpoints) **+1 NEW**

61. `GET /api/v1/rm/goals/:customerId` - Line 2139
62. `POST /api/v1/rm/goals` - Line 2181
63. ** `GET /api/v1/rm/goals/:id`** - Line 2225
64. `POST /api/v1/rm/goals/:id/revise` - Line 2274

#### Risk Profile Assessment (6 endpoints)

65. `GET /api/v1/rm/risk-profile/questions` - Line 2309
66. `POST /api/v1/rm/risk-profile/submit` - Line 2393
67. `GET /api/v1/rm/risk-profile/:customerId/latest` - Line 2461
68. `GET /api/v1/rm/risk-profile/:customerId/history` - Line 2503
69. `POST /api/v1/rm/risk-profile/:id/retake` - Line 2538
70. `GET /api/v1/rm/risk-profile/:id/report` - Line 2569

#### Suitability Assessment (3 endpoints)

71. `GET /api/v1/rm/suitability/questions` - Line 2588
72. `POST /api/v1/rm/suitability/submit` - Line 2598
73. ** `GET /api/v1/rm/suitability/:customerId/latest`** - Line 2647

#### Financial Calculator (3 endpoints)

74. `POST /api/v1/rm/calculator/corpus` - Line 2718
75. `POST /api/v1/rm/calculator/required-return` - Line 2761
76. `POST /api/v1/rm/calculator/match-portfolio` - Line 2806

#### Portfolio Simulation (3 endpoints)

77. `POST /api/v1/rm/simulation/run` - Line 2920
78. `GET /api/v1/rm/simulation/:id/status` - Line 2956
79. `GET /api/v1/rm/simulation/:id/results` - Line 2980

#### Order Management (4 endpoints)

80. `POST /api/v1/rm/orders` - Line 3061
81. `POST /api/v1/rm/orders/:id/send-for-approval` - Line 3128
82. `GET /api/v1/rm/orders/:id/mfa-status` - Line 3159
83. `GET /api/v1/rm/orders/:id/confirmation` - Line 3184

### **4. Journey Tracking (4 endpoints)** - Shared by RM

84. `GET /api/v1/journey/:customerId/current` - Line 3230
85. `PUT /api/v1/journey/:customerId/stage` - Line 3292
86. `GET /api/v1/journey/:customerId/history` - Line 3323
87. `GET /api/v1/journey/:customerId/audit-trail` - Line 3380

---

### **5. Customer APIs (17 endpoints)**

#### Profile Management (2 endpoints)

88. `GET /api/v1/customer/profile` - Line 3540
89. `PUT /api/v1/customer/profile` - Line 3597

#### Dashboard (1 endpoint)

90. `GET /api/v1/customer/dashboard` - Line 3637

#### Risk Profile Self-Assessment (3 endpoints)

91. `GET /api/v1/customer/risk-profile/questions` - Line 3707
92. `POST /api/v1/customer/risk-profile/submit` - Line 3755
93. `GET /api/v1/customer/risk-profile` - Line 3801

#### Suitability Self-Assessment (3 endpoints)

94. `GET /api/v1/customer/suitability/questions` - Line 3839
95. `POST /api/v1/customer/suitability/submit` - Line 3849
96. `GET /api/v1/customer/suitability` - Line 3893

#### Goal Management (2 endpoints)

97. `GET /api/v1/customer/goals` - Line 3926
98. `GET /api/v1/customer/goals/:id` - Line 3962

#### Journey Tracking (1 endpoint)

99. `GET /api/v1/customer/journey` - Line 4019

#### Financial Calculator (2 endpoints)

100. `POST /api/v1/customer/calculator/sip` - Line 4084
101. `POST /api/v1/customer/calculator/lumpsum` - Line 4119

#### Portfolio View (1 endpoint)

102. `GET /api/v1/customer/portfolio/recommended` - Line 4140

#### Order Approval - MFA (2 endpoints)

103. `POST /api/v1/customer/orders/:id/approve` - Line 4194
104. `POST /api/v1/customer/orders/:id/reject` - Line 4225

---

## Quick Reference Summary

| Persona                   | Endpoint Count | Line Range              |
| ------------------------- | -------------- | ----------------------- |
| **Authentication & User** | 12             | Lines 175-504           |
| **Super Admin**           | 44             | Lines 527-3526          |
| **Relationship Manager**  | 27             | Lines 1923-3184         |
| **Journey Tracking**      | 4              | Lines 3230-3380         |
| **Customer**              | 17             | Lines 3540-4225         |
| **TOTAL**                 | **104**        | **Phase 1 Complete ✅** |

---

** Version 2.1 Updates:**

- Added 17 Super Admin CRUD endpoints
- Added 1 RM Goal Details endpoint
- Added 1 RM Suitability Latest endpoint
- **Total: 19 new endpoints** (from 85 to 104)

**Note:** Use these line numbers to quickly navigate to any API endpoint in this document.
