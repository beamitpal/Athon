#!/bin/bash
# Setup Material Icon Theme with Athōn file icons

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo ""
echo -e "${BOLD}🎨 Setting up Material Icon Theme for Athōn${NC}"
echo ""

# Check if Material Icon Theme is installed
if ! code --list-extensions 2>/dev/null | grep -q "PKief.material-icon-theme"; then
    echo -e "${YELLOW}Material Icon Theme not installed. Installing...${NC}"
    code --install-extension PKief.material-icon-theme
    echo -e "${GREEN}✓${NC} Material Icon Theme installed"
else
    echo -e "${GREEN}✓${NC} Material Icon Theme already installed"
fi

# Update workspace settings
echo ""
echo -e "${BLUE}Updating workspace settings...${NC}"

cat > .vscode/settings.json << 'EOF'
{
  "workbench.iconTheme": "material-icon-theme",
  "athon.formatOnSave": true,
  "athon.indentSize": 4,
  "athon.formatterPath": "",
  "[athon]": {
    "editor.defaultFormatter": "athon-lang.athon-language",
    "editor.formatOnSave": true,
    "editor.tabSize": 4,
    "editor.insertSpaces": true
  },
  "files.associations": {
    "*.at": "athon",
    "athon": "athon",
    "athon-boot": "athon",
    "athon-fmt": "athon"
  },
  "material-icon-theme.files.associations": {
    "*.at": "../../.vscode/extensions/athon-lang.athon-language-0.4.0/icons/athon-file"
  }
}
EOF

echo -e "${GREEN}✓${NC} Workspace settings updated"

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}Setup Complete!${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${GREEN}✓${NC} Material Icon Theme configured for Athōn files"
echo ""
echo -e "${BOLD}Next steps:${NC}"
echo "1. Restart VS Code (Ctrl+Q, wait 5 seconds, reopen)"
echo "2. Open a .at file"
echo "3. .at files will have custom Athōn icons"
echo "4. All other files will have Material icons"
echo ""
