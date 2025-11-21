# Athōn Language

**Building the Operating System of the Next Internet**

Athōn is a sovereign, capability-secure systems programming language designed for bare-metal execution, GPU programming, and building the next generation of secure computing platforms.

## Vision

We're not building another programming language.  
We're building:
- A real operating system (Nova microkernel)
- A high-performance rendering engine (Aurora)
- The foundation for a capability-secure internet

**The throne is forged in Athōn.**

---

## Core Features

### ✅ Complete (2025)
- **Self-hosting compiler** - 5 phases, compiles itself
- **Capability-based security** - Enforced at type level
- **Zero external dependencies** - Truly air-gapped
- **Reproducible builds** - Bit-identical compilation
- **Modern type system** - Generics, traits, union types, inference

### 🚧 In Progress (2026)
- **RISC-V backend** - Native bare-metal code generation
- **WebAssembly backend** - Run in any browser
- **Region allocator** - Zero-GC memory management
- **Vulkan/Metal bindings** - GPU programming
- **Reactive signals** - Fine-grained UI reactivity
- **Nova microkernel** - Bootable on real hardware
- **Aurora Engine** - 120 FPS rendering

---

## Quick Start

### Installation

```bash
git clone https://github.com/beamitpal/athon.git
cd athon
./install.sh
```

### Unified CLI

```bash
# Interactive menu
./athon-cli.sh

# Or use commands directly
./athon-cli.sh install      # Install compiler
./athon-cli.sh test         # Test self-compilation
./athon-cli.sh build-ext    # Build VS Code extension
```

### Hello World

```athon
fn main() {
    print("Hello, Athōn!");
}
```

```bash
./athon examples/hello.at
```

---

## 2026 Roadmap

### Q1 (Dec 2025 - Mar 2026): Foundation
- **Memory Management**: Region allocator + capability references
- **RISC-V Backend**: Native code generation
- **Freestanding**: no_std + custom linker

**Milestone**: Hello World boots on QEMU RISC-V

### Q2 (Apr - Jun 2026): Graphics & Reactivity
- **GPU Programming**: Vulkan/Metal bindings
- **Reactive System**: Fine-grained signals
- **Scene Graph**: UI primitives

**Milestone**: 120 FPS animated UI

### Q3 (Jul - Sep 2026): Operating System
- **Process Management**: Capability-secured spawning
- **Nova Microkernel**: Bootable on real hardware
- **Aurora Engine**: Production-ready rendering

**Milestone**: Boot Nova on RISC-V board

### Q4 (Oct - Dec 2026): Web Platform
- **WebAssembly Backend**: Run in browsers
- **Nova Protocol**: Post-quantum networking
- **Browser Integration**: Aurora in any browser

**Milestone**: Aurora Engine running in browser

---

## Project Structure

```
athon/
├── compiler/
│   ├── bootstrap/          # Bootstrap compiler (Rust)
│   └── backend/
│       ├── riscv64/        # Native RISC-V (2026)
│       └── wasm64/         # WebAssembly (2026)
├── std/
│   ├── core/               # Core types (Option, Result)
│   ├── mem/                # Memory management (2026)
│   ├── os/                 # OS layer (2026)
│   ├── gpu/                # GPU programming (2026)
│   ├── reactive/           # Reactivity (2026)
│   ├── ui/                 # Scene graph (2026)
│   └── net/                # Networking (2026)
├── kernel/                 # Nova microkernel (2026)
├── examples/               # 31+ working examples
├── docs/                   # Documentation
├── editor-support/         # VS Code, Sublime, Vim
└── athon-cli.sh           # Unified CLI tool
```

---

## Documentation

- **README.md** (this file) - Overview and roadmap
- **CONTRIBUTING.md** - How to contribute
- **DEVELOPMENT.md** - Development guide and architecture

Additional docs in `docs/`:
- Language guide
- API reference
- Architecture details
- Editor setup

---

## Features

### Language
- **Modern syntax** - Clean, expressive
- **Type inference** - Smart type deduction
- **Generics** - Parametric polymorphism
- **Traits** - Interface-based polymorphism
- **Union types** - Type-safe enums
- **Pattern matching** - Exhaustive matching
- **Capability security** - Resource access control

### Compiler
- **Self-hosting** - Compiles itself
- **5-phase architecture** - Lexer, Parser, Type Checker, IR, Codegen
- **Multiple backends** - C (now), RISC-V (2026), WASM (2026)
- **Reproducible** - Bit-identical builds
- **Zero dependencies** - Completely self-contained

### Standard Library
- **Core types** - Option, Result, Ordering
- **Memory** - Region allocator (2026)
- **OS** - Process management (2026)
- **GPU** - Vulkan/Metal (2026)
- **UI** - Reactive signals (2026)
- **Network** - Nova Protocol (2026)

### Tooling
- **VS Code extension** - Full IDE support
- **Syntax highlighting** - All editors
- **Code formatter** - Consistent style
- **Package manager** - athon-pkg (2026)

---

## Examples

31+ working examples demonstrating all features:

```bash
# Basic
./athon examples/hello.at
./athon examples/variables.at
./athon examples/functions.at

# Advanced
./athon examples/generics.at
./athon examples/traits.at
./athon examples/union_types.at

# 2026 Examples
./athon examples/kernel_spawn.at    # Process isolation
./athon examples/render_scene.at    # 120 FPS UI
```

---

## Editor Support

### VS Code (Recommended)

```bash
# Build and install extension
./athon-cli.sh build-ext
./athon-cli.sh install-ext

# Or use interactive menu
./athon-cli.sh
# Select option 9 or 10
```

Features:
- ✅ Syntax highlighting
- ✅ Code snippets (20+ templates)
- ✅ Auto-completion
- ✅ Format on save
- ✅ File icons (Material Icon Theme)

### Other Editors

```bash
cd editor-support
./install-editor-support.sh
```

Supports: Sublime Text, Vim, Neovim

---

## Testing

```bash
# Test self-compilation
./athon-cli.sh test

# Test all examples
./athon-cli.sh test-examples

# Verify installation
./athon-cli.sh verify
```

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for:
- Code of conduct
- Development workflow
- Coding standards
- How to submit PRs

---

## Development Priorities

### December 2025
- [ ] Region allocator (`std/mem/region.at`)
- [ ] Capability references (`std/mem/cap_ref.at`)

### January 2026
- [ ] RISC-V instruction encoding
- [ ] Register allocation
- [ ] Function calls (ABI)

### February 2026
- [ ] Freestanding environment (`std/os/no_std.at`)
- [ ] Custom linker script
- [ ] Boot on QEMU

See [DEVELOPMENT.md](DEVELOPMENT.md) for detailed roadmap.

---

## Community

- **GitHub**: https://github.com/beamitpal/athon
- **Issues**: Report bugs and feature requests
- **Discussions**: Ask questions and share ideas

---

## License

See [LICENSE](LICENSE) file.

---

## Status

**Current Version**: 0.4.0  
**Self-Hosting**: ✅ Complete  
**Examples**: 31+ working  
**Editor Support**: ✅ VS Code, Sublime, Vim  
**2026 Roadmap**: 🚧 In Progress

---

**You are not building another programming language.**  
**You are building the operating system of the next internet.**

**The throne is forged in Athōn.** 🚀

---

*Last Updated: November 21, 2025*
