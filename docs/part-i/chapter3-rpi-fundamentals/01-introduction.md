---
title: "Section 1: Introduction to the RPI Method"
description: Understand the hallucination problem and why the Research-Plan-Implement methodology is essential for AI-assisted development
author: HVE Core Team
ms.date: 2025-11-26
chapter: 3
part: I
keywords:
  - rpi-method
  - hallucination
  - ai-assisted-development
  - evidence-based
---

You've probably experienced this moment: AI generates code that looks perfect—clean, professional, exactly what you asked for. Then you run it and nothing works.

This isn't a failure of intelligence or skill. It's a fundamental characteristic of how AI systems operate. AI tools like GitHub Copilot are incredibly powerful, but they have a critical weakness: **hallucination**. Without proper constraints and evidence, AI will confidently generate plausible-sounding but incorrect code. It may suggest non-existent APIs or invent configuration options that don't exist.

This chapter introduces the methodology that prevents those frustrating debugging sessions. The Research → Plan → Implement (RPI) method reduces hallucination through systematic evidence gathering and validation. You'll learn the "why" behind each phase and build the foundation for executing complete RPI cycles throughout this guide.

In Chapter 1, you learned that AI works best with codebases that have strong engineering fundamentals—tests, documentation, and consistent structure. RPI is how you leverage those fundamentals. During research, tests and docs become evidence sources. During implementation, linting and type systems catch errors early.

## The hallucination problem

Consider this scenario: A developer asks Copilot to "add authentication to Express app". Copilot suggests using `passport-azure-ad` with a specific version and configuration that looks perfect—clean code, sensible options, professional structure.

The problem? The suggested version doesn't exist yet, or the configuration format comes from an incompatible version. What seemed like a straightforward 15-minute task becomes hours of debugging cryptic errors and version conflicts.

This isn't a rare edge case. AI hallucination happens frequently when you ask it to generate code without providing evidence about how things actually work. The AI fills gaps in its knowledge with plausible-sounding but incorrect information. AI states incorrect information with the same certainty as correct information—there's no built-in confidence indicator you can trust.

If you've used AI assistance before, you might recognize this pattern: the code looks professional, follows good conventions, and seems to do exactly what you asked—until you try to run it.

**Common hallucination patterns:**

* **Invented APIs**: Method names that follow patterns but don't exist
* **Wrong versions**: Features from future releases or deprecated APIs
* **Plausible configuration**: Options that sound right but aren't valid
* **Mixed patterns**: Combining incompatible frameworks or approaches

The traditional response to this problem is "just validate everything AI suggests". But that's exhausting and error-prone. You need a systematic approach that reduces hallucination risk significantly through evidence-based constraints.

## The RPI solution

The Research → Plan → Implement (RPI) method reduces hallucination through **type transformation**—systematically converting uncertainty into knowledge, knowledge into plans, and plans into working code.

Instead of asking AI to generate code directly, you guide it through three distinct phases:

**1. Research** - Gather evidence about how things actually work (not how AI thinks they work)

In this phase, you collect verified information from authoritative sources: official documentation, working code in your codebase, reputable open-source examples. You document findings with source citations so you can validate AI suggestions against real evidence.

**2. Plan** - Create implementation strategy grounded in research findings

With research complete, you build a step-by-step plan that references specific research findings. Each step includes rationale tied to evidence, validation criteria, and anticipated issues. The plan becomes a blueprint that constrains AI outputs.

**3. Implement** - Execute the plan with AI assistance, validating against research

Now you can safely use AI to generate code because it follows a plan grounded in verified research. You validate each step against research examples, run tests frequently, and catch any remaining hallucinations quickly before they compound.

RPI is about containment and early detection, not elimination. You'll learn strategies that catch hallucinations before they propagate through your codebase.

## How this chapter works

This chapter teaches the RPI methodology through progressive concepts and practical application:

**Sections 2-3** explain the core concepts: what RPI is, why type transformation matters, and how to think about AI as a transformer rather than an oracle.

**Sections 4-5** dive into evidence-based decision making and anti-hallucination strategies you'll use throughout RPI workflows.

**Section 6** helps you calibrate time investment based on task novelty and risk.

**Section 7** provides a complete hands-on exercise where you execute your first RPI cycle on a small refactoring task.

By the end of this chapter, you'll understand not just the mechanics of RPI but the underlying principles that make it effective. You'll develop the mindset needed to work productively with AI while maintaining engineering rigor.

> [!NOTE]
> **Accessing chat modes:** Throughout this chapter, you'll use different chat modes. Native modes (Ask, Edit, Agent) appear in VS Code's Copilot Chat by default. Custom hve-core modes (Task Researcher, Task Planner) are accessible via the agent picker dropdown in the chat panel. See [Chapter 2, Section 4](../chapter2-setup-environment/04-chat-modes-configuration.md) for setup instructions.

The remaining chapters in Part I build on RPI fundamentals. Chapter 4 demonstrates the framework through a complete workflow example, applying everything you learn here to a real-world scenario.

Now that you understand why hallucination happens and what RPI is designed to prevent, let's look at how the methodology actually works—the three phases that transform uncertainty into reliable code.

---

**Navigation:**

* **Previous:** [Chapter 3 - Overview](./README.md)
* **Next:** [Section 2 - What is RPI?](./02-what-is-rpi.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
