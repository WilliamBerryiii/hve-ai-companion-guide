---
title: Beads TDD Exercise - Authentication Endpoint
description: Apply systematic task breakdown and Beads workflow to implement a user authentication endpoint using test-driven development
author: HVE Core Team
ms.date: 2025-11-24
ms.topic: how-to
keywords:
  - beads workflow exercise
  - TDD practice
  - authentication endpoint
  - task breakdown application
  - agent handoff workflow
  - hands-on learning
estimated_reading_time: 15
---

This hands-on exercise applies the systematic task breakdown methodology and Beads workflow you learned in previous sections. You'll implement a user authentication endpoint using test-driven development with explicit planning and implementation phases.

## Learning Objectives

By completing this exercise, you'll gain practical experience:

* **Applying the five-step breakdown methodology** to a real feature
* **Creating planning phase beads** with test specifications and design decisions
* **Executing implementation phase beads** following TDD Red-Green-Refactor cycles
* **Documenting agent handoffs** between planning and implementation
* **Tracking bead status** as work progresses through Ready → In Progress → Complete
* **Verifying acceptance criteria** at handoff points ensuring quality gates

This exercise reinforces Chapter 11 fundamentals. Part III, Chapter 14 covers advanced patterns including parallel agent execution, custom agent creation, and complex dependency orchestration.

## Exercise Overview

**Scenario:** You're building a REST API that needs user authentication. Implement a `/api/auth/login` endpoint accepting username and password, validating credentials against a database, and returning a JWT token on success.

**Feature Requirements:**

* POST endpoint at `/api/auth/login`
* Request body: `{ "username": string, "password": string }`
* Response on success: `{ "token": string, "expiresIn": number }`
* Response on failure: `{ "error": string }` with 401 status
* Password validation using bcrypt comparison
* JWT token with 1-hour expiration
* Input validation for missing/invalid fields

**Technology Stack:** Node.js, Express, TypeScript, Jest, bcrypt, jsonwebtoken

**Time Estimate:** 3-4 hours for complete exercise including planning, implementation, and verification. Individual bead times are optimistic targets for developers experienced with the technology stack—adjust based on your familiarity with the technologies and TDD practices.

> [!NOTE]
> Time estimates throughout this exercise assume familiarity with the technology stack and test-driven development. First-time practitioners should expect longer completion times while learning the workflow. Focus on understanding the *process* rather than matching specific time targets.

## Phase 1: Planning Beads Creation

Apply the systematic task breakdown methodology from Section 06. Create three planning beads defining test specifications, API contract, and dependencies before implementation.

### Bead 1: Define Test Specifications

Create your first bead in `.copilot-tracking/beads/auth-login-beads.md`:

```markdown
## Bead AUTH-001: Test Specifications for Login Endpoint

**Status:** Ready
**Priority:** High
**Dependencies:** None
**Estimated Time:** 20 minutes
**Phase:** Planning (Read-Only Tools)

**Context:**
Login endpoint requires comprehensive test coverage including success cases (valid credentials), failure cases (invalid credentials, missing fields, malformed input), and security considerations (password hashing, token structure).

**Acceptance Criteria:**
- [ ] Test specification defines success scenario with valid credentials
- [ ] Test specification defines failure scenario with incorrect password
- [ ] Test specification defines failure scenario with non-existent user
- [ ] Test specification defines failure scenario with missing username field
- [ ] Test specification defines failure scenario with missing password field
- [ ] Test specification covers JWT token structure and expiration
- [ ] Test specification covers bcrypt password verification
- [ ] Each test has clear Given-When-Then structure

**Files to Create:**
* `.copilot-tracking/beads/auth-test-specifications.md` - Test specifications document

**Implementation Guidance:**
* Use Given-When-Then format for each test case
* Specify expected status codes (200, 401, 400)
* Define exact error message formats
* Include security validation requirements

**Research References:**
* Section 05 TDD with AI - Red-Green-Refactor cycle patterns
* Section 06 Systematic Task Breakdown - Acceptance criteria examples

**Verification Approach:**
Test specifications are complete when they provide sufficient detail for implementation agent to write tests autonomously without additional context questions.
```

**Exercise Step 1:** Create this bead document. Open your `.copilot-tracking/beads/` directory and save the bead structure above. Notice how acceptance criteria are specific and testable—each checkbox defines concrete deliverables.

**TIP:** Planning phase uses read-only tools (read_file, grep_search, semantic_search). This prevents accidental code changes during planning. Create bead documents in `.copilot-tracking/beads/` directory for agent handoff.

### Bead 2: Design API Contract

```markdown
## Bead AUTH-002: API Contract Design

**Status:** Ready
**Priority:** High
**Dependencies:** AUTH-001
**Estimated Time:** 25 minutes
**Phase:** Planning (Read-Only Tools)

**Context:**
API contract defines request/response schemas, validation rules, HTTP status codes, and error formats. This contract becomes the source of truth for both tests and implementation.

**Acceptance Criteria:**
- [ ] Request schema defined with username (string, required, 3-50 chars) and password (string, required, 8+ chars)
- [ ] Success response schema defined with token (JWT string) and expiresIn (number, seconds)
- [ ] Error response schema defined with error (string, descriptive message)
- [ ] HTTP status codes documented (200 success, 401 invalid credentials, 400 validation errors)
- [ ] Validation rules specified for username format (alphanumeric, underscore, hyphen)
- [ ] JWT payload structure defined (userId, username, iat, exp claims)
- [ ] Security headers documented (Content-Type application/json)

**Files to Create:**
* `.copilot-tracking/beads/auth-api-contract.md` - Complete API specification

**Implementation Guidance:**
* Use TypeScript interface notation for schemas
* Specify exact error message text for consistency
* Define JWT secret environment variable requirement
* Include example requests and responses

**Research References:**
* Existing API patterns in `src/routes/` directory
* Error handling patterns in `src/middleware/error-handler.ts`

**Verification Approach:**
API contract is complete when it answers all "what should happen when..." questions without ambiguity. Implementation agent should not need to make design decisions.
```

**Exercise Step 2:** Create Bead AUTH-002 document. Notice the dependency on AUTH-001—test specifications inform API contract decisions. Design decisions made in planning prevent implementation rework.

### Bead 3: Identify Dependencies and Architecture

```markdown
## Bead AUTH-003: Dependencies and Architecture Analysis

**Status:** Ready
**Priority:** High
**Dependencies:** AUTH-001, AUTH-002
**Estimated Time:** 30 minutes
**Phase:** Planning (Read-Only Tools)

**Context:**
Authentication endpoint requires integration with existing user repository, password hashing utilities, JWT token generation, and Express middleware for validation. Identify all dependencies, determine implementation order, and document architectural decisions.

**Acceptance Criteria:**
- [ ] User repository interface defined (findByUsername method signature)
- [ ] Password comparison utility identified (bcrypt.compare wrapper if needed)
- [ ] JWT generation utility identified (token creation with configurable expiration)
- [ ] Input validation middleware approach decided (express-validator or custom)
- [ ] Error handling integration documented (how errors propagate to client)
- [ ] Database schema assumptions documented (User model fields required)
- [ ] Environment variables listed (JWT_SECRET, JWT_EXPIRATION)
- [ ] Implementation order determined (utilities → repository → route → integration)

**Files to Create:**
* `.copilot-tracking/beads/auth-dependencies-architecture.md` - Dependency analysis and implementation plan

**Implementation Guidance:**
* Examine existing `src/repositories/` patterns
* Check for existing password utilities in `src/utils/`
* Identify JWT token patterns in codebase
* Create dependency diagram: Foundation → Data → Business → API layers
* Determine what can be implemented in parallel vs sequentially

**Research References:**
* Section 06 Systematic Task Breakdown - Dependency identification patterns
* Existing repository patterns in workspace

**Verification Approach:**
Architecture analysis is complete when implementation beads can be created with clear boundaries, no circular dependencies, and explicit handoff points between beads.
```

**Exercise Step 3:** Create Bead AUTH-003 document. This completes the planning phase. You now have complete specifications, API contract, and architectural decisions documented before writing any code.

**IMPORTANT:** Planning phase creates foundation for implementation success. Incomplete planning leads to mid-implementation design changes, circular dependencies, and scope creep. Invest time validating planning beads before proceeding to implementation.

## Phase 2: Handoff to Implementation

**Handoff Checkpoint:** Review all planning beads ensuring acceptance criteria completeness.

Create handoff document in `.copilot-tracking/handoffs/planning-to-implementation.md`:

```markdown
# Planning to Implementation Handoff: Authentication Login

**Planning Phase Complete:** 2025-11-24
**Implementation Phase Starting:** [Current Date]

## Planning Beads Summary

**AUTH-001: Test Specifications** ✅ Complete
* 7 test cases defined with Given-When-Then structure
* Security requirements specified (bcrypt, JWT structure)
* Expected status codes and error formats documented

**AUTH-002: API Contract** ✅ Complete
* Request/response schemas defined with TypeScript interfaces
* Validation rules specified (username 3-50 chars, password 8+ chars)
* JWT payload structure documented (userId, username, iat, exp)
* Error message formats standardized

**AUTH-003: Dependencies and Architecture** ✅ Complete
* User repository interface defined (findByUsername required)
* bcrypt.compare for password validation identified
* JWT generation utility requirements specified (configurable expiration)
* Implementation order: Test Foundation → Repository → Auth Logic → Route → Integration
* No circular dependencies detected

## Implementation Beads Created

**AUTH-004: RED Phase - Write Failing Tests** (Ready)
**AUTH-005: GREEN Phase - Implement Auth Logic** (Blocked on AUTH-004)
**AUTH-006: GREEN Phase - Integrate Route Handler** (Blocked on AUTH-005)
**AUTH-007: REFACTOR Phase - Improve Code Quality** (Blocked on AUTH-006)
**AUTH-008: Verification - Test Full Integration** (Blocked on AUTH-007)

## Quality Gates for Implementation

Before marking implementation complete:
* All tests pass (Jest coverage ≥90% for auth logic)
* No TypeScript compilation errors
* ESLint passes without warnings
* Password never logged or exposed in error messages
* JWT secret loaded from environment (fails gracefully if missing)
* Postman/curl manual testing confirms expected behavior

## Context for Implementation Agent

Implementation agent has full tool access (create_file, replace_string_in_file, run_in_terminal). Follow TDD discipline strictly: write failing test first (RED), implement minimal code to pass (GREEN), refactor for quality (REFACTOR).

Each implementation bead represents one complete RED-GREEN-REFACTOR cycle or one integration step.
```

**Exercise Step 4:** Create the handoff document. This explicit handoff ensures nothing gets lost between planning and implementation. Implementation agent receives complete context.

**TIP:** Handoff documents preserve context across mode switches. When switching from Task Planner (planning) to Agent mode (implementation), the handoff document provides complete historical context preventing rework.

## Phase 3: Implementation Beads Execution

Now execute implementation beads following TDD discipline. Each bead represents one RED-GREEN-REFACTOR cycle.

### Bead 4: RED Phase - Write Failing Tests

```markdown
## Bead AUTH-004: RED Phase - Write Failing Tests

**Status:** In Progress
**Priority:** High
**Dependencies:** AUTH-001, AUTH-002, AUTH-003 (Planning beads complete)
**Estimated Time:** 45 minutes
**Phase:** Implementation (Full Tools)

**Context:**
Create comprehensive test suite for login endpoint implementing all test specifications from AUTH-001. Tests will fail initially (RED phase) because implementation doesn't exist yet. This validates tests actually check something.

**Acceptance Criteria:**
- [ ] Test file created: `src/routes/__tests__/auth-login.test.ts`
- [ ] Test: Valid credentials returns 200 with token and expiresIn
- [ ] Test: Invalid password returns 401 with error message
- [ ] Test: Non-existent user returns 401 with error message
- [ ] Test: Missing username returns 400 with validation error
- [ ] Test: Missing password returns 400 with validation error
- [ ] Test: JWT token contains correct userId and username claims
- [ ] Test: JWT token expires in 3600 seconds (1 hour)
- [ ] Mock UserRepository.findByUsername implemented
- [ ] Mock bcrypt.compare implemented
- [ ] All tests fail when run (RED phase confirmed)
- [ ] Test output clearly shows expected vs actual behavior

**Files to Create:**
* `src/routes/__tests__/auth-login.test.ts` - Complete test suite (~150 lines)

**Implementation Guidance:**
* Use Jest with supertest for HTTP endpoint testing
* Mock UserRepository using jest.mock()
* Mock bcrypt.compare to control success/failure scenarios
* Each test follows Given-When-Then structure with clear setup
* Use descriptive test names: "returns 401 when password is incorrect"
* Verify JWT token structure using jwt.decode() in tests

**Example Test Structure:**
```typescript
describe('POST /api/auth/login', () => {
  describe('when credentials are valid', () => {
    it('returns 200 with token and expiresIn', async () => {
      // Given: User exists with correct password hash
      // When: POST /api/auth/login with valid credentials
      // Then: Response 200 with { token, expiresIn }
    });
  });
  
  describe('when credentials are invalid', () => {
    it('returns 401 when password is incorrect', async () => {
      // Given: User exists but password doesn't match
      // When: POST /api/auth/login with wrong password
      // Then: Response 401 with { error: "Invalid credentials" }
    });
  });
});
```

**Research References:**

* Section 05 TDD with AI - RED phase patterns
* Existing test patterns in `src/routes/__tests__/` directory

**Verification Approach:**
Run `npm test -- auth-login.test.ts` and confirm all tests fail with clear error messages. If tests pass, they're not testing anything useful.

```text

**Exercise Step 5:** Implement Bead AUTH-004. Write complete test suite using Jest and supertest. Run tests to confirm they fail (RED phase).

**Command to run tests:**
```bash
npm test -- auth-login.test.ts
```

**Expected output:** All tests fail because login endpoint doesn't exist yet. Failure messages should clearly indicate "cannot POST /api/auth/login" or similar.

### Bead 5: GREEN Phase - Implement Authentication Logic

```markdown
## Bead AUTH-005: GREEN Phase - Implement Auth Logic

**Status:** Blocked (depends on AUTH-004)
**Priority:** High
**Dependencies:** AUTH-004 (Tests exist and fail)
**Estimated Time:** 40 minutes
**Phase:** Implementation (Full Tools)

**Context:**
Implement minimal code to make tests pass. Create authentication logic, password verification, and JWT token generation. Focus on satisfying test requirements exactly—don't add extra features.

**Acceptance Criteria:**
- [ ] File created: `src/routes/auth.ts` with login route handler
- [ ] UserRepository.findByUsername called with username from request
- [ ] bcrypt.compare validates password against user's hash
- [ ] JWT token generated using jsonwebtoken with userId and username claims
- [ ] JWT token includes iat (issued at) and exp (expiration) claims
- [ ] Token expiration set to 3600 seconds (1 hour)
- [ ] Success response returns { token, expiresIn: 3600 }
- [ ] Invalid credentials return 401 with { error: "Invalid credentials" }
- [ ] Missing fields return 400 with descriptive validation errors
- [ ] Non-existent user returns 401 (doesn't reveal user existence)
- [ ] All tests from AUTH-004 now pass (GREEN phase confirmed)
- [ ] No test failures or TypeScript compilation errors

**Files to Create:**
* `src/routes/auth.ts` - Login route handler (~80 lines)

**Files to Modify:**
* `src/app.ts` - Register auth routes with Express app

**Implementation Guidance:**
* Minimal implementation only—satisfy tests exactly
* Use existing UserRepository interface (or create if needed)
* Load JWT_SECRET from process.env with validation
* Use express-validator for input validation
* Don't implement features not covered by tests
* Error handling propagates to Express error middleware

**Example Implementation Pattern:**
```typescript
router.post('/login', 
  validateLoginInput,
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const { username, password } = req.body;
      
      // Find user
      const user = await userRepository.findByUsername(username);
      if (!user) {
        return res.status(401).json({ error: "Invalid credentials" });
      }
      
      // Verify password
      const isValidPassword = await bcrypt.compare(password, user.passwordHash);
      if (!isValidPassword) {
        return res.status(401).json({ error: "Invalid credentials" });
      }
      
      // Generate token
      const token = jwt.sign(
        { userId: user.id, username: user.username },
        process.env.JWT_SECRET!,
        { expiresIn: 3600 }
      );
      
      res.json({ token, expiresIn: 3600 });
    } catch (error) {
      next(error);
    }
  }
);
```

**Research References:**

* Section 05 TDD with AI - GREEN phase patterns
* Section 06 Systematic Task Breakdown - Implementation guidance examples

**Verification Approach:**
Run `npm test -- auth-login.test.ts` and confirm all tests pass. Run `npm run build` to ensure TypeScript compiles without errors.

```text

**Exercise Step 6:** Implement Bead AUTH-005. Write minimal code to make tests pass. Avoid adding features not covered by tests—that's scope creep.

**Commands to verify:**
```bash
npm test -- auth-login.test.ts  # All tests should pass
npm run build                    # TypeScript compilation succeeds
```

**Expected outcome:** All tests pass. If any test fails, debug before proceeding. GREEN phase means 100% test pass rate.

### Bead 6: Integration and Route Registration

```markdown
## Bead AUTH-006: Integration and Route Registration

**Status:** Blocked (depends on AUTH-005)
**Priority:** High
**Dependencies:** AUTH-005 (Auth logic implemented and tested)
**Estimated Time:** 20 minutes
**Phase:** Implementation (Full Tools)

**Context:**
Integrate authentication route into main Express application. Register route at `/api/auth/login` ensuring middleware ordering is correct (JSON body parsing before auth routes).

**Acceptance Criteria:**
- [ ] Auth routes registered in `src/app.ts` at `/api/auth` prefix
- [ ] JSON body parser middleware configured before auth routes
- [ ] Error handling middleware registered after auth routes
- [ ] Environment variable JWT_SECRET validated on app startup
- [ ] Integration test confirms route accessible at `/api/auth/login`
- [ ] Postman/curl manual test with real request succeeds
- [ ] 404 returned for non-existent routes under `/api/auth`

**Files to Modify:**
* `src/app.ts` - Register auth routes
* `src/config/environment.ts` - Validate JWT_SECRET (if needed)

**Implementation Guidance:**
* Use app.use('/api/auth', authRoutes) pattern
* Validate JWT_SECRET exists in environment on startup
* Fail fast with clear error if JWT_SECRET missing
* Manual testing command: `curl -X POST http://localhost:3000/api/auth/login -H "Content-Type: application/json" -d '{"username":"testuser","password":"testpass"}'`

**Research References:**
* Existing route registration patterns in `src/app.ts`

**Verification Approach:**
Start development server and test with curl or Postman. Verify 200 response with valid credentials, 401 with invalid credentials, 400 with missing fields.
```

**Exercise Step 7:** Implement Bead AUTH-006. Integrate route into Express app and perform manual testing.

**Manual testing commands:**

```bash
# Start server
npm run dev

# Test valid credentials (in another terminal)
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","password":"testpass"}'

# Test invalid credentials
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","password":"wrongpass"}'

# Test missing field
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser"}'
```

**Expected outcomes:** Valid credentials return 200 with JWT token. Invalid credentials return 401. Missing fields return 400.

### Bead 7: REFACTOR Phase - Code Quality Improvements

```markdown
## Bead AUTH-007: REFACTOR Phase - Improve Code Quality

**Status:** Blocked (depends on AUTH-006)
**Priority:** Medium
**Dependencies:** AUTH-006 (Integration complete and tested)
**Estimated Time:** 30 minutes
**Phase:** Implementation (Full Tools)

**Context:**
Improve code quality while keeping all tests green. Extract reusable utilities, improve error handling, add type safety, enhance readability. Tests provide safety net for refactoring.

**Acceptance Criteria:**
- [ ] Password validation logic extracted to `src/utils/password.ts` utility
- [ ] JWT token generation extracted to `src/utils/jwt.ts` utility
- [ ] Input validation rules extracted to `src/validators/auth.validator.ts`
- [ ] Magic numbers removed (3600 becomes constant JWT_EXPIRATION_SECONDS)
- [ ] Type definitions created for LoginRequest and LoginResponse
- [ ] Error messages defined as constants (no hardcoded strings in route handler)
- [ ] JSDoc comments added to public functions
- [ ] All tests still pass after refactoring
- [ ] ESLint passes with no warnings
- [ ] Test coverage remains ≥90%

**Files to Create:**
* `src/utils/password.ts` - Password validation utilities
* `src/utils/jwt.ts` - JWT token generation utilities
* `src/validators/auth.validator.ts` - Input validation rules
* `src/types/auth.types.ts` - Type definitions

**Files to Modify:**
* `src/routes/auth.ts` - Refactored to use extracted utilities

**Implementation Guidance:**
* Run tests after each refactoring step
* Extract one utility at a time (don't refactor everything simultaneously)
* Keep route handler focused on HTTP concerns (request/response handling)
* Business logic moves to utilities (password verification, token generation)
* Validation logic moves to validators (input rules)

**Example Refactored Structure:**
```typescript
// Before refactoring:
const isValidPassword = await bcrypt.compare(password, user.passwordHash);

// After refactoring:
import { verifyPassword } from '../utils/password';
const isValidPassword = await verifyPassword(password, user.passwordHash);
```

**Research References:**

* Section 05 TDD with AI - REFACTOR phase patterns
* Existing utility patterns in `src/utils/` directory

**Verification Approach:**
Run full test suite and ensure 100% pass rate. Run ESLint and confirm no warnings. Compare code coverage before/after refactoring (should remain same or improve).

```text

**Exercise Step 8:** Implement Bead AUTH-007. Refactor code to improve quality while keeping tests green. Run tests after each refactoring step.

**Commands to verify:**
```bash
npm test                  # All tests pass
npm run lint              # ESLint passes
npm run test:coverage     # Coverage ≥90%
```

**TIP:** Refactor in small steps. Extract one utility, run tests. Extract next utility, run tests. Small steps prevent breaking changes.

### Bead 8: Final Verification and Documentation

```markdown
## Bead AUTH-008: Final Verification and Documentation

**Status:** Blocked (depends on AUTH-007)
**Priority:** High
**Dependencies:** AUTH-007 (Refactoring complete)
**Estimated Time:** 25 minutes
**Phase:** Implementation (Full Tools)

**Context:**
Final verification ensuring feature meets all requirements. Update documentation, verify security requirements, confirm error handling, validate edge cases.

**Acceptance Criteria:**
- [ ] All acceptance criteria from planning beads verified complete
- [ ] README.md updated with authentication endpoint documentation
- [ ] API documentation includes example requests and responses
- [ ] Security checklist confirmed: passwords hashed, secrets from env, no sensitive data logged
- [ ] Error handling verified: validation errors descriptive, auth failures don't reveal user existence
- [ ] Edge cases tested: malformed JSON, empty strings, SQL injection attempts
- [ ] Performance verified: response time <200ms for authentication
- [ ] Manual testing performed with Postman collection saved
- [ ] All bead status updated to Complete in tracking document

**Files to Modify:**
* `README.md` - Add authentication endpoint documentation
* `docs/api/authentication.md` - Detailed API documentation (if exists)
* `.copilot-tracking/beads/auth-login-beads.md` - Update all bead statuses to Complete

**Implementation Guidance:**
* Document example curl commands for common scenarios
* Include troubleshooting section (missing JWT_SECRET, database connection failures)
* Verify TypeScript types exported from appropriate index files
* Confirm no console.log statements left in production code

**Research References:**
* Existing API documentation patterns in workspace

**Verification Approach:**
Run complete test suite, start server and perform manual smoke tests, review all planning bead acceptance criteria ensuring each is satisfied.
```

**Exercise Step 9:** Implement Bead AUTH-008. Perform final verification and update documentation. Confirm all planning beads have satisfied acceptance criteria.

## Exercise Completion Checklist

Verify you've completed all exercise components:

**Planning Phase:**

* [ ] Created AUTH-001: Test Specifications (20 min)
* [ ] Created AUTH-002: API Contract Design (25 min)
* [ ] Created AUTH-003: Dependencies and Architecture (30 min)
* [ ] Created planning-to-implementation handoff document

**Implementation Phase:**

* [ ] Completed AUTH-004: RED Phase - Failing tests written (45 min)
* [ ] Completed AUTH-005: GREEN Phase - Implementation makes tests pass (40 min)
* [ ] Completed AUTH-006: Integration and manual testing (20 min)
* [ ] Completed AUTH-007: REFACTOR Phase - Code quality improved (30 min)
* [ ] Completed AUTH-008: Final verification and documentation (25 min)

**Quality Gates:**

* [ ] All Jest tests pass (≥90% coverage)
* [ ] TypeScript compiles without errors
* [ ] ESLint passes without warnings
* [ ] Manual testing confirms expected behavior
* [ ] Security requirements validated (no password logging, secrets from env)
* [ ] Documentation updated with API examples

**Total Time:** ~225 minutes (3.75 hours) for complete exercise with planning and implementation

## Troubleshooting Common Issues

### Issue 1: Tests Pass Immediately (Skipped RED Phase)

**Problem:** Tests pass without implementation existing.

**Root Cause:** Tests are mocking too much or not actually calling the endpoint.

**Solution:** Verify tests use supertest to make real HTTP requests. Remove excessive mocking—only mock external dependencies (database, bcrypt). Tests should fail with "Cannot POST /api/auth/login" if route doesn't exist.

### Issue 2: Circular Dependencies Between Beads

**Problem:** Can't determine implementation order because beads depend on each other.

**Root Cause:** Insufficient dependency analysis in planning phase (AUTH-003).

**Solution:** Extract foundation bead containing shared types/interfaces. Foundation bead has no dependencies. Other beads depend on foundation. Review Section 06 dependency identification patterns.

### Issue 3: Implementation Exceeds Test Coverage

**Problem:** Implementation includes features not covered by tests.

**Root Cause:** Scope creep during GREEN phase—adding "nice to have" features.

**Solution:** Remove all code not required to make tests pass. If feature is valuable, add it in next iteration: write test first (RED), then implement (GREEN). TDD discipline prevents scope creep.

### Issue 4: Handoff Document Incomplete

**Problem:** Implementation agent asks design questions that should have been answered in planning.

**Root Cause:** Planning beads lack sufficient detail or acceptance criteria are vague.

**Solution:** Return to planning phase. Update planning beads with missing details. Revise handoff document. Incomplete planning creates implementation delays—investing time in planning pays dividends during implementation.

## Extension Ideas

Take this exercise further by adding complexity:

### Extension 1: Refresh Token Flow

* Break down refresh token endpoint using same methodology
* Additional planning beads for refresh token storage and rotation
* Implement Redis for refresh token persistence
* Add integration between login and refresh flows

### Extension 2: Rate Limiting

* Apply systematic task breakdown to rate limiting feature
* Create planning beads for rate limiter middleware
* Implement Redis-based rate limiting (5 requests per minute per IP)
* Add tests for rate limit exceeded scenarios

### Extension 3: Multi-Factor Authentication

* Decompose MFA flow into planning beads
* Design TOTP token generation and verification
* Implement QR code generation for MFA setup
* Add verification step to login flow

### Extension 4: Parallel Bead Execution

* Identify beads that can be implemented in parallel
* Create separate branches for independent beads
* Practice merging parallel implementation streams
* Document conflict resolution strategies

Each extension provides practice applying the five-step methodology to increasingly complex features. Start with complete planning phase before any implementation.

## Reflection Questions

After completing the exercise, reflect on your experience:

1. **Planning Impact:** How did complete planning phase reduce implementation uncertainty? What would have been harder without detailed planning beads?

2. **Bead Boundaries:** Were bead boundaries clear and appropriate? Which beads were too large or too small? How would you adjust for next feature?

3. **Handoff Quality:** Did handoff document provide sufficient context for implementation? What information was missing or unclear?

4. **TDD Discipline:** Did RED-GREEN-REFACTOR cycle improve code quality? How did tests provide safety net during refactoring?

5. **Dependency Management:** Were dependencies identified accurately in planning? Did you encounter unexpected blocking relationships?

6. **Acceptance Criteria:** Were acceptance criteria specific enough to know when beads were complete? Which criteria needed more precision?

## Next Steps

You've practiced systematic task breakdown and Beads workflow with a complete feature implementation. Continue developing these skills:

* **[Section 10: Debugging and Recovery Strategies](./10-debugging-recovery-strategies.md)** demonstrates how bead structure enables fast rollback when issues arise
* **[Section 11: Measuring Workflow Effectiveness](./11-measuring-effectiveness.md)** shows how to track and improve your AI-assisted development patterns
* **Part III:** Advanced patterns for production environments:
  * **Chapter 12:** Prompt files with automatic Beads context via `applyTo` patterns
  * **Chapter 13:** Technology-specific instruction patterns for consistent breakdown
  * **Chapter 14:** Custom agents, parallel execution, complex dependency graphs, and CI/CD integration
  * **Chapter 15:** Meta-prompting for programmatic Beads generation

Return to this exercise as a reference when breaking down your own features. The five-step methodology and planning-implementation handoff pattern apply to any feature regardless of technology stack or complexity.

---

**Previous:** [Systematic Task Breakdown](./08-systematic-task-breakdown.md) | **Next:** [Debugging and Recovery Strategies](./10-debugging-recovery-strategies.md)

---

*This exercise demonstrates Part II fundamentals. Part III covers advanced Beads patterns and custom agent orchestration for production environments.*
