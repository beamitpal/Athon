#!/bin/bash
# Test all Athōn examples using the CLI
# Modern version using athon CLI tool

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║         Athōn Examples Test Suite (CLI Version)               ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Check if CLI exists
if ! command -v athon &> /dev/null; then
    echo -e "${RED}❌ Error: athon CLI not found${NC}"
    echo "Please install the CLI first:"
    echo "  ./install.sh"
    echo "Or:"
    echo "  cd cli && bash build.sh"
    echo "  sudo cp target/release/athon /usr/local/bin/"
    exit 1
fi

# Show version
echo -e "${CYAN}Using: $(athon version | head -1)${NC}"
echo ""

# Count examples
total=$(find examples -name "*.at" -type f | wc -l)
passed=0
failed=0
skipped=0

echo -e "${BLUE}Found $total example files${NC}"
echo ""

# Create temp directory for outputs
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# Test each example
for example in examples/*.at; do
    filename=$(basename "$example")
    name="${filename%.at}"
    
    printf "%-40s " "Testing $filename..."
    
    # Skip error test (expected to fail)
    if [[ "$name" == "error_test" ]]; then
        echo -e "${YELLOW}SKIP${NC} (error test)"
        skipped=$((skipped + 1))
        continue
    fi
    
    # Skip library files (no main function)
    if [[ "$name" == *"_lib" ]]; then
        echo -e "${YELLOW}SKIP${NC} (library file)"
        skipped=$((skipped + 1))
        continue
    fi
    
    # Run using CLI (with timeout)
    if timeout 5s athon run "$example" > "$TEMP_DIR/$name.out" 2>&1; then
        echo -e "${GREEN}✓ PASS${NC}"
        passed=$((passed + 1))
    else
        exit_code=$?
        if [ $exit_code -eq 124 ]; then
            echo -e "${RED}✗ FAIL${NC} (timeout)"
        else
            echo -e "${RED}✗ FAIL${NC} (exit code $exit_code)"
        fi
        failed=$((failed + 1))
        
        # Show error output for failed tests
        if [ -f "$TEMP_DIR/$name.out" ]; then
            echo -e "${YELLOW}  Output:${NC}"
            head -5 "$TEMP_DIR/$name.out" | sed 's/^/    /'
        fi
    fi
done

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "Test Results:"
echo "════════════════════════════════════════════════════════════════"
echo -e "Total:   $total"
echo -e "${GREEN}Passed:  $passed${NC}"
echo -e "${RED}Failed:  $failed${NC}"
echo -e "${YELLOW}Skipped: $skipped${NC}"
echo ""
echo -e "Success Rate: $(( passed * 100 / (total - skipped) ))%"
echo "════════════════════════════════════════════════════════════════"

if [ $failed -eq 0 ]; then
    echo -e "${GREEN}✅ All tests passed!${NC}"
    echo ""
    echo "The Athōn CLI is working perfectly! 🚀"
    exit 0
else
    echo -e "${RED}❌ Some tests failed${NC}"
    echo ""
    echo "Run individual tests with:"
    echo "  athon run examples/<filename>.at -v"
    exit 1
fi
