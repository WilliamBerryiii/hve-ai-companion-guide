#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Finds code blocks missing language identifiers in Markdown files.

.DESCRIPTION
    Scans Markdown files for code fence blocks (```) without language identifiers.

.PARAMETER Path
    Path to search for Markdown files. Defaults to docs/part-i and docs/part-ii.

.EXAMPLE
    .\Find-MissingCodeBlockLanguages.ps1

.EXAMPLE
    .\Find-MissingCodeBlockLanguages.ps1 -Path docs/part-i
#>

[CmdletBinding()]
param(
    [string[]]$Path = @("docs/part-i", "docs/part-ii")
)

$issues = @()

foreach ($searchPath in $Path) {
    $mdFiles = Get-ChildItem -Path $searchPath -Filter "*.md" -Recurse -File
    
    foreach ($file in $mdFiles) {
        $lines = Get-Content -Path $file.FullName
        $inCodeBlock = $false
        
        for ($i = 0; $i -lt $lines.Count; $i++) {
            # Match code fence (``` with optional whitespace)
            if ($lines[$i] -match '^\s*```\s*$') {
                if (-not $inCodeBlock) {
                    # Opening fence without language identifier
                    $issues += [PSCustomObject]@{
                        File       = $file.FullName.Replace($PWD.Path, ".").Replace("\", "/")
                        LineNumber = $i + 1
                        Context    = if ($i -gt 0) { $lines[$i - 1].Trim() } else { "" }
                    }
                    $inCodeBlock = $true
                } else {
                    # Closing fence
                    $inCodeBlock = $false
                }
            } elseif ($lines[$i] -match '^\s*```\w+') {
                # Opening fence with language identifier
                $inCodeBlock = $true
            }
        }
    }
}

Write-Host "Found $($issues.Count) code blocks without language identifiers:`n" -ForegroundColor Cyan

# Group by file
$byFile = $issues | Group-Object -Property File | Sort-Object Name

foreach ($fileGroup in $byFile) {
    Write-Host "$($fileGroup.Name) - $($fileGroup.Count) issues" -ForegroundColor Yellow
    foreach ($issue in $fileGroup.Group) {
        Write-Host "  Line $($issue.LineNumber): $($issue.Context)" -ForegroundColor Gray
    }
    Write-Host ""
}

Write-Host "`nTotal: $($issues.Count) code blocks need language identifiers" -ForegroundColor Red
