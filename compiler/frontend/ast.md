# Abstract Syntax Tree (AST)

The AST represents the syntactic structure of an Athōn program.

## Nodes

### Top Level

- `Program`: List of `Item`s.
- `Item`: `Function`, `Struct`, `Const`.

### Function

- `Function`:
  - `name`: Identifier
  - `params`: List of `Param`
  - `return_type`: `Type`
  - `body`: `Block`

### Statements

- `LetStmt`: `name`, `type`, `expr`
- `ReturnStmt`: `expr`
- `ExprStmt`: `expr`

### Expressions

- `BinaryExpr`: `left`, `op`, `right`
- `CallExpr`: `func`, `args`
- `Literal`: `Int`, `String`, `Bool`
