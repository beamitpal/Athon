# Athōn Language Support for VS Code

Complete language support for the Athōn programming language.

## Features

### ✅ Syntax Highlighting
- All keywords: `fn`, `let`, `if`, `match`, `type`, `trait`, `impl`, `import`
- Types: `int`, `bool`, `string`, custom types
- Operators, comments, strings
- Built-in and user-defined functions

### ✅ Code Snippets
20+ snippets for common patterns:
- `fn` - Function definition
- `main` - Main function
- `struct` - Struct definition
- `enum` - Enum definition
- `match` - Pattern matching
- `trait` - Trait definition
- `impl` - Trait implementation
- And more...

### ✅ Auto-completion
- Keyword suggestions
- Press `Ctrl+Space` for completions
- Smart context-aware suggestions

### ✅ Format on Save
- Integrated formatter
- Automatic formatting on save
- Consistent code style
- Configurable indentation

### ✅ File Icons
- Custom green Athōn icons for `.at` files
- Works with Material Icon Theme
- Keeps all other file icons normal

### ✅ Language Recognition
- `.at` files automatically recognized
- Shows "Athōn" in status bar
- Proper file associations

## Installation

### From VSIX
```bash
code --install-extension athon-language-0.4.0.vsix
```

### From Marketplace (Coming Soon)
Search for "Athōn" in VS Code Extensions

## Usage

### Snippets
Type a snippet prefix and press `Tab`:
- `fn` + Tab → Function template
- `main` + Tab → Main function
- `struct` + Tab → Struct definition

### Formatting
- Automatic: Save file (`Ctrl+S`)
- Manual: Command Palette → "Athōn: Format Document"

### Icon Theme (Optional)
For custom Athōn file icons:

1. Install Material Icon Theme:
```bash
code --install-extension PKief.material-icon-theme
```

2. Add to your settings.json:
```json
{
  "workbench.iconTheme": "material-icon-theme",
  "material-icon-theme.files.associations": {
    "*.at": "../../.vscode/extensions/athon-lang.athon-language-0.4.0/icons/athon-file"
  }
}
```

This gives you:
- Custom green icons for `.at` files
- Material icons for all other files
- No icon conflicts

## Configuration

### Settings

```json
{
  "athon.formatOnSave": true,
  "athon.indentSize": 4,
  "athon.formatterPath": ""
}
```

### Workspace Settings

```json
{
  "workbench.iconTheme": "athon-icons",
  "[athon]": {
    "editor.formatOnSave": true,
    "editor.tabSize": 4
  }
}
```

## Requirements

- VS Code 1.60.0 or higher
- Python 3 (for formatter)

## Extension Settings

This extension contributes the following settings:

* `athon.formatOnSave`: Enable/disable format on save
* `athon.indentSize`: Number of spaces for indentation
* `athon.formatterPath`: Custom path to formatter (auto-detected by default)

## Known Issues

None currently. Please report issues at: https://github.com/beamitpal/athon/issues

## Release Notes

### 0.4.0

- ✅ Integrated formatter with format on save
- ✅ File icons support
- ✅ Enhanced syntax highlighting
- ✅ 20+ code snippets
- ✅ Auto-completion
- ✅ Language configuration

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](https://github.com/beamitpal/athon/blob/main/CONTRIBUTING.md)

## License

See LICENSE file

## More Information

- [GitHub Repository](https://github.com/beamitpal/athon)
- [Documentation](https://github.com/beamitpal/athon#readme)
- [Report Issues](https://github.com/beamitpal/athon/issues)

---

**Enjoy coding in Athōn!** 🚀
