---
title: 'Extract → Verify → Learn: The Discovery Quality Pattern'
description: 'Master the three-step pattern that transforms AI responses from raw output into verified, actionable knowledge you can trust and build upon.'
author: HVE Core Team
ms.date: 2025-11-26
chapter: 5
part: "II"
---

Discovery mode produces answers—but answers aren't knowledge until you've validated them. This section introduces the pattern that transforms AI responses from "something I read" into "something I know."

## Why Raw Answers Aren't Enough

When you ask Copilot a question in Ask Mode, you receive a response. That response might be:

- **Completely accurate** and directly applicable to your situation
- **Partially accurate** with context-specific caveats the AI couldn't know
- **Outdated** based on training data that predates recent changes
- **Confidently wrong** presenting plausible but incorrect information

The challenge: all four scenarios *look the same* in the chat window. The AI presents each with equal confidence. Your job is distinguishing between them—and the Extract → Verify → Learn pattern gives you a systematic approach.

## The Three-Step Pattern

### Step 1: Extract the Testable Claims

Before you can verify anything, you need to identify what the AI actually claimed. This sounds obvious, but AI responses often blend facts, recommendations, and assumptions into flowing prose.

**Practice extraction by asking yourself:**

- What specific facts did the response state?
- What assumptions did the response make about my context?
- What recommendations depend on those assumptions being correct?

> [!TIP]
> A useful technique: mentally prefix each claim with "The AI claims that..." This framing reminds you that you're dealing with claims to be verified, not established facts.

**Example extraction:**

If Copilot responds: "The `useEffect` hook runs after every render by default, so you'll want to add a dependency array to prevent unnecessary API calls."

Extract the claims:

1. `useEffect` runs after every render by default (testable fact)
2. This default behavior would cause unnecessary API calls in your code (context-dependent assumption)
3. A dependency array will fix the issue (recommendation based on #1 and #2)

### Step 2: Verify Against Reality

Extracted claims need different verification strategies based on their type:

| Claim Type          | Verification Strategy                         |
|---------------------|-----------------------------------------------|
| API/syntax facts    | Check official documentation                  |
| Behavior claims     | Write a minimal test case                     |
| Best practices      | Find multiple authoritative sources           |
| Context assumptions | Compare against your actual code/requirements |

**Verification in practice:**

For the `useEffect` example:

1. **Fact check**: React docs confirm `useEffect` runs after every render without dependencies ✓
2. **Context check**: Does your code actually make an API call in `useEffect`? If not, the recommendation doesn't apply
3. **Recommendation validation**: Would a dependency array solve the specific issue you're facing?

> [!WARNING]
> Don't skip verification because "it sounds right." Plausible-sounding answers are the most dangerous—they pass your intuition filter without engaging your verification instincts.

### Step 3: Learn and Integrate

Verified knowledge becomes part of your engineering toolkit. Unverified answers remain temporary scaffolding.

**After verification, capture:**

- **What you confirmed**: The fact or pattern, now verified
- **What you learned**: Nuances the AI response didn't cover
- **What was wrong**: Corrections to avoid repeating mistakes
- **What depends on context**: Caveats for future application

This step transforms one-time answers into reusable knowledge. The next time you encounter a similar situation, you're not starting from zero—you're applying verified understanding.

## The Pattern in Action: A Complete Example

**Starting question**: "How do I handle authentication errors in my Express middleware?"

**AI response** (abbreviated): "Use a try-catch block and call `next(error)` to pass errors to your error-handling middleware. Make sure to return after calling next to prevent further execution."

**Step 1 - Extract:**

1. Try-catch is appropriate for auth errors (pattern claim)
2. `next(error)` passes to error-handling middleware (API fact)
3. Must return after `next()` to prevent further execution (behavior claim)

**Step 2 - Verify:**

1. Express docs confirm `next(error)` triggers error handlers ✓
2. Test: Does execution continue after `next()`? → Yes, confirmed need to return ✓
3. Check: Is try-catch the right pattern for *your* auth library? → Depends on whether it throws or returns errors

**Step 3 - Learn:**

- Confirmed: `next(error)` + return pattern is correct
- Learned: Express doesn't automatically stop middleware chain on error
- Context note: My auth library returns Result objects, so try-catch wouldn't help—need conditional checking instead

The AI's answer was technically correct but didn't match your library's error handling pattern. Without verification, you might have implemented try-catch around code that never throws.

## Building Verification Habits

The Extract → Verify → Learn pattern becomes faster with practice. Initially, you might explicitly work through each step. Over time, extraction becomes automatic and you develop intuition for which claims need deep verification versus quick confirmation.

**Signs you're developing verification instincts:**

- You automatically notice when the AI makes assumptions about your context
- You catch yourself reaching for documentation before implementing suggestions
- You ask clarifying questions when responses seem too general
- You feel uncomfortable with "just trust it" implementations

## Connecting to Your Workflow

This pattern integrates with the discovery workflow you'll practice in the next section:

- **Timeboxed exploration** gives you bounded time for verification
- **Question trees** help you track which claims you've verified
- **Escalation decisions** factor in verification confidence

When you recognize an incomplete answer (from the previous section), the Extract → Verify → Learn pattern tells you *what* is incomplete. Together, these skills transform you from a passive consumer of AI output into an active collaborator who maintains engineering judgment.

## Exercise: Practice Extraction and Verification

Choose a technical question you genuinely want answered—something relevant to your current work. Ask Copilot in Ask Mode, then:

1. **Extract** at least three distinct claims from the response
2. **Categorize** each claim (fact, assumption, recommendation)
3. **Verify** at least one claim from each category
4. **Document** what you learned that wasn't in the original response

> [!NOTE]
> This exercise takes 15-20 minutes. The time investment now builds habits that save hours of debugging incorrect implementations later.

## Key Takeaways

- AI responses blend facts, assumptions, and recommendations—extraction separates them for verification
- Different claim types require different verification strategies
- Verified knowledge integrates into your toolkit; unverified answers remain temporary
- The pattern becomes faster with practice, eventually becoming an automatic part of your AI collaboration workflow
