# Athōn 2026 Roadmap

Detailed quarterly roadmap for 2026.

## Q1 2026: Foundation (Dec 2025 - Mar 2026)

### December 2025 - February 2026: Memory Management
**Goal**: Zero-GC arena allocator with capability tracking

- [ ] `std/mem/region.at` - Region allocator implementation
  - [ ] Bump allocation
  - [ ] Region reset
  - [ ] Capability tracking
  - [ ] Performance benchmarks

- [ ] `std/mem/cap_ref.at` - Linear capability references
  - [ ] Linear type enforcement
  - [ ] Borrow checking
  - [ ] Consumption tracking
  - [ ] Revocation support

**Milestone**: Memory-safe allocation without GC

### January - March 2026: RISC-V Backend
**Goal**: Native code generation for bare-metal

- [ ] `compiler/backend/riscv64/` - RISC-V codegen
  - [ ] Instruction encoding
  - [ ] Register allocation
  - [ ] Function calls (ABI)
  - [ ] Memory operations
  - [ ] Control flow

**Milestone**: Hello World on QEMU RISC-V

### February - April 2026: Freestanding Environment
**Goal**: Run without operating system

- [ ] `std/os/no_std.at` - Freestanding core
  - [ ] Entry point (_start)
  - [ ] Panic handler
  - [ ] Stack initialization
  - [ ] Capability bootstrap

- [ ] `std/os/linker.ld` - Custom linker script
  - [ ] Memory layout
  - [ ] Section placement
  - [ ] Stack/heap setup

**Milestone**: Bootable bare-metal binary

---

## Q2 2026: Graphics & Reactivity (Apr - Jun 2026)

### March - May 2026: GPU Programming
**Goal**: Compile-time Vulkan bindings

- [ ] `std/gpu/vulkan.at` - Vulkan bindings
  - [ ] Instance creation
  - [ ] Device selection
  - [ ] Command buffers
  - [ ] Pipeline creation
  - [ ] Shader compilation

- [ ] `std/gpu/metal.at` - Metal bindings (macOS/iOS)
  - [ ] Device creation
  - [ ] Command encoding
  - [ ] Shader compilation

**Milestone**: Triangle on screen via Vulkan

### April - June 2026: Reactive System
**Goal**: Fine-grained reactivity for UI

- [ ] `std/reactive/signal.at` - Reactive signals
  - [ ] Signal creation
  - [ ] Dependency tracking
  - [ ] Computed signals
  - [ ] Batch updates

- [ ] `std/ui/node.at` - Scene graph
  - [ ] Node hierarchy
  - [ ] Transform propagation
  - [ ] Reactive properties
  - [ ] Render traversal

**Milestone**: Animated UI at 120 FPS

---

## Q3 2026: Operating System (Jul - Sep 2026)

### May - June 2026: Process Management
**Goal**: Capability-secured processes

- [ ] `std/os/process.at` - Process spawning
  - [ ] Address space isolation
  - [ ] Capability granting
  - [ ] IPC implementation
  - [ ] Revocation support

**Milestone**: Spawn isolated process with capabilities

### June - August 2026: Nova Microkernel
**Goal**: Bootable microkernel

- [ ] `kernel/` - Microkernel implementation
  - [ ] Boot sequence
  - [ ] Memory management
  - [ ] Process scheduler
  - [ ] Device drivers
  - [ ] IPC subsystem

**Milestone**: Boot Nova on QEMU and real hardware

### July - September 2026: Aurora Engine Alpha
**Goal**: Production-ready rendering engine

- [ ] Aurora Engine implementation
  - [ ] Scene graph rendering
  - [ ] Reactive updates
  - [ ] GPU acceleration
  - [ ] Input handling
  - [ ] Performance optimization

**Milestone**: 120 FPS reactive UI demo

---

## Q4 2026: Web Platform (Oct - Dec 2026)

### October - December 2026: WebAssembly Backend
**Goal**: Run Athōn in browsers

- [ ] `compiler/backend/wasm64/` - WASM codegen
  - [ ] Module generation
  - [ ] Type mapping
  - [ ] Function exports
  - [ ] Memory management
  - [ ] Browser API bindings

**Milestone**: Aurora Engine running in browser

### Networking (Q3-Q4 2026)
**Goal**: Capability-secured networking

- [ ] `std/net/cap_stream.at` - Nova Protocol
  - [ ] TCP/UDP sockets
  - [ ] Post-quantum crypto
  - [ ] Capability multiplexing
  - [ ] E2EE by default

**Milestone**: Secure network communication

---

## 2026 Year-End Goals

By December 31, 2026, Athōn will have:

1. ✅ Native RISC-V backend (bare-metal)
2. ✅ WebAssembly backend (browser)
3. ✅ Region allocator (zero-GC)
4. ✅ Capability references (linear types)
5. ✅ Vulkan/Metal bindings (GPU)
6. ✅ Reactive signals (fine-grained)
7. ✅ Nova microkernel (bootable)
8. ✅ Aurora Engine (120 FPS)
9. ✅ Process isolation (capability-based)
10. ✅ Nova Protocol (post-quantum)

**Result**: Foundation for the next internet

---

## Beyond 2026

### 2027: Ecosystem
- Package manager (athon-pkg)
- Standard collections (Vec, HashMap)
- Async/await runtime
- Formal verification tools

### 2028-2030: Platform
- Complete browser in Athōn
- .nova executable format
- Decentralized app store
- AI-verified capabilities

### 2030-2035: Internet
- .nova protocol as default
- Sovereign computing platform
- Post-quantum security everywhere
- AI-augmented development

---

**The throne is forged in Athōn.**

Last Updated: November 21, 2025
