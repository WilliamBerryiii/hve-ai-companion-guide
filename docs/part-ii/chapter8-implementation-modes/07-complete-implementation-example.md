---
title: "Complete Implementation Example"
description: Walk through a realistic end-to-end implementation scenario using all three modes with test-first workflow
author: HVE Core Team
ms.date: 2025-11-26
chapter: 8
part: "II"
keywords:
  - implementation-example
  - 2fa-endpoint
  - mode-selection
  - working-set
  - end-to-end
---

## Complete Implementation Example

You've learned the individual modes. You've practiced test-first workflow. Now let's put everything together in a realistic implementation scenario.

This section walks through implementing one complete feature from start to finish. You'll see mode selection decisions, test-first cycles, working set management, and review processes in action.

## The Scenario: 2FA Setup Endpoint

You're implementing Phase 2, Step 1 from Chapter 7's 2FA implementation plan. Your task: create an API endpoint that allows authenticated users to enable two-factor authentication.

### Starting Context

Plan step from Chapter 7:

```markdown
Step 2.1: Create /api/auth/2fa/setup endpoint
- Location: src/auth/authRoutes.ts (existing file, ~120 lines)
- Implementation:
  - POST /api/auth/2fa/setup (authenticated users only)
  - Generate secret using twoFactorService.generateSecret()
  - Store encrypted secret in user.twoFactorSecret
  - Return QR code data URL and backup codes
- Dependencies:
  - twoFactorService.generateSecret() (Phase 1, complete)
  - twoFactorService.encryptSecret() (need to create)
  - User model with twoFactorSecret field (Phase 1, complete)
- Verification:
  - POST returns 200 with qrCode and backupCodes
  - QR code is valid data URL format
  - Secret stored encrypted in database
  - Requires authentication (401 if unauthenticated)
  - Idempotent (calling twice regenerates secret)
```

Estimated time: approximately 25 minutes for experienced developers (versus 45-60 minutes manual)

### Working Set Setup

Before starting, establish your working set:

**Open these files:**

* `src/auth/authRoutes.ts` (modification target)
* `src/services/twoFactorService.ts` (dependency and modification target)
* `src/models/User.ts` (reference for user model)
* `src/auth/__tests__/authRoutes.test.ts` (test pattern reference)

**Why these files:**

* authRoutes.ts: Where you'll add the endpoint
* twoFactorService.ts: Where you'll add encryption methods
* User.ts: Verify twoFactorSecret field exists
* authRoutes.test.ts: Pattern for new test file

Four files. Focused context. Ready for implementation.

## Step 1: Write Tests First Using Insert Mode (8 minutes)

Start with verification criteria. Five criteria mean five test cases minimum.

### Insert Mode Prompt

```markdown
Create src/auth/__tests__/2fa-setup.test.ts

Test suite for 2FA setup endpoint (POST /api/auth/2fa/setup).

Verification criteria to test:
1. Authenticated user receives 200 with qrCode and backupCodes
2. QR code is valid data URL (data:image/png;base64,...)
3. Secret stored encrypted in database
4. Unauthenticated request returns 401
5. Calling endpoint twice regenerates secret (idempotent)

Use supertest for HTTP testing. Follow patterns from authRoutes.test.ts.
Mock twoFactorService.generateSecret() to return predictable data.
Include proper setup and teardown for test database.
```

### Generated Test File

Insert Mode generates complete test suite. Here's what to review:

```typescript
import request from 'supertest';
import app from '../../app';
import { User } from '../../models/User';
import twoFactorService from '../../services/twoFactorService';

jest.mock('../../services/twoFactorService');

describe('POST /api/auth/2fa/setup', () => {
  let authToken: string;
  let userId: string;

  beforeEach(async () => {
    // Create authenticated user
    const user = await User.create({
      email: 'test@example.com',
      password: 'password123'
    });
    userId = user._id.toString();
    
    // Generate auth token
    authToken = jwt.sign({ userId }, process.env.JWT_SECRET);

    // Mock generateSecret
    (twoFactorService.generateSecret as jest.Mock).mockResolvedValue({
      secret: 'JBSWY3DPEHPK3PXP',
      qrCode: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAA...',
      backupCodes: ['12345678', '87654321']
    });
  });

  afterEach(async () => {
    await User.deleteMany({});
    jest.clearAllMocks();
  });

  it('should return 200 with QR code and backup codes for authenticated user', async () => {
    const response = await request(app)
      .post('/api/auth/2fa/setup')
      .set('Authorization', `Bearer ${authToken}`)
      .expect(200);

    expect(response.body).toHaveProperty('qrCode');
    expect(response.body).toHaveProperty('backupCodes');
    expect(Array.isArray(response.body.backupCodes)).toBe(true);
  });

  it('should return valid QR code data URL', async () => {
    const response = await request(app)
      .post('/api/auth/2fa/setup')
      .set('Authorization', `Bearer ${authToken}`)
      .expect(200);

    expect(response.body.qrCode).toMatch(/^data:image\/png;base64,/);
  });

  it('should store encrypted secret in database', async () => {
    await request(app)
      .post('/api/auth/2fa/setup')
      .set('Authorization', `Bearer ${authToken}`)
      .expect(200);

    const user = await User.findById(userId);
    expect(user.twoFactorSecret).toBeDefined();
    expect(user.twoFactorSecret).not.toBe('JBSWY3DPEHPK3PXP'); // Should be encrypted
  });

  it('should return 401 for unauthenticated request', async () => {
    await request(app)
      .post('/api/auth/2fa/setup')
      .expect(401);
  });

  it('should regenerate secret when called twice (idempotent)', async () => {
    // First call
    await request(app)
      .post('/api/auth/2fa/setup')
      .set('Authorization', `Bearer ${authToken}`)
      .expect(200);

    const firstSecret = (await User.findById(userId)).twoFactorSecret;

    // Second call with different mock
    (twoFactorService.generateSecret as jest.Mock).mockResolvedValue({
      secret: 'NEWSECRETVALUE',
      qrCode: 'data:image/png;base64,NEW...',
      backupCodes: ['11111111', '22222222']
    });

    await request(app)
      .post('/api/auth/2fa/setup')
      .set('Authorization', `Bearer ${authToken}`)
      .expect(200);

    const secondSecret = (await User.findById(userId)).twoFactorSecret;
    expect(secondSecret).not.toBe(firstSecret);
  });
});
```

### Review Checklist

Before accepting:

* ✅ All 5 verification criteria have corresponding tests
* ✅ Follows patterns from authRoutes.test.ts
* ✅ Proper mocking of service dependency
* ✅ Setup and teardown handle test data
* ✅ Tests are independent (no shared state)

Everything checks out. Accept the file.

## Step 2: Run Tests for Red Phase (1 minute)

Verify tests fail for the right reasons:

```bash
npm test src/auth/__tests__/2fa-setup.test.ts
```

Output:

```text
FAIL src/auth/__tests__/2fa-setup.test.ts
  POST /api/auth/2fa/setup
    ✕ should return 200 with QR code and backup codes (404: Not Found)
    ✕ should return valid QR code data URL (404: Not Found)
    ✕ should store encrypted secret in database (404: Not Found)
    ✓ should return 401 for unauthenticated request (12ms)
    ✕ should regenerate secret when called twice (404: Not Found)

Tests: 4 failed, 1 passed, 5 total
Time: 2.143s
```

Perfect red phase. Endpoint doesn't exist yet (404 errors). Unauthenticated test passes because auth middleware already works.

Tests are valid. Ready for implementation.

## Step 3: Implement Endpoint Using Edit Mode (10 minutes)

Now implement the endpoint. You're modifying an existing file, so Edit Mode is the right choice.

### Edit Mode Prompt

```markdown
In src/auth/authRoutes.ts, add new POST /api/auth/2fa/setup endpoint after the existing /login route.

Implementation requirements:
1. Protected route (use existing authMiddleware)
2. Call twoFactorService.generateSecret() to get secret, qrCode, backupCodes
3. Encrypt secret using twoFactorService.encryptSecret(secret)
4. Save encrypted secret to req.user.twoFactorSecret
5. Return { qrCode, backupCodes } (don't return raw secret)

Error handling:
- Return 500 if generateSecret fails
- Return 500 if database save fails

Follow patterns from existing routes in this file.
```

### Generated Changes (Diff View)

Edit Mode shows diff:

```typescript
  // Existing /login route
  router.post('/login', async (req, res) => {
    // ... existing login code ...
  });

+ // 2FA Setup endpoint
+ router.post('/2fa/setup', authMiddleware, async (req, res) => {
+   try {
+     // Generate new secret and QR code
+     const { secret, qrCode, backupCodes } = 
+       await twoFactorService.generateSecret(req.user.email);
+     
+     // Encrypt secret before storing
+     const encryptedSecret = twoFactorService.encryptSecret(secret);
+     
+     // Save encrypted secret to user
+     req.user.twoFactorSecret = encryptedSecret;
+     await req.user.save();
+     
+     // Return QR code and backup codes (not raw secret)
+     res.json({
+       qrCode,
+       backupCodes
+     });
+   } catch (error) {
+     console.error('2FA setup error:', error);
+     res.status(500).json({ error: 'Failed to set up 2FA' });
+   }
+ });
+
  // Existing routes continue...
  router.post('/logout', async (req, res) => {
```

### Diff Review

Walk through the review checklist:

* ✅ Follows route handler pattern from file
* ✅ Uses authMiddleware correctly
* ✅ Encrypts secret before storing
* ✅ Doesn't return raw secret to client
* ✅ Error handling included
* ✅ Returns only qrCode and backupCodes
* ⚠️ **Issue spotted:** `twoFactorService.encryptSecret()` doesn't exist yet

Decision: Accept this diff. We'll create encryptSecret next. This is a dependency we expected from the plan.

## Step 4: Add Encryption Helper Using Inline Copilot (3 minutes)

Open `src/services/twoFactorService.ts`. You need to add encryption methods.

### Using Inline Copilot for Utility Functions

Add descriptive comment to trigger suggestion:

```typescript
// Existing methods...
export function generateSecret(email: string) {
  // ... existing implementation ...
}

// Encrypt secret for storage using AES-256-GCM
// Takes plain secret string, returns encrypted string
export function encryptSecret(secret: string): string {
```

Inline Copilot suggests complete implementation:

```typescript
export function encryptSecret(secret: string): string {
  const algorithm = 'aes-256-gcm';
  const key = Buffer.from(process.env.ENCRYPTION_KEY, 'hex');
  const iv = crypto.randomBytes(16);
  
  const cipher = crypto.createCipheriv(algorithm, key, iv);
  let encrypted = cipher.update(secret, 'utf8', 'hex');
  encrypted += cipher.final('hex');
  
  const authTag = cipher.getAuthTag().toString('hex');
  
  // Return format: iv:authTag:encrypted
  return `${iv.toString('hex')}:${authTag}:${encrypted}`;
}
```

Quick review:

* ✅ Uses strong encryption (AES-256-GCM)
* ✅ Generates random IV (initialization vector)
* ✅ Includes auth tag for integrity verification
* ✅ Returns combined format for storage
* ⚠️ **Need:** Corresponding decryptSecret function

Accept suggestion. Now add decrypt function.

### Pattern Continues

Add another comment:

```typescript
// Decrypt secret from storage
// Takes encrypted string (iv:authTag:encrypted), returns plain secret
export function decryptSecret(encrypted: string): string {
```

Inline Copilot suggests matching implementation:

```typescript
export function decryptSecret(encrypted: string): string {
  const [ivHex, authTagHex, encryptedHex] = encrypted.split(':');
  
  const algorithm = 'aes-256-gcm';
  const key = Buffer.from(process.env.ENCRYPTION_KEY, 'hex');
  const iv = Buffer.from(ivHex, 'hex');
  const authTag = Buffer.from(authTagHex, 'hex');
  
  const decipher = crypto.createDecipheriv(algorithm, key, iv);
  decipher.setAuthTag(authTag);
  
  let decrypted = decipher.update(encryptedHex, 'hex', 'utf8');
  decrypted += decipher.final('utf8');
  
  return decrypted;
}
```

Review:

* ✅ Matches encryption format
* ✅ Proper decryption with auth tag verification
* ✅ Error handling through cipher.final() (throws on auth failure)

Accept. Encryption layer complete.

> **NOTE**: If Inline Copilot struggled here, you'd use Insert Mode instead: "Add encryptSecret and decryptSecret functions using Node crypto with AES-256-GCM."

## Step 5: Run Tests for Green Phase (1 minute)

Verify implementation works:

```bash
npm test src/auth/__tests__/2fa-setup.test.ts
```

Output:

```text
PASS src/auth/__tests__/2fa-setup.test.ts
  POST /api/auth/2fa/setup
    ✓ should return 200 with QR code and backup codes (156ms)
    ✓ should return valid QR code data URL (142ms)
    ✓ should store encrypted secret in database (168ms)
    ✓ should return 401 for unauthenticated request (15ms)
    ✓ should regenerate secret when called twice (285ms)

Tests: 5 passed, 5 total
Time: 3.256s
```

Perfect green phase! All tests pass. Implementation complete and verified.

## Step 6: Manual Verification, Optional (2 minutes)

Automated tests prove correctness. Manual testing proves usability.

Start development server:

```bash
npm run dev
```

Test with curl:

```bash
# Authenticate first
TOKEN=$(curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}' \
  | jq -r '.token')

# Setup 2FA
curl -X POST http://localhost:3000/api/auth/2fa/setup \
  -H "Authorization: Bearer $TOKEN" \
  | jq
```

Expected response:

```json
{
  "qrCode": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAA...",
  "backupCodes": [
    "12345678",
    "87654321",
    "11223344",
    "44332211",
    "55667788"
  ]
}
```

Works perfectly. QR code can be scanned by authenticator apps. Backup codes provided for recovery.

## Step 7: Commit Changes (1 minute)

Create atomic commit with clear message:

```bash
# Review changes
git status
# Modified: src/auth/authRoutes.ts
# Modified: src/services/twoFactorService.ts
# New file: src/auth/__tests__/2fa-setup.test.ts

# Stage all related changes
git add src/auth/authRoutes.ts \
        src/services/twoFactorService.ts \
        src/auth/__tests__/2fa-setup.test.ts

# Commit with descriptive message
git commit -m "feat: add 2FA setup endpoint with encryption

- POST /api/auth/2fa/setup endpoint (authenticated users only)
- Generate and encrypt TOTP secret before storage
- Return QR code and backup codes to client
- Add encryptSecret/decryptSecret to twoFactorService
- Comprehensive test suite (5 tests) verifies all requirements
- Tests confirm encryption, idempotency, and auth requirements

Closes #123"
```

Step complete. Move to next plan step.

## Implementation Time Breakdown

Total time for complete feature: **25 minutes**

| Step | Activity                       | Time   | Tools Used     |
|------|--------------------------------|--------|----------------|
| 1    | Write comprehensive test suite | 8 min  | Insert Mode    |
| 2    | Run tests (red phase)          | 1 min  | Terminal       |
| 3    | Implement API endpoint         | 10 min | Edit Mode      |
| 4    | Add encryption helpers         | 3 min  | Inline Copilot |
| 5    | Run tests (green phase)        | 1 min  | Terminal       |
| 6    | Manual verification            | 2 min  | curl, jq       |
| 7    | Commit with message            | 1 min  | git            |

### Comparison to Manual Implementation

**With AI modes:** 25 minutes  
**Manual estimation:** 45-60 minutes  
**Time saved:** Individual results vary based on experience and task complexity

### Why This Was Faster

#### Insert Mode accelerated test creation

* 8 minutes versus 20 minutes manual
* Comprehensive test suite with proper patterns
* No time spent looking up testing APIs

#### Edit Mode accelerated endpoint implementation

* 10 minutes versus 20 minutes manual
* Correct pattern matching from existing routes
* Immediate diff review caught dependency issue

#### Inline Copilot accelerated utility functions

* 3 minutes versus 10-15 minutes
* No time researching Node crypto APIs
* Matching encrypt and decrypt implementations

#### Test-first workflow provided confidence

* No debugging phase needed
* Implementation verified immediately
* Clear definition of "done"

## Key Lessons from This Example

### Lesson 1: Tests Provide Clear Success Criteria

No ambiguity when all five tests pass. Each test maps directly to a verification criterion. Implementation is complete when tests are green.

Without tests, you'd manually verify each scenario. With tests, verification is automatic and repeatable.

### Lesson 2: Mode Selection Was Natural

Decisions flowed from the decision framework:

* New test file → Insert Mode
* Modify existing route file → Edit Mode
* Add utility functions → Inline Copilot (with fallback to Insert Mode if needed)

No second-guessing. Each choice was obvious from context.

### Lesson 3: Incremental Verification Built Confidence

**Red phase:** Confirmed tests are valid (failures for right reasons)  
**Green phase:** Confirmed implementation complete (all criteria met)  
**Manual testing:** Confirmed real-world usability

Each step provided confidence for the next step. No leap of faith required.

### Lesson 4: Working Set Management Mattered

Four files open. Each served a purpose:

* authRoutes.ts: modification target
* twoFactorService.ts: dependency and modification target
* User.ts: reference for model fields
* authRoutes.test.ts: pattern for test structure

Suggestions matched project patterns because relevant patterns were visible.

### Lesson 5: Review Caught Potential Issues

During Edit Mode diff review, you spotted missing `encryptSecret()`. Added before running tests. This saved a red-green-red-green cycle.

Active review prevents downstream debugging.

### Lesson 6: Pattern Is Replicable

This seven-step process works for any plan step:

1. Write tests from verification criteria
2. Run tests (red)
3. Implement with appropriate mode
4. Run tests (green)
5. Manual verification (optional)
6. Commit
7. Next step

Apply this pattern to every feature in your plan. Consistent quality at consistent speed.

---

## Exercise 7.1: Implement Complete Feature (45-60 min)

### Exercise Overview

Implement a complete two-factor authentication feature from Chapter 7's full plan. This exercises mode selection, test-first workflow, working set management, and multi-phase implementation.

**Scenario:** Your application needs full 2FA capability. Users enable 2FA, scan QR codes, and provide TOTP tokens during login.

### Implementation Plan (Abbreviated)

#### Phase 1: Data Layer (15 min)

* Create database migration for 2FA fields
* Update User model with new fields
* Add TypeScript type definitions

#### Phase 2: Business Logic (20 min)

* Create TwoFactorService class
* Add 2FA setup endpoint
* Update login endpoint to verify tokens

#### Phase 3: UI (Optional, 10 min)

* Create 2FA setup React component
* Add QR code display component

### Your Tasks

#### Phase 1 Implementation (15 min)

1. **Create migration tests** (Insert Mode)
   * Test file: `src/migrations/__tests__/add-2fa-fields.test.ts`
   * Verify fields created, proper types, default values

2. **Create migration** (Insert Mode)
   * File: `src/migrations/20240115_add_2fa_fields.ts`
   * Add: twoFactorSecret, twoFactorEnabled, twoFactorBackupCodes
   * Follow patterns from existing migrations

3. **Update User model** (Edit Mode)
   * File: `src/models/User.ts`
   * Add field definitions with proper types

4. **Add TypeScript types** (Inline Copilot)
   * File: `src/types/auth.ts`
   * Types for 2FA setup response, verification request

5. **Verify Phase 1 tests pass**

#### Phase 2 Implementation (20 min)

1. **Write service tests** (Insert Mode)
   * Test file: `src/services/__tests__/twoFactorService.test.ts`
   * Test: generateSecret, verifyToken, encryptSecret, decryptSecret

2. **Create TwoFactorService** (Insert Mode)
   * File: `src/services/twoFactorService.ts`
   * Follow patterns from existing service classes
   * Include all four methods

3. **Write endpoint tests** (Insert Mode)
   * You did this in Section 7 example
   * Apply same approach

4. **Add setup endpoint** (Edit Mode)
   * You did this in Section 7 example
   * Apply same implementation

5. **Update login logic** (Edit Mode)
   * Add 2FA token verification to login flow
   * Follow test-first workflow from Section 6

6. **Verify all Phase 2 tests pass**

#### Phase 3 Implementation - Optional (10 min)

1. **Create React component** (Insert Mode)
   * Component: `src/components/TwoFactorSetup.tsx`
   * Display QR code and backup codes
   * Enable/disable button

2. **Add QR display** (Edit or Inline)
   * Render QR code as image
   * Display backup codes list

### Success Criteria

You've succeeded when:

✅ All phases implemented following plan  
✅ Tests written before each implementation step  
✅ All tests passing (15+ tests total)  
✅ Migration applies successfully to database  
✅ Setup endpoint returns QR code  
✅ Login endpoint verifies TOTP token  
✅ Test-first workflow used consistently  
✅ Appropriate mode selected for each task  
✅ Working set managed effectively throughout

### Verification Strategy

After each phase:

1. Run phase-specific tests
2. Run full test suite (ensure no regressions)
3. Commit with descriptive message
4. Move to next phase

Final verification:

1. All tests pass (entire suite)
2. Manual test with real authenticator app (Google Authenticator, Authy, etc.)
3. Verify secret stored encrypted in database
4. Verify complete login flow with 2FA enabled

### Minimal Guidance Philosophy

This exercise tests your ability to:

* Translate plan steps to executable tests
* Select optimal modes for each task type
* Manage working set for optimal suggestions
* Verify incrementally with confidence
* Handle dependencies between steps

You should complete this with minimal external help. Reference previous sections when needed, but work independently.

---

**Previous:** [Test-Driven Implementation Workflow](./06-test-driven-implementation-workflow.md)  
**Next:** [Summary](./08-summary.md)  
**Up:** [Chapter 8: Implementation Modes](./README.md)

---

*This guide was created using GitHub Copilot and human expertise. Last updated: November 2025.*
