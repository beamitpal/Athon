# Contributing to Athōn

Thank you for your interest in contributing to Athōn! This document provides guidelines and information for contributors.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Documentation](#documentation)
- [Submitting Changes](#submitting-changes)

## Code of Conduct

### Core Principles

1. **Sovereignty First**: All contributions must respect the "no external dependencies" policy
2. **Security by Design**: Consider security implications of every change
3. **Reproducibility**: Ensure all changes maintain deterministic builds
4. **Long-term Thinking**: Code should be maintainable for decades

### Community Guidelines

- Be respectful and constructive
- Focus on technical merit
- Document your reasoning
- Test thoroughly before submitting

## Getting Started

### Prerequisites

- Rust compiler (rustc 1.70+)
- GCC or Clang
- Basic understanding of compilers
- Familiarity with C code generation

### Setting Up Development Environment

```bash
# Clone the repository
git clone <repository-url>
cd athon

# Build the bootstrap compiler
cd compiler/bootstrap
bash build.sh
cd ../..

# Test the compiler
./athon-boot examples/hello.at > hello.c
gcc hello.c -o hello
./hello
```

### Understanding the Codebase

1. **Read the documentation:**
   - [Language Guide](docs/language-guide.md)
   - [API Reference](docs/api-reference.md)
   - [Architecture](docs/architecture.md)

2. **Study the examples:**
   - Start with simple examples in `examples/`
   - Progress to advanced examples
   - See [Examples Index](docs/examples-index.md)

3. **Examine the compiler:**
   - Read `compiler/bootstrap/main.rs`
   - Understand the lexer, parser, and code generator
   - Review generated C code

## Development Workflow

### 1. Choose a Task

Check `task.md` for:
- Unimplemented features
- Known issues
- Documentation needs
- Test coverage gaps

### 2. Create a Branch

```bash
git checkout -b feature/your-feature-name
```

### 3. Make Changes

- Keep changes focused and atomic
- Write clear commit messages
- Test incrementally

### 4. Test Thoroughly

```bash
# Test all examples
for f in examples/*.at; do
    ./athon-boot "$f" > /tmp/test.c && gcc /tmp/test.c -o /tmp/test && /tmp/test
done

# Test specific feature
./athon-boot examples/your-test.at > test.c
gcc test.c -o test
./test
```

### 5. Update Documentation

- Update relevant markdown files
- Add examples if needed
- Update API reference
- Update test results

### 6. Submit for Review

- Create a pull request
- Describe changes clearly
- Reference related issues
- Include test results

## Coding Standards

### Rust Code (Bootstrap Compiler)

```rust
// Use descriptive names
fn parse_expression(&mut self) -> Expr { ... }

// Add comments for complex logic
// Parse binary expression with operator precedence
fn parse_binary(&mut self) -> Expr { ... }

// Handle errors gracefully
if !self.expect(TokenKind::Semicolon) {
    eprintln!("Error at line {}, column {}: Expected ';'",
             self.current.line, self.current.column);
    process::exit(1);
}

// Keep functions focused
fn emit_function(func: &Function) { ... }
fn emit_statement(stmt: &Statement, indent: usize) { ... }
```

### Athōn Code (Examples)

```athon
// Use descriptive variable names
let player_health = 100;
let max_score = 1000;

// Comment complex algorithms
// Calculate distance using Pythagorean theorem
fn distance(x1: int, y1: int, x2: int, y2: int) -> int {
    let dx = abs(x2 - x1);
    let dy = abs(y2 - y1);
    return sqrt(dx * dx + dy * dy);
}

// Keep functions small and focused
fn validate_input(x: int) -> int { ... }
fn process_data(x: int) -> int { ... }
fn format_output(x: int) { ... }
```

### Generated C Code

- Should be readable and debuggable
- Use consistent indentation (4 spaces)
- Add comments for helper functions
- Follow C99 standard

## Testing

### Test Categories

1. **Unit Tests**: Test individual components
2. **Integration Tests**: Test feature combinations
3. **Example Tests**: Ensure all examples compile and run
4. **Regression Tests**: Prevent breaking existing functionality

### Adding New Tests

```bash
# Create a new example
cat > examples/my_feature.at << 'EOF'
fn main() {
    // Test your feature
    print("Testing my feature");
}
EOF

# Test it
./athon-boot examples/my_feature.at > test.c
gcc test.c -o test
./test
```

### Test Checklist

- [ ] All existing examples still pass
- [ ] New feature has example code
- [ ] Edge cases are tested
- [ ] Error messages are clear
- [ ] Generated C code compiles without warnings

## Documentation

### What to Document

1. **New Features**: Add to language guide and API reference
2. **Examples**: Add to examples index with description
3. **Breaking Changes**: Update migration guide
4. **Bug Fixes**: Update changelog

### Documentation Standards

```markdown
# Clear Headings

Use descriptive headings that explain the content.

## Code Examples

Always include working code examples:

\`\`\`athon
fn example() {
    print("Clear and complete");
}
\`\`\`

## Explanations

Explain WHY, not just WHAT:
- Why this design was chosen
- Why alternatives were rejected
- Why this matters to users
```

### Files to Update

When adding features, update:
- `docs/language-guide.md` - Tutorial content
- `docs/api-reference.md` - Function documentation
- `docs/examples-index.md` - Example catalog
- `athon-spec/syntax.md` - Formal syntax
- `TEST_RESULTS.md` - Test coverage
- `task.md` - Mark tasks complete

## Submitting Changes

### Before Submitting

1. **Test everything:**
   ```bash
   # Run full test suite
   bash ci/static_checks.sh
   ```

2. **Update documentation:**
   - Add/update relevant docs
   - Update examples if needed
   - Update test results

3. **Clean up:**
   ```bash
   # Remove temporary files
   rm -f *.c *.o test /tmp/test.c /tmp/test
   ```

4. **Review your changes:**
   ```bash
   git diff
   git status
   ```

### Commit Message Format

```
<type>: <short summary>

<detailed description>

<references>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `test`: Adding tests
- `refactor`: Code refactoring
- `perf`: Performance improvement

**Example:**
```
feat: Add pattern matching for enums

Implements pattern matching with support for:
- Enum variant patterns
- Literal patterns (numbers, booleans)
- Wildcard pattern (_)
- Block and expression bodies

Closes #42
```

### Pull Request Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] New feature
- [ ] Bug fix
- [ ] Documentation
- [ ] Refactoring

## Testing
- [ ] All examples pass
- [ ] New tests added
- [ ] Documentation updated

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings
```

## Areas for Contribution

### High Priority

1. **Self-Hosting**: Write compiler components in Athōn
2. **Module System**: Implement code organization
3. **Type System**: Enhance type checking
4. **Error Messages**: Improve error reporting

### Medium Priority

1. **Standard Library**: Add more functions
2. **Optimization**: Improve generated code
3. **Examples**: More real-world programs
4. **Documentation**: Expand guides

### Low Priority

1. **Tooling**: IDE support, syntax highlighting
2. **Performance**: Compiler speed improvements
3. **Portability**: Support more platforms

## Getting Help

### Resources

- **Documentation**: See `docs/` directory
- **Examples**: See `examples/` directory
- **Specification**: See `athon-spec/` directory

### Questions

For questions about:
- **Language design**: See `athon-spec/`
- **Implementation**: See `compiler/bootstrap/`
- **Usage**: See `docs/language-guide.md`
- **Contributing**: This document

## License and Copyright

By contributing to Athōn, you agree that your contributions will be licensed under the same license as the project.

## Recognition

Contributors will be recognized in:
- CONTRIBUTORS.md file
- Release notes
- Project documentation

Thank you for contributing to Athōn! 🚀
