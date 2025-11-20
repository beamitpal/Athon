#!/bin/bash
# repro_build.sh - Verify reproducible builds for Athōn compiler
# Usage: ./ci/repro_build.sh

set -e

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║        Athōn Reproducible Build Verification                  ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if cargo is installed
if ! command -v cargo &> /dev/null; then
    echo -e "${RED}❌ Error: cargo not found${NC}"
    echo "Please install Rust: https://rustup.rs/"
    exit 1
fi

# Clean previous builds
echo -e "${BLUE}Cleaning previous builds...${NC}"
rm -rf build/
mkdir -p build

# Stage 1: Build compiler first time
echo ""
echo -e "${BLUE}Stage 1: Building compiler (first build)...${NC}"
cd compiler/bootstrap
cargo clean
cargo build --release
cd ../..

# Copy Stage 1 binary
mkdir -p build/stage1
cp compiler/bootstrap/target/release/athon-boot build/stage1/athon-boot
HASH1=$(sha256sum build/stage1/athon-boot | awk '{print $1}')
SIZE1=$(stat -f%z build/stage1/athon-boot 2>/dev/null || stat -c%s build/stage1/athon-boot 2>/dev/null)

echo -e "${GREEN}✓${NC} Stage 1 complete"
echo "  Hash: $HASH1"
echo "  Size: $SIZE1 bytes"

# Stage 2: Build compiler second time (clean rebuild)
echo ""
echo -e "${BLUE}Stage 2: Building compiler (second build)...${NC}"
cd compiler/bootstrap
cargo clean
cargo build --release
cd ../..

# Copy Stage 2 binary
mkdir -p build/stage2
cp compiler/bootstrap/target/release/athon-boot build/stage2/athon-boot
HASH2=$(sha256sum build/stage2/athon-boot | awk '{print $1}')
SIZE2=$(stat -f%z build/stage2/athon-boot 2>/dev/null || stat -c%s build/stage2/athon-boot 2>/dev/null)

echo -e "${GREEN}✓${NC} Stage 2 complete"
echo "  Hash: $HASH2"
echo "  Size: $SIZE2 bytes"

# Compare builds
echo ""
echo "════════════════════════════════════════════════════════════════"
echo "Verification Results:"
echo "════════════════════════════════════════════════════════════════"
echo "Stage 1 Hash: $HASH1"
echo "Stage 2 Hash: $HASH2"
echo ""

if [ "$HASH1" = "$HASH2" ]; then
    echo -e "${GREEN}✅ SUCCESS: Builds are reproducible!${NC}"
    echo ""
    echo "The compiler produces identical binaries across builds."
    echo "This ensures deterministic compilation and build reproducibility."
    exit 0
else
    echo -e "${RED}❌ FAILURE: Builds differ!${NC}"
    echo ""
    echo "The two builds produced different binaries."
    echo "This indicates non-deterministic behavior in the build process."
    echo ""
    echo "Possible causes:"
    echo "  • Timestamps embedded in binary"
    echo "  • Random values in compilation"
    echo "  • Non-deterministic optimization"
    echo "  • Environment-dependent behavior"
    exit 1
fi
