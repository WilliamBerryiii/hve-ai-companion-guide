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

## Complete Example: Inventory Tracking and Analytics Merge

This realistic example demonstrates the workflow resolving a complex e-commerce feature conflict.

### Scenario Setup

**Feature branch:** `feature/inventory-tracking`

* Added inventory management for warehouse and dropship fulfillment
* Modified product creation flow to support inventory providers
* Updated product model with inventory fields
* Added inventory sync configuration

**Main branch (evolved during feature development):**

* Added product analytics for view tracking and reporting
* Modified product display to track views
* Updated product model with analytics fields
* Added analytics middleware

**Conflict situation:** 15 files with conflicts, including critical product code in `models/Product.js`, `routes/products.js`, `middleware/analytics.js`, and configuration files.

### Research Phase Example

### Task Researcher prompt

```markdown
Analyze merge conflict for inventory tracking feature merging into 
main branch with analytics support.

Branches:
- feature/inventory-tracking: Adds inventory management (warehouse, dropship)
- main: Added product analytics

Conflicted files:
- models/Product.js (product schema changes)
- routes/products.js (product flow modifications)
- middleware/analytics.js (tracking logic changes)
- config/inventory.config.js (configuration changes)
- [11 more files listed]

Research:
1. How inventory tracking and analytics should integrate
2. Product model schema combining both features
3. Product flow supporting both inventory and analytics
4. Data consistency considerations for combined implementation
5. Testing strategy for integrated product management
```

### Research document excerpt

The research reveals that inventory tracking and analytics can coexist. Products can have any inventory provider (warehouse, dropship, or direct), and all products can have analytics tracking enabled independently.

**Integration strategy:** Combined product flow assigns inventory provider during creation, then tracks analytics events on product views and interactions. The product model contains fields for both features without conflict.

**Resolution priority:** Start with `models/Product.js` as foundation, then `middleware/analytics.js` for tracking logic, then `routes/products.js` for routing, then configuration, then remaining files.

**Testing requirements:** Six product paths must work: warehouse product with analytics, warehouse product without analytics, dropship product with analytics, dropship product without analytics, direct product with analytics, direct product without analytics.

### Planning Phase Example

### Task Planner prompt

```markdown
Create resolution plan for inventory+analytics merge conflict.
Reference research: 20251117-inventory-analytics-merge-research.md.

Create plan following research priority order:
1. Product model (combine both schemas)
2. Analytics middleware (support tracking)
3. Product routes (integrated flow)
4. Configuration (combined settings)
5. Tests (comprehensive coverage)
```

### Plan document excerpt

#### File 1: models/Product.js

Conflict involves both branches modifying product schema. Resolution: Keep inventory fields (`inventoryProvider`, `inventoryId`, `stockLevel`) from feature branch and analytics fields (`viewCount`, `analyticsEnabled`, `lastViewedAt`) from main. Combine into single schema. Inventory provider can be null for direct-fulfillment products. All product types can have analytics enabled.

#### File 2: middleware/analytics.js

Conflict involves tracking logic. Resolution: Create combined flow that checks if analytics is enabled for the product, then records view events with inventory context. Preserve inventory status checks from feature branch and view tracking from main.

#### File 3: routes/products.js

Conflict involves route additions. Resolution: Keep inventory routes (`/products/:id/inventory`, `/products/:id/sync`, `/products/:id/stock`) from feature branch and analytics routes (`/products/:id/views`, `/products/:id/analytics`) from main. Modify `/products/:id` to return both inventory and analytics data.

The plan continues with detailed strategies for all 15 conflicted files.

### Implementation Phase Example

### Edit Mode prompt

```markdown
Resolve merge conflicts per plan.
Plan: 20251117-inventory-analytics-merge-plan.md
Research: 20251117-inventory-analytics-merge-research.md

Start with models/Product.js (first in priority order).

Show me the conflict, propose resolution combining both schemas, 
explain how fields interact.
```

### Edit Mode interaction

AI shows the conflict in `models/Product.js`:

```javascript
<<<<<<< HEAD (main - Analytics changes)
const productSchema = new Schema({
  name: String,
  sku: String,
  price: Number,
  description: String,
  viewCount: { type: Number, default: 0 },
  analyticsEnabled: { type: Boolean, default: false }
});
=======
const productSchema = new Schema({
  name: String,
  sku: String,
  price: Number,
  description: String,
  inventoryProvider: { type: String, enum: ['warehouse', 'dropship', null] },
  inventoryId: String
});
>>>>>>> feature/inventory-tracking
```

### AI proposes resolution

```javascript
const productSchema = new Schema({
  name: String,
  sku: String,
  price: Number,
  description: String,
  // Inventory fields (from feature branch)
  inventoryProvider: { type: String, enum: ['warehouse', 'dropship', null], default: null },
  inventoryId: String,
  stockLevel: { type: Number, default: 0 },
  // Analytics fields (from main)
  viewCount: { type: Number, default: 0 },
  analyticsEnabled: { type: Boolean, default: false },
  lastViewedAt: { type: Date, default: null }
});
```

**AI explains reasoning:** Inventory provider can be null for direct-fulfillment products. All products can have analytics tracking enabled regardless of inventory source. The `stockLevel` field tracks current inventory for warehouse and dropship products. The `lastViewedAt` field records the most recent view event. All fields coexist without conflict.

You review and approve. AI applies the resolution and moves to the next file.

This process continues through all 15 files with AI proposing resolutions and you maintaining control through approval.

### Testing and Validation

After resolving all conflicts, Edit Mode runs the test suite to verify integration:

```markdown
Edit Mode: "Run test suite to verify merge resolution"
```

Tests identify any integration issues. Edit Mode proposes fixes based on the new combined implementation.

### Manual testing checklist

* Create warehouse product with analytics enabled
* Create warehouse product without analytics
* Create dropship product with analytics enabled
* Create dropship product without analytics
* Create direct-fulfillment product with analytics
* Create direct-fulfillment product without analytics
* Inventory sync for warehouse products
* View tracking increments for analytics-enabled products

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
