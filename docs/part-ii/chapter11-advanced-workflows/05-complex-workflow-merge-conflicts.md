---
title: Complex Workflow - Merge Conflicts
description: Resolve merge conflicts efficiently using Task Researcher + Edit Mode workflow for systematic resolution
author: HVE Core Team
ms.date: 2025-11-19
ms.topic: how-to
keywords:
  - merge conflicts
  - git workflow
  - conflict resolution
  - AI-assisted development
  - task researcher mode
estimated_reading_time: 10
---

Feature branches that diverge from main for weeks often result in painful merge conflicts. Without AI assistance, complex merges can consume hours of careful manual resolution with high risk of mistakes.

This section teaches a systematic AI-assisted approach that can reduce resolution time substantially while improving accuracy.

## The Merge Conflict Challenge

Consider a realistic scenario: You developed a feature branch over two weeks. During that time, main evolved with other team changes. When you attempt to merge, you face 37 changed files with 15 conflicts scattered across critical code.

Traditional manual resolution might take 3-4 hours or more of careful work depending on complexity. An AI-assisted RPI workflow can often reduce this to 45-90 minutes for well-understood codebases while providing better understanding of both branches' intents.

**Why merge conflicts are difficult:**

* You must understand the purpose of changes in both branches
* Both sets of changes need preservation without breaking functionality
* Either feature could break if resolution is incorrect
* Pressure to merge quickly increases mistake risk
* Testing is required after resolution to verify correctness

## Traditional Merge Conflict Process

Manual resolution follows this time-intensive pattern:

### Step 1: Attempt merge (2 minutes)

Run `git merge main` and discover conflicts in 15 files.

### Step 2: Manual conflict resolution (3-4 hours)

For each conflicted file:

* Read conflict markers to understand competing changes
* Determine the intent of both modifications
* Decide which change to keep or how to combine them
* Edit the file manually to resolve markers
* Stage the file as resolved
* Move to next conflict

This process involves constant context switching between files and mental fatigue from complexity.

### Step 3: Test everything (30-45 minutes)

Run the complete test suite, perform manual testing, and fix any issues introduced by resolution decisions.

### Step 4: Commit the merge (2 minutes)

Total time: 3.5-4.5 hours with significant mental load.

**Common pain points:**

* Context switching between files loses continuity
* Forgetting the intent behind changes made days ago
* Accidentally removing important code from one branch
* Integration issues between separately resolved conflicts
* Mental fatigue from sustained complex decision-making

## AI-Assisted Merge Conflict Resolution

The RPI framework transforms merge conflict resolution from manual trial-and-error into systematic analysis and resolution.

### The Three-Phase Workflow

### Phase 1: Research (Task Researcher - 15 minutes)

Analyze both branches' intentions, identify the correct integration strategy, and document testing requirements.

### Phase 2: Plan (Task Planner - 10 minutes)

Prioritize resolution order based on dependencies, define strategy for each file, and specify the testing approach.

### Phase 3: Implement (Edit Mode - 30-40 minutes)

Resolve conflicts iteratively with AI guidance while maintaining full control through review and approval.

**Total time estimate:** typically 55-90 minutes compared to 3.5-4.5 hours or more for manual resolution.

### Phase 1: Research with Task Researcher

Task Researcher analyzes both branches to understand their purposes and identify how changes should integrate.

### Prompt structure: Research phase

```markdown
Task Researcher prompt: "Analyze merge conflict between feature branch 
and main. Context:
- Feature branch: [branch name], implements [feature description]
- Main branch changes: [describe what evolved on main]
- Conflicts in: [list conflicted files from git status]

Research these areas:
1. Purpose of changes in both branches
2. Integration strategy preserving both intents
3. Testing requirements after resolution
4. Potential issues to watch for during resolution"
```

### Research output provides

* Understanding of both branches' goals
* Recommended conflict resolution strategy
* Testing checklist for validation
* Warning about integration risks

This research phase prevents the common mistake of resolving conflicts without understanding what each branch was trying to accomplish.

### Phase 2: Planning with Task Planner

Task Planner uses research findings to create a systematic resolution plan.

### Prompt structure: Planning phase

```markdown
Task Planner prompt: "Create plan for resolving merge conflicts.
Reference research document [path].

Conflicts to resolve:
[Paste output from git status showing conflicted files]

Create plan that:
1. Prioritizes resolution order (dependencies first)
2. Defines resolution strategy per file
3. Identifies integration points requiring careful handling
4. Specifies testing approach"
```

### Plan output includes

* Resolution order accounting for file dependencies
* Strategy for each conflict type
* Integration validation steps
* Comprehensive testing approach

The plan ensures you resolve foundation files before dependent files, reducing rework from resolution order mistakes.

### Phase 3: Implementation with Edit Mode

Edit Mode resolves conflicts iteratively with your approval at each step.

### Prompt structure: Implementation phase

```markdown
Edit Mode prompt: "Resolve merge conflicts per plan. Reference:
- Plan: [plan document path]
- Research: [research document path]

Start with first file from plan: [filename]

For each conflict:
1. Show current conflict with markers
2. Propose resolution preserving both branches' intent
3. Explain reasoning for proposed resolution
4. Apply after my approval"
```

### Iterative resolution process

* AI shows one conflict at a time
* AI proposes resolution with explanation
* You review and approve or request adjustment
* AI applies resolution and moves to next conflict
* Pattern repeats until all conflicts resolved

This controlled approach prevents the AI from making autonomous decisions about critical integration logic while still providing intelligent guidance.

## Complete Example: OAuth and Two-Factor Authentication Merge

This realistic example demonstrates the workflow resolving a complex authentication feature conflict.

### Scenario Setup

**Feature branch:** `feature/oauth-login`

* Added OAuth authentication for Google and GitHub
* Modified login flow to support OAuth
* Updated user model with OAuth fields
* Added OAuth configuration

**Main branch (evolved during feature development):**

* Added two-factor authentication support
* Modified login flow for 2FA verification
* Updated user model with 2FA fields
* Added security middleware

**Conflict situation:** 15 files with conflicts, including critical authentication code in `models/User.js`, `routes/auth.js`, `middleware/auth.js`, and configuration files.

### Research Phase Example

### Task Researcher prompt

```markdown
Analyze merge conflict for OAuth authentication feature merging into 
main branch with 2FA support.

Branches:
- feature/oauth-login: Adds OAuth (Google, GitHub)
- main: Added 2FA support

Conflicted files:
- models/User.js (user schema changes)
- routes/auth.js (login flow modifications)
- middleware/auth.js (authentication logic changes)
- config/auth.config.js (configuration changes)
- [11 more files listed]

Research:
1. How OAuth and 2FA should integrate
2. User model schema combining both features
3. Login flow supporting both OAuth and 2FA
4. Security considerations for combined implementation
5. Testing strategy for integrated authentication
```

### Research document excerpt

The research reveals that OAuth and 2FA can coexist. Users can authenticate via OAuth or password, and both types can optionally enable 2FA for additional security.

**Integration strategy:** Combined login flow checks authentication method first (OAuth vs password), then applies 2FA if enabled for that user. The user model contains fields for both features without conflict.

**Resolution priority:** Start with `models/User.js` as foundation, then `middleware/auth.js` for core logic, then `routes/auth.js` for routing, then configuration, then remaining files.

**Testing requirements:** Four authentication paths must work: OAuth without 2FA, OAuth with 2FA, password without 2FA, password with 2FA.

### Planning Phase Example

### Task Planner prompt

```markdown
Create resolution plan for OAuth+2FA merge conflict.
Reference research: 20251117-oauth-2fa-merge-research.md.

Create plan following research priority order:
1. User model (combine both schemas)
2. Auth middleware (support both methods)
3. Auth routes (integrated flow)
4. Configuration (combined settings)
5. Tests (comprehensive coverage)
```

### Plan document excerpt

#### File 1: models/User.js

Conflict involves both branches modifying user schema. Resolution: Keep OAuth fields (`oauthProvider`, `oauthId`) from feature branch and 2FA fields (`twoFactorSecret`, `twoFactorEnabled`) from main. Combine into single schema. Password field can be null for OAuth users. Both authentication types can use 2FA.

#### File 2: middleware/auth.js

Conflict involves authentication logic. Resolution: Create combined flow that verifies session, checks authentication method (OAuth or password), then checks if 2FA verification is required and completed. Preserve OAuth verification from feature branch and 2FA check from main.

#### File 3: routes/auth.js

Conflict involves route additions. Resolution: Keep OAuth routes (`/auth/google`, `/auth/github`, `/auth/callback`) from feature branch and 2FA routes (`/auth/2fa/setup`, `/auth/2fa/verify`) from main. Modify `/auth/login` to handle both methods.

The plan continues with detailed strategies for all 15 conflicted files.

### Implementation Phase Example

### Edit Mode prompt

```markdown
Resolve merge conflicts per plan.
Plan: 20251117-oauth-2fa-merge-plan.md
Research: 20251117-oauth-2fa-merge-research.md

Start with models/User.js (first in priority order).

Show me the conflict, propose resolution combining both schemas, 
explain how fields interact.
```

### Edit Mode interaction

AI shows the conflict in `models/User.js`:

```javascript
<<<<<<< HEAD (main - 2FA changes)
const userSchema = new Schema({
  username: String,
  email: String,
  password: String,
  twoFactorSecret: String,
  twoFactorEnabled: { type: Boolean, default: false }
});
=======
const userSchema = new Schema({
  username: String,
  email: String,
  password: String,
  oauthProvider: { type: String, enum: ['google', 'github', null] },
  oauthId: String
});
>>>>>>> feature/oauth-login
```

### AI proposes resolution

```javascript
const userSchema = new Schema({
  username: String,
  email: String,
  password: String,
  // OAuth fields (from feature branch)
  oauthProvider: { type: String, enum: ['google', 'github', null] },
  oauthId: String,
  // 2FA fields (from main)
  twoFactorSecret: String,
  twoFactorEnabled: { type: Boolean, default: false },
  twoFactorVerified: { type: Boolean, default: false }
});
```

**AI explains reasoning:** Password can be null for OAuth users. OAuth users can enable 2FA for extra security. The `twoFactorVerified` field tracks whether the current session passed 2FA challenge. All fields coexist without conflict.

You review and approve. AI applies the resolution and moves to the next file.

This process continues through all 15 files with AI proposing resolutions and you maintaining control through approval.

### Testing and Validation

After resolving all conflicts, Edit Mode runs the test suite to verify integration:

```markdown
Edit Mode: "Run test suite to verify merge resolution"
```

Tests identify any integration issues. Edit Mode proposes fixes based on the new combined implementation.

### Manual testing checklist

* OAuth login with Google provider
* OAuth login with GitHub provider
* Password-based login
* 2FA setup for password user
* 2FA setup for OAuth user
* Login with 2FA (password authentication)
* Login with 2FA (OAuth authentication)
* Logout for both authentication types

### Results

The systematic approach resolved all conflicts in approximately 45 minutes compared to an estimated 3.5 hours for manual resolution. Both features were preserved and correctly integrated. The test suite passed. The AI caught potential integration issues that might have been missed in rushed manual resolution.

## Why This Workflow Works

**Systematic analysis replaces guessing:** Research phase prevents resolving conflicts without understanding branch intentions.

**Prioritization reduces rework:** Planning phase establishes dependency-aware resolution order. Foundation files are resolved before dependent files.

**Controlled iteration maintains quality:** Edit Mode provides AI guidance while you maintain approval authority over each resolution decision.

**Context preservation across files:** Research and plan documents provide consistent context as you move between conflicted files, preventing the context-switching mental fatigue of manual resolution.

**Testing validation:** Explicit testing phase in the plan catches integration issues early.

---

**Previous:** [Beads Workflow Fundamentals](./04-beads-workflow-fundamentals.md) | **Next:** [Complex Workflow: TDD with AI](./06-complex-workflow-tdd-with-ai.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
