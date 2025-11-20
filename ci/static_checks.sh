#!/bin/bash
# static_checks.sh - Run static analysis on Athōn project
# Usage: ./ci/static_checks.sh

set -e

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║              Athōn Static Analysis Checks                     ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

total_checks=0
passed_checks=0
failed_checks=0

run_check() {
    local name="$1"
    local command="$2"
    
    total_checks=$((total_checks + 1))
    echo -e "${BLUE}Running: $name${NC}"
    
    if eval "$command"; then
        echo -e "${GREEN}✓ PASS${NC}"
        passed_checks=$((passed_checks + 1))
    else
        echo -e "${RED}✗ FAIL${NC}"
        failed_checks=$((failed_checks + 1))
    fi
    echo ""
}

# Check 1: External dependencies
run_check "External Dependencies Check" "./ci/no_external_deps_check.sh"

# Check 2: Rust code formatting (if rustfmt is available)
if command -v rustfmt &> /dev/null; then
    run_check "Rust Code Formatting" "(cd compiler/bootstrap && cargo fmt -- --check)"
else
    echo -e "${YELLOW}⊘ SKIP: rustfmt not installed${NC}"
    echo ""
fi

# Check 3: Rust clippy lints (if clippy is available)
if command -v cargo-clippy &> /dev/null || cargo clippy --version &> /dev/null; then
    run_check "Rust Clippy Lints" "(cd compiler/bootstrap && cargo clippy -- -D warnings)"
else
    echo -e "${YELLOW}⊘ SKIP: clippy not installed${NC}"
    echo ""
fi

# Check 4: Check for TODO/FIXME comments
echo -e "${BLUE}Running: TODO/FIXME Check${NC}"
todo_count=$(grep -r "TODO\|FIXME" compiler/ examples/ std/ --include="*.rs" --include="*.at" 2>/dev/null | wc -l || echo "0")
if [ "$todo_count" -gt 0 ]; then
    echo -e "${YELLOW}⚠ Found $todo_count TODO/FIXME comments${NC}"
    echo "  (This is informational, not a failure)"
else
    echo -e "${GREEN}✓ No TODO/FIXME comments found${NC}"
fi
echo ""

# Check 5: Check for trailing whitespace
echo -e "${BLUE}Running: Trailing Whitespace Check${NC}"
whitespace_files=$(find compiler/ examples/ -type f \( -name "*.rs" -o -name "*.at" \) -exec grep -l " $" {} \; 2>/dev/null | wc -l || echo "0")
if [ "$whitespace_files" -gt 0 ]; then
    echo -e "${YELLOW}⚠ Found $whitespace_files files with trailing whitespace${NC}"
    echo "  (This is informational, not a failure)"
else
    echo -e "${GREEN}✓ No trailing whitespace found${NC}"
fi
echo ""

# Check 6: Check file permissions (no executable source files)
echo -e "${BLUE}Running: File Permissions Check${NC}"
executable_sources=$(find compiler/ -type f \( -name "*.rs" -o -name "*.toml" \) -executable 2>/dev/null | wc -l || echo "0")
if [ "$executable_sources" -gt 0 ]; then
    echo -e "${RED}✗ Found $executable_sources executable source files${NC}"
    find compiler/ -type f \( -name "*.rs" -o -name "*.toml" \) -executable 2>/dev/null
    failed_checks=$((failed_checks + 1))
else
    echo -e "${GREEN}✓ No executable source files found${NC}"
    passed_checks=$((passed_checks + 1))
fi
total_checks=$((total_checks + 1))
echo ""

# Check 7: Verify all examples compile
echo -e "${BLUE}Running: Example Compilation Check${NC}"
example_count=$(find examples -name "*.at" -type f | wc -l)
echo "Found $example_count example files"

if [ -f "./athon-boot" ]; then
    compile_errors=0
    for example in examples/*.at; do
        if ! ./athon-boot "$example" > /dev/null 2>&1; then
            echo -e "${RED}✗ Failed to compile: $example${NC}"
            compile_errors=$((compile_errors + 1))
        fi
    done
    
    if [ $compile_errors -eq 0 ]; then
        echo -e "${GREEN}✓ All $example_count examples compile successfully${NC}"
        passed_checks=$((passed_checks + 1))
    else
        echo -e "${RED}✗ $compile_errors examples failed to compile${NC}"
        failed_checks=$((failed_checks + 1))
    fi
else
    echo -e "${YELLOW}⊘ SKIP: athon-boot not found (build compiler first)${NC}"
fi
total_checks=$((total_checks + 1))
echo ""

# Summary
echo "════════════════════════════════════════════════════════════════"
echo "Static Analysis Summary:"
echo "════════════════════════════════════════════════════════════════"
echo "Total Checks:  $total_checks"
echo -e "${GREEN}Passed:        $passed_checks${NC}"
echo -e "${RED}Failed:        $failed_checks${NC}"
echo "════════════════════════════════════════════════════════════════"

if [ $failed_checks -eq 0 ]; then
    echo -e "${GREEN}✅ All static checks passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Some static checks failed${NC}"
    exit 1
fi
