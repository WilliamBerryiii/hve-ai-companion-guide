---
title: "RPI Variations Overview"
description: Learn four proven RPI workflow variations that adapt the basic pattern for complex real-world scenarios
author: HVE Core Team
ms.date: 2025-11-26
ms.topic: concept
chapter: 11
part: "II"
keywords:
  - rpi-variations
  - d-rpi
  - iterative-expansion
  - workflow-adaptation
---

## RPI Variations Overview

Basic RPI serves as your foundation: Research → Plan → Implement as a linear progression through distinct phases. This straightforward workflow handles most scenarios effectively when you have clear requirements, focused scope, and straightforward implementation paths.

But some situations demand adaptation. This section introduces four proven RPI variations that extend the basic workflow for complex scenarios you'll encounter in real projects.

## Standard RPI Review

The basic workflow you learned in Chapter 4 follows this pattern:

**Research phase:** Complete investigation before planning. Use Ask Mode for quick queries, Task Researcher for deep investigation, and ADR Creator to document decisions.

**Plan phase:** Create comprehensive three-document implementation plan using Task Planner. Reference research documents to inform planning decisions.

**Implement phase:** Execute the plan using Edit Mode for controlled changes or Agent Mode for autonomous implementation.

This linear progression works well when requirements are clear, scope is bounded to a single feature, and implementation follows straightforward technical patterns. One mode per phase delivers excellent results efficiently.

## When to Modify RPI Workflow

Four distinct problems signal you need a variation rather than standard RPI.

### Scope Uncertainty

**Indicators:**

Requirements are vague ("make it better" or "improve performance"). You don't know what to research yet because the problem space is unclear. Exploring the codebase must happen before research makes sense.

**Solution:** D-RPI (Discovery-first) adds an exploration phase before research.

### Implementation Risk

**Indicators:**

Large changes affect many components. High risk of introducing subtle bugs. You want to validate your approach quickly before committing to full implementation. Early feedback would prevent costly rework.

**Solution:** 1→3→All (iterative expansion) implements progressively across increasing scope.

### Control Requirements

**Indicators:**

You're working in critical production code. Every change requires careful review before execution. High quality standards demand understanding each modification. Regulatory or compliance needs create audit trail requirements.

**Solution:** Edit+RPI maintains strict control by using Edit Mode exclusively.

### Speed With Constraints

**Indicators:**

Large implementation task would benefit from AI autonomy. Specific patterns or constraints must be enforced throughout. You need Agent Mode's speed but with guidance to ensure correctness.

**Solution:** Agent+Ask combines autonomous execution with strategic direction.

## Variation 1: D-RPI (Discovery-First RPI)

D-RPI adds a Discovery phase before Research: Discovery → Research → Plan → Implement.

### When to Use D-RPI

Apply this variation when working with unfamiliar codebases where you don't yet understand the architecture, facing vague requirements that need clarification through exploration, or encountering situations where you don't know what questions to ask yet.

The Discovery phase explores before researching. You navigate the codebase using Ask Mode to understand current state, identify existing patterns and conventions, form questions that guide the Research phase, and refine requirements based on what you discover.

### D-RPI in Practice

Consider this request: "Improve the authentication flow."

Standard RPI faces immediate challenges. What does "improve" mean? What authentication flow currently exists? What are the pain points? You can't research solutions without understanding the current state.

D-RPI provides a systematic approach:

**Discovery phase** (15 minutes):

Use Ask Mode to explore: "Explain the current authentication flow." The AI describes the existing implementation. Ask "What authentication libraries are used?" to understand dependencies. Query "Show me recent auth-related bug reports" to identify problems.

Result: You discover the flow uses JWT, has token refresh issues, and lacks MFA support. Now you know what to research.

**Research phase** (20 minutes):

Task Researcher investigates JWT refresh best practices with concrete context. Another Task Researcher session explores MFA implementation options. ADR Creator documents your MFA approach decision with rationale.

**Plan phase** (15 minutes):

Task Planner creates an implementation plan for token refresh improvements based on research findings. Another plan addresses MFA implementation using the selected approach.

**Implement phase** (60 minutes):

Edit Mode executes both plans systematically.

### Discovery Phase Output

Effective Discovery creates specific artifacts that inform subsequent phases:

**Current state documentation** captures what exists now, including architecture, dependencies, and data flows.

**Constraints identified** lists technical limitations, compatibility requirements, and regulatory considerations discovered through exploration.

**Questions for research phase** provides specific topics to investigate rather than vague explorations.

**Refined requirements** translates vague requests into concrete objectives based on discovered context.

### D-RPI Benefits

This variation delivers three key advantages:

**Informed research:** You research specific topics rather than exploring broadly. Research sessions target known questions instead of fishing for answers.

**Better scoped planning:** Plans account for discovered constraints and current architecture. You avoid planning approaches that won't work in your context.

**Reduced rework:** Early discovery catches incompatibilities before they derail implementation. You don't build solutions that don't fit the actual codebase.

## Variation 2: 1→3→All (Iterative Expansion)

This variation implements through three successive RPI cycles with increasing scope:

**Cycle 1:** Implement one component to validate your approach.

**Cycle 2:** Expand to three components (easy, medium, hard) to confirm the pattern works across different complexity levels.

**Cycle 3:** Apply to all remaining components using your validated pattern.

### When to Use 1→3→All

Apply iterative expansion for large-scale changes affecting many components, situations where you're uncertain if your approach will work at scale, scenarios where you want validation before full commitment, or any change with risk of breaking multiple things simultaneously.

### Iteration Progression

Each cycle builds on learnings from the previous one.

**Cycle 1 proof of concept** chooses the simplest, safest component in your scope. Run a complete RPI cycle for just that one component. Verify your approach actually works in practice. Refine your plan based on what you learn during implementation.

**Cycle 2 pattern confirmation** selects three representative components: one easy (similar to Cycle 1), one medium complexity, and one hard case. Apply your refined approach from Cycle 1 to all three. Confirm the pattern works across different complexity levels. Document edge cases you discover along the way.

**Cycle 3 full rollout** applies your documented pattern to all remaining components. Handle edge cases using strategies established in Cycles 1 and 2. Execute with confidence knowing your approach has been validated.

### 1→3→All in Practice

Consider this request: "Migrate all React class components to functional components with hooks."

Your codebase contains 47 class components. Standard RPI faces significant risk. If your approach doesn't work, you've broken 47 components. Unknown edge cases make creating a complete upfront plan difficult.

**Cycle 1: Single component** (30 minutes)

Research hook equivalents for component lifecycle methods. Plan migration strategy for SimpleButton component. Implement the migration for just SimpleButton. Test to verify behavior hasn't changed.

Learning: You discover a state initialization pattern that differs from the documentation examples.

**Cycle 2: Three components** (60 minutes)

Apply refined strategy to SimpleButton (easy), DataTable (medium), and FormWizard (complex). Discover context usage patterns you hadn't anticipated. Learn about ref handling edge cases and lifecycle method equivalents. Document a migration playbook capturing all edge cases and solutions.

**Cycle 3: Remaining 44 components** (3 hours)

Follow your documented playbook systematically. Use Agent Mode for straightforward components that match established patterns. Use Edit Mode for complex edge cases requiring careful review. Complete all 47 component migrations with low risk because your approach has been validated.

### 1→3→All Benefits

Iterative expansion provides four crucial advantages:

**Early validation** catches problems with one component instead of 47. You discover issues when they're cheap to fix.

**Refined approach** learns from early cycles before full rollout. Your playbook improves as you encounter edge cases.

**Reduced risk** proves your pattern works before applying at scale. You avoid betting everything on an untested approach.

**Faster overall** execution because later cycles parallelize work with confidence. Agent Mode can handle bulk of straightforward cases once the pattern is proven.

## Variation 3: Edit+RPI (Controlled Implementation)

Edit+RPI follows standard Research → Plan → Implement flow but constrains implementation to Edit Mode only, never Agent Mode. You manually review every change before it executes.

### When to Use Edit+RPI

Apply controlled implementation when working in critical production codebases where failures have serious consequences, facing high quality requirements that demand understanding every change, learning new patterns where seeing each modification aids comprehension, or meeting regulatory or compliance requirements that mandate audit trails.

Edit Mode provides complete control. No autonomous execution occurs. You review every proposed change before applying it. Iterative refinement with AI improves suggestions. Full understanding comes from reviewing each modification.

### Edit+RPI in Practice

Consider this request: "Implement payment processing with Stripe."

Context makes control essential: financial transaction code must be correct. Agent Mode might make assumptions about error handling or security. Autonomous changes to financial code create unacceptable risk. You need to understand every line before it executes.

**Research phase** uses Task Researcher to investigate Stripe best practices, PCI compliance requirements, error handling patterns, and idempotency strategies. This creates comprehensive context for safe implementation.

**Plan phase** uses Task Planner to develop complete implementation plan, security checklist, and testing requirements. The plan provides structure but you'll verify each step during implementation.

**Implement phase** uses Edit Mode exclusively through systematic steps:

**Step 1** creates Stripe client configuration. AI proposes the change showing API key handling. You review for security issues like hardcoded keys or insecure storage. You approve the change or refine the approach before execution.

**Step 2** implements payment intent creation. AI proposes the implementation including error handling. You review for idempotency tokens, proper error handling, and security considerations. You approve or request improvements before proceeding.

**Step 3** adds webhook handling. AI proposes the webhook receiver implementation. You review for signature verification, replay attack prevention, and proper error responses. You approve each aspect before execution.

### Edit+RPI Benefits

Controlled implementation delivers four advantages in critical scenarios:

**Full control** means you review every change before execution. Nothing enters the codebase without your understanding and approval.

**Learning** comes from deeply understanding implementation details. Reviewing each change builds expertise rather than just accepting autonomous output.

**Quality** catches issues before they enter code. Your reviews identify problems the AI might miss in autonomous mode.

**Compliance** creates audit trails of all decisions. Each review and approval is documented for regulatory purposes.

**Trade-off acknowledged:** Edit+RPI is slower than Agent Mode. This is appropriate for critical code where speed matters less than correctness.

## Variation 4: Agent+Ask (Autonomous with Guidance)

Agent+Ask combines Agent Mode's autonomous execution with Ask Mode's strategic guidance: Research → Plan → Implement using Agent Mode, with Ask Mode providing constraints and course corrections.

### When to Use Agent+Ask

Apply this combination for large implementation tasks where AI can handle most work autonomously, but specific constraints or patterns must be enforced throughout, and you want Agent Mode's speed combined with directional control.

The technique starts Agent Mode implementation with your plan. Use Ask Mode to provide constraints, patterns, and specific requirements. Agent continues working autonomously within your guidance. Ask Mode provides course corrections when needed without stopping autonomous work.

### Agent+Ask in Practice

Consider this request: "Add comprehensive logging to all API endpoints."

Context: 30+ endpoints need consistent logging following specific formats.

Standard approaches have limitations. Agent Mode alone works fast but might not follow your logging format consistently. Edit Mode alone becomes tediously slow for repetitive changes across many endpoints.

**Research and Plan phases** document your required logging format precisely. Identify all endpoints needing updates. Create an implementation plan with clear specifications.

**Implement phase** uses Agent Mode with Ask Mode guidance:

Start with Agent Mode: "Implement logging for all API endpoints per plan."

Agent begins working through endpoints. You observe progress.

Use Ask Mode to provide precise format guidance: "For each endpoint, include Request ID, User ID, Timestamp, HTTP method and path, Status code, and Response time. Follow this format: [timestamp] [requestId] [userId] [method] [path] [status] [duration]ms"

Agent continues implementation applying your format specifications consistently.

Provide additional Ask Mode guidance for error cases: "For error cases, also log Error message, Stack trace, and User context. Use this format: [timestamp] [ERROR] [requestId] [userId] [method] [path] [error] [stack]"

Agent completes work across all endpoints with both normal and error case logging following your specifications.

### Agent+Ask Benefits

This combination delivers the best of both approaches:

**Speed of Agent Mode** through autonomous execution across many files. The bulk of work happens quickly without manual review of each change.

**Control from Ask Mode** through guidance and constraints you provide. Agent works within your specifications rather than making autonomous decisions about format and structure.

**Best of both worlds** by being fast and correct. You guide the work without slowing it down.

## Decision Framework: Selecting Your Variation

Use this framework to choose the right variation for your scenario.

### Selection Matrix

| Scenario                               | Standard RPI | D-RPI | 1→3→All | Edit+RPI | Agent+Ask |
|----------------------------------------|:------------:|:-----:|:-------:|:--------:|:---------:|
| Clear requirements, small scope        |      ✅       |   ❌   |    ❌    |    ❌     |     ❌     |
| Vague requirements, need exploration   |      ❌       |   ✅   |    ❌    |    ❌     |     ❌     |
| Large-scale changes, validation needed |      ❌       |   ❌   |    ✅    |    ❌     |     ❌     |
| Critical code, need control            |      ❌       |   ❌   |    ❌    |    ✅     |     ❌     |
| Large task, specific patterns          |      ❌       |   ❌   |    ❌    |    ❌     |     ✅     |

### Decision Questions

Ask these questions in order:

1. **Are requirements clear?** If no, use D-RPI to discover before researching.
2. **Is scope large with risk?** If yes, use 1→3→All to validate before scaling.
3. **Is code critical?** If yes, use Edit+RPI for full control.
4. **Large task with specific constraints?** If yes, use Agent+Ask for speed with guidance.
5. **Otherwise** use standard RPI.

### Combining Variations

Variations can be combined when scenarios have multiple characteristics:

**D-RPI + 1→3→All:** Discover the landscape first, then iterate implementation. Use Discovery to understand scope, then validate your approach progressively.

**D-RPI + Edit+RPI:** Discover current state, then implement with full control. Useful when exploring unfamiliar critical codebases.

**1→3→All + Agent+Ask:** Iterate with autonomous execution. Validate your pattern in Cycle 1 with Edit Mode, then use Agent+Ask for Cycles 2 and 3.

The framework provides starting points. Your judgment adapts patterns to specific project needs.

## Practice Exercise: Pattern Selection

Test your understanding by selecting the right variation for each scenario.

**Scenario A:** "Refactor our error handling across 85 API endpoints to use a new centralized error handler."

<details>
<summary>Recommended variation</summary>

**1→3→All** because scope is large (85 endpoints), risk is moderate (could break error handling), and you want validation before full rollout.

Optionally combine with **Agent+Ask** in Cycles 2 and 3 for speed after validating the pattern in Cycle 1.
</details>

**Scenario B:** "Figure out why our deployment pipeline is slow and fix it."

<details>
<summary>Recommended variation</summary>

**D-RPI** because requirements are vague ("figure out why"), you need to discover current pipeline structure before knowing what to research, and exploration must happen before meaningful research begins.
</details>

**Scenario C:** "Implement authentication for our financial transaction API using OAuth2 and JWT."

<details>
<summary>Recommended variation</summary>

**Edit+RPI** because code is critical (financial transactions), security requirements demand reviewing every change, and compliance may require audit trails.
</details>

**Scenario D:** "Add OpenAPI/Swagger documentation comments to all 120 API endpoints following our documentation standard."

<details>
<summary>Recommended variation</summary>

**Agent+Ask** because the task is large and repetitive (120 endpoints), AI can work autonomously for most, but specific documentation format must be enforced consistently.
</details>

> [!TIP]
> Real projects often combine variations. Start with this framework, then adapt based on what you learn during execution.

Now that you understand when and how to vary RPI, Section 3 teaches you to switch between modes strategically while preserving context and maintaining flow.

---

**Previous:** [Introduction](01-introduction-beyond-basic-rpi.md) | **Next:** [Mode Switching Strategies](03-mode-switching-strategies.md)
