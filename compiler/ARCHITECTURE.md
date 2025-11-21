# Athōn Compiler Architecture

## Component Overview

```
┌─────────────────────────────────────────────────────────────┐
│                      Athōn Source Code                       │
│                      (examples/*.at)                         │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                    Frontend (Parser)                         │
│                  compiler/frontend/                          │
│  • Lexical analysis                                          │
│  • Syntax parsing                                            │
│  • AST construction                                          │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
                    ┌────────┐
                    │  AST   │
                    └────┬───┘
                         │
         ┌───────────────┴───────────────┐
         ▼                               ▼
┌─────────────────────┐         ┌─────────────────────┐
│   Type Checker      │         │   IR Generator      │
│ type-system/        │         │   ir/ir_gen.rs      │
│                     │         │                     │
│ • Type inference    │────────▶│ • SSA conversion    │
│ • Capability safety │         │ • Basic blocks      │
│ • Linear types      │         │ • Register alloc    │
│ • Struct/enum check │         │                     │
└─────────────────────┘         └──────────┬──────────┘
                                           │
                                           ▼
                                    ┌──────────────┐
                                    │  AIR (IR)    │
                                    │  ir/ir.rs    │
                                    └──────┬───────┘
                                           │
                         ┌─────────────────┼─────────────────┐
                         ▼                 ▼                 ▼
                  ┌────────────┐    ┌────────────┐   ┌────────────┐
                  │ Optimizer  │    │  Printer   │   │  Verifier  │
                  │  (future)  │    │ ir/printer │   │  (future)  │
                  └──────┬─────┘    └────────────┘   └────────────┘
                         │
                         ▼
                  ┌────────────┐
                  │  Backend   │
                  │ backend/   │
                  │ • C codegen│
                  │ • Assembly │
                  └──────┬─────┘
                         │
                         ▼
                  ┌────────────┐
                  │ Target Code│
                  │  (C, asm)  │
                  └────────────┘
```

## Data Flow

### 1. Source → AST
```
hello.at ──[Parser]──▶ AST {
                         functions: [...]
                         structs: [...]
                         enums: [...]
                       }
```

### 2. AST → Type Checking
```
AST ──[Type Checker]──▶ Typed AST + Type Context
                        
Type Context:
  • Variable types
  • Function signatures
  • Struct definitions
  • Enum definitions
  • Linear type states
```

### 3. AST → IR
```
Typed AST ──[IR Generator]──▶ AIR Module {
                                functions: [
                                  Function {
                                    blocks: [
                                      BasicBlock {
                                        instructions: [...]
                                        terminator: ...
                                      }
                                    ]
                                  }
                                ]
                              }
```

### 4. IR → Optimization (Future)
```
AIR ──[Optimizer]──▶ Optimized AIR

Passes:
  • Constant folding
  • Dead code elimination
  • Common subexpression elimination
  • Inlining
  • Loop optimization
```

### 5. IR → Code Generation
```
AIR ──[Backend]──▶ Target Code

Targets:
  • C code (current)
  • LLVM IR (future)
  • Assembly (future)
  • WebAssembly (future)
```

## Module Dependencies

```
┌──────────────────────────────────────────────────────────┐
│                    Bootstrap Compiler                     │
│                  (compiler/bootstrap/)                    │
│                                                           │
│  ┌─────────────┐  ┌──────────────┐  ┌────────────────┐  │
│  │   Parser    │─▶│     AST      │─▶│   C Codegen    │  │
│  │  parser.rs  │  │   ast.rs     │  │   codegen.rs   │  │
│  └─────────────┘  └──────┬───────┘  └────────────────┘  │
│                           │                               │
└───────────────────────────┼───────────────────────────────┘
                            │
                ┌───────────┴───────────┐
                ▼                       ▼
    ┌──────────────────────┐  ┌──────────────────────┐
    │   Type System        │  │   IR System          │
    │ (type-system/)       │  │   (ir/)              │
    │                      │  │                      │
    │ • type_checker.rs    │  │ • ir.rs              │
    │ • Type               │  │ • ir_gen.rs          │
    │ • TypeContext        │  │ • printer.rs         │
    │ • VarState           │  │ • Module             │
    │                      │  │ • Function           │
    └──────────────────────┘  │ • BasicBlock         │
                              │ • Instruction        │
                              └──────────────────────┘
```

## Type System Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    TypeContext                          │
│                                                         │
│  ┌──────────────┐  ┌──────────────┐  ┌─────────────┐  │
│  │  Variables   │  │  Functions   │  │   Structs   │  │
│  │              │  │              │  │             │  │
│  │ name → type  │  │ name → sig   │  │ name → def  │  │
│  │ name → state │  │              │  │             │  │
│  └──────────────┘  └──────────────┘  └─────────────┘  │
│                                                         │
│  ┌──────────────┐                                      │
│  │    Enums     │                                      │
│  │              │                                      │
│  │ name → vars  │                                      │
│  └──────────────┘                                      │
└─────────────────────────────────────────────────────────┘
                         │
                         ▼
              ┌──────────────────┐
              │   Type Checker   │
              │                  │
              │ • check_expr()   │
              │ • check_stmt()   │
              │ • check_binop()  │
              │ • check_unary()  │
              └──────────────────┘
```

## IR Architecture

```
┌─────────────────────────────────────────────────────────┐
│                      Module                             │
│                                                         │
│  ┌──────────────┐  ┌──────────────┐  ┌─────────────┐  │
│  │  Functions   │  │   Structs    │  │    Enums    │  │
│  └──────┬───────┘  └──────────────┘  └─────────────┘  │
└─────────┼───────────────────────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────────────────────┐
│                     Function                            │
│                                                         │
│  name: String                                           │
│  params: Vec<(String, Type)>                            │
│  return_type: Type                                      │
│  blocks: Vec<BasicBlock>                                │
└─────────────────────────┬───────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│                   BasicBlock                            │
│                                                         │
│  label: String                                          │
│  instructions: Vec<Instruction>                         │
│  terminator: Terminator                                 │
└─────────────────────────┬───────────────────────────────┘
                          │
          ┌───────────────┴───────────────┐
          ▼                               ▼
┌──────────────────┐           ┌──────────────────┐
│   Instruction    │           │   Terminator     │
│                  │           │                  │
│ • Alloc          │           │ • Branch         │
│ • Load/Store     │           │ • CondBranch     │
│ • BinOp/UnaryOp  │           │ • Return         │
│ • Call           │           └──────────────────┘
│ • Const*         │
│ • Array*         │
│ • Struct*        │
│ • Phi            │
└──────────────────┘
```

## Register Allocation (SSA)

```
Source:                    IR (SSA):
─────────                  ──────────
let x = 5;                 %x.0 = const_int 5
x = x + 1;                 %x.1 = add %x.0, const_int 1
x = x * 2;                 %x.2 = mul %x.1, const_int 2
return x;                  ret %x.2

Each assignment creates a new register (SSA property)
```

## Control Flow Graph

```
Source:                    IR CFG:
─────────                  ───────

if x > 0 {                 entry:
  y = 1;                     %cond = gt %x, 0
} else {                     condbr %cond, then, else
  y = 2;                   
}                          then:
return y;                    %y.0 = const_int 1
                             br merge
                           
                           else:
                             %y.1 = const_int 2
                             br merge
                           
                           merge:
                             %y.2 = phi [%y.0, then], [%y.1, else]
                             ret %y.2
```

## Capability Tracking

```
┌─────────────────────────────────────────────────────────┐
│                  Variable State                         │
│                                                         │
│  ┌──────────┐      ┌──────────┐      ┌──────────────┐  │
│  │  Alive   │─────▶│  Moved   │─────▶│  Consumed    │  │
│  │          │ use  │          │ drop │              │  │
│  └──────────┘      └──────────┘      └──────────────┘  │
│                                                         │
│  Linear: Must reach Consumed                            │
│  Affine: Can stop at Moved or Consumed                  │
└─────────────────────────────────────────────────────────┘
```

## Compilation Phases

```
Phase 1: Lexing & Parsing
  Input:  Source text
  Output: AST
  Time:   O(n)

Phase 2: Type Checking
  Input:  AST
  Output: Typed AST + Context
  Time:   O(n) to O(n²)

Phase 3: IR Generation
  Input:  Typed AST
  Output: AIR Module
  Time:   O(n)

Phase 4: Optimization (Future)
  Input:  AIR Module
  Output: Optimized AIR
  Time:   O(n) to O(n³)

Phase 5: Code Generation
  Input:  AIR Module
  Output: Target code
  Time:   O(n)
```

## Error Handling Flow

```
┌──────────┐
│  Parser  │──▶ Syntax Error ──▶ Report & Exit
└────┬─────┘
     │
     ▼
┌──────────────┐
│ Type Checker │──▶ Type Error ──▶ Report & Exit
└────┬─────────┘
     │
     ▼
┌──────────────┐
│ IR Generator │──▶ Generation Error ──▶ Report & Exit
└────┬─────────┘
     │
     ▼
┌──────────────┐
│   Backend    │──▶ Codegen Error ──▶ Report & Exit
└────┬─────────┘
     │
     ▼
  Success!
```

## Future Extensions

### Optimization Pipeline
```
AIR ──▶ [Constant Fold] ──▶ [DCE] ──▶ [CSE] ──▶ [Inline] ──▶ Optimized AIR
```

### Multi-Target Backend
```
                    ┌──▶ C Backend ──▶ .c
AIR ──▶ [Backend] ──┼──▶ LLVM Backend ──▶ .ll
                    ├──▶ ASM Backend ──▶ .s
                    └──▶ WASM Backend ──▶ .wasm
```

### Verification Integration
```
AIR ──▶ [Verifier] ──▶ [Theorem Prover] ──▶ Proof Certificate
```
