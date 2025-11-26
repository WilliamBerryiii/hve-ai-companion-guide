# HVE-Core Framework Installation

With Copilot configured, you're ready for the core of HVE: the **hve-core framework**. This framework transforms Copilot from a code completion tool into a structured engineering partner.

This section walks you through installing hve-core, configuring it for your projects, and verifying everything works. By the end, you'll have the foundation for Research → Plan → Implement workflows.

## What is hve-core?

The **hve-core framework** provides:

* **Chat mode templates** - Pre-configured prompts for Task Researcher, Task Planner, Ask Mode
* **Workflow scripts** - Automation for research/planning document creation
* **VS Code snippets** - Code templates following HVE patterns
* **Configuration presets** - Workspace settings optimized for HVE

**Why you need hve-core:**
Without it, you'd need to manually craft prompts for each mode every time. HVE-core provides the scaffolding so you can focus on engineering, not prompt engineering.

## Prerequisites Verification

Before installing hve-core, verify prerequisites:

### Node.js (Required)

```bash
node --version
# Expected: v18.x.x or v20.x.x (LTS versions)
```

If Node.js not installed or version < 18:

* Download from: <https://nodejs.org/en/download/>
* Install LTS (Long Term Support) version
* Restart terminal after installation

### Git (Required)

```bash
git --version
# Expected: git version 2.40 or higher
```

If Git not installed:

* Windows: <https://git-scm.com/download/win>
* Mac: `brew install git` (if Homebrew installed) or download from git-scm.com
* Linux: `sudo apt-get install git` (Debian/Ubuntu) or equivalent

### VS Code (Required)

```bash
code --version
# Expected: 1.85.x or higher
```

If VS Code not installed:

* Download from: <https://code.visualstudio.com/>
* Install stable release (not Insiders unless you know why)

## Cloning the hve-core Repository

### Step 1: Choose installation location

Create a directory for development tools (if you don't have one):

```bash
# Windows (PowerShell)
mkdir $HOME\dev\tools
cd $HOME\dev\tools

# Mac/Linux
mkdir -p ~/dev/tools
cd ~/dev/tools
```

### Step 2: Clone hve-core repository

```bash
git clone https://github.com/WilliamBerryiii/hve-core.git
cd hve-core
```

> [!NOTE]
> **Repository location**: The URL above is illustrative. Check the official HVE documentation for the canonical repository URL.

### Step 3: Verify clone succeeded

```bash
ls -la
# Expected: Should see:
# - package.json
# - src/
# - templates/
# - .vscode/
# - README.md
```

## Installing hve-core Dependencies

### Step 1: Install npm packages

```bash
npm install
```

**Expected output:**

```text
added 127 packages, and audited 128 packages in 15s
found 0 vulnerabilities
```

**If you see vulnerabilities:**

Don't panic if npm reports vulnerabilities during installation. Security warnings can feel alarming, but most are in development dependencies and don't affect your production code. Here's how to address them:

```bash
npm audit
npm audit fix
```

### Step 2: Verify installation

```bash
npm run verify
```

This command checks:

* ✅ All required dependencies installed
* ✅ VS Code workspace configuration valid
* ✅ Template files present and parseable
* ✅ Chat mode definitions loadable

**Expected output:**

```text
✓ Dependencies verified
✓ Workspace configuration valid
✓ Templates verified (5 found)
✓ Chat modes verified (5 found)

hve-core installation verified successfully!
```

## Configuring hve-core in Your Projects

**hve-core provides two usage modes:**

### Mode 1: Global Installation (Recommended for beginners)

* Install hve-core once in central location
* Link to it from multiple projects
* Easier updates (update once, affects all projects)

### Mode 2: Per-Project Installation (Recommended for teams)

* Install hve-core as dependency in each project
* Team members automatically get hve-core when cloning project
* Version pinned per project (stability)

### Global Installation Setup

```bash
# From hve-core directory
npm link

# Expected output:
# /usr/local/lib/node_modules/hve-core -> ~/dev/tools/hve-core
```

Now in your project directory:

```bash
cd ~/your-project
npm link hve-core
```

This creates symlink from your project to global hve-core installation.

### Per-Project Installation Setup

In your project directory:

```bash
cd ~/your-project
npm install --save-dev hve-core
```

This installs hve-core as a dev dependency in your project's `package.json`.

> [!TIP]
> **Which mode to choose?** Start with Global Installation for learning. Switch to Per-Project Installation when you're ready to onboard your team, as it ensures everyone has consistent hve-core version.

## Workspace Configuration

### Step 1: Create .vscode directory in your project

```bash
mkdir -p .vscode
```

### Step 2: Copy hve-core workspace settings

If using global installation:

```bash
cp $(npm root -g)/hve-core/templates/.vscode/settings.json .vscode/settings.json
```

If using per-project installation:

```bash
cp node_modules/hve-core/templates/.vscode/settings.json .vscode/settings.json
```

### Step 3: Review settings.json

Open `.vscode/settings.json`:

```json
{
  "github.copilot.chat.useProjectFiles": true,
  "github.copilot.chat.followUps": true,
  "files.exclude": {
    "**/.copilot-tracking": false
  },
  "hve.researchDirectory": ".copilot-tracking/research",
  "hve.planningDirectory": ".copilot-tracking/planning",
  "chat.modeFilesLocations": {
    "../hve-core/.github/chatmodes": true
  }
}
```

**Key settings explained:**

* `useProjectFiles: true` - Allows Copilot to read your codebase (essential for research)
* `.copilot-tracking` - Directory where research/planning documents are stored
* `chatModes` - Templates for specialized modes (Task Researcher, etc.)

### Step 4: Create tracking directories

```bash
mkdir -p .copilot-tracking/research
mkdir -p .copilot-tracking/planning
```

### Step 5: Add to .gitignore (optional)

If you want to keep research/planning documents private:

```bash
echo ".copilot-tracking/" >> .gitignore
```

**Or keep them tracked** (recommended for teams):

```bash
# Don't add to .gitignore - commit research/planning documents for team reference
```

---

**Previous:** [GitHub Copilot Setup](./02-copilot-subscription.md) | **Next:** [Chat Modes Configuration](./04-chat-modes-configuration.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
