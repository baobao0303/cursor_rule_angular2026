#!/bin/bash
# Install Global Rules for Cursor

echo "🌍 Installing Global Rules for Cursor"
echo "======================================"

# Check if running from agent-rules directory
if [ ! -d "global-rules" ]; then
    echo "❌ Error: global-rules directory not found"
    echo "   Please run this from the agent-rules repository root"
    exit 1
fi

# Determine global rules directory based on OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    CURSOR_RULES_DIR="$HOME/.cursor/rules"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    CURSOR_RULES_DIR="$HOME/.cursor/rules"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
    # Windows (Git Bash)
    CURSOR_RULES_DIR="$HOME/.cursor/rules"
else
    echo "❌ Unsupported OS: $OSTYPE"
    exit 1
fi

# Create .cursor/rules directory if it doesn't exist
echo "📁 Creating global rules directory: $CURSOR_RULES_DIR"
mkdir -p "$CURSOR_RULES_DIR"

# Function to add frontmatter to a rule file
add_frontmatter() {
    local source_file="$1"
    local dest_file="$2"
    local rule_name=$(basename "$source_file" .mdc)
    rule_name=$(basename "$rule_name" .md)
    
    # Generate description from first line (title) or filename
    local description=$(head -n 1 "$source_file" | sed 's/^# *//' | sed 's/^#//')
    if [ -z "$description" ] || [ "$description" = "$rule_name" ]; then
        description="$rule_name"
    fi
    
    # Global rules typically apply to all files
    local globs="**/*"
    case "$rule_name" in
        github-issue-creation)
            globs="**/*"
            ;;
        mcp-*)
            globs="**/*"
            ;;
        steipete-mcps)
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
echo "📋 Installing global rule files..."
RULE_COUNT=0

for rule_file in global-rules/*.mdc global-rules/*.md; do
    if [ -f "$rule_file" ]; then
        rule_name=$(basename "$rule_file")
        # Convert .md to .mdc if needed
        if [[ "$rule_name" == *.md ]]; then
            rule_name="${rule_name%.md}.mdc"
        fi
        dest_file="$CURSOR_RULES_DIR/$rule_name"
        
        # Check if file already has frontmatter
        if head -n 1 "$rule_file" | grep -q "^---"; then
            # File already has frontmatter, just copy it (and convert .md to .mdc if needed)
            if [[ "$rule_file" == *.md ]]; then
                cp "$rule_file" "$dest_file"
                # Rename extension in the copied file if needed (content stays the same)
                echo "  ✓ Copied $rule_name (already has frontmatter, converted from .md)"
            else
                cp "$rule_file" "$dest_file"
                echo "  ✓ Copied $rule_name (already has frontmatter)"
            fi
        else
            # Add frontmatter
            add_frontmatter "$rule_file" "$dest_file"
            if [[ "$rule_file" == *.md ]]; then
                echo "  ✓ Installed $rule_name (added frontmatter, converted from .md)"
            else
                echo "  ✓ Installed $rule_name (added frontmatter)"
            fi
        fi
        RULE_COUNT=$((RULE_COUNT + 1))
    fi
done

echo ""
echo "✅ Installation complete! Installed $RULE_COUNT global rule(s) to $CURSOR_RULES_DIR"
echo ""
echo "📋 Next Steps:"
echo "  1. Open Cursor Settings (Cmd/Ctrl + ,)"
echo "  2. Go to 'Rules' section"
echo "  3. Your global rules should appear in the list"
echo "  4. Enable 'Auto-attach' for rules you want to apply automatically"
echo ""
echo "📋 Installed Global Rules:"
echo ""
echo "  github-issue-creation.mdc  - Instructions for creating well-structured GitHub issues"
echo "  mcp-peekaboo-setup.mdc     - Automated setup for Peekaboo vision-enabled MCP server"
echo "  mcp-sync-rule.mdc          - MCP server configuration synchronization across IDEs"
echo "  steipete-mcps.mdc          - Steipete's MCP server configuration guide"
echo ""
echo "Note: Shell scripts (mcp-sync.sh, setup-mcps.sh, terminal-title-wrapper.zsh)"
echo "      are utility scripts and are not installed as rules."
