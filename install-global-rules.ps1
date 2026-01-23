# Install Global Rules for Cursor

Write-Host "🌍 Installing Global Rules for Cursor"
Write-Host "======================================"
Write-Host ""

# Check if running from agent-rules directory
if (-not (Test-Path "global-rules")) {
    Write-Host "❌ Error: global-rules directory not found"
    Write-Host "   Please run this from the agent-rules repository root"
    exit 1
}

# Determine global rules directory (Windows)
$cursorRulesDir = Join-Path $env:USERPROFILE ".cursor" "rules"

# Create .cursor/rules directory if it doesn't exist
Write-Host "📁 Creating global rules directory: $cursorRulesDir"
if (-not (Test-Path $cursorRulesDir)) {
    New-Item -ItemType Directory -Path $cursorRulesDir -Force | Out-Null
}

# Function to add frontmatter to a rule file
function Add-Frontmatter {
    param(
        [string]$SourceFile,
        [string]$DestFile
    )
    
    $ruleName = [System.IO.Path]::GetFileNameWithoutExtension($SourceFile)
    $content = Get-Content $SourceFile -Raw
    
    # Check if file already has frontmatter
    if ($content -match "^---") {
        # File already has frontmatter, just copy it
        Copy-Item $SourceFile $DestFile
        return $false
    }
    
    # Generate description from first line (title) or filename
    $firstLine = (Get-Content $SourceFile -First 1) -replace "^#+\s*", ""
    $description = if ($firstLine -and $firstLine -ne $ruleName) { $firstLine } else { $ruleName }
    
    # Global rules typically apply to all files
    $globs = "**/*"
    switch -Wildcard ($ruleName) {
        "github-issue-creation" { $globs = "**/*" }
        "mcp-*" { $globs = "**/*" }
        "steipete-mcps" { $globs = "**/*" }
        default { $globs = "**/*" }
    }
    
    # Create file with frontmatter
    $frontmatter = @"
---
description: $description
globs: $globs
alwaysApply: false
---

"@
    
    $frontmatter + $content | Set-Content -Path $DestFile -NoNewline
    return $true
}

# Copy and process each rule file
Write-Host "📋 Installing global rule files..."
$ruleCount = 0

Get-ChildItem -Path "global-rules" -Filter "*.mdc" | ForEach-Object {
    $ruleFile = $_.FullName
    $ruleName = $_.Name
    $destFile = Join-Path $cursorRulesDir $ruleName
    
    $addedFrontmatter = Add-Frontmatter -SourceFile $ruleFile -DestFile $destFile
    
    if ($addedFrontmatter) {
        Write-Host "  ✓ Installed $ruleName (added frontmatter)"
    } else {
        Write-Host "  ✓ Copied $ruleName (already has frontmatter)"
    }
    $ruleCount++
}

# Also process .md files and convert to .mdc
Get-ChildItem -Path "global-rules" -Filter "*.md" | ForEach-Object {
    $ruleFile = $_.FullName
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
    $ruleName = "$baseName.mdc"
    $destFile = Join-Path $cursorRulesDir $ruleName
    
    $addedFrontmatter = Add-Frontmatter -SourceFile $ruleFile -DestFile $destFile
    
    if ($addedFrontmatter) {
        Write-Host "  ✓ Installed $ruleName (added frontmatter, converted from .md)"
    } else {
        Write-Host "  ✓ Copied $ruleName (already has frontmatter, converted from .md)"
    }
    $ruleCount++
}

Write-Host ""
Write-Host "✅ Installation complete! Installed $ruleCount global rule(s) to $cursorRulesDir"
Write-Host ""
Write-Host "📋 Next Steps:"
Write-Host "  1. Open Cursor Settings (Cmd/Ctrl + ,)"
Write-Host "  2. Go to 'Rules' section"
Write-Host "  3. Your global rules should appear in the list"
Write-Host "  4. Enable 'Auto-attach' for rules you want to apply automatically"
Write-Host ""
Write-Host "📋 Installed Global Rules:"
Write-Host ""
Write-Host "  github-issue-creation.mdc  - Instructions for creating well-structured GitHub issues"
Write-Host "  mcp-peekaboo-setup.mdc     - Automated setup for Peekaboo vision-enabled MCP server"
Write-Host "  mcp-sync-rule.mdc           - MCP server configuration synchronization across IDEs"
Write-Host "  steipete-mcps.mdc           - Steipete's MCP server configuration guide"
Write-Host ""
Write-Host "Note: Shell scripts (mcp-sync.sh, setup-mcps.sh, terminal-title-wrapper.zsh)"
Write-Host "      are utility scripts and are not installed as rules."
