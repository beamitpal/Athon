# Bootstrap Compiler Refactoring Plan

## Current State
- Single file: `main.rs` (2151 lines)
- All code in one monolithic file

## Target Structure
```
compiler/bootstrap/
├── src/
│   ├── lib.rs           # Library root, re-exports modules
│   ├── lexer.rs         # Lexer (TokenKind, Token, Lexer) ✅ DONE
│   ├── ast.rs           # AST definitions ✅ DONE
│   ├── parser.rs        # Parser implementation
│   ├── codegen.rs       # Code generation
│   └── main.rs          # CLI entry point
├── Cargo.toml           # Rust project manifest
├── build.sh             # Build script
└── README.md            # Documentation
```

## Modules

### ✅ lexer.rs (DONE)
- TokenKind enum
- Token struct
- Lexer struct and implementation
- Helper functions (is_alpha, is_digit, is_alnum)

### ✅ ast.rs (DONE)
- Expr enum
- BinOp, UnaryOp enums
- Pattern enum
- MatchArm struct
- Statement enum
- Parameter, Function structs
- StructField, StructDef structs
- EnumDef struct
- Program struct

### parser.rs (TODO)
- Parser struct
- All parsing methods
- Error handling

### codegen.rs (TODO)
- Code generation for all AST nodes
- C code emission
- Helper functions

### lib.rs (TODO)
- Module declarations
- Public API exports

### main.rs (TODO)
- CLI argument parsing
- File I/O
- Compiler pipeline orchestration

## Benefits
1. **Maintainability** - Easier to find and modify code
2. **Testability** - Each module can be tested independently
3. **Clarity** - Clear separation of concerns
4. **Scalability** - Easy to add new features
5. **Collaboration** - Multiple developers can work on different modules

## Implementation Status
- [x] Create src/ directory
- [x] Extract lexer.rs
- [x] Extract ast.rs
- [ ] Extract parser.rs
- [ ] Extract codegen.rs
- [ ] Create lib.rs
- [ ] Create new main.rs
- [ ] Create Cargo.toml
- [ ] Update build.sh
- [ ] Test refactored compiler
- [ ] Update documentation
