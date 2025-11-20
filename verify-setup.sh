#!/bin/bash
# Verify Athōn installation and setup

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║           Athōn Installation Verification                     ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

passed=0
failed=0

# Test 1: Check athon CLI
echo -n "1. Checking athon CLI... "
if command -v athon &> /dev/null; then
    version=$(athon version | head -1)
    echo -e "${GREEN}✓ PASS${NC}"
    echo "   Location: $(which athon)"
    echo "   Version: $version"
    passed=$((passed + 1))
else
    echo -e "${RED}✗ FAIL${NC}"
    echo "   athon command not found"
    failed=$((failed + 1))
fi
echo ""

# Test 2: Check athon-boot compiler
echo -n "2. Checking athon-boot compiler... "
if command -v athon-boot &> /dev/null; then
    echo -e "${GREEN}✓ PASS${NC}"
    echo "   Location: $(which athon-boot)"
    passed=$((passed + 1))
else
    echo -e "${RED}✗ FAIL${NC}"
    echo "   athon-boot command not found"
    failed=$((failed + 1))
fi
echo ""

# Test 3: Check GCC
echo -n "3. Checking GCC compiler... "
if command -v gcc &> /dev/null; then
    gcc_version=$(gcc --version | head -1)
    echo -e "${GREEN}✓ PASS${NC}"
    echo "   Version: $gcc_version"
    passed=$((passed + 1))
else
    echo -e "${RED}✗ FAIL${NC}"
    echo "   gcc command not found"
    failed=$((failed + 1))
fi
echo ""

# Test 4: Run hello world
echo -n "4. Testing hello world... "
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

if athon run examples/hello.at > "$TEMP_DIR/output.txt" 2>&1; then
    output=$(cat "$TEMP_DIR/output.txt")
    if [[ "$output" == *"Hello"* ]]; then
        echo -e "${GREEN}✓ PASS${NC}"
        echo "   Output: $output"
        passed=$((passed + 1))
    else
        echo -e "${RED}✗ FAIL${NC}"
        echo "   Unexpected output: $output"
        failed=$((failed + 1))
    fi
else
    echo -e "${RED}✗ FAIL${NC}"
    echo "   Execution failed"
    failed=$((failed + 1))
fi
echo ""

# Test 5: Create new project
echo -n "5. Testing project creation... "
if athon new "$TEMP_DIR/test-project" > /dev/null 2>&1; then
    if [ -f "$TEMP_DIR/test-project/src/main.at" ]; then
        echo -e "${GREEN}✓ PASS${NC}"
        echo "   Project created successfully"
        passed=$((passed + 1))
    else
        echo -e "${RED}✗ FAIL${NC}"
        echo "   Project structure incomplete"
        failed=$((failed + 1))
    fi
else
    echo -e "${RED}✗ FAIL${NC}"
    echo "   Project creation failed"
    failed=$((failed + 1))
fi
echo ""

# Test 6: Build executable
echo -n "6. Testing build command... "
if athon build examples/hello.at -o "$TEMP_DIR/hello-test" > /dev/null 2>&1; then
    if [ -f "$TEMP_DIR/hello-test" ] && [ -x "$TEMP_DIR/hello-test" ]; then
        echo -e "${GREEN}✓ PASS${NC}"
        echo "   Executable built successfully"
        passed=$((passed + 1))
    else
        echo -e "${RED}✗ FAIL${NC}"
        echo "   Executable not created"
        failed=$((failed + 1))
    fi
else
    echo -e "${RED}✗ FAIL${NC}"
    echo "   Build failed"
    failed=$((failed + 1))
fi
echo ""

# Test 7: Check shell completion
echo -n "7. Checking shell completion... "
if [ -f "/etc/bash_completion.d/athon" ]; then
    echo -e "${GREEN}✓ PASS${NC}"
    echo "   Completion installed"
    passed=$((passed + 1))
else
    echo -e "${YELLOW}⚠ SKIP${NC}"
    echo "   Completion not installed (optional)"
fi
echo ""

# Test 8: Check documentation
echo -n "8. Checking documentation... "
doc_count=0
[ -f "README.md" ] && doc_count=$((doc_count + 1))
[ -f "QUICKSTART.md" ] && doc_count=$((doc_count + 1))
[ -f "CLI_GUIDE.md" ] && doc_count=$((doc_count + 1))
[ -f "docs/language-guide.md" ] && doc_count=$((doc_count + 1))

if [ $doc_count -ge 3 ]; then
    echo -e "${GREEN}✓ PASS${NC}"
    echo "   Found $doc_count documentation files"
    passed=$((passed + 1))
else
    echo -e "${YELLOW}⚠ WARN${NC}"
    echo "   Only found $doc_count documentation files"
fi
echo ""

# Summary
echo "════════════════════════════════════════════════════════════════"
echo "Verification Results:"
echo "════════════════════════════════════════════════════════════════"
echo -e "Tests Passed:  ${GREEN}$passed${NC}"
echo -e "Tests Failed:  ${RED}$failed${NC}"
echo ""

if [ $failed -eq 0 ]; then
    echo -e "${GREEN}✅ Installation verified successfully!${NC}"
    echo ""
    echo "Your Athōn development environment is ready to use!"
    echo ""
    echo "Quick start:"
    echo "  athon run examples/hello.at"
    echo "  athon new my-project"
    echo "  athon help"
    echo ""
    echo "Documentation:"
    echo "  cat SETUP_COMPLETE.md"
    echo "  cat QUICKSTART.md"
    echo "  cat CLI_GUIDE.md"
    echo ""
    exit 0
else
    echo -e "${RED}❌ Installation verification failed${NC}"
    echo ""
    echo "Please run the installation script:"
    echo "  ./install.sh"
    echo ""
    exit 1
fi
