#!/bin/bash
# Athōn Installation Script
# Automates the installation process

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                                                                ║"
echo "║              Athōn Language Installer                         ║"
echo "║                                                                ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Check prerequisites
echo -e "${BLUE}Checking prerequisites...${NC}"
echo ""

# Check Rust
if command -v cargo &> /dev/null; then
    rust_version=$(rustc --version | awk '{print $2}')
    echo -e "${GREEN}✓${NC} Rust installed: $rust_version"
else
    echo -e "${RED}✗${NC} Rust not found"
    echo ""
    echo "Please install Rust first:"
    echo "  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
    echo ""
    exit 1
fi

# Check GCC
if command -v gcc &> /dev/null; then
    gcc_version=$(gcc --version | head -1)
    echo -e "${GREEN}✓${NC} GCC installed: $gcc_version"
else
    echo -e "${RED}✗${NC} GCC not found"
    echo ""
    echo "Please install GCC:"
    echo "  Ubuntu/Debian: sudo apt-get install build-essential"
    echo "  macOS: xcode-select --install"
    echo ""
    exit 1
fi

echo ""
echo -e "${GREEN}✓ All prerequisites satisfied${NC}"
echo ""

# Build compiler
echo "════════════════════════════════════════════════════════════════"
echo -e "${CYAN}Building Athōn Compiler...${NC}"
echo "════════════════════════════════════════════════════════════════"
echo ""

cd compiler/bootstrap
bash build.sh

if [ ! -f "../../athon-boot" ]; then
    echo -e "${RED}✗ Build failed: athon-boot not found${NC}"
    exit 1
fi

cd ../..

echo ""
echo -e "${GREEN}✓ Compiler built successfully${NC}"
echo ""

# Test installation
echo "════════════════════════════════════════════════════════════════"
echo -e "${CYAN}Testing Installation...${NC}"
echo "════════════════════════════════════════════════════════════════"
echo ""

echo "Compiling hello.at..."
if ./athon-boot examples/hello.at > /tmp/athon_test_hello.c 2>&1; then
    echo -e "${GREEN}✓${NC} Athōn compilation successful"
else
    echo -e "${RED}✗${NC} Athōn compilation failed"
    exit 1
fi

echo "Compiling C code..."
if gcc /tmp/athon_test_hello.c -o /tmp/athon_test_hello 2>&1; then
    echo -e "${GREEN}✓${NC} C compilation successful"
else
    echo -e "${RED}✗${NC} C compilation failed"
    exit 1
fi

echo "Running program..."
output=$(/tmp/athon_test_hello 2>&1)
if [ "$output" = "Hello, Athōn!" ]; then
    echo -e "${GREEN}✓${NC} Program executed successfully"
    echo "  Output: $output"
else
    echo -e "${RED}✗${NC} Unexpected output: $output"
    exit 1
fi

# Cleanup
rm -f /tmp/athon_test_hello.c /tmp/athon_test_hello

echo ""
echo -e "${GREEN}✓ Installation test passed${NC}"
echo ""

# Optional: Install system-wide
echo "════════════════════════════════════════════════════════════════"
echo -e "${CYAN}Installation Options${NC}"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "The compiler is ready to use from this directory:"
echo "  $(pwd)/athon-boot"
echo ""
echo "Options:"
echo ""
echo "1. Use from current directory:"
echo "   ./athon-boot examples/hello.at > hello.c"
echo ""
echo "2. Add to PATH (add to ~/.bashrc or ~/.zshrc):"
echo "   export PATH=\"\$PATH:$(pwd)\""
echo ""
echo "3. Install system-wide (requires sudo):"
echo "   sudo cp athon-boot /usr/local/bin/"
echo ""

read -p "Install system-wide? (y/N): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "Installing to /usr/local/bin/..."
    if sudo cp athon-boot /usr/local/bin/; then
        echo -e "${GREEN}✓${NC} Installed to /usr/local/bin/athon-boot"
        echo ""
        echo "You can now use 'athon-boot' from anywhere:"
        echo "  athon-boot examples/hello.at > hello.c"
    else
        echo -e "${RED}✗${NC} Installation failed"
        exit 1
    fi
else
    echo ""
    echo "Skipping system-wide installation."
    echo "Use './athon-boot' from this directory."
fi

echo ""
echo "════════════════════════════════════════════════════════════════"
echo -e "${CYAN}Building Athōn CLI...${NC}"
echo "════════════════════════════════════════════════════════════════"
echo ""

cd cli
echo "Compiling CLI tool..."
cargo build --release 2>&1 | grep -E "(Compiling|Finished)" || cargo build --release
cp target/release/athon ../athon
cd ..

echo -e "${GREEN}✓${NC} CLI built successfully"

# Install CLI if user chose system-wide
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Installing CLI to /usr/local/bin/..."
    if sudo cp athon /usr/local/bin/; then
        echo -e "${GREEN}✓${NC} Installed to /usr/local/bin/athon"
    fi
fi

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                                                                ║"
echo "║              ✅ Installation Complete! ✅                      ║"
echo "║                                                                ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo -e "${GREEN}🚀 Athōn is ready to use!${NC}"
echo ""
echo "Quick start with the CLI:"
echo ""
echo "  ${CYAN}./athon run examples/hello.at${NC}"
echo "    → Compile and run in one command"
echo ""
echo "  ${CYAN}./athon new my-project${NC}"
echo "    → Create a new project"
echo ""
echo "  ${CYAN}./athon build hello.at -O${NC}"
echo "    → Build optimized executable"
echo ""
echo "  ${CYAN}./athon help${NC}"
echo "    → See all commands"
echo ""
echo "Or use the compiler directly:"
echo ""
echo "  ${CYAN}./athon-boot examples/hello.at > hello.c${NC}"
echo "  ${CYAN}gcc hello.c -o hello && ./hello${NC}"
echo ""
echo "Learn more:"
echo ""
echo "  📖 Quick Start: cat QUICKSTART.md"
echo "  📚 Language Guide: cat docs/language-guide.md"
echo "  🎨 Editor Support: cat editor-support/INSTALLATION.md"
echo "  🧪 Run Tests: ./test-all-examples.sh"
echo ""
echo "Happy coding with Athōn! 🚀"
echo ""
