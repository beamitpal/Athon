# RISC-V 64-bit Backend

Native code generation for RISC-V architecture.

## Target: Q1 2026 (Jan - Mar 2026)

## Goals

- Direct Athōn → RISC-V machine code generation
- No C intermediate representation
- Bare-metal execution support
- Bootable on QEMU and real hardware

## Architecture

```
Athōn IR → RISC-V Assembly → Machine Code
```

## Files (To Be Created)

- `codegen.rs` - Main code generator
- `register_alloc.rs` - Register allocation
- `instruction.rs` - RISC-V instruction encoding
- `abi.rs` - Calling convention
- `linker.rs` - Object file generation

## RISC-V Features

- RV64I - Base integer instruction set
- RV64M - Multiply/divide
- RV64A - Atomic operations
- RV64C - Compressed instructions (optional)

## Calling Convention

Following RISC-V ABI:
- a0-a7: Arguments
- a0-a1: Return values
- ra: Return address
- sp: Stack pointer
- s0-s11: Saved registers

## Memory Layout

```
0x80000000: Kernel entry point
0x80001000: Code section
0x80100000: Data section
0x80200000: Heap
0x80F00000: Stack (grows down)
```

## Status

- [ ] Basic instruction encoding
- [ ] Register allocation
- [ ] Function calls
- [ ] Memory operations
- [ ] Control flow
- [ ] Capability tracking
- [ ] Bare-metal support

## Next Steps

1. Implement instruction encoder
2. Add register allocator
3. Generate function prologues/epilogues
4. Test on QEMU
5. Boot on real RISC-V hardware
