# Athōn CLI

A unified command-line interface for the Athōn programming language that simplifies development workflow.

## Features

- **One command to rule them all**: No more juggling multiple commands
- **Smart defaults**: Sensible defaults for common tasks
- **Project scaffolding**: Create new projects instantly
- **Automatic cleanup**: Manages intermediate files automatically
- **Developer-friendly**: Clear error messages and helpful output

## Installation

```bash
cd cli
bash build.sh
```

This creates the `athon` binary in the root directory.

## Commands

### Run a Program

Compile and execute in one step:

```bash
athon run hello.at
```

This automatically:
1. Compiles `.at` → `.c`
2. Compiles `.c` → executable
3. Runs the executable
4. Cleans up intermediate files

### Build an Executable

Create a standalone binary:

```bash
athon build hello.at
athon build hello.at -o my-program
athon build hello.at -O              # With optimizations
athon build hello.at -g              # With debug symbols
```

### Compile to C

Generate C source code:

```bash
athon compile hello.at
athon compile hello.at -o output.c
```

### Check Syntax

Verify code without compiling:

```bash
athon check hello.at
```

### Create New Project

Scaffold a complete project:

```bash
athon new my-project
cd my-project
athon run src/main.at
```

Creates:
```
my-project/
├── src/
│   └── main.at
├── tests/
├── athon.toml
├── README.md
└── .gitignore
```

### Initialize Existing Directory

Convert current directory to Athōn project:

```bash
mkdir my-project && cd my-project
athon init
```

### Run Tests

Execute all tests in `tests/` directory:

```bash
athon test
```

### Clean Build Artifacts

Remove generated files:

```bash
athon clean
```

## Options

- `-o, --output <file>` - Specify output file name
- `-O, --optimize` - Enable optimizations (gcc -O3)
- `-g, --debug` - Include debug symbols
- `-v, --verbose` - Show detailed output
- `--no-run` - Compile only, don't execute
- `--keep-c` - Keep intermediate C files

## Examples

### Quick Development

```bash
# Edit and run immediately
vim hello.at
athon run hello.at
```

### Production Build

```bash
# Optimized release build
athon build main.at -O -o my-app
./my-app
```

### Debugging

```bash
# Build with debug symbols
athon build main.at -g -o my-app
gdb ./my-app
```

### Keep Intermediate Files

```bash
# Keep C source for inspection
athon run main.at --keep-c -v
cat main.c
```

### Project Workflow

```bash
# Create project
athon new calculator
cd calculator

# Edit code
vim src/main.at

# Run during development
athon run src/main.at

# Add tests
vim tests/test_calc.at

# Run tests
athon test

# Build release
athon build src/main.at -O -o calculator

# Clean up
athon clean
```

## Comparison: Before vs After

### Before (Manual)

```bash
# Compile
./athon-boot hello.at > hello.c

# Build
gcc hello.c -o hello

# Run
./hello

# Cleanup
rm hello.c hello
```

### After (CLI)

```bash
athon run hello.at
```

## Project Configuration

Create `athon.toml` in your project:

```toml
[package]
name = "my-project"
version = "0.1.0"
authors = ["Your Name <you@example.com>"]

[dependencies]
# Future: external dependencies

[build]
optimize = false
debug = true
```

## Integration with Editors

### VS Code Task

Add to `.vscode/tasks.json`:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Run Athōn",
      "type": "shell",
      "command": "athon run ${file}",
      "group": {
        "kind": "build",
        "isDefault": true
      }
    }
  ]
}
```

Press `Ctrl+Shift+B` to run current file.

### Vim Integration

Add to `.vimrc`:

```vim
" Run current Athōn file
nnoremap <F5> :!athon run %<CR>

" Build current file
nnoremap <F6> :!athon build %<CR>
```

## Shell Completion

### Bash

Add to `~/.bashrc`:

```bash
_athon_completions() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local commands="run build compile check new init test clean repl version help"
    COMPREPLY=($(compgen -W "${commands}" -- ${cur}))
}

complete -F _athon_completions athon
```

### Zsh

Add to `~/.zshrc`:

```zsh
_athon() {
    local -a commands
    commands=(
        'run:Compile and run a program'
        'build:Build an executable'
        'compile:Compile to C source'
        'check:Check syntax'
        'new:Create new project'
        'init:Initialize project'
        'test:Run tests'
        'clean:Clean build artifacts'
        'version:Show version'
        'help:Show help'
    )
    _describe 'command' commands
}

compdef _athon athon
```

## Troubleshooting

### Command not found

Make sure `athon` is in your PATH:

```bash
export PATH="$PATH:/path/to/athon"
```

Or install system-wide:

```bash
sudo cp athon /usr/local/bin/
```

### athon-boot not found

The CLI looks for `athon-boot` in the current directory. Either:

1. Run from the Athōn root directory
2. Install `athon-boot` to PATH
3. Set `ATHON_BOOT` environment variable:

```bash
export ATHON_BOOT=/path/to/athon-boot
```

### GCC not found

Install GCC:

```bash
# Ubuntu/Debian
sudo apt-get install gcc

# macOS
xcode-select --install

# Fedora
sudo dnf install gcc
```

## Future Features

- 🔮 **REPL**: Interactive Athōn shell
- 📦 **Package manager**: Dependency management
- 🔍 **LSP server**: IDE integration
- 🎨 **Formatter**: Code formatting tool
- 📊 **Profiler**: Performance analysis
- 🧪 **Test framework**: Built-in testing
- 📚 **Documentation generator**: Auto-generate docs

## Contributing

The CLI is designed to be simple and extensible. To add a new command:

1. Add command to `HELP` string
2. Add case in `main()` match statement
3. Implement `cmd_yourcommand()` function
4. Update documentation

## License

MIT License - See LICENSE file for details
