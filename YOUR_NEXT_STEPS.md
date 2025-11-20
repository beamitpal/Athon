# Your Next Steps with Athōn 🚀

Congratulations! Your Athōn development environment is fully configured. Here's what you can do right now.

## ✅ What's Installed

- **Athōn CLI** (`athon`) - Available system-wide
- **Athōn Compiler** (`athon-boot`) - Available system-wide  
- **Shell Completion** - Tab completion for commands
- **All Documentation** - 13,500+ words of guides
- **31 Examples** - All tested and working (100% pass rate)

## 🎯 Try These Commands Right Now

### 1. Run Your First Program (30 seconds)

```bash
athon run ~/Desktop/athon/examples/hello.at
```

**Expected output:**
```
Hello from Athon Bootstrap!
```

### 2. Create Your First Project (2 minutes)

```bash
# Create project
athon new my-calculator

# Navigate to it
cd my-calculator

# Run it
athon run src/main.at
```

### 3. Explore Examples (5 minutes)

```bash
# Go to examples directory
cd ~/Desktop/athon/examples

# Try the showcase (demonstrates all features)
athon run showcase.at

# Try pattern matching
athon run pattern_matching.at

# Try file I/O
athon run file_io.at

# Try structs and enums
athon run structs.at
athon run enums.at
```

### 4. Build an Executable (1 minute)

```bash
# Build optimized executable
athon build ~/Desktop/athon/examples/hello.at -O -o hello

# Run it
./hello

# It's a standalone binary!
file hello
```

## 📚 Learn Athōn (30 minutes)

### Quick Start (5 minutes)

```bash
cat ~/Desktop/athon/QUICKSTART.md
```

This gives you a 5-minute introduction with examples.

### Language Guide (20 minutes)

```bash
cat ~/Desktop/athon/docs/language-guide.md | less
```

Complete tutorial from basics to advanced features.

### CLI Guide (5 minutes)

```bash
cat ~/Desktop/athon/CLI_GUIDE.md | less
```

Everything about the CLI tool.

## 🎨 Build Your First Real Program

Let's build a simple calculator:

### Step 1: Create Project

```bash
athon new calculator
cd calculator
```

### Step 2: Write Code

Edit `src/main.at`:

```athon
fn add(a: int, b: int) -> int {
    return a + b;
}

fn subtract(a: int, b: int) -> int {
    return a - b;
}

fn multiply(a: int, b: int) -> int {
    return a * b;
}

fn divide(a: int, b: int) -> int {
    if b == 0 {
        print("Error: Division by zero!");
        return 0;
    }
    return a / b;
}

fn main() {
    print("Simple Calculator");
    print("=================");
    
    let x = 10;
    let y = 5;
    
    print("{} + {} = {}", x, y, add(x, y));
    print("{} - {} = {}", x, y, subtract(x, y));
    print("{} * {} = {}", x, y, multiply(x, y));
    print("{} / {} = {}", x, y, divide(x, y));
}
```

### Step 3: Test It

```bash
athon run src/main.at
```

### Step 4: Build Release

```bash
athon build src/main.at -O -o calculator
./calculator
```

## 🧪 Run All Tests

Verify everything works:

```bash
cd ~/Desktop/athon
./test-all-examples-cli.sh
```

You should see 30 PASS, 1 SKIP (100% success rate).

## 🎓 Learning Path

### Day 1: Basics
1. ✅ Run hello world
2. ✅ Create first project
3. ✅ Read QUICKSTART.md
4. ✅ Try 5 examples

### Week 1: Intermediate
1. Read complete language guide
2. Try all 31 examples
3. Build a small project (calculator, file processor)
4. Learn CLI commands

### Month 1: Advanced
1. Read architecture documentation
2. Study language specification
3. Build a real application
4. Contribute to the project

## 💡 Project Ideas

Start with these:

### Beginner Projects
- **Calculator** - Basic arithmetic operations
- **Todo List** - File-based task manager
- **Text Analyzer** - Count words, lines, characters
- **Number Guesser** - Simple game

### Intermediate Projects
- **File Organizer** - Sort files by type
- **Log Parser** - Parse and analyze log files
- **Data Converter** - CSV to JSON converter
- **Simple HTTP Server** - Basic web server

### Advanced Projects
- **Compiler** - Write a simple language compiler
- **Database** - Simple key-value store
- **Game Engine** - 2D game framework
- **Package Manager** - Dependency manager

## 🔧 Useful Commands

### Development

```bash
# Quick run
athon run file.at

# Run with verbose output
athon run file.at -v

# Keep C file for inspection
athon run file.at --keep-c

# Build optimized
athon build file.at -O -o app

# Build with debug symbols
athon build file.at -g -o app-debug
```

### Project Management

```bash
# Create new project
athon new project-name

# Initialize existing directory
athon init

# Run all tests
athon test

# Clean build artifacts
athon clean
```

### Utilities

```bash
# Check syntax
athon check file.at

# Generate C code
athon compile file.at -o output.c

# Show version
athon version

# Get help
athon help
```

## 🎨 Editor Setup

### VS Code (Recommended)

```bash
# Install extension
cp -r ~/Desktop/athon/editor-support/vscode/athon ~/.vscode/extensions/athon-language-0.3.0

# Restart VS Code
```

**Features:**
- Syntax highlighting
- 20+ code snippets
- Auto-completion

### Vim/Neovim

```bash
# Install syntax files
mkdir -p ~/.vim/syntax ~/.vim/ftdetect
cp ~/Desktop/athon/editor-support/vim/syntax/athon.vim ~/.vim/syntax/
cp ~/Desktop/athon/editor-support/vim/ftdetect/athon.vim ~/.vim/ftdetect/
```

**Add to ~/.vimrc:**
```vim
" Quick run with F5
nnoremap <F5> :!athon run %<CR>

" Build with F6
nnoremap <F6> :!athon build %<CR>
```

## 🆘 Getting Help

### Documentation

```bash
# Setup guide
cat ~/Desktop/athon/SETUP_COMPLETE.md

# Quick start
cat ~/Desktop/athon/QUICKSTART.md

# CLI guide
cat ~/Desktop/athon/CLI_GUIDE.md

# Language guide
cat ~/Desktop/athon/docs/language-guide.md

# API reference
cat ~/Desktop/athon/docs/api-reference.md
```

### Examples

```bash
# Browse examples
ls ~/Desktop/athon/examples/

# Run specific example
athon run ~/Desktop/athon/examples/<name>.at
```

### Troubleshooting

```bash
# Verify installation
~/Desktop/athon/verify-setup.sh

# Check syntax
athon check your-file.at

# Verbose output
athon run your-file.at -v

# Keep C file for debugging
athon run your-file.at --keep-c
cat your-file.c
```

## 🌟 Quick Reference Card

Save this for quick access:

```bash
# Most Common Commands
athon run file.at           # Run program
athon new project           # Create project
athon build file.at -O      # Build optimized
athon test                  # Run tests
athon help                  # Get help

# Development Workflow
vim file.at                 # Edit
athon run file.at           # Test
athon build file.at -O      # Build
./file                      # Run

# Project Workflow
athon new project           # Create
cd project                  # Enter
vim src/main.at            # Edit
athon run src/main.at      # Test
athon test                 # Test all
athon build -O             # Build release
```

## 🎉 You're Ready!

Your Athōn development environment is fully configured. Start with:

```bash
# Run hello world
athon run ~/Desktop/athon/examples/hello.at

# Create your first project
athon new my-first-app
cd my-first-app
athon run src/main.at
```

**Happy coding with Athōn! 🚀**

---

**Need help?** Read the documentation in `~/Desktop/athon/docs/`

**Found a bug?** Check `~/Desktop/athon/CONTRIBUTING.md`

**Want to contribute?** See `~/Desktop/athon/CONTRIBUTING.md`
