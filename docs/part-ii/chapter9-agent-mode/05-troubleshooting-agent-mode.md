---
title: "Troubleshooting Agent Mode - When Things Go Wrong"
description: "Learn to recognize common Agent Mode failure patterns, intervene effectively, and recover gracefully when autonomous execution deviates from expectations"
author: "HVE Core Team"
ms.date: 2025-11-19
section: 5
chapter: 9
part: 2
keywords:
  - troubleshooting
  - intervention-strategies
  - recovery-patterns
  - failure-modes
estimated_reading_time: 12
---

## Autonomous Doesn't Mean Unsupervised

Agent Mode works autonomously but requires supervision. Think of it like cruise control: hands off the wheel briefly, but eyes always on the road.

This section teaches you to recognize problems early, intervene effectively, and recover gracefully when Agent deviates from expectations.

## Common Failure Modes

### Test Pattern Violations

Agent creates tests that pass immediately when they should fail first.

**Symptom:**

```markdown
Agent: Writing tests for validatePassword function...
Tests created: 4 test cases
Running tests...
Tests: 4 passed ✓

Agent: Implementing validatePassword function...
```

**Problem:** Tests passed before implementation. They should fail in the red phase of test-first development.

**Why it matters:**

* Tests might be testing mocked behavior instead of real code
* False sense of security
* Actual bugs might not be caught

**How to intervene:**

```markdown
Stop. The tests passed before implementation, which means they're not 
testing the real function. Please:

1. Review tests - are they testing mocked behavior instead of real code?
2. Ensure tests import and call the actual validatePassword function
3. Re-run tests - they should fail (red phase)
4. Then implement to make them pass (green phase)
```

This redirects Agent to follow proper test-first workflow.

### Repeated Failures Without Progress

Agent tries multiple approaches but keeps hitting the same failures.

**Symptom:**

```markdown
[Attempt 1] Tests: 3 passed, 2 failed
Agent: Fixing test failures...

[Attempt 2] Tests: 3 passed, 2 failed (same failures)
Agent: Adjusting implementation...

[Attempt 3] Tests: 3 passed, 2 failed (same failures)
Agent: Trying different approach...
```

**Problem:** Agent is stuck in a loop without making progress.

**Why it matters:**

* Wastes time on unsuccessful approaches
* May indicate fundamental misunderstanding
* Could be a test issue, not an implementation issue

**How to intervene:**

```markdown
Stop. You're stuck on these 2 test failures. Let's debug:

1. Show me the exact error messages from failing tests
2. Show me the relevant implementation code
3. Show me the test assertions that are failing

I'll provide specific guidance on the fix.
```

After Agent shows you the details, you might realize:

```markdown
The issue is that you're comparing encrypted strings directly, but 
each encryption produces different output (random IV).

Change the test approach:
- Instead of comparing encrypted strings, test encrypt→decrypt round trip
- Assert: decryptSecret(encryptSecret(secret)) === secret
```

> [!WARNING]
> If Agent appears to be repeatedly attempting similar failing approaches without progress, stop and provide specific guidance. Agent may not discover the solution through additional attempts.

### Scope Creep

Agent adds features beyond the plan specification.

**Symptom:**

```markdown
Agent: Step 2.2 complete. Moving to Step 2.3...

Also adding:
- Email notification when 2FA is enabled
- Backup code regeneration endpoint
- 2FA disable endpoint
- Admin override capability

Creating src/services/emailService.ts...
```

**Problem:** Agent is adding unplanned features.

**Why it matters:**

* Scope expansion delays completion
* Introduces untested features
* May not align with actual requirements
* Increases review burden

**How to intervene:**

```markdown
Stop. You're adding features beyond the plan scope:
- Email notifications
- Backup code regeneration
- 2FA disable endpoint
- Admin override

Stick to the original plan (Steps 2.1-2.3 only). We'll address 
additional features in a future plan.

Please:
1. Revert changes to emailService.ts
2. Complete Step 2.3 as specified
3. Stop after Step 2.3
```

This refocuses Agent on the original scope.

### Security Implementation Without Guidance

Agent implements security-sensitive code incorrectly without asking for guidance.

**Symptom:**

```markdown
Agent: Implementing token encryption...

Using Base64 encoding for secret storage:
const encoded = Buffer.from(secret).toString('base64');

Storing encoded secret in database...
```

**Problem:** Agent is using encoding instead of encryption. This is a security vulnerability.

**Why it matters:**

* Base64 is encoding, not encryption (easily decoded)
* Creates security vulnerability in production
* Should have triggered an Ask checkpoint

**How to intervene:**

```markdown
STOP IMMEDIATELY.

Base64 is encoding, not encryption. Secrets would be trivially 
decoded by anyone with database access.

Please:
1. Remove Base64 encoding approach
2. Implement proper encryption using Node.js crypto module:
   - Algorithm: AES-256-GCM
   - Random IV per encryption
   - Authenticated encryption (includes auth tag)
3. Use environment variable for encryption key
4. Show me the implementation before applying
```

> [!WARNING]
> Always stop Agent immediately when you spot security vulnerabilities. Review security-sensitive code before Agent proceeds to the next step.

### File Modification Beyond Working Set

Agent modifies files that weren't specified in the working set.

**Symptom:**

```markdown
Agent: Implementing 2FA setup endpoint...

Changes made:
- Modified: src/auth/authRoutes.ts ✓
- Modified: src/services/TwoFactorService.ts ✓
- Modified: src/middleware/authMiddleware.ts
- Modified: src/config/passport.ts
- Modified: src/app.ts
```

**Problem:** Agent modified files beyond the original working set.

**Why it matters:**

* Unexpected changes to unrelated code
* May break other functionality
* Harder to review and understand scope

**How to intervene:**

```markdown
Stop. You've modified files beyond the working set:
- authMiddleware.ts
- passport.ts
- app.ts

The plan only specified changes to:
- authRoutes.ts
- TwoFactorService.ts

Please explain:
1. Why were these additional files modified?
2. Are these changes necessary for 2FA setup?
3. Can we achieve the goal without modifying these files?
```

Agent's response might reveal:

* **Necessary changes** you missed in planning → Update plan, approve changes
* **Unnecessary refactoring** → Revert extra changes
* **Misunderstanding** of requirements → Clarify and redirect

## Recovery Strategies

When Agent deviates from the plan, you need recovery strategies that preserve good work while fixing problems.

### Partial Rollback

When Agent completes some steps correctly but fails on others, keep the good work and fix only the problematic parts.

**Scenario:** Steps 2.1 and 2.2 work correctly, but Step 2.3 has issues.

**Recovery approach:**

```markdown
Steps 2.1 and 2.2 look good - tests passing, implementation solid.

Step 2.3 has issues (login logic incorrect).

Please:
1. Keep changes from 2.1 and 2.2
2. Revert changes to login handler in authRoutes.ts (Step 2.3)
3. I'll provide specific guidance for Step 2.3

Commit 2.1 and 2.2 as-is, then we'll tackle 2.3 separately.
```

This preserves completed work while isolating the problem.

### Course Correction

When Agent heads in the wrong direction but hasn't completed the work, redirect before wasting more effort.

**Scenario:** Agent implementing in-memory rate limiting when you need Redis-based solution.

**Recovery approach:**

```markdown
I see you're implementing rate limiting in memory (Map object).

This won't work in production (multi-server deployment).

Please pivot to Redis-based rate limiting:
1. Stop current implementation
2. Add ioredis dependency
3. Use redis-rate-limiter library instead
4. Follow pattern from src/services/cacheService.ts (Redis client setup)
```

Early intervention prevents wasted effort on wrong approach.

### Guided Completion

When Agent is close to correct but stuck on specific issue, provide targeted guidance to finish.

**Scenario:** Agent implements JWT verification but misses error handling for expired tokens.

**Recovery approach:**

```markdown
You're close on the JWT verification logic. The issue is token expiration handling.

Specific fix needed in authMiddleware.ts (lines 23-28):

**Current code:**

```typescript
const decoded = jwt.verify(token, SECRET);
req.user = decoded;
```

**Change to:**

```typescript
try {
  const decoded = jwt.verify(token, SECRET);
  req.user = decoded;
} catch (err) {
  if (err.name === 'TokenExpiredError') {
    return res.status(401).json({ error: 'Token expired' });
  }
  throw err;
}
```

Apply this fix and continue with Step 2.3.

Specific guidance unblocks Agent without starting over.

### Full Restart with Refined Prompt

When Agent fundamentally misunderstood requirements, start over with clearer specification.

**Scenario:** Agent built entirely wrong solution.

**Recovery approach:**

```markdown
Let's start over on Step 2.2. The current implementation doesn't match requirements.

Reverting all Step 2.2 changes...

Here's a refined prompt with more specific guidance:

Step 2.2: Create /api/auth/2fa/setup endpoint

CRITICAL REQUIREMENTS:
1. Must use authenticated session (authMiddleware)
2. Generate secret via TwoFactorService.generateSecret(req.user.email)
3. Encrypt secret BEFORE storing in database
4. Return { qrCode, backupCodes } - NEVER return raw secret
5. Endpoint is idempotent (regenerates secret on repeat calls)

VERIFICATION:
- 200 response with qrCode (data URL) and backupCodes (array of 10)
- Database contains encrypted secret (not plaintext)
- Calling twice generates new secret (old one invalidated)

Please re-implement Step 2.2 with this specification.
```

Clear requirements prevent second misunderstanding.

## Proactive Monitoring

The best troubleshooting is prevention. Monitor Agent execution actively to catch issues early.

### Checkpoint Reviews

Review after each logical checkpoint rather than waiting until the end.

**Pattern:**

After each step completion:

1. Quick scan of changes (30 seconds)
2. Verify tests passing
3. Check files modified match expectations
4. Approve to continue or intervene

**Time investment:** 2-3 minutes per step
**Benefit:** Catch issues early, easier recovery

### Parallel Testing

While Agent implements the next step, manually verify the previous step.

**Pattern:**

```markdown
Agent working on Step 2.3 (5 min estimate)
  ↓
You: Manual testing of Step 2.2 implementation
  - Hit endpoint with Postman
  - Verify QR code displays correctly
  - Check database shows encrypted secret
  ↓
Agent completes Step 2.3
  ↓
You: Review 2.3 changes (already verified 2.2)
```

This overlaps verification with implementation for faster feedback.

### Trust But Verify

Let Agent run but monitor key indicators during execution.

**Watch for:**

* ✓ Test counts increasing appropriately
* ✓ Files modified align with plan
* ✓ No unexpected errors in output
* ✓ Progress updates match plan steps

You don't need to read every line as Agent writes it. You do need to verify the final implementation before accepting it.

### When not to use Agent Mode

Some scenarios are better suited for Edit Mode or Insert Mode.

| Scenario                         | Why Edit/Insert is Better                     |
|----------------------------------|-----------------------------------------------|
| Single function modification     | Agent Mode overhead not justified             |
| Security-critical implementation | Need line-by-line control and review          |
| Exploratory refactoring          | Requirements unclear, need iterative approach |
| Learning new pattern             | First time establishing convention            |
| Ambiguous requirements           | Need to clarify through implementation        |
| No test coverage                 | Can't verify correctness autonomously         |
| Critical production hotfix       | Too risky for autonomous execution            |

**Decision guideline:** If you can't clearly specify success criteria upfront, use Edit Mode to explore and clarify before switching to Agent Mode.

---

## Hands-On Exercise 9.3: Intervention Practice

**Goal:** Practice recognizing failure patterns and crafting effective intervention responses.

**Scenario:** Review the following Agent Mode outputs and write intervention prompts to redirect Agent effectively.

**Steps:**

1. **Analyze this failure pattern:**

   ```markdown
   Agent: Creating validateEmail function...
   Tests created: 3 test cases
   Running tests...
   Tests: 3 passed ✓
   
   Agent: Moving to next step...
   ```

   **Question:** What's wrong with this execution? Write an intervention prompt.

2. **Analyze this scope creep:**

   ```markdown
   Agent: Step 2 complete - basic email validation.
   
   Also adding:
   - DNS verification for email domain
   - Disposable email detection
   - Email normalization (removing dots from Gmail)
   
   Creating src/services/emailEnhancer.ts...
   ```

   **Question:** Write an intervention prompt that stops scope creep while acknowledging the ideas.

3. **Analyze this repeated failure:**

   ```markdown
   [Attempt 1] Test: validateEmail('test@example') - Expected: false, Got: true
   [Attempt 2] Test: validateEmail('test@example') - Expected: false, Got: true
   [Attempt 3] Test: validateEmail('test@example') - Expected: false, Got: true
   ```

   **Question:** Agent is stuck. Write an intervention that helps debug without giving the answer.

**Expected Result:**

Your interventions should:

* Be specific about what went wrong
* Provide clear next steps
* Not micromanage implementation details
* Request confirmation before Agent proceeds

<details>
<summary>Example intervention responses</summary>

**Pattern 1 (tests passed before implementation):**

```markdown
Stop. Tests passed before validateEmail was implemented.
Please:
1. Show me what the tests are actually testing
2. Ensure tests call the real function, not a mock
3. Re-run - tests should fail until implementation exists
```

**Pattern 2 (scope creep):**

```markdown
Stop. Those are good ideas for future enhancements, but they're
beyond current scope.

Please:
1. Revert emailEnhancer.ts changes
2. Complete only the basic validation as specified
3. I'll create a follow-up task for enhanced email features
```

**Pattern 3 (stuck on same failure):**

```markdown
You're stuck on the same test failure. Let's debug:
1. Show me your current regex pattern
2. What should 'test@example' fail? (hint: domain format)
3. Try matching against a simpler test case first
```

</details>

> [!TIP]
> Good interventions are like good coaching—they redirect without taking over. Give Agent the information it needs to self-correct.

**What You Learned:**

* How to recognize common failure patterns quickly
* The structure of an effective intervention prompt
* When to provide guidance versus when to take manual control

---

**Previous:** [Complete Agent Workflow](./04-complete-agent-workflow.md) | **Next:** [Advanced Agent Patterns](./06-advanced-agent-patterns.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
