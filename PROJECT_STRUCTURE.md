# Athōn Project Structure

Complete directory structure and organization guide for the Athōn programming language project.

## Root Directory

```
athon/
├── README.md                    # Project overview and quick start
├── LICENSE                      # Project license
├── CHANGELOG.md                 # Version history and changes
├── CONTRIBUTING.md              # Contribution guidelines
├── SECURITY.md                  # Security policy
├── REPRO_BUILD.md              # Reproducible build instructions
├── PROJECT_STRUCTURE.md         # This file
├── athon-boot                   # Bootstrap compiler executable
│
├── .project/                    # 📁 Project Management
│   ├── status/                  # Status reports
│   ├── checklists/              # Task lists and checklists
│   └── governance/              # Governance documents
│
├── compiler/                    # 🔧 Compiler Source Code
│   ├── frontend/                # Lexer, parser, AST
│   ├── backend/                 # Code generation
│   ├── ir/                      # Intermediate representation
│   ├── type-system/             # Type checking and inference
│   └── bootstrap/               # Bootstrap compiler (Rust)
│
├── std/                         # 📚 Standard Library
│   ├── core/                    # Core functionality
│   ├── io/                      # Input/output
│   ├── math/                    # Mathematical functions
│   └── collections/             # Data structures
│
├── docs/                        # 📖 Documentation
│   ├── language-guide.md        # Language tutorial
│   ├── api-reference.md         # API documentation
│   ├── architecture.md          # Compiler architecture
│   ├── philosophy.md            # Design philosophy
│   ├── capability-security.md   # Security model
│   ├── reproducible-builds.md   # Build reproducibility
│   ├── bootstrap-purge.md       # Bootstrap removal plan
│   └── examples-index.md        # Examples catalog
│
├── athon-spec/                  # 📋 Language Specification
│   ├── overview.md              # Language overview
│   ├── syntax.md                # Syntax specification
│   ├── semantics.md             # Semantic rules
│   ├── memory-model.md          # Memory management
│   ├── capabilities.md          # Capability system
│   └── roadmap.md               # Development roadmap
│
├── examples/                    # 💡 Example Programs
│   ├── hello.at                 # Hello world
│   ├── arithmetic.at            # Basic arithmetic
│   ├── functions.at             # Function examples
│   ├── structs.at               # Struct examples
│   ├── enums.at                 # Enum examples
│   ├── pattern_matching.at      # Pattern matching
│   ├── file_io.at               # File I/O
│   ├── showcase.at              # Comprehensive demo
│   └── ...                      # More examples
│
├── editor-support/              # 🎨 Editor Integration
│   ├── vscode/                  # VS Code extension
│   │   └── athon/
│   │       ├── package.json
│   │       ├── syntaxes/
│   │       ├── snippets/
│   │       └── language-configuration.json
│   ├── sublime-text/            # Sublime Text syntax
│   ├── vim/                     # Vim/Neovim support
│   │   ├── syntax/
│   │   └── ftdetect/
│   ├── test-syntax.at           # Syntax test file
│   ├── verify-installation.sh   # Verification script
│   ├── README.md                # Editor support guide
│   ├── INSTALLATION.md          # Installation instructions
│   ├── IMPROVEMENTS.md          # Recent improvements
│   └── STATUS.md                # Current status
│
├── ci/                          # 🔄 CI/CD Scripts
│   ├── static_checks.sh         # Static analysis
│   ├── repro_build.sh           # Reproducible build
│   └── no_external_deps_check.sh # Dependency check
│
└── ai/                          # 🤖 AI Development Tools
    ├── AI_POLICY.md             # AI usage policy
    ├── REVIEW_GUIDE.md          # AI code review guide
    └── prompt-templates.md      # Prompt templates
```

## Directory Purposes

### 📁 `.project/` - Project Management
Internal project management files, status reports, and governance documents.

**Subdirectories:**
- `status/` - Project status reports and completion markers
- `checklists/` - Task lists and project checklists
- `governance/` - Project governance and charter documents

**Key Files:**
- Status reports for different components
- Final release checklist
- Current task list
- Governance model

### 🔧 `compiler/` - Compiler Source Code
The Athōn compiler implementation.

**Subdirectories:**
- `frontend/` - Lexical analysis, parsing, AST construction
- `backend/` - Code generation (C output)
- `ir/` - Intermediate representation
- `type-system/` - Type checking and inference
- `bootstrap/` - Bootstrap compiler written in Rust

**Purpose:** Contains all compiler source code. The bootstrap compiler (Rust) will eventually be replaced by a self-hosted compiler (Athōn).

### 📚 `std/` - Standard Library
Athōn standard library implementation.

**Subdirectories:**
- `core/` - Core language functionality
- `io/` - Input/output operations
- `math/` - Mathematical functions
- `collections/` - Data structures (arrays, etc.)

**Purpose:** Provides built-in functionality for Athōn programs.

### 📖 `docs/` - Documentation
User-facing documentation and guides.

**Key Files:**
- `language-guide.md` - Complete language tutorial
- `api-reference.md` - API documentation
- `architecture.md` - Compiler architecture
- `philosophy.md` - Design philosophy
- `capability-security.md` - Security model explanation
- `reproducible-builds.md` - Build reproducibility guide

**Purpose:** Comprehensive documentation for users and contributors.

### 📋 `athon-spec/` - Language Specification
Formal language specification documents.

**Key Files:**
- `overview.md` - Language overview
- `syntax.md` - Formal syntax specification (EBNF)
- `semantics.md` - Semantic rules
- `memory-model.md` - Memory management model
- `capabilities.md` - Capability system specification
- `roadmap.md` - Development roadmap

**Purpose:** Formal specification for language implementers.

### 💡 `examples/` - Example Programs
Working example programs demonstrating language features.

**Categories:**
- Basic examples (hello, arithmetic, variables)
- Functions and control flow
- Data structures (structs, enums, arrays)
- Pattern matching
- File I/O
- Comprehensive showcases

**Purpose:** Learning resources and test cases.

### 🎨 `editor-support/` - Editor Integration
Syntax highlighting and editor support for multiple editors.

**Subdirectories:**
- `vscode/` - VS Code extension (full support)
- `sublime-text/` - Sublime Text syntax
- `vim/` - Vim/Neovim support

**Key Files:**
- `test-syntax.at` - Comprehensive syntax test file (500+ lines)
- `verify-installation.sh` - Automated verification
- `README.md` - Editor support overview
- `INSTALLATION.md` - Installation guide
- `STATUS.md` - Current status

**Purpose:** Professional editor support for development.

### 🔄 `ci/` - CI/CD Scripts
Continuous integration and build scripts.

**Scripts:**
- `static_checks.sh` - Run static analysis
- `repro_build.sh` - Reproducible build verification
- `no_external_deps_check.sh` - Dependency verification

**Purpose:** Automated testing and verification.

### 🤖 `ai/` - AI Development Tools
AI-assisted development policies and tools.

**Files:**
- `AI_POLICY.md` - AI usage policy
- `REVIEW_GUIDE.md` - AI code review guidelines
- `prompt-templates.md` - Prompt templates

**Purpose:** Guidelines for AI-assisted development.

## File Organization Principles

### Root Level Files
Keep only essential files at root:
- `README.md` - Project overview
- `LICENSE` - License information
- `CHANGELOG.md` - Version history
- `CONTRIBUTING.md` - Contribution guide
- `SECURITY.md` - Security policy
- `REPRO_BUILD.md` - Build instructions
- `PROJECT_STRUCTURE.md` - This file
- `athon-boot` - Compiler executable

### Organized Subdirectories
All other files belong in organized subdirectories:
- Project management → `.project/`
- Source code → `compiler/`, `std/`
- Documentation → `docs/`, `athon-spec/`
- Examples → `examples/`
- Editor support → `editor-support/`
- CI/CD → `ci/`
- AI tools → `ai/`

## Navigation Guide

### For Users
1. Start with `README.md`
2. Read `docs/language-guide.md`
3. Try examples in `examples/`
4. Install editor support from `editor-support/`

### For Contributors
1. Read `CONTRIBUTING.md`
2. Review `athon-spec/` for language specification
3. Study `docs/architecture.md` for compiler design
4. Check `.project/checklists/` for current tasks

### For Language Implementers
1. Study `athon-spec/` thoroughly
2. Review `compiler/` structure
3. Read `docs/architecture.md`
4. Check `examples/` for test cases

### For Project Maintainers
1. Check `.project/status/` for component status
2. Review `.project/checklists/` for pending tasks
3. Update `.project/governance/` as needed
4. Maintain `CHANGELOG.md`

## Maintenance Guidelines

### Adding New Files
- **Source code** → `compiler/` or `std/`
- **Documentation** → `docs/` or `athon-spec/`
- **Examples** → `examples/`
- **Editor support** → `editor-support/`
- **Project management** → `.project/`
- **CI/CD scripts** → `ci/`

### Updating Documentation
- User docs → `docs/`
- Specification → `athon-spec/`
- Editor support → `editor-support/`
- Project status → `.project/status/`

### Managing Tasks
- Current tasks → `.project/checklists/task.md`
- Release checklist → `.project/checklists/FINAL_CHECKLIST.md`
- Status updates → `.project/status/`

## Quick Reference

### Build and Test
```bash
# Build compiler
./ci/repro_build.sh

# Run static checks
./ci/static_checks.sh

# Test examples
./athon-boot examples/hello.at
```

### Editor Setup
```bash
# VS Code
cp -r editor-support/vscode/athon ~/.vscode/extensions/athon-language-0.3.0

# Verify installation
cd editor-support && ./verify-installation.sh
```

### Documentation
```bash
# View language guide
cat docs/language-guide.md

# View specification
cat athon-spec/syntax.md
```

## Project Statistics

**Total Directories:** 20+  
**Total Files:** 100+  
**Example Programs:** 31  
**Documentation Files:** 15+  
**Editor Support:** 3 editors (VS Code, Sublime Text, Vim)  

## Version

**Structure Version:** 1.0  
**Last Updated:** 2024-11-20  
**Status:** ✅ Organized and Production-Ready  

---

*This structure is designed for long-term maintainability and clarity.*
