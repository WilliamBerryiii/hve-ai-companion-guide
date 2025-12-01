---
title: "Complete Agent Workflow - Autonomous Execution in Practice"
description: "Experience a complete autonomous workflow with detailed execution timeline showing Agent implementing multi-step features end-to-end"
author: "HVE Core Team"
ms.date: 2025-11-19
section: 4
chapter: 9
part: 2
keywords:
  - autonomous-workflow
  - execution-timeline
  - test-first-workflow
  - agent-execution
estimated_reading_time: 15
---

## Seeing Autonomous Execution in Action

Understanding Agent Mode requires watching it work. This section walks through a complete autonomous workflow with realistic timing and detailed Agent commentary.

You'll see Agent implement three related steps from a 2FA feature plan without any Ask checkpoints. Watch how Agent analyzes the plan, writes tests first, implements features, and verifies everything works.

### The Scenario

You're implementing Phase 2 of a two-factor authentication feature. The plan defines three steps:

1. **Step 2.1**: Create `TwoFactorService` with encryption and TOTP generation (~8 min)
2. **Step 2.2**: Create `/api/auth/2fa/setup` endpoint for generating QR codes (~7 min)
3. **Step 2.3**: Update login to verify TOTP tokens (~5 min)

Total estimated time: ~20 minutes. You're handing all three steps to Agent Mode at once. Actual timing will vary based on task complexity and your environment.

## Implementation Plan Structure

Agent needs a complete plan with clear specifications. Here's the plan structure you provide:

```markdown
Phase 2: Business Logic (20 min)

Step 2.1: Create TwoFactorService (8 min)
- Location: src/services/TwoFactorService.ts (new file)
- Implementation: 
  - generateSecret(userEmail): Generate TOTP secret, return QR code data URL
  - verifyToken(secret, token): Verify 6-digit token with 30-second window
  - encryptSecret(secret): Encrypt using AES-256-GCM
  - decryptSecret(encrypted): Decrypt encrypted secret
- Dependencies: speakeasy (TOTP), crypto (encryption)
- Pattern: Follow src/services/authService.ts structure
- Verification: 8 unit tests pass

Step 2.2: Create /api/auth/2fa/setup endpoint (7 min)
- Location: src/auth/authRoutes.ts (after login route, ~line 95)
- Implementation:
  - POST /api/auth/2fa/setup (authenticated users only)
  - Generate secret via TwoFactorService.generateSecret()
  - Encrypt and store in user.twoFactorSecret
  - Return { qrCode, backupCodes }
- Dependencies: TwoFactorService, authMiddleware
- Verification: 5 integration tests pass, returns 200 with QR code

Step 2.3: Update login to verify 2FA token (5 min)
- Location: src/auth/authRoutes.ts, login handler (lines 78-95)
- Implementation:
  - After password verification, check user.twoFactorEnabled
  - If true, require totpToken in request body
  - Verify using TwoFactorService.verifyToken()
  - Return 401 if invalid, 400 if missing
- Verification: 4 login tests pass, 401 for invalid token
```

This plan provides everything Agent needs: file locations, specific implementation details, dependencies, patterns to follow, and verification criteria.

## Agent Mode Prompt

Your prompt to Agent Mode combines the plan with workflow instructions and working set context:

```markdown
Implement Phase 2 (Steps 2.1, 2.2, 2.3) from the attached 2fa-plan.md.

Use test-first workflow:
1. Write tests based on verification criteria
2. Run tests (red phase)
3. Implement to pass tests
4. Run tests (green phase)
5. Commit and move to next step

Working set attached:
- src/services/authService.ts (pattern reference)
- src/auth/authRoutes.ts (file to modify)
- src/models/User.ts (type definitions)
- package.json (dependencies)

Stop conditions:
- Any test fails after implementation
- TypeScript compilation errors

Target: All 17 tests passing (8 + 5 + 4).
```

This prompt establishes test-first workflow, provides context files, defines stop conditions, and sets success criteria.

> [!NOTE]
> Test-first workflow is critical for Agent Mode. Tests define success criteria that Agent can verify autonomously. Without tests, Agent has no objective measure of correctness.

## Autonomous Execution Timeline

> [!NOTE]
> This timeline illustrates a representative Agent Mode execution to help you understand the workflow. The exact timestamps, output format, and commentary style will vary based on your VS Code version, task complexity, and codebase. Use this as a mental model for what to expect, not as a specification of Agent output format.

Watch Agent work through all three steps. This timeline shows realistic execution with Agent commentary at each stage.

### [0:00] Agent Analyzes Plan

Agent starts by understanding the complete task:

```markdown
Agent: Analyzing Phase 2 implementation plan...
- 3 steps identified
- Test-first workflow specified
- 17 total tests expected
- Estimated completion: 20 minutes

Beginning Step 2.1: TwoFactorService creation...
```

Agent confirms understanding of scope, workflow, and success criteria before beginning execution.

### [0:30] Step 2.1 - Test Creation

Agent writes tests first based on verification criteria:

```markdown
Agent: Writing tests for TwoFactorService...

Creating src/services/__tests__/TwoFactorService.test.ts

Test cases (8 total):
1. generateSecret() returns valid secret and QR code
2. generateSecret() QR code includes user email
3. verifyToken() accepts valid token
4. verifyToken() rejects invalid token
5. verifyToken() handles time window (30 sec)
6. encryptSecret() produces different output each time (random IV)
7. decryptSecret() recovers original secret
8. encrypt/decrypt round-trip preserves data

File created: 95 lines

Running tests...
Tests: 8 failed ✓ (expected - red phase)
```

Agent creates comprehensive tests covering all requirements. Eight failing tests is expected and correct at this stage.

### [2:00] Step 2.1 - Implementation

Agent implements the service to pass tests:

```markdown
Agent: Implementing TwoFactorService...

Creating src/services/TwoFactorService.ts

Methods implemented:
- generateSecret(userEmail: string)
  * Uses speakeasy.generateSecret()
  * Generates QR code with qrcode library
  * Returns { secret, qrCode, backupCodes }
  
- verifyToken(secret: string, token: string)
  * Uses speakeasy.totp.verify()
  * 30-second time window
  * Returns boolean
  
- encryptSecret(secret: string)
  * AES-256-GCM encryption
  * Random IV per encryption
  * Returns iv:authTag:encrypted format
  
- decryptSecret(encrypted: string)
  * Parses iv:authTag:encrypted format
  * Verifies auth tag
  * Returns decrypted secret

File created: 124 lines

Dependencies added to imports:
- speakeasy (already in package.json)
- crypto (Node.js built-in)
- qrcode (added to package.json)

Running tests...
Tests: 8 passed ✓

Step 2.1 complete (8 min elapsed)
```

Agent implements all four methods following the plan specifications. Tests now pass. Agent moves to the next step.

### [8:00] Step 2.2 - Test Creation

Agent writes integration tests for the new endpoint:

```markdown
Agent: Writing tests for /api/auth/2fa/setup endpoint...

Creating src/auth/__tests__/2fa-setup.test.ts

Test cases (5 total):
1. Authenticated user receives 200 with qrCode and backupCodes
2. QR code is valid data URL format
3. Secret stored encrypted in database
4. Unauthenticated request returns 401
5. Idempotent (calling twice regenerates secret)

File created: 142 lines
Mocking: TwoFactorService.generateSecret()

Running tests...
Tests: 4 failed, 1 passed ✓ (expected - endpoint doesn't exist yet)
```

Agent creates integration tests covering success, authentication, data format, and idempotency. The unauthenticated test passes because middleware handles that before the endpoint code runs.

### [10:00] Step 2.2 - Implementation

Agent adds the endpoint to the existing routes file:

```markdown
Agent: Implementing POST /api/auth/2fa/setup endpoint...

Modifying src/auth/authRoutes.ts

Changes made:
- Added POST /api/auth/2fa/setup route after login (line 97)
- Applied authMiddleware (requires authenticated user)
- Integrated TwoFactorService.generateSecret()
- Encrypt secret before storing (TwoFactorService.encryptSecret())
- Save to req.user.twoFactorSecret
- Return { qrCode, backupCodes } (don't expose raw secret)
- Error handling for service failures (try/catch, 500 response)

Lines added: 23 (lines 97-120)

Running tests...
Tests: 5 passed ✓

Step 2.2 complete (15 min elapsed)
```

Agent integrates the new service into the existing route structure, applies proper authentication, and handles errors. All tests pass.

### [15:00] Step 2.3 - Test Creation

Agent adds tests for 2FA verification in the login flow:

```markdown
Agent: Writing tests for 2FA login verification...

Modifying src/auth/__tests__/login.test.ts

Test cases added (4 total):
1. Login succeeds with valid password + valid TOTP token
2. Login fails (401) with valid password + invalid TOTP token
3. Login fails (400) with valid password but missing TOTP token
4. Login succeeds normally for users without 2FA enabled

Lines added: 98 (new describe block)

Running tests...
Tests: 4 failed ✓ (expected - 2FA verification not implemented)
```

Agent adds a new test suite to an existing test file covering all login scenarios with and without 2FA.

### [17:00] Step 2.3 - Implementation

Agent modifies the login handler to verify TOTP tokens:

```markdown
Agent: Updating login handler with 2FA verification...

Modifying src/auth/authRoutes.ts (login handler, lines 78-95)

Changes made:
- After password verification (line 90), check user.twoFactorEnabled
- If 2FA enabled:
  * Check req.body.totpToken exists (400 if missing)
  * Decrypt secret: TwoFactorService.decryptSecret(user.twoFactorSecret)
  * Verify token: TwoFactorService.verifyToken(secret, totpToken)
  * Return 401 if invalid token
- If 2FA not enabled or token valid, continue to session creation

Lines modified: 12 (lines 90-102)

Running tests...
Tests: 4 passed ✓

Step 2.3 complete (20 min elapsed)
```

Agent carefully modifies the existing login handler, adding 2FA verification without breaking the existing flow.

### [20:00] Final Verification

Agent completes with a comprehensive summary:

```markdown
Agent: Phase 2 implementation complete.

Final test run (all test files)...
Tests: 17 passed, 0 failed ✓

Summary of changes:
Created:
- src/services/TwoFactorService.ts (124 lines)
- src/services/__tests__/TwoFactorService.test.ts (95 lines)
- src/auth/__tests__/2fa-setup.test.ts (142 lines)

Modified:
- src/auth/authRoutes.ts (+35 lines: setup endpoint + login changes)
- src/auth/__tests__/login.test.ts (+98 lines: 2FA login tests)
- package.json (+1 dependency: qrcode)

Total: 494 lines added/modified
Time: 20 minutes
Tests: 17/17 passing

Ready for review.
```

Agent provides a complete summary of what was created and modified. All success criteria met.

## What Agent Handled Autonomously

Agent made dozens of decisions during this 20-minute implementation without asking for guidance.

### Technical Decisions

Agent decided these implementation details autonomously:

* **File structure**: Created separate test file for TwoFactorService (followed `authService` pattern reference)
* **Error handling**: Used try/catch blocks with 500 status responses
* **Test organization**: Created separate test files for service and endpoint (better isolation)
* **Mock strategy**: Mocked `TwoFactorService` in integration tests (unit test the service separately)
* **Import organization**: Grouped imports by type (external, internal, types)
* **Variable naming**: Used descriptive names (`secret`, `encryptedSecret`, `totpToken`)
* **Code comments**: Added JSDoc documentation for public methods

### Patterns Followed

Agent followed existing codebase patterns automatically:

* **Route handler structure**: Matched existing patterns in `authRoutes.ts`
* **Service class design**: Followed `authService.ts` structure (static methods, clear responsibilities)
* **Test setup/teardown**: Used same patterns as existing test files
* **Error response format**: Matched existing JSON format (`{ error: message }`)
* **TypeScript types**: Leveraged existing type definitions from `User` model

Agent didn't ask about any of these decisions because the plan and working set provided clear patterns to follow.

### When This Approach Works

This autonomous workflow succeeded because:

* **Clear specifications**: Plan defined exactly what to implement
* **Test-first workflow**: Tests provided objective success criteria
* **Pattern references**: Working set showed Agent how to structure code
* **No architectural decisions**: Implementation followed established patterns
* **Well-scoped steps**: Each step had clear inputs, outputs, and verification

These conditions let Agent execute confidently without supervision checkpoints.

---

**Previous:** [Agent+Ask Pattern](./03-agent-ask-pattern.md) | **Next:** [Troubleshooting Agent Mode](./05-troubleshooting-agent-mode.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
