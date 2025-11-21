#!/bin/bash
# Athōn - Unified Command-Line Interface
# All-in-one tool for building, testing, and managing Athōn
# Replaces all individual bash scripts

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#═══════════════════════════════════════════════════════════════════════════════
# UTILITY FUNCTIONS
#═══════════════════════════════════════════════════════════════════════════════

show_banner() {
    echo ""
    echo -e "${BOLD}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}║                    Athōn Language Toolkit                      ║${NC}"
    echo -e "${BOLD}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

show_menu() {
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}Main Menu${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "  ${BOLD}Build & Install${NC}"
    echo "    1) Install Athōn compiler"
    echo "    2) Quick update (fast rebuild)"
    echo "    3) Full update (clean rebuild)"
    echo "    4) Check installation"
    echo ""
    echo "  ${BOLD}Testing${NC}"
    echo "    5) Test self-compilation"
    echo "    6) Test all examples"
    echo "    7) Test all examples (verbose)"
    echo "    8) Test all examples (CLI mode)"
    echo ""
    echo "  ${BOLD}Editor Support${NC}"
    echo "    9) Build VS Code extension (VSIX)"
    echo "   10) Rebuild and install extension"
    echo "   11) Install extension from VSIX"
    echo "   12) Setup Material Icon Theme"
    echo "   13) Verify editor features"
    echo ""
    echo "  ${BOLD}Maintenance${NC}"
    echo "   14) Bootstrap purge (clean all)"
    echo "   15) Verify setup"
    echo ""
    echo "   ${RED}0) Exit${NC}"
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

check_status() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $1"
        return 0
    else
        echo -e "${RED}✗${NC} $1"
        return 1
    fi
}

#═══════════════════════════════════════════════════════════════════════════════
# INSTALL COMPILER
#═══════════════════════════════════════════════════════════════════════════════

install_compiler() {
    echo -e "${BOLD}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}║              Athōn Language Installer                          ║${NC}"
    echo -e "${BOLD}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Check prerequisites
    echo -e "${BLUE}Checking prerequisites...${NC}"
    
    if ! command -v cargo &> /dev/null; then
        echo -e "${RED}✗${NC} Rust not found"
        echo "Please install Rust: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
        return 1
    fi
    echo -e "${GREEN}✓${NC} Rust installed: $(rustc --version | awk '{print $2}')"
    
    if ! command -v gcc &> /dev/null; then
        echo -e "${RED}✗${NC} GCC not found"
        echo "Please install GCC: sudo apt-get install build-essential"
        return 1
    fi
    echo -e "${GREEN}✓${NC} GCC installed"
    
    # Build bootstrap compiler
    echo ""
    echo -e "${BLUE}Building bootstrap compiler...${NC}"
    cd "$SCRIPT_DIR/compiler/bootstrap"
    cargo build --release
    check_status "Bootstrap compiler built"
    
    # Copy to root
    cp target/release/athon-boot "$SCRIPT_DIR/"
    check_status "Copied athon-boot to root"
    
    # Build self-hosted compiler
    echo ""
    echo -e "${BLUE}Building self-hosted compiler...${NC}"
    cd "$SCRIPT_DIR"
    ./athon-boot self-hosted/compiler.at > /tmp/athon-compiler.c
    gcc /tmp/athon-compiler.c -o athon
    check_status "Self-hosted compiler built"
    
    # Build formatter
    echo ""
    echo -e "${BLUE}Building formatter...${NC}"
    ./athon-boot cli/athon-fmt.at > /tmp/athon-fmt.c
    gcc /tmp/athon-fmt.c -o athon-fmt
    check_status "Formatter built"
    
    echo ""
    echo -e "${GREEN}${BOLD}✓ Installation complete!${NC}"
    echo ""
    echo "Binaries created:"
    echo "  ./athon-boot  - Bootstrap compiler"
    echo "  ./athon       - Self-hosted compiler"
    echo "  ./athon-fmt   - Code formatter"
}

#═══════════════════════════════════════════════════════════════════════════════
# UPDATE FUNCTIONS
#═══════════════════════════════════════════════════════════════════════════════

quick_update() {
    echo -e "${BLUE}Quick update (incremental rebuild)...${NC}"
    cd "$SCRIPT_DIR"
    
    if [ ! -f "./athon-boot" ]; then
        echo -e "${RED}Bootstrap compiler not found. Run install first.${NC}"
        return 1
    fi
    
    echo "Rebuilding self-hosted compiler..."
    ./athon-boot self-hosted/compiler.at > /tmp/athon-compiler.c
    gcc /tmp/athon-compiler.c -o athon
    check_status "Compiler updated"
    
    echo "Rebuilding formatter..."
    ./athon-boot cli/athon-fmt.at > /tmp/athon-fmt.c
    gcc /tmp/athon-fmt.c -o athon-fmt
    check_status "Formatter updated"
    
    echo -e "${GREEN}✓ Quick update complete${NC}"
}

full_update() {
    echo -e "${BLUE}Full update (clean rebuild)...${NC}"
    cd "$SCRIPT_DIR/compiler/bootstrap"
    
    echo "Cleaning previous build..."
    cargo clean
    
    echo "Rebuilding bootstrap compiler..."
    cargo build --release
    cp target/release/athon-boot "$SCRIPT_DIR/"
    check_status "Bootstrap rebuilt"
    
    cd "$SCRIPT_DIR"
    quick_update
}

#═══════════════════════════════════════════════════════════════════════════════
# TESTING FUNCTIONS
#═══════════════════════════════════════════════════════════════════════════════

test_self_compilation() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║         Athōn Self-Compilation Test                       ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    if [ ! -f "./athon-boot" ]; then
        echo -e "${RED}Bootstrap compiler not found${NC}"
        return 1
    fi
    
    echo "Stage 1: Compiling with bootstrap..."
    ./athon-boot self-hosted/compiler.at > /tmp/athon-stage1.c
    gcc /tmp/athon-stage1.c -o /tmp/athon-stage1
    check_status "Stage 1 complete"
    
    echo ""
    echo "Stage 2: Compiling with stage 1..."
    /tmp/athon-stage1 self-hosted/compiler.at > /tmp/athon-stage2.c
    gcc /tmp/athon-stage2.c -o /tmp/athon-stage2
    check_status "Stage 2 complete"
    
    echo ""
    echo "Comparing outputs..."
    if diff /tmp/athon-stage1.c /tmp/athon-stage2.c > /dev/null; then
        echo -e "${GREEN}✓ Self-compilation successful! Outputs are identical.${NC}"
    else
        echo -e "${YELLOW}⚠ Outputs differ (this may be expected)${NC}"
    fi
}

test_examples() {
    echo -e "${BLUE}Testing all examples...${NC}"
    cd "$SCRIPT_DIR"
    
    PASSED=0
    FAILED=0
    
    for file in examples/*.at; do
        echo -n "Testing $(basename $file)... "
        if ./athon "$file" > /dev/null 2>&1; then
            echo -e "${GREEN}✓${NC}"
            PASSED=$((PASSED + 1))
        else
            echo -e "${RED}✗${NC}"
            FAILED=$((FAILED + 1))
        fi
    done
    
    echo ""
    echo "Results: ${GREEN}$PASSED passed${NC}, ${RED}$FAILED failed${NC}"
}

test_examples_verbose() {
    echo -e "${BLUE}Testing all examples (verbose)...${NC}"
    cd "$SCRIPT_DIR"
    
    for file in examples/*.at; do
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo "Testing: $file"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        ./athon "$file"
        echo ""
    done
}

test_examples_cli() {
    echo -e "${BLUE}Testing all examples (CLI mode)...${NC}"
    cd "$SCRIPT_DIR"
    
    for file in examples/*.at; do
        echo "Testing: $file"
        ./athon "$file" 2>&1 | head -5
        echo ""
    done
}

#═══════════════════════════════════════════════════════════════════════════════
# EDITOR SUPPORT FUNCTIONS
#═══════════════════════════════════════════════════════════════════════════════

build_extension() {
    echo -e "${BOLD}Building VS Code Extension...${NC}"
    
    EXT_DIR="$SCRIPT_DIR/editor-support/vscode/athon"
    BUILD_DIR="$SCRIPT_DIR/build"
    
    # Check Node.js
    if ! command -v node &> /dev/null; then
        echo -e "${RED}Node.js not installed${NC}"
        return 1
    fi
    
    cd "$EXT_DIR"
    
    # Install vsce if needed
    if ! command -v vsce &> /dev/null && [ ! -f "node_modules/.bin/vsce" ]; then
        echo "Installing vsce..."
        npm install --save-dev @vscode/vsce
    fi
    
    # Copy formatter
    if [ -f "$SCRIPT_DIR/editor-support/athon-format.py" ]; then
        cp "$SCRIPT_DIR/editor-support/athon-format.py" "$EXT_DIR/"
    fi
    
    # Package
    echo "Packaging extension..."
    if command -v vsce &> /dev/null; then
        vsce package --allow-star-activation
    else
        npx vsce package --allow-star-activation
    fi
    
    # Move to build directory
    mkdir -p "$BUILD_DIR"
    VSIX_FILE=$(ls -t *.vsix 2>/dev/null | head -1)
    if [ -n "$VSIX_FILE" ]; then
        cp "$VSIX_FILE" "$BUILD_DIR/"
        cd "$BUILD_DIR"
        ln -sf "$VSIX_FILE" "athon-language-latest.vsix"
        echo -e "${GREEN}✓ Extension built: $BUILD_DIR/$VSIX_FILE${NC}"
    fi
}

install_extension() {
    echo -e "${BLUE}Installing VS Code extension...${NC}"
    
    VSIX_FILE="$SCRIPT_DIR/build/athon-language-latest.vsix"
    
    if [ ! -f "$VSIX_FILE" ]; then
        echo "VSIX not found. Building..."
        build_extension
    fi
    
    code --uninstall-extension athon-lang.athon-language 2>/dev/null || true
    code --install-extension "$VSIX_FILE"
    check_status "Extension installed"
    
    echo ""
    echo "Restart VS Code to activate the extension."
}

setup_icons() {
    echo -e "${BLUE}Setting up Material Icon Theme...${NC}"
    
    if ! code --list-extensions 2>/dev/null | grep -q "PKief.material-icon-theme"; then
        echo "Installing Material Icon Theme..."
        code --install-extension PKief.material-icon-theme
    fi
    
    echo "Updating workspace settings..."
    mkdir -p "$SCRIPT_DIR/.vscode"
    cat > "$SCRIPT_DIR/.vscode/settings.json" << 'EOF'
{
  "workbench.iconTheme": "material-icon-theme",
  "athon.formatOnSave": true,
  "[athon]": {
    "editor.formatOnSave": true,
    "editor.tabSize": 4
  },
  "files.associations": {
    "*.at": "athon"
  },
  "material-icon-theme.files.associations": {
    "*.at": "../../.vscode/extensions/athon-lang.athon-language-0.4.0/icons/athon-file"
  }
}
EOF
    
    echo -e "${GREEN}✓ Material Icon Theme configured${NC}"
    echo "Restart VS Code to see the changes."
}

verify_editor() {
    echo -e "${BLUE}Verifying editor features...${NC}"
    
    EXT_DIR="$HOME/.vscode/extensions/athon-language-0.4.0"
    
    if [ -d "$EXT_DIR" ]; then
        echo -e "${GREEN}✓${NC} Extension installed"
    else
        echo -e "${RED}✗${NC} Extension not found"
    fi
    
    if [ -f "$EXT_DIR/syntaxes/athon.tmLanguage.json" ]; then
        echo -e "${GREEN}✓${NC} Syntax file exists"
    fi
    
    if [ -f "$EXT_DIR/snippets/athon.json" ]; then
        echo -e "${GREEN}✓${NC} Snippets file exists"
    fi
    
    if [ -f "$HOME/.local/bin/athon-format.py" ] || [ -f "$SCRIPT_DIR/editor-support/athon-format.py" ]; then
        echo -e "${GREEN}✓${NC} Formatter available"
    fi
}

#═══════════════════════════════════════════════════════════════════════════════
# MAINTENANCE FUNCTIONS
#═══════════════════════════════════════════════════════════════════════════════

bootstrap_purge() {
    echo -e "${YELLOW}This will delete all build artifacts!${NC}"
    read -p "Are you sure? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        return 0
    fi
    
    echo -e "${BLUE}Purging bootstrap...${NC}"
    
    cd "$SCRIPT_DIR"
    
    # Remove binaries
    rm -f athon athon-boot athon-fmt
    echo "Removed binaries"
    
    # Clean Rust build
    if [ -d "compiler/bootstrap/target" ]; then
        cd compiler/bootstrap
        cargo clean
        cd "$SCRIPT_DIR"
        echo "Cleaned Rust build"
    fi
    
    # Remove temp files
    rm -f /tmp/athon-*.c /tmp/athon-stage*
    echo "Removed temp files"
    
    # Remove build directory
    rm -rf build/
    echo "Removed build directory"
    
    echo -e "${GREEN}✓ Purge complete${NC}"
}

verify_setup() {
    echo -e "${BLUE}Verifying Athōn setup...${NC}"
    echo ""
    
    # Check binaries
    if [ -f "$SCRIPT_DIR/athon-boot" ]; then
        echo -e "${GREEN}✓${NC} Bootstrap compiler (athon-boot)"
    else
        echo -e "${RED}✗${NC} Bootstrap compiler missing"
    fi
    
    if [ -f "$SCRIPT_DIR/athon" ]; then
        echo -e "${GREEN}✓${NC} Self-hosted compiler (athon)"
    else
        echo -e "${RED}✗${NC} Self-hosted compiler missing"
    fi
    
    if [ -f "$SCRIPT_DIR/athon-fmt" ]; then
        echo -e "${GREEN}✓${NC} Formatter (athon-fmt)"
    else
        echo -e "${RED}✗${NC} Formatter missing"
    fi
    
    # Check examples
    if [ -d "$SCRIPT_DIR/examples" ]; then
        EXAMPLE_COUNT=$(ls -1 "$SCRIPT_DIR/examples"/*.at 2>/dev/null | wc -l)
        echo -e "${GREEN}✓${NC} Examples directory ($EXAMPLE_COUNT files)"
    fi
    
    # Check editor support
    if [ -d "$HOME/.vscode/extensions/athon-language-0.4.0" ]; then
        echo -e "${GREEN}✓${NC} VS Code extension installed"
    else
        echo -e "${YELLOW}⚠${NC} VS Code extension not installed"
    fi
}

check_install() {
    verify_setup
}

#═══════════════════════════════════════════════════════════════════════════════
# MAIN FUNCTION
#═══════════════════════════════════════════════════════════════════════════════

main() {
    if [ $# -eq 0 ]; then
        # Interactive mode
        while true; do
            show_banner
            show_menu
            read -p "Select option: " choice
            echo ""
            
            case $choice in
                1) install_compiler ;;
                2) quick_update ;;
                3) full_update ;;
                4) check_install ;;
                5) test_self_compilation ;;
                6) test_examples ;;
                7) test_examples_verbose ;;
                8) test_examples_cli ;;
                9) build_extension ;;
                10) build_extension && install_extension ;;
                11) install_extension ;;
                12) setup_icons ;;
                13) verify_editor ;;
                14) bootstrap_purge ;;
                15) verify_setup ;;
                0) echo -e "${GREEN}Goodbye!${NC}"; exit 0 ;;
                *) echo -e "${RED}Invalid option${NC}" ;;
            esac
            
            echo ""
            read -p "Press Enter to continue..."
        done
    else
        # Command-line mode
        case "$1" in
            install) install_compiler ;;
            update) quick_update ;;
            full-update) full_update ;;
            check) check_install ;;
            test) test_self_compilation ;;
            test-examples) test_examples ;;
            test-verbose) test_examples_verbose ;;
            build-ext) build_extension ;;
            install-ext) install_extension ;;
            setup-icons) setup_icons ;;
            verify-editor) verify_editor ;;
            verify) verify_setup ;;
            purge) bootstrap_purge ;;
            help|--help|-h)
                echo "Athōn CLI - Unified command-line interface"
                echo ""
                echo "Usage: ./athon-cli.sh [command]"
                echo ""
                echo "Commands:"
                echo "  install         Install Athōn compiler"
                echo "  update          Quick update (incremental)"
                echo "  full-update     Full rebuild (clean)"
                echo "  check           Check installation"
                echo "  test            Test self-compilation"
                echo "  test-examples   Test all examples"
                echo "  test-verbose    Test examples with output"
                echo "  build-ext       Build VS Code extension"
                echo "  install-ext     Install VS Code extension"
                echo "  setup-icons     Setup Material Icon Theme"
                echo "  verify-editor   Verify editor features"
                echo "  verify          Verify setup"
                echo "  purge           Clean all build artifacts"
                echo ""
                echo "Run without arguments for interactive menu."
                ;;
            *)
                echo -e "${RED}Unknown command: $1${NC}"
                echo "Run './athon-cli.sh help' for usage."
                exit 1
                ;;
        esac
    fi
}

main "$@"
