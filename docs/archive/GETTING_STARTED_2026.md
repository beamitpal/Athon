# Getting Started with Athōn 2026 Development

Welcome to the Athōn Ultimate Battle Plan.

## What We're Building

**The operating system of the next internet.**

Not just a programming language, but:
- A bare-metal operating system
- A high-performance rendering engine
- A capability-secure platform
- The foundation for a new web

## Current Status (November 2025)

### ✅ Complete
- Self-hosting compiler (5 phases)
- Capability-based type system
- Zero external dependencies
- Reproducible builds
- Generics, traits, union types

### 🚧 In Progress (2026)
- RISC-V native backend
- Region allocator
- Vulkan/Metal bindings
- Reactive signals
- Nova microkernel
- Aurora Engine

## Directory Structure

```
athon/
├── compiler/
│   └── backend/
│       ├── riscv64/        # Native RISC-V codegen (Q1 2026)
│       └── wasm64/         # WebAssembly backend (Q4 2026)
├── std/
│   ├── mem/
│   │   ├── region.at       # Arena allocator (Q1 2026)
│   │   └── cap_ref.at      # Linear references (Q1 2026)
│   ├── os/
│   │   ├── no_std.at       # Freestanding core (Q1 2026)
│   │   ├── process.at      # Process spawning (Q3 2026)
│   │   └── linker.ld       # Linker script (Q1 2026)
│   ├── gpu/
│   │   ├── vulkan.at       # Vulkan bindings (Q2 2026)
│   │   └── metal.at        # Metal bindings (Q2 2026)
│   ├── reactive/
│   │   └── signal.at       # Reactive signals (Q2 2026)
│   ├── ui/
│   │   └── node.at         # Scene graph (Q2 2026)
│   └── net/
│       └── cap_stream.at   # Nova Protocol (Q3 2026)
├── kernel/                 # Nova microkernel (Q3 2026)
├── examples/
│   ├── kernel_spawn.at     # Process demo
│   └── render_scene.at     # Aurora demo
└── athon-pkg/              # Package manager (2026-2027)
```

## Quick Start

### 1. Build Current Compiler
```bash
./install.sh
```

### 2. Test Self-Hosting
```bash
./test-self-compilation.sh
```

### 3. Explore Examples
```bash
./athon examples/hello.at
```

## Development Priorities (Next 12 Months)

### Priority 1: Memory Management (Dec 2025 - Feb 2026)
Work on: `std/mem/region.at`, `std/mem/cap_ref.at`

### Priority 2: RISC-V Backend (Jan - Mar 2026)
Work on: `compiler/backend/riscv64/`

### Priority 3: Freestanding Environment (Feb - Apr 2026)
Work on: `std/os/no_std.at`, `std/os/linker.ld`

### Priority 4: GPU Programming (Mar - May 2026)
Work on: `std/gpu/vulkan.at`

## How to Contribute

### For Memory Management
1. Study region allocators (Rust's bumpalo, Zig's allocators)
2. Implement `region_new()`, `region_alloc()`, `region_free()`
3. Add capability tracking
4. Write tests and benchmarks

### For RISC-V Backend
1. Study RISC-V ISA specification
2. Implement instruction encoding
3. Add register allocation
4. Test on QEMU
5. Boot on real hardware

### For GPU Programming
1. Study Vulkan specification
2. Generate bindings at compile-time
3. Implement command buffer submission
4. Test with simple triangle
5. Optimize for zero overhead

## Resources

### Documentation
- `BATTLE_PLAN.md` - Overall strategy
- `ROADMAP_2026.md` - Quarterly milestones
- `compiler/backend/riscv64/README.md` - RISC-V backend
- `kernel/README.md` - Microkernel design

### Examples
- `examples/kernel_spawn.at` - Process isolation demo
- `examples/render_scene.at` - Aurora Engine demo

### Specifications
- RISC-V ISA: https://riscv.org/specifications/
- Vulkan: https://www.vulkan.org/
- WebAssembly: https://webassembly.org/

## Testing

### Test Memory Allocator
```bash
./athon std/mem/region.at --test
```

### Test RISC-V Backend
```bash
./athon examples/hello.at --target riscv64
qemu-system-riscv64 -kernel hello.elf
```

### Test GPU Rendering
```bash
./athon examples/render_scene.at
```

## Milestones

### Q1 2026
- [ ] Region allocator working
- [ ] RISC-V backend generates code
- [ ] Hello World boots on QEMU

### Q2 2026
- [ ] Vulkan triangle renders
- [ ] Reactive signals implemented
- [ ] 120 FPS UI demo

### Q3 2026
- [ ] Process spawning works
- [ ] Nova kernel boots
- [ ] Aurora Engine alpha

### Q4 2026
- [ ] WASM backend complete
- [ ] Aurora runs in browser
- [ ] Nova Protocol working

## Community

- GitHub: https://github.com/beamitpal/athon
- Discussions: Use GitHub Discussions
- Issues: Report bugs and feature requests

## Philosophy

We're not building another programming language.

We're building:
- The operating system of the next internet
- A capability-secure platform
- A foundation for sovereign computing

**The throne is forged in Athōn.**

---

Last Updated: November 21, 2025  
Next Review: December 2025
