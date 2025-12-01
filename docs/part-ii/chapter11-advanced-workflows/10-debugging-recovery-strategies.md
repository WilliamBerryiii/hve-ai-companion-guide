---
title: Debugging and Recovery Strategies
description: Systematic strategies for debugging AI failures and recovering when suggestions don't work
author: HVE Core Team
ms.date: 2025-11-19
ms.topic: how-to
keywords:
  - debugging AI suggestions
  - recovery strategies
  - iterative refinement
  - context reset
  - git rollback
estimated_reading_time: 8
---

AI assistance doesn't always work perfectly. Suggestions sometimes miss edge cases, misunderstand requirements, or produce incorrect code. Understanding how to debug and recover systematically is essential for productive AI-assisted development.

This section covers five debugging strategies and three recovery strategies for common failure modes.

## Common AI Failure Modes

Recognize these patterns when they occur:

**Incorrect suggestions:** AI proposes code that doesn't work or produces unexpected behavior

**Incomplete solutions:** AI implements the happy path but misses edge cases, error handling, or validation

**Wrong direction:** AI misunderstands the problem domain or requirements

**Context confusion:** AI loses track of codebase state after many iterations

**Hallucinations:** AI references non-existent APIs, libraries, or patterns that seem plausible but don't exist

## Debugging Strategy 1: Iterative Refinement

Use this strategy when AI's suggestion is close but needs adjustment.

**Pattern:**

1. Start with AI suggestion
2. Test and identify specific issue
3. Request refinement with problem described clearly
4. Iterate until working

**Example scenario:** Implementing authentication middleware

```markdown
Edit Mode prompt: "Implement authentication middleware for Express API."
```

AI proposes implementation. Test reveals it doesn't handle admin role properly.

```markdown
Edit Mode prompt: "Refine authentication middleware to distinguish admin vs user roles. 
Admin users should have access to all routes. Current implementation allows authentication 
but doesn't check role for protected admin routes."
```

AI proposes refinement. Test reveals admin access works but standard user access now breaks.

```markdown
Edit Mode prompt: "Fix authentication: admin access works but standard users now blocked 
from non-admin routes. Preserve admin access AND allow standard users to access their 
routes. Current middleware blocks all non-admin users from any route."
```

AI proposes fix. Test confirms both admin and standard users have appropriate access.

**Key success factor:** Provide specific feedback about what's wrong. Avoid vague complaints like "it doesn't work." Describe the exact behavior you see and the behavior you need.

## Debugging Strategy 2: Fallback to Smaller Scope

Use this strategy when AI's suggestion is overwhelmingly complex or way off target.

**Pattern:**

1. Recognize overwhelming complexity
2. Stop current approach
3. Break into smaller pieces with Ask Mode
4. Implement incrementally with Edit Mode

**Example scenario:** Payment processing implementation gone wrong

```markdown
Agent Mode prompt: "Implement complete payment processing with Stripe integration."
```

AI generates 500 lines of code with multiple issues. Debugging is difficult because too much changed at once.

**Stop. Switch approach:**

```markdown
Ask Mode prompt: "Break down Stripe payment processing into smaller implementation steps. 
What should be implemented first, second, and third?"
```

AI suggests: Start with Stripe client configuration, then payment intent creation, then webhook handling, then error handling.

```markdown
Edit Mode prompt: "Implement only Step 1: Stripe client configuration with API key 
initialization and basic connection test."
```

AI provides small, focused implementation. Test confirms it works.

```markdown
Edit Mode prompt: "Now implement Step 2: Payment intent creation for single payment 
amounts. Reference the working client configuration from Step 1."
```

Continue step-by-step with validation at each stage.

## Debugging Strategy 3: Context Reset

Use this strategy when AI is confused about codebase state after many iterations.

**Symptoms:**

* AI references old code that's been changed
* AI proposes changes that conflict with recent work  
* AI seems unaware of current state

**Example scenario:** AI lost track after 20 messages

After extensive back-and-forth, AI suggests: "Update the login function in auth.js."

Problem: That function was renamed to `loginUser` several iterations ago.

**Stop. AI context is stale.**

**Reset approach with /clear command:**

```markdown
/clear

Edit Mode prompt: "I need to add password reset functionality to the authentication 
system. Current code state:

[Paste current auth.js relevant sections]

Requirements:
1. Generate secure reset token
2. Email token to user
3. Validate token on reset page
4. Update password when valid

Implement password reset functionality."
```

Fresh context allows AI to work with accurate understanding.

**Alternative reset with explicit context refresh:**

```markdown
Edit Mode prompt: "Stop. Current code state has changed significantly from earlier 
in this conversation. Here is the current auth.js file:

[Paste complete current file]

Now implement password reset functionality as described earlier."
```

## Debugging Strategy 4: Manual Debugging First

Use this strategy when you can't figure out why AI's suggestion doesn't work.

**Pattern:**

1. Hit error with AI suggestion
2. Pause AI interaction
3. Debug manually with console.log, debugger, or logs
4. Identify root cause
5. Determine if issue is AI's code or something else
6. Fix non-AI issue or request targeted AI fix

**Example scenario:** Error in AI implementation

```markdown
Edit Mode prompt: "Implement shopping cart checkout processing."
```

AI proposes implementation. Test produces error: "Cannot read property 'total' of undefined."

**Before asking AI to fix, debug manually:**

```javascript
// Add logging to checkout function
console.log('cart:', cart);
console.log('cart.total:', cart?.total);
```

Run code. Console shows `cart: null`.

Trace why cart is null. Database query returns null. Check database. Cart document doesn't exist for test user.

**Root cause identified:** Test setup issue, not AI's implementation fault.

Fix test setup:

```javascript
beforeEach(async () => {
  await Cart.create({ 
    userId: testUser._id, 
    items: [], 
    total: 0 
  });
});
```

Re-test AI's original implementation. Works correctly.

**Benefit:** Avoid wasting iterations asking AI to fix what isn't broken. Manual debugging identifies real issues quickly.

## Debugging Strategy 5: Explain the Code Back

Use this strategy when AI's code works but you don't understand why.

**Pattern:**

1. AI provides working code
2. You don't understand the implementation
3. Ask AI to explain back to you
4. Gain understanding before moving forward

**Example scenario:** Complex database aggregation

```markdown
Edit Mode prompt: "Implement sales report with product breakdown using MongoDB aggregation."
```

AI proposes aggregation pipeline with `$lookup`, `$unwind`, and `$group` stages. Test shows correct results but the pipeline logic is unclear.

```markdown
Ask Mode prompt: "Explain this aggregation pipeline step by step:

[Paste aggregation code]

What does each stage do and why is it necessary?"
```

AI explains: "Stage 1 ($match) filters orders by date range and status. Stage 2 ($unwind) deconstructs the items array so each item becomes a separate document for processing. Stage 3 ($group) groups by productId and calculates sum of quantities and totals. Stage 4 ($lookup) joins with the products collection to get product names and details."

Understanding the pipeline allows you to maintain and modify it later.

**Benefit:** Learn from AI's solutions instead of blindly copying code you don't understand.

## Recovery Strategy 1: Git Rollback

Use this strategy when AI changes broke something and fixing seems harder than restarting.

**Example scenario:** Agent Mode made too many changes

```markdown
Agent Mode prompt: "Refactor user management to use new validation library."
```

Agent makes autonomous changes. Test reveals multiple things broken. Git shows 15 files modified with hundreds of changes.

**Recover with rollback:**

```bash
# Check what changed
git status

# See all changes (likely too many to review quickly)
git diff

# Rollback everything
git reset --hard HEAD
```

All AI changes reverted. Start over with more controlled approach.

```markdown
Edit Mode prompt: "Refactor user management validation to use Joi library. 
Start with UserController only. Show me each change for review before applying."
```

**Git checkpoint strategy:**

Before risky AI work:

```bash
# Create checkpoint
git commit -m "Checkpoint before AI refactoring"

# Do AI work
[AI makes changes]

# Test changes
npm test

# If good:
git commit -m "Implemented validation refactoring with AI"

# If bad:
git reset --hard HEAD~1
```

**Git branch protection strategy:**

```bash
# Create experimental branch
git checkout -b ai-experiment

# Do AI work
[AI makes changes]

# Test changes
npm test

# If good:
git checkout main
git merge ai-experiment

# If bad:
git checkout main
git branch -D ai-experiment
```

## Recovery Strategy 2: Ask Mode Investigation

Use this strategy when something broke and you're unclear why.

**Example scenario:** Unexpected error after changes

```markdown
Edit Mode prompt: [Make authentication changes]
```

Test produces error: "JWT token verification failed."

```markdown
Ask Mode prompt: "I'm getting 'JWT token verification failed' error. Where in the 
codebase is JWT verification happening? Show me the relevant code sections."
```

AI responds: "JWT verification occurs in middleware/auth.js, lines 23-35. The middleware uses JWT_SECRET from config/environment.js and verifies tokens using jsonwebtoken library."

Check config. Discover JWT_SECRET is undefined in test environment.

**Root cause identified:** Configuration issue, not code issue.

Fix by setting JWT_SECRET in test configuration.

**Pattern:**

1. Something breaks
2. Ask Mode helps locate relevant code
3. Manually investigate based on AI's pointers
4. Fix root cause

## Recovery Strategy 3: Simplify and Rebuild

Use this strategy when code has become too complex or fragile to salvage.

**When to rebuild:**

* More than 5 iterations fixing issues without resolution
* Code becoming increasingly convoluted
* You've lost confidence in code quality
* Fresh start would be faster than continued patching

**Example scenario:** Feature has been patched repeatedly

After many iterations, the code has multiple workarounds. It works partially but feels fragile and hard to understand.

**Stop. Start fresh:**

**Step 1 - Document what works:**

```markdown
Current implementation successfully:
- Creates user accounts
- Validates email format
- Sends welcome email

Still broken:
- Email verification flow
- Password strength validation
- Account activation
```

**Step 2 - Document complete requirements:**

```markdown
Complete requirements:
1. User registration with email/password
2. Email format validation
3. Password strength requirements (8+ chars, uppercase, number, special char)
4. Send verification email with token
5. Verify email via token link
6. Activate account after verification
```

**Step 3 - Create fresh implementation plan:**

```markdown
Task Planner prompt: "Create clean implementation plan for user registration 
with email verification. Ignore previous implementation attempts.

Requirements:
[Paste complete requirements]

Create step-by-step plan with validation points."
```

**Step 4 - Implement from plan:**

```markdown
Edit Mode prompt: "Implement Step 1 from plan: User registration endpoint 
with validation. Use clean, simple approach."
```

Result: Clean, maintainable code instead of patched complexity.

## Learning from Failures

Keep a failure log to improve future AI collaboration.

**Example log entries:**

```markdown
## 2024-11-15: Agent Mode Too Autonomous for Payments

What happened: Agent Mode implemented payment processing but missed security 
considerations. No idempotency keys, weak error handling, no amount validation.

Lesson: Use Edit Mode for security-critical code (payments, auth, data deletion).

New practice: Always plan security-critical features in detail. Use Edit Mode 
for review-per-change approach.

---

## 2024-11-18: Complex Query Hallucination

What happened: Asked AI for "efficient query for sales by region." AI proposed 
query using aggregate functions our database doesn't support. Wasted 30 minutes 
before realizing the functions don't exist.

Lesson: AI hallucinated database features that seemed plausible but don't exist.

New practice: For complex queries, ask "What database features and functions does 
this require?" before implementation. Verify against actual database documentation.
```

**Pattern for learning:**

1. Document failure with context
2. Identify specific lesson
3. Update your practices  
4. Avoid same failure in future

## Debugging Decision Tree

Follow this decision tree when AI suggestions don't work:

**AI suggestion doesn't work**
↓
**Does error message point to specific issue?**
├─ **Yes** → Use Iterative Refinement (describe specific issue to AI)
└─ **No** → Use Manual Debugging First (console.log, debugger, find root cause)
&nbsp;&nbsp;&nbsp;&nbsp;↓
&nbsp;&nbsp;&nbsp;&nbsp;**Root cause identified?**
&nbsp;&nbsp;&nbsp;&nbsp;├─ **Yes** → Fix root cause or request targeted AI fix
&nbsp;&nbsp;&nbsp;&nbsp;└─ **No** → Use Context Reset (clear chat, provide fresh context)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;↓
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**Still not working?**
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;↓
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Use Fallback to Smaller Scope (break into incremental pieces)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;↓
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**Still stuck after 5+ iterations?**
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;↓
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Consider Simplify and Rebuild (start fresh with cleaner approach)

---

**Previous:** [Beads TDD Exercise](./09-beads-tdd-exercise.md) | **Next:** [Measuring Workflow Effectiveness](./11-measuring-effectiveness.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
