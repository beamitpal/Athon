# Roadmap

## Year 0-1: Bootstrap & Core

- **Goal**: Self-hosting compiler.
- ✅ Implement minimal bootstrap compiler in Rust
- ✅ Define core language features (variables, functions, control flow)
- ✅ Implement data structures (arrays, structs, enums)
- ✅ Add pattern matching
- ✅ Create standard library (math, file I/O, strings)
- ✅ Achieve comprehensive example coverage (31 programs)
- ✅ Complete documentation (language guide, API reference)
- 🔄 Define core IR and type checker (in progress)
- ⏳ Implement basic `std/core`
- ⏳ Achieve "Hello World" self-hosted

### Current Status (Bootstrap Phase)
**Completed:**
- Bootstrap compiler fully functional
- All core language features implemented
- Pattern matching with exhaustive checking
- Math library (6 functions)
- File I/O library (4 functions)
- String operations
- 31 working examples
- Complete documentation suite
- 100% test pass rate

**Next Steps:**
- Begin self-hosting implementation
- Define intermediate representation (IR)
- Implement type checker
- Start writing compiler components in Athōn

## Year 1-3: Stabilization & Ecosystem

- **Goal**: Production-ready for embedded use.
- ⏳ Complete the capability system implementation
- ⏳ Implement module system
- ⏳ Audit and freeze the standard library
- ⏳ Develop formal verification tools for the IR
- ⏳ First LTS release (v1.0)

### Planned Features
- Module system for code organization
- Capability tokens for security
- Memory regions and ownership
- Generic types
- Trait system
- Option and Result types
- Enhanced error handling

## Year 3-6: Expansion & Tooling

- **Goal**: High-assurance tooling.
- ⏳ Integrated theorem prover
- ⏳ IDE support (LSP) built into the monorepo
- ⏳ Support for more hardware architectures (RISC-V, ARM64)
- ⏳ Formal verification integration
- ⏳ Proof-carrying code

## Year 6-10: Ossification

- **Goal**: Perfect stability.
- ⏳ Slow down feature rate to near zero
- ⏳ Focus entirely on optimization, verification, and maintenance
- ⏳ The language specification becomes immutable
- ⏳ Long-term support and security updates only

## Legend
- ✅ Completed
- 🔄 In Progress
- ⏳ Planned
- ❌ Blocked/Deferred
