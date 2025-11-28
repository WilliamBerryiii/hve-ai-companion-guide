---
title: Research document structure
description: Complete template and section-by-section guide for creating evidence-based research documents that prevent hallucination
author: HVE Core Team
ms.date: 2025-11-19
chapter: 6
part: "II"
section: 3
type: content-section
parent: chapter6-planning-architecture-modes
prerequisites:
  - Completed Section 2 - Task Researcher capabilities
  - Understanding of MCP tools integration
estimated_reading_time: 18
keywords:
  - research document template
  - evidence logging
  - technical scenarios
  - scope definition
  - key discoveries
---

# Research document structure

The research document is Task Researcher's core artifact. It transforms scattered investigation into structured evidence that guides implementation. This section provides the complete template and explains how to use each section effectively.

## The research document template

Research documents follow a standardized structure that ensures completeness and prevents hallucination through systematic evidence tracking.

Create your research document in `.copilot-tracking/research/` using this naming pattern:

```text
YYYYMMDD-feature-description-research.md
```

Example: `20251119-authentication-2fa-research.md`

Here's the complete template:

```markdown
<!-- markdownlint-disable-file -->
# Task Research Document: [Feature/System Name]

[Full description of what's being researched and why this research is needed]

## Task Implementation Requests

[Quote the exact user request that triggered this research]

**Interpreted Requirements:**
* [Specific requirement 1]
* [Specific requirement 2]
* [Specific requirement 3]

## Scope and Success Criteria

**Scope:**
* What this research covers
* What this research explicitly excludes

**Assumptions:**
* [Enumerated assumption 1]
* [Enumerated assumption 2]

**Success Criteria:**
* [Measurable criterion 1]
* [Measurable criterion 2]

## Research Executed

### File Analysis

**Files Examined:**
* `path/to/file.ext` (Lines X-Y) - [What was learned]
* `path/to/another.ext` (Lines A-B) - [What was learned]

### Code Search Results

**Pattern:** `search-pattern`
**Results:** [Number] matches found
**Key Findings:**
* [Finding 1 with file reference]
* [Finding 2 with file reference]

### External Research (Evidence Log)

**Documentation Sources:**
* [Library/Framework Name] Official Docs - <https://url.com> (Accessed: YYYY-MM-DD)
  * [Key finding 1]
  * [Key finding 2]
* [API Reference] - <https://url.com> (Accessed: YYYY-MM-DD)
  * [Key finding]

**Standards/RFCs:**
* [Standard Name] - <https://url.com> (Accessed: YYYY-MM-DD)
  * [Relevant requirement]

### Project Conventions

**Discovered Patterns:**
* [Pattern 1 with example location]
* [Pattern 2 with example location]

**Configuration Approach:**
* [How this project handles configuration]

## Key Discoveries

### Project Structure

[Relevant project organization findings]

### Implementation Patterns

[Code patterns and conventions discovered]

### Complete Examples

[Full code examples showing patterns in action]

## Technical Scenarios

### Scenario 1: [Feature Name]

**Requirements:**
* [Requirement 1]
* [Requirement 2]

**Preferred Approach:**
[Recommended implementation with rationale]

**Implementation Details:**
```language
// Code example showing approach
```
```markdown

**Alternatives Considered:**
1. [Alternative 1] - [Why not chosen]
2. [Alternative 2] - [Why not chosen]

### Scenario 2: [Next Feature]

[Repeat structure]
```

> [!NOTE]
> Maintain strict evidence organization throughout your research. Every claim should trace back to a specific file, URL, or code search result with line numbers or access dates.

## Required sections breakdown

Let's examine each section's purpose and how to fill it effectively.

### Task Implementation Requests

This section captures the original user request and your interpretation. Quote the user's exact words, then break down what they need into specific, measurable requirements.

**Example:**

```markdown
## Task Implementation Requests

"Add two-factor authentication to user login so we can meet security compliance requirements."

**Interpreted Requirements:**
* Implement TOTP-based 2FA (Time-based One-Time Password)
* Integrate with existing user authentication system
* Provide setup flow for users to register their devices
* Support backup codes for account recovery
* Meet security compliance standards (cite specific standard if known)
```

This prevents scope drift. When you document requirements clearly, you can verify your research addresses everything the user needs.

### Scope and Success Criteria

Define boundaries explicitly. State what you're researching and what you're deliberately excluding. This prevents endless investigation into tangential topics.

**Example:**

```markdown
## Scope and Success Criteria

**Scope:**
* Research TOTP library options compatible with our Node.js backend
* Document integration approach with existing Express authentication
* Identify database schema changes needed
* Design user setup flow

**What's excluded:**
* SMS-based 2FA (compliance requires TOTP)
* Biometric authentication
* Hardware security keys

**Assumptions:**
* Users have smartphones capable of running authenticator apps
* Database supports schema migrations
* Frontend can handle QR code display

**Success Criteria:**
* Identified TOTP library with active maintenance and good security record
* Documented complete integration approach with code examples
* Database schema changes defined
* User flows mapped out with failure scenarios
```

Clear scope prevents hallucination by giving you specific targets to hit with evidence.

### Evidence Log

This is your hallucination prevention core. Every external claim needs a citation with an access date. Every internal finding needs a file path and line range.

**File Analysis Example:**

```markdown
### File Analysis

**Files Examined:**
* `src/auth/passport-config.js` (Lines 15-87) - Uses Passport.js with local strategy for username/password authentication
* `src/models/user.js` (Lines 23-45) - User model has email, passwordHash fields; no 2FA fields exist yet
* `src/routes/auth.js` (Lines 12-78) - Current login endpoint at POST /api/auth/login
```

**External Research Example:**

```markdown
### External Research (Evidence Log)

**Documentation Sources:**
* Speakeasy Library Official Docs - <https://github.com/speakeasyjs/speakeasy> (Accessed: 2025-11-19)
  * TOTP implementation following RFC 6238
  * Active maintenance (last commit 2025-10-15)
  * 5.2k stars, widely adopted
* Express Rate Limiting - <https://github.com/express-rate-limit/express-rate-limit> (Accessed: 2025-11-19)
  * Required for 2FA verification endpoint protection
  * Prevents brute force attacks on TOTP codes
```

Access dates matter because documentation changes. When someone reviews your research six months later, they can verify if recommendations still apply.

## Key discoveries and technical scenarios

These sections synthesize your evidence into actionable insights and specific implementation approaches.

### Key Discoveries

Organize discoveries by category. Show patterns you found across multiple evidence sources.

**Example:**

```markdown
## Key Discoveries

### Project Structure

Authentication logic centralized in `src/auth/` directory. All Passport.js strategies configured in `passport-config.js`. Middleware functions in `src/auth/middleware.js` handle route protection.

### Implementation Patterns

Project uses async/await consistently throughout auth code. Error handling follows pattern: catch errors, log with Winston, return standardized error response with status codes.

### Complete Examples

Current authentication flow from `src/routes/auth.js` (Lines 34-67):
```javascript
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findByEmail(email);
    
    if (!user || !await user.comparePassword(password)) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }
    
    const token = jwt.sign({ userId: user.id }, process.env.JWT_SECRET);
    res.json({ token, user: user.safeProfile() });
  } catch (error) {
    logger.error('Login error:', error);
    res.status(500).json({ error: 'Server error' });
  }
});
```
```markdown

This pattern must be extended to handle 2FA verification step.
```

Notice how discoveries tie back to specific code locations. No vague "the codebase follows best practices" claims without evidence.

### Technical Scenarios

Document specific implementation approaches with alternatives. Show the recommended path and explain why you chose it over other options.

**Example:**

```markdown
## Technical Scenarios

### Scenario 1: Two-Factor Authentication Setup Flow

**Requirements:**
* User initiates 2FA setup from account settings
* System generates TOTP secret and displays QR code
* User scans QR code with authenticator app
* User verifies setup by entering first code
* System stores encrypted TOTP secret in database

**Preferred Approach:**
Use speakeasy library for TOTP generation. Store encrypted secrets using existing project encryption utility (`src/utils/encryption.js`).

**Implementation Details:**

Database migration (add to `src/models/user.js`):
```javascript
{
  twoFactorSecret: {
    type: DataTypes.STRING,
    allowNull: true, // null = 2FA not enabled
  },
  twoFactorEnabled: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
  },
  backupCodes: {
    type: DataTypes.JSON,
    allowNull: true,
  }
}
```

Setup endpoint (new route in `src/routes/auth.js`):
```javascript
router.post('/setup-2fa', requireAuth, async (req, res) => {
  const secret = speakeasy.generateSecret({
    name: `YourApp (${req.user.email})`
  });
  
  // Store temporarily, confirmed on verification
  await req.user.update({
    twoFactorSecret: encrypt(secret.base32)
  });
  
  res.json({
    qrCode: secret.otpauth_url,
    secret: secret.base32 // for manual entry
  });
});
```

Verification middleware (add to `src/auth/middleware.js`):
```javascript
async function verify2FA(req, res, next) {
  const { token } = req.body;
  const user = req.user;
  
  if (!user.twoFactorEnabled) {
    return next();
  }
  
  const verified = speakeasy.totp.verify({
    secret: decrypt(user.twoFactorSecret),
    encoding: 'base32',
    token,
    window: 1 // Allow 1 time-step tolerance
  });
  
  if (!verified) {
    return res.status(401).json({ error: 'Invalid 2FA code' });
  }
  
  next();
}
```
```markdown

**Alternatives Considered:**
1. **OTP library** - Less actively maintained, last update 2 years ago
2. **node-2fa** - No TypeScript definitions, smaller community
3. **Custom TOTP implementation** - High risk of security bugs, not recommended

Speakeasy provides best balance of security, maintenance, and community support.

### Scenario 2: Account Recovery with Backup Codes

**Requirements:**
* Generate 10 single-use backup codes during 2FA setup
* Allow user to download codes
* Accept backup code in place of TOTP during login
* Invalidate used codes

**Preferred Approach:**
Generate cryptographically random 8-character alphanumeric codes, store hashed in database. Use same bcrypt approach as passwords.

[Implementation details follow same pattern...]
```

Each scenario provides enough detail that someone can implement it without guessing. This is what separates Task Researcher documents from quick Ask Mode responses.

## Exercise 6.1: Create your first research document

**Objective:** Apply the research document template to a realistic integration scenario.

**Time:** 15-20 minutes

**Scenario:** Your team needs to add pagination to an existing REST API endpoint that currently returns all records. The endpoint is `GET /api/products` in a Node.js Express application. You need to research the best approach.

**Instructions:**

1. Create a new research document: `.copilot-tracking/research/YYYYMMDD-api-pagination-research.md`
2. Fill in the Task Implementation Requests section with this scenario
3. Define scope (what pagination features to include) and success criteria
4. Document what you'd search for in the Research Executed section:
   * What files would you examine?
   * What code search patterns would you use?
   * What external documentation would you reference?
5. In Key Discoveries, note what you'd expect to find about the project's database layer and API patterns
6. In Technical Scenarios, outline one pagination approach with:
   * Requirements (query parameters, response format)
   * Implementation sketch (route changes, database query modifications)
   * At least one alternative approach with pros/cons

**Success criteria:**
* All major template sections filled with realistic content
* Evidence sources specified (even if you haven't gathered them yet)
* At least one technical scenario with implementation details
* Clear scope boundaries defined

**Extension challenge (optional):** Research actual pagination approaches by examining a real codebase or consulting documentation. Fill your research document with actual evidence and citations.

---

**Previous:** [Task Researcher capabilities](./02-task-researcher-capabilities.md) | **Next:** [Evidence gathering techniques](./04-evidence-gathering-techniques.md) | **Up:** [Chapter 6 - Task Researcher](./README.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
