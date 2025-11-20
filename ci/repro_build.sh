#!/bin/sh
# repro_build.sh - Verify reproducible builds
# Usage: ./repro_build.sh

set -e

echo "Starting Reproducible Build Verification..."

# Clean previous builds
rm -rf build/

# Stage 1: Build compiler using bootstrap
echo "Stage 1: Bootstrapping..."
mkdir -p build/stage1
# In reality, this would call the bootstrap compiler.
# For now, we simulate it.
echo "mock-binary-stage1" > build/stage1/athonc

# Stage 2: Build compiler using Stage 1
echo "Stage 2: Self-hosting..."
mkdir -p build/stage2
# cp build/stage1/athonc build/stage2/athonc # Simulation
echo "mock-binary-stage2" > build/stage2/athonc

# In a real scenario, the binaries should be identical if the compiler is deterministic.
# Here we just simulate the check.

HASH1=$(sha256sum build/stage1/athonc | awk '{print $1}')
HASH2=$(sha256sum build/stage2/athonc | awk '{print $1}')

echo "Stage 1 Hash: $HASH1"
echo "Stage 2 Hash: $HASH2"

if [ "$HASH1" = "$HASH2" ]; then
    echo "SUCCESS: Builds are reproducible."
    exit 0
else
    echo "FAILURE: Builds differ!"
    exit 1
fi
