---
title: "Inline Chat and Edit Agent: Controlled Code Modification"
description: Master Inline Chat and Edit Agent for precise, reviewable code modifications with diff-based review and iterative refinement
author: HVE Core Team
ms.date: 2025-11-29
chapter: 8
part: "II"
keywords:
  - inline-chat
  - edit-agent
  - file-modification
  - diff-review
  - code-changes
  - precision-editing
---

## Inline Chat and Edit Agent: Controlled Code Modification

VS Code Copilot provides two primary tools for modifying existing code: **Inline Chat** and the **Edit Agent**. Both transform how you modify existing code—instead of typing changes yourself, you describe what needs to change and review the proposed modifications before they're applied. This section teaches you to use these tools for precise, reviewable code modifications that follow your implementation plans.

## Two Tools for Controlled Modification

VS Code Copilot provides two complementary approaches for modifying existing code:

### Inline Chat (Ctrl+I)

Inline Chat allows you to make targeted changes to selected code directly in the editor:

1. Select the code you want to modify
2. Press `Ctrl+I` (Windows/Linux) or `Cmd+I` (Mac)
3. Describe the change you want
4. Review the diff and accept or reject

**Inline Chat characteristics:**

* **File-targeted**: Changes focused on selected code or current file
* **Context-aware**: Uses existing code patterns as templates for consistency
* **Diff-based review**: Shows before/after for every change
* **Iterative refinement**: Refine suggestions before accepting
* **Undo-friendly**: Changes are easy to revert

### Edit Agent

The Edit Agent in the Chat panel handles larger or multi-file modifications:

1. Open Chat panel (`Ctrl+Alt+I`)
2. Select **Edit** from the agent/mode dropdown
3. Describe your changes with file context
4. Review diffs for each affected file

**Edit Agent characteristics:**

* **Multi-file capable**: Can modify multiple files in a single operation
* **Broad scope**: Handles refactoring across the codebase
* **Coordinated changes**: Ensures consistency across related modifications
* **Full context**: Sees the broader project structure

> [!TIP]
> Use Inline Chat (`Ctrl+I`) for quick, focused changes within a single location. Use Edit Agent for changes that span multiple functions or files.

**When to use each:**

| Scenario | Tool | Why |
|----------|------|-----|
| Modify single function | Inline Chat | Focused, fast |
| Add validation to existing code | Inline Chat | Targeted change |
| Refactor across files | Edit Agent | Multi-file coordination |
| Rename with all usages | Edit Agent | Broad scope needed |
| Quick fix in current file | Inline Chat | Immediate, contextual |
| Large-scale pattern changes | Edit Agent | Consistency required |

## How to Invoke Inline Chat and Edit Agent

### Method 1: Inline Chat (Recommended for Focused Changes)

1. Open file in editor
2. Select code section to modify (optional but helpful)
3. Press `Ctrl+I` (Windows/Linux) or `Cmd+I` (Mac)
4. Describe changes in prompt
5. Review diff, accept or refine

**When to use:** You're already viewing the file and know what needs changing. This is the fastest method for most single-location modifications.

### Method 2: Edit Agent via Chat Panel

1. Open Copilot Chat sidebar (`Ctrl+Alt+I` or `Cmd+Alt+I`)
2. Click the **agent picker dropdown** and select **Edit**
3. Reference the file: `#file:src/auth/authRoutes.ts`
4. Describe changes
5. Review diffs for each affected file, accept or refine

**When to use:** Working from an implementation plan when you haven't opened the target file yet, or when making coordinated changes across multiple files.

### Method 3: Context Menu

1. Right-click in file
2. Select "Copilot > Start Inline Chat" (or similar)
3. Describe changes
4. Review diff, accept or refine

**When to use:** You prefer mouse-driven workflows or are discovering these capabilities.

> [!TIP]
> Selecting code before `Ctrl+I` focuses Inline Chat on that section, reducing unnecessary changes to other parts of the file.

## Writing Effective Modification Prompts

Prompt quality determines result quality. Strong prompts specify exactly what to change and how, leveraging implementation plan details for precision.

**Prompt structure for precise modifications:**

1. **What to modify**: Specific function, class, or section with line numbers if available
2. **How to modify**: Clear instruction (add, update, refactor, remove)
3. **Context from plan**: Reference implementation plan details
4. **Patterns to follow**: Reference existing code patterns for consistency

### Example: Weak vs Strong Prompts

**Weak prompt:**

```text
Add 2FA verification
```

**Problems:** Where should it go? How should it work? What approach?

**Strong prompt:**

```text
In the login function (lines 78-95), add 2FA verification after password check:
1. Check if user.twoFactorEnabled is true
2. If true, require req.body.totpToken
3. Verify token using speakeasy.totp.verify()
4. Return 401 if verification fails
Follow the pattern from existing validation checks at lines 85-90.
```

**Why this works:** Specifies location, steps, libraries, error handling, and existing pattern to follow. Copilot has everything needed for correct implementation.

### Real Example: Adding Validation Logic

**Plan Step:**

```markdown
Step 1.3: Add email validation to userValidator.ts
- Location: src/validators/userValidator.ts, after line 25
- Implementation: Use validator.isEmail() library (already imported)
- Pattern: Follow existing validation structure at lines 15-20
- Verification: Test with valid/invalid email formats
```

**Inline Chat Prompt:**

```text
After the username validation (line 25), add email validation:

1. Check if email field exists and is non-empty
2. Use validator.isEmail(email) to validate format
3. Add error message: "Invalid email format"
4. Follow the same structure as username validation above

Keep the existing validation chain pattern.
```

**Expected Result (diff view):**

```diff
  // Username validation
  if (!username || username.length < 3) {
    errors.push('Username must be at least 3 characters');
  }
  
+ // Email validation
+ if (!email) {
+   errors.push('Email is required');
+ } else if (!validator.isEmail(email)) {
+   errors.push('Invalid email format');
+ }
+
  // Password validation
  if (!password || password.length < 8) {
    errors.push('Password must be at least 8 characters');
  }
```

The diff shows exactly what changes. Green lines are added. Existing code remains intact. Review confirms the change matches plan specifications.

## Reviewing Proposed Changes

The diff view is your quality gate. Every change passes through review before affecting your code. Learn to review efficiently and catch issues early.

**The diff view shows:**

* **Red lines (-)**: Code being removed
* **Green lines (+)**: Code being added
* **Gray lines**: Unchanged context

**Review checklist:**

✅ **Correctness**: Does change match plan specifications?  
✅ **Completeness**: Are all required modifications present?  
✅ **Side effects**: Did it change anything unintended?  
✅ **Style consistency**: Does new code match existing patterns?  
✅ **Safety**: Are there any risky changes (deleting critical code)?

### Review Decision Flow

```mermaid
graph TD
    A[Review Diff] --> B{Change matches plan?}
    B -->|Yes| C{Style consistent?}
    B -->|No| D[Reject, refine prompt]
    C -->|Yes| E{Any unintended changes?}
    C -->|No| F[Request style fix]
    E -->|No| G[Accept]
    E -->|Yes| H[Reject, be more specific]
    
    D --> A
    F --> A
    H --> A
    
    style G fill:#50e6ff,stroke:#0078d4
    style D fill:#ff6b6b,stroke:#c92a2a
    style H fill:#ff6b6b,stroke:#c92a2a
```

This decision tree guides your review. Most changes follow the happy path to acceptance. When issues appear, refinement is quick and targeted.

## Refining Suggestions

Initial suggestions won't always be perfect. Refinement lets you correct course without starting over. Follow-up prompts adjust the proposal until it's right.

**Refinement Prompt Patterns:**

### 1. More Specific Location

```text
The validation is correct, but move it above password validation 
(line 30) instead of after.
```

### 2. Style Adjustment

```text
Good, but use our project's error handling pattern:
throw new ValidationError(message) instead of errors.push()
```

### 3. Missing Details

```text
Add the email validation, but also add:
- Trim whitespace before validation
- Convert to lowercase
- Check against disposable email domain list (use isDisposable() helper)
```

### 4. Reduce Scope

```text
Only add the email validation. Don't modify the password validation 
that you changed - revert that part.
```

Refinement is iterative. Each prompt gets you closer to the desired result. Don't hesitate to refine multiple times until the change is correct.

## Best Practices for Code Modification

**DO:**

* ✅ Open file before invoking Inline Chat (provides context)
* ✅ Select specific section for focused changes
* ✅ Reference line numbers from implementation plan
* ✅ Mention existing patterns to follow
* ✅ Review every diff before accepting
* ✅ Test immediately after accepting changes

**DON'T:**

* ❌ Accept changes blindly without reviewing diff
* ❌ Make multiple unrelated changes in one prompt
* ❌ Use Inline Chat for creating entirely new files (use `/new` command or Agent mode)
* ❌ Continue if changes seem off (refine or reject)
* ❌ Skip testing after accepting changes

These practices ensure these modification tools enhance your workflow rather than introducing risks. The review step is never optional.

## Common Modification Scenarios

These real-world scenarios show Inline Chat and Edit Agent in action. Each demonstrates prompt structure and expected results.

### Scenario 1: Adding Function to Existing File

**Plan Step:** Add generateQRCode function to authService.ts

**Inline Chat Prompt:**

```text
Add new function generateQRCode after generateSecret function (line 42):

async function generateQRCode(secret: string, accountName: string): Promise<string> {
  // Use qrcode library to generate data URL
  // Format: otpauth://totp/AppName:account?secret=XXX&issuer=AppName
  // Return data URL string
}

Follow async/await pattern like other functions in this file.
```

**Result:** Function added with correct signature, matching file's async patterns, positioned after line 42.

### Scenario 2: Modifying Existing Function Logic

**Plan Step:** Update login function to check 2FA

**Inline Chat Prompt:**

```text
In the login function (lines 78-95), add 2FA check after password verification:

1. After successful password check (line 90)
2. Check if user.twoFactorEnabled === true
3. If true, verify req.body.totpToken using speakeasy.totp.verify()
4. If verification fails, return 401: "Invalid authentication code"
5. If verification succeeds, continue to session creation (line 93)

Keep all existing error handling and logging.
```

**Result:** 2FA verification added at correct location. Existing flow preserved. Error handling follows established patterns.

### Scenario 3: Refactoring for Consistency

**Plan Step:** Refactor error handling to use custom error classes

**Edit Agent Prompt:**

```text
Refactor all throw new Error() calls in #file:src/auth/ to use custom error classes:

- Authentication failures → throw new AuthenticationError(message)
- Validation failures → throw new ValidationError(message)  
- Not found errors → throw new NotFoundError(message)

Keep all error messages exactly the same.
Import error classes from 'src/errors' (add import at top of each file).
```

**Result:** All error instantiations updated across multiple files. Import statements added. Messages unchanged. Type safety improved.

### Scenario 4: Removing Deprecated Code

**Plan Step:** Remove old authentication method

**Inline Chat Prompt:**

```text
Remove the legacyLogin function (lines 105-130) and its route handler.

Also remove:
- Import of crypto-js (line 8)
- LEGACY_AUTH_ENABLED config check (line 15)

Keep all other authentication methods unchanged.
```

**Result:** Legacy code cleanly removed. Unused imports eliminated. Modern authentication methods untouched.

These scenarios demonstrate the versatility of Copilot's modification tools. From additions to deletions, from small tweaks to significant refactoring, Inline Chat and Edit Agent handle it all with reviewable precision.

> [!IMPORTANT]
> Always test after accepting changes. Even perfect-looking diffs can have subtle integration issues. Testing catches them immediately.

---

**Previous:** [Section 1: Introduction - From Plan to Code](./01-introduction-plan-to-code.md)  
**Next:** [Section 3: File Generation with /new Command and Agent Mode](./03-file-generation-new-command.md)
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
