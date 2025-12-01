---
title: Beads Workflow Fundamentals
description: Learn the Beads workflow system for structured task tracking, agent coordination, and systematic implementation with planning and execution phases
author: HVE Core Team
ms.date: 2025-11-23
ms.topic: concept
keywords:
  - beads workflow
  - task tracking
  - agent coordination
  - planning phase
  - execution phase
  - structured implementation
estimated_reading_time: 15
---

The **Beads workflow** is a structured approach to breaking complex features into discrete implementation units with explicit dependencies and acceptance criteria. Originating from microsoft/edge-ai, this workflow brings project management discipline to AI-assisted development by creating clear boundaries between planning and execution.

This section introduces Beads fundamentals at Part II depth—enough to understand the structure and apply it to straightforward features. Part III, Chapter 14 (Custom Agents and Workflow Orchestration) provides comprehensive coverage of advanced Beads patterns, custom agent creation, workflow orchestration, and production integration.

## What is a Bead?

A **bead** is a single implementation task with complete context:

* **Unique identifier** (B001, B002, etc.) for tracking and referencing
* **Status** showing lifecycle position (Ready/In Progress/Complete/Blocked)
* **Priority** guiding work order (High/Medium/Low)
* **Dependencies** ensuring correct implementation sequence
* **Acceptance criteria** defining "done" with testable outcomes
* **Context** providing background understanding and rationale
* **Files to modify** identifying expected touchpoints
* **Research references** linking to relevant code examples and documentation

Think of beads like work items in Azure DevOps or Jira, but specifically designed for AI-assisted development. Each bead contains everything an implementation agent needs to complete the task without asking clarifying questions.

**Example bead structure:**

```markdown
## Bead: B001 - Create rate limiting middleware

**Status:** Ready
**Priority:** High
**Dependencies:** None

**Acceptance Criteria:**
- [ ] Middleware tracks requests per user via Redis
- [ ] Default limit: 100 requests per 15 minutes
- [ ] Exceeded limits return 429 Too Many Requests
- [ ] Configuration supports custom limits per endpoint

**Context:**
API currently has no rate limiting, creating denial-of-service risk.
Requirements specify Redis-backed tracking with per-user granularity.

**Files to Modify:**
* src/middleware/rate-limiter.ts - Create new middleware
* src/app.ts - Register middleware before routes
* tests/middleware/rate-limiter.test.ts - Add test coverage

**Research References:**
* Express rate limiting patterns: https://expressjs.com/en/advanced/best-practice-security.html
* Existing middleware pattern in src/middleware/logging.ts
```

This complete specification enables an implementation agent to execute without ambiguity.

## Planning vs Execution Phases

The Beads workflow separates planning from implementation through two distinct phases:

### Phase 1: Planning (Bead Creation)

**Purpose:** Analyze requirements, break work into discrete units, document context and dependencies.

**Agent characteristics:**

* **Read-only tools** (file reading, searching, code analysis)
* **No modification capabilities** preventing accidental changes during planning
* **Focus on understanding** existing codebase and requirements
* **Output:** Bead documents in `.copilot-tracking/beads/` directory

**Planning workflow:**

1. Analyze feature requirements and acceptance criteria
2. Examine existing codebase patterns and conventions
3. Identify natural implementation boundaries
4. Create bead structure with dependencies
5. Document context and research references
6. Save beads to `.copilot-tracking/beads/feature-name.md`

**Example planning output:**

```markdown
# Feature: API Rate Limiting

## Bead: B001 - Create rate limiting middleware
**Status:** Ready
**Priority:** High
**Dependencies:** None
[... complete bead specification ...]

## Bead: B002 - Apply rate limiting to public endpoints
**Status:** Blocked
**Priority:** High
**Dependencies:** B001
[... complete bead specification ...]

## Bead: B003 - Configure custom limits for authentication endpoints
**Status:** Blocked
**Priority:** Medium
**Dependencies:** B001, B002
[... complete bead specification ...]
```

Planning agents cannot implement—they can only analyze and document. This separation prevents "thinking while doing" anti-patterns where planning gets interleaved with incomplete implementation.

### Phase 2: Execution (Bead Implementation)

**Purpose:** Implement ready beads systematically, validate acceptance criteria, mark complete.

**Agent characteristics:**

* **Full tool access** (file modification, terminal commands, testing)
* **Focus on implementation** executing validated plans
* **Reads bead specifications** understanding context and acceptance criteria
* **Updates bead status** marking In Progress → Complete as work progresses

**Execution workflow:**

1. Read bead specification from `.copilot-tracking/beads/`
2. Review context, dependencies, and acceptance criteria
3. Implement changes to specified files
4. Validate against acceptance criteria checklist
5. Update bead status to Complete
6. Move to next ready bead

**Example execution sequence:**

```markdown
Agent reads B001 (Ready) → Implements rate limiter → Tests → Marks Complete
Agent reads B002 (now Ready) → Applies to public endpoints → Tests → Marks Complete
Agent reads B003 (now Ready) → Configures auth limits → Tests → Marks Complete
```

Execution agents don't plan—they implement validated beads. If ambiguity arises during execution, stop and return to planning phase rather than making assumptions.

## Agent Handoff Patterns

The transition between planning and execution phases represents a critical handoff:

**Planning agent handoff:**

```markdown
Planning complete. Created 3 beads in .copilot-tracking/beads/rate-limiting.md:
- B001: Middleware creation (Ready, no dependencies)
- B002: Public endpoints (Blocked, depends on B001)
- B003: Auth endpoints (Blocked, depends on B001, B002)

Implementation agent should begin with B001, then proceed sequentially.
All beads include complete context and acceptance criteria.
```

**Implementation agent startup:**

```markdown
Reading bead specification from .copilot-tracking/beads/rate-limiting.md
Starting with B001 (Ready, High priority)
Context understood: Redis-backed rate limiting with per-user tracking
Implementing rate-limiter.ts middleware...
```

The handoff document explicitly states:

* What was planned (number of beads, feature scope)
* Where specifications are located (`.copilot-tracking/beads/`)
* What's ready to implement (B001)
* What's blocked and why (B002, B003 dependencies)

This eliminates ambiguity about what to implement next.

## Connection to RPI Framework

Beads workflow aligns naturally with the Research-Plan-Implement (RPI) framework you learned in earlier chapters:

**Research phase** → **Planning agent with beads**

* Both focus on understanding before acting
* Research gathers information, planning creates beads
* Read-only tools prevent premature implementation

**Plan phase** → **Planning agent with dependencies**

* Both establish implementation sequence
* Plans document approach, beads document tasks with dependencies
* Architecture decisions flow into bead context

**Implement phase** → **Execution agent with beads**

* Both execute validated plans systematically
* Implementation follows plan, execution follows beads
* Full tool access enables actual work

The key enhancement: Beads make RPI phases explicit through agent handoffs and tool restrictions. Instead of loose transitions, you have concrete artifacts (bead documents) and clear boundaries (planning agents can't implement, execution agents don't plan).

## Simple Bead Example

Let's see a complete 3-bead feature showing Beads workflow in practice.

**Feature:** Add user profile avatar upload

**Planning phase output** (`.copilot-tracking/beads/avatar-upload.md`):

```markdown
# Feature: User Profile Avatar Upload

## Bead: B001 - Create file storage service
**Status:** Ready
**Priority:** High
**Dependencies:** None

**Acceptance Criteria:**
- [ ] Service stores files in S3 bucket with unique keys
- [ ] Returns public URL for uploaded file
- [ ] Validates file types (jpg, png, gif only)
- [ ] Validates file size (max 5MB)

**Context:**
Application needs profile avatar storage. Architecture decision: S3 for
scalability rather than local filesystem. Service should be reusable
for future file upload needs beyond avatars.

**Files to Modify:**
* src/services/file-storage.ts - Create new service
* src/config/aws.ts - Add S3 configuration
* tests/services/file-storage.test.ts - Add service tests

**Research References:**
* AWS SDK S3 documentation: https://docs.aws.amazon.com/sdk-for-javascript/v3/developer-guide/s3-example-creating-buckets.html
* Environment variables in src/config/database.ts show existing pattern

---

## Bead: B002 - Add avatar upload endpoint
**Status:** Blocked
**Priority:** High
**Dependencies:** B001

**Acceptance Criteria:**
- [ ] POST /api/users/:id/avatar endpoint accepts multipart upload
- [ ] Validates file type and size before storage
- [ ] Stores file using file storage service
- [ ] Updates user record with avatar URL
- [ ] Returns updated user profile

**Context:**
Endpoint should follow existing REST conventions in src/routes/users.ts.
Authentication middleware should verify requesting user matches :id parameter
(users can only update their own avatar).

**Files to Modify:**
* src/routes/users.ts - Add avatar upload route
* src/controllers/user-controller.ts - Add avatar upload handler
* tests/routes/users.test.ts - Add endpoint tests

**Research References:**
* Existing file upload pattern in src/routes/documents.ts
* Multer middleware configuration in src/middleware/upload.ts

---

## Bead: B003 - Display avatar in user profile UI
**Status:** Blocked
**Priority:** Medium
**Dependencies:** B002

**Acceptance Criteria:**
- [ ] Profile component displays avatar image
- [ ] Shows default avatar icon if no avatar uploaded
- [ ] Provides upload button for authenticated user's own profile
- [ ] Shows loading state during upload
- [ ] Updates display immediately after successful upload

**Context:**
Frontend uses React with TypeScript. Avatar display should match design
system in existing components. Upload should be optimistic (show immediately)
with rollback on failure.

**Files to Modify:**
* src/components/UserProfile.tsx - Add avatar display
* src/components/AvatarUpload.tsx - Create new upload component
* src/api/users.ts - Add avatar upload API call
* tests/components/UserProfile.test.tsx - Add avatar tests

**Research References:**
* Existing image display pattern in src/components/ProductCard.tsx
* File upload pattern in src/components/DocumentUpload.tsx
```

**Execution phase sequence:**

1. Implementation agent reads `avatar-upload.md`
2. Identifies B001 as Ready (no dependencies)
3. Implements file storage service with S3 integration
4. Validates acceptance criteria (file types, size limits, URL return)
5. Marks B001 Complete
6. B002 becomes Ready (dependency met)
7. Implements avatar upload endpoint
8. Validates acceptance criteria (auth check, storage integration, user update)
9. Marks B002 Complete
10. B003 becomes Ready (dependency met)
11. Implements UI components
12. Validates acceptance criteria (display, upload, loading states)
13. Marks B003 Complete
14. Feature complete

Each bead is self-contained. The implementation agent doesn't need to ask questions because all context, dependencies, and acceptance criteria are documented.

> [!TIP]
> **Start with simple 3-bead features** when learning Beads workflow. Complex features with 10+ beads introduce dependency management challenges better addressed after mastering basics. Part III, Chapter 14 covers advanced Beads patterns for large-scale features including parallel execution and complex dependency graphs.

## When to Use Beads Workflow

Beads workflow adds structure and clarity but requires upfront planning investment. Use Beads when:

**✅ Good fit:**

* **Complex features** with multiple implementation steps
* **Team coordination** where multiple developers need clear boundaries
* **Unclear requirements** benefiting from explicit planning phase
* **Quality-critical work** requiring validation at each step
* **Learning scenarios** where systematic approach aids understanding

**❌ Poor fit:**

* **Simple bug fixes** with single-file changes
* **Exploratory coding** where requirements are evolving rapidly
* **Urgent hotfixes** needing immediate implementation
* **Well-understood changes** where planning overhead exceeds value

The decision framework: If you can't articulate clear acceptance criteria before starting, use Beads to force planning. If acceptance criteria are obvious and implementation is straightforward, skip Beads and use standard Edit Mode workflow.

## Best Practices

**Planning phase practices:**

1. **Create complete specifications** - Include all context fields, not just acceptance criteria
2. **Make dependencies explicit** - Don't assume obvious relationships
3. **Write testable acceptance criteria** - "Works correctly" is not testable, "Returns 200 with valid JSON" is testable
4. **Reference existing code** - Link to similar implementations as examples
5. **Document architectural decisions** - Explain why not just what

**Execution phase practices:**

1. **Follow bead order** - Respect dependencies, implement Ready beads first
2. **Validate before marking complete** - Check all acceptance criteria
3. **Stop on ambiguity** - Return to planning rather than guessing
4. **Update status systematically** - Mark In Progress when starting, Complete when done
5. **Document deviations** - If implementation differs from plan, note why

**Handoff practices:**

1. **Explicit handoff documents** - Don't assume implementation agent knows where beads are located
2. **Clear status transitions** - Mark beads Ready only when dependencies complete
3. **Preserve context** - Implementation agent reads full bead specification, not just acceptance criteria

## Connection to Part III

This section introduced Beads workflow fundamentals—bead structure, planning vs execution phases, and simple 3-bead examples. **Part III** explores advanced patterns:

* **Chapter 12: Prompt Files Basics** - Creating instruction files with `applyTo` patterns for automatic Beads context
* **Chapter 13: Instruction Patterns** - Technology-specific instructions and layered context management
* **Chapter 14: Custom Agents** - Specialized planning and execution agents with custom tool configurations and workflow orchestration patterns
* **Chapter 15: Meta-Prompting** - Generating and refining Beads structures programmatically

> [!NOTE]
> **Part II depth:** This section provides working knowledge of Beads workflow sufficient for straightforward features. Part III provides comprehensive coverage for production usage, custom agent creation, and complex scenarios.

For now, understand bead structure, planning vs execution separation, and agent handoff patterns. You'll apply Beads workflow to TDD in [Section 6](./06-complex-workflow-tdd-with-ai.md) and practice complete implementation in [Section 9](./09-beads-tdd-exercise.md).

---

**Previous:** [Mode Switching Strategies](./03-mode-switching-strategies.md) | **Next:** [Complex Workflow: Merge Conflicts](./05-complex-workflow-merge-conflicts.md)

---

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
