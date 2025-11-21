#!/bin/bash
# Athōn Editor Support Uninstallation Script
# Removes syntax highlighting and editor support for VS Code, Sublime Text, and Vim/Neovim

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo ""
echo -e "${BOLD}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║      Athōn Editor Support Uninstallation Script               ║${NC}"
echo -e "${BOLD}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Track removals
REMOVED_COUNT=0
NOT_FOUND_COUNT=0

# Function to print section headers
print_section() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}$1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Confirmation prompt
echo -e "${YELLOW}${BOLD}Warning:${NC} This will remove Athōn editor support from all detected editors."
echo ""
read -p "Are you sure you want to continue? (y/N) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}Uninstallation cancelled.${NC}"
    exit 0
fi

# ============================================================================
# Remove VS Code Support
# ============================================================================
print_section "Removing VS Code Support"

VSCODE_REMOVED=false

# Check common VS Code extension directories
VSCODE_DIRS=(
    "$HOME/.vscode/extensions"
    "$HOME/.vscode-server/extensions"
    "$HOME/Library/Application Support/Code/User/extensions"
)

for dir in "${VSCODE_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        # Find and remove Athōn extensions
        for ext in "$dir"/athon-language-*; do
            if [ -d "$ext" ]; then
                echo -e "${BLUE}Removing: $ext${NC}"
                rm -rf "$ext"
                echo -e "${GREEN}✓${NC} Removed VS Code extension"
                VSCODE_REMOVED=true
                REMOVED_COUNT=$((REMOVED_COUNT + 1))
            fi
        done
    fi
done

if [ "$VSCODE_REMOVED" = false ]; then
    echo -e "${YELLOW}⊘${NC} No VS Code extensions found"
    NOT_FOUND_COUNT=$((NOT_FOUND_COUNT + 1))
fi

# ============================================================================
# Remove Sublime Text Support
# ============================================================================
print_section "Removing Sublime Text Support"

SUBLIME_REMOVED=false

# Check common Sublime Text package directories
SUBLIME_DIRS=(
    "$HOME/.config/sublime-text/Packages/User"
    "$HOME/.config/sublime-text-3/Packages/User"
    "$HOME/Library/Application Support/Sublime Text/Packages/User"
    "$HOME/Library/Application Support/Sublime Text 3/Packages/User"
)

for dir in "${SUBLIME_DIRS[@]}"; do
    if [ -f "$dir/Athon.sublime-syntax" ]; then
        echo -e "${BLUE}Removing: $dir/Athon.sublime-syntax${NC}"
        rm "$dir/Athon.sublime-syntax"
        echo -e "${GREEN}✓${NC} Removed Sublime Text syntax file"
        SUBLIME_REMOVED=true
        REMOVED_COUNT=$((REMOVED_COUNT + 1))
    fi
done

if [ "$SUBLIME_REMOVED" = false ]; then
    echo -e "${YELLOW}⊘${NC} No Sublime Text syntax files found"
    NOT_FOUND_COUNT=$((NOT_FOUND_COUNT + 1))
fi

# ============================================================================
# Remove Vim Support
# ============================================================================
print_section "Removing Vim Support"

VIM_REMOVED=false

if [ -d "$HOME/.vim" ]; then
    # Remove syntax file
    if [ -f "$HOME/.vim/syntax/athon.vim" ]; then
        echo -e "${BLUE}Removing: $HOME/.vim/syntax/athon.vim${NC}"
        rm "$HOME/.vim/syntax/athon.vim"
        echo -e "${GREEN}✓${NC} Removed Vim syntax file"
        VIM_REMOVED=true
    fi
    
    # Remove filetype detection
    if [ -f "$HOME/.vim/ftdetect/athon.vim" ]; then
        echo -e "${BLUE}Removing: $HOME/.vim/ftdetect/athon.vim${NC}"
        rm "$HOME/.vim/ftdetect/athon.vim"
        echo -e "${GREEN}✓${NC} Removed Vim filetype detection"
        VIM_REMOVED=true
    fi
    
    if [ "$VIM_REMOVED" = true ]; then
        REMOVED_COUNT=$((REMOVED_COUNT + 1))
    fi
fi

if [ "$VIM_REMOVED" = false ]; then
    echo -e "${YELLOW}⊘${NC} No Vim support files found"
    NOT_FOUND_COUNT=$((NOT_FOUND_COUNT + 1))
fi

# ============================================================================
# Remove Neovim Support
# ============================================================================
print_section "Removing Neovim Support"

NVIM_REMOVED=false

if [ -d "$HOME/.config/nvim" ]; then
    # Remove syntax file
    if [ -f "$HOME/.config/nvim/syntax/athon.vim" ]; then
        echo -e "${BLUE}Removing: $HOME/.config/nvim/syntax/athon.vim${NC}"
        rm "$HOME/.config/nvim/syntax/athon.vim"
        echo -e "${GREEN}✓${NC} Removed Neovim syntax file"
        NVIM_REMOVED=true
    fi
    
    # Remove filetype detection
    if [ -f "$HOME/.config/nvim/ftdetect/athon.vim" ]; then
        echo -e "${BLUE}Removing: $HOME/.config/nvim/ftdetect/athon.vim${NC}"
        rm "$HOME/.config/nvim/ftdetect/athon.vim"
        echo -e "${GREEN}✓${NC} Removed Neovim filetype detection"
        NVIM_REMOVED=true
    fi
    
    if [ "$NVIM_REMOVED" = true ]; then
        REMOVED_COUNT=$((REMOVED_COUNT + 1))
    fi
fi

if [ "$NVIM_REMOVED" = false ]; then
    echo -e "${YELLOW}⊘${NC} No Neovim support files found"
    NOT_FOUND_COUNT=$((NOT_FOUND_COUNT + 1))
fi

# ============================================================================
# Summary
# ============================================================================
print_section "Uninstallation Summary"

echo ""
echo -e "${BOLD}Results:${NC}"
echo -e "  ${GREEN}✓${NC} Removed:   $REMOVED_COUNT editor(s)"
echo -e "  ${YELLOW}⊘${NC} Not found: $NOT_FOUND_COUNT editor(s)"
echo ""

if [ $REMOVED_COUNT -gt 0 ]; then
    echo -e "${GREEN}${BOLD}✓ Uninstallation complete!${NC}"
    echo ""
    echo -e "${YELLOW}Please restart your editor(s) to complete the removal.${NC}"
    echo ""
else
    echo -e "${YELLOW}${BOLD}⊘ No Athōn editor support was found${NC}"
    echo ""
    echo "Nothing was removed."
    echo ""
fi

# ============================================================================
# Reinstall Instructions
# ============================================================================
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BOLD}To Reinstall:${NC}"
echo ""
echo "Run the installation script again:"
echo -e "  ${CYAN}./install-editor-support.sh${NC}"
echo ""

echo -e "${GREEN}Done!${NC}"
echo ""
