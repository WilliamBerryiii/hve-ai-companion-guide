---
title: "Agent+Ask Pattern - Strategic Intervention"
description: "Master the Agent+Ask pattern to maintain control while leveraging autonomous execution through strategic checkpoints"
author: "HVE Core Team"
ms.date: 2025-11-19
section: 3
chapter: 9
part: 2
keywords:
  - agent-ask-pattern
  - strategic-intervention
  - supervision-checkpoints
  - controlled-autonomy
estimated_reading_time: 15
---

## Maintaining Control with Automation

> [!IMPORTANT]
> The Agent+Ask pattern is a supervision methodology we developed for this guide. It's not a built-in Copilot feature but a structured approach to designing prompts that request Agent to pause at critical decision points. The "ASK checkpoint" prompts you'll see in this chapter are suggested instructions you include in your prompts to Agent Mode—not special syntax or features.

Agent Mode gives you speed through autonomous execution. But speed without control creates risk. The Agent+Ask pattern solves this by combining automation with strategic checkpoints.

### The Challenge

Agent Mode executes multiple steps without waiting for approval. This is powerful but can lead to problems:

* Agent might make architectural decisions without your input
* Security-sensitive code might be implemented without review
* Breaking changes might be introduced without confirmation
* Ambiguous requirements might be interpreted incorrectly

You need a way to maintain control without losing the speed advantage.

### The Solution: Agent+Ask Pattern

The Agent+Ask pattern lets Agent execute autonomously between checkpoints while pausing at critical decision points.

**Pattern structure:**

1. **Initial handoff**: You provide the plan with Ask checkpoints specified
2. **Autonomous execution**: Agent implements steps between checkpoints
3. **Ask checkpoint**: Agent pauses, presents options, waits for your decision
4. **Continued execution**: Agent proceeds based on your guidance
5. **Final review**: You review the complete implementation

This pattern gives you control where it matters while letting Agent handle routine implementation autonomously.

> [!NOTE]
> The Agent+Ask pattern is the primary supervision technique for complex implementations. You'll use it on most multi-step features.

## Defining Ask Checkpoints

Ask checkpoints are explicit pause points where Agent requests guidance. Place them strategically at decision points that require your judgment.

### Security-Sensitive Logic

Security implementations need review before proceeding. Encryption, authentication, and authorization logic are too important to delegate completely.

**Example with Ask checkpoint:**

```markdown
Step 2.3: Implement token encryption
- Implementation: Use AES-256-GCM encryption for secrets
- **ASK: Confirm encryption approach before implementing**
- Verification: Encrypted secrets stored in database
```

When Agent reaches this step, it analyzes encryption options, presents recommendations, and waits for your confirmation before implementing.

### Architecture Decisions

When multiple valid approaches exist with different tradeoffs, Ask checkpoints let you make the architectural decision.

**Example with Ask checkpoint:**

```markdown
Step 3.1: Design rate limiting strategy
- Options: In-memory, Redis, database
- **ASK: Which backend to use for rate limiting?**
- Implementation: Implement selected approach
```

Agent analyzes options, explains tradeoffs, and implements your chosen approach.

### Breaking Changes

Changes that affect existing APIs or contracts need confirmation. Ask checkpoints protect against unintended compatibility breaks.

**Example with Ask checkpoint:**

```markdown
Step 4.2: Refactor authentication flow
- Changes: Modify login endpoint signature
- **ASK: Confirm backward compatibility not required**
- Implementation: Update endpoint and tests
```

This forces explicit acknowledgment of the breaking change before proceeding.

### Ambiguous Requirements

When requirements don't specify behavior completely, Ask checkpoints surface the ambiguity for resolution.

**Example with Ask checkpoint:**

```markdown
Step 2.5: Add error handling
- Scenario: External API call fails
- **ASK: Should we retry, fail immediately, or queue for later?**
- Implementation: Implement selected strategy
```

Agent identifies the decision point, presents options, and waits for guidance.

## Agent+Ask Workflow Example

Let's walk through a complete Agent+Ask workflow implementing a 2FA setup endpoint.

### Initial Prompt with Ask Checkpoints

```markdown
Implement Step 2.2 from plan: Create /api/auth/2fa/setup endpoint.

Before implementing encryption logic (encryptSecret), ASK:
- Which encryption algorithm: AES-256-GCM, AES-256-CBC, or other?
- Should we use environment variable for key or key management service?

Before modifying authRoutes.ts, ASK:
- Confirm middleware ordering (should 2FA setup be before or after rate limiting?)

Proceed with implementation after each Ask response.
```

This prompt establishes two Ask checkpoints: one for encryption decisions, one for middleware ordering.

### Autonomous Execution Phase

Agent begins executing autonomously:

```markdown
Agent: Creating test file for /api/auth/2fa/setup endpoint...
- Generated src/auth/__tests__/2fa-setup.test.ts
- 5 test cases covering success, auth, and error scenarios
- Tests: 5 failed (expected - red phase)

Agent: Generating endpoint structure in authRoutes.ts...
- Added POST /api/auth/2fa/setup route
- Integrated authentication middleware
- Stubbed out encryptSecret() call (pending encryption decision)
```

Agent writes tests, creates the endpoint structure, and prepares for the encryption implementation. Then it reaches the first Ask checkpoint.

### First Ask Checkpoint: Encryption

Agent pauses and presents options. The format below illustrates how Agent might respond when you've requested a pause for decisions:

```markdown
Agent: ❓ ASK CHECKPOINT - Encryption Implementation

I need to implement encryptSecret() to store TOTP secrets securely.

Options analyzed:

1. **AES-256-GCM** (recommended)
   - Authenticated encryption (integrity + confidentiality)
   - Standard for secret storage
   - Requires 256-bit key from environment variable
   
2. **AES-256-CBC with HMAC**
   - Separate encryption + authentication
   - More complex implementation
   - Slightly slower

3. **Use AWS KMS** (if cloud-hosted)
   - Managed key rotation
   - Audit logging
   - External dependency + latency

Key storage options:

> [!CAUTION]
> Environment variable key storage (Option A) is suitable for development and testing but should not be used in production environments. Production systems should use managed key services (Options B or C) with proper access controls, audit logging, and key rotation policies.

A. Environment variable ENCRYPTION_KEY (32-byte hex string)
B. AWS Secrets Manager integration
C. Azure Key Vault integration

**What's your decision?**
- Encryption algorithm: [1/2/3]
- Key storage: [A/B/C]
```

Agent provides context, analyzes options, makes recommendations, and waits for your decision.

### Your Response

```markdown
Use Option 1 (AES-256-GCM) with Option A (environment variable).
Generate random encryption key and document in .env.example.
```

Clear, concise decision. Agent has what it needs to proceed.

### Continued Autonomous Execution

Agent implements your decision:

```markdown
Agent: ✓ Confirmed: AES-256-GCM with environment variable.

Implementing encryptSecret() and decryptSecret()...
- Added crypto functions to TwoFactorService
- Generated example .env.example with ENCRYPTION_KEY
- Updated tests to mock encryption
- Tests: 8 passed ✓

Proceeding to next Ask checkpoint...
```

Agent continues working autonomously until the next checkpoint.

### Second Ask Checkpoint: Middleware Ordering

Agent reaches the second checkpoint:

```markdown
Agent: ❓ ASK CHECKPOINT - Middleware Ordering

Current authRoutes.ts middleware chain:
1. express.json() (body parsing)
2. rateLimiter (100 req/15min)
3. authMiddleware (JWT verification)
4. Route handlers

Where should 2FA setup endpoint fit?
- After authMiddleware (requires authenticated user) ✓
- Before rateLimiter (bypass rate limits for 2FA setup)
- After rateLimiter (subject to rate limits) ✓ [RECOMMENDED]

**Recommendation**: Place after both rateLimiter and authMiddleware.
This protects the endpoint from abuse while requiring authentication.

**Confirm or specify different ordering?**
```

Agent presents the decision clearly with a recommendation.

### Final Execution and Completion

You confirm:

```markdown
Confirmed - place after both rateLimiter and authMiddleware.
```

Agent completes the implementation:

```markdown
Agent: ✓ Confirmed: After rateLimiter and authMiddleware.

Completing /api/auth/2fa/setup endpoint implementation...
- Positioned route correctly in middleware chain
- Integrated TwoFactorService.generateSecret()
- Added error handling for service failures
- Tests: 5 passed ✓

Step 2.2 complete. All tests passing.

Summary:
- Created: src/services/TwoFactorService.ts (encryption logic)
- Modified: src/auth/authRoutes.ts (added POST /api/auth/2fa/setup)
- Created: src/auth/__tests__/2fa-setup.test.ts
- Created: .env.example (encryption key template)
- Tests: 13/13 passed ✓

Ready for review.
```

The implementation is complete. Agent handled routine work autonomously while consulting you on critical decisions.

## Ask Checkpoint Best Practices

Not every decision requires an Ask checkpoint. Too many checkpoints eliminate the automation benefit. Too few increase risk.

### When to Use Ask Checkpoints

Use this decision framework:

| Scenario                    | Ask?  | Rationale                             |
|-----------------------------|-------|---------------------------------------|
| Security implementation     | ✅ Yes | Risk too high for wrong decision      |
| Standard CRUD endpoint      | ❌ No  | Follow established patterns           |
| Encryption algorithm choice | ✅ Yes | Multiple valid options with tradeoffs |
| Variable naming             | ❌ No  | Agent follows conventions             |
| Database schema change      | ✅ Yes | Migration complexity                  |
| Adding utility function     | ❌ No  | Low risk, easily reversed             |
| Authentication flow change  | ✅ Yes | Breaking change potential             |
| Code formatting             | ❌ No  | Automated by linters                  |

**Too many Ask checkpoints** create decision fatigue and slow execution. If you're asking about every implementation detail, use Edit Mode instead.

**Too few Ask checkpoints** increase risk. Agent might make architectural decisions without your input.

**Sweet spot**: In our experience, 0-3 Ask checkpoints per 5-10 step implementation works well. Adjust based on task complexity and your comfort level with Agent's decision-making.

> [!TIP]
> Start with more Ask checkpoints when learning Agent Mode. As you build confidence in Agent's judgment, reduce checkpoint frequency for routine implementations.

### Checkpoint Granularity

Ask checkpoints should address meaningful decisions, not trivial choices.

**Good checkpoint granularity:**

* "Which caching strategy: Redis or in-memory?"
* "Should we implement retry logic for this API call?"
* "Confirm removing deprecated endpoint (breaking change)"

**Poor checkpoint granularity:**

* "Should this variable be named `userId` or `userIdentifier`?"
* "Should this method be public or private?"
* "Should we add a comment explaining this regex?"

Agent makes good decisions on trivial matters. Trust it to follow conventions and best practices. Reserve checkpoints for decisions with architectural or security implications.

## Configuring Ask Behavior

You control Ask checkpoint behavior through explicit instructions in your prompt.

### Explicit Ask Instructions

Tell Agent exactly when to pause:

```markdown
ASK before:
1. Choosing encryption algorithms
2. Modifying authentication middleware
3. Making breaking changes to public APIs

DO NOT ASK about:
- Variable naming
- Code organization
- Test structure
- Error message wording

Proceed autonomously for everything else.
```

This gives Agent clear boundaries. It knows when to pause and when to proceed with confidence.

### Conditional Ask Instructions

Define conditions that trigger Ask checkpoints:

```markdown
ASK if:
- Test coverage drops below 80%
- Any test fails unexpectedly
- Type errors cannot be resolved
- External dependency needs to be added

Otherwise proceed without asking.
```

Agent monitors these conditions during execution and pauses if any are met.

### Risk-Based Ask Strategy

Use risk levels to determine Ask checkpoint frequency:

```markdown
Risk levels:
- LOW: Utility functions, tests, docs → No Ask
- MEDIUM: Business logic, endpoints → Ask if ambiguous
- HIGH: Auth, encryption, payments → Always Ask

Default: Ask for HIGH risk, proceed for LOW/MEDIUM risk.
```

This strategy scales Ask checkpoint density with implementation risk.

> [!IMPORTANT]
> Always specify Ask behavior explicitly. Don't rely on Agent's default judgment for critical implementations. Make your supervision expectations clear upfront.

---

## Hands-On Exercise 9.2: Designing Ask Checkpoints

**Goal:** Practice identifying where to place Ask checkpoints in a multi-step implementation.

**Scenario:** You're implementing a user registration flow with email verification and password hashing. Review the plan below and identify optimal Ask checkpoint placement.

**Steps:**

1. **Review this implementation plan:**

   ```markdown
   Step 1: Create User model with email, passwordHash, emailVerified fields
   Step 2: Create UserService with register() method
   Step 3: Implement password hashing logic
   Step 4: Create email verification token generation
   Step 5: Create /auth/register endpoint
   Step 6: Create /auth/verify-email endpoint
   Step 7: Add rate limiting to registration
   ```

2. **Identify Ask checkpoint candidates** by evaluating each step:
   * Which steps involve security-sensitive decisions?
   * Which steps have multiple valid approaches?
   * Which steps are routine and low-risk?

3. **Write your Ask checkpoint specification:**

   ```markdown
   ASK before:
   1. [Your answer]
   2. [Your answer]
   
   DO NOT ASK about:
   - [Your answer]
   ```

4. **Compare with the decision framework** from this section

**Expected Result:**

Your Ask checkpoints should include:

* Password hashing algorithm choice (Step 3)—security-sensitive with multiple valid options
* Email token format and expiration (Step 4)—security decision with tradeoffs

Your "DO NOT ASK" list should include:

* Model field names (Step 1)—conventions exist
* Endpoint URL structure (Steps 5-6)—follows REST patterns

> [!TIP]
> When unsure whether a step needs an Ask checkpoint, ask yourself: "If Agent chooses wrong here, what's the recovery cost?" High-cost decisions warrant checkpoints.

**What You Learned:**

* How to evaluate steps for Ask checkpoint placement
* The balance between automation speed and control
* Criteria for distinguishing high-risk from routine decisions

---

**Previous:** [Agent Mode Fundamentals](./02-agent-mode-fundamentals.md) | **Next:** [Complete Agent Workflow](./04-complete-agent-workflow.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
