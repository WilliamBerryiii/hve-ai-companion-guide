# Chat Modes Configuration & Verification

With GitHub Copilot and hve-core installed, it's time to configure the **chat modes** that power the Research → Plan → Implement workflow. This section explains what chat modes are, how to access them, and how to verify they're working correctly.

By the end, you'll be able to switch confidently between Ask Mode, Task Researcher, Task Planner, Edit Mode, and Agent Mode based on your engineering needs.

## Understanding Chat Modes

GitHub Copilot Chat has a **mode system** that changes AI behavior based on task type:

**Five Core Modes:**

1. **Ask Mode** (Chapter 5) - Quick discovery (5-10 min)
2. **Task Researcher** (Chapter 6) - Deep research (20-60 min)
3. **Task Planner** (Chapter 7) - Implementation planning (10-20 min)
4. **Edit Mode** (Chapter 8) - File editing and refactoring
5. **Agent Mode** (Chapter 9) - Autonomous implementation

**How modes differ:**

| Mode            | Purpose                 | Time      | Outputs        | User Control                  |
|-----------------|-------------------------|-----------|----------------|-------------------------------|
| Ask             | Quick questions         | 5-10 min  | Chat only      | High - conversational         |
| Task Researcher | Evidence gathering      | 20-60 min | Research doc   | Medium - guided investigation |
| Task Planner    | Implementation strategy | 10-20 min | 3 plan docs    | Medium - structured planning  |
| Edit            | Controlled code changes | Variable  | File edits     | High - approve each change    |
| Agent           | Autonomous development  | Variable  | Multiple files | Low - agent decides steps     |

**Mode selection guideline:**

* **Don't know what exists?** → Ask Mode (Chapter 5)
* **Need deep understanding?** → Task Researcher (Chapter 6)
* **Have research, need plan?** → Task Planner (Chapter 7)
* **Have plan, need implementation?** → Edit Mode (Chapter 8)
* **Clear spec, want autonomous execution?** → Agent Mode (Chapter 9)

## Accessing Chat Modes in VS Code

### Method 1: Agent Picker Dropdown (Recommended)

All chat modes are accessed via the **agent picker dropdown** in GitHub Copilot Chat:

1. Open Copilot Chat sidebar (`Ctrl+Alt+I` or `Cmd+Alt+I`)
2. Click the **agent picker dropdown** at the top of the chat input area
3. Select your desired agent from the list:
   * **Ask** - Quick discovery and questions (built-in agent)
   * **task-researcher** - Deep research with documentation (hve-core chatmode)
   * **task-planner** - Implementation planning with structured outputs (hve-core chatmode)
   * **Edit** - Controlled file editing and refactoring (built-in agent)
   * **Agent** - Autonomous multi-step implementation (built-in agent)
4. Type your message and press Enter

> [!NOTE]
> **Slash commands vs. agent selection:** Slash commands (like `/fixIssue`, `/optimize`) invoke **prompt files** (`.prompt.md`), not chat modes or agents. Agents and chatmodes are always selected from the dropdown.

### Method 2: Agent Selection via Command Palette

1. Press `Ctrl+Shift+P` (or `Cmd+Shift+P`) to open Command Palette
2. Type: `GitHub Copilot: Select Agent`
3. Select your desired agent from the list
4. Chat sidebar updates to show selected agent
5. Type your message

> [!TIP]
> **Use Method 1 (dropdown) for speed.** The agent picker dropdown is visible and fast. Command Palette (Method 2) is useful when you prefer keyboard-only navigation.

## Verifying Chat Modes Work

### Test 1: Ask Mode (Quick Check)

1. Open Copilot Chat sidebar (`Ctrl+Alt+I` or `Cmd+Alt+I`)
2. Click the **agent picker dropdown** at the top
3. Select **Ask** from the list
4. Type this message:

```text
@workspace List the main directories in this project
```

**Expected response:**

* Lists actual directories from your workspace
* No files created

**Success criteria:**

* ✅ Response references actual paths from your project
* ✅ Agent picker shows "Ask" as selected
* ✅ No error about agent not found

---

### Test 2: Task Researcher (Research Document Creation)

1. Open Copilot Chat sidebar
2. Click the **agent picker dropdown**
3. Select **task-researcher** from the list
4. Type this message:

```text
Research the project structure and identify where configuration files are located. Document findings in a research document.
```

**Expected response:**

* Task Researcher analyzes workspace
* Creates file: `.copilot-tracking/research/YYYYMMDD-project-structure-research.md`
* Response includes: "Research document created at [path]"

**Verification steps:**

1. Check `.copilot-tracking/research/` directory exists
2. Open the created `.md` file
3. Verify it contains:
   * Task Implementation Requests section
   * Evidence Log with file paths
   * Key Discoveries section
   * Dated filename format: `YYYYMMDD-description-research.md`

**Success criteria:**

* ✅ Research document created in correct directory
* ✅ Document follows research template (sections match Chapter 6 examples)
* ✅ Contains actual project-specific findings (not generic)

---

### Test 3: Task Planner (Plan Document Creation)

1. Open Copilot Chat sidebar
2. Click the **agent picker dropdown**
3. Select **task-planner** from the list
4. Type this message:

```text
Create a simple plan for adding a new configuration validation function. Use findings from previous research if available.
```

**Expected response:**

* Task Planner generates implementation plan
* Creates THREE files in `.copilot-tracking/planning/`:
  * `YYYYMMDD-config-validation-plan-details.md`
  * `YYYYMMDD-config-validation-plan-implementation.md`
  * `YYYYMMDD-config-validation-plan-changes.md`

**Verification steps:**

1. Check `.copilot-tracking/planning/` directory exists
2. Verify three plan files created
3. Open `*-plan-implementation.md`
4. Verify it contains:
   * Numbered implementation steps
   * Verification criteria for each step
   * References to research findings (if research was done previously)

**Success criteria:**

* ✅ Three plan documents created
* ✅ Documents follow planning template
* ✅ Implementation steps are concrete and actionable
* ✅ Filenames use consistent date format

---

### Test 4: Edit Mode (File Modification)

Create a test file: `test-edit.js`

```javascript
function add(a, b) {
  return a + b;
}
```

1. Select the entire function
2. Open inline chat (`Ctrl+I` or `Cmd+I`)
3. Click the **agent picker** (small icon at top of inline chat)
4. Select **Edit** from the dropdown
5. Type this message:

```text
Add JSDoc comment to this function
```

**Expected response:**

* Copilot suggests edit inline
* Shows diff highlighting changes
* Provides Accept/Reject buttons

**Success criteria:**

* ✅ Copilot generates JSDoc comment
* ✅ Changes shown as diff (green/red highlighting)
* ✅ Can accept or reject changes
* ✅ Agent picker shows "Edit" as selected

---

### Test 5: Agent Switching

Test that you can switch between agents in same chat session:

1. **First query with Ask agent:**
   * Select **Ask** from agent picker dropdown
   * Message: `Where is the main entry point of this application?`
   * Wait for response

2. **Switch to task-researcher:**
   * Click agent picker dropdown
   * Select **task-researcher**
   * Message: `Research the dependency injection pattern used in this codebase`
   * Wait for research document creation

3. **Switch to task-planner:**
   * Click agent picker dropdown
   * Select **task-planner**
   * Message: `Create implementation plan for adding a new dependency`
   * Wait for plan documents creation

**Success criteria:**

* ✅ Each agent responds appropriately to its task
* ✅ Agent switches without error
* ✅ Agent picker dropdown shows currently selected agent
* ✅ Context from previous agent carries forward (e.g., task-researcher can reference Ask mode findings)

## Troubleshooting Chat Modes

### Issue: Agent not available in dropdown

(e.g., `task-researcher` missing from agent picker)

**Diagnosis:** hve-core chatmode files not loaded by VS Code

**Solution:**

1. Verify `.vscode/settings.json` exists with `chat.modeFilesLocations` configuration pointing to hve-core
2. Check the configuration:

   ```json
   {
     "chat.modeFilesLocations": {
       "../hve-core/.github/chatmodes": true
     }
   }
   ```

3. Restart VS Code (Reload Window via Command Palette: `Ctrl+Shift+P` → `Developer: Reload Window`)
4. Verify hve-core directory exists at the configured path

**Recovery:** Reinstall hve-core or update `chat.modeFilesLocations` path in settings

---

### Issue: Task Researcher creates document but it's empty or generic

**Diagnosis:** Copilot doesn't have workspace access

**Solution:**

1. Check `"github.copilot.chat.useProjectFiles": true` in settings.json
2. Verify workspace is trusted (VS Code prompts on first open)
3. Ensure you're using `@workspace` prefix in your message: `@workspace Research project structure`
4. Verify task-researcher is selected in agent picker dropdown

**Recovery:** Grant workspace trust, ensure project has actual files to analyze, verify agent selection

---

### Issue: Chat modes work but are slow (>30 seconds per response)

**Diagnosis:** Large workspace, Copilot analyzing too many files

**Solution:**

1. Add `.gitignore` patterns for large directories (node_modules, dist, build)
2. Use more specific prompts: Instead of "research the project", say "research the src/ directory structure"
3. Close unused editor tabs (Copilot considers open files as high-priority context)

**Optimization:** Configure `files.exclude` in settings.json to hide irrelevant directories

---

**Previous:** [HVE-Core Installation](./03-hve-core-installation.md) | **Next:** [MCP Server Setup (Optional)](./05-mcp-server-setup.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
