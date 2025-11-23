---
description: "Writing guide for workflow guides in HVE AI Companion Guide - step-by-step application instructions for specific engineering scenarios"
applyTo: 'docs/workflows/*.md'
---

# Workflow Guide Writing Guide

## Scope

This guide defines writing standards for **workflow guides** - step-by-step instructions applying RPI patterns to specific engineering scenarios like merge conflict resolution, test suite generation, or onboarding new team members. Follow these instructions when creating or editing workflow documentation.

**Relationship to other guides:**
* **Markdown formatting:** Defer to `.github/instructions/markdown-styleguide.instructions.md` for technical syntax
* **General writing standards:** Defer to `.github/instructions/20251116-book-restructure-writing-guide.instructions.md` for voice and tone
* **This guide:** Defines workflow-specific structure, prerequisite checklists, troubleshooting tables, and validation criteria

## Workflow Guide Characteristics

**Purpose:** Provide complete worked examples applying RPI to specific engineering problems

**Target Audience:** Practitioners executing specific scenarios

**Depth Level:** Procedural/Step-by-Step

**Typical Length:** 2000-3500 words

> [!IMPORTANT]
> **Do NOT include time savings, cost savings, productivity metrics, or duration estimates in workflow guides.** Focus exclusively on technical steps, mode switching, validation criteria, troubleshooting solutions, and outcome verification.

## Required Structure

### Frontmatter

```yaml
---
title: [Scenario Name] Workflow
description: [One-sentence description of problem solved and RPI pattern used]
author: HVE Core Team
date: YYYY-MM-DD
keywords:
  - [scenario type]
  - [RPI pattern]
  - [primary technology]
  - [workflow category]
---
```

### Opening Section

```markdown
# [Scenario Name]

**Workflow Type:** [Category like "Code Quality", "Incident Response", "Feature Development"]

**RPI Pattern:** [Core RPI | D-RPI | Mini-RPI | etc.]

[2-3 paragraphs establishing scenario and challenge]

[Paragraph 1: Describe the scenario and problem]

[Paragraph 2: Why this scenario is challenging traditionally]

[Paragraph 3: How RPI transforms this scenario]
```

**Requirements:**
* Workflow Type categorizes scenario
* RPI Pattern identifies which variation applies
* Three-paragraph introduction: Scenario → Challenge → Solution

<!-- <example-workflow-opening> -->
```markdown
# Merge Conflict Resolution

**Workflow Type:** Code Quality

**RPI Pattern:** Core RPI

You're merging a feature branch that's been in development for two weeks. The merge reveals 12 conflicts spanning 8 files—some in core business logic, others in configuration and tests. Traditional approaches require manually examining each conflict, understanding the intent of both changes, and synthesizing a resolution that preserves functionality.

This scenario is challenging because conflicts often involve code you didn't write, require understanding both branches' intentions, and demand validation that the resolution preserves correctness. Mistakes introduce subtle bugs that surface days or weeks later.

The RPI approach transforms conflict resolution into a systematic evidence-gathering workflow: research both branches' intentions, plan conflict resolution strategy, implement with validation. This structured approach improves correctness through comprehensive analysis and validation.
```
<!-- </example-workflow-opening> -->

### Prerequisites Checklist

```markdown
## Prerequisites

**Required:**
* ✅ [Prerequisite 1 with specific version or access requirement]
* ✅ [Prerequisite 2]
* ✅ [Prerequisite 3]

**Recommended:**
* ○ [Optional prerequisite 1]
* ○ [Optional prerequisite 2]
* ○ [Optional prerequisite 3]

> [!IMPORTANT]
> [Critical prerequisite warning or setup note]
```

**Requirements:**
* Bifurcate prerequisites: Required vs Recommended
* Use ✅ for required items (checkbox metaphor)
* Use ○ for recommended items (hollow circle)
* 3-5 required prerequisites with specifics
* 2-3 recommended prerequisites
* IMPORTANT callout for critical setup note

<!-- <example-prerequisites> -->
```markdown
## Prerequisites

**Required:**
* ✅ GitHub Copilot with GPT-4 access (verify in VS Code settings)
* ✅ Git repository with merge conflict (or ability to simulate one)
* ✅ Test suite that validates affected code paths
* ✅ Ability to run tests locally (not just CI/CD)

**Recommended:**
* ○ Familiarity with codebase conventions (speeds Research phase)
* ○ Understanding of branching strategy (helps assess scope)
* ○ Access to PR context (comments, review feedback)

> [!IMPORTANT]
> Before starting, ensure you can run the test suite successfully on both branches independently. Conflict resolution without test validation is guesswork.
```
<!-- </example-prerequisites> -->

### RPI Pattern Overview

```markdown
## RPI Pattern: [Pattern Name]

This workflow uses **[Pattern Name]** - [one-sentence pattern description].

**Phase structure:**

```mermaid
graph LR
    A[Research] --> B[Plan]
    B --> C[Implement]
    style A fill:#0078d4,stroke:#005a9e,color:#fff
    style B fill:#00b294,stroke:#018574,color:#fff
    style C fill:#50e6ff,stroke:#0078d4,color:#000
```

[Brief paragraph explaining how pattern applies to this scenario]

[Learn more about Core RPI Pattern →](../../docs/rpi-framework/core-rpi.md)
```

**Requirements:**
* Pattern identification with link to pattern documentation
* Simple Mermaid diagram showing phase flow
* Brief application explanation (2-3 sentences)
* Link to detailed pattern documentation

### Phase-by-Phase Walkthrough

```markdown
## Phase 1: Research

**Goal:** [Single-sentence phase objective]

**Chat Mode:** Ask Mode (Research)

### Steps

1. **[Action 1]**
   
   [Detailed instruction for action 1]
   
   **Prompt:**
   ```text
   [Actual prompt to use]
   ```
   
   **Expected result:**
   [What Copilot should produce]

2. **[Action 2]**
   
   [Detailed instruction]
   
   **Prompt:**
   ```text
   [Actual prompt]
   ```
   
   **Expected result:**
   [Expected output]

3. **[Continue for 3-6 steps]**

### Expected Outputs

* [Concrete deliverable 1]
* [Concrete deliverable 2]
* [Concrete deliverable 3]

### Validation Checklist

* [ ] [Checkpoint 1 - specific and verifiable]
* [ ] [Checkpoint 2 - specific and verifiable]
* [ ] [Checkpoint 3 - specific and verifiable]

> [!TIP]
> [Helpful tip for this phase - timing, common pitfall, or optimization]

---

## Phase 2: Plan

[Repeat structure for each phase]
```

**Requirements:**
* One major section per RPI phase (Research, Plan, Implement, etc.)
* Each phase section includes:
  * Goal: Single-sentence objective
  * Chat Mode: Specific Copilot mode
  * Steps: Numbered list with 3-6 detailed actions
  * Each step: Instruction → Prompt (in code block) → Expected result
  * Expected Outputs: 2-4 concrete deliverables
  * Validation Checklist: 2-4 checkboxes with specific criteria
  * TIP or NOTE callout with phase-specific guidance

<!-- <example-phase-walkthrough> -->
```markdown
## Phase 1: Research

**Goal:** Understand the intent behind conflicting changes in both branches

**Chat Mode:** Ask Mode (Research)

### Steps

1. **Identify conflict scope**
   
   Before diving into specific conflicts, understand which files are affected and categorize by conflict type (logic, configuration, tests).
   
   **Prompt:**
   ```text
   Analyze the merge conflict in this pull request:
   - List all conflicted files
   - Categorize conflicts: business logic, configuration, tests, documentation
   - Identify which conflicts are related (same feature/component)
   
   Focus on: [list conflicted files]
   ```
   
   **Expected result:**
   Categorized list showing 8 files with 12 conflicts grouped by type and relationship.

2. **Research feature branch intentions**
   
   Understand what the feature branch was trying to accomplish in each conflicted area.
   
   **Prompt:**
   ```text
   For each conflicted file, analyze the feature branch changes:
   - What functionality is being added or modified?
   - What's the architectural approach?
   - Are there related changes in non-conflicted files that provide context?
   
   Analyze commits in feature branch touching: [conflicted files]
   ```
   
   **Expected result:**
   Summary of feature branch intentions for each conflict area with supporting evidence from commit messages and related changes.

3. **Research main branch context**
   
   Understand what changed on main branch since feature branch diverged.
   
   **Prompt:**
   ```text
   For the same conflicted files, analyze main branch changes:
   - What was modified and why? (review commit messages)
   - Are these bug fixes, refactorings, or new features?
   - Do main branch changes invalidate feature branch assumptions?
   
   Compare: feature-branch...main for files: [conflicted files]
   ```
   
   **Expected result:**
   Understanding of main branch evolution and whether conflicts are trivial (formatting) or substantive (logic changes).

### Expected Outputs

* Conflict categorization document (logic vs config vs tests)
* Feature branch intention summary for each conflict
* Main branch context explaining divergence
* Assessment of conflict complexity (trivial, moderate, complex)

### Validation Checklist

* [ ] All conflicted files categorized by type
* [ ] Feature branch intentions documented with evidence (commits, related changes)
* [ ] Main branch changes understood (not just surface diff)
* [ ] Conflict complexity assessed (know which are simple vs challenging)

> [!TIP]
> Spend 60% of Research phase on logic conflicts, 30% on tests, 10% on config. Business logic conflicts require the deepest understanding, configuration conflicts are usually straightforward.
```
<!-- </example-phase-walkthrough> -->

### Complete Example Walkthrough

```markdown
## Complete Example: [Specific Scenario]

**Scenario context:** [Detailed realistic scenario with specifics]

**Starting state:**
* [Initial condition 1]
* [Initial condition 2]
* [Initial condition 3]

---

### Research Phase: Understanding the Conflict

**Prompt:**
```text
[Actual prompt used]
```

**Copilot response:**
```text
[Actual response showing key findings]
```

**Key findings:**
* [Finding 1]
* [Finding 2]

---

### Plan Phase: Resolution Strategy

**Prompt:**
```text
[Actual prompt]
```

**Copilot response:**
```text
[Actual plan generated]
```

**Plan summary:**
* [Step 1]
* [Step 2]

---

### Implement Phase: Executing Resolution

**Prompt:**
```text
[Actual prompt]
```

**Changes made:**
* [Change 1 with file:line]
* [Change 2 with file:line]

**Validation results:**
* [Test result 1]
* [Test result 2]

---

**Outcome:**
* ✅ All 12 conflicts resolved
* ✅ 247 tests passing
* ✅ No regressions introduced
* ✅ Systematic validation performed throughout
```

**Requirements:**
* Realistic scenario with specific details
* Starting state clearly established
* Phase-by-phase walkthrough with actual prompts
* Copilot responses shown (not summarized)
* Key findings, plan steps, changes documented
* Outcome section with:
  * Checkboxes showing success criteria met
  * Technical validation performed

### Troubleshooting Guide

```markdown
## Troubleshooting

Common issues and solutions when following this workflow:

| Issue | Likely Cause | Solution |
|-------|--------------|----------|
| [Problem 1] | [Root cause explanation] | [Step-by-step fix with commands or prompts] |
| [Problem 2] | [Root cause] | [Solution] |
| [Problem 3] | [Root cause] | [Solution] |
| [Problem 4] | [Root cause] | [Solution]

> [!WARNING]
> [Critical warning about common dangerous mistake]
```

**Requirements:**
* Table with 4-6 common issues
* Three columns: Issue, Likely Cause, Solution
* Issue: Specific problem description (not vague)
* Likely Cause: Root cause explanation
* Solution: Step-by-step fix with commands/prompts
* WARNING callout for critical mistake pattern

<!-- <example-troubleshooting> -->
```markdown
## Troubleshooting

Common issues and solutions when following this workflow:

| Issue | Likely Cause | Solution |
|-------|--------------|----------|
| **Copilot suggests "accept incoming" without analysis** | Insufficient context provided—Copilot defaulting to safe generic advice | Provide file-level context: "Analyze both versions in `src/auth/AuthService.ts` lines 45-67, explain intentions, recommend resolution preserving both requirements" |
| **Tests pass but behavior seems wrong** | Conflict resolved syntactically but not semantically—logic from both branches not integrated | Return to Research phase: "Compare expected behavior from feature branch tests vs main branch tests. Are both requirements preserved?" |
| **Resolution introduces new conflicts** | Resolved conflict in one file exposes integration issues in related files | Expand scope: "Analyze files that import `AuthService.ts`—do they need updates to match resolution?" |
| **Too many conflicts to analyze efficiently** | Attempting to resolve all conflicts in single workflow—cognitive overload | Break into smaller PRs: Resolve conflicts by category (config first, then tests, then logic) in separate passes |
| **Uncertain which branch's approach is correct** | Both branches make reasonable but incompatible changes | Escalate: Involve original authors or tech lead. Document both approaches in PR comment, request decision before resolving. |

> [!WARNING]
> Never resolve conflicts by blindly accepting one side without understanding both intentions. This introduces regressions that surface later under specific conditions. Always validate resolution with tests covering both branches' requirements.
```
<!-- </example-troubleshooting> -->

### Validation Checklist

```markdown
## Final Validation

Before considering this workflow complete, verify:

**Functional Correctness:**
* [ ] [Specific validation 1]
* [ ] [Specific validation 2]
* [ ] [Specific validation 3]

**Code Quality:**
* [ ] [Quality check 1]
* [ ] [Quality check 2]
* [ ] [Quality check 3]

**Integration:**
* [ ] [Integration check 1]
* [ ] [Integration check 2]

**Documentation:**
* [ ] [Documentation check 1]
* [ ] [Documentation check 2]

> [!NOTE]
> [Guidance on when to consider workflow complete vs when to iterate]
```

**Requirements:**
* Four categories: Functional Correctness, Code Quality, Integration, Documentation
* 2-4 checkboxes per category
* Each checkbox specific and verifiable (not vague)
* NOTE callout with completion criteria

### Related Workflows and Resources

```markdown
## Related Workflows

**Prerequisites:**
* [Workflow or concept 1](link) - [Why it's prerequisite]
* [Workflow or concept 2](link) - [Why it's prerequisite]

**Next Steps:**
* [Follow-up workflow 1](link) - [How it builds on this]
* [Follow-up workflow 2](link) - [How it builds on this]

**Related Scenarios:**
* [Similar workflow 1](link) - [Similarity and difference]
* [Similar workflow 2](link) - [Similarity and difference]

**Pattern Documentation:**
* [RPI Pattern](../rpi-framework/pattern.md) - [How pattern applies]
* [Chat Mode Guide](../chat-modes/mode.md) - [Modes used in workflow]
```

**Requirements:**
* Four categories: Prerequisites, Next Steps, Related Scenarios, Pattern Documentation
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

**Voice:** Second-person imperative ("analyze the conflict", "create a plan", "validate results")

**Tone:** Step-by-step, practical, action-oriented, supportive

**Sentence Style:** Clear instructions, direct commands, helpful context

**Example Opening:**
```markdown
# Test Suite Generation for Legacy Code

**Workflow Type:** Code Quality

**RPI Pattern:** D-RPI (Discovery + Core RPI)

You've inherited a 2000-line service with zero test coverage. The code works in production, but any modification risks breaking undocumented assumptions. Your task: generate a comprehensive test suite that captures current behavior before refactoring begins.

This scenario is challenging because legacy code often lacks clear boundaries, depends on undocumented state, and includes edge cases discovered through production failures. Writing tests requires reverse-engineering the implementation to understand intended behavior.

The D-RPI approach transforms this: systematically discover the code's structure and dependencies, research existing behavior patterns, plan test coverage strategy, implement tests with validation. This structured approach produces more comprehensive coverage than ad-hoc manual testing.
```

## Prerequisites Checklist Format

**Bifurcated structure:**
* **Required** with ✅ (critical prerequisites)
* **Recommended** with ○ (helpful but not blocking)

**Required prerequisites should:**
* Be truly blocking (workflow fails without them)
* Include specific versions or access requirements
* Be verifiable (reader can check before starting)

**Recommended prerequisites should:**
* Speed execution or improve outcomes
* Not block workflow if missing
* Provide context for when they matter

## Phase Walkthrough Structure

**Each phase section must include:**
1. **Goal:** Single-sentence objective
2. **Chat Mode:** Specific Copilot mode (Ask Mode, Task Planner, Edit Mode)
3. **Steps:** Numbered list (3-6 steps) with:
   * Instruction paragraph
   * **Prompt:** in code block
   * **Expected result:** concrete description
5. **Expected Outputs:** 2-4 concrete deliverables
6. **Validation Checklist:** 2-4 checkboxes
7. **TIP or NOTE callout:** Phase-specific guidance

**Prompt formatting:**
* Use triple-backtick code blocks with `text` language
* Include actual prompts that work (not placeholders)
* Show full prompt text (don't abbreviate)
* Use specific file paths and variables in prompts

**Expected result formatting:**
* Describe concrete output (not "Copilot will help")
* Include what to look for in response
* Mention red flags if output is wrong

## Troubleshooting Table Guidelines

**Purpose:** Address common failure modes practitioners encounter

**Table structure:**
* **Issue:** Specific problem (not "things don't work")
* **Likely Cause:** Root cause explanation (not just symptom)
* **Solution:** Step-by-step fix with commands or prompts

**Issue characteristics:**
* Observable problem (reader can recognize it)
* Specific (not vague)
* Common (happens to practitioners)

**Solution characteristics:**
* Actionable (step-by-step)
* Include commands or prompts when applicable
* Fix root cause, not just symptom

<!-- <example-troubleshooting-detailed> -->
```markdown
| Issue | Likely Cause | Solution |
|-------|--------------|----------|
| **Generated tests fail immediately** | Copilot doesn't understand test setup/teardown requirements | **Prompt:** "Analyze existing tests in `test/services/` directory. Document: 1) Test setup patterns, 2) Mock/stub conventions, 3) Assertion library usage. Use these patterns for new tests." Then regenerate tests with context. |
| **Tests pass but don't test real behavior** | Tests mock too much—validating mock behavior not actual code | Review mocks: "For each test, identify what's mocked. Are we testing real service logic or just mock returns?" Reduce mocking to external dependencies only. |
| **Coverage metric high but edge cases missing** | Tests focus on happy path—Copilot didn't analyze error handling | **Prompt:** "Analyze error handling in `src/services/LegacyService.ts`. What exceptions can be thrown? What validation failures exist? Generate tests for each error path." Add error case tests. |
| **Tests are too slow (minutes to run)** | Tests hitting real databases or external services | Identify slow tests: `npm test -- --verbose`. For each, replace real dependencies with mocks. **Prompt:** "This test hits real database. Create mock implementation preserving behavior but removing DB dependency." |
```
<!-- </example-troubleshooting-detailed> -->

## Complete Example Requirements

**Starting state:**
* Realistic scenario with specific details
* Initial conditions clearly listed
* Context sufficient to understand challenge

**Phase walkthrough:**
* Show actual prompts (not summarized)
* Show Copilot responses (actual text or meaningful excerpts)
* Document key findings, decisions, changes
* Use code block formatting for prompts and responses

**Outcome section:**
* Checkboxes showing success criteria met
* Technical validation performed
* Evidence of completion (tests passing, feature working, etc.)

## Mermaid Diagram Standards

**Phase flow diagrams:**
* Simple linear flow (graph LR)
* Node labels: Phase name describing objective
* Standard RPI colors
* No complex branching (keep sequential)

**Example:**
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

## Quality Checklist

Before submitting workflow guide content, verify:

### Structure

- [ ] YAML frontmatter complete (title, description, author, date, keywords)
- [ ] Workflow Type and RPI Pattern identified
- [ ] Three-paragraph introduction (Scenario → Challenge → Solution)
- [ ] Prerequisites bifurcated (Required ✅ vs Recommended ○)
- [ ] IMPORTANT callout for critical prerequisite
- [ ] RPI Pattern Overview with Mermaid diagram and link
- [ ] Phase-by-Phase Walkthrough (one section per phase)
- [ ] Each phase includes: Goal, Chat Mode, Steps, Expected Outputs, Validation, TIP/NOTE
- [ ] Complete Example Walkthrough with starting state, actual prompts/responses, outcome
- [ ] Troubleshooting table with 4-6 issues
- [ ] Final Validation checklist with 4 categories
- [ ] Related Workflows with Prerequisites, Next Steps, Related Scenarios, Pattern Documentation
- [ ] Standard footer present

### Voice and Tone

- [ ] Second-person imperative voice ("analyze", "create", "validate")
- [ ] Step-by-step, practical, action-oriented tone
- [ ] Clear instructions without ambiguity
- [ ] Supportive guidance in callouts
- [ ] Commands and prompts use direct language

### Workflow Guidance

- [ ] Prerequisites specific and verifiable
- [ ] Each phase has 3-6 clear steps
- [ ] Prompts shown in full (not abbreviated)
- [ ] Expected results describe concrete outputs
- [ ] Validation checklists specific and checkable
- [ ] Troubleshooting addresses real failure modes
- [ ] Complete example shows actual execution

### Evidence-Based

- [ ] Validation criteria measurable and specific
- [ ] Troubleshooting solutions actionable
- [ ] Prerequisites justify why they're required

### Navigation

- [ ] All internal links use correct relative paths
- [ ] Related Workflows provide clear navigation
- [ ] Pattern documentation linked
- [ ] Prerequisite workflows linked

### Formatting

- [ ] Heading hierarchy correct (H1 → H2 → H3)
- [ ] Prompts in code blocks with `text` language
- [ ] Prerequisites use ✅ and ○ symbols correctly
- [ ] Troubleshooting table properly formatted
- [ ] Validation checklists use [ ] checkboxes
- [ ] Mermaid diagram uses standard colors
- [ ] Bold used for phase names, key terms, emphasis

## Anti-Patterns to Avoid

### 1. Vague Prerequisites

❌ **Avoid:** "Access to repository"

✅ **Instead:** "✅ GitHub Copilot with GPT-4 access (verify in VS Code settings)"

### 2. Summarized Prompts

❌ **Avoid:** "Ask Copilot to analyze the conflict"

✅ **Instead:** Show full prompt: "Analyze the merge conflict in src/auth/AuthService.ts lines 45-67. Explain intentions of both branches, recommend resolution preserving both requirements."

### 3. Missing Expected Results

❌ **Avoid:** Step ends with prompt, no guidance on what comes next

✅ **Instead:** "**Expected result:** Categorized list showing 8 files with 12 conflicts grouped by type and relationship."

### 4. Generic Troubleshooting

❌ **Avoid:** "If it doesn't work, try again"

✅ **Instead:** Specific issue + root cause + step-by-step solution with commands/prompts

### 5. No Complete Example

❌ **Avoid:** Instructions only, no worked example

✅ **Instead:** Complete walkthrough with actual prompts, responses, and measurable outcome

### 6. Abstract Validation

❌ **Avoid:** "Ensure everything works correctly"

✅ **Instead:** "[ ] All 247 tests passing", "[ ] No new lint errors", "[ ] Feature behavior matches requirements"

### 7. Missing Technical Validation

❌ **Avoid:** No verification that workflow achieved technical objectives

✅ **Instead:** Concrete validation criteria: "[ ] All 247 tests passing", "[ ] Feature behavior matches requirements"

### 8. No Prerequisite Warnings

❌ **Avoid:** Hidden assumptions about access or setup

✅ **Instead:** IMPORTANT callout: "Before starting, ensure you can run the test suite successfully on both branches independently."

## Standard Footer

```markdown
---

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
```
