# IR and Type Checker Integration Example

This document demonstrates how the IR generator and type checker work together to compile Athōn programs.

## Example Program

```athon
fn factorial(n: int) -> int {
    if n <= 1 {
        return 1;
    } else {
        return n * factorial(n - 1);
    }
}

fn main() {
    let result = factorial(5);
    print(result);
}
```

## Compilation Pipeline

### Step 1: Parsing (AST)

The parser converts source code to an Abstract Syntax Tree:

```
Program {
    functions: [
        Function {
            name: "factorial",
            params: [("n", "int")],
            return_type: Some("int"),
            body: [
                If {
                    condition: Binary { left: Variable("n"), op: LtEq, right: Number(1) },
                    then_block: [Return { value: Some(Number(1)) }],
                    else_block: Some([
                        Return {
                            value: Some(Binary {
                                left: Variable("n"),
                                op: Mul,
                                right: Call {
                                    name: "factorial",
                                    args: [Binary { left: Variable("n"), op: Sub, right: Number(1) }]
                                }
                            })
                        }
                    ])
                }
            ]
        },
        Function {
            name: "main",
            params: [],
            return_type: None,
            body: [
                Let { name: "result", value: Call { name: "factorial", args: [Number(5)] } },
                Expr(Call { name: "print", args: [Variable("result")] })
            ]
        }
    ]
}
```

### Step 2: Type Checking

The type checker validates the AST:

```
✓ Function 'factorial' signature: (int) -> int
✓ Parameter 'n' has type int
✓ Expression 'n <= 1' has type bool (int <= int -> bool)
✓ Return value '1' has type int (matches return type)
✓ Expression 'n - 1' has type int (int - int -> int)
✓ Call 'factorial(n - 1)' has type int (matches signature)
✓ Expression 'n * factorial(n - 1)' has type int (int * int -> int)
✓ Return value matches return type int

✓ Function 'main' signature: () -> void
✓ Call 'factorial(5)' has type int
✓ Variable 'result' has type int
✓ Call 'print(result)' is valid
```

### Step 3: IR Generation

The IR generator converts the typed AST to AIR:

```air
module example

fn @factorial(%n: int) -> int {
entry:
  %const.0 = const_int 1
  %binop.1 = lte %n.0, %const.0
  condbr %binop.1, then0, else1

then0:
  %const.2 = const_int 1
  ret %const.2

else1:
  %const.3 = const_int 1
  %binop.4 = sub %n.0, %const.3
  %call.5 = call @factorial(%binop.4)
  %binop.6 = mul %n.0, %call.5
  ret %binop.6
}

fn @main() -> void {
entry:
  %const.0 = const_int 5
  %call.1 = call @factorial(%const.0)
  call @print(%call.1)
  ret void
}
```

### Step 4: Optimization (Future)

Optimization passes can transform the IR:

- Constant folding
- Dead code elimination
- Inlining
- Register allocation

### Step 5: Code Generation

The backend converts IR to target code (C, assembly, etc.):

```c
int factorial(int n) {
    if (n <= 1) {
        return 1;
    } else {
        return n * factorial(n - 1);
    }
}

void main() {
    int result = factorial(5);
    print(result);
}
```

## Type Checking Examples

### Example 1: Type Error Detection

```athon
fn bad_add(x: int, y: bool) -> int {
    return x + y;  // ERROR: Cannot add int and bool
}
```

Type checker output:
```
Error: Type mismatch in binary operation
  Operation: +
  Left operand: int
  Right operand: bool
  Expected: int + int -> int
```

### Example 2: Linear Capability Tracking

```athon
fn use_capability(cap: Cap) {
    write(cap, "Hello");
    write(cap, "World");  // ERROR: Capability already moved
}
```

Type checker output:
```
Error: Use of moved value
  Variable: cap
  First use: line 2 (write call)
  Second use: line 3 (write call)
  Note: Linear capabilities can only be used once
```

### Example 3: Struct Field Validation

```athon
struct Point {
    x: int,
    y: int,
}

fn get_z(p: Point) -> int {
    return p.z;  // ERROR: Point has no field 'z'
}
```

Type checker output:
```
Error: Unknown struct field
  Struct: Point
  Field: z
  Available fields: x, y
```

## IR Features Demonstrated

### SSA Form

Each value is assigned exactly once:
```air
%const.0 = const_int 1    // First constant
%const.2 = const_int 1    // Different register for second constant
```

### Basic Blocks

Clear control flow structure:
```air
entry:
  // Entry block
  condbr %cond, then0, else1

then0:
  // Then branch
  ret %value

else1:
  // Else branch
  ret %other_value
```

### Type Preservation

All values have explicit types:
```air
fn @add(%a: int, %b: int) -> int {
  // Types preserved throughout
}
```

## Integration Benefits

1. **Early Error Detection**: Type checker catches errors before code generation
2. **Optimization Opportunities**: Typed IR enables safe transformations
3. **Clear Semantics**: IR makes program behavior explicit
4. **Verification Ready**: Structured IR supports formal methods
5. **Multiple Backends**: IR can target different platforms

## Next Steps

1. **AST to IR Bridge**: Connect parser output to IR generator
2. **Type-Directed Generation**: Use type information during IR generation
3. **Optimization Passes**: Implement IR transformations
4. **Backend Integration**: Connect IR to C code generator
5. **Self-Hosting**: Write compiler in Athōn using these components
