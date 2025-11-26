# Section 2: GitHub Copilot Subscription & Installation

You're ready to install the AI engine that powers hypervelocity engineering. GitHub Copilot (as of November 2024) provides the foundation for all HVE workflows—from research to planning to implementation. This section guides you through subscription verification, extension installation, and configuration for optimal performance.

## Copilot Subscription Tiers

GitHub Copilot comes in three tiers (as of November 2024). Understanding differences helps you choose appropriately. For current pricing, see [GitHub Copilot Pricing](https://github.com/features/copilot#pricing).

**Copilot Individual** ($10/month or $100/year)

* ✅ Code completions in editor
* ✅ Chat in VS Code sidebar
* ✅ Access to all chat modes (Ask, Task Researcher, Task Planner, Edit, Agent)
* ✅ Sufficient for HVE workflows
* ❌ No admin controls
* ❌ Individual license only

**Copilot Business** ($19/user/month)

* ✅ Everything in Individual
* ✅ Organization-wide license management
* ✅ Policy controls (public code blocking)
* ✅ Audit logs
* ✅ Ideal for teams using HVE

**Copilot Enterprise** ($39/user/month)

* ✅ Everything in Business
* ✅ Chat in GitHub.com (not just VS Code)
* ✅ Pull request summaries
* ✅ Custom fine-tuned models (organization-specific)
* ⚠️ Advanced features beyond core HVE needs

**Which tier for HVE?**

* **Individual developers**: Copilot Individual (sufficient)
* **Teams/organizations**: Copilot Business (recommended)
* **Large enterprises**: Copilot Enterprise (if budget allows)

> [!IMPORTANT]
> **Free Copilot for students/educators**: If you're a student or educator, you may qualify for free Copilot Individual. Check [GitHub Education](https://education.github.com/pack) for eligibility.

## Verifying Copilot Subscription

Before installing extensions, verify your Copilot access.

### Step 1: Check GitHub Copilot status

To verify your Copilot subscription, follow these steps:

1. Log into GitHub.com.
2. Navigate to Settings → Copilot.
3. Verify "GitHub Copilot is active" message appears.

### Step 2: Verify billing (if using Individual/Business)

To confirm your subscription is active, follow these steps:

1. In GitHub Settings, navigate to Billing → Plans and usage.
2. Confirm "GitHub Copilot" appears in active subscriptions.

**If Copilot is not active:**

* **Individual**: Subscribe at <https://github.com/features/copilot>
* **Business**: Contact your organization admin for license assignment
* **Student/Educator**: Apply for GitHub Education benefits

> [!TIP]
> **30-day free trial available.** If you don't have Copilot yet, start the free trial to complete this book. You can evaluate HVE workflows risk-free before committing to paid subscription.

## Installing GitHub Copilot in VS Code

Now that you've verified your subscription, install the required extensions.

### Step 1: Install GitHub Copilot Extension

To install the GitHub Copilot extension, follow these steps:

1. Open VS Code.
2. Open Extensions view (`Ctrl+Shift+X` or `Cmd+Shift+X`).
3. Search: `GitHub Copilot`
4. Click **Install** on the official "GitHub Copilot" extension (published by GitHub).
5. Wait for installation to complete.

### Step 2: Install GitHub Copilot Chat Extension

To install the chat extension, follow these steps:

1. In Extensions view, search: `GitHub Copilot Chat`
2. Click **Install** on "GitHub Copilot Chat" extension (published by GitHub).
3. Wait for installation to complete.

> [!IMPORTANT]
> **Two extensions required**: You need BOTH "GitHub Copilot" (inline suggestions) AND "GitHub Copilot Chat" (chat modes). HVE workflows primarily use the Chat extension for research, planning, and agent modes.

### Step 3: Authenticate with GitHub

After installing both extensions, complete authentication.

To authenticate VS Code with your GitHub account, follow these steps:

1. VS Code will prompt: "Sign in to use GitHub Copilot"
2. Click **Sign in to GitHub**.
3. Browser opens → Authorize VS Code to access GitHub.
4. Return to VS Code → Authentication complete.

### Step 4: Verify Installation

To verify Copilot is working correctly, follow these steps:

1. Open VS Code Command Palette (`Ctrl+Shift+P` or `Cmd+Shift+P`).
2. Type: `GitHub Copilot: Enable`
3. If you see "GitHub Copilot is enabled", installation succeeded.

**Alternative verification:**

1. Open any code file (`.js`, `.py`, `.ts`, etc.).
2. Start typing a function.
3. Copilot suggestion should appear in gray text (inline completion).

**Troubleshooting Authentication:**

If authentication fails:

* Check GitHub.com → Settings → Copilot shows "Active"
* Restart VS Code after authentication
* Try manual token auth: Command Palette → `GitHub Copilot: Sign in with GitHub Token`

## Chat Sidebar vs Inline Chat

GitHub Copilot in VS Code provides two chat interfaces:

**Chat Sidebar** (Primary HVE Interface)

* Access: Click Copilot icon in Activity Bar (left sidebar)
* Keyboard: `Ctrl+Alt+I` (Windows/Linux) or `Cmd+Shift+I` (Mac)
* Use for: Research, planning, exploratory questions
* Persistent: Chat history remains across sessions

**Inline Chat** (Quick Edits)

* Access: `Ctrl+I` (Windows/Linux) or `Cmd+I` (Mac) while in editor
* Use for: Quick code changes, refactoring current selection
* Ephemeral: Chat disappears after task

**For HVE workflows, you'll primarily use the Chat Sidebar** to access Task Researcher, Task Planner, and Ask modes.

## Configuring Copilot Settings

Optimize Copilot settings for HVE workflows.

To configure Copilot, follow these steps:

1. Open Settings (File → Preferences → Settings or `Ctrl+,`).
2. Search for "copilot".
3. Configure the following settings.

**Essential Settings:**

* ✅ `github.copilot.enable`: `true` (Enable Copilot)
* ✅ `github.copilot.inlineSuggest.enable`: `true` (Inline suggestions)
* ✅ `github.copilot.chat.followUps`: `true` (Enable follow-up questions)

**Optional but Recommended:**

* `github.copilot.advanced.debug`: `false` (Unless debugging Copilot)
* `github.copilot.editor.enableAutoCompletions`: `true` (Faster completions)

**Settings to review with your team:**

* `github.copilot.chat.useProjectFiles`: `true` (Allows Copilot to read workspace files - essential for HVE research)

> [!WARNING]
> **Public code blocking**: If your organization has policies against using public code, ensure your admin configures `github.copilot.advanced.allow_code_from_public_repositories`: `false` in organization settings.

## Copilot Installed ✅

You've successfully installed and authenticated GitHub Copilot. Take a moment to appreciate this: you now have a powerful AI assistant integrated into your development environment. The inline suggestions you'll see as you code are just the beginning.

Next, you'll install the hve-core framework that unlocks Copilot's full potential through specialized chat modes.

---

**Previous:** [Introduction: Chapter Introduction & Setup Philosophy](01-introduction.md) | **Next:** [HVE-Core Framework Installation](03-hve-core-installation.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
