#!/bin/bash
# Install Athōn VS Code Extension from VSIX

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo ""
echo -e "${BOLD}📦 Installing Athōn VS Code Extension${NC}"
echo ""

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
VSIX_FILE="$SCRIPT_DIR/build/athon-language-latest.vsix"

# Check if VSIX exists
if [ ! -f "$VSIX_FILE" ]; then
    echo -e "${BLUE}VSIX not found. Building extension...${NC}"
    echo ""
    "$SCRIPT_DIR/build-vscode-extension.sh"
    echo ""
fi

# Uninstall old version
echo -e "${BLUE}Removing old version (if exists)...${NC}"
code --uninstall-extension athon-lang.athon-language 2>/dev/null || true

# Install new version
echo -e "${BLUE}Installing extension...${NC}"
code --install-extension "$VSIX_FILE"

echo ""
echo -e "${GREEN}✓${NC} Extension installed successfully!"
echo ""
echo -e "${BOLD}Next steps:${NC}"
echo "1. Restart VS Code (close all windows)"
echo "2. Wait 5 seconds"
echo "3. Reopen VS Code"
echo "4. Open a .at file to test"
echo ""
echo -e "${CYAN}Test with: code test-editor-features.at${NC}"
echo ""
