#!/bin/sh
# no_external_deps_check.sh - Ensure no external crates are used

set -e

echo "Scanning for banned external dependencies..."

# Grep for 'extern crate' or 'crate::' usage that implies external deps
# We exclude the bootstrap compiler's own source if necessary, but generally it applies everywhere.

if grep -r "extern crate" . | grep -v "bootstrap"; then
    echo "ERROR: Found 'extern crate'. External dependencies are forbidden."
    exit 1
fi

if grep -r "Cargo.toml" .; then
    echo "ERROR: Found Cargo.toml. Cargo is not allowed."
    exit 1
fi

echo "No external dependencies found."
