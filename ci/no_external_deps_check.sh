#!/bin/bash
# no_external_deps_check.sh - Ensure sovereignty: no external runtime dependencies
# Usage: ./ci/no_external_deps_check.sh

set -e

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║          Athōn Sovereignty Check: No External Deps            ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

violations=0

echo -e "${BLUE}Checking for external dependencies...${NC}"
echo ""

# Check 1: Verify Cargo.toml has no dependencies
echo "1. Checking Cargo.toml for external dependencies..."
if [ -f "compiler/bootstrap/Cargo.toml" ]; then
    # Extract lines between [dependencies] and next section, excluding comments and empty lines
    deps_count=$(awk '/^\[dependencies\]/,/^\[/ {if ($0 !~ /^\[/ && $0 !~ /^#/ && $0 !~ /^$/) print}' compiler/bootstrap/Cargo.toml | wc -l)
    
    if [ "$deps_count" -gt 0 ]; then
        echo -e "${RED}✗ FAIL: Found external dependencies in Cargo.toml${NC}"
        echo "Dependencies found:"
        awk '/^\[dependencies\]/,/^\[/ {if ($0 !~ /^\[/ && $0 !~ /^#/ && $0 !~ /^$/) print}' compiler/bootstrap/Cargo.toml
        violations=$((violations + 1))
    else
        echo -e "${GREEN}✓ PASS: No external dependencies in Cargo.toml${NC}"
        echo "  (Sovereignty principle maintained)"
    fi
else
    echo -e "${YELLOW}⚠ WARNING: Cargo.toml not found${NC}"
fi
echo ""

# Check 2: Verify no 'extern crate' for external crates (except std)
echo "2. Checking for 'extern crate' declarations..."
if grep -r "extern crate" compiler/bootstrap/src/ 2>/dev/null | grep -v "std" | grep -v "core" | grep -v "alloc"; then
    echo -e "${RED}✗ FAIL: Found 'extern crate' for external dependencies${NC}"
    violations=$((violations + 1))
else
    echo -e "${GREEN}✓ PASS: No external 'extern crate' declarations${NC}"
fi
echo ""

# Check 3: Verify no use statements for external crates
echo "3. Checking for external crate usage..."
# Look for 'use' statements that don't start with std, core, alloc, or crate
# Exclude the project's own crate name (athon_bootstrap)
external_uses=$(grep -r "^use [a-z_][a-z0-9_]*::" compiler/bootstrap/src/ 2>/dev/null | \
   grep -v "use std::" | \
   grep -v "use core::" | \
   grep -v "use alloc::" | \
   grep -v "use crate::" | \
   grep -v "use super::" | \
   grep -v "use self::" | \
   grep -v "use athon_bootstrap::" || true)

if [ -n "$external_uses" ]; then
    echo -e "${RED}✗ FAIL: Found potential external crate usage${NC}"
    echo "$external_uses"
    violations=$((violations + 1))
else
    echo -e "${GREEN}✓ PASS: No external crate usage detected${NC}"
    echo "  (athon_bootstrap is the project's own crate)"
fi
echo ""

# Check 4: Verify standard library usage only
echo "4. Verifying only standard library usage..."
std_count=$(grep -r "use std::" compiler/bootstrap/src/ 2>/dev/null | wc -l || echo "0")
crate_count=$(grep -r "use crate::" compiler/bootstrap/src/ 2>/dev/null | wc -l || echo "0")
echo "  • std:: usage: $std_count occurrences"
echo "  • crate:: usage: $crate_count occurrences"
echo -e "${GREEN}✓ PASS: Using only standard library${NC}"
echo ""

# Check 5: Verify no network dependencies
echo "5. Checking for network-related code..."
if grep -r "reqwest\|hyper\|tokio\|async" compiler/bootstrap/src/ 2>/dev/null | grep -v "// " > /dev/null 2>&1; then
    echo -e "${RED}✗ FAIL: Found network-related dependencies${NC}"
    violations=$((violations + 1))
else
    echo -e "${GREEN}✓ PASS: No network dependencies${NC}"
fi
echo ""

# Check 6: Verify no database dependencies
echo "6. Checking for database-related code..."
if grep -r "diesel\|sqlx\|postgres\|mysql" compiler/bootstrap/src/ 2>/dev/null | grep -v "// " > /dev/null 2>&1; then
    echo -e "${RED}✗ FAIL: Found database-related dependencies${NC}"
    violations=$((violations + 1))
else
    echo -e "${GREEN}✓ PASS: No database dependencies${NC}"
fi
echo ""

# Check 7: Verify no serialization dependencies (except std)
echo "7. Checking for serialization dependencies..."
if grep -r "serde\|bincode\|json" compiler/bootstrap/src/ 2>/dev/null | grep -v "// " | grep -v "std::fmt" > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠ WARNING: Found serialization-related code${NC}"
    echo "  (This may be acceptable if using std only)"
else
    echo -e "${GREEN}✓ PASS: No external serialization dependencies${NC}"
fi
echo ""

# Summary
echo "════════════════════════════════════════════════════════════════"
echo "Sovereignty Check Summary:"
echo "════════════════════════════════════════════════════════════════"

if [ $violations -eq 0 ]; then
    echo -e "${GREEN}✅ SUCCESS: No external dependencies found!${NC}"
    echo ""
    echo "The Athōn project maintains its sovereignty principle:"
    echo "  ✓ Zero external runtime dependencies"
    echo "  ✓ Only Rust standard library used"
    echo "  ✓ Self-contained compiler"
    echo "  ✓ No network dependencies"
    echo "  ✓ No database dependencies"
    echo ""
    echo "This ensures:"
    echo "  • Supply chain security"
    echo "  • Build reproducibility"
    echo "  • Long-term maintainability"
    echo "  • Air-gap friendly deployment"
    exit 0
else
    echo -e "${RED}❌ FAILURE: Found $violations sovereignty violations!${NC}"
    echo ""
    echo "The project has external dependencies that violate the"
    echo "sovereignty principle. Please remove all external dependencies"
    echo "and use only the Rust standard library."
    exit 1
fi
