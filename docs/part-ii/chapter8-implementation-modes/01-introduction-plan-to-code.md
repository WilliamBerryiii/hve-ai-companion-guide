---
title: "Introduction: From Plan to Code"
description: Understand the transition from implementation plans to working code using three AI-assisted implementation modes
author: HVE Core Team
ms.date: 2025-11-26
chapter: 8
part: "II"
keywords:
  - implementation-modes
  - edit-mode
  - insert-mode
  - inline-copilot
  - code-generation
---

## Introduction: From Plan to Code

Welcome to the execution phase. You've researched your approach using Discovery modes and created detailed implementation plans with Task Planner. Now comes the moment where planning transforms into working code. This transition requires precision, verification, and control.

## The Implementation Phase

You've researched (Chapter 6) and planned (Chapter 7). Now comes execution: transforming implementation plans into working code. Implementation is where your careful preparation pays dividends. Each plan step becomes concrete code. Each verification criterion becomes a test to pass.

**What makes implementation different:**

* **Precision required**: Following plan specifications exactly prevents scope creep and ensures quality
* **Verification at each step**: Testing before moving to next step catches issues early
* **Controlled changes**: Reviewable, understandable modifications maintain code quality
* **Safety first**: Easy to undo if something goes wrong protects your working code

**Recall Chapter 4's manual implementation:**

```markdown
Step 3: Add validation logic
- Open src/validators/userValidator.ts
- Add email format check
- Add password strength check
- Test with sample inputs
```

You wrote this code yourself. **This chapter teaches you to delegate implementation to AI** while maintaining control and quality. The difference is profound: you become the architect and reviewer rather than the typist.

## Three Implementation Modes

GitHub Copilot in VS Code and JetBrains IDEs provides three modes for code generation, each optimized for different tasks. Understanding when to use each mode can significantly improve your efficiency and code quality.

| Mode               | Best For                 | Control Level           | Review Style         |
|--------------------|--------------------------|-------------------------|----------------------|
| **Edit Mode**      | Modifying existing files | High (explicit changes) | Before-after diff    |
| **Insert Mode**    | Creating new files       | Medium (template-based) | Full file review     |
| **Inline Copilot** | Line-level suggestions   | Low (autocomplete-like) | Accept/reject inline |

### Example: Implementing "Add 2FA Setup Endpoint"

Let's see how the same task looks across all three modes. This example uses a real implementation from Chapter 7's planning exercise.

**Using Edit Mode:**

```text
Prompt: "Add POST /api/auth/2fa/setup endpoint to src/auth/authRoutes.ts
following the pattern at lines 45-60. Use speakeasy.generateSecret() 
and return QR code data URL."

Result: Copilot shows exact changes to authRoutes.ts with before/after diff
You review, approve or refine, changes applied
```

Edit Mode can accelerate well-defined tasks compared to manual coding, as you guide changes rather than type them. Results vary based on task complexity and your familiarity with the codebase.

**Using Insert Mode:**

```text
Prompt: "Create new file src/services/twoFactorService.ts with functions:
- generateSecret(): returns speakeasy secret
- generateQRCode(secret): returns data URL
- verifyToken(secret, token): validates TOTP

Follow patterns from src/services/authService.ts"

Result: Copilot generates complete new file
You review entire file, approve or refine, file created
```

**Using Inline Copilot:**

```typescript
You type: "const secret = speakeasy."
Copilot suggests: "generateSecret({ length: 32, name: 'AppName' })"
You press Tab to accept, continue typing
```

Each mode serves a distinct purpose. Edit Mode gives you surgical precision. Insert Mode scaffolds entire structures. Inline Copilot accelerates the typing you'd do anyway.

## Why Multiple Modes Matter

Each mode optimizes for different tradeoffs. Choosing the right mode for each task makes the difference between smooth workflow and constant friction.

**Edit Mode strengths:**

* ✅ Precise control over changes
* ✅ Clear before/after diff for review
* ✅ Existing code context guides suggestions
* ✅ Easy to verify against plan specifications

**Edit Mode limitations:**

* ⚠️ Requires file already exists
* ⚠️ Slower for creating new structures
* ⚠️ More overhead for simple completions

**Insert Mode strengths:**

* ✅ Fast scaffolding of new files
* ✅ Template-based generation
* ✅ Good for standard patterns

**Insert Mode limitations:**

* ⚠️ Less precise than Edit Mode
* ⚠️ Requires more review (whole file)
* ⚠️ May miss project conventions

**Inline Copilot strengths:**

* ✅ Fastest for simple completions
* ✅ Seamless workflow integration
* ✅ Minimal cognitive overhead

**Inline Copilot limitations:**

* ⚠️ Limited context awareness
* ⚠️ Line-by-line focus (no structural changes)
* ⚠️ Easy to accept without reviewing

> [!TIP]
> Start with Edit Mode for important changes. You can always switch to Inline Copilot for the routine parts once the structure is correct.

## Implementation Strategy: Test-First Workflow

This chapter teaches **test-driven implementation** (TDD-lite). You'll write tests before implementation to ensure each step meets plan specifications. This approach provides built-in verification and prevents scope creep.

**The test-first cycle:**

1. **Write test for step** (based on plan verification criteria)
2. **Run test** (should fail - feature not implemented yet)
3. **Implement step** (using Edit/Insert/Inline modes)
4. **Run test again** (should pass - feature now works)
5. **Refactor if needed** (tests still pass)
6. **Move to next step**

**Why test-first?**

* **Verification built-in**: Test passing equals step complete, no ambiguity
* **Prevents scope creep**: Only implement what's tested, stay focused
* **Safety net for refactoring**: Tests catch regressions immediately
* **Matches plan structure**: Plan verification criteria become test cases naturally

### Example: Test-First Implementation of 2FA Setup

**From Chapter 7 Plan:**

```markdown
Step 2.1: Create /api/auth/2fa/setup endpoint
- Verification: POST request returns QR code data URL and secret stored
```

**Test First:**

```typescript
describe('POST /api/auth/2fa/setup', () => {
  it('should generate secret and return QR code', async () => {
    const response = await request(app)
      .post('/api/auth/2fa/setup')
      .set('Authorization', `Bearer ${validToken}`)
      .expect(200);
    
    expect(response.body.qrCode).toMatch(/^data:image\/png;base64,/);
    expect(response.body.secret).toBeDefined();
    
    // Verify secret stored in database
    const user = await User.findById(testUserId);
    expect(user.twoFactorSecret).toBeDefined();
  });
});
```

**Run Test:** ❌ Fails (endpoint doesn't exist yet)

**Implement using Edit Mode:**

```text
Prompt to Edit Mode: "Add POST /api/auth/2fa/setup endpoint to 
src/auth/authRoutes.ts. Generate secret using speakeasy, create QR code,
store secret in user.twoFactorSecret, return { qrCode, secret }."
```

**Run Test:** ✅ Passes (endpoint now works)

**Move to next step in plan.**

This cycle ensures every implementation step is verified. No guessing whether it works. The test tells you definitively.

## Scope of This Chapter

By the end of this chapter, you'll master:

1. **Edit Mode**: Precise modifications to existing files with diff review
2. **Insert Mode**: Creating new files with template-based generation
3. **Inline Copilot**: Accelerating line-level coding with suggestions
4. **Test-First Workflow**: Writing tests before implementation
5. **Mode Selection**: Choosing the optimal mode for each task
6. **Verification Strategy**: Confirming each step meets plan criteria

Each section builds your implementation toolkit. Section 2 starts with Edit Mode, the most controlled and reviewable approach. From there you'll expand to Insert Mode and Inline Copilot, then learn when to use each mode effectively.

---

**Previous:** [README](./README.md)  
**Next:** [Section 2: Edit Mode - Controlled File Modification](./02-edit-mode-controlled-modification.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
