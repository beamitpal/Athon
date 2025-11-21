#!/bin/bash
# Development Update Script
# Rebuilds, installs, and runs tests automatically
# Perfect for active development workflow

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo ""
echo -e "${BOLD}${BLUE}🔧 Development Update${NC}"
echo ""

# ============================================================================
# Build & Install
# ============================================================================

echo -e "${CYAN}[1/4]${NC} Building compiler..."
cd compiler/bootstrap
cargo build --release 2>&1 | grep -E "(Compiling|Finished|error)" || true
cp target/release/athon-boot ../../athon-boot
cd ../..
echo -e "${GREEN}✓${NC} Compiler built"

echo -e "${CYAN}[2/4]${NC} Installing system-wide..."
sudo cp athon-boot /usr/local/bin/athon-boot

if [ -d "cli" ]; then
    cd cli
    cargo build --release 2>&1 | grep -E "(Compiling|Finished|error)" || true
    cd ..
    sudo cp cli/target/release/athon /usr/local/bin/athon
    echo -e "${GREEN}✓${NC} Compiler and CLI installed"
else
    echo -e "${GREEN}✓${NC} Compiler installed"
fi

# ============================================================================
# Quick Smoke Test
# ============================================================================

echo -e "${CYAN}[3/4]${NC} Running smoke test..."
if ./athon-boot examples/hello.at > /tmp/test.c 2>&1 && \
   gcc /tmp/test.c -o /tmp/test 2>&1 && \
   /tmp/test > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Smoke test passed"
    rm -f /tmp/test.c /tmp/test
else
    echo -e "${RED}✗${NC} Smoke test failed"
    exit 1
fi

# ============================================================================
# Run Test Suite
# ============================================================================

echo -e "${CYAN}[4/4]${NC} Running test suite..."
echo ""

# Run regular tests
if bash test-all-examples.sh 2>&1 | tail -10; then
    echo ""
    echo -e "${GREEN}${BOLD}✓ All tests passed!${NC}"
else
    echo ""
    echo -e "${RED}${BOLD}✗ Some tests failed${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}${BOLD}✓ Development update complete!${NC} 🚀"
echo ""
echo "Ready to continue development!"
echo ""
