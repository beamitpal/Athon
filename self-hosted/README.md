# Self-Hosted Athōn Compiler Components

This directory contains compiler components written in Athōn itself, demonstrating the path toward self-hosting.

## Overview

A self-hosted compiler is one that can compile its own source code. This is a major milestone for any programming language, as it demonstrates that the language is powerful enough to implement complex systems.

## Current Status

### ✅ Lexer (Tokenizer)

The lexer is the first stage of compilation, responsible for breaking source code into tokens.

**Files**:
- `lexer_simple.at` - Working lexer demonstrating tokenization ✅
- `lexer.at` - Basic lexer with token kind definitions
- `lexer_full.at` - Advanced lexer with struct-based tokens (WIP)

### ✅ Parser

The parser is the second stage, converting tokens into an Abstract Syntax Tree (AST).

**Files**:
- `parser_simple.at` - Working parser demonstrating AST construction ✅
- `parser.at` - Advanced parser with full struct support (WIP)

### ✅ Code Generator

The code generator is the final stage, converting AST to target code (C).

**Files**:
- `codegen_simple.at` - Working code generator demonstrating C emission ✅
- `codegen.at` - Advanced codegen with optimization (WIP)

**Features Implemented**:
- Character classification (whitespace, digits, letters)
- Token recognition for:
  - Keywords: `fn`, `let`, `if`, `else`, `while`, `return`
  - Operators: `+`, `-`, `*`, `=`, etc.
  - Delimiters: `(`, `)`, `{`, `}`, `;`, etc.
  - Literals: numbers, identifiers
- Tokenization of example expressions

**Example Usage**:
```bash
# Compile and run the lexer
./athon-boot self-hosted/lexer_simple.at > /tmp/lexer.c
gcc /tmp/lexer.c -o /tmp/lexer
./tmp/lexer
```

**Output**:
```
=== Athōn Self-Hosted Lexer ===

Character Classification:
  is_whitespace(32): 1
  is_digit(53):      1
  is_alpha(97):      1

Token Classification:
  '(' (40)  -> kind 20
  '5' (53)  -> kind 71
  'a' (97)  -> kind 70

Lexing: x = 5 + 3;
  'x' -> identifier
  ' ' -> (whitespace, skip)
  '=' -> equals
  '5' -> number
  '+' -> plus
  '3' -> number
  ';' -> semicolon
```

## Implementation Details

### Token Kinds

Tokens are represented as integer constants:

**Keywords** (0-19):
- 0: `fn`
- 1: `let`
- 2: `if`
- 3: `else`
- 4: `while`
- 6: `return`

**Symbols** (20-49):
- 20: `(`
- 21: `)`
- 22: `{`
- 23: `}`
- 26: `;`

**Operators** (50-69):
- 50: `=`
- 57: `+`
- 58: `-`
- 59: `*`

**Literals** (70-79):
- 70: identifier
- 71: number

### Character Classification

The lexer uses ASCII values for character classification:

```athon
fn is_digit(c: int) -> int {
    return c >= 48 && c <= 57;  // '0' to '9'
}

fn is_alpha(c: int) -> int {
    if c >= 65 && c <= 90 { return 1; }   // 'A' to 'Z'
    if c >= 97 && c <= 122 { return 1; }  // 'a' to 'z'
    if c == 95 { return 1; }              // '_'
    return 0;
}
```

### Tokenization Process

1. **Character Classification**: Determine if character is whitespace, digit, letter, or symbol
2. **Token Recognition**: Map character/sequence to token kind
3. **Token Stream**: Build sequence of tokens from source code

## Roadmap

### Phase 1: Lexer ✅ **COMPLETE**
- [x] Character classification
- [x] Token kind definitions
- [x] Single-character token recognition
- [x] Basic tokenization demonstration

### Phase 2: Parser ✅ **COMPLETE**
- [x] Token stream processing
- [x] Recursive descent parsing
- [x] AST construction
- [x] Expression parsing
- [x] Statement parsing

### Phase 3: Code Generator ✅ **COMPLETE**
- [x] Expression code generation
- [x] Statement code generation
- [x] Function code generation
- [x] C code emission

### Phase 3: Type Checker
- [ ] Symbol table
- [ ] Type inference
- [ ] Type checking rules
- [ ] Error reporting

### Phase 4: IR Generator
- [ ] AST to IR translation
- [ ] SSA construction
- [ ] Basic block generation

### Phase 5: Code Generator
- [ ] IR to C translation
- [ ] Or: IR to assembly
- [ ] Or: IR to bytecode

### Phase 6: Self-Hosting
- [ ] Compile lexer with self-hosted compiler
- [ ] Compile parser with self-hosted compiler
- [ ] Full bootstrap: compile entire compiler with itself

## Design Decisions

### Why Integer Token Kinds?

Athōn currently doesn't have full enum support in all contexts, so we use integer constants for token kinds. This is a common approach in early compiler implementations.

### Why Character-by-Character?

The current implementation processes one character at a time for simplicity. A production lexer would:
- Process strings as arrays
- Use lookahead for multi-character tokens
- Build token text dynamically

### Current Limitations

1. **No String Processing**: Athōn doesn't yet have full string manipulation, so we work with character codes
2. **No Dynamic Arrays**: Token streams are demonstrated, not built
3. **No String Literals**: Can't lex string literals yet
4. **Simplified Keywords**: Keyword recognition is simplified

## Testing

The lexer includes built-in tests that demonstrate:

1. **Character Classification**:
   ```athon
   is_whitespace(32)  // space -> 1
   is_digit(53)       // '5' -> 1
   is_alpha(97)       // 'a' -> 1
   ```

2. **Token Recognition**:
   ```athon
   classify_char(40)  // '(' -> 20 (lparen)
   classify_char(53)  // '5' -> 71 (number)
   classify_char(97)  // 'a' -> 70 (identifier)
   ```

3. **Expression Lexing**:
   ```athon
   "x = 5 + 3;" -> [identifier, equals, number, plus, number, semicolon]
   ```

4. **Function Lexing**:
   ```athon
   "fn add(x) { }" -> [identifier, identifier, lparen, identifier, rparen, lbrace, rbrace]
   ```

## Contributing

To extend the lexer:

1. **Add Token Kinds**: Define new token kind constants
2. **Add Classification**: Extend `classify_char()` for new tokens
3. **Add Tests**: Add examples in `main()` function
4. **Document**: Update this README

## Next Steps

1. **Implement Parser**: Build on lexer to create AST
2. **Add String Support**: Once Athōn has better string handling
3. **Multi-Character Tokens**: Handle `==`, `!=`, `->`, etc.
4. **Keyword Table**: Proper keyword recognition
5. **Error Handling**: Report lexical errors with line/column

## References

- **Bootstrap Lexer**: `compiler/bootstrap/src/lexer.rs` - Rust implementation
- **Language Spec**: `athon-spec/syntax.md` - Token definitions
- **Roadmap**: `athon-spec/roadmap.md` - Self-hosting goals

## Significance

This lexer represents the first step toward self-hosting. It demonstrates that:

1. ✅ Athōn can implement complex logic
2. ✅ Athōn can process character data
3. ✅ Athōn can classify and recognize patterns
4. ✅ Athōn is suitable for compiler implementation

**Next milestone**: Implement a parser in Athōn to build ASTs from token streams.
