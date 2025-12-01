---
title: "Integrating ADRs into RPI Workflow"
description: Learn how ADRs fit naturally into each RPI phase from research through implementation and review
author: HVE Core Team
ms.date: 2025-11-26
chapter: 10
part: "II"
keywords:
  - rpi-integration
  - adr-workflow
  - research-phase
  - planning-phase
---

## Integrating ADRs into RPI Workflow

### ADR Placement in RPI Phases

Architecture Decision Records fit naturally into the Research → Plan → Implement cycle. Each phase has specific ADR touchpoints.

### Phase mapping

| RPI Phase | ADR Activity                    | Chat Mode                     |
|-----------|---------------------------------|-------------------------------|
| Research  | Explore alternatives            | Ask Mode                      |
| Plan      | Document decision, create plan  | Ask Mode (ADR prompts), Plan  |
| Implement | Reference ADR, update as needed | Edit Mode, Agent Mode         |
| Review    | Verify alignment with ADR       | Code review                   |

This integration ensures decisions are documented when context is fresh.

## Research Phase: ADR Seeds

During research, you're gathering the raw material for ADRs.

### What to capture

* Alternatives explored
* Trade-offs discussed
* Performance benchmarks
* Cost comparisons
* Team concerns and questions

**Research conversation example:**

```text
Ask Mode: "Compare PostgreSQL, MongoDB, MySQL for e-commerce catalog"

Requirements:
- Complex product relationships (categories, variants, bundles)
- Full-text search on product descriptions
- 100K+ products
- Team has strong SQL experience
```

You engage in detailed exploration of each option, discussing schema flexibility, query performance, search capabilities, and operational requirements.

**Immediate ADR creation after research:**

```text
Create an ADR in MADR format for database selection.

Use context from our research above.
Decision: PostgreSQL
Key factors: relational data model, full-text search, team experience
Include all three databases as alternatives.
Format with Status, Context, Decision, Alternatives Considered, and Consequences.
```

**Result:** Decision documented while reasoning is fresh and complete.

## Planning Phase: ADR References

Implementation plans should explicitly reference relevant ADRs. This creates traceability from code to decision rationale.

**Task Planner with ADR context:**

```markdown
## Task: Implement Session Storage

### Context
See ADR-004: Use Redis for Session Storage

This task implements the architecture decision documented in ADR-004.
Configuration requirements and constraints are specified there.

### Implementation Steps

Step 1: Set up ElastiCache Redis cluster
- Multi-AZ deployment (per ADR-004)
- Encryption in transit enabled (per ADR-004)
- Follow security checklist linked in ADR-004

Step 2: Install connect-redis middleware
- Use version 7.x specified in ADR-004
- Configure TTL to 24 hours (per ADR-004)

Step 3: Configure connection pooling
- Pool size based on ADR-004 capacity planning
- Implement retry logic per ADR-004 recommendations
```

**Benefits:**

* Plan aligns with documented decision
* Implementation details trace to rationale
* Future maintainers understand "why"
* Reduces ad-hoc decisions during implementation

## Implementation Phase: ADR Updates

During implementation, you often discover new information that should update the ADR.

**Common discoveries:**

* Original decision needs modification
* New consequences emerge
* Performance differs from expectations
* Additional configuration required

**Update approaches:**

### Option 1: Amend Existing ADR

When discovery doesn't change the core decision:

```markdown
# ADR-004: Use Redis for Session Storage

## Status
Accepted

## Decision
[Original decision content]

## Implementation Notes (Added 2024-01-20)

During implementation, discovered Redis pub/sub has limitations for our
cross-instance event use case. Added secondary EventBridge integration
for broadcast notifications.

Performance note: Achieved sub-millisecond latency as expected, but
connection pool required tuning for our traffic patterns. Increased
pool size from 10 to 25 connections based on load testing.

See ADR-009 for event bus decision details.
```

### Option 2: Create Superseding ADR

When implementation reveals need for different approach:

```markdown
# ADR-009: Use EventBridge for Cross-Instance Events

## Status
Accepted

## Context
ADR-004 specified Redis for session storage. During implementation,
discovered need for cross-instance event notifications beyond sessions:
- User presence updates
- Real-time notifications
- Cache invalidation signals

Redis pub/sub evaluated but has limitations:
- No message persistence (subscribers must be online)
- No message filtering capabilities
- Tightly couples services through shared Redis

## Decision
Use AWS EventBridge for cross-instance event distribution, keeping
Redis exclusively for session storage as per ADR-004.

[Rest of ADR...]

## Related ADRs
- Related to: ADR-004 (Redis session storage)
- Complements: Original Redis decision for its intended purpose
```

## ADR Review in Code Reviews

Code reviews should verify implementation alignment with ADRs.

**Review checklist additions:**

```markdown
## Code Review Checklist

### Architecture Alignment
- [ ] Implementation follows relevant ADRs
- [ ] Deviations from ADRs are documented and justified
- [ ] New architecture decisions are documented as ADRs

### ADR References
- [ ] PR description links to relevant ADRs
- [ ] Code comments reference ADR numbers where appropriate
- [ ] Test strategy aligns with ADR consequences
```

**Example review comment:**

```markdown
This implements database connection pooling differently than specified 
in ADR-007 (using 50 connections instead of documented 20).

Is this intentional? If so, please either:
1. Update ADR-007 with new approach and rationale for change, or
2. Create ADR-012 documenting this pool size variation with benchmarks

This ensures future developers understand the decision.
```

**Reviewer responsibility:**

* Catch undocumented architecture decisions
* Ensure ADRs stay synchronized with implementation
* Prevent architectural drift

## Living Documentation Practices

ADRs are living documents that evolve with your system.

**DO maintain ADR currency:**

* ✅ Update status as decisions evolve: Proposed → Accepted → Deprecated
* ✅ Add implementation notes discovered during coding
* ✅ Create superseding ADRs for major changes
* ✅ Link related ADRs as they're created
* ✅ Update consequences based on production experience

**DON'T destroy historical record:**

* ❌ Delete old ADRs (they show evolution)
* ❌ Heavily edit ADRs after acceptance (add notes instead)
* ❌ Leave ADRs in "Proposed" status indefinitely
* ❌ Create ADR for every minor implementation detail

**ADR lifecycle:**

```text
Proposed (during decision-making)
  ↓
Accepted (decision finalized, implementation begins)
  ↓
[6-12 months pass, system evolves]
  ↓
Deprecated (better approach identified)
  ↓
Superseded by ADR-XXX (new ADR documents evolution)
```

**Status evolution example:**

```markdown
## Status
Superseded by ADR-018 (2024-06-20)

**Historical note:**
Originally accepted 2024-01-15. Redis single-instance session storage
worked well for 6 months. As user base grew from 10K to 50K concurrent
users, geographic expansion required multi-region setup.

ADR-018 documents migration to Redis Cluster with active-active
replication across three regions.
```

## Integration Checklist

For each RPI cycle involving architecture decisions, follow this pattern:

**Research Phase:**

* [ ] Explore alternatives thoroughly in Ask Mode
* [ ] Document key findings and trade-offs
* [ ] Identify decision point (when research is sufficient)

**Decision Point:**

* [ ] Choose approach with clear rationale
* [ ] **Create ADR immediately** using AI-assisted ADR prompts
* [ ] Reference research conversation in ADR context

**Planning Phase:**

* [ ] Review ADR for completeness and accuracy
* [ ] Commit ADR to repository before implementation
* [ ] Reference ADR explicitly in implementation plan
* [ ] Include ADR number in task descriptions

**Implementation Phase:**

* [ ] Follow documented approach from ADR
* [ ] Note deviations and new discoveries
* [ ] Update ADR with implementation notes
* [ ] Create superseding ADRs if approach changes

**Review Phase:**

* [ ] Verify code aligns with ADR specifications
* [ ] Check for undocumented architecture decisions
* [ ] Update ADR status (Accepted, Deprecated, etc.)

**Maintenance:**

* [ ] Quarterly review: Accept or reject "Proposed" ADRs
* [ ] Annual review: Update consequences based on experience
* [ ] Mark deprecated ADRs when superseded

This checklist ensures ADRs stay synchronized with your evolving system.

## Common Integration Anti-Patterns

### Anti-Pattern 1: Post-Implementation ADRs

❌ Writing ADRs after code is complete  
✅ Create ADRs before or during planning phase

**Why it matters:** Post-implementation ADRs rationalize decisions retroactively. You've forgotten alternatives, simplified context, and cherry-picked consequences.

### Anti-Pattern 2: ADR Theater

❌ Creating ADRs for compliance, ignoring during implementation  
✅ Reference ADRs actively in code reviews and plans

**Why it matters:** ADRs only provide value when they guide implementation and inform maintenance.

### Anti-Pattern 3: Frozen ADRs

❌ Treating ADRs as immutable once accepted  
✅ Update ADRs with implementation notes and evolving understanding

**Why it matters:** Systems evolve. ADRs should capture that evolution while preserving historical decisions.

### Anti-Pattern 4: Everything is an ADR

❌ Documenting every technical choice as ADR  
✅ Reserve ADRs for architecture decisions (see Chapter 1 distinction)

**Why it matters:** Too many ADRs creates documentation burden. Focus on decisions with lasting impact.

---

**Previous:** [Writing ADRs with AI Assistance](03-writing-adrs-with-ai-assistance.md) | **Next:** [Advanced ADR Patterns](05-advanced-adr-patterns.md) | **Up:** [Part II: Core Modes and Workflows](../README.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
