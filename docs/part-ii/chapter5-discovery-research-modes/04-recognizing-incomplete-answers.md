---
title: "Recognizing Incomplete Answers"
description: Identify 5 red flags for insufficient AI responses and apply probing techniques to get actionable guidance
author: HVE Core Team
ms.date: 2025-11-26
chapter: 5
part: "II"
keywords:
  - incomplete-answers
  - red-flags
  - probing-techniques
  - answer-quality
  - escalation
---

AI responses vary in quality. Some provide precise, actionable guidance. Others offer generic advice that could apply to any codebase. Learning to recognize red flags—signals that answers are insufficient, speculative, or hallucinated—is essential for effective discovery.

This section teaches you 5 red flags indicating incomplete answers, probing techniques to get better responses, and decision criteria for when answers are "good enough" versus when to escalate.

## 5 Red Flags for Insufficient Answers

### Red Flag 1: Generic Advice Without Codebase Context

**Example:**

```text
You: @workspace How should I implement error handling?
Bad Answer: "Use try-catch blocks and log errors to a logging service. 
            Consider using structured logging with correlation IDs."
```

**Why it's bad:** Generic advice that could apply to any codebase. Doesn't reference your specific patterns, files, or conventions.

**Better question:** `@workspace Show me how existing services in src/services/ handle errors`

**Expected answer:** "Services use Result<T, E> pattern. See UserService.ts lines 45-67 for canonical implementation."

### Red Flag 2: "It Depends" Without Specifics

**Example:**

```text
You: @workspace Which database migration tool should I use?
Bad Answer: "Several options exist: Flyway, Liquibase, or custom scripts. 
            Choice depends on your requirements."
```

**Why it's bad:** Doesn't tell you what THIS codebase uses or recommends.

**Better question:** `@workspace What database migration tools are currently configured in this project?`

**Expected answer:** "Project uses Flyway. See db/migrations/ directory and flyway.conf configuration."

### Red Flag 3: Multiple Approaches Without Disambiguation

**Example:**

```text
You: @workspace How do components share configuration?
Bad Answer: "I see environment variables, JSON config files, and database 
            configuration tables used across the codebase."
```

**Why it's incomplete:** Which is current? Which should new code use? What's legacy?

**Follow-up needed:** `@workspace Which configuration approach is standard for new components? Which are legacy?`

**Expected answer:** "Environment variables via .env files (current standard). JSON config files are legacy, being phased out per CONTRIBUTING.md."

### Red Flag 4: No Source Citations

**Example:**

```text
You: @workspace What's the API versioning strategy?
Bad Answer: "APIs should be versioned using URL path versioning with v1, v2, etc."
```

**Why it's suspicious:** No reference to actual files or examples in your codebase. Could be hallucination or generic best practices.

**Probe deeper:** `@workspace Show me an actual example of API versioning in this codebase`

**Expected answer:** "See src/api/v1/ and src/api/v2/ directories. Routes defined in src/routes/index.ts lines 12-45. Current APIs use v2, v1 is deprecated."

### Red Flag 5: Confident but Vague

**Example:**

```text
You: @workspace How do I integrate with the PaymentService?
Bad Answer: "PaymentService provides a REST API for processing payments. 
            Use standard HTTP requests with proper authentication."
```

**Why it's insufficient:** No specifics—endpoint URLs, auth method, request format, where to find API documentation.

**Better question:** `@workspace Show me an existing service that integrates with PaymentService`

**Expected answer:** "OrderService integrates with PaymentService. See src/services/order/payment-client.ts for API client implementation. Uses bearer token auth, endpoints documented in PaymentService OpenAPI spec at docs/api/payment-service.yaml."

## Probing Techniques for Better Answers

### Technique 1: Request Specific Examples

Transform generic advice into concrete code references.

**Generic answer:** "Services use dependency injection"

**Your probe:** `@workspace Show me the dependency injection pattern with file and line numbers`

**Better answer:** "See UserController.ts lines 12-18 for constructor injection pattern. Dependencies registered in src/di-container.ts."

### Technique 2: Ask for Comparisons

Surface distinctions between approaches and identify current standard.

**Vague answer:** "Multiple logging approaches exist"

**Your probe:** `@workspace Compare the logging approaches and tell me which is newest`

**Better answer:** "Winston (8 files, newer) vs console.log (12 files, legacy). New code should use Winston per CONTRIBUTING.md. See Logger.ts for Winston configuration."

### Technique 3: Request Documentation References

Find written guidance that supplements code examples.

**Uncertain answer:** "Authentication might use OAuth"

**Your probe:** `@workspace Where is authentication documented in this project?`

**Better answer:** "See docs/architecture/authentication.md and src/auth/README.md. OAuth 2.0 implementation documented with examples."

### Technique 4: Validate with File Contents

Verify claims by requesting actual code.

**Suspicious answer:** "Config uses environment variables exclusively"

**Your probe:** `@workspace Show me the actual configuration loading code`

**Better answer:** "src/config/index.ts loads from .env files with dotenv. Lines 5-23 show the implementation. Falls back to default values defined in config.defaults.ts."

## When Generic Becomes Specific Enough

### Decision Criteria

**Specific Enough (Proceed):**

* References actual files in your codebase with line numbers
* Cites examples you can verify by reading the code
* Provides concrete patterns/conventions with clear usage guidelines
* Disambiguates between current and legacy approaches
* Gives you an actionable next step (implementation or research)

**Still Too Generic (Probe Deeper):**

* Advice that could apply to any codebase
* No file references or examples
* "Best practices" without context
* Multiple options without recommendation
* You're still uncertain what to do next

### Example Comparison

**Too Generic:**

```text
"Implement authentication using industry-standard OAuth 2.0 with JWT tokens. 
Ensure proper token validation and refresh token handling."
```

**Specific Enough:**

```text
"This codebase uses Passport.js (v0.6.0) with JWT strategy. See:
- Configuration: src/config/passport.ts (lines 12-45)
- Middleware: src/middleware/authenticate.ts (lines 8-23)
- Token generation: src/services/AuthService.ts (lines 67-89)
- Example usage: src/controllers/UserController.ts (line 15)

New routes should use requireAuth middleware (see authenticate.ts)"
```

## Making the Escalation Decision

After applying probing techniques, you have enough information to decide your next step. Refer to Section 2's escalation triggers to determine whether to:

* **Proceed to implementation** - You have file paths, canonical exemplars, and clear understanding
* **Escalate to Task Researcher** - You need comprehensive documentation or team-shareable artifacts
* **Seek human input** - Red flags persist despite probing, or domain expertise is required

> [!TIP]
> **The "Can I implement from this?" test:** If you could start implementing based solely on the Ask Mode answer, it's specific enough. If you still need to search for files or patterns, probe deeper or escalate.

---

**Previous**: [Section 3: Effective Question Formulation](./03-effective-question-formulation.md) | **Next**: [Section 5: Extract → Verify → Learn](./05-extract-verify-learn.md) | **Up**: [Chapter 5 README](./README.md)

---

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
