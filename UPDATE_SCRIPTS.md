# Athōn Update Scripts

Quick reference for updating your local Athōn installation after making changes to the compiler or CLI.

## Available Scripts

### 1. `./update.sh` - Full Interactive Update
**Best for**: First-time setup, major updates, or when you want detailed feedback

**Features**:
- ✅ Rebuilds bootstrap compiler
- ✅ Rebuilds CLI tool
- ✅ Installs both system-wide
- ✅ Runs verification tests
- ✅ Detailed progress output
- ✅ Optional full test suite
- ✅ Interactive prompts

**Usage**:
```bash
./update.sh
```

**Output**: Detailed progress with colored output and verification steps.

---

### 2. `./quick-update.sh` - Fast Silent Update
**Best for**: Quick iterations during development

**Features**:
- ⚡ Minimal output
- ⚡ Fast execution
- ⚡ Rebuilds and installs everything
- ⚡ Quick smoke test
- ⚡ No prompts

**Usage**:
```bash
./quick-update.sh
```

**Output**: One-line status for each step (✓ or ✗).

**Time**: ~5-10 seconds

---

### 3. `./dev-update.sh` - Development Workflow
**Best for**: Active development with automatic testing

**Features**:
- 🔧 Rebuilds compiler and CLI
- 🔧 Installs system-wide
- 🔧 Runs smoke test
- 🔧 Runs full test suite automatically
- 🔧 Shows test results

**Usage**:
```bash
./dev-update.sh
```

**Output**: Build status + full test results.

**Time**: ~15-20 seconds

---

## Quick Comparison

| Script | Speed | Output | Tests | Interactive |
|--------|-------|--------|-------|-------------|
| `update.sh` | Slow | Detailed | Optional | Yes |
| `quick-update.sh` | Fast | Minimal | Smoke only | No |
| `dev-update.sh` | Medium | Moderate | Full suite | No |

---

## Typical Workflows

### Making a Small Change
```bash
# Edit compiler/bootstrap/src/parser.rs
vim compiler/bootstrap/src/parser.rs

# Quick rebuild and test
./quick-update.sh
```

### Adding a New Feature
```bash
# Edit multiple files
vim compiler/bootstrap/src/ast.rs
vim compiler/bootstrap/src/parser.rs
vim compiler/bootstrap/src/codegen.rs

# Full rebuild with tests
./dev-update.sh
```

### After Pulling Changes
```bash
# Get latest code
git pull

# Full update with verification
./update.sh
```

### Before Committing
```bash
# Make sure everything works
./dev-update.sh

# If all tests pass, commit
git add .
git commit -m "Add new feature"
```

---

## What Each Script Does

### Build Steps
All scripts perform these core steps:

1. **Build Bootstrap Compiler**
   ```bash
   cd compiler/bootstrap
   cargo build --release
   cp target/release/athon-boot ../../athon-boot
   ```

2. **Install Compiler System-Wide**
   ```bash
   sudo cp athon-boot /usr/local/bin/athon-boot
   ```

3. **Build CLI Tool** (if exists)
   ```bash
   cd cli
   cargo build --release
   ```

4. **Install CLI System-Wide**
   ```bash
   sudo cp cli/target/release/athon /usr/local/bin/athon
   ```

### Test Steps

- **Smoke Test**: Compiles and runs `examples/hello.at`
- **Full Test Suite**: Runs `test-all-examples.sh` (50 examples)

---

## Manual Commands

If you prefer manual control:

### Rebuild Compiler Only
```bash
cd compiler/bootstrap
bash build.sh
cd ../..
```

### Rebuild CLI Only
```bash
cd cli
bash build.sh
cd ..
```

### Install System-Wide
```bash
sudo cp athon-boot /usr/local/bin/
sudo cp cli/target/release/athon /usr/local/bin/
```

### Run Tests
```bash
bash test-all-examples.sh           # Regular tests
bash test-all-examples-verbose.sh   # Detailed output
bash test-all-examples-cli.sh       # CLI tests
```

---

## Troubleshooting

### Permission Denied
If you get "Permission denied" errors:
```bash
chmod +x update.sh quick-update.sh dev-update.sh
```

### Sudo Password
All scripts require sudo for system-wide installation. You'll be prompted once.

### Build Failures
If builds fail:
1. Check Rust is installed: `rustc --version`
2. Update Rust: `rustup update`
3. Clean build: `cd compiler/bootstrap && cargo clean && cd ../..`
4. Try again: `./update.sh`

### Test Failures
If tests fail after update:
1. Check which tests failed
2. Run verbose tests: `bash test-all-examples-verbose.sh`
3. Test individual file: `athon run examples/failing_test.at -v`

---

## Environment Variables

You can customize behavior with environment variables:

```bash
# Skip sudo (for testing)
SKIP_INSTALL=1 ./quick-update.sh

# Verbose cargo output
CARGO_VERBOSE=1 ./update.sh

# Skip tests
SKIP_TESTS=1 ./dev-update.sh
```

---

## Integration with Git Hooks

You can add these to git hooks for automatic updates:

### Post-Merge Hook
```bash
#!/bin/bash
# .git/hooks/post-merge
echo "Running quick update after merge..."
./quick-update.sh
```

### Pre-Commit Hook
```bash
#!/bin/bash
# .git/hooks/pre-commit
echo "Running tests before commit..."
./dev-update.sh
```

---

## Performance Tips

### Faster Builds
```bash
# Use more CPU cores
export CARGO_BUILD_JOBS=8

# Use faster linker (if available)
export RUSTFLAGS="-C link-arg=-fuse-ld=lld"
```

### Skip Unnecessary Steps
```bash
# Only rebuild compiler (not CLI)
cd compiler/bootstrap && bash build.sh && cd ../..
sudo cp athon-boot /usr/local/bin/
```

---

## Summary

**Quick Reference**:
- 🚀 **Fast update**: `./quick-update.sh`
- 🔧 **Dev workflow**: `./dev-update.sh`
- 📋 **Full update**: `./update.sh`

**After any update, you can use**:
```bash
athon run examples/hello.at        # Run with CLI
./athon-boot examples/hello.at     # Direct compilation
athon version                      # Check version
```

---

*Last Updated: November 21, 2025*
