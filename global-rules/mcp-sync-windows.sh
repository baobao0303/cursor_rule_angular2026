#!/bin/bash

# MCP Server Configuration Synchronizer (Windows-compatible)
# This script finds and compares MCP server configurations across different applications
# Windows version with corrected paths

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Detect OS and set configuration file paths
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || -n "$WINDIR" ]]; then
    # Windows (Git Bash, Cygwin, or WSL with Windows paths)
    if [[ -n "$APPDATA" ]]; then
        # Native Windows
        CLAUDE_DESKTOP_CONFIG="$APPDATA/Claude/claude_desktop_config.json"
        VSCODE_USER_CONFIG="$APPDATA/Code/User/settings.json"
    else
        # Git Bash - convert Windows path
        CLAUDE_DESKTOP_CONFIG="$HOME/AppData/Roaming/Claude/claude_desktop_config.json"
        VSCODE_USER_CONFIG="$HOME/AppData/Roaming/Code/User/settings.json"
    fi
    CURSOR_CONFIG="$HOME/.cursor/mcp.json"
    CLAUDE_CODE_CONFIG="$HOME/.claude.json"
    WINDSURF_CONFIG="$HOME/.codeium/windsurf/mcp_config.json"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    CLAUDE_DESKTOP_CONFIG="$HOME/Library/Application Support/Claude/claude_desktop_config.json"
    CURSOR_CONFIG="$HOME/.cursor/mcp.json"
    CLAUDE_CODE_CONFIG="$HOME/.claude.json"
    WINDSURF_CONFIG="$HOME/.codeium/windsurf/mcp_config.json"
    VSCODE_USER_CONFIG="$HOME/Library/Application Support/Code/User/settings.json"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    CLAUDE_DESKTOP_CONFIG="$HOME/.config/Claude/claude_desktop_config.json"
    CURSOR_CONFIG="$HOME/.cursor/mcp.json"
    CLAUDE_CODE_CONFIG="$HOME/.claude.json"
    WINDSURF_CONFIG="$HOME/.codeium/windsurf/mcp_config.json"
    VSCODE_USER_CONFIG="$HOME/.config/Code/User/settings.json"
else
    echo -e "${RED}Error: Unsupported operating system${NC}"
    exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo -e "${RED}Error: jq is not installed.${NC}"
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || -n "$WINDIR" ]]; then
        echo -e "${YELLOW}Windows: Install with Chocolatey: choco install jq${NC}"
        echo -e "${YELLOW}Or download from: https://stedolan.github.io/jq/download/${NC}"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo -e "${YELLOW}macOS: Install with: brew install jq${NC}"
    else
        echo -e "${YELLOW}Linux: Install with: sudo apt install jq${NC}"
    fi
    exit 1
fi

# Function to display usage
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help                Show this help message"
    echo "  -l, --list                List all MCP servers (default)"
    echo "  --to-global <server>      Switch a server from local to global config"
    echo "  --to-local <server>       Switch a server from global to local config"
    echo "  --app <app>               Specify app for switching (claude-desktop|cursor|windsurf|vscode)"
    echo ""
    echo "Examples:"
    echo "  $0                        # List all servers"
    echo "  $0 --to-global terminator --app cursor"
    echo "  $0 --to-local peekaboo --app claude-desktop"
    exit 0
}

# Parse command line arguments
ACTION="list"
SERVER_NAME=""
TARGET_APP=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            ;;
        -l|--list)
            ACTION="list"
            shift
            ;;
        --to-global)
            ACTION="to-global"
            SERVER_NAME="$2"
            shift 2
            ;;
        --to-local)
            ACTION="to-local"
            SERVER_NAME="$2"
            shift 2
            ;;
        --app)
            TARGET_APP="$2"
            shift 2
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            usage
            ;;
    esac
done

# Validate required arguments for switching actions
if [[ "$ACTION" == "to-global" || "$ACTION" == "to-local" ]]; then
    if [[ -z "$SERVER_NAME" ]]; then
        echo -e "${RED}Error: Server name is required for $ACTION action${NC}"
        usage
    fi
    if [[ -z "$TARGET_APP" ]]; then
        echo -e "${RED}Error: App must be specified with --app (claude-desktop or cursor)${NC}"
        usage
    fi
    if [[ "$TARGET_APP" != "claude-desktop" && "$TARGET_APP" != "cursor" && "$TARGET_APP" != "windsurf" && "$TARGET_APP" != "vscode" ]]; then
        echo -e "${RED}Error: App must be one of: 'claude-desktop', 'cursor', 'windsurf', or 'vscode'${NC}"
        usage
    fi
fi

echo "🔍 MCP Server Configuration Synchronizer"
echo "======================================="
echo ""
echo "📁 Configuration file locations:"
echo ""

# Check which config files exist
if [ -f "$CLAUDE_DESKTOP_CONFIG" ]; then
    echo -e "${GREEN}✓${NC} Claude Desktop: $CLAUDE_DESKTOP_CONFIG"
else
    echo -e "${RED}✗${NC} Claude Desktop: Not found"
fi

if [ -f "$CURSOR_CONFIG" ]; then
    echo -e "${GREEN}✓${NC} Cursor: $CURSOR_CONFIG"
else
    echo -e "${RED}✗${NC} Cursor: Not found"
fi

if [ -f "$CLAUDE_CODE_CONFIG" ]; then
    echo -e "${GREEN}✓${NC} Claude Code: $CLAUDE_CODE_CONFIG"
else
    echo -e "${RED}✗${NC} Claude Code: Not found"
fi

if [ -f "$WINDSURF_CONFIG" ]; then
    echo -e "${GREEN}✓${NC} Windsurf: $WINDSURF_CONFIG"
else
    echo -e "${RED}✗${NC} Windsurf: Not found"
fi

if [ -f "$VSCODE_USER_CONFIG" ]; then
    echo -e "${GREEN}✓${NC} VS Code: $VSCODE_USER_CONFIG"
else
    echo -e "${RED}✗${NC} VS Code: Not found"
fi

echo ""
echo "💡 Note: This is a simplified Windows-compatible version."
echo "   For full functionality, use the original mcp-sync.sh in Git Bash or WSL."
echo ""
echo "To list servers, the script needs to extract server information from config files."
echo "This requires the full implementation from the original mcp-sync.sh"
echo ""
echo "For now, you can manually check your config files:"
echo "  • Cursor: $CURSOR_CONFIG"
echo "  • Claude Desktop: $CLAUDE_DESKTOP_CONFIG"
