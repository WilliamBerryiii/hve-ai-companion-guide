---
title: "Writing ADRs with AI Assistance"
description: Follow the research-to-ADR workflow for efficient AI-assisted architecture decision documentation
author: HVE Core Team
ms.date: 2025-11-26
chapter: 10
part: "II"
keywords:
  - ai-assisted
  - adr-workflow
  - research-to-adr
  - documentation-generation
---

## Writing ADRs with AI Assistance

### Research-to-ADR Workflow

The journey from exploring options to documenting decisions follows a structured pattern. This workflow ensures you capture context while it's fresh and complete.

### Standard workflow

1. **Research Phase (Ask Mode)**: Discover options and trade-offs
2. **Decision Point**: Choose approach based on research
3. **ADR Creation (Ask Mode with ADR prompts)**: Document decision with AI assistance
4. **Review and Refine**: Verify accuracy and completeness
5. **Commit ADR**: Add to repository
6. **Planning Phase (Plan Mode)**: Reference ADR in implementation plan

This workflow keeps ADR creation lightweight while ensuring quality documentation.

### Example: Session Storage Decision

### Step 1: Research (Ask Mode)

```text
What are the options for session storage in a Node.js web app?
- Requirements: shared across servers, high performance, automatic expiration
- Compare: in-memory, Redis, database-backed, DynamoDB
```

You engage in a 10-minute conversation exploring options, trade-offs, and performance characteristics.

### Step 2: Decision

Based on research: Choose Redis for its performance characteristics and cost-effectiveness.

### Step 3: Create ADR (Ask Mode with ADR Prompts)

```text
Create an ADR in MADR format for session storage decision.

Based on our conversation above, document:
- Decision: Use Redis for session storage
- Context: Multi-server web app, 10K concurrent users, need TTL
- Alternatives: in-memory, PostgreSQL, DynamoDB
- Include performance and cost considerations

Format with all standard MADR sections: Status, Context, Decision, 
Alternatives Considered, Consequences, and References.
```

### Step 4: Review Generated ADR

```markdown
# ADR-004: Use Redis for Session Storage

## Status

Proposed

## Context

Our Node.js web application requires session storage with:

* Shared state across 3+ server instances (load balanced)
* High performance: sub-millisecond reads
* Automatic expiration (TTL)
* Support for 10,000+ concurrent sessions
* Budget constraint: ~$100/month for session infrastructure

Current deployment: AWS ECS with 3 containers behind ALB.

## Decision

We will use Redis (AWS ElastiCache) as our session storage backend.

## Alternatives Considered

### 1. In-Memory (Node.js process)

**Pros:**

* Fastest possible access (no network)
* No additional infrastructure

**Cons:**

* Not shared across instances (sticky sessions required)
* Lost on container restart
* Limited by container memory

### 2. PostgreSQL sessions table

**Pros:**

* Leverages existing database
* Persistent storage
* No new infrastructure

**Cons:**

* Slower (~5-10ms vs <1ms for Redis)
* Requires custom TTL cleanup job
* Adds load to primary database

### 3. DynamoDB

**Pros:**

* Fully managed, serverless
* Good integration with AWS services

**Cons:**

* Higher latency (~10-20ms)
* Higher cost ($150-200/month at scale)
* Less mature session library support

## Consequences

### Positive

* Sub-millisecond session access
* Built-in TTL handles automatic cleanup
* Battle-tested Express session middleware
* Managed service (ElastiCache) reduces ops burden
* Cost-effective (~$80/month for cache.t3.micro)

### Negative

* Additional infrastructure component to monitor
* Single point of failure (requires cluster mode for HA)
* Memory-only by default (enable persistence for durability)
* Network dependency (Redis unavailable = login failures)

## References

* [Express Session + Redis Guide](https://example.com/express-redis)
* [ElastiCache Pricing Calculator](https://aws.amazon.com/elasticache/pricing/)
```

### Step 5: Refine

```text
Good! Change Status to "Accepted" and add:
- Note about Redis cluster setup for HA (we'll do multi-AZ)
- Reference to security guide for encryption in transit
```

### Step 6: Commit

```bash
git add docs/adr/0004-session-redis.md
git commit -m "docs: ADR-004 Use Redis for session storage"
```

This workflow takes approximately 5-10 minutes after your research is complete.

## Capturing Context from Conversations

AI excels at extracting information from conversations, but you provide the judgment about what's important.

### AI extracts from conversation

* Requirements mentioned during discussion
* Constraints discussed
* Alternatives explored
* Trade-offs identified
* Performance benchmarks cited

### Your role

* Verify context completeness
* Add context AI missed (team knowledge, project history)
* Clarify ambiguous statements
* Include specific numbers and timelines

### Example: Adding Missing Context

**AI-generated context:**

```markdown
## Context

Need session storage for web app with multiple servers.
```

**Your refinement:**

```markdown
## Context

Our Node.js web application requires session storage with:

* Shared state across 3+ server instances (load balanced)
* High performance: sub-millisecond reads required for UX
* Automatic expiration (TTL) for security and memory management
* Support for 10,000+ concurrent users (current: 2,000, growing 50%/year)
* Budget constraint: ~$100/month for session infrastructure

Current deployment: AWS ECS with 3 containers behind ALB.  
Previous approach: In-memory with sticky sessions (issues during deployments).
```

Adding specific numbers, constraints, and history dramatically improves future understanding.

## Structuring Decision Rationale

Strong decision statements clarify exactly what you're doing and why.

**Strong decision statements:**

* Clear and actionable
* Specific about what's being done
* Explains how it addresses context

**Weak decision:** "Use Redis"

**Strong decision:**

```markdown
## Decision

We will use Redis (AWS ElastiCache) as our session storage backend,
configured with:

* Multi-AZ cluster for high availability
* Encryption in transit enabled
* Daily automated backups
* 7-day retention for recovery

Session data will be stored with 24-hour TTL, using the
connect-redis middleware for Express.
```

The strong version includes configuration details that guide implementation and provide complete specification.

## Alternatives and Trade-Offs Section

**Key principle:** Document ALL seriously-considered alternatives, even if quickly dismissed.

**Why document rejected options?**

* Future readers understand what was evaluated
* Prevents revisiting same discussion repeatedly
* Context changes might make alternative viable later
* Shows thoroughness of decision process

**Structure for each alternative:**

```markdown
### [Alternative Name]

**Pros:**

* Specific benefit 1
* Specific benefit 2
* Quantified where possible (e.g., "50% lower cost")

**Cons:**

* Specific drawback 1
* Specific drawback 2
* Quantified where possible (e.g., "3x higher latency")

**Why not chosen:** [Clear statement of deal-breaker or key reason]
```

### Example with Quantified Trade-offs

```markdown
### PostgreSQL Sessions Table

**Pros:**

* No new infrastructure (use existing database)
* Persistent storage (survives restarts)
* Transaction support for complex session updates

**Cons:**

* 10-15ms latency vs <1ms for Redis (benchmarked)
* No native TTL (requires custom cleanup job)
* Adds ~1000 queries/sec load to primary database

**Why not chosen:** Latency requirement (<5ms) and database load
concerns made this unsuitable for our use case.
```

Quantified comparisons prevent future debates about why alternatives were rejected.

## Consequences Documentation

**Be honest and complete:**

* Every decision has negative consequences
* Documenting them isn't admitting mistake
* Helps future maintainers understand trade-offs

**Positive consequences:**

* Benefits realized
* Problems solved
* Goals achieved

**Negative consequences:**

* Costs incurred (time, money, complexity)
* New problems introduced
* Limitations accepted

**Neutral consequences:**

* Changes that aren't clearly positive or negative
* Things to be aware of

### Example: Comprehensive Consequences

```markdown
## Consequences

### Positive

* **Performance**: Sub-millisecond session reads (<0.5ms avg, benchmarked)
* **Scalability**: Supports 10K+ concurrent sessions easily
* **Operational**: Managed service (ElastiCache) handles backups, patching
* **Developer experience**: Well-documented Express middleware
* **Cost**: $80/month vs $200/month for DynamoDB alternative

### Negative

* **New dependency**: Redis failure = login failures (mitigated with HA cluster)
* **Memory constraints**: Need to monitor and scale if session data grows
* **Complexity**: Additional service to monitor, alert, troubleshoot
* **Data persistence**: Memory-only by default (enabled AOF persistence)

### Neutral

* **Local development**: Requires Docker Compose for Redis locally
* **Security**: Must configure encryption in transit (AWS requirement)
```

This level of detail helps future teams understand exactly what they're inheriting.

## AI Assistance Techniques

### Prompt Patterns for Better ADRs

**1. Context-rich prompts:**

```text
Create ADR documenting Redis session storage decision.

Include context from our research above PLUS:
- Budget constraint: $100/month max
- Current setup: 3 ECS containers, sticky sessions
- Pain point: Session loss during deployments
- Growth projection: 50% user increase yearly
```

**2. Iterative refinement:**

```text
Good start. Now:
- Add DynamoDB as alternative (cost was key factor)
- Expand "negative consequences" with monitoring burden
- Add reference to our Redis security checklist doc
```

**3. Team template integration:**

```text
Use our team ADR template at docs/adr/template.md

Fill in sections for Redis session storage decision.
Follow our standard: add "Implementation Notes" section
with deployment checklist.
```

These patterns give AI clear direction while maintaining your control over content quality.

## Hands-On Exercise 3.1: Create ADR from Research Session

**Goal:** Transform research conversation into complete ADR using AI assistance.

**Scenario:**

Your team is building a new API and needs to choose between REST, GraphQL, and gRPC. You've just completed research exploring all three options.

**Your Task:**

1. **Conduct research** (10 minutes):
   * Use Ask Mode to explore REST vs GraphQL vs gRPC
   * Focus on: learning curve, tooling, client requirements, performance
   * Document team context: primarily web clients, some mobile apps

2. **Make decision**: Choose one approach based on research findings

3. **Create ADR** (5 minutes):
   * Use Ask Mode with ADR-focused prompts
   * Reference research conversation
   * Ensure all three alternatives documented

4. **Refine ADR** (5 minutes):
   * Add team-specific context AI might have missed
   * Quantify performance differences where possible
   * Include timeline for implementation

**Success Criteria:**

* ADR includes all MADR sections
* Context explains client requirements and team constraints
* All three alternatives documented with pros/cons
* Consequences section includes both positive and negative impacts
* Decision statement is clear and actionable

**Reflection Questions:**

* What context did AI capture well from conversation?
* What information did you need to add manually?
* How will this ADR help future team members?

---

**Previous:** [ADR Creation Fundamentals](02-adr-creator-mode-fundamentals.md) | **Next:** [Integrating ADRs into RPI Workflow](04-adr-integration-rpi-workflow.md) | **Up:** [Part II: Core Modes and Workflows](../README.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
