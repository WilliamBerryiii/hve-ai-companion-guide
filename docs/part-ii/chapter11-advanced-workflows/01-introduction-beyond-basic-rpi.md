---
title: "Introduction: Beyond Basic RPI"
description: Understand when basic RPI workflow needs adaptation and preview advanced patterns for complex scenarios
author: HVE Core Team
ms.date: 2025-11-26
ms.topic: concept
chapter: 11
part: "II"
keywords:
  - advanced-rpi
  - workflow-variations
  - complex-scenarios
  - rpi-patterns
---

## Introduction: Beyond Basic RPI

Your journey through Part II began with basic RPI in Chapter 4: Research → Plan → Implement as a straightforward three-phase workflow. Chapters 5-10 expanded each phase with specialized modes that transformed simple steps into powerful capabilities.

Now you're ready to go beyond the basics.

## The Journey So Far

You've built a comprehensive toolkit across six chapters:

**Research phase capabilities:**

* **Ask Mode** provides quick queries for immediate clarity
* **Task Researcher** delivers deep investigation with comprehensive documentation
* **ADR Creator** captures architectural decisions systematically

**Planning phase capabilities:**

* **Task Planner** generates three-document implementation systems
* Plans reference research documents and ADRs for informed decision-making

**Implementation phase capabilities:**

* **Edit Mode** enables controlled, reviewable changes
* **Agent Mode** executes autonomous implementations with built-in validation

**The 80% case:** Basic RPI handles most scenarios effectively. When you have a single feature with clear requirements and straightforward technical decisions, the linear Research → Plan → Implement workflow delivers excellent results using one mode per phase.

## When Basic RPI Isn't Enough

Some scenarios demand more sophisticated approaches. You've likely encountered these situations:

**Uncertain scope** challenges standard RPI when requirements are vague ("make it better"), multiple technical approaches seem viable, and you're not sure what questions to ask yet. You need to explore before you can research effectively.

**Large-scale changes** create risk when refactoring multiple components, introducing breaking changes across the codebase, or facing high probability of subtle bugs. You need validation checkpoints and incremental progress.

**Complex integrations** arise when multiple branches converge, conflict resolution requires deep understanding of both changes, and mistakes could break functionality from either branch.

**Test-driven development** demands a different rhythm when you write tests before implementation, maintain a green test suite throughout development, and refactor with confidence backed by comprehensive coverage.

**Autonomous but guided work** balances speed and control when large implementation tasks benefit from AI autonomy, but specific patterns and constraints must be enforced throughout.

Standard RPI provides the foundation. These complex scenarios require variations that adapt the workflow to match the problem's shape.

## Advanced Patterns Preview

This chapter teaches you to recognize when basic RPI won't suffice and select the right variation for your context.

### RPI Variations (Section 2)

Four proven variation patterns extend basic RPI for different scenarios:

**D-RPI (Discovery-first RPI)** adds an exploration phase before research when working with unfamiliar codebases or vague requirements. You discover what questions to ask before researching answers.

**1→3→All (iterative expansion)** implements changes progressively across one component, then three related components, then the entire system. Early validation catches issues before they spread.

**Edit+RPI** maintains strict control by using Edit Mode throughout implementation instead of autonomous Agent Mode. Every change receives human review before execution.

**Agent+Ask** combines autonomous implementation with strategic guidance by using Ask Mode for clarifying questions while Agent Mode executes the bulk of the work.

### Mode Switching Strategies (Section 3)

Real work rarely stays in a single mode. You'll learn techniques for seamless transitions while preserving context, recovering gracefully when you've chosen the wrong mode, and maintaining momentum through mode changes.

### Complex Workflows (Sections 5-7)

Three comprehensive workflows demonstrate advanced patterns in realistic scenarios:

**Merge conflict resolution** (Section 5) teaches systematic approaches using AI assistance, illustrated with example scenarios showing potential time savings compared to manual resolution.

**Test-driven development with AI** (Section 6) shows how to maintain the Red-Green-Refactor cycle while leveraging AI for both test generation and implementation.

**Large-scale refactoring** (Section 7) demonstrates progressive implementation strategies that keep the system stable while transforming major architectural components.

### Beads Workflow and Task Breakdown (Sections 4, 8-9)

The **Beads workflow** (Section 4) introduces structured task tracking with planning and execution phases, agent handoffs, and explicit acceptance criteria.

**Systematic task breakdown** (Section 8) teaches decomposition methodology for complex features, while the **Beads TDD exercise** (Section 9) provides hands-on practice combining task breakdown with test-driven development.

### Debugging and Recovery (Section 10)

AI suggestions sometimes fail. You'll develop systematic debugging approaches that diagnose why suggestions miss the mark, recover quickly without losing momentum, and learn from failures to improve future collaboration.

### Effectiveness Measurement (Section 11)

Track your growth systematically by identifying productivity improvements, measuring quality indicators that matter, and setting personal effectiveness goals based on data rather than intuition.

### Capstone Project (Section 12)

A comprehensive project integrates everything you've learned. You'll implement a complex feature requiring five or more modes, apply multiple RPI variations, practice strategic mode switching, and demonstrate mastery through reflection.

## Integration of All Modes

The real power emerges when modes work together. Here's how they interact throughout complex workflows:

**Research phase** starts with Ask Mode for quick exploration and initial orientation. Task Researcher provides deep investigation when Ask Mode reveals complexity. ADR Creator documents key technical decisions that will guide implementation.

**Planning phase** uses Task Planner to create implementation plans that reference research documents and ADRs. The three-document system provides enough detail to proceed confidently while remaining flexible.

**Implementation phase** switches between Edit Mode for controlled changes and Agent Mode for autonomous execution. The choice depends on risk tolerance, code familiarity, and time constraints.

**Throughout the workflow** Ask Mode clarifies questions as they arise, while Task Researcher provides deeper investigation when you encounter unexpected blockers.

This chapter teaches you to orchestrate these modes for complex scenarios where basic RPI falls short.

## Chapter Roadmap

Your learning progression builds from patterns to practice:

**Weeks 1-2** (Chapters 5-10) taught individual modes in isolation. Each chapter focused on mastering one capability thoroughly.

**Week 3** (this chapter) integrates modes for production complexity. You'll see how they work together to handle scenarios that single modes can't address.

**Section-by-section structure:**

1. **Introduction** (this section) established context and motivation
2. **RPI Variations** introduces four proven patterns for different scenarios
3. **Mode Switching** teaches seamless transitions between modes
4. **Beads Workflow Fundamentals** introduces structured task tracking with planning and execution phases
5. **Merge Conflicts** demonstrates systematic resolution workflows
6. **TDD with AI** applies the Red-Green-Refactor cycle with AI assistance
7. **Large Refactoring** shows safe, progressive implementation strategies
8. **Systematic Task Breakdown** teaches decomposition methodology for complex features
9. **Beads TDD Exercise** applies breakdown and Beads workflow hands-on
10. **Debugging** provides recovery strategies when AI suggestions fail
11. **Measurement** establishes frameworks for tracking effectiveness
12. **Capstone** integrates all patterns in a complex project
13. **Summary** reflects on mastery and previews Part III

**Time investment:** Budget 60-80 minutes for reading and concept absorption, plus 45-60 minutes for the capstone project. This is Part II's most intensive chapter because it synthesizes everything you've learned into practical workflows.

> [!IMPORTANT]
> Before proceeding, verify you've completed Chapters 5-10. This capstone chapter assumes proficiency with Ask, Task Researcher, Task Planner, Edit, Agent, and ADR Creator modes. Review earlier chapters if needed.

Ready to move beyond basic RPI? Section 2 introduces your first variation: D-RPI (Discovery-first RPI) for handling uncertain scope and unfamiliar codebases.

---

**Previous:** [Chapter 11 Overview](README.md) | **Next:** [RPI Variations Overview](02-rpi-variations-overview.md)
