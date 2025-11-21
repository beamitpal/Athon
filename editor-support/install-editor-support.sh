#!/bin/bash
# Athōn Editor Support Installation Script
# Installs syntax highlighting and editor support for VS Code, Sublime Text, and Vim/Neovim

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
echo -e "${BOLD}║        Athōn Editor Support Installation Script               ║${NC}"
echo -e "${BOLD}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Track installations
INSTALLED_COUNT=0
SKIPPED_COUNT=0
FAILED_COUNT=0

# Function to print section headers
print_section() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}$1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Function to check if command succeeded
check_status() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $1"
        return 0
    else
        echo -e "${RED}✗${NC} $1"
        return 1
    fi
}

# ============================================================================
# Detect Available Editors
# ============================================================================
print_section "Detecting Installed Editors"

VSCODE_FOUND=false
SUBLIME_FOUND=false
VIM_FOUND=false
NEOVIM_FOUND=false

# Check for VS Code
if command -v code &> /dev/null; then
    VSCODE_FOUND=true
    echo -e "${GREEN}✓${NC} VS Code detected: $(which code)"
else
    echo -e "${YELLOW}⊘${NC} VS Code not found"
fi

# Check for Sublime Text
if command -v subl &> /dev/null; then
    SUBLIME_FOUND=true
    echo -e "${GREEN}✓${NC} Sublime Text detected: $(which subl)"
elif [ -d "/Applications/Sublime Text.app" ]; then
    SUBLIME_FOUND=true
    echo -e "${GREEN}✓${NC} Sublime Text detected: /Applications/Sublime Text.app"
else
    echo -e "${YELLOW}⊘${NC} Sublime Text not found"
fi

# Check for Vim
if command -v vim &> /dev/null; then
    VIM_FOUND=true
    echo -e "${GREEN}✓${NC} Vim detected: $(which vim)"
else
    echo -e "${YELLOW}⊘${NC} Vim not found"
fi

# Check for Neovim
if command -v nvim &> /dev/null; then
    NEOVIM_FOUND=true
    echo -e "${GREEN}✓${NC} Neovim detected: $(which nvim)"
else
    echo -e "${YELLOW}⊘${NC} Neovim not found"
fi

# Check if any editor was found
if [ "$VSCODE_FOUND" = false ] && [ "$SUBLIME_FOUND" = false ] && [ "$VIM_FOUND" = false ] && [ "$NEOVIM_FOUND" = false ]; then
    echo ""
    echo -e "${RED}${BOLD}No supported editors found!${NC}"
    echo ""
    echo "Please install one of the following editors:"
    echo "  - VS Code: https://code.visualstudio.com/"
    echo "  - Sublime Text: https://www.sublimetext.com/"
    echo "  - Vim: Usually pre-installed on Linux/macOS"
    echo "  - Neovim: https://neovim.io/"
    echo ""
    exit 1
fi

# ============================================================================
# Install VS Code Support
# ============================================================================
if [ "$VSCODE_FOUND" = true ]; then
    print_section "Installing VS Code Support"
    
    # Determine VS Code extensions directory
    if [ -d "$HOME/.vscode/extensions" ]; then
        VSCODE_EXT_DIR="$HOME/.vscode/extensions"
    elif [ -d "$HOME/.vscode-server/extensions" ]; then
        VSCODE_EXT_DIR="$HOME/.vscode-server/extensions"
    elif [ -d "$HOME/Library/Application Support/Code/User/extensions" ]; then
        VSCODE_EXT_DIR="$HOME/Library/Application Support/Code/User/extensions"
    else
        echo -e "${YELLOW}⊘${NC} VS Code extensions directory not found, creating..."
        VSCODE_EXT_DIR="$HOME/.vscode/extensions"
        mkdir -p "$VSCODE_EXT_DIR"
    fi
    
    echo -e "${BLUE}Extensions directory: $VSCODE_EXT_DIR${NC}"
    
    # Copy extension
    EXT_NAME="athon-language-0.4.0"
    TARGET_DIR="$VSCODE_EXT_DIR/$EXT_NAME"
    
    echo -e "${BLUE}Installing extension to: $TARGET_DIR${NC}"
    
    # Remove old version if exists
    if [ -d "$TARGET_DIR" ]; then
        echo -e "${YELLOW}Removing old version...${NC}"
        rm -rf "$TARGET_DIR"
    fi
    
    # Copy extension files
    if cp -r "$SCRIPT_DIR/vscode/athon" "$TARGET_DIR"; then
        check_status "VS Code extension installed"
        INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
        
        echo ""
        echo -e "${GREEN}${BOLD}VS Code installation complete!${NC}"
        echo -e "${YELLOW}Please restart VS Code to activate the extension.${NC}"
    else
        check_status "Failed to install VS Code extension"
        FAILED_COUNT=$((FAILED_COUNT + 1))
    fi
else
    SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
fi

# ============================================================================
# Install Sublime Text Support
# ============================================================================
if [ "$SUBLIME_FOUND" = true ]; then
    print_section "Installing Sublime Text Support"
    
    # Determine Sublime Text packages directory
    if [ -d "$HOME/.config/sublime-text/Packages/User" ]; then
        SUBLIME_PKG_DIR="$HOME/.config/sublime-text/Packages/User"
    elif [ -d "$HOME/.config/sublime-text-3/Packages/User" ]; then
        SUBLIME_PKG_DIR="$HOME/.config/sublime-text-3/Packages/User"
    elif [ -d "$HOME/Library/Application Support/Sublime Text/Packages/User" ]; then
        SUBLIME_PKG_DIR="$HOME/Library/Application Support/Sublime Text/Packages/User"
    elif [ -d "$HOME/Library/Application Support/Sublime Text 3/Packages/User" ]; then
        SUBLIME_PKG_DIR="$HOME/Library/Application Support/Sublime Text 3/Packages/User"
    else
        echo -e "${YELLOW}⊘${NC} Sublime Text packages directory not found, creating..."
        SUBLIME_PKG_DIR="$HOME/.config/sublime-text/Packages/User"
        mkdir -p "$SUBLIME_PKG_DIR"
    fi
    
    echo -e "${BLUE}Packages directory: $SUBLIME_PKG_DIR${NC}"
    
    # Copy syntax file
    if cp "$SCRIPT_DIR/sublime-text/Athon.sublime-syntax" "$SUBLIME_PKG_DIR/"; then
        check_status "Sublime Text syntax file installed"
        INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
        
        echo ""
        echo -e "${GREEN}${BOLD}Sublime Text installation complete!${NC}"
        echo -e "${YELLOW}Please restart Sublime Text to activate syntax highlighting.${NC}"
    else
        check_status "Failed to install Sublime Text syntax"
        FAILED_COUNT=$((FAILED_COUNT + 1))
    fi
else
    SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
fi

# ============================================================================
# Install Vim Support
# ============================================================================
if [ "$VIM_FOUND" = true ]; then
    print_section "Installing Vim Support"
    
    VIM_DIR="$HOME/.vim"
    
    # Create directories if they don't exist
    mkdir -p "$VIM_DIR/syntax"
    mkdir -p "$VIM_DIR/ftdetect"
    
    echo -e "${BLUE}Vim directory: $VIM_DIR${NC}"
    
    # Copy syntax file
    if cp "$SCRIPT_DIR/vim/syntax/athon.vim" "$VIM_DIR/syntax/"; then
        check_status "Vim syntax file installed"
    else
        check_status "Failed to install Vim syntax file"
        FAILED_COUNT=$((FAILED_COUNT + 1))
    fi
    
    # Copy filetype detection
    if cp "$SCRIPT_DIR/vim/ftdetect/athon.vim" "$VIM_DIR/ftdetect/"; then
        check_status "Vim filetype detection installed"
        INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
        
        echo ""
        echo -e "${GREEN}${BOLD}Vim installation complete!${NC}"
        echo -e "${YELLOW}Restart Vim to activate syntax highlighting.${NC}"
    else
        check_status "Failed to install Vim filetype detection"
        FAILED_COUNT=$((FAILED_COUNT + 1))
    fi
else
    SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
fi

# ============================================================================
# Install Neovim Support
# ============================================================================
if [ "$NEOVIM_FOUND" = true ]; then
    print_section "Installing Neovim Support"
    
    # Determine Neovim config directory
    if [ -d "$HOME/.config/nvim" ]; then
        NVIM_DIR="$HOME/.config/nvim"
    else
        echo -e "${YELLOW}Creating Neovim config directory...${NC}"
        NVIM_DIR="$HOME/.config/nvim"
        mkdir -p "$NVIM_DIR"
    fi
    
    # Create directories
    mkdir -p "$NVIM_DIR/syntax"
    mkdir -p "$NVIM_DIR/ftdetect"
    
    echo -e "${BLUE}Neovim directory: $NVIM_DIR${NC}"
    
    # Copy syntax file
    if cp "$SCRIPT_DIR/vim/syntax/athon.vim" "$NVIM_DIR/syntax/"; then
        check_status "Neovim syntax file installed"
    else
        check_status "Failed to install Neovim syntax file"
        FAILED_COUNT=$((FAILED_COUNT + 1))
    fi
    
    # Copy filetype detection
    if cp "$SCRIPT_DIR/vim/ftdetect/athon.vim" "$NVIM_DIR/ftdetect/"; then
        check_status "Neovim filetype detection installed"
        INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
        
        echo ""
        echo -e "${GREEN}${BOLD}Neovim installation complete!${NC}"
        echo -e "${YELLOW}Restart Neovim to activate syntax highlighting.${NC}"
    else
        check_status "Failed to install Neovim filetype detection"
        FAILED_COUNT=$((FAILED_COUNT + 1))
    fi
else
    SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
fi

# ============================================================================
# Verification
# ============================================================================
print_section "Verification"

echo -e "${BLUE}Testing with sample file...${NC}"
echo ""

# Check if test file exists
if [ -f "$SCRIPT_DIR/test-syntax.at" ]; then
    echo -e "${GREEN}✓${NC} Test file found: test-syntax.at"
    echo ""
    echo "You can test syntax highlighting by opening:"
    echo -e "  ${CYAN}$SCRIPT_DIR/test-syntax.at${NC}"
    echo ""
    echo "Commands to open:"
    [ "$VSCODE_FOUND" = true ] && echo -e "  ${BLUE}code $SCRIPT_DIR/test-syntax.at${NC}"
    [ "$SUBLIME_FOUND" = true ] && echo -e "  ${BLUE}subl $SCRIPT_DIR/test-syntax.at${NC}"
    [ "$VIM_FOUND" = true ] && echo -e "  ${BLUE}vim $SCRIPT_DIR/test-syntax.at${NC}"
    [ "$NEOVIM_FOUND" = true ] && echo -e "  ${BLUE}nvim $SCRIPT_DIR/test-syntax.at${NC}"
else
    echo -e "${YELLOW}⊘${NC} Test file not found"
fi

# ============================================================================
# Install Formatter
# ============================================================================
print_section "Installing Formatter"

echo -e "${BLUE}Installing athon-format.py...${NC}"

# Copy formatter to user's local bin
if [ ! -d "$HOME/.local/bin" ]; then
    mkdir -p "$HOME/.local/bin"
fi

if cp "$SCRIPT_DIR/athon-format.py" "$HOME/.local/bin/"; then
    chmod +x "$HOME/.local/bin/athon-format.py"
    check_status "Formatter installed to ~/.local/bin/"
    
    # Check if ~/.local/bin is in PATH
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo -e "${YELLOW}Note: Add ~/.local/bin to your PATH:${NC}"
        echo -e "  ${CYAN}export PATH=\"\$HOME/.local/bin:\$PATH\"${NC}"
    fi
else
    check_status "Failed to install formatter"
fi

# ============================================================================
# Summary
# ============================================================================
print_section "Installation Summary"

echo ""
echo -e "${BOLD}Results:${NC}"
echo -e "  ${GREEN}✓${NC} Installed: $INSTALLED_COUNT editor(s)"
echo -e "  ${YELLOW}⊘${NC} Skipped:   $SKIPPED_COUNT editor(s) (not found)"
[ $FAILED_COUNT -gt 0 ] && echo -e "  ${RED}✗${NC} Failed:    $FAILED_COUNT installation(s)"
echo ""

if [ $INSTALLED_COUNT -gt 0 ]; then
    echo -e "${GREEN}${BOLD}✓ Installation successful!${NC}"
    echo ""
    echo "What's installed:"
    [ "$VSCODE_FOUND" = true ] && echo -e "  ${GREEN}✓${NC} VS Code - Athōn language support"
    [ "$SUBLIME_FOUND" = true ] && echo -e "  ${GREEN}✓${NC} Sublime Text - Athōn syntax highlighting"
    [ "$VIM_FOUND" = true ] && echo -e "  ${GREEN}✓${NC} Vim - Athōn syntax highlighting"
    [ "$NEOVIM_FOUND" = true ] && echo -e "  ${GREEN}✓${NC} Neovim - Athōn syntax highlighting"
    echo ""
    echo -e "${YELLOW}${BOLD}Important:${NC} Please restart your editor(s) to activate the changes."
    echo ""
    echo "Features available:"
    echo "  • Syntax highlighting for all Athōn keywords"
    echo "  • Type system support (type, trait, impl, generics)"
    echo "  • Built-in function highlighting"
    echo "  • Comment and string highlighting"
    echo "  • Code snippets (VS Code only)"
    echo ""
else
    echo -e "${YELLOW}${BOLD}⚠ No editors were configured${NC}"
    echo ""
    echo "This could mean:"
    echo "  • No supported editors are installed"
    echo "  • Installation failed (check errors above)"
    echo ""
fi

# ============================================================================
# Next Steps
# ============================================================================
if [ $INSTALLED_COUNT -gt 0 ]; then
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${BOLD}Next Steps:${NC}"
    echo ""
    echo "1. Restart your editor(s)"
    echo "2. Open an Athōn file (.at extension)"
    echo "3. Verify syntax highlighting is working"
    echo ""
    echo "Test with:"
    echo -e "  ${CYAN}$SCRIPT_DIR/test-syntax.at${NC}"
    echo ""
    echo "Or create a new file:"
    echo -e "  ${CYAN}echo 'fn main() { print(\"Hello, Athōn!\"); }' > test.at${NC}"
    echo ""
    echo "Documentation:"
    echo -e "  ${CYAN}cat $SCRIPT_DIR/README.md${NC}"
    echo -e "  ${CYAN}cat $SCRIPT_DIR/INSTALLATION.md${NC}"
    echo ""
fi

# ============================================================================
# Uninstall Instructions
# ============================================================================
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BOLD}To Uninstall:${NC}"
echo ""
[ "$VSCODE_FOUND" = true ] && echo "VS Code:       rm -rf ~/.vscode/extensions/athon-language-*"
[ "$SUBLIME_FOUND" = true ] && echo "Sublime Text:  rm ~/.config/sublime-text/Packages/User/Athon.sublime-syntax"
[ "$VIM_FOUND" = true ] && echo "Vim:           rm ~/.vim/syntax/athon.vim ~/.vim/ftdetect/athon.vim"
[ "$NEOVIM_FOUND" = true ] && echo "Neovim:        rm ~/.config/nvim/syntax/athon.vim ~/.config/nvim/ftdetect/athon.vim"
echo ""

echo -e "${GREEN}Done!${NC} 🚀"
echo ""
