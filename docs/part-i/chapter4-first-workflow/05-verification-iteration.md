---
title: "Verification and Iteration"
description: Apply multi-level verification strategy combining unit tests, integration tests, and manual end-to-end testing to ensure feature quality
author: HVE Core Team
ms.date: 2025-11-26
chapter: 4
part: "I"
keywords:
  - testing
  - verification
  - iteration
  - quality-assurance
---

## Verification and iteration

You've implemented the feature. Tests pass. Code looks good. But how do you **know** it actually works in the real world?

Verification happens at multiple levels: unit tests catch logic errors, integration tests verify components work together, and manual end-to-end testing catches issues that automated tests miss—UX problems, timing issues, environment configuration bugs.

This section walks through systematic verification across all three levels and teaches you how to iterate based on findings.

## Why verification matters

Copilot helps write code quickly. But speed without verification creates false confidence. You think you're done, but production breaks. Users report bugs. Your "finished" feature isn't finished.

The RPI framework includes verification as an explicit phase because it's where you discover:

* **Edge cases you missed:** Tests cover happy paths, but users find the unhappy ones
* **Environment differences:** Works on your machine, fails in staging
* **Integration gaps:** Individual pieces work, but the system doesn't
* **UX issues:** Technically correct but confusing or frustrating for users

Verification isn't busywork. It's the difference between "I wrote code" and "I delivered working functionality."

## Multi-level verification strategy

Effective verification uses three complementary levels, each catching different types of issues.

### Level 1: Unit tests (Already written during implementation)

* Test individual functions in isolation
* Fast, deterministic, catches logic errors
* Example: `isProfileComplete()` verifies field checks work correctly

### Level 2: Integration tests (Already written during implementation)

* Test components working together
* Example: Profile update route triggers completion check which sends email
* Catches issues at component boundaries

### Level 3: Manual end-to-end testing (Do now)

* Human verification in real environment
* Catches issues tests miss: UX problems, timing, environment configuration
* Most time-consuming but essential for production confidence

You've already handled Levels 1 and 2 during implementation (test-driven approach). Now focus on Level 3.

## Manual testing workflow

Follow this five-step process to verify your email notification feature works end-to-end.

### Step 1: Set up local test environment

```bash
# Start test email service (Mailhog catches emails locally)
docker compose up -d mailhog

# Start your application
npm run dev
```

### Step 2: Execute feature manually

Create a user with incomplete profile, then complete it:

```bash
# Create user (incomplete profile - missing bio and avatar)
curl -X POST http://localhost:3000/users \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "name": "Test User"}'

# Response: {"id": "123", ...}

# Complete the profile
curl -X PUT http://localhost:3000/users/123/profile \
  -H "Content-Type: application/json" \
  -d '{
    "bio": "Software developer",
    "avatar_url": "https://example.com/avatar.jpg"
  }'
```

### Step 3: Verify email sent

* Open Mailhog UI: `http://localhost:8025`
* Verify email received with subject "Welcome, Test User! Your profile is complete"
* Check email body contains personalization (user's name)
* Inspect email headers for sender information

### Step 4: Verify idempotency (no duplicate emails)

```bash
# Update profile again (already complete)
curl -X PUT http://localhost:3000/users/123/profile \
  -H "Content-Type: application/json" \
  -d '{"bio": "Senior Software Developer"}'
```

Check Mailhog: No new email should arrive. Verify profile update succeeded (200 response).

### Step 5: Test error handling

```bash
# Stop email service to simulate failure
docker compose stop mailhog

# Attempt profile completion for new user
curl -X PUT http://localhost:3000/users/124/profile \
  -H "Content-Type: application/json" \
  -d '{"bio": "Engineer", "avatar_url": "https://example.com/avatar.jpg"}'
```

Verify:

* Profile update succeeds (200 response) despite email failure
* Error logged to console with clear message
* Application doesn't crash

> [!IMPORTANT]
> Manual testing reveals issues automated tests miss. Don't skip this step because "tests pass." Production environments are messier than test environments.

## Iteration based on findings

Manual testing often reveals issues requiring iteration. Here's how to handle common findings.

### Finding 1: Email template looks broken in some email clients

Your email renders perfectly in Gmail but displays as plain text in Outlook.

Iteration steps:

1. Research email HTML best practices
   * Ask Mode query: "What HTML is safe for email clients?"
   * Discovery: Outlook uses Word rendering engine, requires table-based layout
2. Update email template in `emailService.js`
   * Change from modern CSS grid to table-based layout
   * Add inline styles (external stylesheets don't work in email)
3. Re-test in multiple email clients
   * Gmail, Outlook Web, Outlook Desktop, Apple Mail
   * Use Litmus or Email on Acid for broader testing

### Finding 2: Profile completion check has edge case with empty strings

User submits profile with whitespace-only values: `bio: "   "`. System treats this as "complete" and sends email.

Iteration steps:

1. Add test case for whitespace scenario
   * New test: Profile with whitespace-only fields should be incomplete
2. Update `isProfileComplete()` validation
   * Change: `this[field] !== ''` → `this[field].trim() !== ''`
3. Re-run all tests to ensure no regressions

### Finding 3: Email delays cause confusion

Email arrives 2-3 minutes after profile completion in staging environment. Users don't see immediate confirmation.

Iteration steps:

1. Research: Ask Mode query about email queue systems
2. Add temporary UI feedback: "Email sent to your inbox"
3. Document as known limitation if email infrastructure can't be changed
4. Consider adding email queue monitoring to catch delivery issues

Iteration is normal and healthy. Your first implementation is rarely perfect. The RPI framework's incremental validation helps you catch issues early and iterate quickly rather than discovering problems in production.

## Exercise 4.4: Verify your implementation (15-20 minutes)

**Goal:** Systematically verify your email notification feature works correctly across all three levels.

**Scenario:** You've implemented the feature from Exercise 4.3. Now verify it works end-to-end using the multi-level strategy.

**Your task:**

Work through the verification checklist below, checking each item as you verify it. Document any issues you find and iterate to fix them.

**Verification checklist:**

**Functional verification:**

* Email sent when profile becomes complete (manual test passed)
* Email not sent when already-complete profile updated (manual test passed)
* Email failure doesn't block profile update (manual test passed)
* All unit tests pass (`npm test`)
* All integration tests pass

**Code quality verification:**

* Linting passes with no errors (`npm run lint`)
* Type checking passes if using TypeScript (`npm run type-check`)
* Code follows codebase conventions (matches existing patterns)
* No magic numbers or hard-coded values (use config/constants)
* Error handling comprehensive (all failure paths handled)

**Documentation verification:**

* Function comments explain purpose and parameters
* Plan document updated with any deviations from original approach
* README updated if feature requires configuration changes

**If you find issues:**

1. Document the finding clearly (what broke, how you discovered it)
2. Determine iteration needed (research, code change, test addition)
3. Apply the fix
4. Re-verify the specific item and related items

**Success criteria:**

* All checklist items verified and checked
* Any issues found have been fixed and re-verified
* You have confidence this feature works in production

**Reflection questions:**

1. Which level of verification (unit, integration, manual) caught the most issues?
2. Did you find issues that tests would never catch? What types?
3. How long did verification take compared to implementation time?
4. What would happen if you skipped manual testing and deployed based on passing tests alone?

You've built something real. This verification process isn't academic exercise—it's the same methodology professional teams use before production deployment. You're applying real engineering practices.

---

**Previous:** [Section 4: Implementation with Inline Copilot](./04-implementation-inline-copilot.md) | **Next:** [Section 6: Lessons Learned and Reflection](./06-lessons-learned-reflection.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
