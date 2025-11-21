#!/bin/bash
# Rebuild Athōn VS Code Extension
# Quick rebuild script for development

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo ""
echo -e "${BOLD}🔄 Rebuilding Athōn Extension...${NC}"
echo ""

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Run the build script
"$SCRIPT_DIR/build-vscode-extension.sh"

# Check if we should auto-install
if [ "$1" == "--install" ] || [ "$1" == "-i" ]; then
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}Installing Extension${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    # Uninstall old version
    echo -e "${BLUE}Uninstalling old version...${NC}"
    code --uninstall-extension athon-lang.athon-language 2>/dev/null || true
    
    # Install new version
    echo -e "${BLUE}Installing new version...${NC}"
    code --install-extension "$SCRIPT_DIR/build/athon-language-latest.vsix"
    
    echo ""
    echo -e "${GREEN}✓${NC} Extension installed!"
    echo ""
    echo -e "${BOLD}Restart VS Code to activate the new version.${NC}"
    echo ""
fi

echo ""
echo -e "${GREEN}Done! 🚀${NC}"
echo ""
