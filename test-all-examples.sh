#!/bin/bash
# Test all Athōn examples
# Compiles each .at file to C, then to binary, and runs it

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║              Athōn Examples Test Suite                        ║"
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
    
    echo -n "Testing $filename... "
    
    # Skip error test (expected to fail)
    if [[ "$name" == "error_test" ]]; then
        echo -e "${YELLOW}SKIP${NC} (error test)"
        skipped=$((skipped + 1))
        continue
    fi
    
    # Compile to C
    if ! ./athon-boot "$example" > "$TEMP_DIR/$name.c" 2>&1; then
        echo -e "${RED}FAIL${NC} (compilation failed)"
        failed=$((failed + 1))
        continue
    fi
    
    # Compile C to binary
    if ! gcc "$TEMP_DIR/$name.c" -o "$TEMP_DIR/$name" -lm 2>&1; then
        echo -e "${RED}FAIL${NC} (C compilation failed)"
        failed=$((failed + 1))
        continue
    fi
    
    # Run the binary (with timeout)
    if timeout 5s "$TEMP_DIR/$name" > "$TEMP_DIR/$name.out" 2>&1; then
        echo -e "${GREEN}PASS${NC}"
        passed=$((passed + 1))
    else
        exit_code=$?
        if [ $exit_code -eq 124 ]; then
            echo -e "${RED}FAIL${NC} (timeout)"
        else
            echo -e "${RED}FAIL${NC} (runtime error: exit code $exit_code)"
        fi
        failed=$((failed + 1))
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
echo "════════════════════════════════════════════════════════════════"

if [ $failed -eq 0 ]; then
    echo -e "${GREEN}✅ All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Some tests failed${NC}"
    exit 1
fi
