---
title: "When to Use Ask Mode"
description: Learn the decision framework for choosing between Ask Mode reconnaissance and Task Researcher systematic analysis
author: HVE Core Team
ms.date: 2025-11-26
chapter: 5
part: "II"
keywords:
  - ask-mode
  - task-researcher
  - decision-framework
  - escalation
  - timeboxing
---

Ask Mode and Task Researcher both help you understand codebases, but they serve different purposes. Ask Mode is reconnaissance—quick landscape survey to identify patterns and frame questions. Task Researcher is systematic analysis—comprehensive research that produces documented evidence for team decisions.

This section teaches you the decision framework: when Ask Mode is sufficient, when to escalate to Task Researcher, and how to recognize the boundary between quick discovery and deep research.

## Ask Mode vs. Task Researcher: The Decision Framework

### Ask Mode Characteristics

* **Duration:** 5-10 minutes maximum
* **Style:** Conversational, iterative, exploratory dialogue
* **Outputs:** Mental models, file paths, pattern names (conversational, not structured research documents)
* **Purpose:** Landscape discovery, question refinement, context building
* **Safety:** Read-only exploration, no code generation, no file creation

**Example Ask Mode session:**

```text
You: @workspace What authentication patterns exist?
Copilot: I see managed identity (edge), service principal (cloud), API keys (deprecated)

You: @workspace Which is used for edge components?
Copilot: Edge components use managed identity from 010-security-identity component

You: @workspace Show me an example
Copilot: 110-iot-ops references it via variables.dep.tf, lines 45-67 in main.tf

Result: ~6 minutes, clear understanding of pattern, ready to implement or research deeper
```

### Task Researcher Characteristics

* **Duration:** Typically 20-60 minutes for comprehensive analysis, depending on complexity
* **Style:** Systematic, evidence-based, structured exploration
* **Outputs:** Research documents with citations (markdown artifacts)
* **Purpose:** Deep understanding, decision-making, team documentation
* **Safety:** Creates research docs, but no code changes

**Example Task Researcher scenario:** "Research authentication pattern for edge components, document managed identity integration following 110-iot-ops exemplar, include configuration schema, error handling, and testing considerations for team decision on standardization approach."

## Decision Matrix: When to Use Each Mode

| Scenario                                                                              | Use Ask Mode                       | Use Task Researcher            |
|---------------------------------------------------------------------------------------|------------------------------------|--------------------------------|
| "Where does authentication logic live?"                                               | ✅ Quick file discovery             | ❌ Overkill for simple question |
| "What error handling patterns exist?"                                                 | ✅ Pattern landscape survey         | ❌ Too broad without context    |
| "How should I implement OAuth 2.0 with Azure AD following codebase patterns?"         | ❌ Needs evidence and documentation | ✅ Deep research required       |
| "Show me an example of telemetry integration"                                         | ✅ Exemplar discovery               | ❌ Overkill for finding example |
| "Compare approaches A, B, C with trade-offs and team recommendation"                  | ❌ Needs systematic analysis        | ✅ Research required            |
| "Is there a configuration file for database connections?"                             | ✅ Quick check                      | ❌ Overkill for file location   |
| "Document complete API integration pattern with error handling, retries, and testing" | ❌ Needs comprehensive docs         | ✅ Research required            |

## The Type 1 Input Zone

Recall from Chapter 3: **Type 1 inputs** are uncertainty and questions—the starting point of the type transformation workflow. Type 2 inputs are precise research topics with specific scope.

**Ask Mode excels with Type 1 inputs:**

* "What are my options?"
* "Where does X live?"
* "How is Y currently implemented?"
* "Which pattern should I follow?"
* "Show me an example of Z"

**Example Type 1 → Type 2 transformation:**

```text
Type 1 (Uncertainty): "Add authentication following existing patterns"
↓
Ask Mode Discovery (5-10 min)
↓
Type 2 (Research Topic): "Research managed identity pattern from 
010-security-identity component, document how edge components 
consume it via variables.dep.tf pattern, using 110-iot-ops as 
canonical exemplar"
```

The transformation: Ask Mode converts vague Type 1 uncertainty into precise, contextually-grounded Type 2 research topics. You enter Ask Mode with questions; you exit with either clear answers (proceed to implementation) or precise research topics (escalate to Task Researcher).

## 5-10 Minute Timeboxing

Timeboxing enforces discovery discipline. Without time boundaries, sessions drift into unfocused exploration. Typically 5-10 minutes provides enough time for 4-6 iterative questions while remaining short enough to prevent analysis paralysis.

**Typical timebox progression:**

```text
Minutes 0-2:   Initial question, get landscape overview
Minutes 2-5:   Narrow focus, identify patterns
Minutes 5-8:   Find canonical exemplars, understand conventions
Minutes 8-10:  Frame precise research question or proceed to implementation
```

If you reach approximately 10 minutes without clarity → **Consider escalating to Task Researcher** with what you've learned.

> [!TIP]
> **Set a literal timer.** Open your Ask Mode session, start a 10-minute timer on your phone or desktop. When it goes off, make the escalation decision: "Do I have enough to proceed, or do I need systematic research?"
>
> Think of the timer as training wheels. After 10-20 discovery sessions, you'll internalize the rhythm. But start with the timer to build muscle memory.

## Escalation Triggers: When to Switch to Task Researcher

**Escalate from Ask Mode to Task Researcher when:**

1. **Complexity exceeds quick answers** - Multiple patterns exist, trade-offs unclear, decision requires analysis
2. **Evidence needed for team decision** - Need documented rationale, not just personal understanding
3. **Implementation requires comprehensive details** - Need API signatures, configuration schemas, integration steps documented
4. **Answers are inconsistent** - Ask Mode gives different answers across iterations (signals need for systematic verification)
5. **Time runs out** - 10 minutes elapsed, still unclear on next steps

**Don't escalate when:**

* You found the file or pattern you needed
* You understand enough to proceed with implementation
* Question was truly simple (file location, naming convention)
* You identified a canonical exemplar to follow

> [!NOTE]
> These are training guidelines. Experienced practitioners calibrate escalation based on codebase complexity, domain familiarity, and personal learning velocity. Start with these thresholds, then adjust as you develop judgment.

### Example Escalation Decision

**Ask Mode session (8 minutes):**

```text
You: @workspace What error handling patterns exist?
Copilot: I see Result<T, E> pattern (12 files), try-catch with logging (8 files), 
         and error codes enum (5 files, older)

You: @workspace Which is current standard?
Copilot: Result<T, E> is newer pattern, but adoption is incomplete. 
         authenticateUser() uses Result<T,E>, validateInput() uses try-catch.
```

**Decision:** ESCALATE to Task Researcher

**Reason:** Multiple patterns in use, unclear which to follow, need team decision on standardization approach. Ask Mode gave landscape view but can't provide comprehensive trade-off analysis or recommendation.

**Framed research topic:** "Research error handling approaches in codebase, compare Result<T,E> vs. try-catch patterns with concrete examples, analyze adoption status, document recommendation for new code with rationale."

> [!IMPORTANT]
> **Escalation is not failure.** Ask Mode's job is discovery. If discovery reveals complexity requiring systematic research, Ask Mode succeeded—it prevented you from making uninformed implementation decisions. Quick discovery that identifies need for deep research is a win.

## Context Pre-Seeding: A Preview

When you keep the same chat thread from Ask Mode through Task Researcher, discoveries carry forward. This **context pre-seeding** technique dramatically accelerates subsequent research—files loaded during discovery remain available, patterns identified inform deeper analysis.

Section 6 covers this technique in depth with the full workflow. For now, remember: don't close your Ask Mode chat when escalating to Task Researcher. Same thread = warm context.

---

**Previous**: [Section 1: Welcome to Part II](./01-introduction-part-ii.md) | **Next**: [Section 3: Effective Question Formulation](./03-effective-question-formulation.md) | **Up**: [Chapter 5 README](./README.md)

---

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
