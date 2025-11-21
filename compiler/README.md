# Athōn Compiler Components

This directory contains the core compiler components for Athōn, including the intermediate representation (IR) and type system.

## Structure

```
compiler/
├── bootstrap/          # Bootstrap compiler (Rust -> C)
├── frontend/          # Parser and AST
├── ir/               # Intermediate Representation (AIR)
│   ├── ir.rs         # IR data structures
│   ├── ir_gen.rs     # AST to IR generator
│   ├── printer.rs    # IR pretty printer
│   └── examples/     # IR generation examples
├── type-system/      # Type checker
│   ├── type_checker.rs  # Type checking implementation
│   └── examples/     # Type checking examples
└── backend/          # Code generation

```

## Intermediate Representation (AIR)

The Athōn Intermediate Representation (AIR) is a typed, SSA-based IR designed for:

- **Simplicity**: Minimal instruction set
- **Type preservation**: Full type information for optimization
- **Explicit control flow**: No hidden branches or side effects

### Key Features

- **SSA Form**: Single Static Assignment for optimization
- **Basic Blocks**: Clear control flow structure
- **Typed Instructions**: Every value has an explicit type
- **Capability Tracking**: Supports capability-based security

### IR Instructions

Core instructions include:
- `const_int`, `const_bool`, `const_string` - Constants
- `add`, `sub`, `mul`, `div` - Arithmetic
- `eq`, `neq`, `lt`, `gt` - Comparisons
- `and`, `or`, `not` - Logic
- `call` - Function calls
- `br`, `condbr` - Control flow
- `ret` - Return
- `array_alloc`, `array_load`, `array_store` - Arrays
- `struct_alloc`, `struct_load`, `struct_store` - Structs

### Example IR

```air
module example

fn @add(%a: int, %b: int) -> int {
entry:
  %binop.0 = add %a.0, %b.1
  ret %binop.0
}

fn @max(%x: int, %y: int) -> int {
entry:
  %binop.0 = gt %x.0, %y.1
  condbr %binop.0, then, else
then:
  ret %x.0
else:
  ret %y.1
}
```

## Type System

The type checker validates:

1. **Type Safety**: Operations match operand types
2. **Capability Safety**: Linear/affine types used correctly
3. **Struct/Enum Validity**: Fields and variants exist
4. **Function Signatures**: Calls match declarations

### Type Checking Features

- **Basic Types**: `int`, `bool`, `string`, `void`
- **Composite Types**: Arrays, structs, enums
- **Linear Types**: Capability tracking (use-once semantics)
- **Affine Types**: At-most-once usage
- **Borrowing**: Reference tracking (future)

### Type Rules

```
Arithmetic: int × int → int
Comparison: T × T → bool (where T is comparable)
Logic: bool × bool → bool
Linear: Cap must be consumed exactly once
```

## Usage

### Generating IR

```rust
use ir::{IRGenerator, Type, BinOp};

let mut gen = IRGenerator::new("my_module".to_string());

// Start function
gen.start_function(
    "add".to_string(),
    vec![("a".to_string(), Type::Int), ("b".to_string(), Type::Int)],
    Type::Int
);

// Generate IR
let a = gen.gen_variable("a").unwrap();
let b = gen.gen_variable("b").unwrap();
let result = gen.gen_binop(BinOp::Add, a, b);
gen.gen_return(Some(result));

// Get module
let module = gen.finish();
```

### Type Checking

```rust
use type_system::{TypeChecker, Type};

let mut checker = TypeChecker::new();
let ctx = checker.context_mut();

// Add variable
ctx.add_var("x".to_string(), Type::Int, false);

// Check usage
ctx.check_var_use("x")?;

// Check operation
let result_type = checker.check_binop("+", &Type::Int, &Type::Int)?;
```

## Testing

Run IR generation example:
```bash
cd compiler/ir/examples
# Would compile and run with: rustc simple_ir_test.rs && ./simple_ir_test
```

Run type checker example:
```bash
cd compiler/type-system/examples
# Would compile and run with: rustc type_check_test.rs && ./type_check_test
```

## Implementation Status

✅ **Completed:**
- IR data structures (registers, instructions, basic blocks)
- IR generator (AST to IR conversion)
- IR printer (textual output)
- Type checker core (type validation)
- Linear type tracking (capability safety)
- Struct and enum support

⏳ **Next Steps:**
- Integrate with bootstrap compiler
- Add optimization passes
- Implement region analysis
- Add formal verification hooks
- Complete self-hosting compiler

## Design Documents

- `ir/design.md` - IR design philosophy
- `ir/ir_format.md` - IR textual format specification
- `type-system/rules.md` - Type system rules and algorithms

## Contributing

When adding new IR instructions or type rules:
1. Update the relevant data structures
2. Add printer support
3. Update type checking rules
4. Add tests and examples
5. Document in design files
