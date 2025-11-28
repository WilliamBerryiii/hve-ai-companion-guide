---
title: "Insert Mode: Creating New Files and Scaffolding"
description: Use Insert Mode to generate complete new files following your project's patterns and conventions
author: HVE Core Team
ms.date: 2025-11-26
chapter: 8
part: "II"
keywords:
  - insert-mode
  - file-generation
  - scaffolding
  - new-files
  - pattern-following
---

## Insert Mode: Creating New Files and Scaffolding

Insert Mode generates complete new files from your descriptions. While Edit Mode modifies existing code, Insert Mode creates fresh implementations following patterns from your codebase. This section shows you how to scaffold services, tests, and configurations that integrate seamlessly with your project.

## What Insert Mode Actually Does

Insert Mode is GitHub Copilot's **new file generation tool**. It creates complete, working files based on your specifications and existing project patterns. No more copying templates or starting from empty files.

**Insert Mode characteristics:**

* **Whole-file generation**: Creates complete files, not fragments
* **Pattern-aware**: Follows conventions from reference files you specify
* **Dependency-smart**: Includes correct imports and library usage
* **Type-complete**: Generates TypeScript types and interfaces
* **Iteration-friendly**: Can regenerate with refined prompts until correct

**When to use Insert Mode:**

* Creating new classes, services, or modules
* Scaffolding test files with multiple test cases
* Generating configuration files with proper structure
* Creating new route handlers or API controllers
* Building data models or database schemas

This is your productivity multiplier when expanding functionality. Insert Mode transforms high-level descriptions into production-ready files that follow your team's conventions.

## Invoking Insert Mode

Three methods start Insert Mode for new file creation. Choose based on your workflow and whether the file already exists.

### Method 1: Built-in /new Command (Recommended)

1. In Copilot Chat, type `/new` with file path
2. Describe file contents and patterns to follow
3. Review generated code
4. Accept or refine with follow-up prompts

> [!NOTE]
> `/new` is a built-in VS Code Copilot command (like `/fix`, `/tests`, `/explain`), not a chatmode or agent. Built-in commands are invoked with slash syntax and don't require agent selection.

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

**When to use:** Starting from implementation plan and file doesn't exist yet. Most explicit and controlled method.

### Method 2: Inline Command in New File

1. Create empty file in VS Code
2. Press `Ctrl+I` (Windows/Linux) or `Cmd+I` (Mac)
3. Describe what file should contain
4. Review generated code, accept or refine

**When to use:** You've already created the empty file and are ready to fill it. Good for quick iterations.

### Method 3: File Explorer Context Menu

1. Right-click on folder in Explorer
2. Select "Copilot > Generate New File"
3. Name file and describe contents
4. Review generated code

**When to use:** Mouse-driven workflow or exploring Insert Mode capabilities. Less common in production workflows.

> [!TIP]
> Always reference similar existing files when using Insert Mode. Copilot follows their patterns, ensuring consistency with your project conventions.

## Writing Effective Insert Mode Prompts

Prompt structure determines output quality. Strong Insert Mode prompts provide complete specifications and clear pattern references.

**Prompt structure for Insert Mode:**

1. **File purpose**: What this file does in the system
2. **Key components**: Classes, functions, methods to include
3. **Patterns to follow**: Reference to existing similar files
4. **Dependencies**: Libraries or imports to use
5. **Constraints**: What NOT to include

### Example: Weak vs Strong Prompts

**Weak Insert prompt:**

```text
Create a service for 2FA
```

**Problems:** What methods? What patterns? What libraries? What export format?

**Strong Insert prompt:**

```text
Create TwoFactorService class following the service pattern from 
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

Let's walk through creating a complete service using Insert Mode, from plan step to working code.

**From Chapter 7 Plan:**

```markdown
Step 1.2: Create TwoFactorService module
- Location: src/services/twoFactorService.ts (new file)
- Research reference: Service pattern from authService.ts
- Methods: generateSecret, generateQRCode, verifyToken, generateBackupCodes
- Export: Singleton instance
```

**Insert Mode Prompt:**

```text
Create src/services/twoFactorService.ts following the service pattern 
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

The generated file is production-ready. It follows the referenced pattern, includes all specified methods, handles errors properly, and exports correctly. This is Insert Mode at its best.

## Reviewing Insert Mode Results

Unlike Edit Mode's diff review, Insert Mode requires **full file review**. You're evaluating an entire file, not just changes.

**Review checklist:**

✅ **Completeness**: All required methods and functions present?  
✅ **Correctness**: Logic matches plan specifications?  
✅ **Pattern consistency**: Follows referenced file patterns closely?  
✅ **Type safety**: TypeScript types correct and complete (no `any`)?  
✅ **Error handling**: Appropriate try/catch blocks and error messages?  
✅ **Imports**: All dependencies imported with correct paths?  
✅ **Documentation**: JSDoc comments clear and accurate?  
✅ **Exports**: Correct export format for your project?

**Common Insert Mode issues to catch:**

* ⚠️ Imports missing or using incorrect paths
* ⚠️ Patterns diverge from reference file structure
* ⚠️ TypeScript types too loose (excessive use of `any`)
* ⚠️ Error handling incomplete or inconsistent
* ⚠️ Method signatures don't match plan specifications
* ⚠️ Missing JSDoc or incorrect documentation

Thorough review prevents integration issues. Catch problems now before testing reveals them later.

## Refining Insert Mode Results

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

## Insert Mode Best Practices

**DO:**

* ✅ Always reference similar existing files for pattern consistency
* ✅ Specify export format explicitly (default, named, singleton)
* ✅ Include all required dependencies in prompt
* ✅ Review entire generated file carefully before accepting
* ✅ Test immediately after creation
* ✅ Refine if patterns don't match project conventions

**DON'T:**

* ❌ Generate files without specifying patterns to follow
* ❌ Accept without reviewing imports and types thoroughly
* ❌ Skip testing the new file
* ❌ Generate multiple files in one prompt (do one at a time)
* ❌ Forget to specify TypeScript types and documentation requirements
* ❌ Use Insert Mode for modifying existing files (use Edit Mode)

These practices ensure Insert Mode accelerates development without sacrificing quality. Pattern references and thorough review are non-negotiable.

## Common Insert Mode Scenarios

Real-world scenarios demonstrate Insert Mode's versatility across different file types.

### Scenario 1: Creating Test File

**Plan Step:** Create unit tests for TwoFactorService

**Insert Prompt:**

```text
Create src/services/__tests__/twoFactorService.test.ts

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

**Insert Prompt:**

```text
Create config/twoFactor.ts configuration file.

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

**Insert Prompt:**

```text
Create src/models/TwoFactorSettings.ts Mongoose model.

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

These scenarios show Insert Mode handling diverse file types while maintaining consistency with existing codebase patterns.

> [!IMPORTANT]
> Insert Mode creates files that look complete but may have subtle integration issues. Always run tests immediately after accepting generated files to catch type mismatches or missing dependencies.

---

**Previous:** [Section 2: Edit Mode - Controlled File Modification](./02-edit-mode-controlled-modification.md)  
**Next:** [Section 4: Inline Copilot - Accelerating Line-Level Coding](./04-inline-copilot-line-level-suggestions.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
