# Athōn Editor Support

Syntax highlighting and editor integration for the Athōn programming language.

## Quick Start

### VS Code (Recommended)

```bash
cp -r vscode/athon ~/.vscode/extensions/athon-language-0.3.0
```

Restart VS Code and open any `.at` file!

## What's Included

### ✅ Syntax Highlighting
- Keywords (fn, let, if, match, etc.)
- Types (int, bool, string)
- Built-in functions (print, abs, file_read, etc.)
- Comments (// and /* */)
- Strings with escape sequences
- Numbers (decimal and hex)
- Operators
- Constants (true, false)

### ✅ Code Snippets (VS Code)
- `fn` / `fnv` - Function definitions (with/without return)
- `main` - Main function
- `if` / `ifelse` - Conditionals
- `while` / `for` / `forrange` - Loops
- `match` / `matchb` - Pattern matching (expression/block)
- `struct` / `structinit` - Struct definition and initialization
- `enum` / `enumvar` - Enum definition and variants
- `array` / `arridx` - Array literals and indexing
- `fread` / `fwrite` - File I/O with error checking
- `math` - Math function calls
- And more...

### ✅ Editor Features
- Auto-closing brackets and quotes
- Comment toggling
- Smart indentation
- Code folding
- Syntax-aware navigation

## Supported Editors

| Editor | Status | Installation |
|--------|--------|--------------|
| **VS Code** | ✅ Full Support | [Guide](INSTALLATION.md#vs-code) |
| **Sublime Text** | ✅ Syntax Only | [Guide](INSTALLATION.md#sublime-text) |
| **Vim/Neovim** | ✅ Syntax Only | [Guide](INSTALLATION.md#vimneovim) |
| **Emacs** | ⚠️ Basic | [Guide](INSTALLATION.md#emacs) |
| **IntelliJ IDEA** | ⚠️ Manual Setup | [Guide](INSTALLATION.md#intellij-idea--jetbrains-ides) |
| **Atom** | ⚠️ Basic | [Guide](INSTALLATION.md#atom) |

## Installation

See [INSTALLATION.md](INSTALLATION.md) for detailed installation instructions for each editor.

## Directory Structure

```
editor-support/
├── README.md                    # This file
├── INSTALLATION.md              # Detailed installation guide
├── vscode/                      # VS Code extension
│   └── athon/
│       ├── package.json
│       ├── language-configuration.json
│       ├── syntaxes/
│       │   └── athon.tmLanguage.json
│       ├── snippets/
│       │   └── athon.json
│       └── README.md
├── sublime-text/                # Sublime Text support
│   └── Athon.sublime-syntax
├── vim/                         # Vim/Neovim support
│   ├── syntax/
│   │   └── athon.vim
│   └── ftdetect/
│       └── athon.vim
└── emacs/                       # Emacs support (future)
    └── athon-mode.el
```

## Example

Here's how Athōn code looks with syntax highlighting:

```athon
// Function definition
fn calculate_distance(x1: int, y1: int, x2: int, y2: int) -> int {
    let dx = abs(x2 - x1);
    let dy = abs(y2 - y1);
    return sqrt(dx * dx + dy * dy);
}

// Main function
fn main() {
    let distance = calculate_distance(0, 0, 3, 4);
    print("Distance: {}", distance);
    
    // Pattern matching
    match distance {
        5 => print("Perfect!"),
        _ => print("Other value"),
    }
}

// Data structures
struct Point {
    x: int,
    y: int,
}

enum Color {
    Red,
    Green,
    Blue,
}
```

## Features by Editor

### VS Code
- ✅ Full syntax highlighting
- ✅ Code snippets
- ✅ Auto-completion
- ✅ Bracket matching
- ✅ Comment toggling
- ✅ Smart indentation
- ✅ Code folding

### Sublime Text
- ✅ Syntax highlighting
- ✅ Comment toggling
- ⚠️ No snippets (yet)

### Vim/Neovim
- ✅ Syntax highlighting
- ✅ Filetype detection
- ⚠️ No auto-completion (yet)

## Future Enhancements

### Language Server Protocol (LSP)
- [ ] Real-time error checking
- [ ] Intelligent auto-completion
- [ ] Go to definition
- [ ] Find references
- [ ] Hover documentation
- [ ] Code formatting
- [ ] Refactoring support

### Enhanced Features
- [ ] Semantic highlighting
- [ ] Code lens
- [ ] Inlay hints
- [ ] Debugger integration
- [ ] REPL integration

## Testing

Test your installation with the comprehensive test file:

```bash
# Open the test file in your editor
code test-syntax.at        # VS Code
subl test-syntax.at        # Sublime Text
vim test-syntax.at         # Vim
```

The `test-syntax.at` file includes:
- All language constructs (structs, enums, functions)
- All control flow (if/else, while, for, match)
- All operators (arithmetic, comparison, logical)
- All built-in functions (math, string, file I/O)
- Complex expressions and nested patterns
- Edge cases and special syntax

### Verification Checklist

Verify that the following are properly highlighted:

**Keywords:**
- ✅ `fn`, `let`, `if`, `else`, `while`, `for`, `match`, `return`
- ✅ `struct`, `enum`, `true`, `false`

**Types and Identifiers:**
- ✅ Built-in types: `int`, `bool`, `string`
- ✅ User types: `Point`, `Color` (capitalized)
- ✅ Enum variants: `Color::Red`, `Status::Ok`

**Functions:**
- ✅ Built-in functions: `print`, `abs`, `sqrt`, `max`, `min`, `pow`
- ✅ File I/O: `file_read`, `file_write`, `file_exists`
- ✅ User functions: `calculate_distance`, `main`

**Literals:**
- ✅ Numbers: `42`, `0xFF`, `-10`
- ✅ Strings: `"Hello, Athōn!"`
- ✅ Booleans: `true`, `false`

**Operators:**
- ✅ Arithmetic: `+`, `-`, `*`, `/`, `%`
- ✅ Comparison: `==`, `!=`, `<`, `>`, `<=`, `>=`
- ✅ Logical: `&&`, `||`, `!`
- ✅ Special: `->`, `=>`, `::`, `..`

**Comments:**
- ✅ Line comments: `// comment`
- ✅ Block comments: `/* comment */`

**String Features:**
- ✅ Escape sequences: `\n`, `\t`
- ✅ Placeholders: `{}`

### Automated Verification

Run the verification script to check all files:

```bash
./verify-installation.sh
```

This will:
- Check all required files are present
- Validate JSON syntax
- Provide installation instructions
- Report any issues

## Contributing

We welcome contributions to improve editor support!

### Adding Support for New Editors

1. Create a directory for the editor
2. Add syntax definition files
3. Test thoroughly
4. Update INSTALLATION.md
5. Submit a pull request

### Improving Existing Support

1. Test the current implementation
2. Identify missing features
3. Implement improvements
4. Test again
5. Submit a pull request

See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.

## Resources

- [Athōn Language Guide](../docs/language-guide.md)
- [Athōn Syntax Specification](../athon-spec/syntax.md)
- [VS Code Extension API](https://code.visualstudio.com/api)
- [TextMate Grammar](https://macromates.com/manual/en/language_grammars)
- [Language Server Protocol](https://microsoft.github.io/language-server-protocol/)

## License

See [LICENSE](../LICENSE) for license information.

---

**Quick Links:**
- [Installation Guide](INSTALLATION.md)
- [VS Code Extension](vscode/athon/)
- [Language Guide](../docs/language-guide.md)
- [Contributing](../CONTRIBUTING.md)
