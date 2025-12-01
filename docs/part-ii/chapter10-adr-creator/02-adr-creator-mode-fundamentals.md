---
title: "ADR Creation Fundamentals"
description: Master the MADR format and AI-assisted patterns for generating structured architecture decision records
author: HVE Core Team
ms.date: 2025-11-26
chapter: 10
part: "II"
keywords:
  - adr-creation
  - madr-format
  - decision-documentation
  - architecture-records
---

## ADR Creation Fundamentals

### AI-Assisted ADR Creation

GitHub Copilot excels at generating architecture decision records when given proper context and structure. Using Ask Mode with ADR-focused prompts, you can transform research conversations and technical context into structured, maintainable documentation.

**AI-assisted ADR characteristics:**

* **Format-aware**: Follows MADR structure when prompted explicitly
* **Context-extracting**: Pulls relevant information from conversations and code
* **Template-driven**: Uses standardized format for consistency
* **File-generating**: Creates ADR markdown content ready to save

**How modes support ADR creation:**

* **Ask Mode**: Research alternatives and generate ADR content with prompts
* **Agent Mode**: Create ADR files directly in your project structure
* **Edit Mode**: Update ADRs as decisions evolve over time

AI-assisted ADR creation sits at the critical juncture between research and implementation. It captures the "why" that code alone can never express.

## MADR Format Specification

When prompted to create ADRs, GitHub Copilot can follow the **MADR (Markdown Architecture Decision Records)** format. This lightweight format balances completeness with maintainability. Including MADR structure in your prompts helps AI generate consistent, well-organized documentation.

**Required sections:**

### 1. Title

`ADR-NNN: [Brief decision statement]`

* NNN is sequential number (001, 002, 003...)
* Title is actionable phrase (e.g., "Use PostgreSQL for primary database")
* Keep title under 60 characters when possible

### 2. Status

Current state of the decision:

* `Proposed`: Under review, not yet approved
* `Accepted`: Approved and actively implemented
* `Deprecated`: Still in use but discouraged for new work
* `Superseded by ADR-XYZ`: Replaced by newer decision
* `Rejected`: Considered but not adopted

### 3. Context

Situation and forces leading to the decision:

* What problem are you solving?
* What constraints exist?
* What requirements must be met?
* What's the current state?

This section answers "why did we need to decide?" Include enough detail that someone reading the ADR six months later can understand the situation without hunting for additional context.

### 4. Decision

Clear statement of the chosen approach:

* What are you doing?
* How does it address the context?
* What's the scope of application?

Use active voice and definitive language: "We will use Redis for session storage" rather than "We might consider Redis."

### 5. Alternatives Considered

Other options you evaluated:

* List each alternative
* Brief pros and cons for each
* Why it wasn't chosen

This section prevents future teams from wondering "did they consider X?" Document all seriously-evaluated alternatives.

### 6. Consequences

Impact of the decision:

* **Positive**: Benefits and wins
* **Negative**: Costs and drawbacks
* **Neutral**: Other impacts to be aware of

Be honest about negative consequences. Every decision involves trade-offs. Documenting them prevents surprises and shows thorough evaluation.

**Optional sections:**

### 7. References

Links to:

* Research findings
* Benchmark results
* External documentation
* Related specifications

### 8. Notes

Additional context not fitting elsewhere:

* Implementation considerations
* Migration path from previous approach
* Timeline or phasing details

### 9. Related ADRs

Links to:

* Superseded ADRs
* Dependent decisions
* Related architectural choices

## Example Complete ADR

```markdown
# ADR-007: Use PostgreSQL as Primary Database

## Status

Accepted (2024-01-15)

## Context

Our application needs a database for:

* User account data (structured, relational)
* Task and project data (complex queries, joins)
* Full-text search on task descriptions
* ACID transactions for critical operations
* Support for 100K+ users, 1M+ tasks
* On-premises deployment (can't use cloud-only solutions)

**Budget:** ~$500/month for database infrastructure  
**Team:** Experienced with SQL, limited NoSQL experience

## Decision

We will use PostgreSQL as our primary database.

## Alternatives Considered

### 1. MySQL

**Pros:**

* Team has some MySQL experience
* Widely adopted with large ecosystem
* Good performance for read-heavy workloads

**Cons:**

* Weaker full-text search capabilities than PostgreSQL
* Less advanced JSON support
* Licensing concerns (now Oracle-owned)

### 2. MongoDB

**Pros:**

* Flexible schema for evolving data models
* Horizontal scaling built-in
* Good for document-style data

**Cons:**

* Requires learning new query language
* Not ideal for relational data with many joins
* ACID transactions are recent addition
* Team has no NoSQL production experience

### 3. SQLite

**Pros:**

* No separate server process needed
* Extremely simple deployment
* Perfect for single-server scenarios

**Cons:**

* No concurrent write support
* Not suitable for multi-server architecture
* Limited scalability for 100K+ users

## Consequences

### Positive

* **Rich feature set**: Full-text search, JSON support, complex queries all native
* **ACID compliance**: Strong consistency guarantees for transactions
* **Proven scalability**: Many examples of PostgreSQL at our target scale
* **Team familiarity**: SQL knowledge transfers directly
* **Cost-effective**: Open source with no licensing fees
* **Extensibility**: PostGIS for geospatial, pg_vector for embeddings

### Negative

* **Vertical scaling focus**: Horizontal scaling requires additional tools (Citus, sharding)
* **Maintenance overhead**: Must manage backups, replication, performance tuning
* **Single-server risk**: Requires planning for high availability (replication setup)

### Neutral

* **On-premises deployment**: Requires server provisioning (already planned)
* **Monitoring needed**: Will use pgAdmin and CloudWatch metrics

## References

* [PostgreSQL Official Documentation](https://www.postgresql.org/docs/)
* [PostgreSQL vs MySQL Comparison](https://example.com/pg-vs-mysql)
* [Full-Text Search Benchmarks](https://example.com/fts-benchmarks)

## Related ADRs

* ADR-008: PostgreSQL replication strategy (to be created)
* ADR-009: Backup and disaster recovery (to be created)
```

This example shows all essential elements while remaining scannable and maintainable.

## ADR Storage and Organization

**Recommended structure:**

```text
project-root/
├── docs/
│   └── adr/
│       ├── README.md              # Index of all ADRs
│       ├── 0001-use-typescript.md
│       ├── 0002-api-design-rest.md
│       ├── 0003-auth-jwt-tokens.md
│       └── 0007-database-postgresql.md
```

**Naming convention:**

* `NNNN-brief-title.md` format
* 4-digit sequential number (0001, 0002, 0003...)
* Hyphen-separated lowercase title
* `.md` extension

**Index file (docs/adr/README.md):**

```markdown
# Architecture Decision Records

This directory contains all architecture decisions for the project.

## ADR Index

| ADR                                 | Title                    | Status   | Date       |
|-------------------------------------|--------------------------|----------|------------|
| [0001](0001-use-typescript.md)      | Use TypeScript           | Accepted | 2024-01-10 |
| [0002](0002-api-design-rest.md)     | REST API Design          | Accepted | 2024-01-12 |
| [0003](0003-auth-jwt-tokens.md)     | JWT for Authentication   | Accepted | 2024-01-14 |
| [0007](0007-database-postgresql.md) | PostgreSQL as Primary DB | Accepted | 2024-01-15 |

## Creating New ADRs

Use GitHub Copilot with ADR-focused prompts or copy template from template-adr.md.
```

The index provides quick navigation and status overview for all architecture decisions.

## Prompting for ADR Creation

### Method 1: Direct Prompt (Ask Mode)

In GitHub Copilot Chat, use Ask Mode with explicit ADR formatting instructions:

```text
Create an ADR in MADR format for session storage decision.

Context:
- Need shared session storage across multiple servers
- Require sub-millisecond performance
- 10K concurrent users expected
- Automatic expiration needed

Decision: Use Redis

Alternatives considered: in-memory, PostgreSQL, DynamoDB

Format the output as a complete MADR document with Status, Context, 
Decision, Alternatives Considered, and Consequences sections.
```

### Method 2: From Research Conversation

After exploring options in Ask Mode:

```text
Based on our session storage research above, create an ADR documenting 
this decision:
- Decision: Redis for sessions
- Use context from our conversation
- Format as MADR with all standard sections
- Include positive and negative consequences
```

### Method 3: Template-Based

Reference your team's template in the prompt:

```text
Create an ADR following the template structure in docs/adr/template-adr.md

Topic: Database selection (PostgreSQL)
Include all sections from the template with detailed content.
```

Choose the method that best fits your workflow. Method 2 works especially well when you've conducted thorough research and want to preserve that context.

## AI-Generated ADR Output

### What you receive

* Complete MADR-formatted markdown ready to copy
* Structured sections with content based on your prompt
* Suggested ADR number and filename
* Proper frontmatter if you specify that in your prompt

### What you review

* Context accurately reflects the situation
* Alternatives list is complete
* Consequences are realistic and balanced
* Decision statement is clear and actionable
* References are included where relevant

### Refinement example

```text
Good structure, but:
- Add MySQL as alternative (we discussed it earlier)
- Expand negative consequences: mention HA complexity
- Add reference to benchmarks document
```

Treat AI-generated ADRs as drafts requiring review. The AI captures structure well but needs your judgment about completeness and accuracy.

## ADR Creation Best Practices

**DO:**

* Create ADR immediately after research phase while context is fresh
* Include enough context for future readers (6+ months later)
* Document all seriously-considered alternatives
* Be honest about negative consequences
* Link to supporting research and benchmarks
* Review and refine AI-generated ADR before committing

**DON'T:**

* Create ADR after implementation when memory has faded
* Skip alternatives section even if choice seems obvious
* Omit negative consequences (every decision has trade-offs)
* Accept AI-generated ADR without review
* Create ADRs for trivial decisions (threshold: significant and lasting impact)

Following these practices ensures your ADRs remain valuable long after they're written.

---

**Previous:** [Introduction - Why Document Decisions?](01-introduction-why-document-decisions.md) | **Next:** [Writing ADRs with AI Assistance](03-writing-adrs-with-ai-assistance.md) | **Up:** [Part II: Core Modes and Workflows](../README.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
