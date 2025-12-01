---
title: "Advanced ADR Patterns"
description: Apply advanced patterns for ADR superseding, cross-referencing, templates, and team standards
author: HVE Core Team
ms.date: 2025-11-26
chapter: 10
part: "II"
keywords:
  - adr-patterns
  - superseding
  - cross-referencing
  - team-standards
  - adr-evolution
---

## Advanced ADR Patterns

### ADR Superseding and Evolution

Systems evolve. Original decisions become obsolete. Handle this by superseding ADRs rather than editing or deleting them.

**Wrong approach:** Edit or delete original ADR  
**Right approach:** Create superseding ADR, mark original as deprecated

This preserves historical context and shows system evolution over time.

### Example: Redis Evolution

**Original ADR-004 (preserved):**

```markdown
# ADR-004: Use Redis for Session Storage

## Status
Deprecated (2024-06-20, superseded by ADR-018)

See ADR-018 for current session storage architecture.

**Historical Context Below:**
This ADR documents our original session storage decision for 10K
concurrent users in single AWS region. After 6 months production use,
international expansion required different approach.

## Context
[Original context preserved exactly as written]

Our Node.js web application requires session storage with:
* Shared state across 3+ server instances
* High performance: sub-millisecond reads
* Budget constraint: ~$100/month

Current deployment: AWS ECS, single region (US-East).

## Decision
Use Redis (AWS ElastiCache single instance) for session storage.

[Rest of original ADR content unchanged]
```

**New ADR-018 (superseding):**

```markdown
# ADR-018: Migrate to Redis Cluster for Global Sessions

## Status
Accepted (2024-06-20)

## Context

**Evolution from ADR-004:**
ADR-004 established Redis (single ElastiCache instance) for session storage.
After 6 months in production with excellent results, business context changed:

**New requirements:**
* User base grew from 10K to 50K concurrent sessions (5x growth)
* International expansion: EU and Asia regions launched
* Compliance: Data residency requirements (GDPR, local data laws)

**Problems with single-instance approach:**
* Geographic latency: 200-300ms from Asia to US-East Redis
* No multi-region failover capability
* Regulatory risk: Sessions from EU users stored in US

**Why ADR-004 was correct initially:**
Single-region, 10K users made single-instance Redis appropriate.
Decision was sound for original context.

## Decision

Migrate to Redis Cluster with active-active replication across 3 regions:

* **US-East** (primary, existing)
* **EU-West** (replica with write capability)
* **AP-Southeast** (replica with write capability)

Configuration:
* AWS Global Datastore for Redis
* Session routing by user geographic location
* Cross-region replication <100ms
* Automatic regional failover

## Alternatives Considered

### 1. DynamoDB Global Tables

**Pros:**
* Native AWS global replication
* Serverless scaling

**Cons:**
* 3x higher latency than Redis (~30ms vs ~10ms)
* 4x higher cost at current scale
* Migration effort (change session library)

**Why not chosen:** Latency regression not acceptable for user experience.

### 2. Continue Single-Instance Redis (with CloudFront caching)

**Pros:**
* No architecture change
* Minimal work

**Cons:**
* Doesn't solve latency for dynamic session updates
* Doesn't address compliance requirements
* Performance degrades as user base grows

**Why not chosen:** Fails to meet new regulatory and performance requirements.

## Consequences

### Positive

* **Global performance:** <50ms session access from any region
* **Compliance:** Data residency satisfied (EU sessions in EU)
* **Scalability:** Supports 100K+ concurrent users
* **Availability:** Multi-region failover (99.99% SLA)

### Negative

* **Cost increase:** $80/month → $400/month (5x, but 5x users)
* **Operational complexity:** Monitor 3 regional clusters
* **Data consistency:** Eventual consistency across regions (tunable)
* **Migration effort:** 2 weeks engineering time

### Neutral

* **Session format unchanged:** No application code changes
* **Library support:** connect-redis compatible with cluster mode

## Implementation Plan

- [x] Provision Global Datastore (US-East primary)
- [x] Add EU-West region
- [x] Add AP-Southeast region
- [x] Configure cross-region replication
- [ ] Implement geographic session routing
- [ ] Migrate existing sessions (gradual rollout)
- [ ] Update monitoring dashboards
- [ ] Documentation and runbooks

## Related ADRs

- **Supersedes:** ADR-004 (Redis single instance)
- **Related:** ADR-020 (Data residency compliance strategy)
- **Related:** ADR-015 (Global infrastructure deployment)
```

**Why preserve original ADR?**

* Shows historical decision process
* Explains why initial approach made sense
* Documents evolution trigger (growth, compliance)
* Learning resource: "right decision at the time"

## Cross-Referencing Related ADRs

Architecture decisions are interconnected. Document these relationships explicitly.

**Relationship types:**

* **Depends on:** This decision requires another decision first
* **Related to:** This decision complements or interacts with another
* **Supersedes:** This decision replaces a previous decision
* **See also:** This decision provides additional context

### Example: Building Decision Network

```markdown
# ADR-018: Redis Cluster for Global Sessions

## Related ADRs

- **Supersedes:** ADR-004 (Redis single instance) - Original session storage
- **Depends on:** ADR-015 (Multi-region deployment) - Infrastructure foundation
- **Related to:** ADR-020 (Data residency compliance) - Drives regional requirements
- **Related to:** ADR-008 (API rate limiting) - Also uses Redis infrastructure
- **See also:** ADR-022 (Cache warming strategy) - Session preloading approach
```

**Benefits:**

* Creates navigable knowledge graph
* Shows decision dependencies
* Helps understand system architecture holistically
* Reveals coupling between components

**Maintenance tip:** Update related ADRs bidirectionally. When creating ADR-018, also update ADR-004, ADR-015, and ADR-020 to reference ADR-018.

## ADR Templates for Common Decisions

Create team-specific templates for frequently-made decision types.

**Common decision categories:**

* Database technology selection
* Authentication/authorization approach
* API design (REST vs GraphQL vs gRPC)
* Deployment strategy
* Testing approach
* Monitoring and observability
* Data migration strategy

### Template Example: Database Technology Selection

```markdown
# ADR-NNN: [Database Technology] for [Use Case]

## Status
Proposed

## Context

### Requirements
- **Data volume:** [current and 2-year projection]
- **Query patterns:** [read/write ratio, query complexity, access patterns]
- **Consistency needs:** [strong, eventual, specific guarantees]
- **Performance targets:** [latency, throughput requirements]
- **Team expertise:** [current skills, learning curve tolerance]

### Constraints
- **Budget:** [monthly infrastructure cost limit]
- **Deployment:** [cloud provider, region requirements]
- **Compliance:** [data residency, encryption, audit requirements]
- **Integration:** [existing systems, data pipelines]

### Current Setup
[Existing database architecture, limitations prompting decision]

## Decision

[Database technology and specific configuration]

**Implementation details:**
- Version: [specific version number]
- Configuration: [key settings]
- Deployment: [managed service vs self-hosted]

## Alternatives Considered

### [Option 1: Technology Name]

**Pros:**
* [Specific benefit with quantification where possible]
* [Another benefit]

**Cons:**
* [Specific drawback with quantification]
* [Another drawback]

**Evaluation:**
* [Benchmark results, POC findings, team assessment]

**Why not chosen:**
[Clear statement of deal-breaker or key reason]

### [Option 2: Technology Name]
[Same structure as Option 1]

### [Option 3: Technology Name]
[Same structure as Option 1]

## Consequences

### Positive
- **Performance:** [Specific metrics from benchmarks]
- **Cost:** [Monthly estimate with breakdown]
- **Operational:** [Maintenance burden, monitoring, scaling]
- **Team impact:** [Learning curve, productivity effect]

### Negative
- **Limitations:** [Known constraints, edge cases]
- **Risks:** [Dependencies, single points of failure]
- **Technical debt:** [Future challenges this introduces]

### Neutral
- **Changes required:** [Migration, code updates, process changes]

## Implementation Plan

- [ ] [Specific actionable step]
- [ ] [Another step]
- [ ] [Testing and validation]
- [ ] [Monitoring setup]
- [ ] [Documentation]

## References

- [Benchmark results documentation]
- [Vendor/product documentation]
- [Internal evaluation notes]
- [Related standards or guidelines]

## Related ADRs

- **Depends on:** [ADR that must exist first]
- **Related to:** [ADR with architectural interaction]
```

### Using Templates with AI Prompts

```text
Create an ADR following the template at docs/adr/templates/database-selection.md

Fill in for decision: Use PostgreSQL for customer data
Include benchmarks from our evaluation last week
Alternatives: MySQL, MongoDB, DynamoDB
```

AI uses template structure and fills with conversation context when you reference the template file.

## Team ADR Standards

Establish team conventions for ADR quality and process.

### ADR Review Checklist

```markdown
## ADR Review Requirements

### Content Completeness
- [ ] Context section complete (future readers will understand)
- [ ] All seriously-considered alternatives documented
- [ ] Consequences realistic (includes negative impacts)
- [ ] Decision statement clear and actionable
- [ ] References included where appropriate

### Format Standards
- [ ] Follows MADR template structure
- [ ] ADR number follows sequence
- [ ] Status field present and accurate
- [ ] Proper markdown formatting

### Technical Accuracy
- [ ] Performance claims backed by benchmarks or estimates
- [ ] Cost estimates realistic and sourced
- [ ] Implementation approach feasible
- [ ] No factual errors

### Team Alignment
- [ ] Decision aligns with architecture principles
- [ ] Reviewers from affected teams consulted
- [ ] Security/compliance considerations addressed
```

### ADR Approval Workflow

**Lightweight process for most ADRs:**

1. Developer creates ADR in feature branch
2. Open pull request (ADR + implementation, or ADR-only)
3. Request review from relevant stakeholders
4. Discuss in PR comments (or synchronous meeting for complex decisions)
5. Merge ADR before implementation begins
6. Reference ADR number in implementation PRs

**Architecture Review Board for significant decisions:**

* Infrastructure changes (new services, databases, cloud resources)
* Cross-team impacts (API contracts, shared libraries)
* Security-sensitive decisions (authentication, authorization, encryption)
* Cost implications >$1000/month

### ADR Maintenance Schedule

**Quarterly review:**

* Review all "Proposed" ADRs
* Accept, reject, or request updates (don't leave in limbo)
* Close stale proposals

**Annual review:**

* Review all "Accepted" ADRs
* Validate still accurate
* Update consequences based on production experience
* Mark deprecated where superseded

## ADR Metrics and Health Indicators

Track ADR practice health with simple metrics.

**Metrics to monitor:**

* Number of ADRs created per quarter
* Average time from "Proposed" to "Accepted"
* Percentage of "Deprecated" ADRs (shows evolution)
* ADRs missing consequences section (quality indicator)
* ADRs referenced in code review comments

### Example Dashboard

```markdown
# ADR Metrics - Q4 2024

**Library Health:**
- Total ADRs: 47
- Created this quarter: 9
- Accepted this quarter: 8
- Deprecated: 5
- In "Proposed" status >30 days: 1 ⚠️

**Process Health:**
- Average time to acceptance: 4 days ✅
- ADRs with consequences section: 46/47 (98%) ✅
- ADRs referenced in PRs this quarter: 23 ✅

**Top ADRs by PR References:**
1. ADR-012 (TimescaleDB analytics): 8 PRs
2. ADR-018 (Redis cluster): 6 PRs
3. ADR-007 (PostgreSQL primary): 5 PRs

**Quality Indicators:**
- ✅ Steady ADR creation (decisions documented)
- ✅ Short time to acceptance (efficient review)
- ✅ Frequent PR references (ADRs actively used)
- ✅ Some deprecated ADRs (system evolving healthily)
- ⚠️ One stale proposal (needs resolution)
```

**Red flags:**

* No new ADRs for 6+ months (decisions not documented)
* Many ADRs stuck in "Proposed" (review bottleneck)
* Zero deprecated ADRs (system not evolving, or ADRs not updated)
* No PR references (ADRs not influencing implementation)

**Green indicators:**

* 1-2 ADRs per month average
* <1 week average time to acceptance
* Regular PR references to ADRs
* Occasional deprecation (healthy evolution)

---

**Previous:** [Integrating ADRs into RPI Workflow](04-adr-integration-rpi-workflow.md) | **Next:** [Complete ADR Example Walkthrough](06-complete-adr-example.md) | **Up:** [Part II: Core Modes and Workflows](../README.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
