# GBA System - Frontend Components Guide
## Angular 19 Implementation

**Version:** 1.0 Final
**Date:** December 24, 2025
**Framework:** Angular 19 + TypeScript 5.7 + Tailwind CSS v4

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Project Structure](#project-structure)
3. [Modern Angular 19 Patterns](#modern-angular-19-patterns)
4. [Core Services](#core-services)
5. [Component Library](#component-library)
6. [Feature Modules](#feature-modules)
7. [Routing Configuration](#routing-configuration)
8. [State Management](#state-management)
9. [Forms & Validation](#forms--validation)
10. [Styling Guide](#styling-guide)

---

## Architecture Overview

### Technology Stack

| Layer | Technology |
|-------|-----------|
| **Framework** | Angular 19 (Standalone Components) |
| **Language** | TypeScript 5.7 (Strict Mode) |
| **State** | Angular Signals |
| **Routing** | Angular Router |
| **Forms** | Reactive Forms |
| **HTTP** | HttpClient |
| **Styling** | Tailwind CSS v4 |
| **SSR** | Angular Universal (SSR) |
| **Testing** | Jasmine + Karma |

### Design Principles

1. **Signals-First**: Use signals for all reactive state
2. **Standalone Components**: No NgModules (Angular 19 modern approach)
3. **OnPush Change Detection**: Always use OnPush strategy
4. **Modern Syntax**: `@if`, `@for`, `@switch` (NO `*ngIf`, `*ngFor`)
5. **Inject Function**: Use `inject()` instead of constructor injection
6. **Signal Inputs/Outputs**: Use `input()`, `output()` instead of `@Input()`, `@Output()`
7. **Computed Values**: Use `computed()` for derived state
8. **Type Safety**: No `any` types - strict TypeScript

---

## Project Structure

```
frontend/
├── src/
│   ├── app/
│   │   ├── core/                          # Singleton services, guards, interceptors
│   │   │   ├── auth/
│   │   │   │   ├── auth.service.ts
│   │   │   │   ├── auth.guard.ts
│   │   │   │   └── jwt.interceptor.ts
│   │   │   ├── models/
│   │   │   │   ├── user.model.ts
│   │   │   │   ├── customer.model.ts
│   │   │   │   ├── goal.model.ts
│   │   │   │   ├── portfolio.model.ts
│   │   │   │   ├── questionnaire.model.ts
│   │   │   │   └── api-response.model.ts
│   │   │   ├── services/
│   │   │   │   ├── api.service.ts
│   │   │   │   ├── notification.service.ts
│   │   │   │   └── storage.service.ts
│   │   │   └── guards/
│   │   │       ├── role.guard.ts
│   │   │       └── journey-stage.guard.ts
│   │   │
│   │   ├── features/                      # Lazy-loaded feature modules
│   │   │   ├── auth/
│   │   │   │   ├── login/
│   │   │   │   │   ├── login.component.ts
│   │   │   │   │   ├── login.component.html
│   │   │   │   │   └── login.component.css
│   │   │   │   └── register/
│   │   │   │
│   │   │   ├── super-admin/
│   │   │   │   ├── dashboard/
│   │   │   │   ├── questionnaire-config/
│   │   │   │   │   ├── question-list/
│   │   │   │   │   ├── question-builder/
│   │   │   │   │   └── question-preview/
│   │   │   │   ├── portfolio-config/
│   │   │   │   │   ├── portfolio-list/
│   │   │   │   │   ├── portfolio-form/
│   │   │   │   │   └── asset-allocation/
│   │   │   │   └── risk-category-config/
│   │   │   │
│   │   │   ├── rm-portal/
│   │   │   │   ├── dashboard/
│   │   │   │   │   ├── rm-dashboard.component.ts
│   │   │   │   │   ├── rm-dashboard.component.html
│   │   │   │   │   └── rm-dashboard.component.css
│   │   │   │   ├── customer-management/
│   │   │   │   │   ├── customer-list/
│   │   │   │   │   ├── customer-details/
│   │   │   │   │   └── customer-form/
│   │   │   │   ├── goal-management/
│   │   │   │   │   ├── goal-list/
│   │   │   │   │   ├── goal-form/
│   │   │   │   │   └── goal-revision/
│   │   │   │   ├── risk-assessment/
│   │   │   │   │   ├── questionnaire-container/
│   │   │   │   │   ├── assessment-result/
│   │   │   │   │   └── assessment-history/
│   │   │   │   ├── suitability-assessment/
│   │   │   │   ├── financial-calculator/
│   │   │   │   │   ├── corpus-calculator/
│   │   │   │   │   ├── return-calculator/
│   │   │   │   │   └── portfolio-matcher/
│   │   │   │   ├── portfolio-simulation/
│   │   │   │   │   ├── simulation-form/
│   │   │   │   │   ├── simulation-results/
│   │   │   │   │   └── simulation-chart/
│   │   │   │   └── order-management/
│   │   │   │       ├── order-form/
│   │   │   │       ├── order-confirmation/
│   │   │   │       └── mfa-approval/
│   │   │   │
│   │   │   └── customer-portal/           # Future Phase 2
│   │   │
│   │   ├── shared/                        # Reusable components
│   │   │   ├── components/
│   │   │   │   ├── questionnaire-renderer/
│   │   │   │   │   ├── questionnaire-renderer.component.ts
│   │   │   │   │   └── questionnaire-renderer.component.html
│   │   │   │   ├── data-table/
│   │   │   │   │   ├── data-table.component.ts
│   │   │   │   │   └── data-table.component.html
│   │   │   │   ├── charts/
│   │   │   │   │   ├── line-chart/
│   │   │   │   │   ├── bar-chart/
│   │   │   │   │   └── pie-chart/
│   │   │   │   ├── confirmation-dialog/
│   │   │   │   ├── progress-stepper/
│   │   │   │   ├── loading-spinner/
│   │   │   │   └── notification-toast/
│   │   │   ├── directives/
│   │   │   │   ├── auto-focus.directive.ts
│   │   │   │   └── permission.directive.ts
│   │   │   └── pipes/
│   │   │       ├── currency-inr.pipe.ts
│   │   │       ├── relative-time.pipe.ts
│   │   │       └── percentage.pipe.ts
│   │   │
│   │   ├── layout/                        # Layout components
│   │   │   ├── header/
│   │   │   │   ├── header.component.ts
│   │   │   │   └── header.component.html
│   │   │   ├── sidebar/
│   │   │   │   ├── sidebar.component.ts
│   │   │   │   └── sidebar.component.html
│   │   │   └── footer/
│   │   │
│   │   ├── app.component.ts               # Root component
│   │   ├── app.config.ts                  # Application configuration
│   │   └── app.routes.ts                  # Application routes
│   │
│   ├── styles/
│   │   ├── styles.css                     # Global styles (Tailwind)
│   │   └── variables.css                  # CSS variables
│   │
│   ├── assets/
│   │   ├── images/
│   │   ├── icons/
│   │   └── i18n/
│   │
│   ├── environments/
│   │   ├── environment.ts
│   │   └── environment.prod.ts
│   │
│   ├── index.html
│   └── main.ts                            # Application bootstrap
│
├── tailwind.config.js                     # Tailwind CSS v4 configuration
├── package.json
├── tsconfig.json
├── angular.json
└── CLAUDE.md                              # Angular 19 coding guide
```

---

## Modern Angular 19 Patterns

### ✅ Use Modern Syntax

```typescript
// ✅ CORRECT - Angular 19 Modern Syntax

import { Component, ChangeDetectionStrategy, signal, computed, inject } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-customer-list',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './customer-list.component.html',
  styleUrl: './customer-list.component.css',  // singular!
  changeDetection: ChangeDetectionStrategy.OnPush,  // ALWAYS
})
export class CustomerListComponent {
  // ✅ Services: Use inject() function
  private readonly customerService = inject(CustomerService);
  private readonly router = inject(Router);

  // ✅ Inputs: Use input() function
  readonly rmId = input.required<number>();
  readonly pageSize = input<number>(20);

  // ✅ Outputs: Use output() function
  readonly customerSelected = output<Customer>();

  // ✅ State: Use signals
  protected readonly customers = signal<Customer[]>([]);
  protected readonly loading = signal(false);
  protected readonly searchTerm = signal('');

  // ✅ Computed: Derive state with computed()
  protected readonly filteredCustomers = computed(() => {
    const term = this.searchTerm().toLowerCase();
    return this.customers().filter(c =>
      c.firstName.toLowerCase().includes(term) ||
      c.lastName.toLowerCase().includes(term) ||
      c.email.toLowerCase().includes(term)
    );
  });

  protected readonly totalCustomers = computed(() => this.filteredCustomers().length);

  // ✅ Lifecycle: Use ngOnInit
  async ngOnInit(): Promise<void> {
    await this.loadCustomers();
  }

  // ✅ Methods: Protected for template access
  protected async loadCustomers(): Promise<void> {
    this.loading.set(true);
    const data = await this.customerService.getCustomers(this.rmId());
    this.customers.set(data);
    this.loading.set(false);
  }

  protected selectCustomer(customer: Customer): void {
    this.customerSelected.emit(customer);
  }
}
```

```html
<!-- customer-list.component.html -->
<!-- ✅ Modern Control Flow: Use @if, @for, @switch -->

<div class="container mx-auto p-6">
  <h1 class="text-3xl font-bold mb-6">My Customers</h1>

  <!-- ✅ @if instead of *ngIf -->
  @if (loading()) {
    <app-loading-spinner />
  } @else {
    <!-- Search -->
    <input
      type="text"
      placeholder="Search customers..."
      class="w-full p-3 border rounded mb-4"
      (input)="searchTerm.set($any($event.target).value)"
    />

    <!-- Count -->
    <p class="text-gray-600 mb-4">
      Showing {{ totalCustomers() }} customer(s)
    </p>

    <!-- ✅ @for instead of *ngFor, with track -->
    @if (filteredCustomers().length > 0) {
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        @for (customer of filteredCustomers(); track customer.id) {
          <div
            class="p-4 bg-white rounded-lg shadow hover:shadow-md cursor-pointer transition"
            (click)="selectCustomer(customer)"
          >
            <h3 class="text-xl font-semibold">
              {{ customer.firstName }} {{ customer.lastName }}
            </h3>
            <p class="text-gray-600">{{ customer.email }}</p>
            <p class="text-sm text-gray-500">{{ customer.customerCode }}</p>

            <!-- ✅ @switch for status badges -->
            @switch (customer.kycStatus) {
              @case ('COMPLETED') {
                <span class="px-2 py-1 bg-green-100 text-green-800 rounded text-xs">
                  KYC Complete
                </span>
              }
              @case ('PENDING') {
                <span class="px-2 py-1 bg-yellow-100 text-yellow-800 rounded text-xs">
                  KYC Pending
                </span>
              }
              @default {
                <span class="px-2 py-1 bg-gray-100 text-gray-800 rounded text-xs">
                  KYC {{ customer.kycStatus }}
                </span>
              }
            }
          </div>
        }
      </div>
    } @else {
      <p class="text-center text-gray-500 py-8">
        No customers found matching "{{ searchTerm() }}"
      </p>
    }
  }
</div>
```

### ❌ Don't Use Old Syntax

```typescript
// ❌ WRONG - Old Angular Syntax (Don't use!)

@Component({
  // ...
})
export class OldComponent {
  // ❌ Constructor injection (old way)
  constructor(private service: MyService) {}

  // ❌ @Input() decorator (old way)
  @Input() data: any;

  // ❌ @Output() decorator (old way)
  @Output() change = new EventEmitter();

  // ❌ BehaviorSubject (old reactive state)
  private dataSubject = new BehaviorSubject<Data[]>([]);
  data$ = this.dataSubject.asObservable();

  // ❌ any type (forbidden!)
  handleData(item: any) { }
}
```

```html
<!-- ❌ WRONG - Old Template Syntax (Don't use!) -->

<!-- ❌ *ngIf (old way) -->
<div *ngIf="condition">Content</div>

<!-- ❌ *ngFor (old way) -->
<div *ngFor="let item of items">{{ item }}</div>

<!-- ❌ *ngSwitch (old way) -->
<div [ngSwitch]="value">
  <div *ngSwitchCase="'A'">A</div>
  <div *ngSwitchDefault>Default</div>
</div>
```

---

## Core Services

### 1. Authentication Service

**File:** `src/app/core/auth/auth.service.ts`

```typescript
import { Injectable, signal, computed, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { environment } from '@/environments/environment';
import { User, LoginRequest, LoginResponse, RegisterRequest } from '@/core/models/user.model';
import { StorageService } from '@/core/services/storage.service';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private readonly http = inject(HttpClient);
  private readonly router = inject(Router);
  private readonly storage = inject(StorageService);

  private readonly apiUrl = `${environment.apiUrl}/auth`;

  // State
  readonly currentUser = signal<User | null>(null);
  readonly accessToken = signal<string | null>(null);

  // Computed
  readonly isAuthenticated = computed(() => !!this.currentUser());
  readonly isAdmin = computed(() => this.currentUser()?.role === 'SUPER_ADMIN');
  readonly isRM = computed(() => this.currentUser()?.role === 'RM');
  readonly isCustomer = computed(() => this.currentUser()?.role === 'CUSTOMER');

  constructor() {
    this.initializeAuth();
  }

  private initializeAuth(): void {
    const token = this.storage.getItem('accessToken');
    const user = this.storage.getItem('user');

    if (token && user) {
      this.accessToken.set(token);
      this.currentUser.set(JSON.parse(user));
    }
  }

  async login(email: string, password: string): Promise<void> {
    const response = await this.http.post<LoginResponse>(`${this.apiUrl}/login`, {
      email,
      password
    }).toPromise();

    if (response?.success && response.data) {
      this.accessToken.set(response.data.accessToken);
      this.currentUser.set(response.data.user);

      this.storage.setItem('accessToken', response.data.accessToken);
      this.storage.setItem('refreshToken', response.data.refreshToken);
      this.storage.setItem('user', JSON.stringify(response.data.user));

      await this.router.navigate([this.getDefaultRoute()]);
    }
  }

  async register(data: RegisterRequest): Promise<void> {
    const response = await this.http.post<ApiResponse<any>>(`${this.apiUrl}/register`, data).toPromise();

    if (response?.success) {
      // Registration successful, redirect to login
      await this.router.navigate(['/auth/login']);
    }
  }

  async logout(): Promise<void> {
    try {
      await this.http.post(`${this.apiUrl}/logout`, {}).toPromise();
    } finally {
      this.clearAuth();
      await this.router.navigate(['/auth/login']);
    }
  }

  private clearAuth(): void {
    this.currentUser.set(null);
    this.accessToken.set(null);
    this.storage.removeItem('accessToken');
    this.storage.removeItem('refreshToken');
    this.storage.removeItem('user');
  }

  private getDefaultRoute(): string {
    const user = this.currentUser();
    if (!user) return '/auth/login';

    switch (user.role) {
      case 'SUPER_ADMIN':
        return '/admin/dashboard';
      case 'RM':
        return '/rm/dashboard';
      case 'CUSTOMER':
        return '/customer/dashboard';
      default:
        return '/';
    }
  }

  async refreshToken(): Promise<boolean> {
    const refreshToken = this.storage.getItem('refreshToken');
    if (!refreshToken) return false;

    try {
      const response = await this.http.post<ApiResponse<any>>(`${this.apiUrl}/refresh-token`, {
        refreshToken
      }).toPromise();

      if (response?.success && response.data) {
        this.accessToken.set(response.data.accessToken);
        this.storage.setItem('accessToken', response.data.accessToken);
        this.storage.setItem('refreshToken', response.data.refreshToken);
        return true;
      }
    } catch (error) {
      this.clearAuth();
    }

    return false;
  }
}
```

---

### 2. API Service

**File:** `src/app/core/services/api.service.ts`

```typescript
import { Injectable, inject } from '@angular/core';
import { HttpClient, HttpParams, HttpHeaders } from '@angular/common/http';
import { environment } from '@/environments/environment';
import { ApiResponse, PaginatedResponse } from '@/core/models/api-response.model';
import { lastValueFrom } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  private readonly http = inject(HttpClient);
  private readonly baseUrl = `${environment.apiUrl}/v1`;

  // GET request
  async get<T>(endpoint: string, params?: Record<string, any>): Promise<T> {
    const httpParams = this.buildParams(params);
    const response = await lastValueFrom(
      this.http.get<ApiResponse<T>>(`${this.baseUrl}${endpoint}`, { params: httpParams })
    );
    return response.data;
  }

  // POST request
  async post<T>(endpoint: string, body: any): Promise<T> {
    const response = await lastValueFrom(
      this.http.post<ApiResponse<T>>(`${this.baseUrl}${endpoint}`, body)
    );
    return response.data;
  }

  // PUT request
  async put<T>(endpoint: string, body: any): Promise<T> {
    const response = await lastValueFrom(
      this.http.put<ApiResponse<T>>(`${this.baseUrl}${endpoint}`, body)
    );
    return response.data;
  }

  // DELETE request
  async delete<T>(endpoint: string): Promise<T> {
    const response = await lastValueFrom(
      this.http.delete<ApiResponse<T>>(`${this.baseUrl}${endpoint}`)
    );
    return response.data;
  }

  // Paginated GET request
  async getPaginated<T>(
    endpoint: string,
    page: number = 0,
    size: number = 20,
    params?: Record<string, any>
  ): Promise<PaginatedResponse<T>> {
    const allParams = { ...params, page, size };
    const httpParams = this.buildParams(allParams);

    const response = await lastValueFrom(
      this.http.get<ApiResponse<PaginatedResponse<T>>>(`${this.baseUrl}${endpoint}`, { params: httpParams })
    );
    return response.data;
  }

  private buildParams(params?: Record<string, any>): HttpParams {
    let httpParams = new HttpParams();

    if (params) {
      Object.keys(params).forEach(key => {
        if (params[key] !== null && params[key] !== undefined) {
          httpParams = httpParams.set(key, params[key].toString());
        }
      });
    }

    return httpParams;
  }
}
```

---

### 3. Customer Service

**File:** `src/app/core/services/customer.service.ts`

```typescript
import { Injectable, inject, signal } from '@angular/core';
import { ApiService } from './api.service';
import { Customer, CreateCustomerRequest } from '@/core/models/customer.model';
import { PaginatedResponse } from '@/core/models/api-response.model';

@Injectable({
  providedIn: 'root'
})
export class CustomerService {
  private readonly api = inject(ApiService);

  // Cache
  readonly customers = signal<Customer[]>([]);

  async getCustomers(page: number = 0, size: number = 20, search?: string): Promise<PaginatedResponse<Customer>> {
    const params = search ? { search } : undefined;
    const response = await this.api.getPaginated<Customer>('/rm/customers', page, size, params);
    this.customers.set(response.content);
    return response;
  }

  async getCustomerById(id: number): Promise<Customer> {
    return await this.api.get<Customer>(`/rm/customers/${id}`);
  }

  async createCustomer(data: CreateCustomerRequest): Promise<Customer> {
    return await this.api.post<Customer>('/rm/customers', data);
  }

  async updateCustomer(id: number, data: Partial<Customer>): Promise<Customer> {
    return await this.api.put<Customer>(`/rm/customers/${id}`, data);
  }

  async deleteCustomer(id: number): Promise<void> {
    return await this.api.delete<void>(`/rm/customers/${id}`);
  }
}
```

---

## Component Library

### 1. Questionnaire Renderer Component

**Purpose:** Dynamically render any question type with real-time scoring

**File:** `src/app/shared/components/questionnaire-renderer/questionnaire-renderer.component.ts`

```typescript
import { Component, ChangeDetectionStrategy, signal, computed, input, output } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormControl } from '@angular/forms';
import { Question, QuestionOption, Answer } from '@/core/models/questionnaire.model';

@Component({
  selector: 'app-questionnaire-renderer',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './questionnaire-renderer.component.html',
  styleUrl: './questionnaire-renderer.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class QuestionnaireRendererComponent {
  // Inputs
  readonly question = input.required<Question>();
  readonly userRole = input<string>('RM');
  readonly showPoints = input<boolean>(false);
  readonly currentAnswer = input<Answer | undefined>();

  // Outputs
  readonly answerChange = output<Answer>();

  // State
  protected readonly selectedOptions = signal<Set<number>>(new Set());
  protected readonly textAnswer = signal<string>('');
  protected readonly numberAnswer = signal<number | null>(null);

  // Computed
  protected readonly showNotes = computed(() => {
    const q = this.question();
    return q.clientNotes || q.rmNotes;
  });

  protected readonly notes = computed(() => {
    const q = this.question();
    return this.userRole() === 'CUSTOMER' ? q.clientNotes : q.rmNotes;
  });

  protected readonly currentPoints = computed(() => {
    const selected = this.selectedOptions();
    const q = this.question();
    return Array.from(selected).reduce((sum, optionId) => {
      const option = q.options.find(o => o.id === optionId);
      return sum + (option?.points ?? 0);
    }, 0);
  });

  protected readonly isMaxCapReached = computed(() => {
    const q = this.question();
    return this.currentPoints() >= q.maxCapPoints;
  });

  protected readonly cappedPoints = computed(() => {
    const points = this.currentPoints();
    const maxCap = this.question().maxCapPoints;
    return Math.min(points, maxCap);
  });

  ngOnInit(): void {
    // Initialize from currentAnswer if provided
    const answer = this.currentAnswer();
    if (answer) {
      if (answer.selectedOptionIds) {
        this.selectedOptions.set(new Set(answer.selectedOptionIds));
      }
      if (answer.textAnswer) {
        this.textAnswer.set(answer.textAnswer);
      }
      if (answer.numberAnswer !== undefined) {
        this.numberAnswer.set(answer.numberAnswer);
      }
    }
  }

  protected isOptionSelected(optionId: number): boolean {
    return this.selectedOptions().has(optionId);
  }

  protected selectSingleOption(optionId: number): void {
    const option = this.question().options.find(o => o.id === optionId);
    this.selectedOptions.set(new Set([optionId]));

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
      points: this.cappedPoints()
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

  protected setNumberAnswer(event: Event): void {
    const value = parseFloat((event.target as HTMLInputElement).value);
    this.numberAnswer.set(value);

    this.answerChange.emit({
      questionId: this.question().id,
      numberAnswer: value,
      points: 0
    });
  }

  protected selectFromDropdown(event: Event): void {
    const optionId = parseInt((event.target as HTMLSelectElement).value);
    const option = this.question().options.find(o => o.id === optionId);

    this.answerChange.emit({
      questionId: this.question().id,
      selectedOptionIds: [optionId],
      points: option?.points ?? 0
    });
  }
}
```

**Template:** `questionnaire-renderer.component.html`

```html
<div class="question-container p-6 bg-white rounded-lg shadow-md mb-4">
  <!-- Question Header -->
  <div class="mb-4">
    <h3 class="text-xl font-semibold text-gray-800 mb-2">
      {{ question().questionText }}
      @if (question().isRequired) {
        <span class="text-red-500">*</span>
      }
    </h3>

    @if (question().description) {
      <p class="text-gray-600 text-sm mb-2">{{ question().description }}</p>
    }

    @if (showNotes()) {
      <div class="bg-blue-50 border-l-4 border-blue-500 p-3 rounded mb-3">
        <p class="text-sm text-blue-800">
          <span class="font-semibold">Note:</span> {{ notes() }}
        </p>
      </div>
    }

    @if (showPoints() && question().questionType !== 'TEXT_INPUT') {
      <div class="flex items-center gap-2 text-sm">
        <span class="text-gray-600">Current Points:</span>
        <span class="font-bold text-blue-600">{{ cappedPoints() }}</span>
        @if (question().questionType === 'MULTI_SELECT') {
          <span class="text-gray-500">/ {{ question().maxCapPoints }} max</span>
        }
      </div>
    }
  </div>

  <!-- Question Body -->
  @switch (question().questionType) {
    <!-- Single Select Radio Buttons -->
    @case ('SINGLE_SELECT') {
      <div class="space-y-2">
        @for (option of question().options; track option.id) {
          <label
            class="flex items-center p-4 border-2 rounded-lg cursor-pointer transition-all
                   hover:bg-gray-50 hover:border-blue-300
                   [&:has(input:checked)]:bg-blue-50 [&:has(input:checked)]:border-blue-500"
          >
            <input
              type="radio"
              [name]="'question-' + question().id"
              [value]="option.id"
              [checked]="isOptionSelected(option.id)"
              (change)="selectSingleOption(option.id)"
              class="mr-3 w-5 h-5 text-blue-600"
            />
            <span class="flex-1 text-gray-800">{{ option.optionText }}</span>
            @if (showPoints()) {
              <span class="ml-auto text-sm font-semibold text-blue-600">
                {{ option.points }} pts
              </span>
            }
          </label>
        }
      </div>
    }

    <!-- Multi Select Checkboxes -->
    @case ('MULTI_SELECT') {
      <div class="space-y-2">
        @for (option of question().options; track option.id) {
          <label
            class="flex items-center p-4 border-2 rounded-lg cursor-pointer transition-all
                   hover:bg-gray-50 hover:border-blue-300
                   [&:has(input:checked)]:bg-blue-50 [&:has(input:checked)]:border-blue-500
                   [&:has(input:disabled)]:opacity-50 [&:has(input:disabled)]:cursor-not-allowed"
          >
            <input
              type="checkbox"
              [value]="option.id"
              [checked]="isOptionSelected(option.id)"
              [disabled]="isMaxCapReached() && !isOptionSelected(option.id)"
              (change)="toggleMultiOption(option.id)"
              class="mr-3 w-5 h-5 text-blue-600"
            />
            <span class="flex-1 text-gray-800">{{ option.optionText }}</span>
            @if (showPoints()) {
              <span class="ml-auto text-sm font-semibold text-blue-600">
                {{ option.points }} pts
              </span>
            }
          </label>
        }

        @if (isMaxCapReached()) {
          <div class="mt-3 p-3 bg-orange-50 border border-orange-300 rounded">
            <p class="text-sm text-orange-800">
              ⚠️ Maximum {{ question().maxCapPoints }} points reached.
              Uncheck options to select different ones.
            </p>
          </div>
        }
      </div>
    }

    <!-- Text Input -->
    @case ('TEXT_INPUT') {
      <input
        type="text"
        [placeholder]="question().placeholder || 'Enter your answer'"
        [value]="textAnswer()"
        (input)="setTextAnswer($event)"
        class="w-full p-3 border-2 border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none"
      />
    }

    <!-- Number Input -->
    @case ('NUMBER_INPUT') {
      <input
        type="number"
        [placeholder]="question().placeholder || 'Enter a number'"
        [value]="numberAnswer() || ''"
        (input)="setNumberAnswer($event)"
        class="w-full p-3 border-2 border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none"
      />
    }

    <!-- Dropdown -->
    @case ('DROPDOWN') {
      <select
        (change)="selectFromDropdown($event)"
        class="w-full p-3 border-2 border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none"
      >
        <option value="">-- Select an option --</option>
        @for (option of question().options; track option.id) {
          <option [value]="option.id">
            {{ option.optionText }}
            @if (showPoints()) {
              ({{ option.points }} pts)
            }
          </option>
        }
      </select>
    }

    <!-- Date Input -->
    @case ('DATE_INPUT') {
      <input
        type="date"
        class="w-full p-3 border-2 border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none"
      />
    }
  }
</div>
```

---

### 2. Data Table Component

**Purpose:** Reusable paginated data table with sorting and filtering

**File:** `src/app/shared/components/data-table/data-table.component.ts`

```typescript
import { Component, ChangeDetectionStrategy, signal, computed, input, output } from '@angular/core';
import { CommonModule } from '@angular/common';

export interface TableColumn<T> {
  key: keyof T;
  label: string;
  sortable?: boolean;
  width?: string;
  render?: (value: any, row: T) => string;
}

export interface SortConfig {
  column: string;
  direction: 'asc' | 'desc';
}

@Component({
  selector: 'app-data-table',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './data-table.component.html',
  styleUrl: './data-table.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class DataTableComponent<T> {
  // Inputs
  readonly data = input.required<T[]>();
  readonly columns = input.required<TableColumn<T>[]>();
  readonly loading = input<boolean>(false);
  readonly emptyMessage = input<string>('No data available');

  // Outputs
  readonly rowClick = output<T>();
  readonly sortChange = output<SortConfig>();

  // State
  protected readonly sortConfig = signal<SortConfig | null>(null);

  // Computed
  protected readonly sortedData = computed(() => {
    const config = this.sortConfig();
    if (!config) return this.data();

    return [...this.data()].sort((a, b) => {
      const aValue = a[config.column as keyof T];
      const bValue = b[config.column as keyof T];

      if (aValue === bValue) return 0;

      const comparison = aValue < bValue ? -1 : 1;
      return config.direction === 'asc' ? comparison : -comparison;
    });
  });

  protected toggleSort(column: TableColumn<T>): void {
    if (!column.sortable) return;

    const currentConfig = this.sortConfig();
    const key = String(column.key);

    let newConfig: SortConfig;

    if (!currentConfig || currentConfig.column !== key) {
      newConfig = { column: key, direction: 'asc' };
    } else if (currentConfig.direction === 'asc') {
      newConfig = { column: key, direction: 'desc' };
    } else {
      newConfig = { column: key, direction: 'asc' };
    }

    this.sortConfig.set(newConfig);
    this.sortChange.emit(newConfig);
  }

  protected getCellValue(row: T, column: TableColumn<T>): string {
    const value = row[column.key];
    return column.render ? column.render(value, row) : String(value);
  }

  protected getSortIcon(column: TableColumn<T>): string {
    if (!column.sortable) return '';

    const config = this.sortConfig();
    const key = String(column.key);

    if (!config || config.column !== key) return '↕️';
    return config.direction === 'asc' ? '↑' : '↓';
  }

  protected onRowClick(row: T): void {
    this.rowClick.emit(row);
  }
}
```

**Template:** `data-table.component.html`

```html
<div class="overflow-x-auto">
  @if (loading()) {
    <div class="flex justify-center items-center p-8">
      <app-loading-spinner />
    </div>
  } @else {
    @if (data().length > 0) {
      <table class="min-w-full bg-white border border-gray-200">
        <thead class="bg-gray-100">
          <tr>
            @for (column of columns(); track column.key) {
              <th
                [style.width]="column.width"
                [class.cursor-pointer]="column.sortable"
                [class.hover:bg-gray-200]="column.sortable"
                (click)="toggleSort(column)"
                class="px-6 py-3 text-left text-xs font-medium text-gray-700 uppercase tracking-wider"
              >
                <div class="flex items-center gap-2">
                  <span>{{ column.label }}</span>
                  @if (column.sortable) {
                    <span class="text-gray-400">{{ getSortIcon(column) }}</span>
                  }
                </div>
              </th>
            }
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-200">
          @for (row of sortedData(); track row) {
            <tr
              (click)="onRowClick(row)"
              class="hover:bg-gray-50 cursor-pointer transition"
            >
              @for (column of columns(); track column.key) {
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                  {{ getCellValue(row, column) }}
                </td>
              }
            </tr>
          }
        </tbody>
      </table>
    } @else {
      <div class="text-center py-12 text-gray-500">
        <p>{{ emptyMessage() }}</p>
      </div>
    }
  }
</div>
```

---

## Feature Modules

### RM Portal - Risk Assessment

**File:** `src/app/features/rm-portal/risk-assessment/questionnaire-container/questionnaire-container.component.ts`

```typescript
import { Component, ChangeDetectionStrategy, signal, computed, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, ActivatedRoute } from '@angular/router';
import { QuestionnaireRendererComponent } from '@/shared/components/questionnaire-renderer/questionnaire-renderer.component';
import { RiskAssessmentService } from '@/core/services/risk-assessment.service';
import { JourneyTrackingService } from '@/core/services/journey-tracking.service';
import { Question, Answer } from '@/core/models/questionnaire.model';

@Component({
  selector: 'app-questionnaire-container',
  standalone: true,
  imports: [CommonModule, QuestionnaireRendererComponent],
  templateUrl: './questionnaire-container.component.html',
  styleUrl: './questionnaire-container.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class QuestionnaireContainerComponent {
  private readonly riskService = inject(RiskAssessmentService);
  private readonly journeyService = inject(JourneyTrackingService);
  private readonly router = inject(Router);
  private readonly route = inject(ActivatedRoute);

  // State
  protected readonly customerId = signal<number>(0);
  protected readonly currentQuestionIndex = signal(0);
  protected readonly answers = signal<Map<number, Answer>>(new Map());
  protected readonly loading = signal(false);

  // Computed
  protected readonly questions = computed(() => this.riskService.questions());

  protected readonly currentQuestion = computed(() => {
    const index = this.currentQuestionIndex();
    const allQuestions = this.questions();
    return allQuestions[index];
  });

  protected readonly totalQuestions = computed(() => this.questions().length);

  protected readonly currentAnswer = computed(() => {
    const question = this.currentQuestion();
    return question ? this.answers().get(question.id) : undefined;
  });

  protected readonly canProceedToPrevious = computed(() => {
    return this.currentQuestionIndex() > 0;
  });

  protected readonly canProceedToNext = computed(() => {
    const question = this.currentQuestion();
    if (!question) return false;

    if (question.isRequired) {
      return this.answers().has(question.id);
    }

    return true;
  });

  protected readonly isLastQuestion = computed(() => {
    return this.currentQuestionIndex() === this.totalQuestions() - 1;
  });

  protected readonly progress = computed(() => {
    const answered = this.answers().size;
    const total = this.totalQuestions();
    return total > 0 ? (answered / total) * 100 : 0;
  });

  protected readonly currentScore = computed(() => {
    let score = 0;
    this.answers().forEach((answer, questionId) => {
      const question = this.questions().find(q => q.id === questionId);
      if (question) {
        const weight = question.weight ?? 1.0;
        score += answer.points * weight;
      }
    });
    return Math.round(score);
  });

  async ngOnInit(): Promise<void> {
    const customerIdParam = this.route.snapshot.paramMap.get('customerId');
    if (customerIdParam) {
      this.customerId.set(parseInt(customerIdParam));
    }

    await this.loadQuestions();
  }

  protected async loadQuestions(): Promise<void> {
    this.loading.set(true);
    await this.riskService.loadQuestions();
    this.loading.set(false);
  }

  protected handleAnswerChange(answer: Answer): void {
    this.answers.update(map => {
      const newMap = new Map(map);
      newMap.set(answer.questionId, answer);
      return newMap;
    });
  }

  protected previousQuestion(): void {
    if (this.canProceedToPrevious()) {
      this.currentQuestionIndex.update(i => i - 1);
    }
  }

  protected nextQuestion(): void {
    if (this.canProceedToNext() && !this.isLastQuestion()) {
      this.currentQuestionIndex.update(i => i + 1);
    }
  }

  protected async submitAssessment(): Promise<void> {
    if (!this.canProceedToNext()) return;

    this.loading.set(true);

    try {
      const answersArray = Array.from(this.answers().values());
      const result = await this.riskService.submitAssessment(
        this.customerId(),
        answersArray
      );

      await this.journeyService.updateStage(this.customerId(), 'RISK_PROFILE');

      await this.router.navigate(['/rm/risk-assessment/result', result.riskProfileId]);
    } catch (error) {
      console.error('Failed to submit assessment:', error);
    } finally {
      this.loading.set(false);
    }
  }
}
```

**Template:** `questionnaire-container.component.html`

```html
<div class="container mx-auto p-6 max-w-4xl">
  <!-- Header -->
  <div class="mb-6">
    <h1 class="text-3xl font-bold text-gray-800 mb-2">Risk Profile Assessment</h1>
    <p class="text-gray-600">
      Answer all questions to determine your risk tolerance
    </p>
  </div>

  <!-- Progress Bar -->
  <div class="mb-6">
    <div class="flex justify-between text-sm text-gray-600 mb-2">
      <span>Question {{ currentQuestionIndex() + 1 }} of {{ totalQuestions() }}</span>
      <span>{{ progress() | number:'1.0-0' }}% Complete</span>
    </div>
    <div class="w-full bg-gray-200 rounded-full h-2.5">
      <div
        class="bg-blue-600 h-2.5 rounded-full transition-all duration-300"
        [style.width.%]="progress()"
      ></div>
    </div>
  </div>

  <!-- Current Score Preview -->
  <div class="mb-6 p-4 bg-blue-50 rounded-lg border border-blue-200">
    <div class="flex justify-between items-center">
      <div>
        <p class="text-sm text-gray-600">Current Score</p>
        <p class="text-3xl font-bold text-blue-600">{{ currentScore() }}</p>
      </div>
      <div class="text-right">
        <p class="text-sm text-gray-600">Score Range</p>
        <p class="text-lg font-semibold text-gray-700">8 - 35</p>
      </div>
    </div>
  </div>

  <!-- Question -->
  @if (loading()) {
    <div class="flex justify-center items-center py-12">
      <app-loading-spinner />
    </div>
  } @else if (currentQuestion()) {
    <app-questionnaire-renderer
      [question]="currentQuestion()"
      [userRole]="'RM'"
      [showPoints]="true"
      [currentAnswer]="currentAnswer()"
      (answerChange)="handleAnswerChange($event)"
    />

    <!-- Navigation Buttons -->
    <div class="flex justify-between mt-6">
      <button
        (click)="previousQuestion()"
        [disabled]="!canProceedToPrevious()"
        class="px-6 py-3 bg-gray-300 text-gray-700 rounded-lg font-semibold
               hover:bg-gray-400 disabled:opacity-50 disabled:cursor-not-allowed
               transition"
      >
        ← Previous
      </button>

      @if (!isLastQuestion()) {
        <button
          (click)="nextQuestion()"
          [disabled]="!canProceedToNext()"
          class="px-6 py-3 bg-blue-600 text-white rounded-lg font-semibold
                 hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed
                 transition"
        >
          Next →
        </button>
      } @else {
        <button
          (click)="submitAssessment()"
          [disabled]="!canProceedToNext() || loading()"
          class="px-6 py-3 bg-green-600 text-white rounded-lg font-semibold
                 hover:bg-green-700 disabled:opacity-50 disabled:cursor-not-allowed
                 transition flex items-center gap-2"
        >
          @if (loading()) {
            <span class="inline-block w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin"></span>
          }
          Submit Assessment
        </button>
      }
    </div>
  }
</div>
```

---

## Routing Configuration

**File:** `src/app/app.routes.ts`

```typescript
import { Routes } from '@angular/router';
import { AuthGuard } from './core/auth/auth.guard';
import { RoleGuard } from './core/guards/role.guard';

export const routes: Routes = [
  {
    path: '',
    redirectTo: '/auth/login',
    pathMatch: 'full'
  },

  // Auth Routes
  {
    path: 'auth',
    loadChildren: () => import('./features/auth/auth.routes').then(m => m.AUTH_ROUTES)
  },

  // Super Admin Routes
  {
    path: 'admin',
    canActivate: [AuthGuard, RoleGuard],
    data: { roles: ['SUPER_ADMIN'] },
    loadChildren: () => import('./features/super-admin/admin.routes').then(m => m.ADMIN_ROUTES)
  },

  // RM Portal Routes
  {
    path: 'rm',
    canActivate: [AuthGuard, RoleGuard],
    data: { roles: ['RM', 'SUPER_ADMIN'] },
    loadChildren: () => import('./features/rm-portal/rm.routes').then(m => m.RM_ROUTES)
  },

  // 404
  {
    path: '**',
    redirectTo: '/auth/login'
  }
];
```

**File:** `src/app/features/rm-portal/rm.routes.ts`

```typescript
import { Routes } from '@angular/router';

export const RM_ROUTES: Routes = [
  {
    path: 'dashboard',
    loadComponent: () => import('./dashboard/rm-dashboard.component').then(m => m.RmDashboardComponent)
  },
  {
    path: 'customers',
    loadComponent: () => import('./customer-management/customer-list/customer-list.component').then(m => m.CustomerListComponent)
  },
  {
    path: 'customers/:id',
    loadComponent: () => import('./customer-management/customer-details/customer-details.component').then(m => m.CustomerDetailsComponent)
  },
  {
    path: 'risk-assessment/:customerId',
    loadComponent: () => import('./risk-assessment/questionnaire-container/questionnaire-container.component').then(m => m.QuestionnaireContainerComponent)
  },
  {
    path: 'risk-assessment/result/:id',
    loadComponent: () => import('./risk-assessment/assessment-result/assessment-result.component').then(m => m.AssessmentResultComponent)
  }
];
```

---

## State Management

### Signals-Based State Pattern

```typescript
// Example: Goal Management State Service
import { Injectable, signal, computed } from '@angular/core';
import { Goal } from '@/core/models/goal.model';

@Injectable({
  providedIn: 'root'
})
export class GoalStateService {
  // State
  private readonly _goals = signal<Goal[]>([]);
  private readonly _selectedGoalId = signal<number | null>(null);
  private readonly _loading = signal(false);

  // Public read-only signals
  readonly goals = this._goals.asReadonly();
  readonly loading = this._loading.asReadonly();

  // Computed values
  readonly selectedGoal = computed(() => {
    const id = this._selectedGoalId();
    return this._goals().find(g => g.id === id) ?? null;
  });

  readonly activeGoals = computed(() =>
    this._goals().filter(g => g.status === 'IN_PROGRESS')
  );

  readonly totalGoalAmount = computed(() =>
    this._goals().reduce((sum, g) => sum + g.targetAmount, 0)
  );

  // Actions
  setGoals(goals: Goal[]): void {
    this._goals.set(goals);
  }

  addGoal(goal: Goal): void {
    this._goals.update(goals => [...goals, goal]);
  }

  updateGoal(id: number, updates: Partial<Goal>): void {
    this._goals.update(goals =>
      goals.map(g => g.id === id ? { ...g, ...updates } : g)
    );
  }

  removeGoal(id: number): void {
    this._goals.update(goals => goals.filter(g => g.id !== id));
  }

  selectGoal(id: number): void {
    this._selectedGoalId.set(id);
  }

  setLoading(loading: boolean): void {
    this._loading.set(loading);
  }
}
```

---

## Forms & Validation

### Reactive Forms with Signal Integration

```typescript
import { Component, ChangeDetectionStrategy, signal, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { GoalService } from '@/core/services/goal.service';

@Component({
  selector: 'app-goal-form',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './goal-form.component.html',
  styleUrl: './goal-form.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class GoalFormComponent {
  private readonly fb = inject(FormBuilder);
  private readonly goalService = inject(GoalService);
  private readonly router = inject(Router);

  // State
  protected readonly loading = signal(false);
  protected readonly errorMessage = signal<string | null>(null);

  // Form
  protected readonly goalForm: FormGroup = this.fb.group({
    goalName: ['', [Validators.required, Validators.minLength(3), Validators.maxLength(100)]],
    goalTypeId: ['', Validators.required],
    targetAmount: ['', [Validators.required, Validators.min(10000)]],
    targetDate: ['', Validators.required],
    initialInvestment: [0, [Validators.required, Validators.min(0)]],
    monthlySip: [0, [Validators.required, Validators.min(0)]],
    priority: ['MEDIUM'],
    description: ['']
  }, { validators: this.atLeastOneInvestmentValidator });

  // Custom Validator
  private atLeastOneInvestmentValidator(form: FormGroup) {
    const initial = form.get('initialInvestment')?.value || 0;
    const sip = form.get('monthlySip')?.value || 0;

    return (initial > 0 || sip > 0) ? null : { atLeastOneInvestment: true };
  }

  protected async onSubmit(): Promise<void> {
    if (this.goalForm.invalid) {
      this.goalForm.markAllAsTouched();
      return;
    }

    this.loading.set(true);
    this.errorMessage.set(null);

    try {
      await this.goalService.createGoal(this.goalForm.value);
      await this.router.navigate(['/rm/goals']);
    } catch (error: any) {
      this.errorMessage.set(error.message || 'Failed to create goal');
    } finally {
      this.loading.set(false);
    }
  }

  protected getFieldError(fieldName: string): string | null {
    const field = this.goalForm.get(fieldName);
    if (!field || !field.touched || !field.errors) return null;

    const errors = field.errors;

    if (errors['required']) return `${fieldName} is required`;
    if (errors['minlength']) return `Minimum length is ${errors['minlength'].requiredLength}`;
    if (errors['min']) return `Minimum value is ${errors['min'].min}`;

    return 'Invalid value';
  }

  protected hasError(fieldName: string): boolean {
    const field = this.goalForm.get(fieldName);
    return !!(field && field.invalid && field.touched);
  }
}
```

---

## Styling Guide

### Tailwind CSS v4 Usage

```css
/* styles.css - Global Styles */

@import 'tailwindcss/base';
@import 'tailwindcss/components';
@import 'tailwindcss/utilities';

/* Custom CSS Variables */
:root {
  --primary: #2563eb;
  --primary-dark: #1e40af;
  --secondary: #64748b;
  --success: #22c55e;
  --warning: #f59e0b;
  --danger: #ef4444;
  --background: #f8fafc;
  --surface: #ffffff;
  --text-primary: #1e293b;
  --text-secondary: #64748b;
}

/* Custom Utility Classes */
@layer utilities {
  .scrollbar-hide {
    -ms-overflow-style: none;
    scrollbar-width: none;
  }

  .scrollbar-hide::-webkit-scrollbar {
    display: none;
  }
}
```

### Component Styling Example

```html
<!-- Using Tailwind classes -->
<div class="container mx-auto p-6">
  <!-- Card -->
  <div class="bg-white rounded-lg shadow-md p-6 mb-4">
    <!-- Title -->
    <h2 class="text-2xl font-bold text-gray-800 mb-4">Card Title</h2>

    <!-- Content -->
    <p class="text-gray-600 mb-4">Card content goes here</p>

    <!-- Buttons -->
    <div class="flex gap-3">
      <button class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 transition">
        Primary
      </button>
      <button class="px-4 py-2 bg-gray-300 text-gray-700 rounded hover:bg-gray-400 transition">
        Secondary
      </button>
    </div>
  </div>

  <!-- Responsive Grid -->
  <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
    <div class="p-4 bg-white rounded shadow">Item 1</div>
    <div class="p-4 bg-white rounded shadow">Item 2</div>
    <div class="p-4 bg-white rounded shadow">Item 3</div>
  </div>
</div>
```

---

**Document Status:** ✅ **COMPLETE**
**Last Updated:** December 24, 2025
**Version:** 1.0 Final
**Framework:** Angular 19
