# Install Project Rules for Cursor

Write-Host "🎯 Installing Project Rules for Cursor"
Write-Host "=========================================="
Write-Host ""

# Check if running from agent-rules directory
if (-not (Test-Path "project-rules")) {
    Write-Host "❌ Error: project-rules directory not found"
    Write-Host "   Please run this from the agent-rules repository root"
    exit 1
}

# Get the current working directory (project root)
$projectRoot = (Get-Location).Path
$cursorRulesDir = Join-Path $projectRoot ".cursor" "rules"

# Create .cursor/rules directory if it doesn't exist
Write-Host "📁 Creating .cursor/rules directory..."
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
    
    # Determine glob pattern based on rule name
    $globs = "**/*"
    switch -Wildcard ($ruleName) {
        "commit*" { $globs = "**/*.{ts,js,tsx,jsx,py,java,go,rs}" }
        "bug-fix" { $globs = "**/*.{ts,js,tsx,jsx,py,java,go,rs}" }
        "pr-review" { $globs = "**/*.{ts,js,tsx,jsx,py,java,go,rs}" }
        "analyze-issue" { $globs = "**/*.{ts,js,tsx,jsx,py,java,go,rs}" }
        "check" { $globs = "**/*.{ts,js,tsx,jsx,py,java,go,rs}" }
        "clean" { $globs = "**/*.{ts,js,tsx,jsx,py,java,go,rs}" }
        "code-analysis" { $globs = "**/*.{ts,js,tsx,jsx,py,java,go,rs}" }
        "add-to-changelog" { $globs = "**/*.{md,mdc,txt}" }
        "create-docs" { $globs = "**/*.{md,mdc,txt}" }
        "update-docs" { $globs = "**/*.{md,mdc,txt}" }
        "mermaid" { $globs = "**/*.{md,mdc,txt}" }
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
Write-Host "📋 Installing rule files..."
$ruleCount = 0
Get-ChildItem -Path "project-rules" -Filter "*.mdc" | ForEach-Object {
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

Write-Host ""
Write-Host "✅ Installation complete! Installed $ruleCount rule(s) to .cursor/rules/"
Write-Host ""
Write-Host "📋 Next Steps:"
Write-Host "  1. Open Cursor Settings (Cmd/Ctrl + ,)"
Write-Host "  2. Go to 'Rules' section"
Write-Host "  3. Your rules should appear in the list"
Write-Host "  4. Enable 'Auto-attach' for rules you want to apply automatically"
Write-Host ""
Write-Host "📋 Available Rules:"
Write-Host ""
Write-Host "Git & GitHub:"
Write-Host "  commit.mdc             - Create well-formatted commits with conventional commit messages"
Write-Host "  commit-fast.mdc        - Generate 3 commit message suggestions and auto-use the first one"
Write-Host "  bug-fix.mdc            - Streamline bug fixing workflow from issue creation to pull request"
Write-Host "  pr-review.mdc          - Comprehensive pull request review from multiple perspectives"
Write-Host "  analyze-issue.mdc      - Fetch GitHub issue details and create implementation specification"
Write-Host ""
Write-Host "Code Quality:"
Write-Host "  check.mdc              - Perform comprehensive code quality and security checks"
Write-Host "  clean.mdc              - Fix all code formatting and quality issues in the entire codebase"
Write-Host "  code-analysis.mdc      - Perform advanced code analysis with multiple inspection options"
Write-Host ""
Write-Host "Documentation:"
Write-Host "  add-to-changelog.mdc   - Update the project's CHANGELOG.md file with a new entry"
Write-Host "  create-docs.mdc        - Create comprehensive documentation for components or features"
Write-Host "  mermaid.mdc            - Generate Mermaid diagrams for visualizing code structure"
Write-Host ""
Write-Host "Development Workflow:"
Write-Host "  implement-task.mdc     - Approach task implementation methodically with planning"
Write-Host "  context-prime.mdc      - Prime Claude with comprehensive project understanding"
Write-Host "  five.mdc               - Use Five Whys root cause analysis to understand problems"
Write-Host ""
Write-Host "Automation & Meta:"
Write-Host "  create-command.mdc     - Guide for creating new custom Claude commands"
Write-Host "  continuous-improvement.mdc - Systematic approach for improving AI assistant rules"
Write-Host "  safari-automation.mdc  - Automating Safari interactions for web UI testing"
Write-Host "  screenshot-automation.mdc - AppleScript patterns for automated screenshots"
