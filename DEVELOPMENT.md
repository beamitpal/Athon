# Athōn Development Guide

Complete guide for developing Athōn and contributing to the 2026 roadmap.

---

## Table of Contents

1. [Architecture](#architecture)
2. [2026 Battle Plan](#2026-battle-plan)
3. [Development Workflow](#development-workflow)
4. [Building & Testing](#building--testing)
5. [Editor Setup](#editor-setup)
6. [Contributing](#contributing)

---

## Architecture

### Compiler Pipeline

```
Source Code (.at)
    ↓
Lexer → Tokens
    ↓
Parser → AST
    ↓
Type Checker → Typed AST
    ↓
IR Generator → Intermediate Representation
    ↓
Backend → Target Code
    ↓
Output (C / RISC-V / WASM)
```

### Current Backends

- **C Backend** (✅ Complete) - Generates C code
- **RISC-V Backend** (🚧 2026) - Native machine code
- **WASM Backend** (🚧 2026) - WebAssembly

### Directory Structure

```
compiler/
├── bootstrap/          # Bootstrap compiler (Rust)
│   ├── src/
│   │   ├── lexer.rs
│   │   ├── parser.rs
│   │   ├── typechecker.rs
│   │   ├── ir.rs
│   │   └── codegen.rs
│   └── Cargo.toml
└── backend/
    ├── riscv64/        # RISC-V backend (2026)
    └── wasm64/         # WASM backend (2026)
```

---

## 2026 Battle Plan

### Mission

**Build the operating system of the next internet.**

Not just a programming language, but:
- A bare-metal operating system (Nova)
- A high-performance rendering engine (Aurora)
- A capability-secure platform

### What We Have (2025)

✅ Self-hosting compiler (5 phases)  
✅ Capability-based type system  
✅ Zero external dependencies  
✅ Reproducible builds  
✅ Generics, traits, union types

### What We're Building (2026)

🚧 RISC-V native backend  
🚧 WebAssembly backend  
🚧 Region allocator (zero-GC)  
🚧 Vulkan/Metal bindings  
🚧 Reactive signals  
🚧 Nova microkernel  
🚧 Aurora Engine

---

## Quarterly Roadmap

### Q1 2026: Foundation (Dec 2025 - Mar 2026)

#### December 2025 - February 2026: Memory Management

**Goal**: Zero-GC arena allocator with capability tracking

**Tasks**:
- [ ] Implement `std/mem/region.at`
  - [ ] Bump allocation
  - [ ] Region reset
  - [ ] Capability tracking
  - [ ] Performance benchmarks

- [ ] Implement `std/mem/cap_ref.at`
  - [ ] Linear type enforcement
  - [ ] Borrow checking
  - [ ] Consumption tracking
  - [ ] Revocation support

**Milestone**: Memory-safe allocation without GC

#### January - March 2026: RISC-V Backend

**Goal**: Native code generation for bare-metal

**Tasks**:
- [ ] Create `compiler/backend/riscv64/`
  - [ ] Instruction encoding
  - [ ] Register allocation
  - [ ] Function calls (ABI)
  - [ ] Memory operations
  - [ ] Control flow

**Milestone**: Hello World on QEMU RISC-V

#### February - April 2026: Freestanding Environment

**Goal**: Run without operating system

**Tasks**:
- [ ] Implement `std/os/no_std.at`
  - [ ] Entry point (_start)
  - [ ] Panic handler
  - [ ] Stack initialization
  - [ ] Capability bootstrap

- [ ] Create `std/os/linker.ld`
  - [ ] Memory layout
  - [ ] Section placement
  - [ ] Stack/heap setup

**Milestone**: Bootable bare-metal binary

---

### Q2 2026: Graphics & Reactivity (Apr - Jun 2026)

#### March - May 2026: GPU Programming

**Goal**: Compile-time Vulkan bindings

**Tasks**:
- [ ] Implement `std/gpu/vulkan.at`
  - [ ] Instance creation
  - [ ] Device selection
  - [ ] Command buffers
  - [ ] Pipeline creation
  - [ ] Shader compilation

- [ ] Implement `std/gpu/metal.at`
  - [ ] Device creation
  - [ ] Command encoding
  - [ ] Shader compilation

**Milestone**: Triangle on screen via Vulkan

#### April - June 2026: Reactive System

**Goal**: Fine-grained reactivity for UI

**Tasks**:
- [ ] Implement `std/reactive/signal.at`
  - [ ] Signal creation
  - [ ] Dependency tracking
  - [ ] Computed signals
  - [ ] Batch updates

- [ ] Implement `std/ui/node.at`
  - [ ] Node hierarchy
  - [ ] Transform propagation
  - [ ] Reactive properties
  - [ ] Render traversal

**Milestone**: Animated UI at 120 FPS

---

### Q3 2026: Operating System (Jul - Sep 2026)

#### May - June 2026: Process Management

**Goal**: Capability-secured processes

**Tasks**:
- [ ] Implement `std/os/process.at`
  - [ ] Address space isolation
  - [ ] Capability granting
  - [ ] IPC implementation
  - [ ] Revocation support

**Milestone**: Spawn isolated process with capabilities

#### June - August 2026: Nova Microkernel

**Goal**: Bootable microkernel

**Tasks**:
- [ ] Implement `kernel/`
  - [ ] Boot sequence
  - [ ] Memory management
  - [ ] Process scheduler
  - [ ] Device drivers
  - [ ] IPC subsystem

**Milestone**: Boot Nova on QEMU and real hardware

#### July - September 2026: Aurora Engine Alpha

**Goal**: Production-ready rendering engine

**Tasks**:
- [ ] Aurora Engine implementation
  - [ ] Scene graph rendering
  - [ ] Reactive updates
  - [ ] GPU acceleration
  - [ ] Input handling
  - [ ] Performance optimization

**Milestone**: 120 FPS reactive UI demo

---

### Q4 2026: Web Platform (Oct - Dec 2026)

#### October - December 2026: WebAssembly Backend

**Goal**: Run Athōn in browsers

**Tasks**:
- [ ] Implement `compiler/backend/wasm64/`
  - [ ] Module generation
  - [ ] Type mapping
  - [ ] Function exports
  - [ ] Memory management
  - [ ] Browser API bindings

**Milestone**: Aurora Engine running in browser

#### Networking (Q3-Q4 2026)

**Goal**: Capability-secured networking

**Tasks**:
- [ ] Implement `std/net/cap_stream.at`
  - [ ] TCP/UDP sockets
  - [ ] Post-quantum crypto
  - [ ] Capability multiplexing
  - [ ] E2EE by default

**Milestone**: Secure network communication

---

## Development Workflow

### Setup

```bash
# Clone repository
git clone https://github.com/beamitpal/athon.git
cd athon

# Install compiler
./athon-cli.sh install

# Or use interactive menu
./athon-cli.sh
```

### Building

```bash
# Quick rebuild (incremental)
./athon-cli.sh update

# Full rebuild (clean)
./athon-cli.sh full-update

# Check installation
./athon-cli.sh check
```

### Testing

```bash
# Test self-compilation
./athon-cli.sh test

# Test all examples
./athon-cli.sh test-examples

# Test specific example
./athon examples/hello.at
```

### Making Changes

1. **Edit source files** in `compiler/bootstrap/src/`
2. **Rebuild**: `./athon-cli.sh update`
3. **Test**: `./athon-cli.sh test`
4. **Commit**: Follow conventional commits

### Adding Features

1. **Create stub file** in appropriate `std/` directory
2. **Add tests** in `examples/`
3. **Update documentation**
4. **Submit PR**

---

## Building & Testing

### Compiler Development

```bash
# Edit compiler source
vim compiler/bootstrap/src/parser.rs

# Rebuild
./athon-cli.sh update

# Test
./athon-cli.sh test
```

### Standard Library Development

```bash
# Create new module
vim std/mem/region.at

# Test with example
./athon examples/memory_test.at
```

### Backend Development

```bash
# Work on RISC-V backend
vim compiler/backend/riscv64/codegen.rs

# Test on QEMU
./athon examples/hello.at --target riscv64
qemu-system-riscv64 -kernel hello.elf
```

---

## Editor Setup

### VS Code (Recommended)

```bash
# Build extension
./athon-cli.sh build-ext

# Install extension
./athon-cli.sh install-ext

# Setup icons (optional)
./athon-cli.sh
# Select option 12
```

**Features**:
- Syntax highlighting
- Code snippets (20+)
- Auto-completion
- Format on save
- File icons

### Configuration

Workspace settings in `.vscode/settings.json`:

```json
{
  "athon.formatOnSave": true,
  "athon.indentSize": 4,
  "[athon]": {
    "editor.formatOnSave": true,
    "editor.tabSize": 4
  }
}
```

---

## Contributing

### Code Style

- **Indentation**: 4 spaces
- **Line length**: 100 characters
- **Naming**: snake_case for functions, PascalCase for types
- **Comments**: Document public APIs

### Commit Messages

Follow conventional commits:

```
feat: Add region allocator
fix: Fix type inference bug
docs: Update roadmap
test: Add memory tests
```

### Pull Requests

1. Fork repository
2. Create feature branch
3. Make changes
4. Add tests
5. Update documentation
6. Submit PR

### Review Process

- Code review by maintainers
- CI checks must pass
- Documentation must be updated
- Tests must be added

---

## Resources

### Specifications

- **RISC-V ISA**: https://riscv.org/specifications/
- **Vulkan**: https://www.vulkan.org/
- **WebAssembly**: https://webassembly.org/

### Learning

- **Rust Book**: https://doc.rust-lang.org/book/
- **Compiler Design**: Dragon Book
- **OS Development**: OSDev Wiki

### Community

- **GitHub**: https://github.com/beamitpal/athon
- **Issues**: Bug reports and features
- **Discussions**: Questions and ideas

---

## Milestones

### 2025 (Complete)
- ✅ Self-hosting compiler
- ✅ 31+ working examples
- ✅ VS Code extension
- ✅ Documentation

### 2026 Goals
- [ ] RISC-V backend
- [ ] WebAssembly backend
- [ ] Region allocator
- [ ] Vulkan bindings
- [ ] Nova microkernel
- [ ] Aurora Engine

### 2027+ Vision
- Package manager (athon-pkg)
- Async/await runtime
- Formal verification
- Complete browser
- .nova internet protocol

---

## Philosophy

### Core Principles

1. **Sovereignty** - Zero external dependencies
2. **Security** - Capability-based by default
3. **Reproducibility** - Bit-identical builds
4. **Permanence** - Built to last decades

### Design Goals

- **Simplicity** - Easy to understand
- **Performance** - Zero-cost abstractions
- **Safety** - Prevent bugs at compile time
- **Expressiveness** - Powerful type system

---

## FAQ

**Q: Why Athōn?**  
A: To build the operating system of the next internet with capability security baked in.

**Q: Why no external dependencies?**  
A: For sovereignty, security, and reproducibility.

**Q: When will X feature be ready?**  
A: See the quarterly roadmap above.

**Q: How can I help?**  
A: See CONTRIBUTING.md and pick a task from the roadmap.

---

**The throne is forged in Athōn.**

---

*Last Updated: November 21, 2025*
