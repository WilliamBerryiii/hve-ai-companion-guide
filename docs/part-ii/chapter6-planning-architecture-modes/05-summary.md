---
title: Chapter summary and next steps
description: Consolidate Task Researcher mastery through complex research scenario and preview transition to planning phase
author: HVE Core Team
ms.date: 2025-11-19
chapter: 6
part: "II"
section: 5
type: content-section
parent: chapter6-planning-architecture-modes
prerequisites:
  - Completed Section 4 - Evidence gathering techniques
  - Practice with research documents
estimated_reading_time: 45
keywords:
  - chapter summary
  - deep dive exercise
  - research mastery
  - planning transition
---

You've learned to conduct deep research with Task Researcher mode, create evidence-based research documents, and gather findings from internal codebases and external documentation through systematic triangulation.

## What you've learned

This chapter equipped you with the skills to conduct research that prevents hallucination and builds team confidence through evidence-backed recommendations.

**Research escalation and scope:** You recognize when Ask Mode reaches its limits and Task Researcher becomes necessary. Complex integrations, brownfield codebases, and architectural decisions require 20-60 minute research sessions with structured documentation. You define clear research scope to prevent infinite exploration while ensuring thorough coverage.

**Research document creation:** You know how to create research documents following the standard template with Task Implementation Requests, Scope, Evidence Log, Key Discoveries, and Technical Scenarios sections. Each section serves a specific purpose: requests establish the task, scope sets boundaries, evidence provides citations, discoveries synthesize findings, and scenarios demonstrate real implementations.

**Evidence gathering from codebases:** You use five tools to extract evidence systematically from internal code. File search locates files by pattern, grep search finds code patterns across files, semantic search discovers concepts without exact keywords, read file examines complete implementations with context, and list code usages traces function calls throughout the codebase. Each tool has specific strengths for different research questions.

**External documentation research:** You leverage MCP tools to consult authoritative sources. Context7 provides access to SDK and API documentation from official sources. Web fetch retrieves content from documentation sites, GitHub READMEs, and RFC specifications. You cite sources with access dates to enable future verification of your research.

**Triangulation and completeness:** You verify findings through multiple independent sources before making recommendations. Three-source verification combines internal code, official documentation, and community practice. You resolve conflicts using an authority hierarchy and assess research completeness through seven questions that confirm you have sufficient evidence to proceed.

**MCP integration in practice:** You understand how Model Context Protocol tools expand Copilot's capabilities beyond the workspace. Task Researcher automatically invokes these tools during research sessions, giving you access to documentation, SDKs, and external resources without leaving your workflow. This integration makes deep research practical within time-boxed sessions.

## Key takeaways

Remember these essential insights as you conduct Task Researcher sessions:

1. **Research prevents hallucination.** Structured documentation with citations creates verifiable findings that teams can trust. Claims without evidence are speculation; claims with line numbers and URLs are facts.

2. **Time-boxing maintains momentum.** Research can expand infinitely; set 20-60 minute limits and use completeness criteria to know when you've gathered enough evidence to move forward with confidence.

3. **Triangulation builds confidence.** Single-source findings are prone to error. When internal code, official documentation, and community practice all agree, you have solid ground for recommendations.

4. **Document conflicts, not just conclusions.** When sources disagree, explaining why and how you resolved the conflict prevents future confusion and demonstrates thorough analysis.

5. **Research documents are communication artifacts.** Your research document enables reviewers to verify your findings, provides context for future maintainers, and creates a knowledge base for similar decisions.

6. **MCP tools are research accelerators.** Context7 and web fetch eliminate the context-switching cost of consulting external documentation. You gather evidence from authoritative sources while maintaining citation quality.

7. **Completeness has objective criteria.** You don't guess when research is sufficient; you answer seven specific questions that confirm you can explain decisions, articulate trade-offs, and cite every claim.

8. **Evidence organization matters.** Group findings by source type (internal vs external), maintain chronological logs, and structure discoveries around implementation needs. Future readers should find information quickly.

Ready to synthesize these skills in a realistic complex scenario? The deep dive exercise challenges you to conduct complete research for an architectural decision with multiple approaches and real trade-offs.

## Deep Dive Exercise 6.3: Complex research scenario

**Objective:** Conduct complete research and produce a publication-ready research document for a complex architectural decision involving unfamiliar APIs, multiple approaches, and significant trade-offs.

**Time:** 30-45 minutes

**Scenario:** Your team needs to add rate limiting to your Express.js REST API to prevent abuse and ensure fair resource usage. The application currently has no rate limiting. You need to research approaches, evaluate alternatives, understand configuration trade-offs, and provide a research document that enables your team to implement the solution confidently.

**Research requirements:**

* Identify at least 3 viable rate limiting approaches for Express.js
* Understand configuration parameters (window size, max requests, storage backends)
* Evaluate trade-offs between in-memory and distributed rate limiting
* Document Redis integration if distributed rate limiting is needed
* Research industry standards for rate limiting (RFCs, best practices)
* Consider monitoring and logging requirements
* Assess impact on existing middleware and route structure

**Instructions:**

1. **Define research scope** (2-3 minutes)
   * Write Task Implementation Requests section describing the rate limiting feature
   * Define what's in scope (implementation approaches, configuration, infrastructure)
   * Define what's out of scope (frontend changes, billing integration, user notifications)
   * Set success criteria for the research

2. **Explore internal codebase** (8-12 minutes)
   * Search for existing rate limiting or throttling patterns
   * Identify middleware structure and where rate limiting would integrate
   * Find configuration patterns (environment variables, config files)
   * Examine error handling patterns for 429 responses
   * Document relevant files with line numbers

3. **Research external documentation** (10-15 minutes)
   * Use Context7 or web fetch to research `express-rate-limit` library
   * Investigate Redis rate limiting options (`rate-limit-redis`, `ioredis`)
   * Consult RFC 6585 Section 4 (429 Too Many Requests status code)
   * Review industry recommendations (OWASP API Security, REST API guidelines)
   * Capture all citations with access dates

4. **Identify and evaluate alternatives** (5-8 minutes)
   * Document at least 3 approaches: in-memory rate limiting, Redis-backed rate limiting, API gateway rate limiting
   * List pros/cons for each approach
   * Identify configuration parameters and their implications
   * Consider scaling requirements and current infrastructure

5. **Triangulate findings** (3-5 minutes)
   * Verify recommendations across internal patterns, library documentation, and industry standards
   * Document any conflicts between sources and how you resolved them
   * Apply authority hierarchy when sources disagree

6. **Create technical scenarios** (5-8 minutes)
   * Write code examples showing rate limiter configuration
   * Show Redis integration if applicable
   * Document error handling for rate limit exceeded scenarios
   * Include monitoring/logging setup

7. **Assess completeness** (2-3 minutes)
   * Answer all seven completeness criteria questions
   * Verify every claim has a citation
   * Confirm you can explain the decision to someone unfamiliar with the project

8. **Structure final research document** (3-5 minutes)
   * Organize findings into standard template sections
   * Write Key Discoveries synthesis
   * Include clear recommendation with supporting evidence

**Success criteria:**

You've completed the exercise successfully when your research document includes:

* ✅ Task Implementation Requests with clear scope boundaries
* ✅ Evidence Log with internal codebase findings (file paths, line numbers)
* ✅ Evidence Log with external research (library docs, RFCs, best practices with URLs and access dates)
* ✅ At least 3 alternative approaches documented with trade-offs
* ✅ Key Discoveries section synthesizing findings into clear recommendation
* ✅ Technical Scenarios with code examples for implementation
* ✅ All seven completeness criteria questions answered positively
* ✅ Triangulation performed across internal, official, and community sources
* ✅ Conflicts documented and resolved using authority hierarchy
* ✅ Document ready for team review without additional research

**Validation checklist:**

Review your completed research document:

* [ ] Every technical claim has a citation (file path with line numbers OR URL with access date)
* [ ] At least 3 alternative approaches identified and evaluated
* [ ] Recommendation clearly stated with supporting evidence from multiple sources
* [ ] Code examples are complete and copy-pasteable
* [ ] Configuration parameters explained with their implications
* [ ] Trade-offs articulated for each approach
* [ ] Infrastructure requirements documented (Redis setup if needed)
* [ ] Error handling and monitoring considerations included
* [ ] All template sections completed (no "TODO" or "[Content here]" placeholders)
* [ ] Document is readable by someone unfamiliar with the project

**Extension challenge (optional):** Share your research document with a colleague and ask them to implement the solution using only your document as guidance. Their questions reveal gaps in your research or documentation.

## What's next

Research produces findings; planning produces actionable steps. Chapter 7 introduces Task Planner mode, which transforms research insights into implementation plans with task breakdowns, acceptance criteria, and dependency tracking.

Task Planner operates in the 15-30 minute range between Task Researcher's deep investigation and Agent Mode's autonomous implementation. You provide research context (often from Task Researcher documents), and Task Planner generates structured plans that engineers can execute systematically. The mode excels at breaking complex features into manageable tasks, identifying dependencies, and defining testable acceptance criteria.

You'll learn to create implementation plans that bridge research findings to actual code. When Task Researcher tells you "use express-rate-limit with Redis backend", Task Planner tells you exactly which files to modify, what configuration to add, how to test the changes, and what order to implement tasks to avoid breaking existing functionality.

The combination of Task Researcher and Task Planner forms a complete discovery and planning workflow: research first to understand options and gather evidence, then plan to define implementation steps with dependencies and validation. Together they enable high-confidence execution without hallucination or architectural surprises.

## Related resources

* **Chapter 3: RPI Framework Fundamentals** - Review the Research phase principles that guide Task Researcher methodology
* **Chapter 5: Ask Mode Quick Discovery** - Refresh quick research patterns and understand when to escalate to Task Researcher
* **Chapter 7: Task Planner - Actionable Implementation Plans** - Continue to planning phase with implementation task breakdowns
* **Appendix A: RPI Reference Guide** - Complete reference for Research phase with troubleshooting tips
* **Appendix B: Chat Modes Quick Reference** - Task Researcher mode capabilities and comparison with other modes

---

**Previous:** [Evidence gathering techniques](./04-evidence-gathering-techniques.md) | **Next:** [Chapter 7 - Task Planner](../../part-ii/chapter7-implementation-modes/README.md) | **Up:** [Chapter 6 - Task Researcher](./README.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
