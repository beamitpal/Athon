#!/bin/bash
# Athōn Update Script
# Automatically rebuilds and installs the latest version of compiler and CLI

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo ""
echo -e "${BOLD}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║           Athōn Update & Installation Script                  ║${NC}"
echo -e "${BOLD}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Track what was updated
UPDATED_COMPILER=false
UPDATED_CLI=false
ERRORS=false

# Function to print section headers
print_section() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}$1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Function to check if command succeeded
check_status() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $1"
        return 0
    else
        echo -e "${RED}✗${NC} $1"
        ERRORS=true
        return 1
    fi
}

# Check if we're in the right directory
if [ ! -f "athon-boot" ] && [ ! -d "compiler/bootstrap" ]; then
    echo -e "${RED}Error: Must be run from the Athōn project root directory${NC}"
    exit 1
fi

# ============================================================================
# STEP 1: Rebuild Bootstrap Compiler
# ============================================================================
print_section "Step 1: Rebuilding Bootstrap Compiler"

echo -e "${BLUE}Building Rust bootstrap compiler...${NC}"
cd compiler/bootstrap

if cargo build --release 2>&1 | tail -5; then
    check_status "Bootstrap compiler built successfully"
    
    echo -e "${BLUE}Copying binary to project root...${NC}"
    cp target/release/athon-boot ../../athon-boot
    check_status "Binary copied to ./athon-boot"
    
    UPDATED_COMPILER=true
else
    check_status "Failed to build bootstrap compiler"
fi

cd ../..

# ============================================================================
# STEP 2: Install Bootstrap Compiler System-Wide
# ============================================================================
print_section "Step 2: Installing Bootstrap Compiler System-Wide"

if [ "$UPDATED_COMPILER" = true ]; then
    echo -e "${BLUE}Installing athon-boot to /usr/local/bin/...${NC}"
    
    if sudo cp athon-boot /usr/local/bin/athon-boot; then
        check_status "Installed to /usr/local/bin/athon-boot"
        
        # Verify installation
        if command -v athon-boot &> /dev/null; then
            echo -e "${GREEN}✓${NC} athon-boot is now available system-wide"
        fi
    else
        check_status "Failed to install athon-boot (requires sudo)"
    fi
else
    echo -e "${YELLOW}⊘${NC} Skipped (compiler build failed)"
fi

# ============================================================================
# STEP 3: Rebuild CLI Tool
# ============================================================================
print_section "Step 3: Rebuilding CLI Tool"

if [ -d "cli" ]; then
    echo -e "${BLUE}Building Athōn CLI...${NC}"
    cd cli
    
    if cargo build --release 2>&1 | tail -5; then
        check_status "CLI built successfully"
        UPDATED_CLI=true
    else
        check_status "Failed to build CLI"
    fi
    
    cd ..
else
    echo -e "${YELLOW}⊘${NC} CLI directory not found, skipping"
fi

# ============================================================================
# STEP 4: Install CLI System-Wide
# ============================================================================
print_section "Step 4: Installing CLI System-Wide"

if [ "$UPDATED_CLI" = true ]; then
    echo -e "${BLUE}Installing athon CLI to /usr/local/bin/...${NC}"
    
    if sudo cp cli/target/release/athon /usr/local/bin/athon; then
        check_status "Installed to /usr/local/bin/athon"
        
        # Verify installation
        if command -v athon &> /dev/null; then
            echo -e "${GREEN}✓${NC} athon CLI is now available system-wide"
        fi
    else
        check_status "Failed to install CLI (requires sudo)"
    fi
else
    echo -e "${YELLOW}⊘${NC} Skipped (CLI build failed or not found)"
fi

# ============================================================================
# STEP 5: Verify Installation
# ============================================================================
print_section "Step 5: Verifying Installation"

echo -e "${BLUE}Checking installed versions...${NC}"
echo ""

# Check athon-boot
if command -v athon-boot &> /dev/null; then
    echo -e "${GREEN}✓${NC} athon-boot: $(which athon-boot)"
    echo -e "  Binary size: $(ls -lh $(which athon-boot) | awk '{print $5}')"
    echo -e "  Last modified: $(stat -c %y $(which athon-boot) 2>/dev/null || stat -f %Sm $(which athon-boot))"
else
    echo -e "${RED}✗${NC} athon-boot not found in PATH"
fi

echo ""

# Check athon CLI
if command -v athon &> /dev/null; then
    echo -e "${GREEN}✓${NC} athon CLI: $(which athon)"
    athon version | head -2 | sed 's/^/  /'
else
    echo -e "${RED}✗${NC} athon CLI not found in PATH"
fi

# ============================================================================
# STEP 6: Run Quick Tests
# ============================================================================
print_section "Step 6: Running Quick Tests"

echo -e "${BLUE}Testing with hello.at example...${NC}"

# Test direct compilation
if ./athon-boot examples/hello.at > /tmp/athon_update_test.c 2>&1; then
    check_status "Direct compilation works"
    
    if gcc /tmp/athon_update_test.c -o /tmp/athon_update_test 2>&1; then
        check_status "C compilation works"
        
        if /tmp/athon_update_test > /dev/null 2>&1; then
            check_status "Execution works"
        fi
    fi
else
    check_status "Direct compilation failed"
fi

echo ""

# Test CLI if available
if command -v athon &> /dev/null; then
    echo -e "${BLUE}Testing CLI...${NC}"
    if athon run examples/hello.at > /dev/null 2>&1; then
        check_status "CLI execution works"
    else
        check_status "CLI execution failed"
    fi
fi

# Cleanup
rm -f /tmp/athon_update_test.c /tmp/athon_update_test

# ============================================================================
# STEP 7: Summary
# ============================================================================
print_section "Update Summary"

echo ""
if [ "$ERRORS" = false ]; then
    echo -e "${GREEN}${BOLD}✓ Update completed successfully!${NC}"
    echo ""
    echo "What was updated:"
    [ "$UPDATED_COMPILER" = true ] && echo -e "  ${GREEN}✓${NC} Bootstrap compiler (athon-boot)"
    [ "$UPDATED_CLI" = true ] && echo -e "  ${GREEN}✓${NC} CLI tool (athon)"
    echo ""
    echo "You can now use:"
    echo -e "  ${CYAN}athon run examples/hello.at${NC}        # Run with CLI"
    echo -e "  ${CYAN}./athon-boot examples/hello.at${NC}     # Direct compilation"
    echo -e "  ${CYAN}athon new my-project${NC}               # Create new project"
    echo ""
else
    echo -e "${YELLOW}${BOLD}⚠ Update completed with some errors${NC}"
    echo ""
    echo "Please check the output above for details."
    echo ""
fi

# ============================================================================
# Optional: Run Full Test Suite
# ============================================================================
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
read -p "Run full test suite? (y/N) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_section "Running Full Test Suite"
    
    if [ -f "test-all-examples.sh" ]; then
        echo -e "${BLUE}Running test-all-examples.sh...${NC}"
        bash test-all-examples.sh
    fi
    
    if [ -f "test-all-examples-cli.sh" ]; then
        echo ""
        echo -e "${BLUE}Running test-all-examples-cli.sh...${NC}"
        bash test-all-examples-cli.sh
    fi
else
    echo -e "${YELLOW}Skipped test suite${NC}"
    echo ""
    echo "You can run tests manually:"
    echo -e "  ${CYAN}bash test-all-examples.sh${NC}"
    echo -e "  ${CYAN}bash test-all-examples-cli.sh${NC}"
    echo -e "  ${CYAN}bash test-all-examples-verbose.sh${NC}"
fi

echo ""
echo -e "${GREEN}${BOLD}Done!${NC} 🚀"
echo ""
