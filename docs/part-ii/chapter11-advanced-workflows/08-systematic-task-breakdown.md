---
title: Systematic Task Breakdown with Beads
description: Learn to break complex features into manageable beads with clear dependencies, priorities, and acceptance criteria
author: HVE Core Team
ms.date: 2025-11-24
ms.topic: how-to
keywords:
  - task breakdown
  - beads workflow
  - feature decomposition
  - dependency management
  - acceptance criteria
  - systematic planning
estimated_reading_time: 12
---

Breaking complex features into manageable beads is a learnable skill. This section provides a systematic methodology for decomposition—from analyzing requirements to creating validated bead structures with clear dependencies and acceptance criteria.

Effective breakdown enables parallel work, reduces implementation risk, and creates natural checkpoints for progress validation. Poor breakdown leads to circular dependencies, blocked work, and ambiguous completion criteria.

This section teaches Part II fundamentals of task breakdown. Part III, Chapter 14 covers advanced orchestration patterns including parallel agent execution, complex dependency graphs, and production workflow integration with custom agents.

## Why Systematic Breakdown Matters

**Without structured breakdown:**

* Implementation starts without clear scope boundaries
* Dependencies emerge mid-work causing blocking issues
* Acceptance criteria remain ambiguous until review time
* Progress tracking becomes subjective and imprecise
* Context loss occurs during interruptions or handoffs

**With structured breakdown:**

* Each bead has complete implementation context
* Dependencies are explicit before work begins
* Acceptance criteria define "done" objectively
* Progress is measurable by bead completion status
* Context preservation enables seamless resumption

Real-world impact: A 2-week feature broken into 8 well-defined beads enables incremental delivery, parallel work opportunities, and clear progress visibility. The same feature implemented as a single large chunk risks scope creep and lacks natural validation checkpoints.

## Task Breakdown Methodology

This five-step process transforms feature requirements into validated bead structures:

### Step 1: Feature Analysis

**Purpose:** Understand the complete scope before decomposition.

**Questions to answer:**

* What user-facing behavior changes?
* What system components are affected?
* What existing code patterns apply?
* What quality requirements exist (performance, security, scalability)?
* What integration points need coordination?

#### Example - Feature: API Rate Limiting

```markdown
## Feature Analysis: API Rate Limiting

**User-Facing Behavior:**
* API returns 429 Too Many Requests when limits exceeded
* Response includes Retry-After header
* Different endpoints have different limits

**Affected Components:**
* Express middleware layer (new rate limiter)
* Redis connection (request tracking)
* API route registration (middleware ordering)
* Error handling (429 responses)

**Existing Patterns:**
* Middleware pattern in src/middleware/logging.ts
* Redis utilities in src/utils/redis-client.ts
* Error handling in src/middleware/error-handler.ts

**Quality Requirements:**
* Response time: <10ms overhead per request
* Availability: Degrade gracefully if Redis unavailable
* Security: Prevent rate limit bypass attempts

**Integration Points:**
* Redis cluster for distributed tracking
* Monitoring system for rate limit metrics
* Documentation for API consumers
```

This analysis reveals six distinct implementation areas requiring different expertise and having different dependencies.

### Step 2: Dependency Identification

**Purpose:** Determine what must exist before each component can be built.

**Dependency types:**

* **Hard dependencies:** Component B cannot start until Component A completes
* **Soft dependencies:** Component B benefits from Component A but can proceed independently
* **Integration dependencies:** Component C requires Components A and B for testing

**Identification technique:** Work backward from the final outcome:

1. What needs to exist for users to see the feature?
   * → Rate limiter active on all routes
2. What enables that?
   * → Middleware registered in app.ts
   * → Rate limiter implementation complete
3. What enables rate limiter implementation?
   * → Redis client available
   * → Rate limit configuration defined
   * → Middleware pattern understood

This reveals the dependency chain: Configuration → Redis client → Rate limiter → Registration → Testing

**Example dependency graph:**

```markdown
## Dependency Analysis: API Rate Limiting

**Foundation Layer (no dependencies):**
* Config: Define rate limit rules (requests/window, per endpoint)
* Redis: Establish connection and utility methods

**Implementation Layer (depends on foundation):**
* Middleware: Create rate limiter using Redis utilities (depends on Redis)
* Testing: Unit tests for rate limiter logic (depends on Middleware)

**Integration Layer (depends on implementation):**
* Registration: Add middleware to Express app (depends on Middleware)
* Integration tests: Validate end-to-end behavior (depends on Registration)

**Documentation Layer (depends on integration):**
* API docs: Document rate limits and 429 responses (depends on Integration tests for validation)
```

This structure enables parallel work: Config and Redis beads can execute simultaneously, then Middleware can begin once Redis completes.

### Step 3: Bead Creation

**Purpose:** Define discrete implementation units with complete context.

**Bead design principles:**

* **Single responsibility:** Each bead addresses one concern
* **Testable boundary:** Clear inputs, outputs, and verification criteria
* **Complete context:** No external clarifications needed during implementation
* **Appropriate size:** 30-90 minutes implementation time
* **Explicit dependencies:** All prerequisites documented

**Example bead structure:**

```markdown
## Bead: B001 - Define rate limit configuration

**Status:** Ready
**Priority:** High
**Dependencies:** None
**Estimated Time:** 30 minutes

**Acceptance Criteria:**
- [ ] Configuration file defines default rate limit (100 requests per 15 minutes)
- [ ] Per-endpoint overrides supported via configuration object
- [ ] Window types support: sliding window, fixed window
- [ ] Configuration validates on application startup
- [ ] TypeScript types define configuration schema

**Context:**
Feature requires flexible rate limiting supporting different limits per endpoint.
Default limits must be conservative (100/15min) with ability to tighten or relax per route.
Sliding window approach preferred for accurate rate measurement.

**Files to Modify:**
* src/config/rate-limit.config.ts - Create configuration schema (NEW FILE)
* src/config/index.ts - Export rate limit configuration
* src/types/rate-limit.types.ts - Define TypeScript types (NEW FILE)

**Implementation Guidance:**
* Use existing config pattern from src/config/database.config.ts as template
* Consider environment variable overrides for production flexibility
* Validation should fail fast at startup, not per-request

**Research References:**
* Config pattern: src/config/database.config.ts (lines 12-45)
* Type definitions: src/types/database.types.ts (lines 8-23)

**Verification Approach:**
* Unit test: Invalid configuration throws error at startup
* Unit test: Per-endpoint overrides merge correctly with defaults
* Manual test: Configuration loads successfully in development mode
```

This bead provides everything needed for autonomous implementation without clarifying questions.

### Step 4: Priority Assignment

**Purpose:** Determine implementation order optimizing for risk reduction and parallel work.

**Prioritization factors:**

1. **Critical path items:** Beads blocking multiple downstream beads
2. **Risk mitigation:** Uncertain or complex beads investigated early
3. **Value delivery:** User-facing functionality prioritized
4. **Dependency satisfaction:** Prerequisites completed before dependents
5. **Parallel opportunities:** Independent beads executed simultaneously

**Priority levels:**

* **High:** Critical path or risk mitigation
* **Medium:** Important but not blocking
* **Low:** Nice-to-have or polish work

**Example prioritization:**

```markdown
## Bead Priorities: API Rate Limiting

**High Priority (Critical Path):**
* B001: Define configuration (blocks B003)
* B002: Create Redis utilities (blocks B003)
* B003: Implement rate limiter middleware (blocks B004, B005, B006)

**Medium Priority (Value Delivery):**
* B004: Register middleware in app.ts (depends on B003)
* B005: Add integration tests (depends on B004)

**Low Priority (Polish):**
* B006: Add rate limit metrics to monitoring (depends on B003)
* B007: Update API documentation (depends on B005 for validation)

**Parallel Work Opportunities:**
* B001 and B002 can execute simultaneously (no dependencies)
* B006 and B007 can execute in parallel after B003 completes
```

This structure enables two parallel work streams initially (B001 + B002), then sequential execution through the critical path (B003 → B004 → B005), with polish work (B006, B007) parallelizable at the end.

### Step 5: Acceptance Criteria Definition

**Purpose:** Define objective "done" criteria preventing ambiguity.

**Effective criteria characteristics:**

* **Testable:** Can be verified programmatically or manually
* **Specific:** No interpretation required
* **Complete:** All quality requirements covered
* **Measurable:** Success is boolean (pass/fail)

**Poor vs good acceptance criteria:**

| Poor (Vague)                 | Good (Specific)                                                                     |
|------------------------------|-------------------------------------------------------------------------------------|
| ❌ Middleware works correctly | ✅ Middleware returns 429 when limit exceeded in 5 consecutive requests              |
| ❌ Performance is acceptable  | ✅ Middleware adds <10ms latency measured via k6 load test                           |
| ❌ Error handling implemented | ✅ Redis connection failure logs warning and allows requests through (degraded mode) |
| ❌ Tests are comprehensive    | ✅ Test suite achieves 95%+ branch coverage measured by Jest coverage report         |

**Example comprehensive acceptance criteria:**

```markdown
## Bead: B003 - Implement rate limiter middleware

**Acceptance Criteria:**

**Functional Requirements:**
- [ ] Middleware tracks requests per user ID via Redis
- [ ] Returns 429 status with Retry-After header when limit exceeded
- [ ] Sliding window algorithm (not fixed buckets)
- [ ] Configurable limits via rate-limit.config.ts
- [ ] Different limits per endpoint supported

**Quality Requirements:**
- [ ] Response time <10ms measured via performance test
- [ ] Degrades gracefully if Redis unavailable (logs warning, allows requests)
- [ ] Thread-safe for concurrent requests
- [ ] Memory usage <5MB per 10K tracked users

**Testing Requirements:**
- [ ] Unit tests: 95%+ branch coverage (Jest coverage report)
- [ ] Unit test: Correctly tracks requests in sliding window
- [ ] Unit test: Returns 429 after exceeding configured limit
- [ ] Unit test: Retry-After header calculated correctly
- [ ] Unit test: Allows requests when Redis unavailable (degraded mode)
- [ ] Performance test: <10ms latency under 1000 req/sec load (k6 test)

**Documentation Requirements:**
- [ ] JSDoc comments explain sliding window algorithm
- [ ] README section documents configuration options
- [ ] Inline comments explain Redis key structure
```

These criteria eliminate implementation ambiguity and enable objective verification before marking the bead complete.

## Breakdown Patterns by Feature Type

Different feature types benefit from different breakdown approaches:

### Pattern 1: New Feature Development

**Characteristics:** Greenfield implementation, no existing code to modify, architectural decisions needed.

**Breakdown approach:**

1. Architecture/design bead (data models, API contracts, component boundaries)
2. Foundation beads (utilities, configuration, database schema)
3. Core implementation beads (business logic, per component)
4. Integration beads (connecting components)
5. Testing beads (unit, integration, end-to-end)
6. Documentation beads (API docs, user guides)

#### Example: User Authentication System

```markdown
## Beads: User Authentication System (New Feature)

**Phase 1: Architecture (1 bead)**
* B001: Design authentication flow, token structure, storage schema

**Phase 2: Foundation (3 beads, parallel)**
* B002: Create user database schema and migrations
* B003: Set up JWT configuration and utilities
* B004: Create password hashing utilities (bcrypt)

**Phase 3: Core Implementation (4 beads, sequential)**
* B005: Implement user registration endpoint (depends on B002, B004)
* B006: Implement login endpoint (depends on B002, B003, B004)
* B007: Implement token refresh endpoint (depends on B003, B006)
* B008: Create authentication middleware (depends on B003)

**Phase 4: Integration (2 beads)**
* B009: Protect existing routes with auth middleware (depends on B008)
* B010: Add integration tests for auth flows (depends on B009)

**Phase 5: Documentation (1 bead)**
* B011: Document authentication API and usage examples (depends on B010)
```

This structure enables 3 parallel beads in phase 2, then sequential implementation through phases 3-5.

### Pattern 2: Bug Fixes

**Characteristics:** Existing code modification, root cause analysis required, regression risk.

**Breakdown approach:**

1. Investigation bead (reproduce bug, identify root cause)
2. Fix implementation bead (minimal code change)
3. Regression testing bead (prevent reoccurrence)
4. Related issue scanning bead (check for similar bugs)

#### Example: Memory Leak in WebSocket Handler

```markdown
## Beads: Fix WebSocket Memory Leak (Bug Fix)

**Phase 1: Investigation (1 bead)**
* B001: Reproduce memory leak, profile heap usage, identify root cause

**Phase 2: Fix Implementation (1 bead)**
* B002: Implement fix (likely missing cleanup in disconnect handler) (depends on B001)

**Phase 3: Testing (2 beads, parallel)**
* B003: Add memory leak regression test (depends on B002)
* B004: Scan codebase for similar missing cleanup patterns (depends on B001)

**Phase 4: Validation (1 bead)**
* B005: Validate fix in staging environment under load (depends on B002, B003)
```

Bug fix beads prioritize fast investigation and minimal changes to reduce regression risk.

### Pattern 3: Refactoring Work

**Characteristics:** No behavior change, improve code structure, high test coverage required.

**Breakdown approach:**

1. Test coverage bead (ensure comprehensive tests exist BEFORE refactoring)
2. Refactoring beads (one per component, small incremental changes)
3. Validation bead (verify behavior unchanged)

#### Example: Extract Service Layer from Controllers

```markdown
## Beads: Extract Service Layer (Refactoring)

**Phase 1: Test Coverage Preparation (1 bead)**
* B001: Achieve 95%+ integration test coverage on affected controllers

**Phase 2: Service Extraction (4 beads, sequential to minimize conflicts)**
* B002: Extract UserController business logic to UserService (depends on B001)
* B003: Extract OrderController business logic to OrderService (depends on B001)
* B004: Extract ProductController business logic to ProductService (depends on B001)
* B005: Extract PaymentController business logic to PaymentService (depends on B001)

**Phase 3: Validation (1 bead)**
* B006: Run full test suite, verify no behavior changes (depends on B002-B005)
```

Refactoring beads are kept small (one controller per bead) to enable easy rollback if issues arise.

> [!TIP]
> **Refactoring Breakdown Strategy**
>
> For large refactorings spanning 10+ files, create "verification milestone" beads every 3-4 implementation beads. These run the full test suite and validate behavior preservation before continuing. This limits blast radius if problems emerge.

### Pattern 4: Documentation Tasks

**Characteristics:** No code implementation, research and writing required, validation through review.

**Breakdown approach:**

1. Research bead (gather information, identify gaps)
2. Writing beads (one per major section or document type)
3. Review bead (technical accuracy validation)
4. Polish bead (formatting, links, examples)

#### Example: API Documentation for New Endpoints

```markdown
## Beads: API Documentation for Rate Limiting Feature

**Phase 1: Research (1 bead)**
* B001: Gather endpoint details, error codes, configuration options from implementation

**Phase 2: Writing (3 beads, can be parallel)**
* B002: Write rate limiting concept overview (depends on B001)
* B003: Document rate limit configuration options (depends on B001)
* B004: Create endpoint reference with examples (depends on B001)

**Phase 3: Review and Polish (2 beads, sequential)**
* B005: Technical review by engineering team (depends on B002-B004)
* B006: Format, add navigation, validate links (depends on B005)
```

Documentation beads separate research, writing, and review for clear quality gates.

## Real-World Breakdown Example

This example demonstrates the complete methodology from feature requirements through validated bead structure.

### Initial Requirements

**Feature:** Add pagination support to product listing API endpoint.

**Requirements:**

* Support page-based pagination (page number + page size)
* Default page size: 20 items
* Maximum page size: 100 items
* Return total count and page metadata in response
* Maintain backward compatibility with existing unpaginated endpoint behavior

### Step 1: Feature Analysis (Applied)

```markdown
## Feature Analysis: Product Listing Pagination

**User-Facing Behavior:**
* GET /api/products accepts ?page=1&pageSize=20 query parameters
* Response includes items array plus pagination metadata
* Omitting parameters returns first 20 items (backward compatible)
* Invalid parameters (page < 1, pageSize > 100) return 400 error

**Affected Components:**
* ProductController (add query parameter parsing)
* ProductService (add pagination logic)
* ProductRepository (add LIMIT/OFFSET SQL logic)
* Response type definitions (add pagination metadata)

**Existing Patterns:**
* Query parameter parsing: src/middleware/query-parser.ts
* SQL pagination: src/repositories/order-repository.ts (lines 78-95)
* Response structure: src/types/api-response.ts

**Quality Requirements:**
* Performance: Query time <100ms for any page
* Validation: Reject invalid page/pageSize values
* Documentation: Update API reference with pagination examples

**Integration Points:**
* Frontend will need updated API client library
* Existing API consumers must continue working (backward compatibility)
```

This analysis identifies four implementation areas (controller, service, repository, types) with different dependencies.

### Step 2: Dependency Identification (Applied)

```markdown
## Dependency Analysis: Product Listing Pagination

**Foundation Layer:**
* Type definitions (no dependencies)
  * → Response type with pagination metadata
  * → Query parameter type definitions

**Data Layer:**
* Repository changes (depends on Type definitions)
  * → Add pagination parameters to findAll method
  * → Add total count query

**Business Layer:**
* Service changes (depends on Repository)
  * → Calculate page offsets
  * → Call paginated repository method
  * → Build pagination metadata

**API Layer:**
* Controller changes (depends on Service)
  * → Parse and validate query parameters
  * → Call service with pagination options
  * → Return paginated response

**Testing Layer:**
* Tests (depends on all implementation layers)
  * → Unit tests for service pagination logic
  * → Integration tests for endpoint behavior
  * → Backward compatibility tests
```

Clear dependency chain: Types → Repository → Service → Controller → Tests.

### Step 3: Bead Creation (Applied)

```markdown
## Bead: B001 - Define pagination types

**Status:** Ready
**Priority:** High
**Dependencies:** None
**Estimated Time:** 20 minutes

**Acceptance Criteria:**
- [ ] PaginationParams type defines page, pageSize, with validation constraints
- [ ] PaginationMetadata type defines totalItems, totalPages, currentPage, pageSize
- [ ] PaginatedResponse<T> generic type combines items array with metadata
- [ ] Type definitions exported from src/types/pagination.ts

**Context:**
Pagination requires consistent type definitions across controller, service, and repository layers.
Types must enforce constraints (page ≥ 1, 1 ≤ pageSize ≤ 100).

**Files to Modify:**
* src/types/pagination.ts - Create pagination types (NEW FILE)
* src/types/index.ts - Export pagination types

**Implementation Guidance:**
* Use Zod for runtime validation and TypeScript type inference
* Reference existing validation pattern in src/types/query-filters.ts

**Verification Approach:**
* Unit test: PaginationParams validation rejects invalid values
* Unit test: PaginatedResponse type compiles with various T types

---

## Bead: B002 - Add pagination to ProductRepository

**Status:** Blocked
**Priority:** High
**Dependencies:** B001
**Estimated Time:** 45 minutes

**Acceptance Criteria:**
- [ ] findAll method accepts optional PaginationParams
- [ ] SQL query uses LIMIT/OFFSET for pagination
- [ ] Separate getTotalCount method returns total items (for metadata calculation)
- [ ] Omitting PaginationParams returns first 20 items (backward compatible default)
- [ ] Database indexes support efficient offset queries

**Context:**
Repository layer provides data access with pagination support.
Must handle large result sets efficiently and maintain backward compatibility.

**Files to Modify:**
* src/repositories/product-repository.ts - Add pagination support to findAll
* src/repositories/product-repository.ts - Add getTotalCount method

**Implementation Guidance:**
* Reference pagination pattern in src/repositories/order-repository.ts (lines 78-95)
* Use SQL LIMIT/OFFSET: `LIMIT ${pageSize} OFFSET ${(page - 1) * pageSize}`
* Separate count query: `SELECT COUNT(*) FROM products WHERE ...`

**Research References:**
* Existing pagination: src/repositories/order-repository.ts (lines 78-95)
* Query builder usage: src/repositories/base-repository.ts (lines 34-56)

**Verification Approach:**
* Unit test: Pagination returns correct subset of results
* Unit test: Total count query returns accurate count
* Unit test: Omitting params returns default page size (20)
* Performance test: Query time <100ms measured via repository benchmark

---

## Bead: B003 - Add pagination logic to ProductService

**Status:** Blocked
**Priority:** High
**Dependencies:** B001, B002
**Estimated Time:** 30 minutes

**Acceptance Criteria:**
- [ ] getProducts method accepts optional PaginationParams
- [ ] Calculates pagination metadata (totalPages, currentPage)
- [ ] Returns PaginatedResponse<Product> with items and metadata
- [ ] Defaults to page=1, pageSize=20 when params omitted
- [ ] Validates pageSize ≤ 100 (throws error if exceeded)

**Context:**
Service layer orchestrates pagination logic between controller and repository.
Responsible for calculating pagination metadata from total count.

**Files to Modify:**
* src/services/product-service.ts - Update getProducts method signature
* src/services/product-service.ts - Add pagination metadata calculation

**Implementation Guidance:**
* Total pages calculation: `Math.ceil(totalItems / pageSize)`
* Offset calculation: `(page - 1) * pageSize`
* Validate pageSize before calling repository to prevent large queries

**Verification Approach:**
* Unit test: Correctly calculates totalPages for various counts
* Unit test: Throws error for pageSize > 100
* Unit test: Returns empty items array for page beyond total pages
* Unit test: Default params applied when omitted

---

## Bead: B004 - Update ProductController for pagination

**Status:** Blocked
**Priority:** High
**Dependencies:** B003
**Estimated Time:** 30 minutes

**Acceptance Criteria:**
- [ ] Parses page and pageSize from query parameters
- [ ] Validates parameters (page ≥ 1, pageSize ≤ 100)
- [ ] Returns 400 Bad Request for invalid parameters
- [ ] Passes parameters to ProductService.getProducts
- [ ] Response includes pagination metadata alongside items
- [ ] Omitting parameters works (backward compatible)

**Context:**
Controller exposes pagination through API endpoint.
Must validate user input and return appropriate error responses.

**Files to Modify:**
* src/controllers/product-controller.ts - Update GET /api/products handler
* src/middleware/query-parser.ts - Add pagination parameter parsing (if needed)

**Implementation Guidance:**
* Parse integers: `parseInt(req.query.page, 10)` with validation
* Return 400 error: `res.status(400).json({ error: 'Invalid pagination parameters' })`
* Use existing error handling middleware pattern

**Verification Approach:**
* Integration test: Valid pagination params return correct page
* Integration test: Invalid page (0) returns 400 error
* Integration test: Excessive pageSize (101) returns 400 error
* Integration test: Omitting params returns default behavior
* Integration test: Response includes pagination metadata object

---

## Bead: B005 - Add backward compatibility tests

**Status:** Blocked
**Priority:** Medium
**Dependencies:** B004
**Estimated Time:** 20 minutes

**Acceptance Criteria:**
- [ ] Test: GET /api/products (no params) returns 20 items
- [ ] Test: Response structure unchanged for unpaginated requests
- [ ] Test: Existing frontend code continues working
- [ ] Test: Pagination metadata included but not breaking

**Context:**
Existing API consumers must continue functioning without changes.
Backward compatibility critical to avoid breaking deployments.

**Files to Modify:**
* tests/integration/product-api.test.ts - Add backward compatibility tests

**Verification Approach:**
* Integration test: Unpaginated request returns expected structure
* Integration test: Frontend mock request succeeds with new response
```

Five beads with clear dependencies: B001 → B002 → B003 → B004 → B005.

### Step 4: Priority Assignment (Applied)

```markdown
## Priorities: Product Listing Pagination

**High Priority (Critical Path):**
* B001: Define pagination types (enables all other beads)
* B002: Add pagination to repository (enables service)
* B003: Add pagination logic to service (enables controller)
* B004: Update controller (enables testing and completion)

**Medium Priority (Validation):**
* B005: Add backward compatibility tests (ensures safe deployment)

**Implementation Order:**
1. B001 (20 min) - No blockers
2. B002 (45 min) - Start after B001 complete
3. B003 (30 min) - Start after B001 + B002 complete
4. B004 (30 min) - Start after B003 complete
5. B005 (20 min) - Start after B004 complete

**Total Estimated Time:** 145 minutes (~2.5 hours)
```

Sequential implementation minimizes context switching and dependency conflicts.

### Step 5: Acceptance Criteria Definition (Applied)

Each bead above includes specific, testable acceptance criteria. Example from B003:

**Effective Criteria:**

* ✅ Calculates pagination metadata (totalPages, currentPage) - *Testable via unit test*
* ✅ Returns PaginatedResponse\<Product\> with items and metadata - *Verifiable via type checking*
* ✅ Validates pageSize ≤ 100 (throws error if exceeded) - *Testable via unit test expecting error*
* ✅ Defaults to page=1, pageSize=20 when params omitted - *Testable via unit test*

Each criterion is boolean (pass/fail) and verifiable programmatically.

## Common Mistakes and Solutions

### Mistake 1: Over-Decomposition

**Problem:** Breaking work into beads smaller than 15-20 minutes creates excessive overhead.

**Example:**

* ❌ B001: Write TypeScript type definition (5 min)
* ❌ B002: Export type from index.ts (2 min)
* ❌ B003: Import type in service file (2 min)

**Solution:** Combine related small changes into single bead:

* ✅ B001: Define and integrate pagination types (20 min) - includes definition, export, initial imports

**Rule of thumb:** Beads < 20 minutes likely indicate over-decomposition unless they're foundation work enabling parallel downstream beads.

> [!WARNING]
> **Over-Decomposition Risk**
>
> Beads smaller than 15-20 minutes create planning overhead exceeding implementation time. Combine related micro-tasks into cohesive beads representing complete concepts (e.g., "pagination types" not "define type" + "export type" + "import type").

### Mistake 2: Circular Dependencies

**Problem:** Bead A depends on B, Bead B depends on A - creates blocking deadlock.

**Example:**

* ❌ B001: Create ProductService (depends on ProductController for type definitions)
* ❌ B002: Create ProductController (depends on ProductService for business logic)

**Solution:** Extract dependency into separate foundation bead:

* ✅ B001: Define shared types for Product domain
* ✅ B002: Create ProductService (depends on B001)
* ✅ B003: Create ProductController (depends on B001, B002)

**Detection technique:** Draw dependency graph - any cycles indicate circular dependencies requiring refactoring.

### Mistake 3: Vague Acceptance Criteria

**Problem:** Ambiguous "done" definition causes incomplete implementations and rework.

**Example:**

* ❌ "Service works correctly"
* ❌ "Error handling implemented"
* ❌ "Tests are adequate"

**Solution:** Define measurable, verifiable criteria:

* ✅ "Service returns PaginatedResponse with items array and metadata object containing totalItems, totalPages, currentPage, pageSize fields"
* ✅ "Service throws ValidationError with message 'Page size exceeds maximum (100)' when pageSize > 100"
* ✅ "Test suite achieves 95%+ branch coverage measured by Jest coverage report"

### Mistake 4: Missing Context

**Problem:** Implementation agent lacks information needed to complete bead autonomously.

**Example:**

```markdown
## Bead: B003 - Add pagination to repository

**Acceptance Criteria:**
- [ ] Repository supports pagination

**Files:** src/repositories/product-repository.ts
```

**Solution:** Provide complete context:

```markdown
## Bead: B003 - Add pagination to repository

**Acceptance Criteria:**
- [ ] findAll method accepts optional PaginationParams (page, pageSize)
- [ ] Uses SQL LIMIT/OFFSET for pagination
- [ ] Separate getTotalCount method returns total items

**Context:**
Repository must support efficient pagination for large product catalogs (10K+ items).
Reference existing pagination pattern in order-repository.ts (lines 78-95).
Database has index on (category_id, created_at) supporting sorted pagination.

**Files:** 
* src/repositories/product-repository.ts - Update findAll method
* src/repositories/product-repository.ts - Add getTotalCount method

**Research References:**
* Existing pattern: src/repositories/order-repository.ts (lines 78-95)
```

The second version provides everything needed: what to do, how to do it, where to find examples, and why decisions matter.

## Integration with RPI Framework

Systematic task breakdown supports the RPI framework's Research → Plan → Implement cycle:

**Research Phase:**

* Identify existing code patterns for bead context
* Locate similar implementations to reference
* Discover dependency relationships through code analysis
* Document findings for planning phase

**Planning Phase:**

* Apply breakdown methodology to create bead structure
* Define priorities based on critical path and dependencies
* Establish acceptance criteria for each bead
* Create execution order maximizing parallel work

**Implementation Phase:**

* Execute beads in priority order
* Mark acceptance criteria complete as verification succeeds
* Update bead status (Ready → In Progress → Complete)
* Document blockers or discoveries for plan refinement

This tight integration ensures planning directly supports systematic implementation.

> [!TIP]
> **Task Breakdown in RPI Context**
>
> During the Planning phase, use Task Planner mode to create initial bead structure. During Implementation phase, switch to Agent mode with `/bd-start` to execute beads systematically. This mode combination enforces the planning-execution separation while maintaining context through bead documents.

## Connection to Part III Advanced Patterns

This section covered Part II fundamentals:

* Five-step breakdown methodology
* Dependency identification techniques  
* Bead creation with complete context
* Priority assignment for sequential and parallel work
* Acceptance criteria definition

**Part III** extends these foundations with advanced patterns:

* **Chapter 12: Prompt Files** - Using instruction files with `applyTo` patterns to automatically provide Beads context
* **Chapter 13: Instruction Patterns** - Technology-specific breakdown patterns and layered context management
* **Chapter 14: Custom Agents** - Parallel agent execution, complex dependency graph management, dynamic re-planning, production workflow integration (CI/CD, code review), and multi-phase orchestration with verification milestones
* **Chapter 15: Meta-Prompting** - Programmatic Beads generation and optimization

Start with these Part II fundamentals, then progress to Part III for sophisticated orchestration in production environments.

---

---

**Previous:** [Complex Workflow: Large Refactoring](./07-complex-workflow-large-refactoring.md) | **Next:** [Beads TDD Exercise](./09-beads-tdd-exercise.md)

---

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
