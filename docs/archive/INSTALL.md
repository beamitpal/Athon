# Installing Athōn

Complete installation guide for the Athōn programming language.

## Quick Install

```bash
# Clone the repository
git clone https://github.com/beamitpal/athon.git
cd athon

# Build the compiler
cd compiler/bootstrap
bash build.sh
cd ../..

# Test installation
./athon-boot examples/hello.at > hello.c
gcc hello.c -o hello
./hello
```

---

## Prerequisites

### Required

1. **Rust** (1.70 or later)
   - Used to build the bootstrap compiler
   - Install from: https://rustup.rs/

2. **GCC or Clang**
   - Used to compile generated C code
   - Usually pre-installed on Linux/macOS
   - Windows: Install MinGW or MSVC

### Optional

- **Git** - For cloning the repository
- **Make** - For using Makefile (if provided)

---

## Installation Methods

### Method 1: Build from Source (Recommended)

#### Step 1: Install Rust

**Linux/macOS:**
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
```

**Windows:**
- Download from: https://rustup.rs/
- Run the installer
- Restart your terminal

**Verify installation:**
```bash
rustc --version
cargo --version
```

#### Step 2: Install GCC

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install build-essential
```

**Fedora/RHEL:**
```bash
sudo dnf install gcc gcc-c++ make
```

**macOS:**
```bash
xcode-select --install
```

**Windows:**
- Install MinGW: https://www.mingw-w64.org/
- Or install Visual Studio with C++ tools

**Verify installation:**
```bash
gcc --version
```

#### Step 3: Clone Repository

```bash
git clone https://github.com/beamitpal/athon.git
cd athon
```

Or download ZIP:
- Go to: https://github.com/beamitpal/athon
- Click "Code" → "Download ZIP"
- Extract and navigate to the directory

#### Step 4: Build Compiler

```bash
cd compiler/bootstrap
bash build.sh
```

This will:
- Build the Rust bootstrap compiler
- Create the `athon-boot` binary
- Copy it to the project root

**Expected output:**
```
╔════════════════════════════════════════════════════════════════╗
║     Building Athōn Bootstrap Compiler (Stage 0)               ║
╚════════════════════════════════════════════════════════════════╝

📦 Building with Cargo...
   Compiling athon-bootstrap v0.1.0
    Finished `release` profile [optimized] target(s) in 7.5s

📋 Copying binary...

✅ Build complete!

Binary location: ./athon-boot
```

#### Step 5: Verify Installation

```bash
cd ../..  # Return to project root
./athon-boot examples/hello.at > hello.c
gcc hello.c -o hello
./hello
```

**Expected output:**
```
Hello, Athōn!
```

---

### Method 2: Install System-Wide (Linux/macOS)

After building the compiler:

```bash
# Copy binary to system path
sudo cp athon-boot /usr/local/bin/

# Verify
athon-boot examples/hello.at > hello.c
gcc hello.c -o hello
./hello
```

---

### Method 3: Add to PATH (All Platforms)

#### Linux/macOS

Add to `~/.bashrc` or `~/.zshrc`:

```bash
export PATH="$PATH:/path/to/athon"
```

Then:
```bash
source ~/.bashrc  # or ~/.zshrc
athon-boot examples/hello.at > hello.c
```

#### Windows

1. Open "Environment Variables"
2. Edit "Path" variable
3. Add: `C:\path\to\athon`
4. Restart terminal

---

## Usage

### Basic Workflow

1. **Write Athōn code** (`.at` file)
2. **Compile to C** using `athon-boot`
3. **Compile C to binary** using `gcc`
4. **Run** the binary

### Example

**Create `hello.at`:**
```athon
fn main() {
    print("Hello, World!");
}
```

**Compile and run:**
```bash
# Compile Athōn to C
athon-boot hello.at > hello.c

# Compile C to binary
gcc hello.c -o hello

# Run
./hello
```

**Output:**
```
Hello, World!
```

---

## Editor Setup

### VS Code

```bash
# Install extension
cp -r editor-support/vscode/athon ~/.vscode/extensions/athon-language-0.3.0

# Restart VS Code
```

Features:
- Syntax highlighting
- 20+ code snippets
- Auto-completion
- Bracket matching

### Sublime Text

```bash
# Install syntax
cp editor-support/sublime-text/Athon.sublime-syntax \
   ~/.config/sublime-text/Packages/User/

# Restart Sublime Text
```

### Vim/Neovim

```bash
# Install syntax files
mkdir -p ~/.vim/syntax ~/.vim/ftdetect
cp editor-support/vim/syntax/athon.vim ~/.vim/syntax/
cp editor-support/vim/ftdetect/athon.vim ~/.vim/ftdetect/

# Restart Vim
```

See [editor-support/INSTALLATION.md](editor-support/INSTALLATION.md) for details.

---

## Testing Installation

### Run All Examples

```bash
./test-all-examples.sh
```

**Expected output:**
```
╔════════════════════════════════════════════════════════════════╗
║              Athōn Examples Test Suite                        ║
╚════════════════════════════════════════════════════════════════╝

Found 31 example files

Testing arithmetic.at... PASS
Testing arrays.at... PASS
...
Testing structs.at... PASS

════════════════════════════════════════════════════════════════
Test Results:
════════════════════════════════════════════════════════════════
Total:   31
Passed:  30
Failed:  0
Skipped: 1
════════════════════════════════════════════════════════════════
✅ All tests passed!
```

### Try Examples

```bash
# Hello World
./athon-boot examples/hello.at > hello.c && gcc hello.c -o hello && ./hello

# Arithmetic
./athon-boot examples/arithmetic.at > arithmetic.c && gcc arithmetic.c -o arithmetic && ./arithmetic

# Structs
./athon-boot examples/structs.at > structs.c && gcc structs.c -o structs && ./structs

# Pattern Matching
./athon-boot examples/match_simple.at > match.c && gcc match.c -o match && ./match

# Showcase (comprehensive demo)
./athon-boot examples/showcase.at > showcase.c && gcc showcase.c -o showcase && ./showcase
```

---

## Troubleshooting

### Issue: "rustc: command not found"

**Solution:** Install Rust
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
```

### Issue: "gcc: command not found"

**Solution:** Install GCC

**Ubuntu/Debian:**
```bash
sudo apt-get install build-essential
```

**macOS:**
```bash
xcode-select --install
```

### Issue: "cargo: command not found"

**Solution:** Add Cargo to PATH
```bash
source $HOME/.cargo/env
```

Or add to `~/.bashrc`:
```bash
export PATH="$HOME/.cargo/bin:$PATH"
```

### Issue: Build fails with "permission denied"

**Solution:** Make build script executable
```bash
chmod +x compiler/bootstrap/build.sh
```

### Issue: "athon-boot: command not found"

**Solution:** Use full path or add to PATH
```bash
# Use full path
./athon-boot examples/hello.at

# Or add to PATH
export PATH="$PATH:$(pwd)"
```

### Issue: Generated C code doesn't compile

**Solution:** Check GCC version and install math library
```bash
gcc --version  # Should be 7.0 or later
gcc hello.c -o hello -lm  # Add -lm for math functions
```

### Issue: Examples fail to run

**Solution:** Rebuild compiler
```bash
cd compiler/bootstrap
cargo clean
cargo build --release
cp target/release/athon-boot ../../athon-boot
cd ../..
```

---

## Uninstallation

### Remove Binary

```bash
# If installed system-wide
sudo rm /usr/local/bin/athon-boot

# If in project directory
rm athon-boot
```

### Remove Editor Support

**VS Code:**
```bash
rm -rf ~/.vscode/extensions/athon-language-0.3.0
```

**Sublime Text:**
```bash
rm ~/.config/sublime-text/Packages/User/Athon.sublime-syntax
```

**Vim:**
```bash
rm ~/.vim/syntax/athon.vim
rm ~/.vim/ftdetect/athon.vim
```

### Remove Project

```bash
cd ..
rm -rf athon
```

---

## Advanced Installation

### Building with Optimizations

```bash
cd compiler/bootstrap
RUSTFLAGS="-C target-cpu=native" cargo build --release
cp target/release/athon-boot ../../athon-boot
```

### Cross-Compilation

```bash
# Install target
rustup target add x86_64-unknown-linux-musl

# Build for target
cd compiler/bootstrap
cargo build --release --target x86_64-unknown-linux-musl
```

### Development Build (Faster, Unoptimized)

```bash
cd compiler/bootstrap
cargo build  # Without --release
cp target/debug/athon-boot ../../athon-boot
```

---

## Docker Installation

### Using Docker

**Create Dockerfile:**
```dockerfile
FROM rust:1.70 as builder

WORKDIR /athon
COPY . .

RUN cd compiler/bootstrap && cargo build --release
RUN cp compiler/bootstrap/target/release/athon-boot /usr/local/bin/

FROM gcc:latest
COPY --from=builder /usr/local/bin/athon-boot /usr/local/bin/
COPY examples /examples

WORKDIR /workspace
CMD ["bash"]
```

**Build and run:**
```bash
docker build -t athon .
docker run -it athon

# Inside container
athon-boot /examples/hello.at > hello.c
gcc hello.c -o hello
./hello
```

---

## Package Managers (Future)

### Homebrew (macOS/Linux) - Coming Soon

```bash
brew install athon
```

### APT (Debian/Ubuntu) - Coming Soon

```bash
sudo apt-get install athon
```

### Cargo Install - Coming Soon

```bash
cargo install athon
```

---

## Verification

### Verify Installation

```bash
# Check binary exists
which athon-boot  # or: ls -l athon-boot

# Check version
./athon-boot --version  # (if implemented)

# Test compilation
echo 'fn main() { print("OK"); }' > test.at
./athon-boot test.at > test.c
gcc test.c -o test
./test
rm test.at test.c test
```

### Run CI Checks

```bash
# Check dependencies
./ci/no_external_deps_check.sh

# Run static analysis
./ci/static_checks.sh

# Test all examples
./test-all-examples.sh

# Verify reproducible builds
./ci/repro_build.sh
```

---

## Getting Help

### Documentation

- [Language Guide](docs/language-guide.md)
- [API Reference](docs/api-reference.md)
- [Examples](examples/)
- [FAQ](docs/faq.md) (if exists)

### Community

- GitHub Issues: https://github.com/beamitpal/athon/issues
- Discussions: https://github.com/beamitpal/athon/discussions

### Reporting Issues

When reporting installation issues, include:

1. Operating system and version
2. Rust version (`rustc --version`)
3. GCC version (`gcc --version`)
4. Error messages (full output)
5. Steps to reproduce

---

## Next Steps

After installation:

1. **Read the Language Guide:** [docs/language-guide.md](docs/language-guide.md)
2. **Try Examples:** Explore the `examples/` directory
3. **Install Editor Support:** See [editor-support/INSTALLATION.md](editor-support/INSTALLATION.md)
4. **Write Your First Program:** Start with `hello.at`
5. **Join the Community:** Contribute and get help

---

## System Requirements

### Minimum

- **OS:** Linux, macOS, or Windows
- **RAM:** 512 MB
- **Disk:** 100 MB for compiler
- **CPU:** Any modern processor

### Recommended

- **OS:** Linux (Ubuntu 20.04+) or macOS (10.15+)
- **RAM:** 2 GB
- **Disk:** 500 MB (for development)
- **CPU:** Multi-core processor

---

## Build Times

Typical build times on different systems:

| System | CPU | Time |
|--------|-----|------|
| Linux Desktop | i7-8700K | ~7s |
| macOS Laptop | M1 | ~5s |
| Linux Server | Xeon E5 | ~10s |
| Raspberry Pi 4 | ARM Cortex-A72 | ~45s |

---

## License

Athōn is released under the MIT License. See [LICENSE](LICENSE) for details.

---

## Contributing

Want to contribute? See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

**Installation complete! Welcome to Athōn! 🎉**

For questions or issues, please visit:
https://github.com/beamitpal/athon/issues
