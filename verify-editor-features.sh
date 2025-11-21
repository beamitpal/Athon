#!/bin/bash
# Verify Athōn Editor Features Installation

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo "🔍 Verifying Athōn Editor Features"
echo ""

# Check VS Code extension
echo -e "${BLUE}Checking VS Code Extension...${NC}"
if [ -d "$HOME/.vscode/extensions/athon-language-0.4.0" ]; then
    echo -e "${GREEN}✓${NC} Extension directory exists"
    
    # Check required files
    if [ -f "$HOME/.vscode/extensions/athon-language-0.4.0/package.json" ]; then
        echo -e "${GREEN}✓${NC} package.json exists"
    else
        echo -e "${RED}✗${NC} package.json missing"
    fi
    
    if [ -f "$HOME/.vscode/extensions/athon-language-0.4.0/syntaxes/athon.tmLanguage.json" ]; then
        echo -e "${GREEN}✓${NC} Syntax file exists"
    else
        echo -e "${RED}✗${NC} Syntax file missing"
    fi
    
    if [ -f "$HOME/.vscode/extensions/athon-language-0.4.0/snippets/athon.json" ]; then
        echo -e "${GREEN}✓${NC} Snippets file exists"
    else
        echo -e "${RED}✗${NC} Snippets file missing"
    fi
    
    if [ -f "$HOME/.vscode/extensions/athon-language-0.4.0/icons/athon-logo.png" ]; then
        echo -e "${GREEN}✓${NC} Icon file exists"
    else
        echo -e "${YELLOW}⚠${NC} Icon file missing (optional)"
    fi
else
    echo -e "${RED}✗${NC} Extension not installed"
    echo -e "${YELLOW}Run: cd editor-support && ./install-editor-support.sh${NC}"
fi

echo ""

# Check formatter
echo -e "${BLUE}Checking Formatter...${NC}"
if [ -f "$HOME/.local/bin/athon-format.py" ]; then
    echo -e "${GREEN}✓${NC} Formatter installed at ~/.local/bin/"
elif [ -f "editor-support/athon-format.py" ]; then
    echo -e "${GREEN}✓${NC} Formatter exists in editor-support/"
else
    echo -e "${RED}✗${NC} Formatter not found"
fi

if [ -f "./athon-fmt" ]; then
    echo -e "${GREEN}✓${NC} CLI formatter (athon-fmt) exists"
else
    echo -e "${RED}✗${NC} CLI formatter missing"
fi

echo ""

# Check test file
echo -e "${BLUE}Checking Test Files...${NC}"
if [ -f "test-editor-features.at" ]; then
    echo -e "${GREEN}✓${NC} Test file exists"
else
    echo -e "${YELLOW}⚠${NC} Test file missing"
fi

echo ""

# Test formatter
echo -e "${BLUE}Testing Formatter...${NC}"
if [ -f "editor-support/athon-format.py" ]; then
    echo 'fn main(){let x=42;}' | python3 editor-support/athon-format.py --stdin > /tmp/test_format.out 2>&1
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓${NC} Formatter works"
        echo -e "${BLUE}  Input:${NC}  fn main(){let x=42;}"
        echo -e "${BLUE}  Output:${NC} $(cat /tmp/test_format.out)"
    else
        echo -e "${RED}✗${NC} Formatter failed"
    fi
else
    echo -e "${YELLOW}⚠${NC} Formatter not found, skipping test"
fi

echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${BLUE}Next Steps:${NC}"
echo ""
echo "1. Open VS Code:"
echo -e "   ${GREEN}code test-editor-features.at${NC}"
echo ""
echo "2. Check syntax highlighting:"
echo "   - Keywords should be colored (fn, let, if, type, trait, impl)"
echo "   - Types should be colored (int, bool, string)"
echo "   - Comments should be gray"
echo ""
echo "3. Test snippets:"
echo "   - Type 'fn' and press Tab"
echo "   - Should expand to function template"
echo ""
echo "4. Format code:"
echo -e "   ${GREEN}./athon-fmt -w test-editor-features.at${NC}"
echo ""
echo "If features don't work, see: EDITOR_TROUBLESHOOTING.md"
echo ""
