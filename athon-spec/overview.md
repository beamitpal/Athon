# Athōn Language Specification: Overview

## Goal

Athōn aims to be the foundation for critical infrastructure software that must survive for decades. It provides a capability-based security model to eliminate entire classes of vulnerabilities (like arbitrary file access or network exfiltration) at the type system level.

## Core Invariant

**"If a function does not accept a capability token, it cannot perform the side effect associated with that capability."**

## Design Philosophy

- **Explicit over Implicit**: Magic is forbidden. Control flow and allocation must be visible.
- **Zero-Cost Abstractions**: Safety features should not incur runtime overhead where possible.
- **Minimal Runtime**: The language requires a minimal runtime environment, suitable for bare-metal execution.

## Current Implementation Status

### Bootstrap Compiler (Stage 0)
The bootstrap compiler is written in Rust and compiles Athōn to C. It implements:

**Core Language Features:**
- Variables and basic types (int, bool, string)
- Functions with parameters and return values
- Control flow (if/else, while, for loops)
- All operators (arithmetic, comparison, logical, unary)
- Comments (single-line and multi-line)

**Data Structures:**
- Arrays with literals and indexing
- Structs with member access
- Enums with variants

**Advanced Features:**
- Pattern matching with exhaustive checking
- Recursive functions
- Printf-style string formatting

**Standard Library:**
- Math functions (abs, min, max, pow, sqrt, mod)
- File I/O operations (read, write, append, exists)
- String operations (length, concat, compare)
- Array operations (length)

### Future Stages
- **Stage 1**: Self-hosting compiler written in Athōn
- **Stage 2**: Capability system enforcement
- **Stage 3**: Memory safety and region analysis
- **Stage 4**: Formal verification integration

## Implementation Notes

The bootstrap compiler:
- Generates readable C code for inspection
- Uses helper functions for complex operations
- Provides comprehensive error messages with line/column information
- Supports 31 working example programs
- Achieves 100% test pass rate
