# Athōn Language Support for VS Code

Syntax highlighting and language support for the Athōn programming language.

## Features

- **Syntax Highlighting** - Full syntax highlighting for Athōn code
- **Code Snippets** - Common code patterns and templates
- **Auto-completion** - Bracket and quote auto-closing
- **Comment Support** - Line and block comments
- **Indentation** - Smart indentation rules

## Installation

### From Source

1. Copy this directory to your VS Code extensions folder:
   - **Windows**: `%USERPROFILE%\.vscode\extensions\`
   - **macOS/Linux**: `~/.vscode/extensions/`

2. Restart VS Code

3. Open any `.at` file to see syntax highlighting

### From VSIX (Future)

```bash
code --install-extension athon-language-0.3.0.vsix
```

## Usage

Simply open any file with `.at` extension and the syntax highlighting will be applied automatically.

### Snippets

Type these prefixes and press Tab:

- `fn` - Function definition
- `main` - Main function
- `if` - If statement
- `ifelse` - If-else statement
- `while` - While loop
- `for` - For loop
- `match` - Match statement
- `struct` - Struct definition
- `enum` - Enum definition
- `let` - Variable declaration
- `print` - Print statement
- `printf` - Print with formatting

## Supported Features

### Keywords
- Control flow: `if`, `else`, `while`, `for`, `in`, `match`, `return`
- Declarations: `fn`, `let`, `struct`, `enum`
- Types: `int`, `bool`, `string`
- Constants: `true`, `false`

### Built-in Functions
- I/O: `print`
- Math: `abs`, `min`, `max`, `pow`, `sqrt`, `mod`
- String: `length`, `concat`, `compare`
- Array: `array_length`
- File I/O: `file_read`, `file_write`, `file_append`, `file_exists`

### Operators
- Arithmetic: `+`, `-`, `*`, `/`, `%`
- Comparison: `==`, `!=`, `<`, `>`, `<=`, `>=`
- Logical: `&&`, `||`, `!`
- Other: `->`, `=>`, `::`, `.`, `..`

## Example

```athon
fn main() {
    let x = 42;
    print("Hello, Athōn!");
    
    if x > 10 {
        print("x is greater than 10");
    }
}
```

## Building VSIX Package

To create a distributable VSIX package:

```bash
# Install vsce
npm install -g vsce

# Package the extension
cd editor-support/vscode/athon
vsce package
```

This will create `athon-language-0.3.0.vsix` that can be distributed.

## Contributing

See [CONTRIBUTING.md](../../../CONTRIBUTING.md) for contribution guidelines.

## License

See [LICENSE](../../../LICENSE) for license information.
