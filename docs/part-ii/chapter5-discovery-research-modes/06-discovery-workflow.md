---
title: "The 5-10 Minute Discovery Workflow"
description: Follow a repeatable discovery process from landscape survey through exemplar discovery to implementation decision
author: HVE Core Team
ms.date: 2025-11-26
chapter: 5
part: "II"
keywords:
  - discovery-workflow
  - timeboxing
  - context-pre-seeding
  - exercises
---

You've learned when to use Ask Mode, how to formulate questions, and how to recognize incomplete answers. Now you'll see how these skills combine into a repeatable workflow.

This section provides a concrete process you can follow for every discovery session. Think of it as your scaffolding while building discovery habits—eventually this workflow becomes automatic.

## The Standard Discovery Pattern

Every Ask Mode session follows the same basic structure:

### Minutes 0-2: Define Goal and Landscape

* State what you're trying to accomplish
* Ask broad landscape question
* Identify major patterns or approaches

### Minutes 2-5: Context Filtering and Validation

* Apply contextual filters to narrow to relevant patterns
* Verify pattern applies to your situation
* Eliminate irrelevant approaches

### Minutes 5-8: Exemplar Discovery

* Request specific code examples
* Identify canonical exemplar (best reference implementation)
* Verify exemplar quality (comprehensive, recent, idiomatic)

### Minutes 8-10: Convention Details and Decision

* Clarify naming conventions, configuration patterns
* Fill specific knowledge gaps
* Decide next step: implement, escalate, or extend discovery

This pattern guides your questions from broad landscape to specific implementation details.

## Step-by-Step Walkthrough

Let's trace a complete discovery session for adding telemetry to an edge component.

### Step 1: Define Goal and Landscape (Minutes 0-2)

Start by stating your goal clearly in the chat. This helps you stay focused and helps Copilot understand context.

**Your stated goal:**

```text
I need to add telemetry metrics to the 120-custom-processor edge component. 
I don't know what telemetry infrastructure exists or how edge components 
typically expose metrics.
```

**Landscape question:**

```text
@workspace What patterns exist for telemetry and metrics collection in edge 
components?
```

**What you're looking for:**

* Do telemetry patterns exist?
* Multiple approaches or single standard?
* High-level understanding of architecture

**Typical discovery:**

* Prometheus metrics via 501-rust-telemetry component
* Components export metrics on `/metrics` endpoint
* Monitoring stack scrapes endpoints periodically

**What you're building:** Mental model of telemetry architecture.

### Step 2: Context Filtering (Minutes 2-5)

Apply contextual filters to narrow from general telemetry patterns to edge component specifics.

**Contextual filtering question:**

```text
@workspace Show examples of telemetry integration specifically in edge 
components, not in cloud services or orchestration components.
```

**What you're looking for:**

* Relevant subset of pattern (edge, not cloud)
* Multiple examples or single canonical approach
* Confidence that pattern applies to your context

**Typical discovery:**

* 110-iot-ops component integrates telemetry
* 130-ml-inference component also uses pattern
* Both expose `/metrics` via HTTP server

**What you're building:** Confidence that pattern applies to edge components like yours.

### Step 3: Exemplar Discovery (Minutes 5-8)

Identify the best reference implementation to use as guide.

**Exemplar request:**

```text
@workspace Show me the implementation in 110-iot-ops. I want to see how it 
initializes the telemetry library, registers metrics, and exposes the 
/metrics endpoint.
```

**What you're looking for:**

* Complete working example
* Initialization, registration, exposure pattern
* Code you can adapt directly

**Typical discovery:**

* Copilot shows `110-iot-ops/src/telemetry.rs` (lines 12-67)
* Initializes `PrometheusExporter` on startup
* Registers counters and gauges for component operations
* Exposes endpoint via existing HTTP server

**What you're building:** Concrete reference code to follow.

### Step 4: Convention Clarification (Minutes 8-10)

Fill specific gaps about conventions and configuration.

**Convention question:**

```text
@workspace What's the convention for metric naming in edge components? Do I 
follow component_name_metric_name format or something else?
```

**What you're looking for:**

* Naming conventions
* Configuration patterns
* Codebase-specific best practices

**Typical discovery:**

* Naming format: `component_name_operation_metric_type`
* Example: `custom_processor_messages_processed_total`
* Metrics registered in component initialization function

**What you're building:** Detailed understanding to implement correctly.

### Step 5: Decision Point (Minute 10)

Evaluate what you've learned and decide next step.

**Decision criteria:**

✅ **Consider proceeding to Implementation:**

* Clear pattern identified
* Canonical exemplar found and understood
* Conventions clarified
* No obvious blockers to starting work

⚠️ **Consider escalating to Task Researcher:**

* Multiple patterns, unclear which to use
* Need comprehensive documentation for team review
* Complex integration requiring detailed design
* Implementation has significant risk

⚠️ **Extend Discovery (5 more minutes):**

* Close to clarity, need one or two more questions
* Specific gap identified that quick question can resolve
* Still within reasonable discovery timeframe

**For our telemetry example:**

* ✅ Clear pattern (Prometheus via 501-rust-telemetry)
* ✅ Canonical exemplar (110-iot-ops/src/telemetry.rs)
* ✅ Conventions understood (naming, registration)
* **Decision:** Proceed to implementation

## Capturing Discovery Findings

Don't rely on memory. Capture what you learned in lightweight markdown notes.

**Simple discovery notes template:**

```markdown
## Discovery Session: [Feature/Question]
**Date:** 2024-11-17
**Duration:** 8 minutes
**Goal:** [What you were trying to understand]

### Findings
- **Pattern:** [High-level approach identified]
- **Canonical Exemplar:** [Best reference implementation with file/line numbers]
- **Key Convention:** [Important conventions or patterns]
- **Integration Points:** [Where/how pattern integrates with system]

### Next Step
[Clear decision: Implement, escalate to Task Researcher, or extend discovery]

### Key Files
- [file1] - [purpose]
- [file2] - [purpose]
```

**Why capture findings:**

* Reference while implementing (don't re-ask same questions)
* Share context with teammates
* Document rationale for approach chosen
* Prevent rediscovery later

## The Context Pre-Seeding Advantage

Your discovery session loads files into chat context. This creates significant advantage for next phases.

**The force multiplier pattern:**

When you keep the same chat thread from Ask Mode → Task Researcher → Implementation:

**Minutes 0-10 (Ask Mode):**

* Question 1: Pattern discovery → Copilot loads pattern files
* Question 2: Context filtering → Copilot loads edge component examples
* Question 3: Exemplar request → Copilot loads canonical exemplar
* Question 4: Convention clarification → Copilot loads convention docs

**Minutes 10-40 (Task Researcher, same thread):**

* All files from Ask Mode already in context
* Pattern understanding established
* Research starts "warm" instead of cold
* Often faster with higher quality results

**Anti-pattern (don't do this):**

```text
❌ Ask Mode in Chat 1 → Close → Task Researcher in new Chat 2
```

**Result:** Lost context, must rediscover patterns, wasted time.

**Best practice:**

```text
✅ Ask Mode in Chat 1 → Continue with Task Researcher in same Chat 1
```

**Result:** Context carries forward, warm start, efficient research.

> [!TIP]
> Think of Ask Mode as "context loading phase" not just "question asking phase." Those 5-10 minutes load 15-20 files into chat context that dramatically accelerate subsequent work.

## Quick Check Exercises

Practice the discovery workflow with three focused scenarios. Each should take 5-7 minutes.

### Exercise 1: API Endpoint Discovery (5-7 min)

**Context:** You need to add a new REST API endpoint for retrieving user activity logs. You don't know route structure, authentication approach, or response format conventions.

**Your Task:** Use Ask Mode to discover:

1. How REST API routes are structured in this codebase
2. What authentication middleware is used
3. How responses are formatted (error handling, JSON structure)
4. Which existing endpoint serves as good exemplar

**Success Criteria:**

* ✅ Identified route structure convention
* ✅ Found authentication middleware name/location
* ✅ Identified response format pattern
* ✅ Located canonical exemplar endpoint
* ✅ Clear decision: implement or escalate

**Time Allocation:**

* Minutes 0-2: Landscape (route structure)
* Minutes 2-4: Authentication approach
* Minutes 4-6: Response format and exemplar
* Minutes 6-7: Decision and notes

**What You Learned:**

* How to discover route structure conventions in unfamiliar codebases
* The difference between Ask Mode file discovery and manual grep
* When to escalate from "where is it?" to "how do I use it?"

### Exercise 2: Email Infrastructure Discovery (5-7 min)

**Context:** Building on the email notification feature from Chapter 4, you need to understand email infrastructure more deeply. What library is used? How are templates structured? What happens when sends fail?

**Your Task:** Use Ask Mode to discover:

1. Does email sending infrastructure exist? What library/service?
2. Where is email logic located (service layer, utilities)?
3. How are email templates structured (inline, template engine, files)?
4. Is there a canonical example of transactional emails?

**Success Criteria:**

* ✅ Determined if infrastructure exists (yes/no)
* ✅ If yes: Identified library, configuration, template approach
* ✅ If yes: Located exemplar code
* ✅ If no: Understood next step (research email integration)
* ✅ Clear decision made

**Time Allocation:**

* Minutes 0-2: Infrastructure existence check
* Minutes 2-4: Library/service details
* Minutes 4-6: Template approach and examples
* Minutes 6-7: Decision

**What You Learned:**

* How to verify infrastructure existence before building new systems
* The value of asking "does this exist?" before "how do I build this?"
* Pattern for discovering library configurations and template approaches

### Exercise 3: Service Layer Pattern Discovery (5-7 min)

**Context:** You're asked to "implement the service layer pattern for the new feature, following codebase conventions." You don't know what "service layer pattern" means in THIS codebase—different teams implement it differently.

**Your Task:** Use Ask Mode to discover:

1. How is "service layer" defined in this codebase?
2. Where do service components live (directory structure)?
3. What are naming conventions for services?
4. What's a canonical example of the pattern in action?
5. What dependencies do services typically have?

**Success Criteria:**

* ✅ Clear definition of "service layer" in this context
* ✅ Identified directory structure and naming conventions
* ✅ Located canonical exemplar service
* ✅ Understood dependency patterns
* ✅ Confident you can implement following pattern

**Time Allocation:**

* Minutes 0-2: Definition and purpose
* Minutes 2-4: Structure, location, naming
* Minutes 4-6: Canonical exemplar
* Minutes 6-7: Dependencies and decision

**What You Learned:**

* How context-dependent terms like "service layer" require codebase-specific discovery
* The importance of finding canonical exemplars over generic definitions
* How naming conventions and dependency patterns vary across codebases

## What You've Learned

You now have a concrete workflow for discovery sessions:

* Define goal → Landscape → Filter → Exemplar → Convention → Decision
* Time allocations for each step (total 5-10 minutes)
* Decision criteria for next steps (implement, escalate, extend)
* Lightweight note-taking to capture findings
* Context pre-seeding advantage for subsequent phases

This workflow transforms vague "I'll ask Copilot" into disciplined discovery practice. The more you follow this pattern, the more automatic it becomes—until discovery feels effortless.

---

**Previous:** [Extract → Verify → Learn](./05-extract-verify-learn.md) | **Next:** [Summary](./07-summary.md) | **Up:** [Chapter 5 Overview](./README.md)

---

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
