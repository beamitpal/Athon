#!/bin/bash
# Build Athōn VS Code Extension (VSIX)
# This script packages the extension into a .vsix file that can be installed or published

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo ""
echo -e "${BOLD}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║        Athōn VS Code Extension Builder                        ║${NC}"
echo -e "${BOLD}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
EXT_DIR="$SCRIPT_DIR/editor-support/vscode/athon"
BUILD_DIR="$SCRIPT_DIR/build"

# ============================================================================
# Step 1: Check Prerequisites
# ============================================================================
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}Step 1: Checking Prerequisites${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${RED}✗${NC} Node.js is not installed"
    echo ""
    echo "Please install Node.js:"
    echo "  Ubuntu/Debian: sudo apt install nodejs npm"
    echo "  macOS: brew install node"
    echo "  Or download from: https://nodejs.org/"
    exit 1
fi
echo -e "${GREEN}✓${NC} Node.js installed: $(node --version)"

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo -e "${RED}✗${NC} npm is not installed"
    exit 1
fi
echo -e "${GREEN}✓${NC} npm installed: $(npm --version)"

# ============================================================================
# Step 2: Install vsce (VS Code Extension Manager)
# ============================================================================
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}Step 2: Installing vsce${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

cd "$EXT_DIR"

# Check if vsce is available globally
if command -v vsce &> /dev/null; then
    echo -e "${GREEN}✓${NC} vsce already installed globally: $(vsce --version)"
    VSCE_CMD="vsce"
# Check if vsce is installed locally
elif [ -f "node_modules/.bin/vsce" ]; then
    echo -e "${GREEN}✓${NC} vsce installed locally"
    VSCE_CMD="npx vsce"
else
    echo -e "${YELLOW}Installing @vscode/vsce locally...${NC}"
    npm install --save-dev @vscode/vsce
    echo -e "${GREEN}✓${NC} vsce installed locally"
    VSCE_CMD="npx vsce"
fi

# ============================================================================
# Step 3: Copy Formatter to Extension
# ============================================================================
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}Step 3: Bundling Formatter${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Copy formatter into extension directory
if [ -f "$SCRIPT_DIR/editor-support/athon-format.py" ]; then
    cp "$SCRIPT_DIR/editor-support/athon-format.py" "$EXT_DIR/athon-format.py"
    chmod +x "$EXT_DIR/athon-format.py"
    echo -e "${GREEN}✓${NC} Formatter bundled into extension"
else
    echo -e "${YELLOW}⚠${NC} Formatter not found, extension will use system formatter"
fi

# ============================================================================
# Step 4: Update Version from Git
# ============================================================================
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}Step 4: Version Information${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Get version from package.json
VERSION=$(grep -o '"version": "[^"]*"' "$EXT_DIR/package.json" | cut -d'"' -f4)
echo -e "${BLUE}Extension version: ${BOLD}$VERSION${NC}"

# Get git commit hash if available
if command -v git &> /dev/null && [ -d "$SCRIPT_DIR/.git" ]; then
    GIT_HASH=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
    GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
    echo -e "${BLUE}Git branch: ${BOLD}$GIT_BRANCH${NC}"
    echo -e "${BLUE}Git commit: ${BOLD}$GIT_HASH${NC}"
fi

# ============================================================================
# Step 5: Validate Extension
# ============================================================================
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}Step 5: Validating Extension${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

cd "$EXT_DIR"

# Check required files
REQUIRED_FILES=(
    "package.json"
    "extension.js"
    "syntaxes/athon.tmLanguage.json"
    "snippets/athon.json"
    "icons/athon-logo.png"
    "icons/athon-file.svg"
    "language-configuration.json"
)

MISSING=0
for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}✗${NC} Missing: $file"
        MISSING=1
    else
        echo -e "${GREEN}✓${NC} Found: $file"
    fi
done

if [ $MISSING -eq 1 ]; then
    echo ""
    echo -e "${RED}${BOLD}Error: Missing required files!${NC}"
    exit 1
fi

# ============================================================================
# Step 6: Package Extension
# ============================================================================
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}Step 6: Packaging Extension${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Remove old VSIX files
rm -f *.vsix

# Package the extension
echo -e "${BLUE}Running: $VSCE_CMD package${NC}"
echo ""
$VSCE_CMD package --allow-star-activation

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✓${NC} Extension packaged successfully!"
else
    echo ""
    echo -e "${RED}✗${NC} Failed to package extension"
    exit 1
fi

# ============================================================================
# Step 7: Move VSIX to Build Directory
# ============================================================================
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}Step 7: Organizing Build Output${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Create build directory
mkdir -p "$BUILD_DIR"

# Find the generated VSIX file
VSIX_FILE=$(ls -t *.vsix 2>/dev/null | head -1)

if [ -z "$VSIX_FILE" ]; then
    echo -e "${RED}✗${NC} VSIX file not found"
    exit 1
fi

# Copy to build directory
cp "$VSIX_FILE" "$BUILD_DIR/"
echo -e "${GREEN}✓${NC} Copied to: $BUILD_DIR/$VSIX_FILE"

# Create a symlink to latest
cd "$BUILD_DIR"
ln -sf "$VSIX_FILE" "athon-language-latest.vsix"
echo -e "${GREEN}✓${NC} Created symlink: athon-language-latest.vsix"

# ============================================================================
# Step 8: Generate Installation Instructions
# ============================================================================
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}Step 8: Creating Installation Guide${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

cat > "$BUILD_DIR/INSTALL_EXTENSION.md" << EOF
# Install Athōn VS Code Extension

## Quick Install

\`\`\`bash
# Install the extension
code --install-extension $VSIX_FILE

# Or use the latest symlink
code --install-extension athon-language-latest.vsix
\`\`\`

## Manual Install

1. Open VS Code
2. Press \`Ctrl+Shift+P\` (or \`Cmd+Shift+P\` on Mac)
3. Type: "Extensions: Install from VSIX"
4. Select: \`$BUILD_DIR/$VSIX_FILE\`
5. Restart VS Code

## Verify Installation

\`\`\`bash
# Check if installed
code --list-extensions | grep athon

# Open a test file
code test-editor-features.at
\`\`\`

## What's Included

- ✅ Syntax highlighting
- ✅ Code snippets
- ✅ Auto-completion
- ✅ Format on save
- ✅ File icons
- ✅ Integrated formatter

## Version

- Extension: $VERSION
- Build date: $(date)
- File: $VSIX_FILE

## Troubleshooting

If features don't work after installation:
1. Restart VS Code completely (close all windows)
2. Wait 5 seconds
3. Reopen VS Code

## Publishing

To publish to VS Code Marketplace:

\`\`\`bash
# Login to publisher account
vsce login athon-lang

# Publish
vsce publish
\`\`\`
EOF

echo -e "${GREEN}✓${NC} Created: $BUILD_DIR/INSTALL_EXTENSION.md"

# ============================================================================
# Summary
# ============================================================================
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}Build Complete!${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${GREEN}${BOLD}✓ Extension packaged successfully!${NC}"
echo ""
echo -e "${BOLD}Output:${NC}"
echo -e "  ${BLUE}File:${NC} $BUILD_DIR/$VSIX_FILE"
echo -e "  ${BLUE}Link:${NC} $BUILD_DIR/athon-language-latest.vsix"
echo -e "  ${BLUE}Size:${NC} $(du -h "$BUILD_DIR/$VSIX_FILE" | cut -f1)"
echo ""

echo -e "${BOLD}Install:${NC}"
echo -e "  ${CYAN}code --install-extension $BUILD_DIR/$VSIX_FILE${NC}"
echo ""
echo -e "  ${CYAN}# Or use the latest symlink${NC}"
echo -e "  ${CYAN}code --install-extension $BUILD_DIR/athon-language-latest.vsix${NC}"
echo ""

echo -e "${BOLD}Publish:${NC}"
echo -e "  ${CYAN}cd $EXT_DIR${NC}"
echo -e "  ${CYAN}vsce publish${NC}"
echo ""

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${GREEN}Done! 🚀${NC}"
echo ""
