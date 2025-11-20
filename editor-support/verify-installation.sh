#!/bin/bash
# Athōn Editor Support Installation Verification Script

set -e

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║         Athōn Editor Support Verification                      ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $1"
        return 0
    else
        echo -e "${RED}✗${NC} $1 (MISSING)"
        return 1
    fi
}

check_json() {
    if command -v python3 >/dev/null 2>&1; then
        if python3 -m json.tool "$1" >/dev/null 2>&1; then
            echo -e "${GREEN}✓${NC} $1 (valid JSON)"
            return 0
        else
            echo -e "${RED}✗${NC} $1 (invalid JSON)"
            return 1
        fi
    else
        echo -e "${YELLOW}?${NC} $1 (cannot validate - python3 not found)"
        return 0
    fi
}

total=0
passed=0

echo -e "${BLUE}📁 VS Code Extension Files:${NC}"
for file in vscode/athon/package.json vscode/athon/language-configuration.json vscode/athon/syntaxes/athon.tmLanguage.json vscode/athon/snippets/athon.json vscode/athon/README.md; do
    total=$((total + 1))
    if check_file "$file"; then
        passed=$((passed + 1))
    fi
done

echo ""
echo -e "${BLUE}🔍 JSON Validation:${NC}"
for file in vscode/athon/package.json vscode/athon/language-configuration.json vscode/athon/syntaxes/athon.tmLanguage.json vscode/athon/snippets/athon.json; do
    if [ -f "$file" ]; then
        check_json "$file"
    fi
done

echo ""
echo -e "${BLUE}📄 Sublime Text Files:${NC}"
for file in sublime-text/Athon.sublime-syntax; do
    total=$((total + 1))
    if check_file "$file"; then
        passed=$((passed + 1))
    fi
done

echo ""
echo -e "${BLUE}📝 Vim Files:${NC}"
for file in vim/syntax/athon.vim vim/ftdetect/athon.vim; do
    total=$((total + 1))
    if check_file "$file"; then
        passed=$((passed + 1))
    fi
done

echo ""
echo -e "${BLUE}📚 Documentation:${NC}"
for file in README.md INSTALLATION.md; do
    total=$((total + 1))
    if check_file "$file"; then
        passed=$((passed + 1))
    fi
done

echo ""
echo -e "${BLUE}🧪 Test Files:${NC}"
for file in test-syntax.at; do
    total=$((total + 1))
    if check_file "$file"; then
        passed=$((passed + 1))
    fi
done

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "Results: $passed/$total files present"
echo "════════════════════════════════════════════════════════════════"

if [ $passed -eq $total ]; then
    echo -e "${GREEN}✓ All editor support files present and valid!${NC}"
    echo ""
    echo -e "${BLUE}🚀 Installation Instructions:${NC}"
    echo ""
    echo "VS Code:"
    echo "  cp -r vscode/athon ~/.vscode/extensions/athon-language-0.3.0"
    echo "  # Then restart VS Code"
    echo ""
    echo "Sublime Text:"
    echo "  cp sublime-text/Athon.sublime-syntax ~/.config/sublime-text/Packages/User/"
    echo "  # Then restart Sublime Text"
    echo ""
    echo "Vim/Neovim:"
    echo "  mkdir -p ~/.vim/syntax ~/.vim/ftdetect"
    echo "  cp vim/syntax/athon.vim ~/.vim/syntax/"
    echo "  cp vim/ftdetect/athon.vim ~/.vim/ftdetect/"
    echo "  # Then restart Vim"
    echo ""
    echo "Test with: test-syntax.at"
    exit 0
else
    echo -e "${RED}✗ Some editor support files missing or invalid!${NC}"
    exit 1
fi
