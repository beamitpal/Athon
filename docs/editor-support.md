# Athōn Editor Support

Complete guide for setting up editor support for Athōn.

## Quick Start

### Install VS Code Extension

```bash
# Install from VSIX
./install-extension.sh

# Or manually
code --install-extension build/athon-language-latest.vsix
```

### Restart VS Code
Close all windows (Ctrl+Q), wait 5 seconds, reopen.

---

## Features

### ✅ Syntax Highlighting
- All keywords, types, operators
- Comments and strings
- Built-in and user-defined functions

### ✅ Code Snippets
20+ snippets for common patterns:
- `fn` + Tab → Function template
- `main` + Tab → Main function
- `struct` + Tab → Struct definition
- And more...

### ✅ Auto-completion
- Keyword suggestions
- Press Ctrl+Space for completions

### ✅ Format on Save
- Integrated formatter
- Automatic formatting on save
- Configurable indentation

### ✅ File Icons (Optional)
- Works with Material Icon Theme
- Custom green icons for `.at` files
- Keeps Material icons for other files

---

## Setup File Icons

### Option 1: Automatic
```bash
./setup-material-icons.sh
```

### Option 2: Manual
1. Install Material Icon Theme:
```bash
code --install-extension PKief.material-icon-theme
```

2. Add to `.vscode/settings.json`:
```json
{
  "workbench.iconTheme": "material-icon-theme",
  "material-icon-theme.files.associations": {
    "*.at": "../../.vscode/extensions/athon-lang.athon-language-0.4.0/icons/athon-file"
  }
}
```

3. Restart VS Code

---

## Configuration

### Extension Settings

```json
{
  "athon.formatOnSave": true,
  "athon.indentSize": 4,
  "athon.formatterPath": ""
}
```

### Workspace Settings

Already configured in `.vscode/settings.json`:
```json
{
  "[athon]": {
    "editor.formatOnSave": true,
    "editor.tabSize": 4
  }
}
```

---

## Development

### Rebuild Extension

After making changes to the compiler or extension:

```bash
# Quick rebuild
./rebuild-extension.sh

# Rebuild and install
./rebuild-extension.sh --install

# Full build
./build-vscode-extension.sh
```

### Extension Structure

```
editor-support/vscode/athon/
├── extension.js          # Main extension logic
├── package.json          # Extension manifest
├── athon-format.py       # Bundled formatter
├── syntaxes/             # Syntax highlighting
├── snippets/             # Code snippets
└── icons/                # File icons
```

---

## Other Editors

### Sublime Text
```bash
cd editor-support
./install-editor-support.sh
```

### Vim/Neovim
```bash
cd editor-support
./install-editor-support.sh
```

---

## Troubleshooting

### Extension Not Working?
```bash
# Reinstall
./install-extension.sh

# Restart VS Code completely
# Close all windows, wait 5 seconds, reopen
```

### Formatter Not Found?
The formatter is bundled in the extension. If it doesn't work:
```json
{
  "athon.formatterPath": "/path/to/athon-format.py"
}
```

### Icons Not Showing?
Install Material Icon Theme and configure file associations (see above).

---

## Scripts

- `build-vscode-extension.sh` - Build VSIX package
- `rebuild-extension.sh` - Quick rebuild for development
- `install-extension.sh` - Install from VSIX
- `setup-material-icons.sh` - Configure file icons
- `verify-editor-features.sh` - Verify installation

---

## Publishing

To publish to VS Code Marketplace:

```bash
cd editor-support/vscode/athon
npx vsce login athon-lang
npx vsce publish
```

---

## More Information

- Extension README: `editor-support/vscode/athon/README.md`
- Changelog: `editor-support/vscode/athon/CHANGELOG.md`
- Build Guide: See build scripts in project root

---

**Version:** 0.4.0  
**Status:** All Features Working ✅
