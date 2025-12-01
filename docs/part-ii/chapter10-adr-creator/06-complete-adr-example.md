---
title: "Complete ADR Example Walkthrough"
description: Walk through a complete end-to-end ADR creation scenario from research through documentation
author: HVE Core Team
ms.date: 2025-11-26
chapter: 10
part: "II"
keywords:
  - adr-example
  - database-selection
  - end-to-end
  - walkthrough
---

## Complete ADR Example Walkthrough

### Scenario: Database Selection for Analytics Feature

Your task management application is adding a "Team Analytics" feature requiring different database characteristics than your existing transactional workload.

**Starting context:**

* **Existing system:** PostgreSQL for task/user/project data
* **New feature:** Team analytics dashboard
  * Aggregate statistics across teams
  * Time-series data (task completion rates over time)
  * Complex queries (GROUP BY, multiple joins, moving averages)
  * Query-heavy workload (read >> write)
* **Scale:** Currently ~1M data points, growing to ~10M over 2 years

**Question:** Use existing PostgreSQL or add specialized analytics database?

## Phase 1: Research (Ask Mode) - 10 Minutes

You explore options systematically using Ask Mode.

**Prompt 1:**

```text
What database options exist for analytics workloads with time-series data?

Requirements:
- Store task completion metrics over time
- Complex aggregations (GROUP BY team, date range, task type)
- Join with existing PostgreSQL tables (users, teams)
- <2 second dashboard query response
```

**AI Response Summary:** PostgreSQL with TimescaleDB, ClickHouse, InfluxDB, DynamoDB Time Series, separate PostgreSQL instance.

**Prompt 2:**

```text
Compare PostgreSQL + TimescaleDB vs ClickHouse for this use case

Current setup: PostgreSQL 14 on AWS RDS
Team: 5 years PostgreSQL experience, no ClickHouse experience
Data volume: 1M points now, 10M in 2 years
Budget: prefer leveraging existing infrastructure
```

**AI Response Summary:** TimescaleDB offers 10x time-series performance improvement, stays in PostgreSQL ecosystem. ClickHouse offers 100x improvement but requires separate infrastructure and team learning.

**Prompt 3:**

```text
What's the operational complexity difference between running ClickHouse 
vs extending our existing PostgreSQL with TimescaleDB?

Consider: monitoring, backups, team learning curve, infrastructure cost
```

**AI Response Summary:** TimescaleDB: 1-2 week learning curve, existing PostgreSQL monitoring works, no new infrastructure. ClickHouse: 2-3 month learning curve, new monitoring stack, separate infrastructure ($300+/month), data replication complexity.

**Prompt 4:**

```text
Show me benchmark results for time-series queries:
- PostgreSQL (vanilla)
- PostgreSQL + TimescaleDB
- ClickHouse

Specific queries:
1. Moving average over 30-day window
2. Percentile calculations across time buckets
3. Multi-table joins with time-series data
```

**AI Response Summary:**

* Vanilla PostgreSQL: 3-5 seconds
* TimescaleDB: 200-500ms (10x faster)
* ClickHouse: 50-100ms (100x faster, but limited JOIN support)

**Research conclusions:**

* TimescaleDB provides sufficient performance (<2s target)
* No new infrastructure or team learning required
* Can migrate to ClickHouse later if scale demands

## Phase 2: Decision - 2 Minutes

Based on research, you decide: **PostgreSQL + TimescaleDB extension**.

**Reasoning:**

* Performance improvement (10x) meets requirements
* Leverages team's PostgreSQL expertise
* No additional infrastructure cost
* Operational simplicity (extension, not separate database)
* Future migration path to ClickHouse if needed

## Phase 3: Create ADR (Ask Mode with ADR Prompts) - 5 Minutes

Now document the decision while context is fresh.

**Prompt:**

```text
Create an ADR in MADR format for analytics database decision.

Based on our research conversation above, document:

Decision: Use PostgreSQL with TimescaleDB extension for team analytics
Context: New analytics feature, time-series data, 1M→10M data points, <2s query requirement
Alternatives: ClickHouse, InfluxDB, separate PostgreSQL instance
Key factors: team expertise, operational simplicity, performance sufficient for scale

Include benchmark results from our discussion.
Format with all standard sections: Status, Context, Decision, Alternatives 
Considered, Consequences, Implementation Plan, References, and Related ADRs.
```

**Generated ADR (AI draft):**

```markdown
# ADR-012: Use PostgreSQL with TimescaleDB for Team Analytics

## Status
Proposed

## Context

Our task management application is adding "Team Analytics" feature requiring:

**Requirements:**
- Time-series data: task completions, velocity metrics, burndown charts
- Data volume: ~1M data points currently, growing to ~10M over 2 years
- Query patterns:
  * Complex aggregations (GROUP BY team, date range, task type)
  * Time-series operations: moving averages, percentiles over windows
  * Joins with existing task/user/team tables in PostgreSQL
- Performance target: <2 second response for dashboard queries
- Budget constraint: Prefer leveraging existing infrastructure

**Current Setup:**
- PostgreSQL 14 (AWS RDS) for transactional data
- Team: 5 years PostgreSQL experience
- No experience with specialized analytics databases
- Existing monitoring and backup systems for PostgreSQL

## Decision

We will use PostgreSQL with the TimescaleDB extension for team analytics data.

**Implementation approach:**
- Install TimescaleDB extension on existing PostgreSQL RDS instance
- Create separate `analytics` schema (isolate from transactional tables)
- Use TimescaleDB hypertables for time-series metrics
- Leverage continuous aggregates for pre-computed dashboard queries
- Configure retention policies for automatic data lifecycle

## Alternatives Considered

### 1. ClickHouse (Separate Analytics Database)

**Pros:**
- Extreme performance: 50-100ms query times (100x faster than vanilla PostgreSQL)
- Purpose-built for analytics workloads
- Columnar storage optimized for aggregations

**Cons:**
- New database technology (team learning curve: 2-3 months)
- Additional infrastructure: $300/month for managed ClickHouse
- Data replication from PostgreSQL required (adds complexity)
- Limited JOIN support (would need to duplicate data from main DB)

**Benchmarks:**
- Moving average query: ClickHouse 50ms vs PostgreSQL 5000ms
- Percentile calculation: ClickHouse 75ms vs PostgreSQL 4500ms

**Why not chosen:** Performance gain (100x) doesn't justify operational complexity at current scale. TimescaleDB provides sufficient performance (10x improvement) to meet <2s target.

### 2. InfluxDB (Time-Series Specialist)

**Pros:**
- Designed specifically for time-series data
- Simple deployment and operation
- Purpose-built query language (InfluxQL)

**Cons:**
- No JOIN support (cannot query with PostgreSQL tables)
- Would need to duplicate user/team data from PostgreSQL
- Team unfamiliar with InfluxQL
- Enterprise features: $500/month license cost

**Why not chosen:** Lack of JOIN support is deal-breaker. Our analytics queries require correlation with task/user/team tables.

### 3. Separate PostgreSQL Instance (Analytics Replica)

**Pros:**
- Same technology as main database (no learning curve)
- Could use read replica approach
- Familiar operational model

**Cons:**
- Doesn't solve performance problem (same query engine)
- Doubles database infrastructure cost
- Read replica lag (real-time analytics delayed)
- No time-series optimizations

**Why not chosen:** Provides no performance benefit for time-series queries.

## Consequences

### Positive

- **Performance:** Benchmarked 10x faster time-series queries
  * Moving average query: 500ms (vs 5000ms vanilla PostgreSQL)
  * Time-bucket aggregations: 200ms (vs 3000ms vanilla)
- **Team productivity:** No new query language to learn (standard SQL)
- **Operational simplicity:** Extension on existing DB (no new infrastructure)
- **Cost-effective:** $0 additional infrastructure cost (open-source extension)
- **Data consistency:** Analytics data in same database (no replication lag)
- **Future-proofing:** Can migrate to ClickHouse later if scale requires

### Negative

- **Extension dependency:** Tied to TimescaleDB maintenance schedule
- **Shared resources:** Analytics queries compete with transactional workload (mitigated by read replica)
- **Scaling limits:** If data grows beyond 10M rows, may need dedicated analytics DB
- **Backup complexity:** Ensure TimescaleDB continuous aggregates included in backups

### Neutral

- **Learning curve:** 1-2 weeks to understand TimescaleDB concepts (hypertables, chunks, continuous aggregates)
- **Monitoring:** Add TimescaleDB-specific metrics to existing PostgreSQL dashboards

## Implementation Plan

- [ ] Enable TimescaleDB extension on RDS PostgreSQL
- [ ] Create `analytics` schema
- [ ] Design hypertable structure for metrics
- [ ] Set up continuous aggregates for common dashboard queries
- [ ] Configure 90-day retention policy for raw metrics
- [ ] Update monitoring dashboards with TimescaleDB metrics
- [ ] Backfill 6 months historical data
- [ ] Performance test with production-like data volume
- [ ] Document query patterns in team wiki

## References

- [TimescaleDB Documentation](https://docs.timescale.com/)
- [TimescaleDB vs ClickHouse Benchmark](https://blog.timescale.com/benchmark)
- [Internal Benchmark Results](https://wiki.internal/analytics-db-benchmarks)
- [PostgreSQL RDS Performance Guide](https://docs.aws.amazon.com/rds/postgresql)

## Related ADRs

- **Related to:** ADR-007 (Use PostgreSQL as Primary Database) - Parent decision
- **Future:** ADR-013 (Analytics Data Retention Policy) - To be created
```

## Phase 4: Review and Refine - 3 Minutes

You review AI-generated ADR for accuracy and completeness.

**Review checklist:**

✅ Context complete and accurate  
✅ Alternatives comprehensive  
✅ Benchmarks included  
✅ Decision clear  
⚠️ Missing: Specific TimescaleDB version  
⚠️ Missing: Migration strategy from existing analytics tables  
⚠️ Status should be "Accepted" (decided in team meeting)

**Refinement prompt:**

```text
Excellent ADR! Please add:

1. Specify TimescaleDB version 2.11 (latest stable)
2. Add migration strategy to Decision section:
   - Migrate existing analytics_events table
   - Dual-write approach for validation
3. Change Status to "Accepted" with date (decided 2024-11-17)
```

**Updated sections (final ADR):**

```markdown
## Status
Accepted (2024-11-17, Architecture Review Meeting)

## Decision

We will use PostgreSQL with TimescaleDB extension (version 2.11) 
for team analytics data.

**Implementation approach:**
- Install TimescaleDB 2.11 extension on existing RDS PostgreSQL
- Create separate `analytics` schema for time-series data
- Migrate existing `analytics_events` table to hypertable
- Use continuous aggregates for pre-computed dashboard queries
- Configure 90-day retention policy for raw metrics

**Migration strategy:**
1. Create new hypertable `analytics.metrics`
2. Backfill from existing `public.analytics_events` table
3. Dual-write to both tables for 1-week validation period
4. Cut over to hypertable exclusively after validation
5. Archive old table after 30 days
```

## Phase 5: Commit ADR - 2 Minutes

Add ADR to repository before implementation begins.

**Commands:**

```bash
# Create ADR file
git add docs/adr/0012-timescaledb-analytics.md

# Update ADR index
git add docs/adr/README.md

# Commit with descriptive message
git commit -m "docs: ADR-012 Use TimescaleDB for team analytics

Decided in architecture review meeting 2024-11-17.

Key factors:
- 10x performance improvement for time-series queries
- Leverages existing PostgreSQL expertise
- No additional infrastructure cost
- Can migrate to ClickHouse later if scale increases

Alternatives considered: ClickHouse (too complex), InfluxDB (no JOIN),
separate PostgreSQL (no performance benefit)."
```

**ADR index update:**

```markdown
# Architecture Decision Records

## Active Decisions

...

### Data Storage
- [ADR-007: Use PostgreSQL as Primary Database](0007-postgresql-primary.md)
- [ADR-012: Use TimescaleDB for Team Analytics](0012-timescaledb-analytics.md) ⭐ NEW
```

## Phase 6: Reference in Implementation Plan - 3 Minutes

Create implementation plan that references ADR for context.

**Task Planner prompt:**

```text
Create implementation plan for team analytics feature

Context: ADR-012 (TimescaleDB for analytics) approved
Include: database setup, schema design, data migration, query implementation
Timeline: 2-week sprint
```

**Generated plan (excerpt):**

```markdown
## Implementation Plan: Team Analytics Feature

**Context:** Implementing ADR-012 (TimescaleDB for analytics)

### Phase 1: Database Setup (4 hours)

**Task 1.1: Enable TimescaleDB extension**
- Install TimescaleDB 2.11 per ADR-012
- Execute: CREATE EXTENSION timescaledb;
- Verify: SELECT extname, extversion FROM pg_extension;

**Task 1.2: Create analytics schema**
- Following ADR-012 isolation approach
- Separate from transactional data
- Apply appropriate permissions

**Task 1.3: Design hypertable**
- Table: analytics.metrics
- Columns per ADR-012 requirements
- Partitioning: chunk_time_interval = 1 day

### Phase 2: Data Migration (6 hours)

**Task 2.1: Backfill historical data**
- Migrate from public.analytics_events per ADR-012
- 6 months historical data
- Verify data integrity

**Task 2.2: Implement dual-write**
- Write to both old and new tables
- 1-week validation period per ADR-012
- Monitor for discrepancies

...
```

**Plan references ADR throughout:**

* Specific version numbers from ADR
* Configuration decisions from ADR
* Migration strategy from ADR
* Success criteria aligned with ADR consequences

## Complete Timeline Summary

### Total time: ~25 minutes (excluding implementation)

| Phase           | Duration | Activity                                        |
|-----------------|----------|-------------------------------------------------|
| Research        | 10 min   | Ask Mode exploration of database options        |
| Decision        | 2 min    | Choose approach based on research findings      |
| ADR Creation    | 5 min    | AI-generated draft with context (Ask Mode)      |
| Review & Refine | 3 min    | Verify accuracy, add missing details            |
| Commit          | 2 min    | Add ADR to repository with clear message        |
| Planning        | 3 min    | Create implementation plan referencing ADR      |

**Value created:**

* ✅ Decision documented with full context for future team members
* ✅ Rationale preserved (prevents "why did we do this?" questions)
* ✅ Alternatives recorded (prevents re-litigation of same decision)
* ✅ Implementation plan aligned with documented decision
* ✅ Code reviewers can verify adherence to ADR
* ✅ New team members can understand architecture reasoning

**Effort comparison:**

* Manual ADR creation: Requires gathering context, structuring content, formatting consistently
* AI-assisted ADR creation: AI extracts context from conversation, provides structured draft to refine
* **Value:** Consistent format, reduced cognitive load, comprehensive alternatives captured

**Quality comparison:**

* Manual ADR: Varies by author, often incomplete alternatives
* AI-assisted ADR: Consistent format, comprehensive alternatives from conversation
* **Quality improvement: Higher consistency and completeness**

---

**Previous:** [Advanced ADR Patterns](05-advanced-adr-patterns.md) | **Next:** [Chapter Summary](07-summary.md) | **Up:** [Part II: Core Modes and Workflows](../README.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
