#!/bin/bash
# Install Project Rules for Cursor

echo "🎯 Installing Project Rules for Cursor"
echo "=========================================="

# Check if running from agent-rules directory
if [ ! -d "project-rules" ]; then
    echo "❌ Error: project-rules directory not found"
    echo "   Please run this from the agent-rules repository root"
    exit 1
fi

# Get the current working directory (project root)
PROJECT_ROOT="$(pwd)"
CURSOR_RULES_DIR="$PROJECT_ROOT/.cursor/rules"

# Create .cursor/rules directory if it doesn't exist
echo "📁 Creating .cursor/rules directory..."
mkdir -p "$CURSOR_RULES_DIR"

# Function to add frontmatter to a rule file
add_frontmatter() {
    local source_file="$1"
    local dest_file="$2"
    local rule_name=$(basename "$source_file" .mdc)
    
    # Generate description from first line (title) or filename
    local description=$(head -n 1 "$source_file" | sed 's/^# *//' | sed 's/^#//')
    if [ -z "$description" ] || [ "$description" = "$rule_name" ]; then
        description="$rule_name"
    fi
    
    # Determine glob pattern based on rule name
    local globs="**/*"
    case "$rule_name" in
        commit*|bug-fix|pr-review|analyze-issue)
            globs="**/*.{ts,js,tsx,jsx,py,java,go,rs}"
            ;;
        check|clean|code-analysis)
            globs="**/*.{ts,js,tsx,jsx,py,java,go,rs}"
            ;;
        add-to-changelog|create-docs|update-docs|mermaid)
            globs="**/*.{md,mdc,txt}"
            ;;
        implement-task|context-prime|five)
            globs="**/*"
            ;;
        *)
            globs="**/*"
            ;;
    esac
    
    # Create file with frontmatter
    {
        echo "---"
        echo "description: $description"
        echo "globs: $globs"
        echo "alwaysApply: false"
        echo "---"
        echo ""
        cat "$source_file"
    } > "$dest_file"
}

# Copy and process each rule file
echo "📋 Installing rule files..."
RULE_COUNT=0
for rule_file in project-rules/*.mdc; do
    if [ -f "$rule_file" ]; then
        rule_name=$(basename "$rule_file")
        dest_file="$CURSOR_RULES_DIR/$rule_name"
        
        # Check if file already has frontmatter
        if head -n 1 "$rule_file" | grep -q "^---"; then
            # File already has frontmatter, just copy it
            cp "$rule_file" "$dest_file"
            echo "  ✓ Copied $rule_name (already has frontmatter)"
        else
            # Add frontmatter
            add_frontmatter "$rule_file" "$dest_file"
            echo "  ✓ Installed $rule_name (added frontmatter)"
        fi
        RULE_COUNT=$((RULE_COUNT + 1))
    fi
done

echo ""
echo "✅ Installation complete! Installed $RULE_COUNT rule(s) to .cursor/rules/"

echo ""
echo "📋 Next Steps:"
echo "  1. Open Cursor Settings (Cmd/Ctrl + ,)"
echo "  2. Go to 'Rules' section"
echo "  3. Your rules should appear in the list"
echo "  4. Enable 'Auto-attach' for rules you want to apply automatically"
echo ""
echo "📋 Available Rules:"
echo ""
echo "Git & GitHub:"
echo "  commit.mdc             - Create well-formatted commits with conventional commit messages"
echo "  commit-fast.mdc        - Generate 3 commit message suggestions and auto-use the first one"
echo "  bug-fix.mdc            - Streamline bug fixing workflow from issue creation to pull request"
echo "  pr-review.mdc          - Comprehensive pull request review from multiple perspectives"
echo "  analyze-issue.mdc      - Fetch GitHub issue details and create implementation specification"
echo ""
echo "Code Quality:"
echo "  check.mdc              - Perform comprehensive code quality and security checks"
echo "  clean.mdc              - Fix all code formatting and quality issues in the entire codebase"
echo "  code-analysis.mdc      - Perform advanced code analysis with multiple inspection options"
echo ""
echo "Documentation:"
echo "  add-to-changelog.mdc   - Update the project's CHANGELOG.md file with a new entry"
echo "  create-docs.mdc        - Create comprehensive documentation for components or features"
echo "  mermaid.mdc            - Generate Mermaid diagrams for visualizing code structure"
echo ""
echo "Development Workflow:"
echo "  implement-task.mdc     - Approach task implementation methodically with planning"
echo "  context-prime.mdc      - Prime Claude with comprehensive project understanding"
echo "  five.mdc               - Use Five Whys root cause analysis to understand problems"
echo ""
echo "Automation & Meta:"
echo "  create-command.mdc     - Guide for creating new custom Claude commands"
echo "  continuous-improvement.mdc - Systematic approach for improving AI assistant rules"
echo "  safari-automation.mdc  - Automating Safari interactions for web UI testing"
echo "  screenshot-automation.mdc - AppleScript patterns for automated screenshots"