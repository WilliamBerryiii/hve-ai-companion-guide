---
description: "Markdown formatting standards for GitHub Copilot - inclusive language, accessibility, and technical syntax requirements"
applyTo: '**/*.md, !**/*.instructions.md, !**/*.prompt.md, !**/chatmodes/**'
---

# Markdown Formatting Guide

## Scope

This guide defines markdown formatting standards for GitHub Copilot when helping users write or edit markdown files. It focuses on technical syntax, inclusive language, and accessibility requirements.

**Division of responsibility:**

* **Markdownlint configuration** (`.markdownlint.json`, `.markdownlint-cli2.jsonc`) enforces: line length, heading syntax, list indentation, code block style, blank line rules
* **This guide** enforces: inclusive language, accessibility requirements, callout syntax, frontmatter format, heading structure

This guide applies to all markdown files in the repository (`**/*.md`) except files in `.copilot-tracking/**` (excluded by markdownlint-cli2 configuration).

## Writing Tone

Write with the voice of a friendly, knowledgeable guide who combines deep technical expertise with genuine enthusiasm for helping others succeed.

**Tone characteristics:**

* **Welcoming:** Make readers feel comfortable asking questions and exploring new concepts
* **Generous:** Share knowledge freely and assume good intent
* **Knowledgeable:** Demonstrate expertise through clear explanations and practical insights
* **Approachable:** Use conversational language that bridges technical complexity with accessibility
* **Supportive:** Focus on empowering readers rather than showcasing technical superiority

Think of yourself as the experienced colleague who takes time to explain things thoroughly, celebrates learning moments, and creates a safe space for experimentation and growth.

## Evidence-Based Prose Standards

Research validates that conversational, scannable prose dramatically improves comprehension and user satisfaction across all expertise levels.

### Research Foundation

**Nielsen Norman Group Study Results:**
* **124% usability improvement** when combining conversational techniques (concise, scannable, objective language) compared to formal promotional writing
* **79% of users scan** web pages; only 16% read word-by-word
* Source: [How Users Read on the Web](https://www.nngroup.com/articles/how-users-read-on-the-web/)

**Expert Preferences:**
* Even highly educated professionals (IT managers, college professors, nurses with doctorates) consistently prefer conversational, scannable content over academic prose
* Plain language makes writers appear smarter because readers understand more
* Study participant (Professor): "All this is so complicated... I personally prefer it be to be nice and conversational"
* Source: [Plain Language Is for Everyone, Even Experts](https://www.nngroup.com/articles/plain-language-experts/)

**Industry Alignment:**
* Microsoft: "Warm and relaxed, crisp and clear"
* Google: Clarity over rigid formality
* GitHub: "Clear, simple language that's approachable for a wide range of readers"

### Sentence Length Guidelines

**Target:** 15-20 words per sentence average

**Rationale:**
* Shorter sentences reduce cognitive load
* Varied sentence length creates natural rhythm
* Technical concepts benefit from deliberate pacing

**Application:**
* Break compound sentences into multiple statements
* Use transitional words to maintain flow
* Aim for variety: some sentences shorter (10-12 words), others longer (22-25 words)

**Example:**

❌ Not recommended: "The framework provides a systematic approach to AI-assisted development by establishing clear phases for research, planning, and implementation, which helps teams maintain consistency and quality throughout complex projects."

✅ Recommended: "The framework provides a systematic approach to AI-assisted development. It establishes clear phases for research, planning, and implementation. This structure helps teams maintain consistency and quality throughout complex projects."

### Reading Level Target

**Target:** 10-12th grade reading level (Flesch-Kincaid Grade Level)

**Rationale:**
* Accessible to broad audience without oversimplification
* Maintains technical accuracy
* Reduces comprehension time

**Validation:**
* Use readability tools (Hemingway Editor, Flesch-Kincaid calculators)
* Test complex sections to ensure they meet target
* Technical terms are allowed but should be explained

### Inverted Pyramid Pattern

Present conclusions first, then supporting details. This pattern respects scanning behavior and gets readers to key insights quickly.

**Structure:**
1. **Lead:** Core insight or conclusion (what matters most)
2. **Context:** Supporting details and explanation
3. **Background:** Technical specifics and edge cases

**Example:**

❌ Not recommended: "Testing frameworks come in many varieties. Some focus on unit testing, others on integration testing. After evaluating various options and considering team needs, we recommend pytest for Python projects."

✅ Recommended: "Use pytest for Python projects. It provides excellent unit and integration testing capabilities with minimal setup. The framework offers clear error messages and extensive plugin ecosystem."

### Scannable Formatting

Support the 79% of users who scan by using:

**Structural Elements:**
* Headings every 2-3 paragraphs
* Bulleted lists for parallel items
* Short paragraphs (3-4 sentences maximum)
* Bold text for key terms (first mention only)

**Code Examples:**
* Explanatory text before code blocks (not after)
* Context showing where code fits in larger file
* Progressive disclosure (simple example, then complex variant)

**Visual Hierarchy:**
* H2 for major sections
* H3 for subsections
* H4 for specific topics within subsections
* Never skip heading levels

### Conversational vs Formal Tone

Use conversational language that maintains technical precision.

**Conversational Techniques:**
* Second-person voice ("you will configure", "your workflow")
* Contractions where natural ("you'll", "it's", "we're")
* Questions to engage readers ("What makes this effective?")
* Active voice over passive ("Configure the settings" not "The settings should be configured")

**Maintain Professionalism:**
* Avoid slang or overly casual language
* No hyperbole or promotional language ("amazing", "revolutionary")
* Technical accuracy is non-negotiable
* Respectful of reader's time and intelligence

**Example:**

❌ Too formal: "It is recommended that one should configure the linting rules prior to commencing development activities."

❌ Too casual: "You're gonna want to setup linting before you start coding, it's super awesome!"

✅ Balanced: "Configure your linting rules before you start development. This catches issues early and maintains code quality."

## Inclusive Language

### Prohibited Terms and Alternatives

Use inclusive, bias-free language that respects all readers. Replace outdated technical terms and ableist language with modern alternatives.

| Prohibited Term      | Acceptable Alternatives                              | Context                                               |
| -------------------- | ---------------------------------------------------- | ----------------------------------------------------- |
| master/slave/mastery | primary/replica, primary/secondary, main/subordinate | Technical systems, Git branches, database replication |
| whitelist/blacklist  | allowlist/denylist, allowlist/blocklist              | Security, filtering, access control                   |
| man-hours            | person-hours, work-hours, effort-hours               | Project planning, estimation                          |
| mankind              | humankind, humanity, people                          | General references to human species                   |
| manpower             | workforce, staff, personnel, staffing                | Resource planning, capacity                           |
| chairman             | chair, moderator, coordinator                        | Meeting roles, leadership                             |
| crazy                | unexpected, surprising, unusual, unpredictable       | Describing situations or results                      |
| insane               | extreme, wild, intense, remarkable                   | Describing magnitude or impact                        |
| blind to             | unaware of, unfamiliar with, overlooking             | Describing lack of awareness                          |
| cripple              | disable, impair, limit, break                        | Describing system failures or limitations             |
| dumb                 | silent, muted, basic, simplified                     | Describing interfaces or communication                |
| lame                 | weak, ineffective, suboptimal, limited               | Describing poor solutions or approaches               |

**Rationale:** These standards follow Microsoft Writing Style Guide, Google Developer Documentation Style Guide, and GitHub's inclusive language guidelines.

### Gender-Neutral Language

Use gender-neutral language consistently:

* **Singular they/them/their:** Use for unknown or irrelevant gender ("Each developer should review their code")
* **Second-person you:** Prefer for instructional content ("You can configure the settings")
* **Avoid "he or she" constructions:** Use "they" instead
* **Gender-neutral alternatives:**
  * mankind → humanity, humankind, people
  * man-made → synthetic, artificial, manufactured
  * manpower → workforce, staff, personnel

**Example:**

✅ Recommended: "When a developer joins the team, they should review the onboarding guide."

❌ Not recommended: "When a developer joins the team, he or she should review the onboarding guide."

## Accessibility

### Requirements for All Content

Make content accessible to all users including those using screen readers and assistive technologies.

**Alt text for images:**

* Required for all images
* Describe the content and function, not appearance
* Keep concise (1-2 sentences)
* Avoid "image of" or "picture of" (screen readers announce it's an image)

**Example:** `![Workflow diagram showing three phases: Discovery, Implementation, Review](path/to/workflow.png)`

**Semantic heading hierarchy:**

* Use headings in order: H1 → H2 → H3
* Never skip levels (H1 → H3)
* One H1 per page (acts as page title)
* Use headings to structure content, not for visual styling

**Descriptive link text:**

* Link text must describe the destination or purpose
* Avoid generic text like "click here," "this document," or "read more"
* Match page title or use descriptive phrase

**Example:** "See the Workflow Configuration Guide for details."

**Color and visual cues:**

* Never use color as the sole means of conveying information
* Supplement color with text labels or icons
* Ensure sufficient contrast for text (WCAG AA: 4.5:1 for normal text)

**Tables:**

* Always include header row with clear column labels
* Use markdown table syntax (headers in first row, separator in second row)
* Keep tables simple; complex tables are difficult for screen readers

**Code examples:**

* Always specify language for syntax highlighting
* Syntax highlighting provides visual structure that aids comprehension
* Screen readers can identify code blocks by language

**Callout icons:**

* All callouts use text labels (NOTE, TIP, IMPORTANT, WARNING, CAUTION)
* Icons supplement text labels, not replace them
* Font Awesome icons have built-in accessibility attributes

## Markdown Syntax

### Callouts and Notices

Use five callout types with GitHub-style alert syntax, rendered by Docsify flexible-alerts plugin.

**Syntax:** `> [!TYPE]` followed by blockquote content

**Callout types:**

| Type      | Purpose               | Icon                    |
| --------- | --------------------- | ----------------------- |
| NOTE      | Useful information    | fa-info-circle          |
| TIP       | Helpful advice        | fa-lightbulb            |
| IMPORTANT | Crucial information   | fa-exclamation-circle   |
| WARNING   | Potential issues      | fa-exclamation-triangle |
| CAUTION   | Negative consequences | fa-ban                  |

**Examples:**

```markdown
> [!NOTE]
> This workflow requires GitHub Copilot Chat with GPT-4. Check your subscription settings to verify you have access.

> [!TIP]
> Use keyboard shortcuts to switch between chat modes quickly: `Ctrl+Shift+P` opens the Command Palette where you can type "chat mode".

> [!IMPORTANT]
> Complete the prerequisite reading on AI context management before starting this chapter. Understanding context windows is essential for effective prompt engineering.

> [!WARNING]
> The `--force` flag bypasses safety checks and may overwrite uncommitted changes. Always commit or stash your work first.

> [!CAUTION]
> Deleting a chat mode file removes all associated prompts and settings. This action cannot be undone. Back up your configuration before proceeding.
```

### Code Examples

Present code with proper formatting for Prism.js syntax highlighting.

**Supported languages:** bash, python, javascript, typescript, json, yaml, markdown, powershell, csharp, bicep

**Formatting standards:**

* **Language specification:** Always specify language for syntax highlighting
* **Indentation:** 2 spaces per level (follow language style guides)
* **Line length:** Up to 1200 characters (markdownlint configuration allows wide code blocks)
* **Omitted code:** Use language-appropriate comments, not ellipsis
  * Bash: `# ... additional configuration`
  * Python: `# ... rest of function`
  * JavaScript: `// ... other imports`
  * JSON: Use actual valid JSON structure
* **Command examples:** No `$` prompt unless showing command output
* **Copy-pasteable:** Code should work when copied and pasted

### Procedures and Steps

Write clear, actionable procedures for task-based content.

**Single-step procedures:**

* Use bulleted list (not numbered)
* No introductory sentence needed for obvious actions

**Example:**

```markdown
* Click **File** > **New Document**.
```

**Multi-step procedures:**

* Use numbered list
* Include introductory sentence providing context
* Format: "To accomplish X, follow these steps:"

**Sub-steps:**

* Use lowercase letters for sub-steps (a, b, c)
* Use lowercase Roman numerals for sub-sub-steps (i, ii, iii)

**Optional steps:**

* Prefix with "Optional:" at start of step
* Explain when the step applies

**Goal before action:**

* State the purpose before the action
* Format: "To start a new document, click File"

**Location before action:**

* Specify where to perform the action first
* Format: "In Google Docs, click File"

**Example:**

```markdown
To configure a new chat mode, follow these steps:

1. Create a configuration file in `.github/chatmodes/` directory.
   a. Name the file using kebab-case (e.g., `task-researcher.json`).
   b. Include the `.json` extension.
2. Add required fields: `name`, `description`, `systemPrompt`.
3. Optional: Set `temperature` value between 0.0 (deterministic) and 1.0 (creative).
4. Save the file and reload VS Code to activate the chat mode.
```

### Cross-References and Links

Create effective links that enhance navigation without overwhelming readers.

**Core principles:**

* **Be selective:** Each link adds cognitive load and an exit opportunity
* **No duplicate links:** Don't link to the same destination multiple times on the same page
* **Descriptive link text:** Text must describe the destination or purpose

**Link text options:**

1. **Match page title/heading:** Use exact title for clarity
2. **Descriptive phrase:** Summarize the destination content

**Recommended:**

```markdown
See the [Configuration Guide](./configuration.md) for detailed setup instructions.
```

**Not recommended:**

```markdown
Click [this link](./configuration.md) to learn more.

For more information about advanced features, see [Advanced Features Guide](./advanced.md).
```

❌ Not recommended:
```markdown
Click [here](./configuration.md) to learn more.

For more information, see [this document](./advanced.md).
```

**Consistent introduction:**

* "For more information, see [Link]"
* "For more information about X, see [Link]"
* "See [Link] for details"

**Punctuation:**

* Place punctuation outside link tags when possible
* Exception: When link is possessive or part of clause

**Link fragments:**

* Must match heading IDs (kebab-case, lowercase)
* Use `#heading-name` for same-page links
* Use `./file.md#heading-name` for cross-file links

**Example:**

```markdown
The framework provides structure for collaboration. For more information about the framework's components, see [Framework Overview](../docs/framework.md#overview).

Related topics:

* [Configuration Guide](../docs/configuration.md) - How to configure the system
* [Getting Started](../docs/getting-started.md) - Introduction and setup
```

### Headings and Titles

Use heading style that distinguishes between procedural and conceptual content.

**Capitalization:** Use sentence case for all headings (not title case).

✅ Recommended: `## Configure chat mode settings`

❌ Not recommended: `## Configure Chat Mode Settings`

**Task-based headings:** Start with bare infinitive verb (base form, no "to").

| Recommended            | Not Recommended           |
| ---------------------- | ------------------------- |
| Create an agent        | Creating an agent         |
| Configure settings     | How to configure settings |
| Deploy the application | Deploying the application |
| Install dependencies   | Installing dependencies   |

**Conceptual headings:** Use noun phrase, avoid -ing verbs.

| Recommended           | Not Recommended         |
| --------------------- | ----------------------- |
| Agent architecture    | Understanding agents    |
| Configuration options | Configuring your system |
| Migration strategies  | Migrating to new system |
| Context management    | Managing context        |

**Structural rules:**

* **One H1 per page:** Acts as page title
* **No level skipping:** H1 → H2 → H3, never H1 → H3
* **Heading hierarchy:** Use to structure content, not for font size

**Code in headings:**

* Avoid when possible
* If necessary, add descriptive noun: "The `config.json` file"

**No links in headings:** Keep headings as plain text for accessibility and navigation.

## Frontmatter

Use YAML frontmatter for metadata at the start of markdown files.

**Format:** YAML block between `---` delimiters at start of file.

**Basic syntax:**

```yaml
---
title: HVE AI Companion Guide
description: Master the Research → Plan → Implement (RPI) framework for AI-assisted development with hve-core and GitHub Copilot
author: HVE Core Team
ms.date: 2025-11-15
keywords:
  - AI-assisted development
  - GitHub Copilot
  - RPI framework
  - hve-core
  - engineering fundamentals
---
```

**Required fields:**

* **title:** Page title
* **description:** Brief summary of page content and purpose
* **author:** Content author or team name
* **ms.date:** Last update date in YYYY-MM-DD format
* **keywords:** List of relevant keywords for searchability

## Document Footer

All markdown documents should end with this attribution footer:

```markdown
<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
```
