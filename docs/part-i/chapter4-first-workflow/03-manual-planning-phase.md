---
title: "Manual Planning Phase"
description: Create structured implementation plans that capture context, break down work into logical steps, and define explicit success criteria
author: HVE Core Team
ms.date: 2025-11-26
chapter: 4
part: "I"
keywords:
  - planning
  - task-breakdown
  - strategy
  - implementation-plan
---

## Manual Planning Phase

You've completed your research using Ask Mode. You know how email works in your codebase, where the profile update logic lives, and what patterns exist. Now comes the critical transition: research → plan.

In Chapter 7, you'll learn Task Planner—an advanced tool that generates comprehensive three-document plans. But for your first complete workflow, you'll create a **simple manual plan** to understand why planning matters and what good plans contain.

## Why Plan Before Implementing?

You've done research. The temptation to start coding is strong. Why delay with planning?

### Without Planning

* ⚠️ **Unclear sequencing:** Should you build the email template first or the completion detection logic?
* ⚠️ **Missed edge cases:** Discover halfway through implementation that email send failures block profile updates
* ⚠️ **Rework cycles:** Realize after completing Step 3 that Step 1 needs changes
* ⚠️ **Uncertain completion:** When are you "done"? Hope you remembered everything?

### With Planning

* ✅ **Clear roadmap:** Know exactly what to build and in what order
* ✅ **Edge cases upfront:** Identify error scenarios before they become bugs
* ✅ **Logical dependencies:** Understand what must be built before what
* ✅ **Done criteria:** Explicit checklist defining "feature complete"

Planning prevents thrashing. Research shows: Spend 15% more time planning upfront, save 40% overall time by avoiding rework, backtracking, and debugging sessions caused by poor architecture decisions.

## What Makes a Good Plan?

Good plans share four characteristics:

### 1. Captures Context and Goals

```markdown
## Feature: Email Notification on Profile Complete

**Goal:** Send welcome email automatically when user completes all required profile fields

**Success Criteria:**
- Email sent when profile transitions from incomplete → complete
- Email not sent when already-complete profile updated
- Email send failures logged but don't block profile update
- Integration test validates trigger logic
```

**Why this matters:** Six months from now, someone (possibly you) will ask "why did we build this feature this way?" Your plan answers that question.

### 2. Documents Architectural Decisions

```markdown
## Technical Approach

**Email Send Strategy:** Immediate send in route handler

**Rationale:**
- Research finding: Codebase currently sends emails immediately (no job queue infrastructure)
- Constraint: Adding queue infrastructure beyond scope of this feature
- Trade-off accepted: Profile update may be slightly slower (acceptable for low-volume use case)

**Alternative Considered:** Background job queue → Rejected due to infrastructure complexity for single feature
```

Every architectural decision has alternatives. Explain why you chose this path over others. Future maintainers will thank you.

### 3. Breaks Work into Verifiable Steps

Each step should:

* Specify what you're creating or updating (file paths)
* Define the logic you're implementing
* Include a verification action (how you'll know it works)

```markdown
## Implementation Steps

**Step 1: Profile completion detection logic**
- Create: `src/models/User.js` - Add `isProfileComplete()` method
- Returns: boolean (true if all required fields present)
- Verify: Unit test `User.test.js` - test true/false cases

**Step 2: Email template function**
- Update: `src/services/emailService.js`
- Add: `sendProfileCompleteEmail(user)` function
- Template: Inline HTML with user.name personalization
- Verify: Unit test `emailService.test.js` - test template generates correctly
```

**Why verification matters:** You're building incremental confidence. Each verified step becomes solid ground for the next step.

### 4. Identifies Edge Cases

```markdown
## Edge Cases to Handle

**Case 1: Profile updated but already complete**
- Scenario: User updates email address, all fields already complete
- Expected: No new email sent
- Implementation: Check `wasProfileComplete` before update, `isProfileComplete` after update, only send if transitioned false → true

**Case 2: Email service unavailable**
- Scenario: SMTP server down, email send fails
- Expected: Profile update succeeds, error logged, user sees success message
- Implementation: try-catch with log.error(), don't re-throw
```

**Why document upfront?** You'll implement defensive handling as you code, not as an afterthought when bugs appear in production.

## Creating Your Manual Plan

### Section 1: Context and Goals

Start by defining what success looks like:

```markdown
## Feature: [Feature Name]

**Goal:** [One-sentence description of what you're building]

**Success Criteria:**
- [Criterion 1 - testable condition]
- [Criterion 2 - testable condition]
- [Criterion 3 - testable condition]
```

**Example:**

```markdown
## Feature: Email Notification on Profile Complete

**Goal:** Send personalized welcome email when user completes their profile

**Success Criteria:**
- Email sent immediately when profile becomes complete
- No duplicate emails on subsequent updates
- Profile update succeeds even if email fails
- Integration test covers happy path and email failure
```

### Section 2: Research Summary

Capture key findings from your Ask Mode research:

```markdown
## Research Findings

### Email Infrastructure
- Library: nodemailer v6.9.0 (package.json confirmed)
- Config: `src/services/emailService.js` exports configured transporter
- Pattern: Emails sent immediately in route handlers (no queue)

### Profile Update Endpoint
- Location: `src/routes/users.js` - `PUT /users/:id/profile`
- Current behavior: Updates user, returns 200 with user object
- Validation: express-validator middleware checks required fields
```

### Section 3: Technical Approach

Document the "what" and "why" of your architecture:

```markdown
## Approach Selected

**Strategy:** Immediate email send in route handler

**Rationale:**
- Matches existing email pattern in codebase
- No queue infrastructure available
- Feature requirements don't justify queue addition
- Low-volume feature (not a performance concern)

**Trade-offs Accepted:**
- Profile update latency increases by email send time (~200ms)
- Acceptable for low-volume use case
- Will revisit if feature scales to high volume

**Alternatives Considered:**
- Background job queue: Rejected (infrastructure overhead for single feature)
- Webhook to external service: Rejected (adds dependency, doesn't fit use case)
```

### Section 4: Implementation Steps

Break feature into 4-7 discrete steps:

```markdown
## Implementation Steps

**Step 1: [Component Name]**
- Create/Update: [File path]
- Logic: [What you're building]
- Verify: [How you'll test it]

**Step 2: [Component Name]**
- Create/Update: [File path]
- Logic: [What you're building]
- Verify: [How you'll test it]

[Continue for remaining steps]
```

**Full example:**

```markdown
**Step 1: Profile completion detection**
- Create: `src/models/User.js` - `isProfileComplete()` method
- Logic: Check name, email, bio, avatar_url all present and non-empty
- Verify: Unit test with complete profile (true), incomplete profile (false)

**Step 2: Email template function**
- Update: `src/services/emailService.js` - Add `sendProfileCompleteEmail(user)`
- Logic: Generate personalized HTML email with user.name
- Verify: Unit test validates template contains user.name and expected content

**Step 3: Profile update integration**
- Update: `src/routes/users.js` - `PUT /users/:id/profile` handler
- Logic: Check before/after completion state, send email on transition
- Verify: Integration test - profile completion triggers email

**Step 4: Error handling**
- Update: Step 3 implementation - Add try-catch around email send
- Logic: Log errors, don't throw (profile update should succeed)
- Verify: Integration test - email failure doesn't break profile update
```

Each step builds on previous ones. Order matters. Step 3 depends on Step 1's `isProfileComplete()` method. Step 4 refines Step 3 with error handling.

### Section 5: Edge Cases

Document 2-5 edge cases with handling strategy:

```markdown
## Edge Cases

**Case 1: [Scenario Name]**
- Scenario: [What situation might occur]
- Expected Behavior: [What should happen]
- Implementation: [How you'll handle it]

**Case 2: [Scenario Name]**
- Scenario: [What situation might occur]
- Expected Behavior: [What should happen]
- Implementation: [How you'll handle it]
```

### Section 6: Verification Plan

Define how you'll validate the complete feature:

```markdown
## Verification Plan

**Automated Tests:**
- Unit: `User.isProfileComplete()` - Test all required fields checked
- Unit: `emailService.sendProfileCompleteEmail()` - Test template generation
- Integration: Profile update endpoint - Test email trigger on completion
- Integration: Email failure handling - Test profile succeeds when email fails

**Manual Tests:**
1. Create incomplete profile via API
2. Complete profile via PUT request
3. Verify email received in test inbox
4. Update completed profile again
5. Verify no duplicate email sent

**Quality Checks:**
- [ ] All tests passing
- [ ] Linting passes (no errors)
- [ ] Follows codebase conventions
- [ ] Error handling comprehensive
```

## Using AI to Refine Your Plan

You created the initial plan manually. Now use GitHub Copilot inline suggestions to refine:

**Add a section and let Copilot suggest potential issues:**

```markdown
## Potential Issues

[Start typing "Potential issues with immediate email..." and review Copilot suggestions]
```

**Example Copilot suggestions:**

* Race conditions if multiple requests update same user simultaneously
* Email rate limiting if user triggers multiple completion events
* Internationalization concerns for email content
* Email validation (what if user provides invalid email address?)

**Your job:** Evaluate each suggestion. Keep relevant ones, discard irrelevant ones, mark some as "future enhancements".

Copilot excels at "what am I forgetting?" Use it to prompt your thinking and identify blind spots, not to replace your architectural judgment.

## Exercise 4.2: Create Your Implementation Plan (10-15 minutes)

**Goal:** Create a complete manual implementation plan for the email notification feature using your research findings from Exercise 4.1.

### Instructions

1. **Create plan file:** `implementation-plan-email-feature.md`

2. **Write Context section** (2 minutes)
   * Feature name: Email Notification on Profile Complete
   * Goal: One sentence describing feature
   * Success criteria: 3-4 testable conditions

3. **Summarize Research** (2 minutes)
   * Copy key findings from your research notes
   * Focus on decisions that affect implementation

4. **Document Technical Approach** (3 minutes)
   * Strategy: What architecture are you choosing?
   * Rationale: Why this approach? What did research reveal?
   * Trade-offs: What are you accepting?
   * Alternatives: What did you consider and reject?

5. **Define Implementation Steps** (4-6 minutes)
   * Break feature into 4-6 steps
   * Each step: File path, logic description, verification method
   * Ensure logical dependency order (Step N can't depend on Step N+1)

6. **Identify Edge Cases** (2-3 minutes)
   * Document 2-4 edge cases
   * For each: Scenario, expected behavior, implementation approach

7. **Optional: Use Copilot to identify blind spots** (1-2 minutes)
   * Add "Potential Issues" section
   * Let Copilot suggest, evaluate relevance

### Success Criteria

Your plan is complete when it includes:

* ✅ **Clear success criteria** - You can objectively determine "done"
* ✅ **Rationale for technical decisions** - Future you understands "why"
* ✅ **Logical step sequence** - Each step builds on previous ones
* ✅ **Verification plan** - You know how to validate each component
* ✅ **Edge case handling** - Defensive coding built into steps

**Time check:** If you've spent more than 15 minutes, you're over-planning. Stop and move to implementation. You can refine the plan during coding if needed.

## Manual Plan Template

Use this template for your plan:

```markdown
## Feature: [Feature Name]

**Goal:** [One-sentence description]

**Success Criteria:**
- [Criterion 1]
- [Criterion 2]
- [Criterion 3]

---

## Research Findings

[Summary of Ask Mode discoveries and codebase patterns]

---

## Technical Approach

**Strategy:** [Chosen approach]

**Rationale:**
- [Reason 1]
- [Reason 2]

**Trade-offs:**
- [What you're accepting and why]

**Alternatives Considered:**
- [Alternative 1]: Rejected because [reason]

---

## Implementation Steps

**Step 1: [Name]**
- Create/Update: [File paths]
- Logic: [What you're building]
- Verify: [How to test]

**Step 2: [Name]**
- Create/Update: [File paths]
- Logic: [What you're building]
- Verify: [How to test]

[Continue for Steps 3-6]

---

## Edge Cases

**Case 1: [Scenario]**
- Scenario: [Description]
- Expected: [Behavior]
- Implementation: [Handling approach]

**Case 2: [Scenario]**
- Scenario: [Description]
- Expected: [Behavior]
- Implementation: [Handling approach]

---

## Verification Plan

**Automated Tests:**
- Unit: [Test 1]
- Integration: [Test 2]

**Manual Tests:**
1. [Test step 1]
2. [Test step 2]

**Quality Checks:**
- [ ] All tests passing
- [ ] Linting passes
- [ ] Follows conventions
```

## Transitioning to Implementation

You now have a complete plan. You've spent ~25 minutes total on research and planning (15 min Ask Mode + 10-15 min planning).

**What you have:**

* ✅ Understanding of existing codebase patterns
* ✅ Clear feature goal with success criteria
* ✅ Step-by-step implementation roadmap
* ✅ Edge cases identified with handling strategy
* ✅ Verification plan for each component

**What happens next:**
You'll implement the feature step-by-step, using GitHub Copilot's inline suggestions to accelerate coding while your plan keeps you on track. That's Section 4.

## Navigation

[Previous: Section 2 - Research Phase with Ask Mode](./02-research-phase-ask-mode.md) | [Next: Section 4 - Implementation with Inline Copilot](./04-implementation-inline-copilot.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
