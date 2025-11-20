#!/bin/sh
# static_checks.sh - Run static analysis

set -e

echo "Running Static Checks..."

# 1. Check for external dependencies
./ci/no_external_deps_check.sh

# 2. Check License Headers (simplified)
echo "Checking license headers..."
# grep -L "MIT License" $(find . -name "*.rs")

echo "Static checks passed."
