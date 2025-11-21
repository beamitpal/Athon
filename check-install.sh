#!/bin/bash
# Check Installation Status
# Shows what's installed and where

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo ""
echo -e "${BOLD}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║           Athōn Installation Status Check                     ║${NC}"
echo -e "${BOLD}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# ============================================================================
# Check Bootstrap Compiler
# ============================================================================
echo -e "${CYAN}━━━ Bootstrap Compiler (athon-boot) ━━━${NC}"
echo ""

# Local binary
if [ -f "./athon-boot" ]; then
    echo -e "${GREEN}✓${NC} Local binary: ./athon-boot"
    echo -e "  Size: $(ls -lh ./athon-boot | awk '{print $5}')"
    echo -e "  Modified: $(stat -c %y ./athon-boot 2>/dev/null | cut -d'.' -f1 || stat -f '%Sm' ./athon-boot)"
else
    echo -e "${RED}✗${NC} Local binary not found"
fi

echo ""

# System binary
if command -v athon-boot &> /dev/null; then
    echo -e "${GREEN}✓${NC} System binary: $(which athon-boot)"
    echo -e "  Size: $(ls -lh $(which athon-boot) | awk '{print $5}')"
    echo -e "  Modified: $(stat -c %y $(which athon-boot) 2>/dev/null | cut -d'.' -f1 || stat -f '%Sm' $(which athon-boot))"
else
    echo -e "${RED}✗${NC} System binary not found in PATH"
fi

# ============================================================================
# Check CLI Tool
# ============================================================================
echo ""
echo -e "${CYAN}━━━ CLI Tool (athon) ━━━${NC}"
echo ""

if command -v athon &> /dev/null; then
    echo -e "${GREEN}✓${NC} CLI installed: $(which athon)"
    echo -e "  Size: $(ls -lh $(which athon) | awk '{print $5}')"
    echo -e "  Modified: $(stat -c %y $(which athon) 2>/dev/null | cut -d'.' -f1 || stat -f '%Sm' $(which athon))"
    echo ""
    echo -e "${BLUE}Version:${NC}"
    athon version | sed 's/^/  /'
else
    echo -e "${RED}✗${NC} CLI not found in PATH"
fi

# ============================================================================
# Check Source Files
# ============================================================================
echo ""
echo -e "${CYAN}━━━ Source Files ━━━${NC}"
echo ""

if [ -d "compiler/bootstrap" ]; then
    echo -e "${GREEN}✓${NC} Bootstrap compiler source: compiler/bootstrap/"
    echo -e "  Files: $(find compiler/bootstrap/src -name '*.rs' | wc -l) Rust files"
else
    echo -e "${RED}✗${NC} Bootstrap compiler source not found"
fi

if [ -d "cli" ]; then
    echo -e "${GREEN}✓${NC} CLI source: cli/"
    echo -e "  Main file: cli/athon-cli.rs"
else
    echo -e "${YELLOW}⊘${NC} CLI source not found"
fi

# ============================================================================
# Check Examples
# ============================================================================
echo ""
echo -e "${CYAN}━━━ Examples ━━━${NC}"
echo ""

if [ -d "examples" ]; then
    EXAMPLE_COUNT=$(find examples -name "*.at" -type f | wc -l)
    echo -e "${GREEN}✓${NC} Examples directory: examples/"
    echo -e "  Total: $EXAMPLE_COUNT example files"
else
    echo -e "${RED}✗${NC} Examples directory not found"
fi

# ============================================================================
# Check Test Scripts
# ============================================================================
echo ""
echo -e "${CYAN}━━━ Test Scripts ━━━${NC}"
echo ""

TEST_SCRIPTS=(
    "test-all-examples.sh"
    "test-all-examples-verbose.sh"
    "test-all-examples-cli.sh"
)

for script in "${TEST_SCRIPTS[@]}"; do
    if [ -f "$script" ]; then
        echo -e "${GREEN}✓${NC} $script"
    else
        echo -e "${RED}✗${NC} $script"
    fi
done

# ============================================================================
# Check Update Scripts
# ============================================================================
echo ""
echo -e "${CYAN}━━━ Update Scripts ━━━${NC}"
echo ""

UPDATE_SCRIPTS=(
    "update.sh"
    "quick-update.sh"
    "dev-update.sh"
)

for script in "${UPDATE_SCRIPTS[@]}"; do
    if [ -f "$script" ] && [ -x "$script" ]; then
        echo -e "${GREEN}✓${NC} $script (executable)"
    elif [ -f "$script" ]; then
        echo -e "${YELLOW}⊘${NC} $script (not executable - run: chmod +x $script)"
    else
        echo -e "${RED}✗${NC} $script"
    fi
done

# ============================================================================
# Quick Functionality Test
# ============================================================================
echo ""
echo -e "${CYAN}━━━ Functionality Test ━━━${NC}"
echo ""

# Test local compiler
if [ -f "./athon-boot" ] && [ -f "examples/hello.at" ]; then
    if ./athon-boot examples/hello.at > /tmp/check_test.c 2>&1; then
        echo -e "${GREEN}✓${NC} Local compiler works"
        rm -f /tmp/check_test.c
    else
        echo -e "${RED}✗${NC} Local compiler failed"
    fi
else
    echo -e "${YELLOW}⊘${NC} Cannot test local compiler"
fi

# Test system compiler
if command -v athon-boot &> /dev/null && [ -f "examples/hello.at" ]; then
    if athon-boot examples/hello.at > /tmp/check_test.c 2>&1; then
        echo -e "${GREEN}✓${NC} System compiler works"
        rm -f /tmp/check_test.c
    else
        echo -e "${RED}✗${NC} System compiler failed"
    fi
else
    echo -e "${YELLOW}⊘${NC} Cannot test system compiler"
fi

# Test CLI
if command -v athon &> /dev/null && [ -f "examples/hello.at" ]; then
    if athon run examples/hello.at > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} CLI works"
    else
        echo -e "${RED}✗${NC} CLI failed"
    fi
else
    echo -e "${YELLOW}⊘${NC} Cannot test CLI"
fi

# ============================================================================
# Summary
# ============================================================================
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Count what's working
WORKING=0
TOTAL=0

[ -f "./athon-boot" ] && WORKING=$((WORKING+1))
TOTAL=$((TOTAL+1))

command -v athon-boot &> /dev/null && WORKING=$((WORKING+1))
TOTAL=$((TOTAL+1))

command -v athon &> /dev/null && WORKING=$((WORKING+1))
TOTAL=$((TOTAL+1))

if [ $WORKING -eq $TOTAL ]; then
    echo -e "${GREEN}${BOLD}✓ Everything is installed and working!${NC}"
    echo ""
    echo "You can use:"
    echo -e "  ${CYAN}athon run examples/hello.at${NC}        # Run with CLI"
    echo -e "  ${CYAN}./athon-boot examples/hello.at${NC}     # Direct compilation"
    echo -e "  ${CYAN}athon new my-project${NC}               # Create new project"
elif [ $WORKING -gt 0 ]; then
    echo -e "${YELLOW}${BOLD}⚠ Partial installation ($WORKING/$TOTAL components)${NC}"
    echo ""
    echo "Run one of these to complete installation:"
    echo -e "  ${CYAN}./update.sh${NC}         # Full interactive update"
    echo -e "  ${CYAN}./quick-update.sh${NC}   # Fast update"
else
    echo -e "${RED}${BOLD}✗ Nothing is installed${NC}"
    echo ""
    echo "Run this to install:"
    echo -e "  ${CYAN}./update.sh${NC}"
fi

echo ""
