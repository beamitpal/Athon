#!/bin/bash
# Build the Athōn CLI tool

set -e

echo "🔨 Building Athōn CLI..."

# Build the CLI
cargo build --release

# Copy to root directory
cp target/release/athon ../athon

echo "✅ CLI built successfully: ./athon"
echo ""
echo "Try it out:"
echo "  ./athon run examples/hello.at"
echo "  ./athon new my-project"
echo "  ./athon help"
