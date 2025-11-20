# Athōn CI/CD Scripts

Continuous Integration and Deployment scripts for the Athōn programming language project.

## Scripts

### 1. no_external_deps_check.sh

**Purpose:** Verify sovereignty principle - no external runtime dependencies

**Usage:**
```bash
./ci/no_external_deps_check.sh
```

**Checks:**
1. ✅ Cargo.toml has no external dependencies
2. ✅ No `extern crate` declarations (except std)
3. ✅ No external crate usage
4. ✅ Only standard library usage
5. ✅ No network dependencies
6. ✅ No database dependencies
7. ✅ No external serialization dependencies

**Exit Codes:**
- `0` - All checks passed (no external dependencies)
- `1` - Found external dependencies (sovereignty violation)

**Example Output:**
```
✅ SUCCESS: No external dependencies found!

The Athōn project maintains its sovereignty principle:
  ✓ Zero external runtime dependencies
  ✓ Only Rust standard library used
  ✓ Self-contained compiler
```

---

### 2. static_checks.sh

**Purpose:** Run comprehensive static analysis on the codebase

**Usage:**
```bash
./ci/static_checks.sh
```

**Checks:**
1. ✅ External dependencies check
2. ✅ Rust code formatting (rustfmt)
3. ✅ Rust clippy lints
4. ℹ️  TODO/FIXME comments (informational)
5. ℹ️  Trailing whitespace (informational)
6. ✅ File permissions (no executable source files)
7. ✅ Example compilation (all examples compile)

**Exit Codes:**
- `0` - All checks passed
- `1` - One or more checks failed

**Example Output:**
```
════════════════════════════════════════════════════════════════
Static Analysis Summary:
════════════════════════════════════════════════════════════════
Total Checks:  7
Passed:        7
Failed:        0
════════════════════════════════════════════════════════════════
✅ All static checks passed!
```

---

### 3. repro_build.sh

**Purpose:** Verify reproducible builds (deterministic compilation)

**Usage:**
```bash
./ci/repro_build.sh
```

**Process:**
1. Clean all previous builds
2. Build compiler (Stage 1)
3. Build compiler again (Stage 2)
4. Compare SHA256 hashes
5. Verify builds are identical

**Exit Codes:**
- `0` - Builds are reproducible (hashes match)
- `1` - Builds differ (non-deterministic)

**Example Output:**
```
Stage 1 Hash: abc123...
Stage 2 Hash: abc123...

✅ SUCCESS: Builds are reproducible!

The compiler produces identical binaries across builds.
```

---

## CI/CD Integration

### GitHub Actions

```yaml
name: CI

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
      
      - name: Check Dependencies
        run: ./ci/no_external_deps_check.sh
      
      - name: Static Analysis
        run: ./ci/static_checks.sh
      
      - name: Build Compiler
        run: cd compiler/bootstrap && cargo build --release
      
      - name: Test Examples
        run: ./test-all-examples.sh
      
      - name: Reproducible Build
        run: ./ci/repro_build.sh
```

### GitLab CI

```yaml
stages:
  - check
  - build
  - test

dependencies:
  stage: check
  script:
    - ./ci/no_external_deps_check.sh

static_analysis:
  stage: check
  script:
    - ./ci/static_checks.sh

build:
  stage: build
  script:
    - cd compiler/bootstrap && cargo build --release

test:
  stage: test
  script:
    - ./test-all-examples.sh

reproducible:
  stage: test
  script:
    - ./ci/repro_build.sh
```

### Jenkins

```groovy
pipeline {
    agent any
    
    stages {
        stage('Check Dependencies') {
            steps {
                sh './ci/no_external_deps_check.sh'
            }
        }
        
        stage('Static Analysis') {
            steps {
                sh './ci/static_checks.sh'
            }
        }
        
        stage('Build') {
            steps {
                sh 'cd compiler/bootstrap && cargo build --release'
            }
        }
        
        stage('Test') {
            steps {
                sh './test-all-examples.sh'
            }
        }
        
        stage('Reproducible Build') {
            steps {
                sh './ci/repro_build.sh'
            }
        }
    }
}
```

---

## Local Development

### Pre-commit Hook

Create `.git/hooks/pre-commit`:

```bash
#!/bin/bash
# Pre-commit hook for Athōn project

echo "Running pre-commit checks..."

# Check dependencies
if ! ./ci/no_external_deps_check.sh; then
    echo "❌ Dependency check failed"
    exit 1
fi

# Run static checks
if ! ./ci/static_checks.sh; then
    echo "❌ Static checks failed"
    exit 1
fi

echo "✅ Pre-commit checks passed"
```

Make it executable:
```bash
chmod +x .git/hooks/pre-commit
```

### Quick Check

Run all CI checks locally:

```bash
# Quick check
./ci/no_external_deps_check.sh && \
./ci/static_checks.sh && \
./test-all-examples.sh

# Full check (includes reproducible build)
./ci/no_external_deps_check.sh && \
./ci/static_checks.sh && \
./test-all-examples.sh && \
./ci/repro_build.sh
```

---

## Requirements

### System Requirements

- **Rust:** 1.70+ (for building compiler)
- **GCC:** Any recent version (for compiling generated C code)
- **Bash:** 4.0+ (for running scripts)
- **Standard Unix tools:** grep, awk, sed, sha256sum

### Optional Tools

- **rustfmt:** For code formatting checks
- **clippy:** For lint checks
- **cargo:** For building (required)

### Installation

**Rust (includes cargo, rustfmt, clippy):**
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup component add rustfmt clippy
```

**GCC (Ubuntu/Debian):**
```bash
sudo apt-get install build-essential
```

**GCC (macOS):**
```bash
xcode-select --install
```

---

## Troubleshooting

### Script Fails to Run

**Issue:** Permission denied

**Solution:**
```bash
chmod +x ci/*.sh
```

### Dependency Check Fails

**Issue:** False positive for project's own crate

**Solution:** The script excludes `athon_bootstrap` (project crate). If you rename the crate, update the script.

### Static Checks Fail

**Issue:** Formatting or lint errors

**Solution:**
```bash
# Fix formatting
cd compiler/bootstrap
cargo fmt

# Fix clippy warnings
cargo clippy --fix
```

### Reproducible Build Fails

**Issue:** Builds produce different hashes

**Possible Causes:**
- Timestamps in binary
- Random values in compilation
- Non-deterministic optimization
- Environment-dependent behavior

**Solution:** Check Cargo.toml for deterministic build settings:
```toml
[profile.release]
opt-level = 3
lto = true
codegen-units = 1
strip = true
```

---

## Maintenance

### Adding New Checks

1. Edit the appropriate script
2. Add new check function
3. Update check counter
4. Test locally
5. Update this README

### Updating Scripts

1. Make changes to script
2. Test with: `bash -n script.sh` (syntax check)
3. Run script locally
4. Verify exit codes
5. Update documentation

---

## Best Practices

### For Contributors

1. **Run checks before committing:**
   ```bash
   ./ci/static_checks.sh
   ```

2. **Test examples after changes:**
   ```bash
   ./test-all-examples.sh
   ```

3. **Verify no external dependencies:**
   ```bash
   ./ci/no_external_deps_check.sh
   ```

### For Maintainers

1. **Run full CI suite:**
   ```bash
   ./ci/no_external_deps_check.sh && \
   ./ci/static_checks.sh && \
   ./test-all-examples.sh && \
   ./ci/repro_build.sh
   ```

2. **Check before releases:**
   - All CI checks pass
   - All examples compile and run
   - Builds are reproducible
   - No external dependencies

---

## Status

**Current Status:** ✅ All scripts working

**Last Updated:** 2024-11-20

**Scripts:**
- `no_external_deps_check.sh` - ✅ Working
- `static_checks.sh` - ✅ Working
- `repro_build.sh` - ✅ Working

**Test Coverage:**
- Dependency checks: 7 checks
- Static analysis: 7 checks
- Reproducible builds: 2-stage verification
- Example tests: 31 examples

---

## Contributing

When adding new CI checks:

1. Follow existing script structure
2. Use color-coded output
3. Provide clear error messages
4. Return proper exit codes (0 = success, 1 = failure)
5. Update this README
6. Test thoroughly

---

## License

See [LICENSE](../LICENSE) for license information.
