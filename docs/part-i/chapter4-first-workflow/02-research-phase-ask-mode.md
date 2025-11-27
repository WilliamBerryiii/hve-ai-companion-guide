---
title: "Research Phase with Ask Mode"
description: Learn to use Ask Mode for rapid codebase reconnaissance before implementation, understanding when quick discovery suffices versus deeper research
author: HVE Core Team
ms.date: 2025-11-26
chapter: 4
part: "I"
keywords:
  - ask-mode
  - research-phase
  - discovery
  - reconnaissance
---

## Research Phase with Ask Mode

You've selected your feature: email notification when users complete their profile. Before you write any code, you need to understand the landscape. What email infrastructure exists? What patterns does your codebase follow? What edge cases should you handle?

This is the **Research phase**, and you'll use GitHub Copilot's Ask Mode to conduct rapid initial reconnaissance.

## What Is Ask Mode?

Ask Mode is GitHub Copilot's conversational interface for quick questions. Think of it as your pair programmer who has read your entire codebase.

> [!TIP]
> **To switch to Ask Mode:** Open GitHub Copilot Chat (Ctrl+Shift+I or Cmd+Shift+I), then click the mode dropdown in the chat panel header and select "Ask." You can also type `@workspace` before your question to ensure codebase-aware responses.

**Strengths:**

* Fast answers to specific questions
* Searches your codebase for patterns
* Identifies relevant files quickly
* Good for "where is X?" and "how does Y work?" questions

**Limitations:**

* Answers based on code, not external documentation
* May hallucinate if pattern doesn't exist in codebase
* Not suitable for deep technical research (use Task Researcher for that—Chapter 5)

> [!TIP]
> **Ask Mode is for reconnaissance, not comprehensive research.** Typically, spending 5-10 minutes getting oriented is sufficient before moving to planning. Resist the urge to research every detail—you'll discover what you need during implementation.

## When to Use Ask Mode vs. Task Researcher

You'll learn Task Researcher in Chapter 5, but here's the quick decision guide:

| Use Ask Mode When                         | Use Task Researcher When                            |
|-------------------------------------------|-----------------------------------------------------|
| Exploring your codebase patterns          | Researching external libraries or APIs              |
| "Where is the email configuration?"       | "What are best practices for email deliverability?" |
| Quick reconnaissance (typically 5-10 min) | Deep research (often 30-60 min)                     |
| Answer found in your code                 | Answer requires external knowledge                  |

**For this chapter:** You'll use Ask Mode because you're exploring existing codebase patterns, not researching external concepts.

## The Four-Step Ask Mode Workflow

### Step 1: Frame Your Questions

Start with the **minimum you need to know** to plan implementation:

**Good starting questions:**

* "How does email sending work in this codebase?"
* "Where is the user profile update logic?"
* "What email library are we using?"

**Avoid premature depth:**

* ❌ "What are all possible email deliverability issues?" (Too broad, external knowledge)
* ❌ "Show me every file that touches user objects" (Too comprehensive, fishing expedition)

Research is understanding enough to make informed planning decisions. Over-researching is procrastination.

### Step 2: Ask Mode Query Patterns

Open GitHub Copilot Chat and use these query patterns:

### Pattern 1: Discovery

```text
@workspace What email libraries or services does this codebase use?
```

**Expected response:**

* Library name (nodemailer, SendGrid, etc.)
* File location of email configuration
* How it's initialized

### Pattern 2: Pattern Identification

```text
@workspace Show me an example of sending an email in this codebase
```

**Expected response:**

* Example code showing email send pattern
* How templates are handled
* How errors are handled (if at all)

### Pattern 3: File Location

```text
@workspace Where is the user profile update endpoint?
```

**Expected response:**

* Route file location
* Handler function name
* Related validation logic

### Step 3: Validate Answers Against Codebase

**Critical step:** Ask Mode can hallucinate. Always verify important findings:

**Example validation:**

```text
Ask Mode: "The codebase uses nodemailer configured in src/services/emailService.js"

Your validation:
1. Open src/services/emailService.js - Does it exist? ✅
2. Check imports - Does it import nodemailer? ✅
3. Check package.json - Is nodemailer listed in dependencies? ✅
```

> [!WARNING]
> **Trust but verify.** If Ask Mode identifies a pattern, spot-check at least one example to confirm it's accurate. This catches hallucinations early.

### Step 4: Document Findings

As you research, capture findings in simple markdown:

```markdown
## Research Notes: Email Notification Feature

### Email Infrastructure
- Library: nodemailer v6.9.0 (confirmed in package.json)
- Config: src/services/emailService.js exports configured transporter
- Pattern: Emails sent immediately in route handlers (no queue)

### User Profile Update
- Endpoint: PUT /users/:id/profile in src/routes/users.js
- Validation: Uses express-validator middleware
- Current behavior: Returns 200 with updated user object

### Questions for Planning Phase
- How to detect profile completion? (need to define "complete")
- What to do if email send fails? (current code has no error handling)
- Should email be queued or sent immediately? (no queue infrastructure exists)
```

**Why document as you go?**

* Prevents forgetting details when you move to planning
* Creates audit trail (what did you know when you made decisions?)
* Helps teammates who work on related features later

## Exercise 4.1: Research Phase Practice (~15-20 minutes)

**Goal:** Use Ask Mode to research the email notification feature, documenting findings you'll use in planning phase.

### Setup

1. **Open your codebase** (or use the reference repository provided in prerequisites)
2. **Open GitHub Copilot Chat** (Ctrl+Shift+I or Cmd+Shift+I)
3. **Create research notes file:** `research-notes-email-feature.md`

### Step-by-Step Instructions

### Task 1: Discover Email Infrastructure (5 minutes)

Query Ask Mode:

```text
@workspace What email libraries or services does this codebase use? Show me the configuration.
```

Document in your notes:

* Library name and version (check package.json to verify)
* Configuration file location (open file to confirm)
* How transporter/service is initialized

### Task 2: Find Email Send Pattern (5 minutes)

Query Ask Mode:

```text
@workspace Show me an example of sending an email in this codebase
```

Document:

* Example file and function
* Is email sent immediately or queued?
* How are templates handled? (inline HTML? separate files?)
* What error handling exists? (try-catch? none?)

### Task 3: Locate Profile Update Logic (5 minutes)

Query Ask Mode:

```text
@workspace Where is the user profile update endpoint? Show me the handler function.
```

Document:

* Route file and endpoint path
* Handler function name
* What validation happens currently?
* What does it return on success?

### Task 4: Identify Knowledge Gaps (5 minutes)

Review your notes and list questions you can't answer from Ask Mode alone:

**Example questions:**

* "What fields are required for a 'complete' profile?" (Business logic, not in code yet)
* "Should we send email on *any* profile update or only on completion?" (Product decision)
* "What if email service is down—should profile update fail?" (Architecture decision)

Identifying what you don't know is just as valuable as documenting what you do know. These gaps guide your planning phase.

### Success Criteria

You've completed this exercise when your research notes include:

* ✅ **Email infrastructure details:** Library, version, config file, initialization pattern
* ✅ **Send pattern:** Immediate vs. queued, template approach, error handling
* ✅ **Profile update logic:** Endpoint, handler, validation, current behavior
* ✅ **Knowledge gaps list:** 3-5 questions that need planning phase decisions

**Time check:** If you've spent more than 20 minutes, consider stopping—you likely have enough for planning. Additional research can happen during implementation if needed.

## Verify Your Research: Extract, Verify, Learn

Research without verification is assumption. Before moving to planning, take time to verify your findings and create a learning path for knowledge gaps. This **Extract → Verify → Learn** pattern transforms raw research into actionable knowledge.

### The Hidden Resource Problem

Ask Mode generates comprehensive responses, but valuable resources often get buried. That 15-line answer might contain 3 documentation links, 2 SDK references, and a tutorial URL—all easily overlooked when you're focused on the main answer.

**The solution:** Systematically extract and verify before proceeding.

### Step 1: Extract Supporting Resources

After your research queries, ask Ask Mode to surface the resources it discovered:

```text
@workspace Based on our research conversation, list all external documentation, library references, SDK links, and tutorials you mentioned or that would help me implement this email notification feature.
```

**Expected output:**

```markdown
## Resources from Research

### Official Documentation
- nodemailer: https://nodemailer.com/
- express-validator: https://express-validator.github.io/docs/

### Codebase References
- Email service: src/services/emailService.js
- User model: src/models/User.js
- Profile routes: src/routes/users.js

### Tutorials/Guides
- [nodemailer SMTP setup guide]
- [Error handling patterns in Express]
```

### Step 2: Verify Claims Against Sources

AI can hallucinate. Before committing to your plan, verify critical claims:

```text
@workspace I need to verify these claims from our research:
1. We use nodemailer v6.9.0
2. Emails are sent immediately (no queue)
3. The profile update endpoint is PUT /users/:id/profile

Check each against the actual codebase and tell me what's accurate.
```

**Create a verification report:**

```markdown
## Research Verification

| Claim | Source | Verified? | Notes |
|-------|--------|-----------|-------|
| nodemailer v6.9.0 | package.json | ✅ Yes | Actual: 6.9.7 |
| Immediate send (no queue) | emailService.js | ✅ Yes | No job queue found |
| PUT /users/:id/profile | routes/users.js | ✅ Yes | Line 45-62 |
| Error handling exists | emailService.js | ❌ No | No try-catch found |

**Verification Score:** 3/4 claims verified (75%)
**Action Required:** Add error handling (not in codebase, must implement)
```

> [!TIP]
> **Verification catches expensive mistakes early.** A 2-minute verification step can prevent hours of debugging when your implementation fails because it's based on hallucinated patterns.

### Step 3: Create Your Custom Learning Path

Based on knowledge gaps from your research, create a structured learning path. This isn't about reading everything—it's about filling specific gaps efficiently.

```text
@workspace Based on my research, I have these knowledge gaps:
1. How to detect profile completion (business logic)
2. Error handling for email sends
3. Best practices for non-blocking side effects

Create a learning path with specific documentation sections I should review, ordered from foundational to advanced.
```

**Document the learning path:**

```markdown
## Learning Path (Pre-Planning)

### Priority 1: Critical for Implementation (~15 min)
**Must complete before planning phase**

1. **nodemailer error handling**
   - URL: https://nodemailer.com/usage/#error-handling
   - Focus: transporter.sendMail() error callbacks
   - Time: 5 min

2. **Express async error patterns**
   - Codebase: Check existing try-catch patterns in routes/
   - Focus: How other endpoints handle async failures
   - Time: 5 min

3. **Profile completion definition**
   - Decision needed: What fields constitute "complete"?
   - Action: Define in planning phase, no external docs needed
   - Time: 5 min

### Priority 2: Nice to Have (~10 min)
**Can defer to implementation if needed**

4. **Email templating options**
   - URL: https://nodemailer.com/message/
   - Focus: HTML vs plain text, inline styles
   - Time: 5 min

5. **Retry patterns for transient failures**
   - Consider for v2, skip for initial implementation
   - Time: Deferred

### Time Estimate
- Priority 1 review: 15 min
- Ready for planning after Priority 1 complete
```

### Step 4: Validate Knowledge Gaps Are Addressable

Before planning, confirm each gap has a path to resolution:

```markdown
## Knowledge Gap Resolution Matrix

| Knowledge Gap | Resolution Source | Confidence | Status |
|--------------|-------------------|------------|--------|
| Profile completion definition | Product decision (define in plan) | High | Ready |
| Email error handling | nodemailer docs + codebase pattern | High | Docs reviewed |
| Queue vs immediate send | Architecture (use existing: immediate) | High | Decided |
| Email template format | nodemailer docs (can defer) | Medium | Deferred |

**All critical gaps resolved:** ✅ Ready for planning
```

> [!IMPORTANT]
> **Low confidence gaps need attention.** If a gap has no clear resolution path, either escalate to Task Researcher (Chapter 5) for deeper research, or make an explicit assumption you'll validate during implementation.

### Exercise 4.1b: Verify and Create Learning Path (~10 minutes)

**Goal:** Extract resources from your research, verify critical claims, and create a targeted learning path.

**Steps:**

1. Query Ask Mode for all documentation links and resources from your research
2. Create a verification table with at least 4 claims from your research
3. Open at least 2 documentation links and verify specific claims
4. Create a learning path with Priority 1 (critical) and Priority 2 (nice to have) items
5. Add a Knowledge Gap Resolution Matrix to your research notes

**Success Criteria:**

* ✅ At least 3 external resources extracted and documented
* ✅ Verification table with 4+ claims, each marked verified or not
* ✅ At least 2 claims verified against actual sources
* ✅ Learning path with prioritized items and time estimates
* ✅ All critical knowledge gaps have identified resolution paths

**What you learned:**

* How to surface hidden resources from AI research responses
* How to verify claims before they become implementation decisions
* How to create targeted learning paths that prevent over-research
* How to assess readiness for the planning phase

## Common Ask Mode Mistakes

### Mistake #1: Treating Ask Mode as source of truth without verification

❌ **Bad:**

```text
Ask Mode says use SendGrid → Proceed to use SendGrid without checking codebase
```

✅ **Good:**

```text
Ask Mode says use SendGrid → Check package.json → Codebase actually uses nodemailer → Use existing pattern
```

### Mistake #2: Using Ask Mode for deep technical research

❌ **Bad:**

```text
"What are email deliverability best practices and how do I implement SPF, DKIM, and DMARC?"
```

✅ **Good:**

```text
"Does this codebase have email deliverability configuration? Where is it?" → If doesn't exist and needed, escalate to Task Researcher
```

### Mistake #3: Skipping codebase-specific follow-ups

❌ **Bad:**

```text
Stop after Ask Mode says "use nodemailer"
```

✅ **Good:**

```text
"use nodemailer" → "Show me nodemailer config in this codebase" → "How is nodemailer currently used?" → Understand actual patterns
```

### Mistake #4: Over-researching edge cases prematurely

❌ **Bad:**

```text
Spending 45 minutes asking about every possible email failure scenario before planning
```

✅ **Good:**

```text
Document that email sends can fail → Note in planning phase: "Need error handling strategy" → Research specific failures if implementation reveals need
```

The goal is informed planning, not comprehensive documentation. You're gathering enough context to make architectural decisions, not creating an encyclopedia. Move to planning phase once you understand existing patterns and have identified decision points.

## Transitioning to Planning Phase

After research and verification, you should have:

* ✅ **Landscape understanding:** How email works in this codebase
* ✅ **Pattern awareness:** How similar features are implemented
* ✅ **File locations:** Where you'll make changes
* ✅ **Knowledge gaps:** What you need to decide during planning
* ✅ **Verified claims:** Research validated against actual sources
* ✅ **Learning path:** Prioritized resources for filling gaps

**What you don't have yet (and that's correct):**

* ❌ Detailed implementation steps
* ❌ Edge case handling strategies  
* ❌ Code snippets ready to paste

**The pattern you've learned:** Research → Verify → Learn → Plan

This **Extract → Verify → Learn** pattern becomes even more powerful with Task Researcher in Chapter 5, where you'll work with 15+ page research documents containing dozens of resources.

**Next step:** Use your verified research findings to create an implementation plan. That's Section 3.

## Navigation

[Previous: Section 1 - Introduction and Feature Selection](./01-introduction-feature-selection.md) | [Next: Section 3 - Manual Planning Phase](./03-manual-planning-phase.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
