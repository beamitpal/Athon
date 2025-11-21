#!/bin/bash
# Quick Update Script - Minimal output, maximum speed
# Use this when you just want to rebuild and install quickly

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}⚡ Quick Update Starting...${NC}"

# Build compiler
echo -n "Building compiler... "
cd compiler/bootstrap
if cargo build --release > /dev/null 2>&1; then
    cp target/release/athon-boot ../../athon-boot
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
    exit 1
fi
cd ../..

# Install compiler
echo -n "Installing compiler... "
if sudo cp athon-boot /usr/local/bin/athon-boot 2>/dev/null; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
fi

# Build CLI
if [ -d "cli" ]; then
    echo -n "Building CLI... "
    cd cli
    if cargo build --release > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗${NC}"
        cd ..
        exit 1
    fi
    cd ..
    
    # Install CLI
    echo -n "Installing CLI... "
    if sudo cp cli/target/release/athon /usr/local/bin/athon 2>/dev/null; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗${NC}"
    fi
fi

# Quick test
echo -n "Testing... "
if ./athon-boot examples/hello.at > /tmp/test.c 2>&1 && \
   gcc /tmp/test.c -o /tmp/test 2>&1 && \
   /tmp/test > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC}"
    rm -f /tmp/test.c /tmp/test
else
    echo -e "${RED}✗${NC}"
fi

echo -e "${GREEN}✓ Done!${NC} 🚀"
