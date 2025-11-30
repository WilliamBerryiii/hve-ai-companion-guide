---
title: "Test-Driven Implementation Workflow"
description: Apply test-first methodology with AI-assisted implementation to translate verification criteria into executable tests
author: HVE Core Team
ms.date: 2025-11-26
chapter: 8
part: "II"
keywords:
  - test-driven
  - verification-criteria
  - test-first
  - implementation-workflow
  - ai-assisted-testing
---

## Test-Driven Implementation Workflow

You have your plan from Chapter 7. You know your implementation tools. Now it's time to write code.

But there's a critical step that transforms implementation from guesswork into verification: **writing tests first**.

This section teaches test-driven implementation using AI tools. You'll learn to translate plan verification criteria into executable tests, implement to pass those tests, and build confidence through incremental proof.

## Why Test-First?

Implementation plans from Chapter 7 include verification criteria for each step. Test-driven implementation translates those criteria into executable tests before writing implementation code.

This isn't traditional Test-Driven Development (TDD). It's a practical, AI-assisted approach that leverages verification criteria you already have.

### Benefits of Test-First Workflow

### Verification built-in

* A passing test equals a complete step
* No ambiguity about success
* Verification criteria become assertions

### Prevents scope creep

* Implement only what's tested
* Clear boundaries for each step
* Focused, incremental progress

### Confidence in changes

* Tests catch regressions immediately
* Safe to refactor after implementation
* Proof that code works as specified

### Living documentation

* Tests show how code should work
* Examples of API usage
* Executable specification

### Refactoring safety

* Improve code without breaking functionality
* Tests provide safety net
* Optimization with confidence

> **TIP**: You don't need to write tests for everything. Focus on tests for business logic, API contracts, and anything with verification criteria in your plan.

## The Test-First Cycle

Here's the lightweight cycle for AI-assisted test-driven implementation:

1. **Read plan step** and verification criteria
2. **Write test** based on criteria (using Inline Chat or /new command)
3. **Run test** (should fail, indicating red phase)
4. **Implement code** to pass test (using Inline Chat, /new command, or Inline Suggestions)
5. **Run test again** (should pass, indicating green phase)
6. **Refactor if needed** (tests still pass)
7. **Move to next step**

This cycle provides structure without ceremony. Each step has clear entry and exit criteria.

## Translating Plan Criteria to Tests

Your implementation plan provides the blueprint. Verification criteria map directly to test assertions.

### Plan Step Format

Here's a typical plan step from Chapter 7:

```markdown
Step 2.1: Create /api/auth/2fa/setup endpoint
- Implementation: Express route handler, generate secret, return QR code
- Dependencies: twoFactorService.generateSecret()
- Verification: POST request returns 200, response includes qrCode and secret
```

The verification line tells you exactly what to test.

### Test Conversion

Transform that verification into executable code:

```typescript
describe('POST /api/auth/2fa/setup', () => {
  it('should return 200 with QR code and secret', async () => {
    // Arrange - setup test conditions
    const authToken = await getValidAuthToken();
    
    // Act - execute the operation
    const response = await request(app)
      .post('/api/auth/2fa/setup')
      .set('Authorization', `Bearer ${authToken}`)
      .expect(200);
    
    // Assert - verify results match criteria
    expect(response.body).toHaveProperty('qrCode');
    expect(response.body.qrCode).toMatch(/^data:image\/png;base64,/);
    expect(response.body).toHaveProperty('secret');
    expect(typeof response.body.secret).toBe('string');
  });
});
```

Notice how verification criteria became assertions. "Returns 200" became `.expect(200)`. "Response includes qrCode" became `.toHaveProperty('qrCode')`.

### Criteria to Assertion Mapping

Common patterns for translating verification criteria:

| Verification Criteria            | Test Assertion                                   |
|----------------------------------|--------------------------------------------------|
| "Returns 200 status"             | `.expect(200)`                                   |
| "Response includes qrCode field" | `expect(response.body).toHaveProperty('qrCode')` |
| "QR code is valid data URL"      | `expect(qrCode).toMatch(/^data:image/)`          |
| "Secret stored in database"      | `expect(user.twoFactorSecret).toBeDefined()`     |
| "Throws error if unauthorized"   | `expect(() => ...).toThrow(AuthError)`           |
| "Returns array with 3 items"     | `expect(result).toHaveLength(3)`                 |
| "Calls service method"           | `expect(mockService.method).toHaveBeenCalled()`  |

Most verification criteria map to one or two assertions. Complex criteria might need three to five assertions.

## Complete Test-First Workflow Example

Let's walk through one complete cycle. This demonstrates every step from plan to passing test.

### Step 1: Read the Plan

```markdown
Step 2.3: Update login endpoint to verify 2FA token
- Location: src/auth/authRoutes.ts, login handler (lines 78-95)
- Implementation: After password verification, check if user.twoFactorEnabled
  - If true, require totpToken in request body
  - Verify using twoFactorService.verifyToken()
  - Return 401 if invalid token
- Verification: 
  - Login succeeds with valid password + valid TOTP token
  - Login fails (401) with valid password + invalid TOTP token
  - Login fails (400) with valid password but missing TOTP token
```

Three verification criteria means three test cases minimum.

### Step 2: Write Tests (Using /new Command)

Prompt for /new command:

```text
Create src/auth/__tests__/2fa-login.test.ts

Test suite for 2FA login verification.

Test cases:
1. Login succeeds with valid password and valid TOTP token
2. Login fails (401) with valid password and invalid TOTP token  
3. Login fails (400) with valid password but missing TOTP token
4. Login succeeds normally for users without 2FA enabled

Use supertest for API testing, follow patterns from auth.test.ts.
Mock twoFactorService.verifyToken() for predictable tokens.
```

Generated test file (reviewed and accepted):

```typescript
import request from 'supertest';
import app from '../../app';
import { User } from '../../models/User';
import twoFactorService from '../../services/twoFactorService';

jest.mock('../../services/twoFactorService');

describe('2FA Login', () => {
  let testUser: any;

  beforeEach(async () => {
    // Create test user with 2FA enabled
    testUser = await User.create({
      email: 'test@example.com',
      password: 'validpassword123',
      twoFactorEnabled: true,
      twoFactorSecret: 'TESTSECRET'
    });
  });

  afterEach(async () => {
    await User.deleteMany({});
    jest.clearAllMocks();
  });

  it('should succeed with valid password and valid TOTP token', async () => {
    // Mock verifyToken to return true
    (twoFactorService.verifyToken as jest.Mock).mockReturnValue(true);

    const response = await request(app)
      .post('/api/auth/login')
      .send({
        email: 'test@example.com',
        password: 'validpassword123',
        totpToken: '123456'
      })
      .expect(200);

    expect(response.body).toHaveProperty('token');
    expect(twoFactorService.verifyToken).toHaveBeenCalledWith(
      'TESTSECRET',
      '123456'
    );
  });

  it('should fail (401) with valid password but invalid TOTP token', async () => {
    // Mock verifyToken to return false
    (twoFactorService.verifyToken as jest.Mock).mockReturnValue(false);

    const response = await request(app)
      .post('/api/auth/login')
      .send({
        email: 'test@example.com',
        password: 'validpassword123',
        totpToken: 'invalid'
      })
      .expect(401);

    expect(response.body.error).toBe('Invalid authentication code');
  });

  it('should fail (400) with valid password but missing TOTP token', async () => {
    const response = await request(app)
      .post('/api/auth/login')
      .send({
        email: 'test@example.com',
        password: 'validpassword123'
        // totpToken missing
      })
      .expect(400);

    expect(response.body.error).toBe('TOTP token required for 2FA');
  });

  it('should succeed normally for users without 2FA', async () => {
    // Create user without 2FA
    const regularUser = await User.create({
      email: 'regular@example.com',
      password: 'validpassword123',
      twoFactorEnabled: false
    });

    const response = await request(app)
      .post('/api/auth/login')
      .send({
        email: 'regular@example.com',
        password: 'validpassword123'
      })
      .expect(200);

    expect(response.body).toHaveProperty('token');
    expect(twoFactorService.verifyToken).not.toHaveBeenCalled();
  });
});
```

Review checklist before accepting:

* ✅ All verification criteria have corresponding tests
* ✅ Follows existing test patterns from auth.test.ts
* ✅ Proper mocking of service dependency
* ✅ Setup and teardown handle test data correctly

### Step 3: Run Tests (Red Phase)

```bash
npm test src/auth/__tests__/2fa-login.test.ts
```

Output:

```text
FAIL src/auth/__tests__/2fa-login.test.ts
  2FA Login
    ✕ should succeed with valid password and valid TOTP token (45ms)
    ✕ should fail (401) with valid password but invalid TOTP token (32ms)
    ✕ should fail (400) with valid password but missing TOTP token (28ms)
    ✓ should succeed normally for users without 2FA (52ms)

Tests: 3 failed, 1 passed, 4 total
Time: 2.143s
```

Perfect! Tests fail because 2FA verification isn't implemented yet. The fourth test passes because existing login flow works for users without 2FA.

This proves tests are valid and ready to guide implementation.

### Step 4: Implement (Using Inline Chat)

Inline Chat (`Ctrl+I`) prompt:

```text
In the login handler (src/auth/authRoutes.ts, lines 78-95), add 2FA verification:

After password verification succeeds (line 90), add:

1. Check if user.twoFactorEnabled is true
2. If true:
   a. Check if req.body.totpToken exists
   b. If missing, return 400: "TOTP token required for 2FA"
   c. Verify token using twoFactorService.verifyToken(user.twoFactorSecret, totpToken)
   d. If invalid, return 401: "Invalid authentication code"
3. Continue to session creation (line 93)

Keep all existing error handling.
```

Generated changes (diff view):

```diff
  // Verify password
  const isValidPassword = await bcrypt.compare(password, user.password);
  if (!isValidPassword) {
    return res.status(401).json({ error: 'Invalid credentials' });
  }
  
+ // Verify 2FA if enabled
+ if (user.twoFactorEnabled) {
+   const { totpToken } = req.body;
+   
+   if (!totpToken) {
+     return res.status(400).json({ error: 'TOTP token required for 2FA' });
+   }
+   
+   const isValidToken = twoFactorService.verifyToken(
+     user.twoFactorSecret,
+     totpToken
+   );
+   
+   if (!isValidToken) {
+     return res.status(401).json({ error: 'Invalid authentication code' });
+   }
+ }
+
  // Create session
  const token = jwt.sign({ userId: user._id }, JWT_SECRET);
  res.json({ token });
```

Review diff:

* ✅ Placement correct (after password check, before session creation)
* ✅ All error cases handled (missing token, invalid token)
* ✅ Error messages match test expectations
* ✅ Doesn't affect users without 2FA

Accept changes.

### Step 5: Run Tests (Green Phase)

```bash
npm test src/auth/__tests__/2fa-login.test.ts
```

Output:

```text
PASS src/auth/__tests__/2fa-login.test.ts
  2FA Login
    ✓ should succeed with valid password and valid TOTP token (48ms)
    ✓ should fail (401) with valid password and invalid TOTP token (35ms)
    ✓ should fail (400) with valid password but missing TOTP token (30ms)
    ✓ should succeed normally for users without 2FA (55ms)

Tests: 4 passed, 4 total
Time: 3.256s
```

All tests pass! Implementation complete and verified.

### Step 6: Refactor (Optional)

If code works but could be cleaner, refactor now with tests as safety net:

```text
Extract 2FA verification into separate function verifyTwoFactor(user, token)
in same file. Keep tests passing.
```

Run tests after refactoring. Still pass. Refactoring was safe.

### Step 7: Commit and Move to Next Step

```bash
git add src/auth/authRoutes.ts src/auth/__tests__/2fa-login.test.ts
git commit -m "feat: add 2FA verification to login endpoint

- Verify TOTP token for users with 2FA enabled
- Return 400 if token missing, 401 if invalid
- Tests verify all scenarios
- Closes #issue-number"
```

Step complete. Move to next plan step and repeat cycle.

## Using AI Tools for Test Creation

Tests are code. Use the same AI tools for test creation:

### /new Command for test files

* New test suites from scratch
* Following patterns from existing tests
* Complete test file generation

### Inline Chat for adding tests

* Adding test cases to existing suite
* Updating setup or teardown logic
* Modifying existing assertions

### Inline Suggestions for test patterns

* Once pattern established, Copilot suggests similar tests
* Arrange-Act-Assert structure repeats naturally
* Assertion variations follow first example

### Example: Inline Suggestions for Repetitive Tests

```typescript
// Write first test manually to establish pattern:
it('should validate email format', () => {
  const result = validateEmail('invalid-email');
  expect(result).toBe('Invalid email format');
});

// Start next test, Copilot suggests pattern:
it('should validate email length', () => {
  // Copilot suggests following established structure:
  const result = validateEmail('a@b.c'); // too short
  expect(result).toBe('Email too short');
});

// And continues:
it('should accept valid email', () => {
  // Copilot maintains pattern:
  const result = validateEmail('valid@example.com');
  expect(result).toBeNull();
});
```

Pattern establishment is powerful for tests. Write first test carefully. Subsequent tests follow automatically.

## Test-First Discipline

When should you write tests first? Here's the decision framework:

### Always Write Tests First

* ✅ Plan includes verification criteria (always in good plans)
* ✅ Step modifies business logic
* ✅ Step adds new API endpoint
* ✅ Step involves data validation
* ✅ Step has edge cases to verify

### Tests Can Come After (Rarely)

* UI styling changes (visual verification more valuable)
* Documentation updates (no executable behavior)
* Configuration file changes (if non-critical)
* Exploratory coding (spike solutions for research)

**Default rule:** Test first, implement second. Exceptions are rare.

## Common Test-First Challenges

### Challenge 1: "I Don't Know How to Test This Yet"

**Solution:** Write test for desired behavior, even if implementation is unclear.

```typescript
it('should generate valid QR code', async () => {
  const result = await twoFactorService.generateSecret();
  
  // What you know it should do:
  expect(result.qrCode).toMatch(/^data:image\/png;base64,/);
  expect(result.secret).toHaveLength(32);
  
  // Implementation details will emerge during coding
});
```

The test clarifies what "valid" means. Implementation approach will become clear when you start coding.

### Challenge 2: "Test Setup Is Complex"

**Solution:** Use the /new command to create test helpers.

```text
Prompt: Create src/test/helpers/authHelpers.ts with:
- createTestUser(overrides): creates user for testing
- getValidAuthToken(userId): generates valid JWT
- mockAuthMiddleware(): mocks authentication

Follow patterns from existing test helpers.
```

Complex setup once, reuse everywhere. Tests become simpler.

### Challenge 3: "Tests Take Too Long to Write"

**Solution:** Use AI tools to accelerate test creation.

* **/new command** for test scaffolding
* **Inline Suggestions** for repetitive assertions (pattern-based)
* **Test templates** for common scenarios

AI-assisted test writing often enables more tests with better coverage.

> **IMPORTANT**: Test-first workflow with AI tools can help maintain quality while keeping development efficient. The upfront investment in tests pays off in reduced debugging time.

---

## Exercise 6.1: Implement Password Validation

### Exercise Overview

Apply test-first workflow to implement password strength validation using Inline Chat and Inline Suggestions.

**Scenario:** Your application needs password validation before user registration. Requirements include minimum length, character diversity, and common password blocking.

### Starting Materials

Plan step provided:

```markdown
Step 1.5: Add password validation to userValidator.ts
- Location: src/validators/userValidator.ts (existing file)
- Implementation:
  - Minimum 8 characters
  - Must contain: uppercase, lowercase, number, special character
  - Block common passwords (use commonPasswords list)
  - Return error array with specific messages
- Pattern: Follow existing validation structure in file
- Verification:
  - Weak passwords rejected with specific error
  - Strong passwords accepted (return empty array)
  - Common passwords blocked
```

Existing file structure (userValidator.ts):

```typescript
import validator from 'validator';

export function validateUsername(username: string): string[] {
  const errors: string[] = [];
  
  if (!username) {
    errors.push('Username is required');
  } else if (username.length < 3) {
    errors.push('Username must be at least 3 characters');
  }
  
  return errors;
}

export function validateEmail(email: string): string[] {
  const errors: string[] = [];
  
  if (!email) {
    errors.push('Email is required');
  } else if (!validator.isEmail(email)) {
    errors.push('Invalid email format');
  }
  
  return errors;
}

// TODO: Add validatePassword function here
```

### Your Tasks

1. **Write tests first**
   * Create `src/validators/__tests__/password-validation.test.ts`
   * Use the /new command to generate test file
   * Test cases: weak password, strong password, common password, missing requirements

2. **Run tests** (red phase) - Verify they fail

3. **Implement validation**
   * Use Inline Chat to add `validatePassword` function
   * Follow existing validator pattern
   * Use Inline Suggestions for regex patterns and checks

4. **Run tests** (green phase) - Verify they pass

### Success Criteria

✅ Tests written before implementation  
✅ All 4+ test cases passing  
✅ Function follows existing validator pattern  
✅ Error messages specific and helpful  
✅ Common passwords blocked  
✅ Used appropriate tools for each task

### Hints

* Use /new command prompt: "Create test file following validator.test.ts pattern"
* Common passwords list: `['password', '12345678', 'qwerty', 'admin', 'letmein']`
* Regex for checks: `/[A-Z]/`, `/[a-z]/`, `/[0-9]/`, `/[^A-Za-z0-9]/`
* Pattern from existing validators: return string array, specific messages

---

**Previous:** [Choosing the Right Tool](./05-choosing-right-mode-decision-framework.md)  
**Next:** [Complete Implementation Example](./07-complete-implementation-example.md)  
**Up:** [Chapter 8: Implementation Tools](./README.md)

---

*This guide was created using GitHub Copilot and human expertise. Last updated: November 2025.*
