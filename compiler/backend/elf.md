# ELF Generation

The backend generates ELF64 (Executable and Linkable Format) binaries directly, without relying on an external assembler or linker (like `ld`).

## Sections

1. **.text**: Executable machine code.
2. **.rodata**: Read-only data (string constants).
3. **.data**: Mutable globals (discouraged in Athōn).
4. **.bss**: Zero-initialized data.

## Layout

- **ELF Header**: 64 bytes.
- **Program Headers**: Describe segments (LOAD).
- **Section Headers**: Describe sections (for debugging/linking).
- **Content**: The raw bytes of code and data.

## Verification

The generated ELF binary can be inspected with `readelf` or `objdump` to verify structure.
