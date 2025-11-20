#!/bin/bash
# Test all Athōn examples with verbose output
# Shows compilation output and program output for each example

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║         Athōn Examples Test Suite (Verbose Mode)              ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Check if compiler exists
if [ ! -f "./athon-boot" ]; then
    echo -e "${RED}❌ Error: athon-boot not found${NC}"
    echo "Please build the compiler first:"
    echo "  cd compiler/bootstrap && bash build.sh"
    exit 1
fi

# Check if gcc exists
if ! command -v gcc &> /dev/null; then
    echo -e "${RED}❌ Error: gcc not found${NC}"
    echo "Please install GCC to compile generated C code"
    exit 1
fi

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
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${CYAN}Testing: $filename${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Skip error test (expected to fail)
    if [[ "$name" == "error_test" ]]; then
        echo -e "${YELLOW}⊘ SKIPPED${NC} (error test - expected to fail)"
        echo ""
        skipped=$((skipped + 1))
        continue
    fi
    
    # Show source code (first 10 lines)
    echo -e "${BLUE}Source (first 10 lines):${NC}"
    head -10 "$example" | sed 's/^/  /'
    if [ $(wc -l < "$example") -gt 10 ]; then
        echo "  ..."
    fi
    echo ""
    
    # Compile to C
    echo -e "${BLUE}Compiling to C...${NC}"
    if ! ./athon-boot "$example" > "$TEMP_DIR/$name.c" 2>&1; then
        echo -e "${RED}✗ FAILED${NC} (Athōn compilation failed)"
        echo ""
        failed=$((failed + 1))
        continue
    fi
    c_lines=$(wc -l < "$TEMP_DIR/$name.c")
    echo -e "${GREEN}✓${NC} Generated $c_lines lines of C code"
    echo ""
    
    # Compile C to binary
    echo -e "${BLUE}Compiling C to binary...${NC}"
    if ! gcc "$TEMP_DIR/$name.c" -o "$TEMP_DIR/$name" -lm 2>&1; then
        echo -e "${RED}✗ FAILED${NC} (C compilation failed)"
        echo ""
        failed=$((failed + 1))
        continue
    fi
    binary_size=$(stat -f%z "$TEMP_DIR/$name" 2>/dev/null || stat -c%s "$TEMP_DIR/$name" 2>/dev/null)
    echo -e "${GREEN}✓${NC} Binary size: $binary_size bytes"
    echo ""
    
    # Run the binary
    echo -e "${BLUE}Running program...${NC}"
    if timeout 5s "$TEMP_DIR/$name" > "$TEMP_DIR/$name.out" 2>&1; then
        echo -e "${GREEN}✓ Program executed successfully${NC}"
        echo ""
        echo -e "${BLUE}Output:${NC}"
        cat "$TEMP_DIR/$name.out" | head -20 | sed 's/^/  /'
        if [ $(wc -l < "$TEMP_DIR/$name.out") -gt 20 ]; then
            echo "  ... (output truncated)"
        fi
        echo ""
        echo -e "${GREEN}✅ PASSED${NC}"
        passed=$((passed + 1))
    else
        exit_code=$?
        if [ $exit_code -eq 124 ]; then
            echo -e "${RED}✗ FAILED${NC} (timeout after 5 seconds)"
        else
            echo -e "${RED}✗ FAILED${NC} (runtime error: exit code $exit_code)"
            if [ -f "$TEMP_DIR/$name.out" ]; then
                echo ""
                echo -e "${RED}Error output:${NC}"
                cat "$TEMP_DIR/$name.out" | sed 's/^/  /'
            fi
        fi
        echo ""
        failed=$((failed + 1))
    fi
    echo ""
done

echo "════════════════════════════════════════════════════════════════"
echo "Final Test Results:"
echo "════════════════════════════════════════════════════════════════"
echo -e "Total:   $total"
echo -e "${GREEN}Passed:  $passed${NC}"
echo -e "${RED}Failed:  $failed${NC}"
echo -e "${YELLOW}Skipped: $skipped${NC}"
echo "════════════════════════════════════════════════════════════════"

if [ $failed -eq 0 ]; then
    echo -e "${GREEN}✅ All tests passed!${NC}"
    echo ""
    echo "Summary:"
    echo "  • $passed examples compiled and ran successfully"
    echo "  • $skipped examples skipped (expected failures)"
    echo "  • 0 unexpected failures"
    exit 0
else
    echo -e "${RED}❌ Some tests failed${NC}"
    exit 1
fi
