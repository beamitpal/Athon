# WebAssembly 64-bit Backend

Generate WebAssembly for running Athōn in browsers.

## Target: Q4 2026 (Oct - Dec 2026)

## Goals

- Athōn → WASM64 compilation
- Run Aurora Engine in any browser
- No JavaScript required
- Full capability security in browser

## Architecture

```
Athōn IR → WASM Module → Browser
```

## Files (To Be Created)

- `codegen.rs` - WASM code generator
- `module.rs` - WASM module builder
- `types.rs` - WASM type mapping
- `imports.rs` - Browser API bindings

## WASM Features

- Memory64 - 64-bit addressing
- Threads - Multi-threading support
- SIMD - Vector operations
- Reference types - GC integration

## Browser Integration

- WebGPU for rendering
- WebSockets for networking
- IndexedDB for storage
- Web Workers for threads

## Capability Mapping

Map Athōn capabilities to browser permissions:
- File access → File System Access API
- Network → Fetch API / WebSockets
- GPU → WebGPU
- Storage → IndexedDB

## Status

- [ ] Basic WASM generation
- [ ] Memory management
- [ ] Function calls
- [ ] Browser API bindings
- [ ] WebGPU integration
- [ ] Capability security

## Next Steps

1. Implement WASM module builder
2. Add type mapping
3. Generate function exports
4. Test in browser
5. Integrate with Aurora Engine
