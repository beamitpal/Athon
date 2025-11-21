/* Athōn Custom Linker Script
 * For bare-metal / kernel builds
 * Target: Q1 2026 (Feb - Apr 2026)
 */

OUTPUT_FORMAT("elf64-littleriscv")
OUTPUT_ARCH(riscv)
ENTRY(_start)

MEMORY
{
    /* RISC-V memory layout */
    RAM (rwx) : ORIGIN = 0x80000000, LENGTH = 128M
}

SECTIONS
{
    . = 0x80000000;

    /* Code section */
    .text : {
        *(.text._start)
        *(.text .text.*)
    } > RAM

    /* Read-only data */
    .rodata : {
        *(.rodata .rodata.*)
    } > RAM

    /* Initialized data */
    .data : {
        *(.data .data.*)
    } > RAM

    /* Uninitialized data */
    .bss : {
        *(.bss .bss.*)
        *(COMMON)
    } > RAM

    /* Stack (grows downward) */
    . = ALIGN(16);
    _stack_start = .;
    . += 0x100000; /* 1MB stack */
    _stack_end = .;

    /* Heap (for region allocator) */
    . = ALIGN(16);
    _heap_start = .;
    . += 0x1000000; /* 16MB heap */
    _heap_end = .;

    /* Discard debug info for now */
    /DISCARD/ : {
        *(.comment)
        *(.debug*)
    }
}
