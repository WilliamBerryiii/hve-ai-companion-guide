---
title: "Plan Document Structure and Template"
description: Master the standardized implementation plan template with phases, verification criteria, and rollback strategies
author: HVE Core Team
ms.date: 2025-11-26
chapter: 7
part: "II"
keywords:
  - plan-template
  - document-structure
  - verification-criteria
  - implementation-phases
---

## Plan Document Structure and Template

Task Planner uses a standardized template to ensure plan completeness and consistency. This structure provides implementers with all the information they need: what to build, where to build it, how to verify it works, and what to do if it fails.

This section explains each template component and shows you how to recognize complete, well-structured plans.

## The Implementation Plan Template

Every Task Planner document follows this structure:

```markdown
<!-- markdownlint-disable-file -->
# Implementation Plan: [Feature Name]

**Created**: YYYY-MM-DD  
**Research Document**: [link to research .md file]  
**Complexity**: Low | Medium | High  
**Estimated Implementation Time**: X-Y hours

## Feature Overview

[2-3 sentence summary of what's being built and why]

**Success Criteria:**
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Prerequisites

**Before starting implementation, verify:**
- [ ] Prerequisite 1 (why it's needed)
- [ ] Prerequisite 2 (why it's needed)

**Dependencies on other work:**
- Dependency 1: [description]
- Dependency 2: [description]

## Implementation Phases

### Phase 1: [Phase Name] (no dependencies)

**Goal**: [What this phase accomplishes]  
**Estimated Time**: X-Y hours

#### Step 1.1: [Specific task]
- **Location**: `path/to/file.ts`, approximate line range
- **Research reference**: See [Research Doc Section X]
- **Implementation details**:
  - Specific action 1
  - Specific action 2
  - Code pattern to follow
- **Verification**: How to confirm this step is complete
- **Files modified**:
  - `file1.ts` (what changes)
  - `file2.ts` (what changes)

#### Step 1.2: [Next task]
[Same structure as Step 1.1]

### Phase 2: [Phase Name] (depends on: Phase 1)

**Goal**: [What this phase accomplishes]  
**Estimated Time**: X-Y hours

[Steps structured like Phase 1]

### Phase 3: [Phase Name] (depends on: Phase 1, Phase 2)

[Continue pattern]

## Testing Strategy

### Unit Tests
- [ ] Test scenario 1: [what to test, expected outcome]
- [ ] Test scenario 2: [what to test, expected outcome]

### Integration Tests
- [ ] Integration scenario 1: [what to test]
- [ ] Integration scenario 2: [what to test]

### Manual Verification
- [ ] Manual test 1: [steps to perform, expected result]
- [ ] Manual test 2: [steps to perform, expected result]

## Risk Analysis

### High-Complexity Steps
- **Step X.Y**: [Why this is risky, mitigation strategy]
- **Step X.Z**: [Why this is risky, mitigation strategy]

### Potential Breaking Changes
- Change 1: [what might break, how to verify]
- Change 2: [what might break, how to verify]

## Rollback Plan

**If implementation fails at Phase X:**
1. Action 1 to undo changes
2. Action 2 to restore state
3. How to verify rollback successful

## Implementation Checklist

- [ ] All prerequisites completed
- [ ] Phase 1 complete and verified
- [ ] Phase 2 complete and verified
- [ ] Phase 3 complete and verified
- [ ] All tests passing
- [ ] Manual verification successful
- [ ] Documentation updated
- [ ] Code reviewed (if team process)
- [ ] Deployed to staging/production

## Notes for Implementer

[Any additional context, gotchas, or considerations]
```

This template ensures plans contain every detail an implementer needs without overwhelming them with unnecessary information.

## Key Template Sections Explained

### Feature Overview and Success Criteria

The feature overview provides context. Success criteria define "done" with testable conditions rather than vague statements.

❌ **Vague success criteria:**
```markdown
- Feature works correctly
- Users can use 2FA
- System is secure
```

These criteria are not testable. How do you verify "works correctly"? What does "can use 2FA" mean specifically?

✅ **Testable success criteria:**
```markdown
- Existing users can enable 2FA from account settings page (Settings > Security > Enable 2FA button)
- New users see optional 2FA setup during registration (step 3 of 4 in registration flow)
- Login requires TOTP token when 2FA enabled (401 error without valid token)
- Backup codes can be used when TOTP unavailable (tested: 1 use per code, code becomes invalid after use)
- Admin panel shows 2FA status for all users (new column in user table: "2FA Status")
```

Each criterion specifies what to test and what outcome to expect. You can verify each one independently.

### Prerequisites Section

Prerequisites list what must be true before implementation begins. This prevents starting work only to discover missing dependencies halfway through.

**Example Prerequisites:**
```markdown
## Prerequisites

**Before starting implementation, verify:**
- [ ] Database supports encrypted text fields (PostgreSQL 12+ required for native encryption)
- [ ] Redis session store configured (required for 2FA verification state during login)
- [ ] QR code library budget approved (adds 8kb to bundle, requires tech lead approval)
- [ ] Development environment has test TOTP app installed (Google Authenticator or Authy for manual testing)

**Dependencies on other work:**
- User model refactor (PR #234) must be merged first (adds required field accessors)
- Auth middleware updates (ticket #567) provide required pre-login hooks
- Database migration tooling upgrade (ticket #612) supports encrypted columns
```

Checking prerequisites before starting saves hours of blocked implementation time.

### Implementation Phases and Steps

This is the plan's core. Each phase groups related steps that can be implemented together.

**Phase organization principles:**
* **By dependency**: Phase 1 has no dependencies, Phase 2 depends on Phase 1, etc.
* **By subsystem**: Database layer → API layer → UI layer
* **By complexity**: Simple steps first → Complex steps later (build confidence early)

**Step format anatomy:**

```markdown
#### Step 2.3: Add TOTP verification to login endpoint
│
├─ **Location**: `src/auth/loginController.ts`, lines 78-120
│  └─ Tells implementer exactly where to work
│
├─ **Research reference**: See Research Doc Section 4.2 (Passport.js integration pattern)
│  └─ Links decision back to evidence from research phase
│
├─ **Implementation details**:
│  - After password verification (line 95), check `user.twoFactorEnabled`
│  - If true, require `req.body.totpToken` field (validate presence in request)
│  - Use `speakeasy.totp.verify({ secret: user.twoFactorSecret, token: req.body.totpToken, window: 1 })`
│  - If verification fails, return 401 with error: "Invalid authentication code"
│  - If verification succeeds, continue to session creation (line 105)
│  └─ Specific code patterns to follow (not vague instructions)
│
├─ **Verification**: Create test user with 2FA enabled, attempt login without token (should fail with 401), with valid token (should succeed and create session), with expired token (should fail)
│  └─ How to know this step is complete
│
└─ **Files modified**:
   - `src/auth/loginController.ts` (add 2FA verification logic after password check)
   - `src/auth/validators/loginValidator.ts` (add optional totpToken field with format validation)
   └─ Complete list of files this step touches
```

This structure eliminates ambiguity. The implementer knows:
* Exact file and line range to modify
* Why this approach was chosen (research reference)
* Specific code to write (implementation details)
* How to verify success (verification criteria)
* What files will change (modified files list)

### Testing Strategy

Defines how to verify each step and the complete feature. Three testing levels:

**Unit tests** verify individual function/method behavior:
```markdown
### Unit Tests
- [ ] `speakeasy.totp.verify()` returns true for valid token generated from secret
- [ ] `speakeasy.totp.verify()` returns false for invalid token
- [ ] `speakeasy.totp.verify()` returns false for expired token (window parameter respected)
- [ ] Login controller throws AuthError when 2FA enabled and token missing
- [ ] Login controller throws AuthError when 2FA enabled and token invalid
```

**Integration tests** verify multiple components working together:
```markdown
### Integration Tests
- [ ] Full login flow with 2FA enabled: password + valid token → session created
- [ ] Login with 2FA disabled: password only → session created (no token required)
- [ ] 2FA setup flow: generate secret → display QR → verify token → enable 2FA
- [ ] Backup code usage: valid backup code bypasses TOTP requirement, code becomes invalid after use
```

**Manual verification** covers end-to-end user scenarios:
```markdown
### Manual Verification
- [ ] Manual test 1: Enable 2FA in account settings, scan QR with Google Authenticator, verify login requires token
- [ ] Manual test 2: Use backup code when TOTP unavailable, verify code works once and becomes invalid
- [ ] Manual test 3: Disable 2FA in account settings, verify login no longer requires token
```

### Risk Analysis

Risk analysis calls out steps that are:
* **High complexity**: Might need expert review or pairing
* **Potential breaking changes**: Need extra verification before deployment
* **External dependencies**: API calls, third-party services, network requirements

**Example Risk Analysis:**
```markdown
## Risk Analysis

### High-Complexity Steps
- **Step 2.3 (TOTP verification)**: Integrates with existing auth flow. Test thoroughly with all authentication paths (local, OAuth, SSO). Consider pairing with security expert for review.
- **Step 3.4 (Backup code generation)**: Cryptographic operations. Verify bcrypt rounds setting (10 rounds minimum). Ensure backup codes stored hashed, never plaintext.

### Potential Breaking Changes
- Login endpoint signature changes: Adding optional `totpToken` field. Verify existing API clients still work (field is optional).
- Session creation timing: 2FA check delays session creation. Verify timeout handling works correctly (30-second window for token entry).
```

This analysis helps you allocate time appropriately. High-complexity steps deserve extra attention and slower implementation pace.

### Rollback Plan

Defines how to undo changes if implementation fails. Critical for:
* **Database migrations**: How to roll back schema changes without data loss
* **Configuration changes**: How to restore previous values
* **Feature flags**: How to disable feature without code rollback

**Example Rollback Plan:**
```markdown
## Rollback Plan

**If implementation fails at Phase 1 (Database layer):**
1. Run rollback migration: `npm run migrate:rollback`
2. Verify columns removed: `SELECT column_name FROM information_schema.columns WHERE table_name='users'`
3. Restart application: `npm run restart`

**If implementation fails at Phase 2 (API layer):**
1. Revert API changes: `git revert <commit-hash>`
2. Redeploy previous version: `npm run deploy:staging`
3. Verify login still works without 2FA: Test with existing user accounts

**If implementation fails at Phase 3 (UI layer):**
1. Disable 2FA feature flag: Set `FEATURE_2FA_ENABLED=false` in environment
2. Redeploy application: `npm run deploy`
3. Verify UI no longer shows 2FA options
4. Backend still supports 2FA for users who already enabled it (graceful degradation)
```

Rollback plans provide safety. You can implement confidently knowing you can undo changes if needed.

## Template Usage Guidelines

**When reviewing a plan, verify:**
* ✅ Every step has file location and line range
* ✅ Every step cites research document section
* ✅ Every step includes verification criteria
* ✅ Phases organize by dependencies (Phase 2 cannot start before Phase 1)
* ✅ Success criteria are testable (not vague)
* ✅ Prerequisites list all required dependencies
* ✅ Testing strategy covers unit, integration, and manual verification
* ✅ Risk analysis identifies high-complexity steps
* ✅ Rollback plan provides undo instructions for each phase

**Red flags indicating incomplete plan:**
* ❌ Steps say "Implement feature X" without file locations
* ❌ No research references (plan not grounded in evidence)
* ❌ Vague verification criteria ("Test that it works")
* ❌ Missing prerequisites (assumed, not documented)
* ❌ No rollback plan (cannot undo if something fails)

---

**Previous:** [Section 2: Task Planner Capabilities](./02-task-planner-capabilities.md)  
**Next:** [Section 4: Creating Plans with Task Planner](./04-creating-plans-task-planner.md)  
**Up:** [Chapter 7: Task Planner](./README.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
