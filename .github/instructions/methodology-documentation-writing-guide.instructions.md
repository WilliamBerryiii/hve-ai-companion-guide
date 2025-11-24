---
description: "Writing guide for methodology documentation in HVE AI Companion Guide - RPI variations and engineering patterns"
applyTo: 'docs/rpi-framework/*.md, docs/patterns/*.md'
---

# Methodology Documentation Writing Guide

## Scope

This guide defines writing standards for **methodology documentation** - systematic explanations of RPI variations (Core RPI, D-RPI, C-RPI, Mini-RPI, etc.) and reusable engineering patterns. Follow these instructions when creating or editing methodology documents that explain when and how to apply specific workflow patterns.

**Relationship to other guides:**
* **Markdown formatting:** Defer to `.github/instructions/markdown-styleguide.instructions.md` for technical syntax
* **General writing standards:** Defer to `.github/instructions/20251116-book-restructure-writing-guide.instructions.md` for voice and tone
* **This guide:** Defines methodology-specific structure, phase breakdown tables, pattern characteristics, and use-case scenarios

## Methodology Documentation Characteristics

**Purpose:** Explain RPI variations and engineering patterns with specific application guidance

**Target Audience:** Practitioners selecting and applying workflow patterns

**Depth Level:** Instructional/Reference

**Typical Length:** 2500-4500 words

> [!IMPORTANT]
> **Do NOT include time savings, cost savings, productivity metrics, or duration estimates in methodology documentation.** Focus exclusively on technical implementation details, pattern characteristics, RPI phase modifications, use-case scenarios, and validation criteria.

## Required Structure

### Frontmatter

```yaml
---
title: [Pattern Name] Pattern
description: [One-sentence description of pattern purpose and ideal scenario]
author: HVE Core Team
date: YYYY-MM-DD
keywords:
  - [pattern name]
  - [RPI variation if applicable]
  - [primary use case]
  - [key characteristic]
---
```

### Opening Section

```markdown
# [Pattern Name]

[2-3 paragraphs introducing the pattern]

[Paragraph 1: What this pattern accomplishes]

[Paragraph 2: Core innovation or key insight]

[Paragraph 3: When this pattern excels]
```

**Requirements:**
* Three-paragraph introduction: What → Why → When
* Focus on technical capabilities and application scenarios

<!-- <example-opening-section> -->
```markdown
# D-RPI (Discovery-Enhanced RPI)

Discovery-Enhanced RPI extends the standard RPI workflow with an upfront Discovery phase that systematically maps unfamiliar codebases before planning or implementation. This pattern eliminates the "brownfield friction" that causes standard RPI to stall in unknown territory.

The core insight: Attempting to plan implementation without understanding the existing architecture leads to false starts, rework, and frustration. D-RPI inverts this—systematic discovery of the codebase structure enables confident planning and implementation.

D-RPI excels when you're working in codebases you don't deeply understand, joining new teams, or tackling features that span unfamiliar subsystems.
```
<!-- </example-opening-section> -->

### When to Use This Pattern

```markdown
## When to Use [Pattern Name]

**Ideal scenarios:**
* [Specific scenario 1 with conditions]
* [Specific scenario 2 with conditions]
* [Specific scenario 3 with conditions]
* [Specific scenario 4 with conditions]

**Required prerequisites:**
* [Prerequisite 1]
* [Prerequisite 2]
* [Prerequisite 3]

**When NOT to use this pattern:**
* [Anti-scenario 1] → Use [Alternative] instead
* [Anti-scenario 2] → Use [Alternative] instead
* [Anti-scenario 3] → Use [Alternative] instead
```

**Requirements:**
* Ideal scenarios: 3-5 specific conditions (not abstract)
* Required prerequisites: Technical/knowledge requirements (2-4 items)
* When NOT to use: 2-4 anti-scenarios with alternatives
* Anti-scenarios must recommend specific alternative patterns

<!-- <example-when-to-use> -->
```markdown
## When to Use D-RPI

**Ideal scenarios:**
* Implementing features in codebases you joined within the last 3-6 months
* Working in legacy systems without current documentation
* Tackling features that span subsystems you haven't modified before
* Onboarding to a new team where you need to contribute quickly
* Investigating incidents in unfamiliar code paths

**Required prerequisites:**
* GitHub Copilot with GPT-4 access
* Read access to full codebase (not just feature branch)
* Ability to explore codebase without breaking changes

**When NOT to use this pattern:**
* **Familiar codebase with clear conventions** → Use Core RPI instead
* **Quick bug fixes in known code** → Use Mini-RPI instead
* **Well-documented greenfield project** → Use Core RPI (documentation replaces Discovery)
* **Critical production incident** → Use incident-specific workflow (discovery deferred)
```
<!-- </example-when-to-use> -->

### RPI Phase Mapping

```markdown
## RPI Phase Mapping

[Paragraph explaining how this pattern relates to core RPI phases]

```mermaid
graph LR
    A[Discovery] --> B[Research]
    B --> C[Plan]
    C --> D[Implement]
    style A fill:#8764b8,stroke:#6b4c9a,color:#fff
    style B fill:#0078d4,stroke:#005a9e,color:#fff
    style C fill:#00b294,stroke:#018574,color:#fff
    style D fill:#50e6ff,stroke:#0078d4,color:#000
```

[Paragraph explaining phase relationships and objectives]
```

**Requirements:**
* Brief explanation of phase structure
* Mermaid diagram showing phase flow
* Use standard RPI colors: Research (blue), Plan (teal), Implement (cyan)
* Add distinct color for variation-specific phases (e.g., Discovery purple)
* Explanatory text after diagram describing phase objectives

### Phase Breakdown Table

```markdown
## Phase-by-Phase Breakdown

| Phase | Chat Mode | Primary Goal | Key Activities |
|-------|-----------|--------------|----------------|
| [Phase 1] | [Mode name] | [Goal statement] | [Bulleted activities] |
| [Phase 2] | [Mode name] | [Goal statement] | [Bulleted activities] |
| [Phase 3] | [Mode name] | [Goal statement] | [Bulleted activities] |
| [Phase 4] | [Mode name] | [Goal statement] | [Bulleted activities] |

[Paragraph providing context or transitions between phases]
```

**Requirements:**
* Table with 4 columns: Phase, Chat Mode, Primary Goal, Key Activities
* One row per phase (3-5 phases typically)
* Chat mode specifies which Copilot mode
* Primary goal: single-sentence objective
* Key activities: 2-4 bulleted actions per phase

<!-- <example-phase-breakdown> -->
```markdown
## Phase-by-Phase Breakdown

| Phase | Chat Mode | Primary Goal | Key Activities |
|-------|-----------|--------------|----------------|
| **Discovery** | Ask Mode (Research) | Map codebase structure, identify key components, document conventions | • Identify entry points and dependencies<br>• Document architectural patterns<br>• Map naming conventions<br>• Create codebase mental model |
| **Research** | Ask Mode (Research) | Build evidence for implementation approach | • Analyze similar existing implementations<br>• Review related tests and mocks<br>• Document integration points<br>• Identify reusable patterns |
| **Plan** | Task Planner | Create structured implementation plan | • Define file modifications and additions<br>• Sequence implementation steps<br>• Identify validation checkpoints<br>• Document dependencies |
| **Implement** | Edit Mode | Execute plan with validation | • Generate code following plan<br>• Run tests after each change<br>• Validate integration points<br>• Address edge cases |

The Discovery phase frontloads the brownfield friction—systematic mapping of the codebase structure prevents false starts during Research and Plan. Once you understand the landscape, the remaining phases flow like Core RPI.
```
<!-- </example-phase-breakdown> -->

### Step-by-Step Application

```markdown
## Applying [Pattern Name]

### Phase 1: [Phase Name]

**Goal:** [Single-sentence objective]

**Chat mode:** [Mode name]

**Steps:**

1. **[Action 1]**
   
   [Detailed guidance on performing action 1]
   
   [Example prompt or command if applicable]

2. **[Action 2]**
   
   [Detailed guidance]

3. **[Action 3]**
   
   [Detailed guidance]

**Expected output:**
* [Deliverable 1]
* [Deliverable 2]
* [Deliverable 3]

**Validation:**
* [ ] [Checkpoint 1]
* [ ] [Checkpoint 2]
* [ ] [Checkpoint 3]

---

### Phase 2: [Phase Name]

[Repeat structure for each phase]
```

**Requirements:**
* One subsection per phase
* Each phase: Goal → Chat mode → Steps (3-6 steps) → Expected output → Validation
* Steps with numbered list and detailed guidance
* Example prompts/commands when helpful
* Expected output with 2-4 concrete deliverables
* Validation checkboxes (2-4 per phase)

### Real-World Example

```markdown
## Real-World Example: [Specific Scenario]

**Context:** [Realistic scenario description with specifics]

**Challenge:** [What makes this scenario difficult or interesting]

### Phase 1: [Phase Name]

[Detailed walkthrough showing actual inputs/outputs]

**Prompt:**
```text
[Actual prompt used]
```

**Result:**
[Concrete output showing what AI produced]

[Continue for each phase...]

**Outcome:**
* [Measurable result 1]
* [Measurable result 2]
* [Technical validation performed]
```

**Requirements:**
* Realistic scenario with specifics (not abstract example)
* Clear challenge statement
* Phase-by-phase walkthrough
* Actual prompts in code blocks
* Concrete outputs/results shown
* Measurable outcome focused on technical results

<!-- <example-real-world> -->
```markdown
## Real-World Example: Implementing OAuth Refresh Logic

**Context:** New team member tasked with adding token refresh to authentication flow in a 3-year-old Node.js API they joined two weeks ago. Codebase has 40+ auth-related files with inconsistent patterns.

**Challenge:** Understanding existing auth architecture, identifying refresh token storage strategy, and integrating refresh logic without breaking current flows.

### Phase 1: Discovery

**Prompt:**
```text
Map the authentication architecture in this codebase. I need to understand:
1. Where are auth tokens generated and stored?
2. What's the token lifecycle (creation, validation, expiration)?
3. Are refresh tokens already in use anywhere?
4. What are the naming conventions for auth-related modules?

Start with src/auth/ and src/middleware/ directories.
```

**Result:**
Copilot identified key files: `src/auth/JwtService.ts` (token generation), `src/auth/TokenRepository.ts` (storage), `src/middleware/AuthMiddleware.ts` (validation), and `src/auth/SessionManager.ts` (lifecycle). Discovered: refresh tokens are stored but not currently used—expired tokens result in logout.

### Phase 2: Research

**Prompt:**
```text
Based on the architecture discovered, analyze how I should implement token refresh:
1. Review JwtService.ts and TokenRepository.ts for refresh token generation patterns
2. Find similar "automatic retry" patterns in the codebase
3. Identify where token expiration is detected
4. Document integration points

Analyze: src/auth/JwtService.ts, src/auth/TokenRepository.ts, src/middleware/AuthMiddleware.ts
```

**Result:**
Research revealed: `JwtService.generateTokenPair()` already creates refresh tokens, `AuthMiddleware` detects expiration, pattern exists in `src/services/RetryService.ts` for automatic retries. Integration point: add refresh attempt before logout in `AuthMiddleware`.

### Phase 3: Plan

**Prompt:**
```text
Create implementation plan for token refresh:
1. Modify AuthMiddleware to attempt refresh before logout
2. Add refreshAccessToken() method to JwtService
3. Update TokenRepository with refresh validation
4. Add tests covering refresh success/failure paths

Files to modify: src/middleware/AuthMiddleware.ts, src/auth/JwtService.ts, src/auth/TokenRepository.ts
New files: test/auth/TokenRefresh.test.ts
```

**Result:**
Task Planner produced sequenced plan with 8 steps, 4 file modifications, 1 new test file with clear validation checkpoints.

### Phase 4: Implement

Applied plan in Edit Mode with validation after each change. All tests passed. Token refresh working.

**Outcome:**
* Feature completed successfully with systematic validation
* All tests passing (unit and integration)
* Zero false starts due to upfront Discovery phase
* Production-ready implementation following existing architectural patterns
```
<!-- </example-real-world> -->

### Pattern Comparison

```markdown
## Comparing [This Pattern] to Alternatives

[Paragraph explaining comparison context]

### vs [Alternative Pattern 1]

**Use [This Pattern] when:**
* [Condition 1]
* [Condition 2]
* [Condition 3]

**Use [Alternative] when:**
* [Different condition 1]
* [Different condition 2]

**Key difference:** [Fundamental distinction between patterns]

---

### vs [Alternative Pattern 2]

[Repeat structure for 2-3 comparison alternatives]
```

**Requirements:**
* Compare to 2-3 related or alternative patterns
* Each comparison: When to use this → When to use alternative → Key difference
* Focus on decision criteria (not feature comparison)
* Clear guidance for pattern selection

### Anti-Patterns and Limitations

```markdown
## Anti-Patterns and Limitations

### Common Mistakes

**Anti-pattern 1: [Mistake name]**

❌ **What not to do:** [Description of mistake]

**Why it fails:** [Explanation of problem]

✅ **Instead:** [Correct approach]

---

**Anti-pattern 2: [Another mistake]**

[Repeat structure for 3-4 anti-patterns]

### Pattern Limitations

**Limitation 1: [Constraint or weakness]**

[Explanation of limitation]

**Workaround:** [How to address or mitigate]

---

**Limitation 2: [Another limitation]**

[Repeat structure for 2-3 limitations]
```

**Requirements:**
* Common Mistakes: 3-4 anti-patterns with What/Why/Instead structure
* Pattern Limitations: 2-3 honest constraints with workarounds
* Use ❌/✅ formatting for visual clarity

### Related Patterns and Resources

```markdown
## Related Patterns

**Prerequisites:**
* [Pattern or concept 1](link) - [Why it's prerequisite]
* [Pattern or concept 2](link) - [Why it's prerequisite]

**Builds Into:**
* [Advanced pattern 1](link) - [How this enables it]
* [Advanced pattern 2](link) - [How this enables it]

**Complementary Patterns:**
* [Related pattern 1](link) - [Relationship]
* [Related pattern 2](link) - [Relationship]

**Practical Applications:**
* [Workflow 1](../workflows/workflow1.md) - [How pattern applies]
* [Workflow 2](../workflows/workflow2.md) - [How pattern applies]
```

**Requirements:**
* Four categories: Prerequisites, Builds Into, Complementary Patterns, Practical Applications
* 2-3 items per category
* Each item with relationship explanation
* Links to actual content

### Footer

```markdown
---

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
```

## Voice and Tone

**Voice:** Second-person instructional ("you'll apply", "your workflow")

**Tone:** Educational, pattern-focused, analytical, objective

**Sentence Style:** Clear explanations, systematic breakdowns, comparative guidance

**Example Opening:**
```markdown
# Mini-RPI Pattern

Mini-RPI streamlines the standard RPI workflow for quick fixes and small changes—removing planning overhead while maintaining evidence-based rigor. This pattern handles bugs, configuration updates, and minor feature adjustments in codebases you understand well.

The core tradeoff: Skip formal planning to move faster, but maintain research and validation to avoid introducing regressions. Mini-RPI works when the change scope is clear and the implementation path obvious.

Mini-RPI excels for developers who know their codebase intimately and need to handle small tasks efficiently without sacrificing quality.
```

## Phase Breakdown Table Format

**Standard columns:**
1. **Phase:** Phase name (bold)
2. **Chat Mode:** Specific Copilot mode (Ask Mode, Task Planner, Edit Mode)
3. **Primary Goal:** Single-sentence objective
4. **Key Activities:** Bulleted list (2-4 items)

**Chat mode values:**
* Ask Mode (Research)
* Ask Mode (Documentation)
* Task Planner
* Edit Mode
* Ask Mode (Review)

**Key activities formatting:**
* Use bullet characters (•) within table cell
* Use `<br>` for line breaks in markdown tables
* Keep activities concise (5-10 words each)
* Focus on deliverables, not process

## Pattern Comparison Format

**Decision-oriented structure:**

```markdown
## Comparing [This Pattern] to Alternatives

### vs [Alternative Pattern]

**Use [This Pattern] when:**
* [Specific condition]
* [Measurable criterion]
* [Situational factor]

**Use [Alternative Pattern] when:**
* [Different condition]
* [Different criterion]

**Key difference:** [One-sentence fundamental distinction]
```

**Guidelines:**
* Focus on when/why to choose, not feature comparison
* Use specific conditions (not "need advanced capabilities")
* Highlight key difference in bold
* Compare to 2-3 most likely alternatives

<!-- <example-pattern-comparison> -->
```markdown
## Comparing D-RPI to Alternatives

### vs Core RPI

**Use D-RPI when:**
* Working in codebases you've touched for less than 3-6 months
* Existing documentation is outdated or missing
* Feature spans unfamiliar subsystems
* Onboarding to new team requires fast contribution

**Use Core RPI when:**
* Codebase is familiar with clear conventions
* Documentation is current and comprehensive
* Feature implementation path is obvious
* Time constraint requires fastest possible execution

**Key difference:** D-RPI adds 20-30 minute Discovery phase to eliminate brownfield friction. Worth the investment in unfamiliar territory, unnecessary overhead in well-understood codebases.

---

### vs Mini-RPI

**Use D-RPI when:**
* Change spans multiple files or subsystems
* Codebase architecture is unclear
* Feature requires understanding existing patterns
* Implementation approach is uncertain

**Use Mini-RPI when:**
* Quick fix in well-understood code
* Single-file or highly localized change
* Implementation path is obvious

**Key difference:** Mini-RPI is streamlined Core RPI—skips formal planning for speed. D-RPI adds Discovery for unfamiliar codebases. If you don't know the codebase AND need speed, fix that with D-RPI first, then use Mini-RPI for subsequent quick fixes.
```
<!-- </example-pattern-comparison> -->

## Anti-Patterns and Limitations

**Anti-pattern structure:**
* Name the mistake clearly
* ❌ What not to do (description)
* Why it fails (explanation)
* ✅ Instead (correct approach)

**Limitation structure:**
* State limitation clearly
* Explain impact or constraint
* Provide workaround or mitigation

**Guidelines:**
* Address real mistakes practitioners make
* Be honest about pattern boundaries
* Offer actionable alternatives
* Don't create strawman anti-patterns

## Real-World Example Guidelines

**Characteristics of effective examples:**
* Realistic scenario with specifics (file names, technologies, constraints)
* Clear challenge (what makes this interesting)
* Phase-by-phase walkthrough with actual prompts
* Concrete outputs shown (not "AI produced a plan")
* Measurable outcome with time breakdown

**Structure:**
1. Context: Realistic scenario description
2. Challenge: What makes this difficult
3. Phase walkthrough: Actual prompts + concrete results
4. Outcome: Measurable results + time breakdown

**Show don't tell:**

❌ **Avoid:** "Copilot analyzed the codebase and suggested an approach"

✅ **Instead:** Show the prompt, show the response, show the specific files identified

## Mermaid Diagram Standards

**Phase flow diagrams:**
* Linear left-to-right (graph LR)
* Node labels: Phase name describing objective
* Standard RPI colors:
  * Research: Blue (`#0078d4`)
  * Plan: Teal (`#00b294`)
  * Implement: Cyan (`#50e6ff`)
  * Custom phases: Purple (`#8764b8`)
* Simple arrows (A --> B)
* Keep to 3-5 phases (avoid complexity)

<!-- <example-phase-diagram> -->
```markdown
```mermaid
graph LR
    A[Discovery] --> B[Research]
    B --> C[Plan]
    C --> D[Implement]
    style A fill:#8764b8,stroke:#6b4c9a,color:#fff
    style B fill:#0078d4,stroke:#005a9e,color:#fff
    style C fill:#00b294,stroke:#018574,color:#fff
    style D fill:#50e6ff,stroke:#0078d4,color:#000
```
```
<!-- </example-phase-diagram> -->

## Quality Checklist

Before submitting methodology documentation, verify:

### Structure

- [ ] YAML frontmatter complete (title, description, author, date, keywords)
- [ ] Three-paragraph introduction (What → Why → When)
- [ ] "When to Use" with ideal scenarios, prerequisites, when NOT to use
- [ ] RPI Phase Mapping with Mermaid diagram
- [ ] Phase Breakdown Table with all 5 columns
- [ ] Step-by-Step Application for each phase (Goal, Chat mode, Steps, Expected output, Validation)
- [ ] Real-World Example with context, challenge, phase walkthrough, outcome
- [ ] Pattern Comparison (vs 2-3 alternatives)
- [ ] Anti-Patterns and Limitations
- [ ] Related Patterns with Prerequisites, Builds Into, Complementary, Practical Applications
- [ ] Standard footer present

### Voice and Tone

- [ ] Second-person instructional voice ("you'll")
- [ ] Educational, pattern-focused, analytical tone
- [ ] Clear explanations without jargon
- [ ] Comparative guidance (when to use X vs Y)
- [ ] Objective assessment of tradeoffs

### Pattern Description

- [ ] Scenarios specific with conditions (not abstract)
- [ ] Anti-scenarios include alternative recommendations
- [ ] Prerequisites concrete and verifiable
- [ ] Phase breakdown includes chat modes, goals, activities
- [ ] Real-world example shows actual prompts and outputs

### Evidence-Based

- [ ] Real-world example includes measurable outcome
- [ ] Pattern limitations stated honestly
- [ ] Workarounds provided for limitations

### Navigation

- [ ] All internal links use correct relative paths
- [ ] Related Patterns provide clear navigation
- [ ] Pattern comparisons help readers choose
- [ ] Practical Applications link to workflows

### Formatting

- [ ] Heading hierarchy correct (H1 → H2 → H3)
- [ ] Phase breakdown table properly formatted
- [ ] Mermaid diagram uses standard colors
- [ ] Anti-patterns use ❌/✅ formatting
- [ ] Validation checklists with [ ] checkboxes
- [ ] Bold used for phase names, pattern names, key terms

## Anti-Patterns to Avoid

### 1. Vague Pattern Description

❌ **Avoid:** "Quick workflow" or "Comprehensive approach" without specifics

✅ **Instead:** Specific technical characteristics and use-case conditions

### 2. Abstract Scenarios

❌ **Avoid:** "Use when you need advanced capabilities"

✅ **Instead:** "Use when implementing features in codebases you joined within the last 3-6 months"

### 3. Missing Alternatives

❌ **Avoid:** "When NOT to use: When it doesn't fit"

✅ **Instead:** "When NOT to use: **Familiar codebase with clear conventions** → Use Core RPI instead"

### 4. Generic Examples

❌ **Avoid:** "Used pattern to implement feature successfully"

✅ **Instead:** Show specific scenario with file names, actual prompts, concrete outputs, technical validation

### 5. No Pattern Comparison

❌ **Avoid:** Describing pattern in isolation without comparison to alternatives

✅ **Instead:** Compare to 2-3 related patterns with decision criteria

### 6. Incomplete Phase Breakdown

❌ **Avoid:** Missing chat mode, primary goal, or key activities

✅ **Instead:** Complete table with all 4 columns for every phase

### 7. Missing Pattern Boundaries

❌ **Avoid:** Presenting pattern without clear applicability criteria

✅ **Instead:** Specific "When to Use" and "When NOT to Use" guidance with alternative recommendations

### 8. No Limitations

❌ **Avoid:** Presenting pattern as universally applicable

✅ **Instead:** Honest limitations with workarounds

## Standard Footer

```markdown
---

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
```
