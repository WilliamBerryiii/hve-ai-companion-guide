# Section 1: Chapter Introduction & Setup Philosophy

You've assessed your codebase's readiness in Chapter 1. Now it's time to build the toolkit that transforms those engineering fundamentals into systematic, evidence-based workflows.

This chapter takes you from assessment to action. You'll install three essential layers—GitHub Copilot for AI assistance, hve-core framework for specialized modes, and optional enhancements for research—then verify everything works through hands-on testing. By the end, you'll have a complete development environment ready for Chapter 3's RPI methodology.

## The Foundation Layer

Chapter 1 prepared you with engineering fundamentals: version control, testing mindset, code readability, and documentation discipline. These fundamentals ensure your codebase is **AI-ready**—structured for effective AI assistance.

**Chapter 2 builds the tools layer** on top of those fundamentals:

* ✅ **hve-core framework** - Provides research/planning/implementation modes
* ✅ **GitHub Copilot** - Core AI assistance engine
* ✅ **VS Code configuration** - Optimized development environment
* ✅ **Chat modes** - Specialized AI modes for different tasks
* ✅ **MCP servers** (optional) - Enhanced research capabilities

**Why this order matters:**

1. **Chapter 1**: Prepared codebase for AI (tests, git, linting, docs)
2. **Chapter 2**: Install AI tools configured for your prepared codebase
3. **Chapter 3+**: Apply AI tools to engineering workflows with confidence

> [!NOTE]
> **Building on solid ground.** The engineering fundamentals from Chapter 1 aren't just "nice to have"—they create the discoverable artifacts that make AI assistance reliable. Tests document behavior, linting defines conventions, documentation captures decisions, and Git tracks evolution. Without these, even the best AI tools produce inconsistent results.

## What Makes HVE Different

If you've used GitHub Copilot before, you might recognize this pattern: you type a function signature, Copilot suggests an implementation, and you accept or reject it. That's helpful—but it's just scratching the surface of what AI can do for your development workflow. The specialized modes you'll configure in this chapter transform Copilot from a reactive suggestion tool into a proactive engineering partner.

Many developers use GitHub Copilot for basic code completion. The **Hypervelocity Engineering (HVE) approach** is different:

**Traditional Copilot Use:**

```text
Developer writes function signature → Copilot suggests implementation → Accept/reject
```

**HVE Approach:**

```text
Research Phase (Task Researcher) → Evidence-based findings documented
↓
Planning Phase (Task Planner) → Implementation strategy with verification steps
↓
Implementation Phase (Edit/Agent Mode) → Execution with validation checkpoints
```

**Why HVE prevents hallucination:**

* **Research before implementation**: Gather evidence first, generate code second
* **Specialized modes**: Different AI modes optimized for different tasks
* **Verification built in**: Each phase validates outputs before proceeding

The **hve-core framework** provides these specialized modes through VS Code extensions and chat mode configuration.

## Installation Overview: Three Layers

**Layer 1: Core Prerequisites** (15-20 min)

* Visual Studio Code (latest stable)
* Node.js (LTS version 18.x or 20.x)
* Git (2.40+)
* GitHub account with Copilot subscription

**Layer 2: HVE Core Framework** (10-15 min)

* Clone hve-core repository
* Install npm dependencies
* Configure VS Code workspace settings
* Verify chat modes available

**Layer 3: Optional Enhancements** (10-15 min)

* MCP server for SDK research (Context7)
* Additional VS Code extensions (GitLens, REST Client, etc.)
* Keybinding customizations

**Total setup time: 35-50 minutes** (including verification)

> [!NOTE]
> **Installation is iterative, not blocking.** You can start using basic HVE workflows after Layer 1+2 (25-35 min), then add Layer 3 enhancements as needed.

## What This Chapter Covers vs. Chapter 1

**Chapter 1 (Engineering-Ready State):**

* ❌ Did NOT install tools
* ✅ Validated your existing project/environment readiness
* ✅ Taught fundamentals: tests, git, linting, documentation

**Chapter 2 (Tool Installation):**

* ✅ INSTALLS hve-core, Copilot, extensions
* ✅ Configures VS Code for HVE workflows
* ✅ Verifies installation with systematic tests
* ❌ Does NOT teach how to use modes (that's Chapter 3-9)

**If you're an experienced user:** You might have VS Code and Copilot already installed. This chapter ensures you have the **HVE-specific configuration** that enables research, planning, and specialized modes.

---

**Previous:** [Chapter 2 Overview](README.md) | **Next:** [GitHub Copilot Subscription & Installation](02-copilot-subscription.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
