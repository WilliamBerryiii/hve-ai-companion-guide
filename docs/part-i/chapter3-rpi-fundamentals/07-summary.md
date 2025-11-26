---
title: "Chapter 3 Summary"
description: Reinforce RPI methodology concepts with a hands-on exercise practicing the complete workflow
author: HVE Core Team
ms.date: 2025-11-26
chapter: 3
part: I
keywords:
  - chapter-summary
  - rpi-exercise
  - workflow-practice
  - key-takeaways
---

You've learned the Research → Plan → Implement methodology that transforms uncertain requirements into working code while reducing AI hallucination risk. This summary reinforces key concepts and provides a hands-on exercise to practice the complete workflow.

## Key takeaways

* **RPI transforms types systematically:** Uncertainty → Knowledge → Strategy → Working Code through three distinct phases
* **Evidence-based development reduces hallucination:** Every AI output grounded in verified research findings with source citations
* **Three phases have distinct purposes:** Research gathers evidence, Planning creates strategy, Implementation executes with validation
* **Type transformation mindset:** Give AI high-quality inputs (Type 4 precise instructions), get high-quality outputs; vague inputs yield vague outputs
* **Investment varies by novelty:** High novelty requires more research; low novelty allows minimal research with faster implementation
* **RPI is iterative, not linear:** Loop back to earlier phases when you discover gaps or errors—that's expected and encouraged

## What you can now do

✓ Execute complete RPI cycle for small-to-medium refactoring tasks with confidence

✓ Recognize hallucination patterns (invented APIs, wrong versions, plausible config, mixed patterns) and apply prevention strategies

✓ Assess task novelty and adjust time investment across phases using the decision framework

✓ Create evidence trails from research → plan → implementation that provide accountability for technical decisions

✓ Validate AI outputs incrementally to catch errors early before they compound

✓ Apply type transformation mindset to improve AI input quality and output reliability

## Standard exercise: Your first RPI workflow

Apply the complete RPI method to a practical refactoring task. This exercise demonstrates the full workflow.

### Exercise overview

Refactor a complex function into smaller, testable units following the single-responsibility principle. You'll experience all three RPI phases and build muscle memory for the workflow.

### Scenario

You have a JavaScript function that validates user input, checks permissions, logs actions, and saves to database—all in one 80-line function. You need to refactor it into smaller functions that are easier to test and maintain.

### Starter code

```javascript
// src/user/userActions.js
async function updateUserProfile(userId, updates) {
  // 80 lines of validation, permission checking, logging, DB operations
  // All mixed together - needs refactoring
}
```

This exercise uses native Copilot features (Chat, Edits) and custom hve-core modes (Task Researcher, Task Planner). Access custom modes via the agent picker dropdown—see [Section 1](./01-introduction.md) for setup details.

### Phase 1: Research

Follow these steps to gather evidence about refactoring approaches:

1. Open Copilot Chat panel in VS Code (use native Chat for **Ask Mode** pattern questions)
2. Ask: "What are best practices for refactoring large functions in JavaScript?"
3. Review the response and note key concepts (single responsibility, pure functions, separation of concerns)
4. Use the agent picker dropdown to select **Task Researcher** (custom hve-core mode)
5. Ask: "Research refactoring patterns for extracting validation, logging, and database logic from a monolithic function"
6. Wait for research document creation
7. Review the document at `.copilot-tracking/research/YYYYMMDD-refactoring-patterns-research.md`
8. Verify the document includes at least three refactoring patterns with sources

### Phase 2: Plan

Create a structured implementation strategy based on research:

1. Use the agent picker dropdown to select **Task Planner** (custom hve-core mode)
2. Provide this context: "I need to refactor the updateUserProfile function. See research doc at [paste path]. Create plan for extracting: input validation, permission checking, audit logging, and database operations into separate testable functions."
3. Wait for three-document plan creation:
   * `YYYYMMDD-refactoring-plan-details.md` (why and what)
   * `YYYYMMDD-refactoring-plan-implementation.md` (how, step-by-step)
   * `YYYYMMDD-refactoring-plan-changes.md` (tracking)
4. Review the implementation plan and verify steps are clear and sequenced correctly
5. Confirm each step references research findings

### Phase 3: Implement

Execute the plan step-by-step with validation:

1. Open **Copilot Edits** panel (Ctrl+Shift+I or via Command Palette: "Copilot Edits: Focus on Edits View")
2. Execute plan steps sequentially:
   * Step 1: Create validation functions
   * Step 2: Create permission checking function
   * Step 3: Create logging function
   * Step 4: Create database operation function
   * Step 5: Refactor main function to orchestrate calls
3. Run linter after each step to catch errors immediately
4. Verify code structure matches plan specifications

### Self-check criteria

Use these criteria to verify successful completion of each phase.

**✅ Research phase success:**

* Research document exists with at least three refactoring patterns documented with sources
* Document includes authoritative sources (articles, documentation, code examples)
* You understand the single-responsibility principle from research findings
* You can explain why extracting functions improves code quality

**✅ Plan phase success:**

* Three plan documents created in `.copilot-tracking/plans/` directory
* Implementation plan has 4-6 discrete steps with clear boundaries
* Each step describes what to create or modify with specific details
* Steps are sequenced logically (validation before database operations)
* Plan references specific research findings for rationale

**✅ Implement phase success:**

* Original 80-line function broken into 4-5 smaller functions
* Each extracted function has single, clear responsibility
* Main function simplified to orchestrate calls to extracted functions
* Code passes linting with no errors
* Function names clearly indicate purpose

**✅ Overall RPI success:**

* You can trace implementation code back to specific plan steps
* You can trace plan steps back to research findings with sources
* You feel confident the refactoring follows best practices grounded in research

### Example output

Here's what successful completion looks like for each phase.

**Research document (excerpt):**

```markdown
## Refactoring Pattern: Extract Method

**Source:** [Martin Fowler - Refactoring](https://refactoring.com/catalog/extractFunction.html)

**When to use:** Function does too many things, mixing different concerns

**How to apply:** 
1. Identify cohesive blocks of code that serve single purpose
2. Extract to named functions with descriptive names
3. Pass only necessary parameters
4. Return results explicitly

**Benefits:** 
* Improved readability through descriptive function names
* Enhanced testability with isolated units
* Increased reusability across codebase
```

**Plan document (excerpt):**

```markdown
## Step 1: Extract Input Validation

**Action:** Create `validateUserProfileUpdates(updates)` function in new file `src/validation/userProfile.js`

**Implementation:**
* Validates required fields (email, name)
* Checks field format constraints
* Returns validation result object: `{ isValid: boolean, errors: string[] }`

**Source:** Research document section 2.1 - "Validation Separation Pattern"

**Verification:** Unit test validates both valid and invalid inputs
```

**Implementation (excerpt):**

```javascript
// src/validation/userProfile.js
// Extracted validation function (Step 1 of plan)
function validateUserProfileUpdates(updates) {
  const errors = [];
  
  if (!updates.email || !isValidEmail(updates.email)) {
    errors.push('Invalid email format');
  }
  
  if (!updates.name || updates.name.length < 2) {
    errors.push('Name must be at least 2 characters');
  }
  
  return { 
    isValid: errors.length === 0, 
    errors 
  };
}

// src/user/userActions.js
// Refactored main function (Step 5 of plan)
async function updateUserProfile(userId, updates) {
  // Step 1: Validate input
  const validation = validateUserProfileUpdates(updates);
  if (!validation.isValid) {
    throw new ValidationError(validation.errors);
  }
  
  // Step 2: Check permissions
  await checkUserPermissions(userId, 'updateProfile');
  
  // Step 3: Save to database
  await saveUserProfile(userId, updates);
  
  // Step 4: Log action
  await logUserAction(userId, 'profile_updated', updates);
}
```

### Troubleshooting

Common issues and their solutions:

#### Issue: Research document is too generic or lacks specific patterns

→ Refine Task Researcher prompt with more context: "Research refactoring patterns specifically for JavaScript async functions that mix validation, authorization, and database operations. Include code examples."

#### Issue: Plan steps are too vague (e.g., "Extract validation")

→ Return to Task Planner and ask: "Make Step 1 more specific—what exact validation logic should be extracted and what should the function signature look like?"

#### Issue: Implementation doesn't match plan specifications

→ Stop and check: Are you following plan steps sequentially? Did Copilot Edits misunderstand a step? Go back to last verified step and re-implement from there.

#### Issue: Research seems complete but you still feel uncertain

→ Review the "Research is sufficient when" checklist from Section 6. If you can't answer yes to all questions, identify specific gaps and research those targeted questions.

## Common RPI anti-patterns

Learn from these mistakes to avoid common pitfalls.

### Anti-pattern 1: Skipping research for "simple" tasks

**What it looks like:** "This is straightforward, I'll just ask AI to implement it directly."

**Why it fails:** "Simple" tasks often have hidden complexity. AI generates plausible-but-wrong code when you skip evidence gathering.

**What to do instead:** Even "simple" tasks deserve 10 minutes of research. Quick research helps avoid hours of debugging hallucinated code.

### Anti-pattern 2: Planning without evidence

**What it looks like:** Creating plans based on assumptions about how things work, not research findings.

**Why it fails:** Plans built on assumptions compound errors. AI generates code following the flawed plan, creating working code that solves the wrong problem.

**What to do instead:** Every plan step must reference research findings. If you can't cite research for a plan decision, return to research phase.

### Anti-pattern 3: Ignoring test failures during implementation

**What it looks like:** Tests fail after a plan step, but you continue implementing remaining steps anyway.

**Why it fails:** Errors compound. Later steps depend on earlier steps working correctly. Proceeding with failures creates cascading problems.

**What to do instead:** RPI is incremental. Stop at first test failure. Debug and fix before proceeding. Each step should leave code in working state.

### Anti-pattern 4: Research that never ends

**What it looks like:** Spending hours researching, reading documentation, exploring options, never reaching planning or implementation.

**Why it fails:** Perfectionism prevents progress. You don't need to know everything—you need to know enough to make informed decisions.

**What to do instead:** Time-box research (see Section 6). Define "good enough" criteria upfront: "I need to answer questions X, Y, Z." When answered with evidence, proceed to planning.

## Connection to next chapter

You've learned the RPI methodology at a conceptual level. Chapter 4 applies RPI to your first complete feature implementation, walking you through each phase with a realistic scenario and detailed guidance. You'll gain hands-on experience with the full workflow, building confidence before diving into mode-specific techniques in Part II.

## Additional resources

* [Martin Fowler: Refactoring Catalog](https://refactoring.com/catalog/) - Systematic refactoring patterns referenced in this chapter's exercise
* [Joel Spolsky: Evidence-Based Scheduling](https://www.joelonsoftware.com/2007/10/26/evidence-based-scheduling/) - Evidence-based approach to software estimation that shares RPI's grounding in verifiable information
* [Google: Code Review Developer Guide](https://google.github.io/eng-practices/review/) - Incremental development and validation practices similar to RPI's step-by-step approach

---

**Previous:** [Section 6: When to invest time in each phase](./06-when-to-invest-time.md)

**Next:** [Chapter 4: Your First RPI Workflow](../../part-i/chapter4-first-workflow/README.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
