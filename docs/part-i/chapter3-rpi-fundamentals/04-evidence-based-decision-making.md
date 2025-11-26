---
title: "Section 4: Evidence-Based Decision Making"
description: Learn to distinguish reliable evidence from AI-generated plausibility and build audit trails
author: HVE Core Team
ms.date: 2025-11-26
chapter: 3
part: I
keywords:
  - evidence-based
  - audit-trails
  - verification
  - source-citations
---

You've learned the RPI workflow and the type transformation mindset. Now comes a critical skill: distinguishing between reliable evidence and AI-generated plausibility.

The RPI framework depends on a critical skill: distinguishing between reliable evidence and AI-generated plausibility. This section teaches you to evaluate information quality and build audit trails that detect and contain hallucinations before they propagate through your work.

## What counts as evidence?

Not all information sources deserve equal weight. The RPI method categorizes evidence into three tiers based on verifiability.

### Strong evidence (✅)

Trust these sources when making technical decisions:

* **Official documentation** with explicit version numbers (not "latest" references)
* **Working code** from your current codebase (verified through execution)
* **Verified examples** from official repositories or maintainer-endorsed sources
* **Stack traces** and error messages from actual execution
* **Test results** showing specific inputs and outputs

**Example of strong evidence:**

> According to the passport-azure-ad v4.3.5 documentation at [passport-azure-ad v4.3.5 README](https://github.com/AzureAD/passport-azure-ad/blob/v4.3.5/README.md), the `BearerStrategy` constructor accepts these parameters: `identityMetadata`, `clientID`, `validateIssuer`, and `passReqToCallback`. This example from the official repository demonstrates the configuration: [link to specific file and line numbers].

### Weak evidence (⚠️)

These sources require additional verification before use:

* **AI-generated examples** without source citations or version context
* **Generic best practices** not tied to specific technologies or versions
* **Advice without version numbers** ("Express uses middleware" vs "Express 4.x uses `app.use()`")
* **Unvalidated patterns** from community forums or blog posts

**Example of weak evidence:**

> Passport typically uses a `realm` parameter for multi-tenant authentication. You can configure it in the strategy options.

This sounds plausible but lacks version specificity, source citation, or verification against official documentation.

### Non-evidence (❌)

Disregard these when making technical decisions:

* **AI confidence statements** ("I'm certain this will work")
* **Plausible API names** that sound correct but aren't verified
* **Unvalidated code** that hasn't been tested or type-checked
* **Anecdotal claims** without reproducible examples

> [!WARNING]
> AI confidence level is not correlated with accuracy. AI will state incorrect information with the same certainty as correct information. Always verify against evidence.

Now that you understand evidence tiers, try evaluating evidence in practice:

> [!TIP]
> **Try This (2 min):** Ask Copilot about a library configuration. Before accepting the suggestion, find the official documentation and compare. Notice any differences between what Copilot suggests and what the docs recommend.

## The evidence trail

Successful RPI workflows maintain an audit trail from research through implementation. Each phase references previous phases, creating accountability for technical decisions.

### Research to plan

Your research document provides source citations for every technical claim:

```markdown
## Azure AD Authentication Configuration

**Source**: passport-azure-ad official documentation  
**URL**: https://github.com/AzureAD/passport-azure-ad#bearerstrategy

### Required Parameters

* `identityMetadata` (string): Metadata endpoint URL
* `clientID` (string): Azure AD application ID
* `validateIssuer` (boolean): Whether to validate token issuer
* `passReqToCallback` (boolean): Whether to pass req to verify callback

**Working Example**:
```typescript
// From official repository examples/bearer-example.js (line 23-28)
const bearerStrategy = new BearerStrategy({
  identityMetadata: 'https://login.microsoftonline.com/common/v2.0/.well-known/openid-configuration',
  clientID: 'your-client-id',
  validateIssuer: true,
  passReqToCallback: false
}, verifyCallback);
```

### Plan to implementation

Your plan references research findings and explains rationale:

```markdown
## Step 3: Configure BearerStrategy

**Reference**: Research document section "Azure AD Authentication Configuration"

**Action**: Create new file `src/auth/azure-strategy.ts` with BearerStrategy configuration

**Rationale**: Using parameters verified in research document from official v4.3.5 documentation. Configuration matches working example from official repository.

**Implementation**:
* Import BearerStrategy from passport-azure-ad
* Configure with identityMetadata, clientID, validateIssuer, passReqToCallback
* Use values from environment variables for clientID
* Set validateIssuer to true for security
```

### Implementation with audit trail

Your implementation includes comments linking back to decisions:

```typescript
// Configuration verified against passport-azure-ad v4.3.5 documentation
// See: research.md section "Azure AD Authentication Configuration"
// See: plan.md step 3 for rationale
const bearerStrategy = new BearerStrategy({
  // Official metadata endpoint from research document
  identityMetadata: 'https://login.microsoftonline.com/common/v2.0/.well-known/openid-configuration',
  
  // Application ID from environment (plan.md step 2)
  clientID: process.env.AZURE_CLIENT_ID!,
  
  // Enable issuer validation for security (research.md security recommendations)
  validateIssuer: true,
  
  // Callback receives user profile only (plan.md step 3)
  passReqToCallback: false
}, verifyCallback);
```

This audit trail lets you trace any implementation decision back to verified evidence.

## When to trust AI, when to verify

Different contexts require different levels of verification.

### Trust (but verify) AI for

* **Boilerplate code generation** following patterns you've established in research
* **Transforming well-defined inputs** (Type 4 precise instructions) into code
* **Suggesting approaches** you'll validate through research phase
* **Explaining concepts** you'll verify against official documentation

### Always verify AI claims about

* **API signatures** and method names in any library or framework
* **Configuration option names** and their acceptable values
* **Version compatibility** between dependencies
* **Performance characteristics** of specific approaches
* **Security implications** of authentication, authorization, or data handling

> [!TIP]
> When AI suggests an API or configuration option, ask: "What documentation confirms this exists?" If AI can't provide a specific source, move the claim to your research task list for manual verification.

## Mini-exercise: Evidence quality assessment

Evaluating evidence can feel tedious at first. But catching hallucinations early is far less tedious than debugging them in production. This quick exercise builds your intuition.

Practice evaluating evidence quality with these scenarios. Rate each as strong (✅), weak (⚠️), or non-evidence (❌).

**Scenario 1:**
> "According to the Express 4.18 documentation at [Express 4.18 API Reference](https://expressjs.com/en/4x/api.html#req), the `req.ip` property contains the remote IP address. I verified this in our codebase at `src/middleware/logging.ts` line 34 where it successfully logs client IPs."

**Scenario 2:**
> "I'm confident that Passport's `realm` parameter will solve your multi-tenant authentication issue. It's a standard OAuth2 pattern that most authentication libraries support."

**Scenario 3:**
> "Stack Overflow user 'expertDev99' posted this solution for Azure AD authentication two years ago. It has 45 upvotes and looks comprehensive."

**Scenario 4:**
> [!NOTE]
> **Answers**: Scenario 1 is strong evidence (✅) - combines official documentation with verified codebase example. Scenario 2 is non-evidence (❌) - relies on AI confidence and generic patterns without verification. Scenario 3 is weak evidence (⚠️) - community content that might be outdated or version-specific, requires verification against current documentation.

## Evidence evaluator ✅

You've practiced distinguishing strong evidence from AI-generated plausibility. This skill becomes automatic with practice—you'll start mentally categorizing evidence sources without conscious effort.

Evidence evaluation helps you verify AI outputs. But what happens when you find problems? The next section covers anti-hallucination strategies—patterns for detection and recovery when things go wrong.

---

**Previous:** [Section 3: The type transformation mindset](./03-type-transformation-mindset.md)

**Next:** [Section 5: Anti-hallucination strategies](./05-anti-hallucination-strategies.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
