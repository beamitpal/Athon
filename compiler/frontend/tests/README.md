# Frontend Tests

Test suite for the Athōn compiler frontend (lexer and parser).

## Status

⚠️ **Tests to be added**

## Planned Tests

### Lexer Tests
- Token recognition
- Comment handling
- String literals
- Number literals
- Keywords vs identifiers
- Operators
- Error cases

### Parser Tests
- Expression parsing
- Statement parsing
- Function definitions
- Struct definitions
- Enum definitions
- Pattern matching
- Error recovery

## Running Tests

```bash
# Once implemented
cargo test --package athon-frontend
```

## Test Coverage Goals

- **Lexer**: 100% coverage
- **Parser**: 100% coverage
- **Error handling**: All error paths tested

## Contributing

When adding tests:
1. Test both success and failure cases
2. Include edge cases
3. Document expected behavior
4. Use descriptive test names
