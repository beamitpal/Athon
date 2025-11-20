# Intermediate Representation (AIR)

Athōn IR (AIR) is a deterministic, textual SSA-based IR.

## Design Goals

- **Simple**: Minimal instruction set.
- **Typed**: Preserves type information for backend optimization.
- **Explicit**: No implicit control flow.

## Instructions (Ops)

- `alloc %reg, size` : Allocate memory in current region.
- `load %dest, %ptr` : Load value.
- `store %ptr, %val` : Store value.
- `call %dest, @func, args...` : Function call.
- `br label` : Unconditional branch.
- `condbr %cond, true_label, false_label` : Conditional branch.
- `ret %val` : Return.

## Structure

- Modules contain Functions.
- Functions contain Basic Blocks.
- Basic Blocks contain Instructions.
