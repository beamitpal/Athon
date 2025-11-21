#!/bin/bash
# Bootstrap Purge Script
# Transitions from Rust bootstrap to self-hosted Athōn compiler

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║         Athōn Bootstrap Purge Process                     ║${NC}"
echo -e "${BLUE}║         Transitioning to Self-Hosted Compiler             ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if bootstrap compiler exists
if [ ! -f "./athon-boot" ]; then
    echo -e "${RED}Error: Bootstrap compiler (athon-boot) not found${NC}"
    echo "Please build the bootstrap compiler first:"
    echo "  cd compiler/bootstrap && ./build.sh"
    exit 1
fi

# Phase 1: Verify self-hosted components
echo -e "${YELLOW}Phase 1: Verifying self-hosted components...${NC}"
echo ""

echo "Testing lexer..."
if ./athon-boot self-hosted/lexer_simple.at > /tmp/lexer_test.c 2>&1 && \
   gcc /tmp/lexer_test.c -o /tmp/lexer_test 2>&1 && \
   /tmp/lexer_test > /dev/null 2>&1; then
    echo -e "  ${GREEN}✓${NC} Lexer works"
else
    echo -e "  ${RED}✗${NC} Lexer failed"
    exit 1
fi

echo "Testing parser..."
if ./athon-boot self-hosted/parser_simple.at > /tmp/parser_test.c 2>&1 && \
   gcc /tmp/parser_test.c -o /tmp/parser_test 2>&1 && \
   /tmp/parser_test > /dev/null 2>&1; then
    echo -e "  ${GREEN}✓${NC} Parser works"
else
    echo -e "  ${RED}✗${NC} Parser failed"
    exit 1
fi

echo "Testing code generator..."
if ./athon-boot self-hosted/codegen_simple.at > /tmp/codegen_test.c 2>&1 && \
   gcc /tmp/codegen_test.c -o /tmp/codegen_test 2>&1 && \
   /tmp/codegen_test > /dev/null 2>&1; then
    echo -e "  ${GREEN}✓${NC} Code generator works"
else
    echo -e "  ${RED}✗${NC} Code generator failed"
    exit 1
fi

echo ""
echo -e "${GREEN}✓ All self-hosted components verified${NC}"
echo ""

# Phase 2: Archive bootstrap compiler
echo -e "${YELLOW}Phase 2: Archiving bootstrap compiler...${NC}"
echo ""

if [ -d "compiler/bootstrap-archived" ]; then
    echo -e "${YELLOW}Warning: Archive directory already exists${NC}"
    read -p "Overwrite? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted"
        exit 1
    fi
    rm -rf compiler/bootstrap-archived
fi

echo "Creating archive..."
cp -r compiler/bootstrap compiler/bootstrap-archived
echo -e "  ${GREEN}✓${NC} Bootstrap compiler archived to compiler/bootstrap-archived/"
echo ""

# Phase 3: Statistics
echo -e "${YELLOW}Phase 3: Compiler Statistics${NC}"
echo ""

echo "Bootstrap Compiler (Rust):"
RUST_LINES=$(find compiler/bootstrap/src -name "*.rs" -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}')
echo "  Lines of code: ${RUST_LINES}"
echo "  Language: Rust"
echo "  Dependencies: cargo, rustc"
echo ""

echo "Self-Hosted Compiler (Athōn):"
ATHON_LINES=$(wc -l self-hosted/*_simple.at 2>/dev/null | tail -1 | awk '{print $1}')
echo "  Lines of code: ${ATHON_LINES}"
echo "  Language: Athōn"
echo "  Dependencies: gcc (for C output)"
echo ""

# Phase 4: Next steps
echo -e "${YELLOW}Phase 4: Next Steps${NC}"
echo ""
echo "The bootstrap compiler has been archived."
echo ""
echo "To complete the transition:"
echo ""
echo "1. Create unified compiler:"
echo "   ${BLUE}# Create self-hosted/compiler.at that connects all components${NC}"
echo ""
echo "2. Test self-compilation:"
echo "   ${BLUE}./athon-boot self-hosted/compiler.at > athon-stage1.c${NC}"
echo "   ${BLUE}gcc athon-stage1.c -o athon-stage1${NC}"
echo "   ${BLUE}./athon-stage1 self-hosted/compiler.at > athon-stage2.c${NC}"
echo ""
echo "3. Verify reproducibility:"
echo "   ${BLUE}diff athon-stage1.c athon-stage2.c${NC}"
echo ""
echo "4. Replace bootstrap:"
echo "   ${BLUE}cp athon-stage2 ./athon${NC}"
echo "   ${BLUE}rm ./athon-boot${NC}"
echo ""
echo "5. Update documentation and scripts"
echo ""

# Phase 5: Summary
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                 Bootstrap Purge Summary                    ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "Status: Phase 1-2 Complete"
echo ""
echo "✓ Self-hosted components verified"
echo "✓ Bootstrap compiler archived"
echo "⏳ Unified compiler creation (next)"
echo "⏳ Self-compilation testing (next)"
echo "⏳ Full transition (next)"
echo ""
echo "The Athōn project is ready for self-hosting!"
echo ""
echo "For detailed plan, see: BOOTSTRAP_PURGE_PLAN.md"
echo ""
