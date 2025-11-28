---
title: "Creating Plans with Task Planner"
description: Walk through the complete planning workflow from invoking Task Planner to producing implementation-ready plans
author: HVE Core Team
ms.date: 2025-11-26
chapter: 7
part: "II"
keywords:
  - planning-workflow
  - task-planner
  - research-grounding
  - plan-creation
---

## Creating Plans with Task Planner

You have research findings documented. Now you transform them into an implementation plan that guides execution step-by-step. This section walks through the planning workflow from invoking Task Planner to producing implementation-ready plans.

## The Planning Workflow

**Complete planning workflow:**

1. **Complete research** using Task Researcher (Chapter 6 workflow)
2. **Clear chat context** or start fresh chat session
3. **Switch to Task Planner mode** in chat settings
4. **Attach research document** to provide grounding context
5. **Describe implementation goal** with specific requirements
6. **Review generated plan** for completeness and accuracy
7. **Refine through iteration** until plan is implementation-ready

Each step has a specific purpose. Skipping steps (especially attaching research) leads to ungrounded plans prone to hallucination.

## Invoking Task Planner

### Step 1: Complete your research

Before planning, finish research using Task Researcher mode. You need documented findings that answer:

* What approaches exist? (alternatives comparison)
* Which approach did you select? (decision with rationale)
* How does it integrate with existing code? (file references, patterns)
* What constraints exist? (dependencies, compatibility, performance)

Incomplete research produces incomplete plans.

### Step 2: Start fresh or clear context

Task Planner performs better with focused context. If you were just in research mode, either:

* Start a new chat session (click **New Chat** in Copilot panel)
* Clear context (click **Clear Chat** or start message with `/clear`)

This prevents mixing research context with planning context.

### Step 3: Switch to Task Planner mode

In Copilot Chat settings (gear icon), select **Task Planner** mode. This loads specialized prompts optimized for structured planning.

### Step 4: Attach research document

Critical step that grounds the plan in evidence:

1. Open research document in editor (the `.md` file from Chapter 6)
2. In Copilot Chat panel, click **Attach Context** button
3. Select **Current File** (or drag file into chat from Explorer)
4. Verify file name appears in chat context area

### Step 5: Describe implementation goal

Provide Task Planner with your planning request. Strong prompts include:

* Reference to attached research document
* Specific implementation goal
* Key requirements or constraints
* Desired plan structure (if you have preferences)

**Example Task Planner prompt:**

```markdown
I have completed research on adding 2FA authentication (see attached research document).

Please create an implementation plan that:
- Uses the speakeasy library approach we selected in research Section 4
- Integrates with our existing Passport.js authentication (detailed in research Section 3)
- Includes database schema changes, API endpoints, and UI components
- Follows our project's file organization patterns (documented in research Section 2)
- Organizes phases by dependency (database → API → UI)

The plan should be suitable for handoff to Edit Mode (Chapter 8) for implementation.
```

**What this prompt accomplishes:**

* References attached research (grounding)
* Specifies selected approach (decision from research)
* Lists integration requirements (constraints)
* Notes project conventions (consistency)
* Requests dependency-based phasing (organization preference)
* States intended use (implementation handoff)

> [!TIP]
> If your research document is very long (500+ lines), Task Planner may receive a summarized version. Keep the file open in the editor to ensure full context is available.

## What Task Planner Does Next

After you submit your prompt, Task Planner:

1. **Reads entire research document** to understand findings and decisions
2. **Identifies selected approach** and the rationale for choosing it
3. **Extracts file patterns** and conventions from existing code examples
4. **Analyzes dependencies** between components (what must happen first)
5. **Creates phased plan** organizing steps by dependencies
6. **Includes verification criteria** for each step (how to confirm completion)
7. **Produces plan document** saved to `.copilot-tracking/plans/`

**Task Planner should acknowledge your research:**

```markdown
I've reviewed your research document (20240115-add-2fa-research.md).

Key findings I'll base the plan on:
- Selected approach: speakeasy library with TOTP (Research Section 4.2)
- Existing auth pattern: Passport.js local strategy (Research Section 3.1)
- Integration point: Post-password verification step (Research Section 3.3)
- File references: loginController.ts (lines 78-120), passportConfig.ts (lines 15-45)
- Database: PostgreSQL with encrypted columns (Research Section 2.4)

Proceeding to create phased implementation plan with database → API → UI sequence...
```

This acknowledgment proves Task Planner read and understood your research. If acknowledgment lacks specifics or references wrong sections, re-attach the research document.

## Reviewing the Generated Plan

Task Planner produces a draft plan following the template from Section 3. Review it for:

**Completeness checks:**

* ✅ Every phase has clear prerequisites listed
* ✅ Each step includes file locations with line numbers
* ✅ Implementation details reference research findings
* ✅ Verification criteria are testable (not vague)
* ✅ Testing strategy covers unit, integration, and manual verification
* ✅ Risk analysis identifies high-complexity steps
* ✅ Rollback plan exists for destructive changes

**Accuracy checks:**

* ✅ File paths match your project structure (not invented)
* ✅ Line numbers approximate actual code locations
* ✅ Dependencies are correct (Phase 2 truly depends on Phase 1)
* ✅ Selected approach matches research decision
* ✅ Integration patterns match existing code

**Quality checks:**

* ✅ Steps are specific, not vague ("Add validation" → "Add email format validation using validator.isEmail() at line 45")
* ✅ Phases are appropriately sized (3-8 steps per phase)
* ✅ No circular dependencies (Phase 3 depends on Phase 2, which depends on Phase 1)
* ✅ Verification is concrete (specific test cases, not "test it works")

## Refining Plans Through Iteration

First-draft plans often need refinement. Common refinement patterns:

### Request: More detail in specific phase

```markdown
Phase 3 (UI components) needs more detail. Please expand Step 3.2 to include:
- Specific React component structure (functional component with hooks)
- State management approach (we use Redux, see research Section 5.2)
- Form validation pattern matching our existing auth forms (Formik + Yup, see src/components/LoginForm.tsx)
- Error handling display (toast notifications, see research Section 5.4)
```

### Request: Add missing verification steps

```markdown
Add verification steps for database migration rollback. Include:
- How to verify migration applied successfully (query for new columns)
- How to roll back if issues discovered (migration:rollback command)
- What to check in production database (column presence, data integrity)
- Backup strategy before migration (dump command)
```

### Request: Adjust complexity estimates

```markdown
Step 2.4 (backup codes generation) is marked low-complexity, but research Section 4.5 
indicates we need:
- Secure random generation (crypto.randomBytes)
- Bcrypt hashing (10 rounds minimum)
- Encrypted storage in database

Please re-evaluate complexity to "medium" or "high" and add risk mitigation notes 
about cryptographic operations requiring security review.
```

### Request: Add integration testing scenarios

```markdown
Testing strategy is missing integration tests for cross-phase workflows. Please add scenarios:
- User enables 2FA in settings, logs out, logs back in with TOTP (full enable flow)
- User enables 2FA, loses device, uses backup code (backup code path)
- Admin views 2FA status across multiple users (reporting functionality)
- User disables 2FA, logs in without token required (disable flow)
```

### Request: Reorganize phases

```markdown
Phase 2 includes both API endpoints and UI components. Please split into:
- Phase 2: API Layer (all endpoints, authentication logic)
- Phase 3: UI Layer (settings page, login form modifications)

This allows backend and frontend developers to work in parallel after Phase 1.
```

Task Planner incorporates your feedback and regenerates the affected sections. Continue refining until the plan is implementation-ready.

## When Planning is Complete

A plan is ready for implementation when it meets these criteria:

### Example: Implementation-ready specification

✅ **Every phase has clear prerequisites** - No circular dependencies, no assumed prerequisites  
✅ **Each step includes file locations** - Path + approximate line numbers  
✅ **Implementation details reference research findings** - Traceability to evidence  
✅ **Verification criteria are testable** - Concrete conditions, specific test cases  
✅ **Testing strategy covers three levels** - Unit + integration + manual verification  
✅ **Risk analysis identifies high-complexity steps** - No hidden surprises  
✅ **Rollback plan exists for destructive changes** - Safety net for database, config changes  

### Example: Implementation-ready step

```markdown
#### Step 2.3: Add TOTP verification to login endpoint
- **Location**: `src/auth/loginController.ts`, lines 78-120
- **Research reference**: Passport.js integration pattern (Research Section 3.3)
- **Implementation details**:
  - After password verification (line 95), check `user.twoFactorEnabled`
  - If true, require `req.body.totpToken` field (validate in loginValidator.ts)
  - Use `speakeasy.totp.verify({ secret: user.twoFactorSecret, token: req.body.totpToken, window: 1 })`
  - If verification fails, throw new AuthError('Invalid authentication code')
  - If verification succeeds, continue to session creation (line 105)
- **Verification**: 
  - Unit test: 2FA-enabled user with valid token succeeds
  - Unit test: 2FA-enabled user without token fails with 401
  - Unit test: 2FA-enabled user with invalid token fails with 401
  - Integration test: Full login flow with 2FA succeeds
- **Files modified**:
  - `src/auth/loginController.ts` (add 2FA verification logic)
  - `src/auth/validators/loginValidator.ts` (add optional totpToken field)
```

This step is implementation-ready. It has everything the implementer needs.

## Red Flags: Plans Needing More Work

❌ **Vague steps**: "Implement 2FA" (where? how? verify how?)  
❌ **Missing file references**: "Update the auth code" (which file?)  
❌ **No verification criteria**: "Test the feature" (test what specifically?)  
❌ **Unclear dependencies**: "Phase 2 can't start" without explaining what's missing  
❌ **Missing testing strategy**: How do you know implementation succeeded?  
❌ **No rollback plan**: What if Step 3.2 breaks production authentication?  
❌ **Invented details**: File paths or patterns not found in research  

When you spot these red flags, refine the plan before handing off to implementation.

## Exercise: Evaluate Plan Quality

Review this plan excerpt and identify issues:

```markdown
### Phase 2: Add 2FA

#### Step 2.1: Create endpoints
- Add setup endpoint
- Add verify endpoint
- Test endpoints

#### Step 2.2: Update login
- Modify login to check 2FA
- Add token verification
- Test login flow
```

**Issues to identify:**

1. Missing file locations
2. No research references
3. Vague implementation details
4. No concrete verification criteria
5. Missing files modified list

**Improved version** would include all five elements for each step, following the template from Section 3.

---

**Previous:** [Section 3: Plan Document Structure](./03-plan-document-structure.md)  
**Next:** [Section 5: Dependency Analysis and Phase Organization](./05-dependency-analysis-phase-organization.md)  
**Up:** [Chapter 7: Task Planner](./README.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
