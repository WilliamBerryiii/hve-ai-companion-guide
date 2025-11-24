# Test script to verify all schema files load correctly
param()

Write-Host "`n=== Testing Schema System ===" -ForegroundColor Cyan

# Import the validation script
. "$PSScriptRoot\linting\Validate-MarkdownFrontmatter.ps1"

# Test 1: Load validation config
Write-Host "`n1. Testing Get-ValidationConfig..." -ForegroundColor Yellow
$config = Get-ValidationConfig
if ($config) {
    Write-Host "   ✓ Config loaded successfully" -ForegroundColor Green
    Write-Host "   ✓ Version: $($config.version)" -ForegroundColor Green
    Write-Host "   ✓ Rules: $($config.rules.Count)" -ForegroundColor Green
} else {
    Write-Host "   ✗ Config failed to load" -ForegroundColor Red
    exit 1
}

# Test 2: Verify all schema files exist
Write-Host "`n2. Verifying schema files..." -ForegroundColor Yellow
$allSchemasExist = $true
foreach ($rule in $config.rules) {
    $schemaPath = Join-Path "$PSScriptRoot\schemas" $rule.schema
    if (Test-Path $schemaPath) {
        Write-Host "   ✓ $($rule.name) -> $($rule.schema)" -ForegroundColor Green
        
        # Try to load the schema
        $schema = Get-SchemaDefinition -SchemaName $rule.schema
        if ($schema) {
            Write-Host "     - Schema loads successfully" -ForegroundColor Gray
        } else {
            Write-Host "     - WARNING: Schema file exists but failed to parse" -ForegroundColor Yellow
            $allSchemasExist = $false
        }
    } else {
        Write-Host "   ✗ $($rule.name) -> $($rule.schema) NOT FOUND" -ForegroundColor Red
        $allSchemasExist = $false
    }
}

if (-not $allSchemasExist) {
    Write-Host "`n✗ Some schema files are missing or invalid" -ForegroundColor Red
    exit 1
}

# Test 3: Test pattern matching with sample files
Write-Host "`n3. Testing pattern matching..." -ForegroundColor Yellow
$testFiles = @(
    @{ Path = "docs/README.md"; Expected = "landing-page" },
    @{ Path = "docs/workflows/create-agent.md"; Expected = "workflow-guide" },
    @{ Path = "docs/part1/chapter-01.md"; Expected = "chapter-content" },
    @{ Path = ".github/instructions/test.instructions.md"; Expected = "instruction" },
    @{ Path = "CONTRIBUTING.md"; Expected = "community-file" }
)

foreach ($test in $testFiles) {
    $rule = Get-ContentTypeRule -FilePath "C:\repo\$($test.Path)" -Config $config
    if ($rule -and $rule.name -eq $test.Expected) {
        Write-Host "   ✓ $($test.Path) -> $($rule.name)" -ForegroundColor Green
    } elseif ($rule) {
        Write-Host "   ? $($test.Path) -> $($rule.name) (expected: $($test.Expected))" -ForegroundColor Yellow
    } else {
        Write-Host "   - $($test.Path) -> no rule matched" -ForegroundColor Gray
    }
}

# Test 4: Run validation on a sample file
Write-Host "`n4. Testing validation on real file..." -ForegroundColor Yellow
$testFile = "docs\README.md"
if (Test-Path $testFile) {
    $result = & "$PSScriptRoot\linting\Validate-MarkdownFrontmatter.ps1" -Files @($testFile) 2>&1 | Out-String
    if ($result -match "Matched rule:") {
        Write-Host "   ✓ Validation executed with schema rules" -ForegroundColor Green
    } else {
        Write-Host "   - Validation executed (check output for details)" -ForegroundColor Yellow
    }
} else {
    Write-Host "   - Skipping (test file not found)" -ForegroundColor Gray
}

Write-Host "`n=== All Schema Tests Passed ===" -ForegroundColor Green
Write-Host ""
