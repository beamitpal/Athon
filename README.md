# Athōn Language (athon)

Athōn is a sovereign, capability-secure, quantum-resistant systems programming language designed for high-assurance environments. It prioritizes complete self-reliance, enforcing a strict "no external dependencies" policy to ensure supply chain security and build reproducibility. Athōn is built to last for decades, with a focus on deterministic compilation and a zero-trust architecture where every resource access requires an explicit capability token.

## Core Invariants

1. **Sovereignty**: Zero external dependencies. The repository is self-contained.
2. **Security**: Capability-based security model enforced at the type level.
3. **Reproducibility**: Bit-for-bit deterministic builds, verified by double-compilation.
4. **Permanence**: Single monorepo, air-gap friendly, designed for long-term maintenance.

## Repository Layout

- `athon-spec/`: The normative specification of the language and its invariants.
- `compiler/`: The self-hosting compiler implementation (bootstrap, frontend, IR, backend).
- `std/`: The minimal standard library, strictly namespaced and capability-gated.
- `examples/`: 31 working example programs demonstrating all language features.
- `docs/`: Language guide, API reference, and architectural documentation.
- `editor-support/`: Professional editor support for VS Code, Sublime Text, and Vim.
- `ai/`: Policies and templates for AI-assisted development within the sovereign constraint.
- `ci/`: Shell scripts for reproducible builds and static analysis (no external CI services).
- `.project/`: Project management, status reports, and governance documents.

**📖 Navigation:** See [INDEX.md](INDEX.md) for quick navigation or [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) for detailed structure.

## Current Status

**🎉 Self-Hosting Complete!** Athōn can now compile itself.

**Bootstrap Compiler:** Fully functional with escape sequence support  
**Self-Hosted Compiler:** 5 phases complete - true self-compilation achieved  
**std/core Library:** Option, Result, Ordering types implemented  
**Examples:** 31 working programs demonstrating all features  
**Documentation:** Complete language guide, API reference, and examples catalog  

See [SELF_COMPILATION_COMPLETE.md](SELF_COMPILATION_COMPLETE.md) for details.  
**Test Coverage:** 100% of examples passing

## Getting Started

### 🚀 One-Command Installation

```bash
git clone https://github.com/yourusername/athon.git
cd athon
./install.sh
```

This installs both the compiler and the unified CLI tool.

### ⚡ Quick Start with CLI

The easiest way to use Athōn:

```bash
# Run a program (compile + execute in one step)
./athon run examples/hello.at

# Create a new project
./athon new my-project
cd my-project
./athon run src/main.at

# Build an optimized executable
./athon build hello.at -O -o my-app

# See all commands
./athon help
```

**Why use the CLI?** It handles all the compilation steps automatically, manages intermediate files, and provides a streamlined developer experience.

### 📚 Learn More

- **[CLI Guide](CLI_GUIDE.md)** - Complete CLI documentation with workflows and tips
- **[Quick Start](QUICKSTART.md)** - 5-minute getting started guide
- **[Installation Guide](INSTALL.md)** - Detailed installation instructions

### 🔧 Manual Compilation (Advanced)

If you prefer direct compiler access:

```bash
# Build the bootstrap compiler
cd compiler/bootstrap
bash build.sh
cd ../..

# Compile manually
./athon-boot examples/hello.at > hello.c
gcc hello.c -o hello
./hello
```

## Documentation

### Learning Resources
- **[Language Guide](docs/language-guide.md)** - Complete tutorial from basics to advanced features
- **[API Reference](docs/api-reference.md)** - Detailed documentation of all built-in functions
- **[Examples Index](docs/examples-index.md)** - Catalog of all 31 examples with learning paths
- **[Syntax Specification](athon-spec/syntax.md)** - Formal syntax rules

### Technical Documentation
- **[Architecture](docs/architecture.md)** - Compiler architecture and design
- **[Capability Security](docs/capability-security.md)** - Security model documentation
- **[Reproducible Builds](docs/reproducible-builds.md)** - Build reproducibility guide
- **[Test Results](TEST_RESULTS.md)** - Complete test coverage report

## Language Features

### Core Language
- ✓ Variables and types (int, bool, string)
- ✓ Functions with parameters and return values
- ✓ Control flow (if/else, while, for)
- ✓ Operators (arithmetic, comparison, logical, unary)
- ✓ Comments (single-line and multi-line)

### Data Structures
- ✓ Arrays (literals, indexing, length)
- ✓ Structs (definition, literals, member access)
- ✓ Enums (definition, variants, comparison)

### Advanced Features
- ✓ Pattern matching (literals, enums, wildcards)
- ✓ Recursive functions
- ✓ Printf-style formatting

### Standard Library
- ✓ **Math:** abs, min, max, pow, sqrt, mod
- ✓ **File I/O:** file_read, file_write, file_append, file_exists
- ✓ **String:** length, concat, compare
- ✓ **Array:** array_length

## Example Programs

Browse the `examples/` directory for working code:

**Beginner (14 examples):**
- hello.at, variables.at, arithmetic.at, control_flow.at, loops.at, etc.

**Intermediate (8 examples):**
- structs.at, enums.at, match_test.at, math.at, file_io_simple.at, etc.

**Advanced (7 examples):**
- geometry.at, file_logger.at, data_processor.at, showcase.at, etc.

See [Examples Index](docs/examples-index.md) for complete catalog with learning paths.

## Project Resources

📚 **[Documentation Index](DOCUMENTATION_INDEX.md)** - Complete guide to all documentation

### For Users
- **[Quick Start Guide](docs/language-guide.md#getting-started)** - Get started in 5 minutes
- **[Language Guide](docs/language-guide.md)** - Complete tutorial
- **[API Reference](docs/api-reference.md)** - Function documentation
- **[Examples](docs/examples-index.md)** - 31 working programs
- **[Editor Support](editor-support/README.md)** - Syntax highlighting for VS Code, Vim, Sublime Text

### For Contributors
- **[Contributing Guide](CONTRIBUTING.md)** - How to contribute
- **[Project Status](PROJECT_STATUS.md)** - Current state and metrics
- **[Changelog](CHANGELOG.md)** - Version history

### Technical Documentation
- **[Architecture](docs/architecture.md)** - Compiler design
- **[Capability Security](docs/capability-security.md)** - Security model
- **[Reproducible Builds](docs/reproducible-builds.md)** - Build system
- **[Bootstrap Compiler](compiler/bootstrap/README.md)** - Implementation details

### Specification
- **[Syntax](athon-spec/syntax.md)** - Language syntax
- **[Semantics](athon-spec/semantics.md)** - Language semantics
- **[Capabilities](athon-spec/capabilities.md)** - Security model
- **[Roadmap](athon-spec/roadmap.md)** - Future plans

## Project Status

**Version:** 0.3.0  
**Phase:** Bootstrap Complete ✅  
**Test Coverage:** 100% (29/29 examples passing)  
**Documentation:** Complete

See [PROJECT_STATUS.md](PROJECT_STATUS.md) for detailed metrics and progress.

## Governance

This project is governed by a "Sovereign Charter" that prioritizes the language's invariants over feature velocity. Changes are managed through a Request for Comments (RFC) process that requires cryptographic signing of all commits. A quorum of maintainers must approve changes to the core specification or security model.

See [GOVERNANCE.md](GOVERNANCE.md) and [SOVEREIGN_CHARTER.md](SOVEREIGN_CHARTER.md) for details.

## Contributing

We welcome contributions! Please read:
1. [CONTRIBUTING.md](CONTRIBUTING.md) - Contribution guidelines
2. [task.md](task.md) - Open tasks
3. [PROJECT_STATUS.md](PROJECT_STATUS.md) - Current status

## Quick Reference

### Install Syntax Highlighting

**VS Code:**
```bash
cp -r editor-support/vscode/athon ~/.vscode/extensions/athon-language-0.3.0
```

**Sublime Text:**
```bash
cp editor-support/sublime-text/Athon.sublime-syntax ~/.config/sublime-text/Packages/User/
```

**Vim:**
```bash
mkdir -p ~/.vim/syntax ~/.vim/ftdetect
cp editor-support/vim/syntax/athon.vim ~/.vim/syntax/
cp editor-support/vim/ftdetect/athon.vim ~/.vim/ftdetect/
```

See [editor-support/INSTALLATION.md](editor-support/INSTALLATION.md) for detailed instructions.

### Compile and Run

```bash
# Compile Athōn to C
./athon-boot examples/hello.at > hello.c

# Compile C to executable
gcc hello.c -o hello

# Run
./hello
```

### One-liner
```bash
./athon-boot examples/hello.at > /tmp/test.c && gcc /tmp/test.c -o /tmp/test && /tmp/test
```

## License

See [LICENSE](LICENSE) for license information.

## Contact

- **Issues:** [Issue Tracker]
- **Discussions:** [Discussion Forum]
- **Email:** me@beamitpal.com (Placeholder)

---

**Version:** 0.3.0 | **Status:** Bootstrap Complete ✅ | **Test Coverage:** 100%
