---
title: "File Generation with /new Command and Agent Mode"
description: Use the /new slash command and Agent mode to generate complete new files following your project's patterns and conventions
author: HVE Core Team
ms.date: 2025-11-29
chapter: 8
part: "II"
keywords:
  - new-command
  - slash-commands
  - agent-mode
  - file-generation
  - scaffolding
  - new-files
  - pattern-following
---

## File Generation with /new Command and Agent Mode

VS Code Copilot provides powerful tools for generating complete new files from your descriptions. While Inline Chat and Edit Agent modify existing code, the `/new` command and Agent mode create fresh implementations following patterns from your codebase. This section shows you how to scaffold services, tests, and configurations that integrate seamlessly with your project.

## Understanding File Generation Tools

VS Code Copilot offers two primary approaches for creating new files:

### The /new Slash Command

The `/new` command is GitHub Copilot's **single-file generation tool**. Type `/new` in the Chat panel followed by your file specification, and Copilot generates a complete, working file based on your requirements.

**`/new` command characteristics:**

* **Whole-file generation**: Creates complete files, not fragments
* **Pattern-aware**: Follows conventions from reference files you specify
* **Dependency-smart**: Includes correct imports and library usage
* **Type-complete**: Generates TypeScript types and interfaces
* **Iteration-friendly**: Can regenerate with refined prompts until correct

### Agent Mode for Multi-File Generation

Agent mode extends file generation to create multiple related files in a single operation. Select **Agent** from the mode dropdown in the Chat panel, describe your requirements, and Agent mode handles the complexity of creating interconnected files.

**Agent mode characteristics:**

* **Multi-file generation**: Creates multiple related files together
* **Context-aware**: Understands relationships between files
* **Task-oriented**: Handles larger implementation tasks
* **Coordinated output**: Ensures consistency across generated files

**When to use each tool:**

| Scenario | Tool | Reason |
|----------|------|--------|
| Create single new service | `/new` command | Focused, explicit control |
| Create service + tests + types | Agent mode | Handles file relationships |
| Scaffold test file | `/new` command | Single file with clear spec |
| Create new API module | Agent mode | Routes, handlers, tests together |
| Generate configuration file | `/new` command | Self-contained, template-based |
| Create feature with multiple components | Agent mode | Coordinated multi-file output |

## How to Generate New Files

VS Code Copilot offers multiple methods for generating new files. Choose based on your workflow and task complexity.

### Method 1: /new Slash Command (Recommended for Single Files)

1. Open Chat panel (`Ctrl+Alt+I` or click Chat icon)
2. Type `/new` followed by your file specification
3. Example: `/new Create a TypeScript Express route handler for user authentication`
4. Copilot generates file content in the response
5. Review the generated code
6. Save the file to your desired location

> [!NOTE]
> `/new` is a built-in VS Code Copilot slash command (like `/fix`, `/tests`, `/explain`). Built-in commands are invoked with slash syntax and don't require agent selection.

**Example:**

```text
/new src/services/twoFactorService.ts

Create TwoFactorService class with methods:
- generateSecret(): generates TOTP secret
- generateQRCode(secret, account): creates QR code data URL
- verifyToken(secret, token): validates TOTP token

Follow patterns from src/services/authService.ts
Use speakeasy library (already in dependencies)
```

**When to use:** Starting from implementation plan and creating a single new file. Most explicit and controlled method.

### Method 2: Agent Mode (For Multiple Related Files)

1. Open Chat panel (`Ctrl+Alt+I`)
2. Select **Agent** from the mode dropdown at the top
3. Describe the files you want to create with full context
4. Agent mode can create multiple related files in a single operation
5. Review all generated files before accepting

**Example:**

```text
Create a new two-factor authentication module with:
- Service: src/services/twoFactorService.ts with generateSecret, verifyToken methods
- Tests: src/services/__tests__/twoFactorService.test.ts with full test coverage
- Types: src/types/twoFactor.ts with TypeScript interfaces

Follow patterns from the existing authService module.
```

**When to use:** Creating multiple related files or when file creation is part of a larger task.

### Method 3: Inline Chat in New File

1. Create empty file in VS Code
2. Press `Ctrl+I` (Windows/Linux) or `Cmd+I` (Mac)
3. Describe what file should contain
4. Review generated code, accept or refine

**When to use:** You've already created the empty file and are ready to fill it. Good for quick iterations.

> [!TIP]
> Use `/new` for single-file generation with explicit control. Use Agent mode when you need to create multiple related files or when file creation is part of a larger implementation task.

## Writing Effective File Generation Prompts

Prompt structure determines output quality. Strong prompts for `/new` and Agent mode provide complete specifications and clear pattern references.

**Prompt structure for file generation:**

1. **File purpose**: What this file does in the system
2. **Key components**: Classes, functions, methods to include
3. **Patterns to follow**: Reference to existing similar files
4. **Dependencies**: Libraries or imports to use
5. **Constraints**: What NOT to include

### Example: Weak vs Strong Prompts

**Weak prompt:**

```text
/new Create a service for 2FA
```

**Problems:** What methods? What patterns? What libraries? What export format?

**Strong prompt:**

```text
/new Create TwoFactorService class following the service pattern from 
src/services/authService.ts.

Required methods:
1. generateSecret(): Use speakeasy.generateSecret({ length: 32 })
2. generateQRCode(secret, accountName): Use qrcode.toDataURL() with 
   otpauth:// URL format
3. verifyToken(secret, token, window): Use speakeasy.totp.verify()
4. generateBackupCodes(): Create 10 random 8-character codes

Export as singleton instance like authService.
Include TypeScript types for all method signatures.
Add JSDoc comments for public methods.

Dependencies already installed: speakeasy, qrcode, crypto
```

**Why this works:** Specifies every method, references pattern file, names exact libraries, defines export format, and notes TypeScript requirements. No ambiguity.

## Creating a Complete Service File

Let's walk through creating a complete service using the `/new` command, from plan step to working code.

**From Chapter 7 Plan:**

```markdown
Step 1.2: Create TwoFactorService module
- Location: src/services/twoFactorService.ts (new file)
- Research reference: Service pattern from authService.ts
- Methods: generateSecret, generateQRCode, verifyToken, generateBackupCodes
- Export: Singleton instance
```

**Using /new Command:**

```text
/new src/services/twoFactorService.ts following the service pattern 
from src/services/authService.ts.

Class: TwoFactorService
Methods:
1. generateSecret(): Promise<{ secret: string, qrCode: string }>
   - Use speakeasy.generateSecret({ length: 32, name: 'MyApp' })
   - Generate QR code with qrcode.toDataURL()
   - Return both secret and QR code data URL

2. verifyToken(secret: string, token: string): boolean
   - Use speakeasy.totp.verify({ secret, token, window: 1 })
   - Window allows 30-second time drift
   - Return true if valid, false otherwise

3. generateBackupCodes(count: number = 10): string[]
   - Generate random 8-character alphanumeric codes
   - Use crypto.randomBytes for security
   - Return array of codes

Export singleton instance: export default new TwoFactorService()

Include:
- TypeScript types for all parameters and returns
- JSDoc comments for each public method
- Error handling with custom TwoFactorError
- Import speakeasy, qrcode, crypto

Follow authService.ts structure exactly.
```

**Generated Result:**

```typescript
import speakeasy from 'speakeasy';
import QRCode from 'qrcode';
import crypto from 'crypto';
import { TwoFactorError } from '../errors/TwoFactorError';

/**
 * Service for handling two-factor authentication operations.
 * Follows singleton pattern like authService.
 */
class TwoFactorService {
  /**
   * Generates a new TOTP secret and QR code for user enrollment.
   * @returns Object containing secret key and QR code data URL
   */
  async generateSecret(): Promise<{ secret: string; qrCode: string }> {
    try {
      const secret = speakeasy.generateSecret({
        length: 32,
        name: 'MyApp',
        issuer: 'MyApp'
      });

      const otpauthUrl = secret.otpauth_url;
      if (!otpauthUrl) {
        throw new TwoFactorError('Failed to generate OTP auth URL');
      }

      const qrCode = await QRCode.toDataURL(otpauthUrl);

      return {
        secret: secret.base32,
        qrCode
      };
    } catch (error) {
      throw new TwoFactorError('Failed to generate 2FA secret', error);
    }
  }

  /**
   * Verifies a TOTP token against a secret.
   * @param secret - The user's TOTP secret
   * @param token - The 6-digit token to verify
   * @returns True if token is valid, false otherwise
   */
  verifyToken(secret: string, token: string): boolean {
    try {
      return speakeasy.totp.verify({
        secret,
        token,
        encoding: 'base32',
        window: 1 // Allow 30-second time drift
      });
    } catch (error) {
      return false;
    }
  }

  /**
   * Generates backup codes for account recovery.
   * @param count - Number of backup codes to generate (default: 10)
   * @returns Array of random alphanumeric backup codes
   */
  generateBackupCodes(count: number = 10): string[] {
    const codes: string[] = [];
    
    for (let i = 0; i < count; i++) {
      const code = crypto
        .randomBytes(4)
        .toString('hex')
        .toUpperCase();
      codes.push(code);
    }
    
    return codes;
  }
}

// Export singleton instance
export default new TwoFactorService();
```

The generated file is production-ready. It follows the referenced pattern, includes all specified methods, handles errors properly, and exports correctly. This is the `/new` command at its best.

## Reviewing Generated Files

Unlike Inline Chat's diff review, file generation requires **full file review**. You're evaluating an entire file, not just changes.

**Review checklist:**

✅ **Completeness**: All required methods and functions present?  
✅ **Correctness**: Logic matches plan specifications?  
✅ **Pattern consistency**: Follows referenced file patterns closely?  
✅ **Type safety**: TypeScript types correct and complete (no `any`)?  
✅ **Error handling**: Appropriate try/catch blocks and error messages?  
✅ **Imports**: All dependencies imported with correct paths?  
✅ **Documentation**: JSDoc comments clear and accurate?  
✅ **Exports**: Correct export format for your project?

**Common file generation issues to catch:**

* ⚠️ Imports missing or using incorrect paths
* ⚠️ Patterns diverge from reference file structure
* ⚠️ TypeScript types too loose (excessive use of `any`)
* ⚠️ Error handling incomplete or inconsistent
* ⚠️ Method signatures don't match plan specifications
* ⚠️ Missing JSDoc or incorrect documentation

Thorough review prevents integration issues. Catch problems now before testing reveals them later.

## Refining Generated Results

Initial generation won't always be perfect. Refinement prompts correct specific issues without regenerating the entire file.

**Refinement Prompt Patterns:**

### 1. Fix Specific Issues

```text
Good structure, but fix these issues:
- Import TwoFactorError from '../errors' not '../errors/TwoFactorError'
- generateBackupCodes should return Promise<string[]> not string[]
- Add input validation to verifyToken (check secret and token format)
```

### 2. Match Pattern More Closely

```text
Regenerate following authService.ts pattern more closely:
- Use private methods for internal logic
- Add logging statements like authService (use logger.info/error)
- Return consistent error format: { success: boolean, error?: string }
```

### 3. Add Missing Elements

```text
Add these missing methods:
- encryptSecret(secret): Encrypt before storing in database
- decryptSecret(encrypted): Decrypt when retrieving from database
Use crypto.createCipher like in authService.ts
```

### 4. Simplify

```text
Remove the backup codes feature for now - just keep:
- generateSecret()
- verifyToken()

We'll add backup codes in a separate step.
```

Each refinement prompt adjusts the file incrementally. Multiple refinements are fine. Iterate until the file meets all requirements.

## File Generation Best Practices

**DO:**

* ✅ Always reference similar existing files for pattern consistency
* ✅ Specify export format explicitly (default, named, singleton)
* ✅ Include all required dependencies in prompt
* ✅ Review entire generated file carefully before accepting
* ✅ Test immediately after creation
* ✅ Use `/new` for single files, Agent mode for related file sets
* ✅ Refine if patterns don't match project conventions

**DON'T:**

* ❌ Generate files without specifying patterns to follow
* ❌ Accept without reviewing imports and types thoroughly
* ❌ Skip testing the new file
* ❌ Generate multiple unrelated files in one prompt
* ❌ Forget to specify TypeScript types and documentation requirements
* ❌ Use file generation for modifying existing files (use Inline Chat or Edit Agent)

These practices ensure file generation accelerates development without sacrificing quality. Pattern references and thorough review are non-negotiable.

## Common File Generation Scenarios

Real-world scenarios demonstrate file generation versatility across different file types.

### Scenario 1: Creating Test File

**Plan Step:** Create unit tests for TwoFactorService

**Using /new Command:**

```text
/new src/services/__tests__/twoFactorService.test.ts

Test suite for TwoFactorService following test patterns from 
authService.test.ts.

Test cases:
1. generateSecret() returns valid secret and QR code
2. verifyToken() accepts valid token
3. verifyToken() rejects invalid token
4. verifyToken() accepts token within time window
5. generateBackupCodes() returns correct count
6. generateBackupCodes() returns unique codes

Use Jest framework with async/await.
Mock dependencies: speakeasy, qrcode, crypto.
Include setup/teardown like authService.test.ts.
```

**Result:** Complete test file with six test cases, proper mocking, setup/teardown, following project test patterns.

### Scenario 2: Creating Configuration File

**Plan Step:** Add 2FA configuration module

**Using /new Command:**

```text
/new config/twoFactor.ts configuration file.

Export configuration object with these properties:
- enabled: boolean (from env TWO_FACTOR_ENABLED, default false)
- secretLength: number (default 32)
- tokenWindow: number (default 1)
- backupCodesCount: number (default 10)
- qrCodeOptions: { errorCorrectionLevel: 'M', width: 200 }

Follow patterns from config/auth.ts:
- Load from environment variables with dotenv
- Provide sensible defaults
- Validate with Joi schema
- Export validated config object

Include TypeScript interface for type safety.
```

**Result:** Configuration file with environment loading, validation, defaults, and type safety matching existing config patterns.

### Scenario 3: Creating Data Model

**Plan Step:** Create Mongoose model for 2FA settings

**Using /new Command:**

```text
/new src/models/TwoFactorSettings.ts Mongoose model.

Schema fields:
- userId: ObjectId (required, ref: 'User')
- secret: String (required, encrypted)
- enabled: Boolean (default: false)
- backupCodes: [String] (encrypted array)
- createdAt: Date
- lastUsedAt: Date

Follow model patterns from src/models/User.ts:
- Use mongoose.Schema with timestamps option
- Add virtual property 'isActive' (enabled && secret exists)
- Add instance method: verifyAndUpdateLastUsed(token)
- Add static method: findByUserId(userId)
- Export as Mongoose model

Include TypeScript interface ITwoFactorSettings.
```

**Result:** Complete Mongoose model with schema, virtuals, methods, statics, and TypeScript interface following project patterns.

These scenarios show file generation handling diverse file types while maintaining consistency with existing codebase patterns.

> [!IMPORTANT]
> File generation creates files that look complete but may have subtle integration issues. Always run tests immediately after accepting generated files to catch type mismatches or missing dependencies.

---

**Previous:** [Section 2: Inline Chat and Edit Agent - Controlled Code Modification](./02-edit-mode-controlled-modification.md)  
**Next:** [Section 4: Inline Suggestions - Real-Time Completions](./04-inline-copilot-line-level-suggestions.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
