# IR Examples

Example programs in Athōn Intermediate Representation (IR) format.

## Status

⚠️ **Examples to be added**

## Purpose

This directory will contain example IR programs demonstrating:
- IR syntax and structure
- Optimization opportunities
- Transformation examples
- Code generation patterns

## Planned Examples

### Basic Examples
- `hello.ir` - Simple hello world in IR
- `arithmetic.ir` - Basic arithmetic operations
- `control_flow.ir` - If/else, loops in IR

### Advanced Examples
- `optimization.ir` - Before/after optimization
- `ssa.ir` - Static Single Assignment form
- `lowering.ir` - High-level to low-level IR

## IR Format

The Athōn IR format is documented in:
- [ir_format.md](ir_format.md) - IR syntax specification
- [design.md](design.md) - IR design principles

## Usage

```bash
# Once IR tools are implemented
athon-ir-tool examples/hello.ir
```

## Contributing

When adding IR examples:
1. Follow the IR format specification
2. Include comments explaining the IR
3. Show both input and output
4. Document any optimizations applied
