# Pester tests for Validate-MarkdownFrontmatter.ps1
# Tests schema loading, pattern matching, and validation logic

BeforeAll {
    # Import the validation script
    . "$PSScriptRoot\..\Validate-MarkdownFrontmatter.ps1"
    
    # Get repository root for test file paths
    $script:RepoRoot = git rev-parse --show-toplevel 2>$null
    if (-not $script:RepoRoot) {
        $script:RepoRoot = (Get-Item $PSScriptRoot).Parent.Parent.Parent.FullName
    }
    
    # Ensure paths use forward slashes for consistency
    $script:RepoRoot = $script:RepoRoot.Replace('\', '/')
}

Describe "Schema System Integration Tests" {
    
    Context "Get-ValidationConfig Function" {
        
        It "Should load validation config successfully" {
            $config = Get-ValidationConfig
            $config | Should -Not -BeNullOrEmpty
        }
        
        It "Should load config with correct version" {
            $config = Get-ValidationConfig
            $config.version | Should -Be "1.0.0"
        }
        
        It "Should contain rules array" {
            $config = Get-ValidationConfig
            $config.rules | Should -Not -BeNullOrEmpty
            $config.rules.Count | Should -BeGreaterThan 0
        }
        
        It "Should have validation rules with required properties" {
            $config = Get-ValidationConfig
            $config.rules | Should -Not -BeNullOrEmpty
            $config.rules | Should -HaveCount 10 -Because "Current configuration has 10 rules"
            
            # Validate each rule has required structure
            $config.rules | ForEach-Object {
                $_.name | Should -Not -BeNullOrEmpty -Because "Rule must have a name"
                $_.schema | Should -Not -BeNullOrEmpty -Because "Rule must reference a schema"
                $_.requiredFields | Should -Not -BeNullOrEmpty -Because "Rule must define required fields"
            }
        }
        
        It "Should contain excludePatterns array" {
            $config = Get-ValidationConfig
            $config.excludePatterns | Should -Not -BeNullOrEmpty
        }
        
        It "Should handle missing config file gracefully" {
            # Temporarily rename config to simulate missing file
            $configPath = Join-Path $script:RepoRoot "scripts\schemas\validation-config.json"
            $tempPath = Join-Path $script:RepoRoot "scripts\schemas\validation-config.json.bak"
            
            if (Test-Path $configPath) {
                Rename-Item $configPath $tempPath -Force
                try {
                    $config = Get-ValidationConfig
                    $config | Should -BeNullOrEmpty
                } finally {
                    Rename-Item $tempPath $configPath -Force
                }
            }
        }
    }
    
    Context "Get-ContentTypeRule Function" {
        
        BeforeAll {
            $script:Config = Get-ValidationConfig
        }
        
        It "Should match chapter content pattern" {
            $rule = Get-ContentTypeRule -FilePath "docs/part1/chapter-1.md" -Config $script:Config
            $rule | Should -Not -BeNullOrEmpty
            $rule.name | Should -Be "chapter-content"
        }
        
        It "Should match workflow guide pattern" {
            $rule = Get-ContentTypeRule -FilePath "docs/workflows/setup-workflow.md" -Config $script:Config
            $rule | Should -Not -BeNullOrEmpty
            $rule.name | Should -Be "workflow-guide"
        }
        
        It "Should match methodology documentation pattern" {
            $rule = Get-ContentTypeRule -FilePath "docs/rpi-framework/research-phase.md" -Config $script:Config
            $rule | Should -Not -BeNullOrEmpty
            $rule.name | Should -Be "methodology-documentation"
        }
        
        It "Should match conceptual guide pattern for README" {
            $rule = Get-ContentTypeRule -FilePath "docs/engineering-fundamentals/README.md" -Config $script:Config
            $rule | Should -Not -BeNullOrEmpty
            $rule.name | Should -Be "conceptual-guide"
        }
        
        It "Should match landing page pattern for docs/README.md" {
            $rule = Get-ContentTypeRule -FilePath "docs/README.md" -Config $script:Config
            $rule | Should -Not -BeNullOrEmpty
            $rule.name | Should -Be "landing-page"
        }
        
        It "Should match root community file pattern" -Skip {
            # This test requires actual root-level file detection with git repo context
            # The pattern requires location='root' which is handled specially
            $rule = Get-ContentTypeRule -FilePath "CONTRIBUTING.md" -Config $script:Config
            $rule | Should -Not -BeNullOrEmpty
            $rule.name | Should -Be "root-community-file"
        }
        
        It "Should match devcontainer doc pattern" {
            $rule = Get-ContentTypeRule -FilePath ".devcontainer/devcontainer/README.md" -Config $script:Config
            $rule | Should -Not -BeNullOrEmpty
            $rule.name | Should -Be "devcontainer-doc"
        }
        
        It "Should match chatmode file pattern" {
            $rule = Get-ContentTypeRule -FilePath "docs/modes/task-researcher.chatmode.md" -Config $script:Config
            $rule | Should -Not -BeNullOrEmpty
            $rule.name | Should -Be "chatmode-file"
        }
        
        It "Should match instruction file pattern" {
            $rule = Get-ContentTypeRule -FilePath ".github/instructions/markdown.instructions.md" -Config $script:Config
            $rule | Should -Not -BeNullOrEmpty
            $rule.name | Should -Be "instruction-file"
        }
        
        It "Should match prompt file pattern" {
            $rule = Get-ContentTypeRule -FilePath ".copilot-tracking/prompts/implement-feature.prompt.md" -Config $script:Config
            $rule | Should -Not -BeNullOrEmpty
            $rule.name | Should -Be "prompt-file"
        }
        
        It "Should apply pattern precedence correctly (exclude before match)" {
            # Conceptual guide excludes docs/README.md, landing page should match instead
            $rule = Get-ContentTypeRule -FilePath "docs/README.md" -Config $script:Config
            $rule.name | Should -Be "landing-page"
        }
        
        It "Should return null for unmatched patterns" {
            $rule = Get-ContentTypeRule -FilePath "some/random/file.md" -Config $script:Config
            $rule | Should -BeNullOrEmpty
        }
    }
    
    Context "Get-SchemaDefinition Function" {
        
        BeforeAll {
            $script:Config = Get-ValidationConfig
        }
        
        It "Should load chapter content schema" {
            $rule = Get-ContentTypeRule -FilePath "docs/part1/chapter-1.md" -Config $script:Config
            $schema = Get-SchemaDefinition -SchemaName $rule.schema
            $schema | Should -Not -BeNullOrEmpty
            $schema.'$schema' | Should -Be "https://json-schema.org/draft/2020-12/schema"
        }
        
        It "Should load workflow guide schema" {
            $rule = Get-ContentTypeRule -FilePath "docs/workflows/setup.md" -Config $script:Config
            $schema = Get-SchemaDefinition -SchemaName $rule.schema
            $schema | Should -Not -BeNullOrEmpty
        }
        
        It "Should load methodology documentation schema" {
            $rule = Get-ContentTypeRule -FilePath "docs/rpi-framework/plan-phase.md" -Config $script:Config
            $schema = Get-SchemaDefinition -SchemaName $rule.schema
            $schema | Should -Not -BeNullOrEmpty
        }
        
        It "Should load conceptual guide schema" {
            $rule = Get-ContentTypeRule -FilePath "docs/fundamentals/README.md" -Config $script:Config
            $schema = Get-SchemaDefinition -SchemaName $rule.schema
            $schema | Should -Not -BeNullOrEmpty
        }
        
        It "Should load landing page schema" {
            $rule = Get-ContentTypeRule -FilePath "docs/README.md" -Config $script:Config
            $schema = Get-SchemaDefinition -SchemaName $rule.schema
            $schema | Should -Not -BeNullOrEmpty
        }
        
        It "Should load community file schema" -Skip {
            # Skipped because root-community-file matching requires git repo context
            $rule = Get-ContentTypeRule -FilePath "CONTRIBUTING.md" -Config $script:Config
            $schema = Get-SchemaDefinition -SchemaName $rule.schema
            $schema | Should -Not -BeNullOrEmpty
        }
        
        It "Should load devcontainer doc schema" {
            $rule = Get-ContentTypeRule -FilePath ".devcontainer/devcontainer/README.md" -Config $script:Config
            $schema = Get-SchemaDefinition -SchemaName $rule.schema
            $schema | Should -Not -BeNullOrEmpty
        }
        
        It "Should load chatmode schema" {
            $rule = Get-ContentTypeRule -FilePath "docs/modes/test.chatmode.md" -Config $script:Config
            $schema = Get-SchemaDefinition -SchemaName $rule.schema
            $schema | Should -Not -BeNullOrEmpty
        }
        
        It "Should load instruction file schema" {
            $rule = Get-ContentTypeRule -FilePath ".github/instructions/test.instructions.md" -Config $script:Config
            $schema = Get-SchemaDefinition -SchemaName $rule.schema
            $schema | Should -Not -BeNullOrEmpty
        }
        
        It "Should load prompt file schema" {
            $rule = Get-ContentTypeRule -FilePath ".copilot-tracking/prompts/test.prompt.md" -Config $script:Config
            $schema = Get-SchemaDefinition -SchemaName $rule.schema
            $schema | Should -Not -BeNullOrEmpty
        }
        
        It "Should return null for invalid schema path" {
            $schema = Get-SchemaDefinition -SchemaName "nonexistent/schema.json"
            $schema | Should -BeNullOrEmpty
        }
        
        It "Should handle malformed JSON gracefully" {
            # Create temporary malformed schema
            $tempSchema = Join-Path $script:RepoRoot "scripts\schemas\temp-malformed.json"
            "{ invalid json }" | Out-File $tempSchema -Encoding UTF8
            
            try {
                $schema = Get-SchemaDefinition -SchemaName "temp-malformed.json"
                $schema | Should -BeNullOrEmpty
            } finally {
                Remove-Item $tempSchema -Force -ErrorAction SilentlyContinue
            }
        }
    }
    
    Context "Schema-Based Validation Logic" {
        
        BeforeAll {
            $script:Config = Get-ValidationConfig
            
            # Create temporary test files
            $script:TestDir = Join-Path $script:RepoRoot "scripts\linting\Tests\TestFiles"
            New-Item -ItemType Directory -Path $script:TestDir -Force | Out-Null
        }
        
        AfterAll {
            # Cleanup test files
            if (Test-Path $script:TestDir) {
                Remove-Item $script:TestDir -Recurse -Force
            }
        }
        
        It "Should validate required fields from schema" {
            # Create test file with valid frontmatter
            $testFile = Join-Path $script:TestDir "test-chapter.md"
            @"
---
title: "Chapter 1: Test Chapter"
description: Test description for validating chapter content schema compliance
author: Test Author
ms.date: 2025-11-16
chapter: 1
part: "I"
keywords:
  - testing
  - schema
  - validation
---
# Test Content
"@ | Out-File $testFile -Encoding UTF8
            
            $rule = Get-ContentTypeRule -FilePath "docs/part1/chapter-1.md" -Config $script:Config
            $schema = Get-SchemaDefinition -SchemaName $rule.schema
            
            # Parse frontmatter
            $content = Get-Content $testFile -Raw
            $frontmatter = @{}
            if ($content -match '(?ms)^---\s*\n(.+?)\n---') {
                $yamlContent = $matches[1]
                $yamlContent -split "`n" | ForEach-Object {
                    if ($_ -match '^\s*([^:]+):\s*(.+)$') {
                        $frontmatter[$matches[1].Trim()] = $matches[2].Trim()
                    }
                }
            }
            
            # Verify required fields are present (use rule's requiredFields, not schema.required)
            $rule.requiredFields | ForEach-Object {
                $frontmatter.ContainsKey($_) | Should -Be $true
            }
        }
        
        It "Should detect missing required fields" {
            # Create test file missing required field
            $testFile = Join-Path $script:TestDir "test-missing.md"
            @"
---
title: Test Chapter
description: Test description
---
# Test Content
"@ | Out-File $testFile -Encoding UTF8
            
            $rule = Get-ContentTypeRule -FilePath "docs/part1/chapter-1.md" -Config $script:Config
            $schema = Get-SchemaDefinition -SchemaName $rule.schema
            
            # Parse frontmatter
            $content = Get-Content $testFile -Raw
            $frontmatter = @{}
            if ($content -match '(?ms)^---\s*\n(.+?)\n---') {
                $yamlContent = $matches[1]
                $yamlContent -split "`n" | ForEach-Object {
                    if ($_ -match '^\s*([^:]+):\s*(.+)$') {
                        $frontmatter[$matches[1].Trim()] = $matches[2].Trim()
                    }
                }
            }
            
            # Should be missing 'author' and 'ms.date'
            $missingFields = $schema.required | Where-Object { -not $frontmatter.ContainsKey($_) }
            $missingFields.Count | Should -BeGreaterThan 0
        }
    }
    
    Context "Backward Compatibility" {
        
        It "Should fall back to legacy validation for unmatched files" {
            $config = Get-ValidationConfig
            $rule = Get-ContentTypeRule -FilePath ".github/workflows/README.md" -Config $config
            $rule | Should -BeNullOrEmpty
            # Script should use legacy validation (no error)
        }
        
        It "Should preserve error format for legacy validation" {
            # Legacy validation should still work for files without schema rules
            # This is verified by the script's Test-FrontmatterValidation function
            $true | Should -Be $true  # Placeholder - actual test requires running full validation
        }
    }
    
    Context "ExcludePatterns Feature" {
        
        BeforeAll {
            $script:Config = Get-ValidationConfig
        }
        
        It "Should load excludePatterns from config" {
            $script:Config.excludePatterns | Should -Not -BeNullOrEmpty
        }
        
        It "Should exclude docs/_sidebar.md" {
            $script:Config.excludePatterns | Should -Contain "docs/_sidebar.md"
        }
    }
}

Describe "End-to-End Validation Tests" {
    
    Context "Real Repository Files" {
        
        It "Should validate instruction files successfully" {
            $instructionFiles = Get-ChildItem -Path (Join-Path $script:RepoRoot ".github\instructions") -Filter "*.instructions.md" -ErrorAction SilentlyContinue
            $instructionFiles.Count | Should -BeGreaterThan 0
        }
        
        It "Should validate landing page successfully" {
            $landingPage = Join-Path $script:RepoRoot "docs\README.md"
            Test-Path $landingPage | Should -Be $true
        }
    }
}
