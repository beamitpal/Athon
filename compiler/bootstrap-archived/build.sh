#!/bin/bash
# Build script for Athōn Bootstrap Compiler

set -e

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║     Building Athōn Bootstrap Compiler (Stage 0)               ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Check if cargo is installed
if ! command -v cargo &> /dev/null; then
    echo "❌ Error: cargo not found"
    echo "Please install Rust: https://rustup.rs/"
    exit 1
fi

echo "📦 Building with Cargo..."
cd "$(dirname "$0")"
cargo build --release

echo ""
echo "📋 Copying binary..."
cp target/release/athon-boot ../../athon-boot

echo ""
echo "✅ Build complete!"
echo ""
echo "Binary location: ./athon-boot"
echo ""
echo "Usage:"
echo "  ./athon-boot <source.at> > output.c"
echo ""
echo "Example:"
echo "  ./athon-boot examples/hello.at > hello.c"
echo "  gcc hello.c -o hello"
echo "  ./hello"
echo ""
