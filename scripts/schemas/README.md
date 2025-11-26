---
title: Frontmatter Schema System
description: Centralized JSON Schema system for validating markdown frontmatter across the HVE AI Companion Guide
author: HVE Core Team
ms.date: 2025-11-16
---

Centralized JSON Schema system for validating markdown frontmatter across the HVE AI Companion Guide.

## Architecture Overview

This schema system provides standardized frontmatter validation using JSON Schema Draft 2020-12 and PowerShell integration.

**Directory Structure:**

```text
scripts/schemas/
├── README.md                           # This documentation
├── frontmatter-base.schema.json        # Base schema with common fields
├── validation-config.json              # Pattern-to-schema mapping configuration
├── definitions/
│   └── common-fields.json              # Reusable field definitions
└── content-types/
    ├── chapter-content.schema.json     # Chapter content validation
    ├── workflow-guide.schema.json      # Workflow documentation validation
    ├── methodology-documentation.schema.json  # RPI patterns and methodologies
    ├── conceptual-guide.schema.json    # Conceptual README validation
    ├── section-introduction.schema.json # Section about.md validation
    ├── landing-page.schema.json        # Main landing page validation
    ├── community-file.schema.json      # Community files (CONTRIBUTING.md, etc.)
    ├── devcontainer-doc.schema.json    # DevContainer documentation validation
    ├── chatmode.schema.json            # Chat mode definition validation
    ├── instruction.schema.json         # Instruction file validation
    └── prompt.schema.json              # Prompt template validation
```

## JSON Schema Format

All schemas follow **JSON Schema Draft 2020-12** specification.

**Base Schema Structure:**

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://hve-ai-companion-guide/schemas/content-types/example.schema.json",
  "title": "Example Frontmatter",
  "description": "Schema description",
  "type": "object",
  "properties": {
    "title": {
      "type": "string",
      "minLength": 1,
      "maxLength": 200
    }
  },
  "required": ["title"],
  "additionalProperties": false
}
```

**Key Schema Fields:**

* **$schema**: JSON Schema version identifier
* **$id**: Unique schema identifier (URL-based)
* **title**: Human-readable schema name
* **description**: Schema purpose and application
* **type**: Always "object" for frontmatter
* **properties**: Field definitions with validation rules
* **required**: Array of mandatory field names
* **additionalProperties**: Set to `false` to prevent unknown fields

## Validation Configuration

`validation-config.json` maps file patterns to schema requirements.

**Configuration Structure:**

```json
{
  "rules": [
    {
      "name": "chapter-content",
      "description": "Chapter content in parts directory",
      "pattern": "docs/part\\d+/.+\\.md$",
      "schema": "content-types/chapter-content.schema.json",
      "requiredFields": ["title", "description", "author", "date", "chapter", "part", "keywords"],
      "footerRequired": true,
      "dateField": "date",
      "datePattern": "^\\d{4}-\\d{2}-\\d{2}$",
      "titlePattern": "^Chapter \\d+: .+$"
    }
  ]
}
```

**Configuration Fields:**

* **name**: Rule identifier
* **description**: Rule purpose
* **pattern**: Regex for matching file paths (relative from repository root)
* **excludePattern**: Optional regex to exclude specific files
* **schema**: Path to JSON Schema file (relative to `scripts/schemas/`)
* **requiredFields**: Array of mandatory frontmatter fields
* **suggestedFields**: Array of optional recommended fields
* **footerRequired**: Boolean indicating footer requirement
* **dateField**: Field name for date validation
* **datePattern**: Regex pattern for date format validation
* **titlePattern**: Regex pattern for title format validation
* **prohibitedPatterns**: Array of regex patterns that must NOT appear in content

## Schema Composition with $ref

Reuse common field definitions using JSON Schema `$ref`.

**Common Field Definitions** (`definitions/common-fields.json`):

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://hve-ai-companion-guide/schemas/definitions/common-fields.json",
  "description": "Reusable field definitions for frontmatter schemas",
  "$defs": {
    "title": {
      "type": "string",
      "minLength": 1,
      "maxLength": 200
    }
  }
}
```

**Using $ref in Content-Type Schemas:**

```json
{
  "properties": {
    "title": {
      "$ref": "../definitions/common-fields.json#/$defs/title",
      "description": "Override description for this context"
    }
  }
}
```

**Benefits:**

* Ensures consistency across content types
* Single source of truth for common fields
* Easier maintenance when updating validation rules

## Adding New Content Types

Follow these steps to add a new content type:

### Step 1: Create Schema File

Create `scripts/schemas/content-types/your-type.schema.json`:

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://hve-ai-companion-guide/schemas/content-types/your-type.schema.json",
  "title": "Your Type Frontmatter",
  "description": "Schema for your content type (pattern/location)",
  "type": "object",
  "properties": {
    "title": {
      "$ref": "../definitions/common-fields.json#/$defs/title"
    },
    "yourCustomField": {
      "type": "string",
      "minLength": 5
    }
  },
  "required": ["title", "yourCustomField"],
  "additionalProperties": false,
  "examples": [
    {
      "title": "Example Title",
      "yourCustomField": "example value"
    }
  ]
}
```

### Step 2: Add Validation Rule

Update `scripts/schemas/validation-config.json`:

```json
{
  "rules": [
    {
      "name": "your-type",
      "description": "Your content type description",
      "pattern": "path/pattern/.+\\.md$",
      "schema": "content-types/your-type.schema.json",
      "requiredFields": ["title", "yourCustomField"],
      "footerRequired": true,
      "dateField": "date",
      "datePattern": "^\\d{4}-\\d{2}-\\d{2}$"
    }
  ]
}
```

### Step 3: Test Validation

Run the validation script to verify your schema:

```powershell
.\scripts\linting\Validate-MarkdownFrontmatter.ps1 -Path "path/to/test/file.md"
```

## PowerShell Integration

The validation script (`Validate-MarkdownFrontmatter.ps1`) uses a **hybrid approach**:

1. **Schema-driven validation** (primary): Loads validation rules from `validation-config.json`
2. **Native PowerShell validation**: Implements validation logic without external JSON Schema libraries
3. **Backward compatibility**: Maintains existing validation behavior as fallback

**Integration Architecture:**

```powershell
# Load validation configuration
$config = Get-Content "scripts/schemas/validation-config.json" | ConvertFrom-Json

# Match file to content type
$rule = $config.rules | Where-Object { $file.FullName -match $_.pattern }

# Validate required fields
foreach ($field in $rule.requiredFields) {
    if (-not $frontmatter.ContainsKey($field)) {
        # Report validation error
    }
}

# Validate field patterns
if ($rule.titlePattern -and $frontmatter.title -notmatch $rule.titlePattern) {
    # Report pattern validation error
}
```

**Why Hybrid Approach:**

* **Zero external dependencies**: No PowerShell Gallery modules required
* **Native validation**: PowerShell can validate patterns, types, and constraints directly
* **Schema documentation**: JSON Schema provides clear, standard-based documentation
* **Future extensibility**: Easy to add external validator if needed

## Troubleshooting

### Schema Validation Fails

**Symptom**: Validation script reports schema-related errors

**Solutions:**

1. **Verify JSON syntax**: Use a JSON validator to check schema files
2. **Check $ref paths**: Ensure relative paths are correct (`../definitions/common-fields.json`)
3. **Validate schema structure**: Confirm `$schema`, `$id`, and `type` fields are present

### Pattern Not Matching Files

**Symptom**: Files aren't validated with expected schema

**Solutions:**

1. **Test regex pattern**: Use PowerShell to test pattern against file paths

   ```powershell
   "docs/workflows/example.md" -match "docs/workflows/.+\.md$"
   ```

2. **Check path format**: Patterns match relative paths from repository root
3. **Review excludePattern**: Ensure exclusion patterns aren't preventing matches

### Missing Required Fields

**Symptom**: Validation fails for existing frontmatter

**Solutions:**

1. **Check field names**: Verify exact spelling and capitalization
2. **Review schema requirements**: Confirm which fields are in `required` array
3. **Check validation config**: Ensure `requiredFields` matches schema requirements

### $ref Resolution Errors

**Symptom**: Schema composition with $ref fails

**Solutions:**

1. **Verify file paths**: Ensure `common-fields.json` exists at specified path
2. **Check JSON pointer**: Confirm `#/$defs/fieldName` syntax is correct
3. **Validate definition exists**: Ensure referenced field is defined in `$defs`

## Schema Maintenance

### Updating Common Fields

1. Edit `scripts/schemas/definitions/common-fields.json`
2. Update field definition in `$defs` section
3. Changes automatically apply to all schemas using `$ref`

### Modifying Validation Rules

1. Edit `scripts/schemas/validation-config.json`
2. Update rule properties (pattern, requiredFields, etc.)
3. No code changes required in PowerShell script

### Adding New Field Definitions

1. Add new field to `definitions/common-fields.json` in `$defs`
2. Reference in content-type schemas using `$ref`
3. Test with validation script

## Best Practices

* **Use $ref for common fields**: Maintain consistency and reduce duplication
* **Provide examples**: Include realistic examples in schema files
* **Document patterns clearly**: Add descriptions to validation rules
* **Test incrementally**: Validate schemas immediately after creation
* **Keep patterns specific**: Use precise regex to avoid unintended matches
* **Set additionalProperties: false**: Prevent unknown fields in frontmatter

## References

* [JSON Schema Draft 2020-12](https://json-schema.org/draft/2020-12/json-schema-core.html) - Official specification
* [Understanding JSON Schema](https://json-schema.org/understanding-json-schema/) - Comprehensive guide
* [JSON Schema Validator](https://www.jsonschemavalidator.net/) - Online validation tool
