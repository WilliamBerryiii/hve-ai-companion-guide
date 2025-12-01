---
title: Advanced Agent Patterns
description: Master multi-phase agents, workflow chaining, and hybrid Agent+Edit approaches for complex implementation scenarios
author: HVE Core Team
ms.date: 2025-11-19
ms.topic: concept
keywords:
  - multi-phase agents
  - workflow chaining
  - hybrid workflows
  - agent coordination
  - complex implementations
chapter: 9
part: 2
section: 6
type: chapter-content
parent: chapter9-agent-mode
estimated_reading_time: 13
---

You've mastered single-phase Agent Mode execution with supervision. Now scale to complex scenarios requiring multiple autonomous runs, sequential coordination, and strategic mode switching.

## Multi-Phase Agent Execution

Break large implementations into sequential Agent Mode runs, each with focused scope and clear verification.

### Why Multi-Phase Over Single Long Run

#### Single 90-minute Agent run problems

* Context drift as implementation progresses
* Harder to pinpoint when deviation occurred
* Difficult to recover from mid-execution failures
* Risk accumulates without verification checkpoints

#### Three 30-minute phases advantages

* Verify correctness after each phase before continuing
* Clear recovery points if issues arise
* Focused working set per phase
* Reduced cognitive load for supervision

### Phase Boundary Selection

Choose phase boundaries at natural verification points where you can confidently assess quality before proceeding.

#### Good phase boundaries

* After completing database layer (models, migrations)
* After service layer with comprehensive tests
* After API endpoints before integration tests
* After core functionality before optimization

#### Poor phase boundaries

* Mid-service implementation (split across phases)
* Before critical tests exist
* During refactoring when code is unstable
* Arbitrary time limits (stop at 20 minutes regardless of progress)

### Multi-Phase Example: E-Commerce Cart System

#### Phase 1: Data Layer

* Cart, CartItem, Product models
* Database migrations
* Model method tests (15 tests)
* **Verification checkpoint:** All model tests pass, schema valid

#### Agent prompt for Phase 1

```text
Implement Phase 1 of cart system: Data Layer

Steps:
1. Create Cart model (userId, createdAt, updatedAt)
2. Create CartItem model (cartId, productId, quantity, price)
3. Add cart relationship methods to User model
4. Create migrations for cart tables
5. Test all models and relationships (15 tests target)

Working set:
- src/models/User.ts (modify)
- src/models/BaseModel.ts (pattern)
- migrations/20241115_create_orders.ts (migration pattern)
- src/models/__tests__/Order.test.ts (test pattern)

Stop conditions:
- All 15 model tests passing
- TypeScript compiles with no errors
- STOP after Step 5 completion

Success: Cart and CartItem models complete with passing tests
```

**[Execute Phase 1... 18 minutes... All tests pass ✓]**

#### Review Phase 1 outputs

* Cart model structure matches requirements ✓
* CartItem includes price snapshot (important for historical accuracy) ✓
* Relationships bidirectional (Cart ↔ CartItem) ✓
* Migrations include indexes for foreign keys ✓
* Test coverage comprehensive ✓

#### Decision: Proceed to Phase 2

---

#### Phase 2: Business Logic

* CartService with add/remove/update operations
* Price calculation logic
* Inventory validation
* Service tests (20 tests)
* **Verification checkpoint:** All service tests pass, business rules enforced

#### Agent prompt for Phase 2

```text
Implement Phase 2 of cart system: Business Logic

Steps:
1. Create CartService with CRUD operations
2. Implement addItem (with inventory check)
3. Implement removeItem
4. Implement updateQuantity (validate against inventory)
5. Implement calculateTotal (with tax calculation)
6. Test all service methods (20 tests target)

Working set:
- src/services/orderService.ts (service pattern)
- src/models/Cart.ts (from Phase 1)
- src/models/CartItem.ts (from Phase 1)
- src/models/Product.ts (for inventory)
- src/services/__tests__/orderService.test.ts (test pattern)

Stop conditions:
- All 20 service tests passing
- Business rules validated (inventory, pricing)
- STOP after Step 6 completion

Success: CartService complete with comprehensive business logic
```

**[Execute Phase 2... 23 minutes... All tests pass ✓]**

#### Review Phase 2 outputs

* Inventory checks prevent overselling ✓
* Price snapshots captured when adding items ✓
* Total calculation includes tax correctly ✓
* Edge cases handled (removing non-existent items) ✓
* Service tests comprehensive ✓

#### Decision: Proceed to Phase 3

---

#### Phase 3: API Layer

* Cart endpoints (GET, POST, PATCH, DELETE)
* Request validation
* Authentication middleware
* API tests (18 tests)
* **Verification checkpoint:** All API tests pass, endpoints secured

#### Agent prompt for Phase 3

```text
Implement Phase 3 of cart system: API Layer

Steps:
1. Add cart endpoints to routes/cartRoutes.ts
2. GET /cart/me - Get user's cart
3. POST /cart/items - Add item to cart
4. PATCH /cart/items/:id - Update item quantity
5. DELETE /cart/items/:id - Remove item
6. Add authentication middleware to all routes
7. Test all endpoints (18 tests target)

Working set:
- src/routes/orderRoutes.ts (route pattern)
- src/services/CartService.ts (from Phase 2)
- src/middleware/authMiddleware.ts (auth pattern)
- src/routes/__tests__/orderRoutes.test.ts (test pattern)

Stop conditions:
- All 18 API tests passing
- Authentication enforced on all routes
- STOP after Step 7 completion

Success: Cart API complete with authentication and validation
```

**[Execute Phase 3... 20 minutes... All tests pass ✓]**

#### Final verification across all phases

* Total: 53 tests passing (15 + 20 + 18)
* Manual test: Add item → update quantity → remove item → works end-to-end ✓
* Security: Unauthenticated requests rejected ✓
* Performance: Cart operations < 100ms ✓

### Multi-Phase Coordination Strategies

#### Sequential phases with verification

```text
Phase 1 → [Verify] → Phase 2 → [Verify] → Phase 3 → [Verify] → Done
```

Use when: Each phase depends on previous phase outputs

#### Parallel phases with integration

```text
Phase 1a (Database) ─┐
Phase 1b (Services)  ├→ [Integrate] → Phase 2 (API)
Phase 1c (Utilities) ─┘
```

Use when: Phases have minimal dependencies, can develop independently

#### Iterative phases with refinement

```text
Phase 1 (MVP) → [Deploy] → Phase 2 (Enhanced) → [Deploy] → Phase 3 (Advanced)
```

Use when: Feature rolls out incrementally, each phase adds capability

## Chaining Agent Workflows

Connect multiple Agent Mode executions where one Agent's output becomes the next Agent's input.

### Research → Plan → Implement Chain

#### Agent 1: Research (Chapter 5 - Research Mode)

* Input: Feature request ("Add OAuth authentication")
* Output: Research document with implementation approaches, library comparisons, security considerations

#### Agent 2: Plan (Chapter 7 - Task Planner)

* Input: Research document from Agent 1
* Output: Detailed implementation plan with steps, dependencies, verification criteria

#### Agent 3: Implement (Chapter 9 - Agent Mode)

* Input: Implementation plan from Agent 2
* Output: Working OAuth implementation with tests

### Chain Example: Payment Gateway Integration

#### Agent 1 Prompt (Research)

```text
Research payment gateway options for e-commerce platform.

Requirements:
- Support credit cards and ACH
- PCI compliance built-in
- < $0.30 per transaction
- Good TypeScript SDK

Deliverable: Comparison table with recommendation
```

#### Agent 1 Output

```markdown
## Payment Gateway Research

### Options Evaluated
| Gateway   | CC+ACH | PCI | Fee        | TypeScript | Score |
|-----------|--------|-----|------------|------------|-------|
| Stripe    | ✓      | ✓   | 2.9%+$0.30 | Excellent  | 95    |
| Square    | ✓      | ✓   | 2.9%+$0.30 | Good       | 85    |
| Braintree | ✓      | ✓   | 2.9%+$0.30 | Fair       | 75    |

### Recommendation: Stripe
- Best TypeScript support (official SDK)
- Comprehensive documentation
- Handles PCI compliance
- Webhook support for async events
- Market leader with proven reliability

### Implementation Considerations
- Webhook signature verification critical
- Idempotency keys for retry safety
- Test mode for development
- Customer object for repeat purchases
```

#### Agent 2 Prompt (Planning)

```text
Create implementation plan for Stripe payment integration.

Context: [Attach Agent 1 research output]

Requirements:
- Payment processing for orders
- Customer storage for repeat purchases
- Webhook handling for async events
- Test coverage

Deliverable: Step-by-step plan with test-first workflow
```

#### Agent 2 Output

```markdown
## Stripe Integration Implementation Plan

### Phase 1: Core Payment Processing
**Step 1.1**: Add Stripe dependency and configuration
**Step 1.2**: Create PaymentService with charge method
**Step 1.3**: Test payment success, failure, network error (8 tests)

### Phase 2: Customer Management
**Step 2.1**: Create CustomerService for Stripe customer CRUD
**Step 2.2**: Link User model to Stripe customer ID
**Step 2.3**: Test customer creation, retrieval, card storage (6 tests)

### Phase 3: Webhook Handling
**Step 3.1**: Create webhook endpoint with signature verification
**Step 3.2**: Handle payment_intent.succeeded event
**Step 3.3**: Handle payment_intent.payment_failed event
**Step 3.4**: Test webhook signature validation, event handling (10 tests)

### Phase 4: Order Integration
**Step 4.1**: Integrate PaymentService with OrderService
**Step 4.2**: Add payment flow to checkout endpoint
**Step 4.3**: End-to-end test: create order → process payment → webhook → order confirmed (5 tests)

Total: 4 phases, 11 steps, 29 tests
```

#### Agent 3 Prompt (Implementation)

```text
Implement Stripe payment integration following the plan.

Plan: [Attach Agent 2 plan output]

Working set:
- src/services/orderService.ts (pattern)
- src/routes/orderRoutes.ts (integrate here)
- package.json (add stripe dependency)

Stop conditions:
- All 29 tests passing
- Webhook signature verification working
- STOP after Phase 4 completion

Proceed with test-first implementation.
```

#### Agent 3 Execution

* [Autonomous implementation following plan...]
* All 29 tests passing ✓
* Stripe integration complete ✓

#### Chain result: Research → Plan → Working implementation

### Chain Debugging: When Middle Agent Fails

**Scenario:** Agent 2 (Planner) produces incomplete plan

#### Agent 3 encounters issue

```text
Agent 3: Step 3.2 implementation blocked
Issue: Plan doesn't specify which webhook events to handle
```

#### Recovery approach

##### Option 1: Fix plan, restart Agent 3

```text
1. Stop Agent 3
2. Update Agent 2 plan with missing event details
3. Restart Agent 3 from beginning with updated plan
```

##### Option 2: Intervene and continue

```text
You: For Step 3.2, handle these webhook events:
     - payment_intent.succeeded
     - payment_intent.payment_failed
     - charge.refunded
     
     Continue implementation with these events.
```

##### Option 3: Re-run Agent 2 with clarification

```text
Restart Agent 2 with: "Specify which Stripe webhook events
to handle and what actions to take for each event."

Then restart Agent 3 with improved plan.
```

> [!TIP]
> When chaining fails, evaluate whether to fix the current chain or restart earlier agents with better inputs. Restarting earlier agents often produces better long-term results.

## Hybrid Agent+Edit Workflows

Strategically combine Agent Mode (autonomous multi-step) with Edit Mode (precise single changes) for optimal efficiency and control.

### When to Switch Modes Mid-Feature

#### Start with Agent Mode when

* You have a detailed plan with 5+ steps
* Steps follow clear patterns
* Test coverage exists or will be created
* Risk level is low-to-medium

#### Switch to Edit Mode when

* Agent produces unexpected output
* Implementation hits edge case not in plan
* Security-sensitive code needs manual review
* Single-file refinement needed

#### Return to Agent Mode when

* Edge case resolved, clear path forward
* Pattern established by manual edit
* Remaining steps follow known structure

### Hybrid Example: API Rate Limiting

**Feature:** Add rate limiting to API endpoints with Redis backing

#### Phase 1: Agent Mode - Core rate limiter

Autonomous implementation of:

* RateLimiterService with Redis client
* Check and increment logic
* Service tests (12 tests)

**[Agent completes Phase 1 successfully]**

---

#### Phase 2: Edit Mode - Middleware integration

##### Why switch to Edit Mode

* Middleware injection requires precise placement in existing route file
* Must not break existing authentication middleware order
* High-risk change (affects all endpoints)

##### Manual edits

1. Open `src/routes/api.ts`
2. Add rate limiter middleware import
3. Carefully insert middleware before route handlers, after auth
4. Verify middleware chain order correct

##### Edit Mode dialogue

```text
You: Add rate limiter middleware to api.ts routes

[Copilot suggests middleware insertion]

You: Move rateLimiter after authMiddleware (auth must happen first)

[Copilot adjusts order]

You: Accept - correct order now
```

**Result:** Precise middleware integration without risk of Agent Mode making wrong assumptions about order

---

#### Phase 3: Agent Mode - Endpoint-specific limits

##### Why return to Agent Mode

* Pattern established by manual middleware edit
* Remaining work follows structure: add `@rateLimit()` decorator to endpoints
* 15 endpoints to update (tedious manually)

Autonomous implementation of:

* Rate limit decorators on endpoints
* Different limits per endpoint type (strict for write, loose for read)
* Tests for rate-limited endpoints (10 tests)

**[Agent completes Phase 3 successfully]**

---

#### Final hybrid result

* Phase 1 (Agent): Foundation automated ✓
* Phase 2 (Edit): Critical integration manual ✓
* Phase 3 (Agent): Repetitive application automated ✓

### Hybrid Decision Framework

| Characteristic  | Agent Mode                   | Edit Mode               |
|-----------------|------------------------------|-------------------------|
| **Steps**       | 5+ sequential steps          | 1-2 targeted changes    |
| **Pattern**     | Repetitive structure         | Unique/custom logic     |
| **Risk**        | Low-to-medium                | High or unknown         |
| **Context**     | Multi-file changes           | Single file precision   |
| **Tests**       | Test-first workflow          | Existing tests validate |
| **Duration**    | 15-45 minutes                | 2-10 minutes            |
| **Supervision** | Monitor, intervene if needed | Review every suggestion |

### Hybrid Workflow Patterns

#### Pattern 1: Agent Foundation, Edit Refinement

```text
Agent Mode: Implement 80% of feature (core logic, tests)
Edit Mode: Refine 20% (edge cases, performance, polish)
```

Use when: Feature structure is clear, but details need precision

#### Pattern 2: Edit Prototype, Agent Scale

```text
Edit Mode: Create first instance (example route handler)
Agent Mode: Apply pattern to remaining instances (15 similar routes)
```

Use when: Pattern is custom, but repetition is extensive

#### Pattern 3: Agent Phases, Edit Transitions

```text
Agent Phase 1: Database layer
Edit Mode: Review, adjust indexes, constraints
Agent Phase 2: Service layer
Edit Mode: Review, optimize critical methods
Agent Phase 3: API layer
```

Use when: Each phase needs careful review before continuing

#### Pattern 4: Edit Critical, Agent Supportive

```text
Edit Mode: Authentication logic (high security)
Agent Mode: Logging, monitoring, documentation around auth
Edit Mode: Payment processing (high security)
Agent Mode: Receipt generation, email notifications
```

Use when: Core logic requires manual precision, supporting code can be automated

## Hands-On Exercise: Multi-Phase Agent Workflow

Practice coordinating multiple Agent Mode runs with verification checkpoints.

### Scenario

Implement a notification system with multiple delivery methods (email, SMS, push).

### Phase 1: Data and Service Layer

**Your task:**

1. Create Agent Mode prompt for Phase 1 covering:
   * Notification model (userId, type, message, deliveryMethod, status)
   * NotificationService with send() method
   * Tests for service (15 tests)
2. Execute Phase 1 with Agent Mode
3. Verify outputs before proceeding

**Success criteria:**

* All model and service tests pass
* Notification service handles multiple delivery methods
* No hardcoded delivery logic (prepared for Phase 2 plugins)

### Phase 2: Delivery Method Plugins

**Your task:**

1. Manually review Phase 1 service structure
2. Decide: Should Phase 2 be Agent Mode or Edit Mode? Why?
3. If Agent: Create prompt for email, SMS, push notification delivery implementations
4. If Edit: Manually implement one delivery method as pattern, then use Agent for remaining
5. Execute your chosen approach

**Success criteria:**

* All three delivery methods working (email, SMS, push)
* Each method has tests (12 tests total)
* Delivery method selection logic correct

### Phase 3: API and Integration

**Your task:**

1. Create Agent Mode prompt for Phase 3 covering:
   * POST /notifications/send endpoint
   * GET /notifications/me endpoint
   * Integration tests (8 tests)
2. Execute Phase 3 with Agent Mode
3. Run full test suite across all phases

**Success criteria:**

* All 35 tests passing (15 + 12 + 8)
* End-to-end notification flow works
* All three delivery methods reachable via API

### Reflection Questions

1. How did you decide when to verify outputs between phases?
2. Did you use Agent Mode for all phases, or switch to Edit Mode? Why?
3. How many interventions did you make across all three phases?
4. Would you structure the phases differently next time?

<details>
<summary>Guidance for phase decisions</summary>

**Phase 1 (Data and Service Layer):** Agent Mode is appropriate—clear structure, testable outputs, low risk.

**Phase 2 (Delivery Method Plugins):** Consider hybrid approach:

* If delivery methods follow identical patterns → Agent Mode for all three
* If each method has unique integration requirements → Edit Mode for first method to establish pattern, then Agent Mode for remaining two

**Phase 3 (API and Integration):** Agent Mode with Ask checkpoint for authentication middleware placement.

**Common intervention points:**

* Phase 1: Rarely needed if model structure is clear
* Phase 2: Often needed for third-party SDK integration details
* Phase 3: Sometimes needed for error response format decisions

</details>

> [!TIP]
> The hybrid decision in Phase 2 is the key learning moment. There's no single correct answer—your choice depends on how uniform the delivery method implementations are in your codebase.

---

**Previous:** [Troubleshooting Agent Mode](./05-troubleshooting-agent-mode.md) | **Next:** [Summary and Next Steps](./07-summary-next-steps.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
