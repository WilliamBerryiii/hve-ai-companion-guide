---
title: "Introduction: Why Systematic Planning Matters"
description: Understand when manual planning becomes insufficient and how Task Planner creates dependency-aware implementation blueprints
author: HVE Core Team
ms.date: 2025-11-26
chapter: 7
part: "II"
keywords:
  - task-planner
  - implementation-planning
  - dependencies
  - systematic-planning
---

## Introduction: Why Systematic Planning Matters

You learned to create implementation plans manually in Chapter 4, taking research findings and organizing them into actionable steps. This approach works for simple features but breaks down as complexity increases.

This section explores when manual planning becomes insufficient and how Task Planner mode transforms complex research into structured, dependency-aware implementation plans.

## Escalation from Manual Planning

Manual planning served you well for straightforward features. You identified steps, ordered them logically, and executed them one by one. This workflow succeeds when requirements are simple and dependencies are obvious.

**Manual planning works when:**

* Feature requires 3-5 implementation steps
* No complex dependencies between steps
* You're familiar with the codebase structure
* Single developer owns the work

**Manual planning breaks down when:**

* **Complex dependencies emerge**: Steps must execute in specific order with multiple prerequisites
* **Multiple subsystems require coordination**: Database, API, UI, authentication all need changes
* **Team collaboration increases**: Plan becomes contract between multiple developers
* **Risk escalates**: High-impact changes need verification checklists to prevent breakage

Consider a feature like "Add two-factor authentication." Manual planning might produce:

```markdown
## Implementation Plan: 2FA Feature

1. Install speakeasy library
2. Add 2FA setup endpoint
3. Generate QR codes
4. Verify TOTP tokens
5. Update login flow
6. Add tests
```

This plan has critical gaps:

* Missing database schema changes (where does the secret get stored?)
* No error handling strategy (what if QR generation fails?)
* Unclear implementation order (can you update login before endpoints exist?)
* No verification criteria (how do you know each step succeeded?)
* Missing integration details (how does this connect to existing auth?)

Task Planner addresses these gaps through systematic structure.

## Task Planner's Systematic Approach

Task Planner transforms the manual plan above into a dependency-aware, verifiable implementation blueprint:

```markdown
## Implementation Plan: 2FA Feature

### Prerequisites
- Database migration for user.twoFactorSecret field
- Update User model with 2FA fields
- Install dependencies (speakeasy@2.0.0, qrcode@1.5.3)

### Phase 1: Data Layer (no dependencies)
- [ ] Step 1.1: Create migration `20240115_add_2fa_fields.ts`
  - Add user.twoFactorSecret (encrypted text)
  - Add user.twoFactorEnabled (boolean, default false)
  - Add user.twoFactorBackupCodes (encrypted json array)
  - Verification: Migration runs without errors, fields visible in database
  
- [ ] Step 1.2: Update User model (`src/models/User.ts`, lines 45-60)
  - Add fields to TypeScript interface
  - Add validation rules for twoFactorSecret format
  - Verification: TypeScript compiles, no type errors
  
- [ ] Step 1.3: Run migration and verify schema
  - Execute: `npm run migrate:latest`
  - Verification: Query database, confirm all three fields exist

### Phase 2: 2FA Setup Flow (depends on: Phase 1)
- [ ] Step 2.1: Create `/api/auth/2fa/setup` endpoint
  - Location: `src/auth/authRoutes.ts`, after line 78
  - Generate secret using speakeasy.generateSecret()
  - Return QR code data URL using qrcode.toDataURL()
  - Store encrypted secret in user.twoFactorSecret
  - Verification: POST request returns valid QR code data URL

- [ ] Step 2.2: Create setup UI component
  - Location: New file `src/components/TwoFactorSetup.tsx`
  - Display QR code image from data URL
  - Show manual entry code as fallback
  - Add token verification input field
  - Verification: Component renders without errors, displays QR code

- [ ] Step 2.3: Create `/api/auth/2fa/verify-setup` endpoint
  - Location: `src/auth/authRoutes.ts`, after setup endpoint
  - Verify token using speakeasy.totp.verify()
  - Set user.twoFactorEnabled = true on success
  - Generate and store backup codes (10 codes, bcrypt hashed)
  - Verification: Valid token enables 2FA, invalid token returns 400 error

### Phase 3: Login Integration (depends on: Phase 2)
- [ ] Step 3.1: Modify login endpoint for 2FA check
  - Location: `src/auth/authRoutes.ts`, login function (lines 120-145)
  - After password verification, check user.twoFactorEnabled
  - If true, require totpToken in request body
  - Verify token using speakeasy.totp.verify()
  - Return 401 if token missing or invalid
  - Verification: Login succeeds with valid token, fails without token or with invalid token
```

**Key improvements:**

* **Explicit prerequisites**: Database and model changes happen first
* **Dependency tracking**: Phase 2 can't start until Phase 1 completes
* **File-level specificity**: Plan references actual files and line numbers
* **Verification criteria**: Each step defines "done when" conditions
* **Error scenarios**: Plan includes validation for failure cases

## Hallucination Prevention Through Structure

Task Planner continues the anti-hallucination strategy you learned with Task Researcher in Chapter 6. Where research mode prevented hallucination through evidence citations and source references, planning mode prevents it through structured grounding in research findings.

**Research phase prevented hallucination by:**

* Requiring evidence citations for every claim
* Comparing alternatives with objective criteria
* Documenting findings with source references
* Making reasoning explicit and reviewable

**Planning phase prevents hallucination by:**

* **Grounding in research findings**: Every implementation step references specific research document sections
* **Explicit dependency tracking**: Can't implement Step 5 without completing Steps 1-4 first
* **Verification criteria**: Each step includes concrete "done when" conditions
* **File-level specificity**: Plan references actual file paths and approximate line numbers
* **No invented details**: Task Planner only elaborates what research already discovered

Compare these planning approaches:

❌ **Ungrounded (prone to hallucination):**

```markdown
- Add 2FA verification to login
```

This step invites hallucination. Where in the code? What verification method? What happens on failure? The AI implementing this will guess, potentially inventing nonexistent patterns or incompatible approaches.

✅ **Grounded (hallucination-resistant):**

```markdown
- [ ] Step 3.1: Modify login endpoint for 2FA check
  - Location: `src/auth/authRoutes.ts`, login function (lines 120-145)
  - After password verification (line 135), check user.twoFactorEnabled
  - If true, require totpToken in request body
  - Verify token using speakeasy.totp.verify() (API documented in Research Section 3.2)
  - Return 401 with message "Invalid authentication code" if verification fails
  - Verification: Test with valid token (succeeds), without token (fails with 401), with invalid token (fails with 401)
  - Research reference: Authentication flow described in Research Doc Section 4.1
```

This step eliminates guesswork:

* Exact file and line numbers guide the implementer
* Verification method specified (speakeasy.totp.verify)
* Error handling defined explicitly
* Success/failure cases documented
* Research findings referenced for context

> [!TIP]
> When you review implementation plans, check that every step references either existing code locations or research findings. Steps without grounding are hallucination risks.

## When to Use Task Planner

Escalate from manual planning to Task Planner when:

**Complexity indicators:**

* Feature typically touches 5+ files across multiple subsystems
* Implementation order matters (database → API → UI)
* Multiple developers need to coordinate work
* Feature has security or data integrity implications

**Team collaboration needs:**

* Plan serves as specification for code review
* Multiple people implement different phases
* Handoff between specialists (backend dev → frontend dev)
* Need to track progress with checkboxes

**Quality requirements:**

* Changes are high-risk (authentication, payment processing, data migration)
* Verification testing required before production
* Rollback strategy needed
* Compliance or audit requirements exist

**Chapter 7 teaches you when manual planning suffices and when Task Planner's systematic structure becomes necessary.**

---

**Previous:** [Chapter 7 Overview](./README.md)  
**Next:** [Section 2: Task Planner Capabilities](./02-task-planner-capabilities.md)  
**Up:** [Chapter 7: Task Planner](./README.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
