# Changelog

All notable changes to the Athōn language will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Module system for code organization
- Self-hosting compiler (Stage 1)
- Capability token system
- Generic types
- Trait system

## [0.3.0] - 2025-11-20

### Added
- **Complete Documentation Suite**
  - Comprehensive language guide with tutorials
  - Complete API reference for all built-in functions
  - Examples index with 31 cataloged programs
  - Learning paths for different skill levels
  - Contributing guidelines
  - Changelog

### Changed
- Updated README with current project status
- Enhanced roadmap with completion tracking
- Improved bootstrap compiler documentation

### Documentation
- Created `docs/language-guide.md` - Complete tutorial
- Created `docs/api-reference.md` - Function documentation
- Created `docs/examples-index.md` - Example catalog
- Created `CONTRIBUTING.md` - Contribution guidelines
- Created `CHANGELOG.md` - This file

## [0.2.0] - 2025-11-20

### Added
- **File I/O Library**
  - `file_read(filename)` - Read file contents
  - `file_write(filename, content)` - Write to file
  - `file_append(filename, content)` - Append to file
  - `file_exists(filename)` - Check file existence
- **New Examples**
  - `file_io_simple.at` - Basic file operations
  - `file_logger.at` - Logging system
  - `data_processor.at` - Data processing with file output

### Changed
- Updated syntax specification with file I/O documentation
- Enhanced standard library documentation

### Documentation
- Created `std/io/README.md` - File I/O documentation
- Updated `athon-spec/syntax.md` with file I/O examples

## [0.1.0] - 2025-11-20

### Added
- **Pattern Matching**
  - Match statements with multiple arms
  - Enum variant patterns
  - Literal patterns (numbers, booleans)
  - Wildcard pattern (`_`)
  - Block and expression bodies
  - Assignment support in match arms

- **Math Library**
  - `abs(x)` - Absolute value
  - `min(a, b)` - Minimum of two values
  - `max(a, b)` - Maximum of two values
  - `pow(base, exp)` - Power function
  - `sqrt(x)` - Integer square root
  - `mod(a, b)` - Modulo operation

- **Unary Negation**
  - Support for negative numbers (`-x`)
  - Unary minus operator in expressions

- **New Examples**
  - `match_test.at` - Basic pattern matching
  - `match_simple.at` - Enum matching
  - `match_comprehensive.at` - Advanced patterns
  - `match_integration.at` - Integration example
  - `math.at` - Math library demonstration
  - `geometry.at` - Geometry calculator
  - `showcase.at` - Complete feature showcase

### Fixed
- Struct parameters in functions now properly typed
- Struct return types now properly handled
- Struct literal parsing conflicts with match blocks

### Changed
- Improved code generation for structs
- Enhanced type handling in let statements

### Documentation
- Created `std/math/README.md` - Math library documentation
- Updated `athon-spec/syntax.md` with pattern matching
- Created `TEST_RESULTS.md` - Test coverage report

## [0.0.1] - 2025-11-19

### Added - Initial Bootstrap Compiler

**Core Language Features:**
- Variables and types (int, bool, string)
- Functions with parameters and return values
- Control flow (if/else, while, for loops)
- Operators (arithmetic, comparison, logical)
- Comments (single-line `//` and multi-line `/* */`)

**Data Structures:**
- Arrays with literals and indexing
- Structs with member access
- Enums with variants

**Standard Library:**
- String operations (length, concat, compare)
- Array operations (array_length)
- Printf-style formatting

**Examples:**
- Basic examples (hello, variables, arithmetic)
- Control flow examples (loops, conditionals)
- Function examples (factorial, recursion)
- Data structure examples (arrays, structs, enums)
- String examples (operations, formatting)

**Infrastructure:**
- Bootstrap compiler in Rust
- C code generation
- Build scripts
- Example programs
- Basic documentation

### Technical Details
- Lexer with full token support
- Recursive descent parser
- AST construction
- Error messages with line/column tracking
- Readable C code generation

## Version History

- **0.3.0** - Documentation and polish
- **0.2.0** - File I/O library
- **0.1.0** - Pattern matching and math library
- **0.0.1** - Initial bootstrap compiler

## Upgrade Guide

### From 0.2.0 to 0.3.0
No breaking changes. All existing code continues to work.

### From 0.1.0 to 0.2.0
No breaking changes. File I/O functions are additive.

### From 0.0.1 to 0.1.0
No breaking changes. Pattern matching and math functions are additive.

## Future Versions

### 0.4.0 (Planned)
- Module system
- Import/export statements
- Multi-file programs

### 0.5.0 (Planned)
- Self-hosting compiler (Stage 1)
- Lexer written in Athōn
- Parser written in Athōn

### 1.0.0 (Planned)
- Complete self-hosting
- Capability system
- Stable language specification
- LTS release

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on contributing to Athōn.

## License

See [LICENSE](LICENSE) for license information.
