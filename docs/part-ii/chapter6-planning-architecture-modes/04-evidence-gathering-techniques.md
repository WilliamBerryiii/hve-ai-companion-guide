---
title: Evidence gathering techniques
description: Master systematic techniques for gathering internal and external evidence, triangulating findings, and assessing research completeness
author: HVE Core Team
ms.date: 2025-11-19
chapter: 6
part: "II"
section: 4
type: content-section
parent: chapter6-planning-architecture-modes
prerequisites:
  - Completed Section 3 - Research document structure
  - Understanding of research document template
estimated_reading_time: 20
keywords:
  - evidence gathering
  - code search techniques
  - triangulation
  - research completeness
  - mcp tools
---

Effective research depends on systematic evidence gathering from multiple authoritative sources. This section teaches you how to extract evidence from internal codebases, consult external documentation, and verify findings through triangulation.

## Internal codebase exploration

Your project's existing code is your most reliable evidence source. It shows current patterns, conventions, and architectural decisions in practice.

### File search: Finding specific files

Use `file_search` when you know part of a filename or need to locate files by pattern.

**Purpose:** Locate configuration files, implementation files, or files matching naming conventions.

**When to use:**

* Finding configuration files (`config.json`, `tsconfig.json`, `.env`)
* Locating test files for specific modules
* Discovering files following naming patterns (`*.service.ts`, `*Repository.js`)

**Example:**

```text
Search for authentication-related files:
Pattern: **/*auth*.{ts,js}

Results might include:
- src/auth/authService.ts
- src/middleware/authMiddleware.js
- tests/auth/authService.test.ts
```

This reveals where authentication logic lives and what patterns your project uses.

### Code search: Pattern matching across files

Use `grep_search` to find specific code patterns, function calls, or text across your entire codebase.

**Purpose:** Discover usage patterns, find all calls to a function, or locate specific implementation patterns.

**When to use:**

* Finding all usages of a library or function
* Discovering existing error handling patterns
* Locating configuration usage
* Identifying where specific APIs are called

**Example:**

```text
Search for all uses of JWT token generation:
Pattern: jwt.sign (literal text)

Results:
- src/auth/tokenService.ts (Line 34): const token = jwt.sign(payload, secret)
- src/middleware/refresh.ts (Line 67): jwt.sign({ userId }, refreshSecret)
```

This shows you exactly how your project creates JWT tokens and where.

### Semantic search: Concept-based discovery

Use `semantic_search` when you don't know exact function names or patterns but understand the concept you're looking for.

**Purpose:** Find code that handles specific concepts even when exact keywords aren't known.

**When to use:**

* Understanding how your project handles authentication without knowing exact function names
* Finding error handling patterns without knowing specific error classes
* Discovering database query patterns when you don't know the ORM methods

**Example:**

```text
Query: "How does this project validate user input?"

Semantic search might return:
- src/validators/userValidator.js (validation middleware)
- src/middleware/validation.ts (Joi schema validation)
- tests/validators/integration.test.js (validation test examples)
```

This discovers validation approaches even if they use different libraries or naming conventions.

### Read file: Examining specific implementations

Use `read_file` to examine complete implementations once you've identified relevant files.

**Purpose:** Read complete functions, classes, or configuration files to understand implementation details.

**When to use:**

* Reading discovered configuration files
* Examining implementation patterns from search results
* Understanding complete function logic with context

**Best practices:**

* Use line ranges when files are large (offset/limit parameters)
* Read surrounding context (10-20 lines before/after target code)
* Note line numbers for citations in your research document

### List code usages: Tracing implementations

Use `list_code_usages` to find all places where a function, class, or method is used.

**Purpose:** Understand impact of changes, find usage examples, discover implementation patterns.

**When to use:**

* Planning to modify a function (need to know all call sites)
* Finding real-world usage examples of a pattern
* Understanding how interfaces are implemented across codebase

**Example:**

```text
Find all implementations of authentication middleware:
Symbol: isAuthenticated

Results:
- src/routes/users.js (Line 23): router.get('/profile', isAuthenticated, ...)
- src/routes/admin.js (Line 15): router.post('/users', isAuthenticated, ...)
- src/routes/api.js (Line 45): router.put('/settings', isAuthenticated, ...)
```

This shows exactly where authentication checks happen and how they're applied.

## External documentation research

Internal code shows what exists; external documentation shows what's possible and recommended.

### MCP Context7: SDK and API documentation

Context7 provides access to official SDK documentation, API references, and technical guides through MCP integration.

**Purpose:** Research official library APIs, framework capabilities, and recommended patterns from authoritative sources.

**When to use:**

* Investigating library features and APIs
* Finding code examples from official documentation
* Verifying API signatures and parameters
* Discovering framework capabilities

**Example invocation:**

```typescript
// Research Passport.js strategy API
// MCP Context7 provides access to Passport.js documentation
// Query: "Passport.js custom strategy implementation"

// Response includes:
// - Strategy class interface
// - Required methods (authenticate, success, fail)
// - Example implementations
// - Best practices from official docs
```

**Evidence citation:**

```markdown
**Documentation Sources:**
* Passport.js Official Docs - <https://www.passportjs.org/docs/> (Accessed: 2025-11-19)
  * Custom strategy requires extending Strategy class
  * Must implement authenticate(req, options) method
  * Call this.success(user) or this.fail(info) based on result
```

### Web fetch: Official project documentation

Use web fetch MCP tool to retrieve content from official documentation sites, GitHub repositories, and authoritative technical resources.

**Purpose:** Gather evidence from project READMEs, documentation sites, RFC specifications, and technical standards.

**When to use:**

* Reading library documentation that's not in Context7
* Accessing GitHub README files and wikis
* Consulting RFC specifications (e.g., RFC 6238 for TOTP)
* Reviewing security advisories and best practices

**Example invocation:**

```typescript
// Fetch speakeasy library documentation
// URL: https://github.com/speakeasyjs/speakeasy/blob/master/README.md

// Response includes:
// - Installation instructions
// - API reference
// - Usage examples
// - Security considerations
```

**Evidence citation:**

```markdown
**External Research (Evidence Log):**
* Speakeasy Library GitHub - <https://github.com/speakeasyjs/speakeasy> (Accessed: 2025-11-19)
  * Implements TOTP and HOTP per RFC 6238 and RFC 4226
  * 5.2k GitHub stars, actively maintained (last commit Oct 2025)
  * Provides generateSecret(), totp.verify(), and QR code generation
  * Used by major platforms: Twilio, Okta integration examples
```

Access dates matter because documentation evolves. Six months later, reviewers can verify recommendations still apply.

> [!WARNING]
> Always verify documentation version compatibility with your project dependencies. Library version 2.x documentation may not apply to your project's version 1.x implementation.

### Combining internal and external evidence

Effective research triangulates internal patterns with external recommendations.

**Pattern:**

1. **Discover internal pattern** using code search
2. **Identify library/framework** being used
3. **Consult official documentation** via MCP tools
4. **Verify pattern matches recommendations**
5. **Document both in evidence log**

**Example:**

```markdown
### File Analysis
* `src/auth/passportConfig.js` (Lines 12-35) - Uses Passport.js LocalStrategy for username/password authentication
* `src/models/user.js` (Lines 23-45) - User model has passwordHash field, uses bcrypt for hashing

### External Research
* Passport.js Official Docs (Accessed: 2025-11-19)
  * LocalStrategy configuration matches project pattern
  * Recommends bcrypt for password hashing (project follows this)
* bcrypt npm package (Accessed: 2025-11-19)
  * Current version: 5.1.1
  * Project uses 5.1.0 (compatible, minor version behind)

### Key Discovery
Project follows Passport.js recommended patterns correctly. Existing auth structure is well-architected and extensible for adding 2FA as additional middleware.
```

This triangulation gives you confidence in your recommendations because they're grounded in both current practice and authoritative guidance.

## Triangulating evidence

Triangulation means verifying findings through multiple independent sources. Single-source claims are prone to error; multi-source verification builds confidence.

### Cross-referencing techniques

**Three-source verification:**

1. **Internal codebase**: What does current implementation show?
2. **Official documentation**: What do library maintainers recommend?
3. **Community practice**: What do production systems at scale demonstrate?

#### Example: Verifying TOTP window parameter

```markdown
**Claim:** TOTP verification should use window parameter of 1 for production systems.

**Evidence 1 - Internal Code:**
* `src/auth/mfaVerify.js` (Line 45): Uses window: 1 in speakeasy.totp.verify()
* Comment indicates 30-second time step tolerance

**Evidence 2 - Official Documentation:**
* RFC 6238 Section 5.2 (Accessed: 2025-11-19)
  * Recommends allowing one time-step variance
  * Window of 1 means ±30 seconds tolerance
* Speakeasy documentation (Accessed: 2025-11-19)
  * window parameter defines time-step tolerance
  * window: 1 is recommended default for production

**Evidence 3 - Community Practice:**
* Twilio's 2FA implementation guide (Accessed: 2025-11-19)
  * Uses window: 1 in their examples
  * Notes this balances security with user experience
* Auth0 TOTP documentation (Accessed: 2025-11-19)
  * Recommends window: 1 for most applications
  * Higher values (2-3) only for high-latency scenarios

**Conclusion:** window: 1 is verified correct choice through internal code, official specs, and industry practice.
```

This level of triangulation prevents hallucination and gives implementation teams confidence.

### Consistency checks

Verify that evidence sources agree or understand why they differ.

**When sources agree:**
✅ High confidence in recommendation
✅ Document all agreeing sources
✅ Note the consensus in Key Discoveries

**When sources conflict:**
⚠️ Investigate the conflict
⚠️ Determine which source is authoritative for your context
⚠️ Document why you chose one over another

#### Example: Conflicting recommendations

```markdown
**Conflict:** Session token expiration time

**Source 1 - Internal Code:**
* `config/auth.js` (Line 23): tokenExpiry: '24h'

**Source 2 - OWASP Recommendations:**
* OWASP Session Management Cheat Sheet (Accessed: 2025-11-19)
  * Recommends 2-8 hour session timeout for sensitive applications

**Source 3 - Project Requirements:**
* `docs/requirements.md` (Line 78): "Users should remain logged in for extended periods to avoid friction"

**Resolution:**
Conflict stems from different priorities: security vs user experience. Project requirement explicitly prioritizes convenience. Current 24-hour timeout is intentional trade-off.

**Recommendation:**
Keep 24-hour timeout but implement:
1. Sliding expiration (renew on activity)
2. Additional 2FA requirements for sensitive operations
3. Detection of suspicious session activity

This balances project requirements with security best practices.
```

Documenting conflicts and resolutions prevents future confusion.

### Authority hierarchy

When sources conflict, use this authority hierarchy:

1. **Project-specific requirements** (highest authority for this project)
2. **Official specifications/RFCs** (technical correctness)
3. **Library/framework official documentation** (implementation guidance)
4. **Industry best practices** (community wisdom)
5. **Individual blog posts/Stack Overflow** (lowest, verify through other sources)

Never rely solely on Stack Overflow or blog posts. Use them as starting points, then verify through official sources.

## Assessing research completeness

How do you know when you've researched enough? Use these criteria.

### Completeness criteria

Research is complete when you can answer these questions with evidence:

1. **✅ Can you explain the decision to someone unfamiliar with the project?**
   * If no: Gather more context about the problem being solved

2. **✅ Have you identified at least 2-3 viable alternatives?**
   * If no: Broaden your search for alternative approaches

3. **✅ Can you articulate trade-offs for each alternative?**
   * If no: Research pros/cons more deeply

4. **✅ Do you have evidence from internal codebase?**
   * If no: Search for existing patterns and conventions

5. **✅ Do you have evidence from official documentation?**
   * If no: Consult library docs, RFCs, or specifications

6. **✅ Can you cite line numbers or URLs for every claim?**
   * If no: Return to sources and capture specific references

7. **✅ Have you verified findings through triangulation?**
   * If no: Cross-reference claims across multiple sources

**When all answers are yes:** You have sufficient evidence to create a high-quality research document.

### Knowing when to stop

Research can expand infinitely. These signals indicate you should move to planning:

**Stop researching when:**

* ✅ You've identified preferred approach with solid evidence
* ✅ Alternative approaches are documented with trade-offs
* ✅ You understand implementation requirements clearly
* ✅ You've reached your time-box (20-60 minutes for Task Researcher)
* ✅ Additional research yields diminishing returns

**Continue researching if:**

* ❌ Unclear which approach to recommend
* ❌ Missing key trade-offs between alternatives
* ❌ Can't find evidence for critical claims
* ❌ Internal code patterns contradict external recommendations without understanding why

Trust the completeness criteria. If you can answer all seven questions with specific evidence, you have enough to proceed.

## Exercise 6.2: Evidence triangulation practice

**Objective:** Practice verifying a technical claim through multiple evidence sources.

**Time:** 10-15 minutes

**Scenario:** You're researching API rate limiting for your Express.js application. You found a recommendation to use the `express-rate-limit` package, but you want to verify this through triangulation.

**Instructions:**

1. **Identify three evidence sources** you would consult:
   * Internal: Where might existing rate limiting appear in your codebase? (search patterns to try)
   * Official: What official documentation would you consult?
   * Community: What production examples would validate this choice?

2. **Plan your search strategy:**
   * What `grep_search` patterns would find existing rate limiting?
   * What files would you examine with `read_file`?
   * What MCP tool queries would fetch relevant documentation?

3. **Document potential conflicts:**
   * What might cause different sources to recommend different approaches?
   * How would you resolve conflicts using the authority hierarchy?

4. **Define completeness criteria:**
   * What evidence would you need to confidently recommend `express-rate-limit`?
   * What alternatives should you evaluate for comparison?

**Success criteria:**

* Listed specific search patterns for internal code
* Identified official documentation sources with URLs
* Described triangulation approach with 3+ sources
* Defined what evidence would constitute "enough" research

**Extension challenge (optional):** Actually perform the research using MCP tools and code search. Create a mini evidence log with citations from each source type.

---

**Previous:** [Research document structure](./03-research-document-structure.md) | **Next:** [Chapter summary](./05-summary.md) | **Up:** [Chapter 6 - Task Researcher](./README.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
