# Athōn CLI Guide

The unified command-line interface that makes Athōn development effortless.

## Why Use the CLI?

### Before: Manual Workflow ❌

```bash
# Multiple steps, easy to forget
./athon-boot hello.at > hello.c
gcc hello.c -o hello
./hello
rm hello.c hello  # Manual cleanup
```

### After: CLI Workflow ✅

```bash
# One command, automatic cleanup
athon run hello.at
```

## Installation

The CLI is automatically built when you run `./install.sh`. You can also build it separately:

```bash
cd cli
bash build.sh
```

## Core Commands

### 1. Run - Compile and Execute

The most common command for development:

```bash
athon run hello.at
```

**What it does:**
1. Compiles `.at` → `.c`
2. Compiles `.c` → executable
3. Runs the program
4. Cleans up intermediate files

**Options:**
```bash
athon run hello.at -v              # Verbose output
athon run hello.at --keep-c        # Keep C file for inspection
athon run hello.at --no-run        # Compile only, don't execute
athon run hello.at -O              # Enable optimizations
```

### 2. Build - Create Executable

Build a standalone binary:

```bash
athon build hello.at
athon build hello.at -o my-program
athon build hello.at -O            # Optimized build
athon build hello.at -g            # Debug build
```

**Output:** Creates an executable you can distribute

### 3. New - Create Project

Scaffold a complete project structure:

```bash
athon new calculator
```

**Creates:**
```
calculator/
├── src/
│   └── main.at          # Main program
├── tests/               # Test directory
├── athon.toml          # Project configuration
├── README.md           # Documentation
└── .gitignore          # Git ignore rules
```

**Generated main.at:**
```athon
fn main() {
    print("Hello from {}!", "calculator");
}
```

### 4. Init - Initialize Current Directory

Convert existing directory to Athōn project:

```bash
mkdir my-project && cd my-project
athon init
```

### 5. Test - Run All Tests

Execute all test files in `tests/` directory:

```bash
athon test
```

**Output:**
```
🧪 Running tests...
  Testing test_math.at... ✅ PASSED
  Testing test_strings.at... ✅ PASSED
  Testing test_arrays.at... ✅ PASSED

📊 Results: 3 passed, 0 failed
```

### 6. Compile - Generate C Code

Produce C source without building:

```bash
athon compile hello.at
athon compile hello.at -o output.c
```

**Use case:** Inspect generated C code or integrate with custom build systems

### 7. Check - Syntax Validation

Verify code without compiling:

```bash
athon check hello.at
```

**Output:**
- `✅ No errors found` - Code is valid
- `❌ Errors found:` - Shows compilation errors

### 8. Clean - Remove Build Artifacts

Clean up generated files:

```bash
athon clean
```

**Removes:**
- `*.c` - C source files
- `*.o` - Object files
- `*.out` - Executables
- `build/` - Build directory
- `target/` - Target directory

## Real-World Workflows

### Quick Prototyping

```bash
# Create and test quickly
vim test.at
athon run test.at
```

### Project Development

```bash
# Set up project
athon new my-app
cd my-app

# Develop
vim src/main.at
athon run src/main.at

# Add tests
vim tests/test_main.at
athon test

# Build release
athon build src/main.at -O -o my-app
```

### Debugging

```bash
# Build with debug symbols
athon build main.at -g -o debug-app

# Debug with GDB
gdb ./debug-app
```

### Inspecting Generated Code

```bash
# Keep C file and view it
athon run main.at --keep-c -v
cat main.c
```

### Continuous Development

```bash
# Watch and run on changes (with entr or similar)
ls *.at | entr athon run main.at
```

## Command Reference

### Global Options

| Option | Short | Description |
|--------|-------|-------------|
| `--output <file>` | `-o` | Specify output file |
| `--optimize` | `-O` | Enable optimizations (gcc -O3) |
| `--debug` | `-g` | Include debug symbols |
| `--verbose` | `-v` | Show detailed output |
| `--no-run` | | Compile without executing |
| `--keep-c` | | Keep intermediate C files |

### Commands Summary

| Command | Purpose | Example |
|---------|---------|---------|
| `run` | Compile and execute | `athon run hello.at` |
| `build` | Create executable | `athon build hello.at -o app` |
| `compile` | Generate C code | `athon compile hello.at` |
| `check` | Validate syntax | `athon check hello.at` |
| `new` | Create project | `athon new my-project` |
| `init` | Initialize directory | `athon init` |
| `test` | Run tests | `athon test` |
| `clean` | Remove artifacts | `athon clean` |
| `version` | Show version | `athon version` |
| `help` | Show help | `athon help` |

## Project Configuration

Create `athon.toml` in your project root:

```toml
[package]
name = "my-project"
version = "0.1.0"
authors = ["Your Name <you@example.com>"]
description = "My awesome Athōn project"

[dependencies]
# Future: external dependencies

[build]
optimize = false
debug = true
target = "native"

[test]
verbose = true
```

## Editor Integration

### VS Code

**tasks.json:**
```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Athōn: Run",
      "type": "shell",
      "command": "athon",
      "args": ["run", "${file}"],
      "group": {
        "kind": "build",
        "isDefault": true
      },
      "presentation": {
        "reveal": "always",
        "panel": "new"
      }
    },
    {
      "label": "Athōn: Build",
      "type": "shell",
      "command": "athon",
      "args": ["build", "${file}", "-o", "${fileDirname}/${fileBasenameNoExtension}"],
      "group": "build"
    },
    {
      "label": "Athōn: Test",
      "type": "shell",
      "command": "athon",
      "args": ["test"],
      "group": "test"
    }
  ]
}
```

**Keyboard shortcuts:**
- `Ctrl+Shift+B` - Run current file
- `Ctrl+Shift+T` - Run tests

### Vim/Neovim

**Add to .vimrc:**
```vim
" Athōn commands
nnoremap <F5> :!athon run %<CR>
nnoremap <F6> :!athon build %<CR>
nnoremap <F7> :!athon test<CR>
nnoremap <F8> :!athon check %<CR>

" Async run (with vim-dispatch)
nnoremap <leader>ar :Dispatch athon run %<CR>
nnoremap <leader>ab :Dispatch athon build %<CR>
nnoremap <leader>at :Dispatch athon test<CR>
```

### Sublime Text

**Build System (Athōn.sublime-build):**
```json
{
  "cmd": ["athon", "run", "$file"],
  "file_regex": "^(.+):([0-9]+):([0-9]+): (.+)$",
  "working_dir": "$file_path",
  "selector": "source.athon",
  "variants": [
    {
      "name": "Build",
      "cmd": ["athon", "build", "$file", "-o", "$file_base_name"]
    },
    {
      "name": "Check",
      "cmd": ["athon", "check", "$file"]
    }
  ]
}
```

## Shell Integration

### Bash Completion

**~/.bashrc:**
```bash
_athon_completions() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local commands="run build compile check new init test clean repl version help"
    
    if [ $COMP_CWORD -eq 1 ]; then
        COMPREPLY=($(compgen -W "${commands}" -- ${cur}))
    elif [ $COMP_CWORD -eq 2 ]; then
        COMPREPLY=($(compgen -f -X '!*.at' -- ${cur}))
    fi
}

complete -F _athon_completions athon
```

### Zsh Completion

**~/.zshrc:**
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
    
    if (( CURRENT == 2 )); then
        _describe 'command' commands
    elif (( CURRENT == 3 )); then
        _files -g '*.at'
    fi
}

compdef _athon athon
```

### Fish Completion

**~/.config/fish/completions/athon.fish:**
```fish
complete -c athon -n "__fish_use_subcommand" -a "run" -d "Compile and run"
complete -c athon -n "__fish_use_subcommand" -a "build" -d "Build executable"
complete -c athon -n "__fish_use_subcommand" -a "compile" -d "Compile to C"
complete -c athon -n "__fish_use_subcommand" -a "check" -d "Check syntax"
complete -c athon -n "__fish_use_subcommand" -a "new" -d "Create project"
complete -c athon -n "__fish_use_subcommand" -a "init" -d "Initialize project"
complete -c athon -n "__fish_use_subcommand" -a "test" -d "Run tests"
complete -c athon -n "__fish_use_subcommand" -a "clean" -d "Clean artifacts"
complete -c athon -n "__fish_use_subcommand" -a "version" -d "Show version"
complete -c athon -n "__fish_use_subcommand" -a "help" -d "Show help"

complete -c athon -s o -l output -d "Output file"
complete -c athon -s O -l optimize -d "Enable optimizations"
complete -c athon -s g -l debug -d "Debug symbols"
complete -c athon -s v -l verbose -d "Verbose output"
```

## Aliases and Shortcuts

Add to your shell config:

```bash
# Quick aliases
alias ar='athon run'
alias ab='athon build'
alias ac='athon check'
alias at='athon test'

# Development workflow
alias adev='athon run src/main.at'
alias atest='athon test && athon run src/main.at'
alias arelease='athon build src/main.at -O -o release'
```

## CI/CD Integration

### GitHub Actions

**.github/workflows/test.yml:**
```yaml
name: Test

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v2
      
      - name: Install Rust
        uses: actions-rs/toolchain@v1
        with:
          toolchain: stable
      
      - name: Install Athōn
        run: |
          ./install.sh
          echo "$PWD" >> $GITHUB_PATH
      
      - name: Run tests
        run: athon test
      
      - name: Build release
        run: athon build src/main.at -O -o app
```

### GitLab CI

**.gitlab-ci.yml:**
```yaml
test:
  image: rust:latest
  before_script:
    - apt-get update && apt-get install -y gcc
    - ./install.sh
  script:
    - ./athon test
    - ./athon build src/main.at -O -o app
  artifacts:
    paths:
      - app
```

## Tips and Tricks

### 1. Quick Testing

```bash
# Test without saving to file
echo 'fn main() { print("test"); }' | athon run /dev/stdin
```

### 2. Benchmark Builds

```bash
# Compare optimization levels
time athon build main.at -o normal
time athon build main.at -O -o optimized

# Compare execution
time ./normal
time ./optimized
```

### 3. Parallel Testing

```bash
# Run tests in parallel (with GNU parallel)
find tests -name '*.at' | parallel athon run {}
```

### 4. Watch for Changes

```bash
# Auto-run on file changes (with entr)
ls src/*.at | entr -c athon run src/main.at

# Or with watchexec
watchexec -e at 'athon run src/main.at'
```

### 5. Profile Generated Code

```bash
# Build with profiling
athon build main.at -g -o app
valgrind --tool=callgrind ./app
kcachegrind callgrind.out.*
```

## Troubleshooting

### CLI not found

```bash
# Add to PATH
export PATH="$PATH:/path/to/athon"

# Or create symlink
sudo ln -s /path/to/athon /usr/local/bin/athon
```

### athon-boot not found

The CLI looks for `athon-boot` in the current directory. Solutions:

```bash
# Option 1: Run from Athōn root
cd /path/to/athon
./athon run examples/hello.at

# Option 2: Set environment variable
export ATHON_BOOT=/path/to/athon-boot

# Option 3: Install system-wide
sudo cp athon-boot /usr/local/bin/
```

### Permission denied

```bash
# Make CLI executable
chmod +x athon

# Or rebuild
cd cli && bash build.sh
```

## Future Features

Coming soon:

- 🔮 **REPL**: Interactive shell
- 📦 **Package manager**: Dependency management
- 🔍 **LSP server**: IDE integration
- 🎨 **Formatter**: Code formatting
- 📊 **Profiler**: Performance analysis
- 🧪 **Coverage**: Test coverage reports
- 📚 **Doc generator**: Auto-generate documentation
- 🌐 **Web playground**: Online compiler

## Feedback

The CLI is designed to make your life easier. If you have suggestions or find issues:

1. Open an issue on GitHub
2. Describe your workflow
3. Suggest improvements

We're constantly improving the developer experience!

---

**Happy coding with Athōn CLI! 🚀**
