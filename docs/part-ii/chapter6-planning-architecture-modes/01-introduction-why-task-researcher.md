---
title: Introduction - Why Task Researcher matters
description: Understand when to escalate from Ask Mode to Task Researcher for complex integrations and evidence-based architectural decisions
author: HVE Core Team
ms.date: 2025-11-19
chapter: 6
part: "II"
section: 1
type: content-section
parent: chapter6-planning-architecture-modes
prerequisites:
  - Chapter 5 - Ask Mode capabilities
  - Understanding of hallucination risks
estimated_reading_time: 8
keywords:
  - task researcher
  - escalation criteria
  - hallucination prevention
  - evidence-based research
---

## Escalation from Ask Mode

In Chapter 5, you learned Ask Mode for rapid 5-10 minute discovery sessions. Ask Mode is perfect when you need quick answers:

* "Where does authentication happen in this codebase?"
* "What email library are we using?"
* "Does this API support pagination?"

But Ask Mode has limitations. When you encounter these situations, it's time to escalate to Task Researcher:

**Escalation triggers:**

* **Complex integration**: Feature requires understanding multiple interconnected systems
* **Multiple viable approaches**: Need to evaluate alternatives with evidence-based criteria
* **External dependencies**: Must research SDKs, libraries, or third-party APIs in depth
* **Brownfield codebase**: Unfamiliar codebase with unclear patterns
* **High-risk changes**: Decisions with significant architectural implications

### Example escalation scenario

*Requirement:* "Add two-factor authentication to user login"

**Ask Mode session (~10 minutes):**

```text
You: "What authentication library do we use?"
Copilot: "You're using Passport.js with local strategy in src/auth/passportConfig.js"

You: "Do we have any 2FA implementations?"
Copilot: "I don't see 2FA implementations in the codebase."

You: "What 2FA libraries work with Passport.js?"
Copilot: "Common options include speakeasy, otplib, or passport-totp. Each has different features..."
```

At this point, Ask Mode has identified the landscape but can't help you:

* **Evaluate** which 2FA library best fits your architecture
* **Analyze** how to integrate with existing Passport.js setup
* **Research** best practices for 2FA token storage and recovery codes
* **Document** findings with evidence from official docs and code examples

**This is when you switch to Task Researcher.**

## When quick discovery is insufficient

Ask Mode works in conversational flow: each answer builds on the last. But this approach breaks down when:

1. **You need systematic analysis**: Comparing 3-4 approaches requires structured evaluation
2. **Evidence must be preserved**: Findings need source citations for later validation
3. **Multiple people will use it**: Research document serves as team reference
4. **Implementation will span days**: Can't rely on chat history for critical details

**Time investment comparison:**

| Scenario                   | Ask Mode (5-10 min) | Task Researcher (20-60 min) |
|----------------------------|---------------------|-----------------------------|
| Find where auth code lives | ✅ Perfect fit       | ❌ Overkill                  |
| Add 2FA to existing auth   | ⚠️ Incomplete       | ✅ Right tool                |
| Migrate auth system        | ❌ Insufficient      | ✅ Essential                 |
| Understand auth flow       | ✅ Good for overview | ✅ Better for depth          |

## Hallucination prevention through evidence

Task Researcher's primary purpose: **prevent AI hallucination by requiring evidence for every claim.**

> [!IMPORTANT]
> AI models can confidently state incorrect information when working in unfamiliar territory. Task Researcher's evidence requirements create verification checkpoints that catch hallucinations before they reach your implementation.

**How Task Researcher enforces evidence:**

* Every finding must cite a source (file path + line numbers, or external URL + access date)
* Code examples must come from actual codebase or official documentation
* Alternative approaches compared using objective criteria, not AI opinion
* Research documents create audit trail of decision rationale

### Example: Evidence-based finding

❌ **Without evidence (Ask Mode might say):**

```markdown
Use speakeasy library for 2FA. It's the most popular and easiest to integrate.
```

✅ **With evidence (Task Researcher produces):**

```markdown
## 2FA Library Analysis

### Option 1: speakeasy (v2.0.0)

**Evidence:**

* Source: npm registry, accessed 2024-01-15
* Weekly downloads: 500k+ (https://npmjs.com/package/speakeasy)
* Last updated: 2023-12-10
* Integration example: https://github.com/speakeasyjs/speakeasy#usage

**Pros:**

* Battle-tested (6+ years production use)
* Supports TOTP and HOTP standards
* QR code generation built-in

**Cons:**

* No TypeScript types included (requires @types/speakeasy)
* Larger bundle size (45kb)

**Existing codebase patterns:**

* Project uses TypeScript throughout (src/tsconfig.json, L3-15)
* Prefers libraries with native TS support (see package.json dependencies)

**Recommendation:** Consider otplib (Option 2) for better TypeScript support.
```

Notice the difference: The evidence-based version provides verifiable sources, specific metrics, and connects recommendations to actual codebase patterns. This creates a foundation for confident decision-making.

## The cost of hallucinated information

Consider what happens when you act on AI-generated information without evidence:

**Scenario:** You ask about performance characteristics of a library. AI confidently states "Library X handles 10,000 requests/second with minimal memory overhead." You architect your system around this capability.

**Reality:** During implementation, you discover:

* Library X's documentation mentions no such performance claims
* Your load testing shows 1,000 requests/second before memory issues
* The architecture decisions you made are now invalidated
* You need to redesign and reimplement significant portions

**Time cost:**

* Original research that would have caught this: 30 minutes
* Rework from hallucinated information: 2-3 days

Task Researcher prevents these scenarios by requiring evidence citations. When claims can't be backed by verifiable sources, they don't make it into your research document.

## Scope of this chapter

By the end of this chapter, you'll master:

1. **Task Researcher Mode**: When and how to invoke deep research mode
2. **Research Document Structure**: Template and sections for comprehensive research
3. **Evidence Gathering**: Internal codebase analysis + external source integration
4. **MCP Tool Integration**: Using Context7 for SDK docs, web fetch for documentation
5. **Completeness Assessment**: Knowing when research is "good enough" for planning
6. **D-RPI Variation**: Adding Discovery phase for unfamiliar codebases

**What this chapter does NOT cover:**

* Planning from research (that's Chapter 7 - Task Planner)
* Implementation techniques (Chapters 8-9 - Edit/Agent modes)
* Quick discovery sessions (that's Chapter 5 - Ask Mode)

---

## Navigation

* **Previous:** [Chapter 6 README](./README.md)
* **Next:** [Section 2 - Task Researcher Capabilities](./02-task-researcher-capabilities.md)
* **Up:** [Chapter 6 README](./README.md)

---

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
