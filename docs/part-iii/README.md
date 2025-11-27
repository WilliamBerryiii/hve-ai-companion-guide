---
title: "Part III: Advanced Prompting"
description: Master advanced prompting techniques using Edge-AI patterns - from instruction files to custom agents, meta-prompting, and three-tier architecture
author: HVE Core Team
ms.date: 2025-11-23
keywords:
  - advanced-prompting
  - instruction-files
  - custom-agents
  - meta-prompting
  - three-tier-architecture
  - edge-ai-patterns
---

> [!IMPORTANT]
> Part III teaches advanced capabilities that are currently in preview status. Custom agents require VS Code 1.106+, and prompt files are in public preview for VS Code and JetBrains IDEs. These features affect only chat responses, not inline code suggestions.

## What You'll Learn in Part III

Part III advances your AI engineering capabilities through sophisticated prompting techniques drawn from microsoft/edge-ai patterns. You'll learn to structure workspace-aware instructions, create specialized agents with handoff workflows, and apply meta-prompting for continuous improvement. This part bridges the gap between foundational RPI workflows and professional-scale automation.

**Core Skills:**

* **Instruction File Proficiency:** Create reusable `.instructions.md` and `.prompt.md` files with variable substitution and automatic context application through `applyTo` patterns
* **Advanced Pattern Design:** Build technology-specific instruction sets using glob patterns and layering strategies for complex multi-file workflows
* **Custom Agent Development:** Design specialized agents with tool restrictions, implement agent handoff workflows, and coordinate multi-agent systems using the Beads framework
* **Meta-Prompting Techniques:** Use `prompt-new` and `prompt-refactor` to analyze patterns, optimize prompts, and validate against professional standards
* **Three-Tier Architecture:** Integrate prompts, instructions, and chat modes into cohesive workflows for CI/CD pipelines and team adoption

The patterns you'll learn in Part III enable sophisticated AI-assisted development workflows used in production engineering environments. These techniques represent the current state of the art in AI tooling, with capabilities continuing to evolve as GitHub Copilot and VS Code mature.

## Prerequisites

Before starting Part III, you should:

* Complete Part I (Chapters 1-4) to understand RPI fundamentals and basic chat mode usage
* Complete Part II (Chapters 5-11) to achieve proficiency with all five core chat modes and advanced workflows
* Have a working development environment with hve-core installed and configured
* Be comfortable with GitHub Copilot Chat and basic prompt engineering concepts
* Understand context management strategies and token budgets from previous chapters

Part III assumes you can effectively use Ask, Task Researcher, Task Planner, Edit, and Agent modes for standard development tasks. The advanced techniques taught here build directly on those foundations.

## Chapters in Part III

### Chapter 12: Prompt Files and Instructions Basics

**Time:** 45-60 minutes | **Level:** Moderate

Learn the foundation of workspace-aware instructions. Use `prompt-builder` to create instruction files, understand `.prompt.md` and `.instructions.md` formats, implement variable substitution patterns, and leverage the `applyTo` field for automatic context application. Hands-on exercises guide you through creating your first instruction file and testing it across your workspace.

[Start Chapter 12](./chapter12-prompt-files-basics/README.md)

### Chapter 13: Advanced Instruction Patterns

**Time:** 60-75 minutes | **Level:** Advanced

Deepen your pattern expertise with sophisticated `applyTo` glob patterns and technology-specific instruction files. Master automatic versus manual context application, create layered instructions for complex workflows, and build reusable patterns for Terraform, Bicep, Shell, and Python projects. Build a complete technology-specific instruction set through guided exercises.

[Start Chapter 13](./chapter13-instruction-patterns/README.md)

### Chapter 14: Custom Agents and Chat Modes

**Time:** 75-90 minutes | **Level:** Advanced

Design specialized agents beyond the five built-in modes. Understand agent capabilities and limitations, implement handoff workflows with pre-filled prompts, apply tool restriction patterns for security, and coordinate multi-agent systems using the Beads framework. Create a custom agent with complete handoff workflow for your domain.

[Start Chapter 14](./chapter14-custom-agents/README.md)

### Chapter 15: Meta-Prompting and Prompt Engineering

**Time:** 60-75 minutes | **Level:** Advanced

Apply meta-prompting for continuous improvement. Use `prompt-new` to analyze code patterns and generate prompts, leverage `prompt-refactor` to optimize existing prompts, master prompt composition and layering strategies, and validate against professional patterns. Create and refine domain-specific prompts through iterative exercises.

[Start Chapter 15](./chapter15-meta-prompting/README.md)

### Chapter 16: Advanced Agent Architecture

**Time:** 90-120 minutes | **Level:** Expert

Integrate all techniques into professional workflows. Understand the three-tier architecture (Prompts → Instructions → Chat Modes), compose workflows for Planning → Implementation → Validation cycles, implement context management strategies, and integrate with CI/CD pipelines. Analyze the Edge-AI project structure as a real-world case study and complete a capstone integration exercise.

[Start Chapter 16](./chapter16-advanced-architecture/README.md)

## Estimated Time

**Total:** 5.5-7 hours across five chapters

Part III requires hands-on practice and experimentation. Each chapter builds progressively, so working through them sequentially yields the best results. Budget additional time for adapting patterns to your specific projects and exploring edge cases.

## Reading Path Guidance

**Sequential Learning Path** (Recommended):
Work through Chapters 12-16 in order. Each chapter introduces concepts that subsequent chapters extend and combine.

**Selective Learning Path**:
If you need specific capabilities immediately:

* **Instruction files only:** Chapters 12-13
* **Custom agents only:** Chapter 14 (requires understanding of instruction files from Chapter 12)
* **Meta-prompting only:** Chapter 15 (benefits from Chapters 12-13 for pattern extraction)
* **Architecture integration:** Chapter 16 (requires all previous chapters)

**Preview Feature Considerations**:
Some capabilities require specific tool versions:

* Custom agents require VS Code 1.106+ (preview feature)
* Prompt files require VS Code or JetBrains IDEs (public preview)
* All features affect only chat responses, not inline code suggestions

## Next Steps: Part IV Organizational Scaling

After completing Part III, you'll have learned advanced prompting patterns including prompt files, custom agents, meta-prompting, and architectural integration.

Part IV demonstrates how to apply these advanced techniques across different engineering roles and scale HVE practices to entire organizations. You'll see how development teams use custom agents for full-stack AI assistance, how program managers leverage advanced workflows for technical depth, and how to implement organizational adoption frameworks with measurement systems.

The advanced patterns you learn in Part III become essential tools for the organizational-scale applications covered in Part IV, particularly custom agent repositories for team-wide workflow standards and governance models for prompt file management.

[Continue to Part IV](../part-iv/README.md)

## Get Started

Ready to advance your prompting expertise? Begin with [Chapter 12: Prompt Files and Instructions Basics](./chapter12-prompt-files-basics/README.md) to learn the foundation of workspace-aware instructions.

If you need to review core concepts first, return to [Part II: Deep Dive into Practice](../part-ii/README.md) to solidify your proficiency with standard chat modes and workflows.

---

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
