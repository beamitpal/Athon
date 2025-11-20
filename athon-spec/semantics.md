# Semantics

## Evaluation Order

Strict evaluation. Arguments are evaluated left-to-right before function application.

## Module System

- **Modules**: Modules are defined by file structure.
- **Visibility**: Visibility is private by default. `pub` keyword exposes items.
- **No Cyclic Dependencies**: The compiler enforces a strict DAG of module dependencies.

## ABI (Application Binary Interface)

Athōn defines a stable C-compatible ABI for functions marked `extern "C"`.
Internal ABI is not stable and may change between compiler versions.

## Safety Checks

- **Bounds Checking**: Enabled by default.
- **Integer Overflow**: Traps (panics) in debug and release modes.
- **Null Pointers**: Non-existent. `Option<T>` is used for nullable values.
