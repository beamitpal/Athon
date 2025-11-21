# Changelog

All notable changes to the Athōn language will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Module system for code organization
- Memory management (ownership system)
- Capability token system
- Full monomorphization for generics
- Advanced trait features (default methods, associated types)

## [0.4.0] - 2025-11-21

### Added - Type System Enhancements
- **Type Aliases** - Semantic naming for types
  - Syntax: `type UserId = int;`
  - C typedef generation
  - Full support in function signatures
- **Type Inference** - Automatic type deduction
  - Literal type inference
  - Expression type inference
  - Array type inference
  - Function return type inference
- **Generics** - Type parameters for functions and structs
  - Syntax: `fn max<T>(a: T, b: T) -> T`
  - Struct generics: `struct Pair<T> { first: T, second: T }`
  - Multiple type parameters supported
  - Monomorphization framework ready
- **Traits** - Interface definitions and polymorphism
  - Trait definitions: `trait Display { fn to_string(self) -> int; }`
  - Trait implementations: `impl Display for Point { ... }`
  - VTable generation for dynamic dispatch
  - Multiple trait implementations per type
- **Union Types** - Tagged unions for type-safe variants
  - Syntax: `type Result = Ok(int) | Err(int);`
  - C tagged union generation
  - Pattern matching support
  - Multiple variants with associated types

### Added - Automation & Tooling
- **Update Scripts** for streamlined development
  - `update.sh` - Full interactive update with verification
  - `quick-update.sh` - Fast silent update (5-10 seconds)
  - `dev-update.sh` - Development workflow with automatic testing
  - `check-install.sh` - Installation status checker
- **Documentation**
  - `UPDATE_SCRIPTS.md` - Complete automation guide

### Added - Examples
- 14 new type system examples
  - `type_aliases.at`, `type_aliases_real.at`
  - `type_inference.at`, `type_inference_enhanced.at`
  - `generics_basic.at`, `generics_working.at`, `test_generics_simple.at`
  - `traits_basic.at`, `traits_working.at`, `test_traits_simple.at`
  - `union_types.at`, `union_types_working.at`, `test_union_simple.at`
  - `type_system_showcase.at` - Demonstrates all features

### Changed
- **Compiler** - Enhanced with modern type system
  - Updated AST with type system nodes
  - Enhanced parser with generic syntax support
  - Improved codegen with vtable and tagged union generation
  - Fixed format string escaping bug in print statements
- **Test Scripts** - Improved reliability
  - Added library file detection (skip `*_lib.at` files)
  - Fixed CLI test script to use updated binaries
  - All 3 test suites now passing (50/50 tests)

### Fixed
- Format string escaping in multi-argument print statements
- Type alias resolution in function parameters
- Union type detection with smart lookahead
- Library file handling in test scripts

### Performance
- Fast compilation maintained (no LLVM overhead)
- Efficient C code generation
- Small binary sizes
- 100% test pass rate across all test suites

### Documentation
- Updated `athon-spec/roadmap.md` - All type system features marked complete
- Cleaned up redundant status files
- Consolidated documentation

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
