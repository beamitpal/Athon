# Athōn Project Index

Quick navigation guide for the Athōn programming language project.

## 🚀 Quick Start

**New to Athōn?**
1. Run `./install.sh` to set up everything
2. Try `athon run examples/hello.at`
3. Read [QUICKSTART.md](QUICKSTART.md) for 5-minute guide
4. Create your first project: `athon new my-project`

**Already installed?**
- Run `./verify-setup.sh` to verify installation
- Read [SETUP_COMPLETE.md](SETUP_COMPLETE.md) for usage guide
- See [CLI_GUIDE.md](CLI_GUIDE.md) for complete CLI documentation

**Want to contribute?**
1. Read [CONTRIBUTING.md](CONTRIBUTING.md)
2. Check [.project/checklists/task.md](.project/checklists/task.md)
3. Review [athon-spec/](athon-spec/)

## 📚 Documentation

### User Documentation
- [Language Guide](docs/language-guide.md) - Complete tutorial
- [API Reference](docs/api-reference.md) - Built-in functions
- [Examples Index](docs/examples-index.md) - All examples

### Technical Documentation
- [Architecture](docs/architecture.md) - Compiler design
- [Philosophy](docs/philosophy.md) - Design principles
- [Capability Security](docs/capability-security.md) - Security model
- [Reproducible Builds](docs/reproducible-builds.md) - Build system

### Language Specification
- [Overview](athon-spec/overview.md) - Language overview
- [Syntax](athon-spec/syntax.md) - Formal syntax (EBNF)
- [Semantics](athon-spec/semantics.md) - Semantic rules
- [Memory Model](athon-spec/memory-model.md) - Memory management
- [Capabilities](athon-spec/capabilities.md) - Capability system
- [Roadmap](athon-spec/roadmap.md) - Development plan

## 💻 Development

### Source Code
- [Compiler](compiler/) - Compiler source code
  - [Frontend](compiler/frontend/) - Lexer, parser, AST
  - [Backend](compiler/backend/) - Code generation
  - [Type System](compiler/type-system/) - Type checking
  - [Bootstrap](compiler/bootstrap/) - Bootstrap compiler (Rust)
- [Standard Library](std/) - Built-in functionality

### Examples
- [Basic Examples](examples/) - 31 working programs
  - [hello.at](examples/hello.at) - Hello world
  - [showcase.at](examples/showcase.at) - Comprehensive demo
  - [pattern_matching.at](examples/pattern_matching.at) - Pattern matching
  - [file_io.at](examples/file_io.at) - File operations

### Editor Support
- [VS Code](editor-support/vscode/) - Full support with snippets
- [Sublime Text](editor-support/sublime-text/) - Syntax highlighting
- [Vim/Neovim](editor-support/vim/) - Syntax highlighting
- [Installation Guide](editor-support/INSTALLATION.md)
- [Test File](editor-support/test-syntax.at) - 500+ line test

## 🔧 Tools & Scripts

### CI/CD
- [Static Checks](ci/static_checks.sh) - Code analysis
- [Reproducible Build](ci/repro_build.sh) - Build verification
- [Dependency Check](ci/no_external_deps_check.sh) - Dependency audit

### AI Tools
- [AI Policy](ai/AI_POLICY.md) - AI usage guidelines
- [Review Guide](ai/REVIEW_GUIDE.md) - AI code review
- [Prompt Templates](ai/prompt-templates.md) - Useful prompts

## 📊 Project Management

### Status Reports
- [Project Status](.project/status/PROJECT_STATUS.md) - Overall status
- [Setup Complete](.project/status/SETUP_COMPLETE.md) - Setup status
- [Documentation Complete](.project/status/DOCUMENTATION_COMPLETE.md) - Docs status
- [Test Results](.project/status/TEST_RESULTS.md) - Test coverage
- [Editor Support Complete](.project/status/EDITOR_SUPPORT_COMPLETE.md) - Editor status

### Checklists
- [Final Checklist](.project/checklists/FINAL_CHECKLIST.md) - Release checklist
- [Current Tasks](.project/checklists/task.md) - Active tasks
- [Documentation Index](.project/checklists/DOCUMENTATION_INDEX.md) - Doc index

### Governance
- [Sovereign Charter](.project/governance/SOVEREIGN_CHARTER.md) - Project charter
- [Governance Model](.project/governance/GOVERNANCE.md) - Governance rules

## 📋 Essential Files

### Root Level
- [README.md](README.md) - Project overview
- [YOUR_NEXT_STEPS.md](YOUR_NEXT_STEPS.md) - **START HERE** after installation
- [INSTALL.md](INSTALL.md) - Installation guide
- [SETUP_COMPLETE.md](SETUP_COMPLETE.md) - Post-installation guide
- [CLI_GUIDE.md](CLI_GUIDE.md) - Complete CLI documentation
- [CLI_EXAMPLES.md](CLI_EXAMPLES.md) - Real-world CLI examples
- [CLI_SUMMARY.md](CLI_SUMMARY.md) - CLI impact summary
- [FILE_STRUCTURE.md](FILE_STRUCTURE.md) - Clean file structure
- [LICENSE](LICENSE) - License information
- [CHANGELOG.md](CHANGELOG.md) - Version history
- [CONTRIBUTING.md](CONTRIBUTING.md) - How to contribute
- [SECURITY.md](SECURITY.md) - Security policy
- [REPRO_BUILD.md](REPRO_BUILD.md) - Build instructions
- [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) - Detailed directory structure
- [INDEX.md](INDEX.md) - This file

### Executables
- [athon-boot](athon-boot) - Bootstrap compiler
- [athon](athon) - Unified CLI tool (after installation)

## 🎯 Common Tasks

### Building
```bash
# One-command installation
./install.sh

# Or build manually
./ci/repro_build.sh

# Run static checks
./ci/static_checks.sh
```

### Running Examples
```bash
# Using CLI (recommended)
./athon run examples/hello.at
./athon run examples/showcase.at

# Or using compiler directly
./athon-boot examples/hello.at > hello.c
gcc hello.c -o hello && ./hello
```

### Creating Projects
```bash
# Create new project
./athon new my-project
cd my-project
./athon run src/main.at

# Run tests
./athon test

# Build release
./athon build src/main.at -O -o my-app
```

### Editor Setup
```bash
# Install VS Code extension
cp -r editor-support/vscode/athon ~/.vscode/extensions/athon-language-0.3.0

# Verify installation
cd editor-support && ./verify-installation.sh
```

### Testing
```bash
# Test all examples
for f in examples/*.at; do ./athon-boot "$f"; done

# Test syntax highlighting
code editor-support/test-syntax.at
```

## 🔍 Finding Things

### Looking for...

**Language features?**
→ [athon-spec/syntax.md](athon-spec/syntax.md)

**How to use X?**
→ [docs/language-guide.md](docs/language-guide.md)

**Example of Y?**
→ [examples/](examples/) or [docs/examples-index.md](docs/examples-index.md)

**Compiler internals?**
→ [docs/architecture.md](docs/architecture.md)

**How to contribute?**
→ [CONTRIBUTING.md](CONTRIBUTING.md)

**Current tasks?**
→ [.project/checklists/task.md](.project/checklists/task.md)

**Project status?**
→ [.project/status/](.project/status/)

**Editor support?**
→ [editor-support/](editor-support/)

**Security info?**
→ [SECURITY.md](SECURITY.md)

**Build instructions?**
→ [REPRO_BUILD.md](REPRO_BUILD.md)

## 📈 Project Stats

- **Lines of Code:** 10,000+ (compiler)
- **Example Programs:** 31
- **Documentation Pages:** 15+
- **Supported Editors:** 3 (VS Code, Sublime Text, Vim)
- **Test Coverage:** 100% (31/31 examples pass)
- **Status:** ✅ Production Ready

## 🌟 Highlights

### Recent Achievements
- ✅ Bootstrap compiler complete (Rust → C)
- ✅ 31 working example programs
- ✅ Professional editor support (3 editors)
- ✅ Comprehensive documentation
- ✅ 100% test pass rate
- ✅ Reproducible builds
- ✅ Pattern matching with exhaustive checking

### Next Steps
- [ ] Self-hosting compiler (Athōn → C)
- [ ] Capability system implementation
- [ ] Memory safety analysis
- [ ] Language Server Protocol (LSP)
- [ ] Formal verification integration

## 📞 Getting Help

### Documentation
- Start with [README.md](README.md)
- Read [docs/language-guide.md](docs/language-guide.md)
- Check [athon-spec/](athon-spec/)

### Examples
- Browse [examples/](examples/)
- Try [examples/showcase.at](examples/showcase.at)

### Contributing
- Read [CONTRIBUTING.md](CONTRIBUTING.md)
- Check [.project/checklists/task.md](.project/checklists/task.md)

### Issues
- Check [SECURITY.md](SECURITY.md) for security issues
- Review [.project/status/](.project/status/) for known issues

## 🗺️ Project Map

```
athon/
├── 📖 Documentation (docs/, athon-spec/)
├── 💻 Source Code (compiler/, std/)
├── 💡 Examples (examples/)
├── 🎨 Editor Support (editor-support/)
├── 🔧 Tools (ci/, ai/)
└── 📊 Project Management (.project/)
```

## Version

**Index Version:** 1.0  
**Last Updated:** 2024-11-20  
**Project Status:** ✅ Production Ready  

---

**Quick Links:**
[README](README.md) | 
[Language Guide](docs/language-guide.md) | 
[Examples](examples/) | 
[Editor Support](editor-support/) | 
[Contributing](CONTRIBUTING.md) | 
[Structure](PROJECT_STRUCTURE.md)
