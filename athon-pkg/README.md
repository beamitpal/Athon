# Athōn Package Manager

Sovereign package manager with zero external dependencies.

## Target: 2026-2027

## Goals

- Zero dependencies (no npm, cargo, pip)
- Capability-based permissions for packages
- Cryptographic verification of all packages
- Reproducible builds
- Air-gapped operation support

## Architecture

```
athon-pkg install <package>
    ↓
Fetch from registry (or local cache)
    ↓
Verify cryptographic signature
    ↓
Check capability requirements
    ↓
Build from source (reproducible)
    ↓
Install with granted capabilities
```

## Package Format

```athon
// package.at
package "my-app" {
    version: "1.0.0",
    author: "developer@example.com",
    
    // Required capabilities
    capabilities: [
        FileRead("/data"),
        NetworkSend("api.example.com"),
    ],
    
    // Dependencies
    dependencies: [
        "std-collections" version "0.4.0",
        "crypto" version "2.1.0",
    ],
    
    // Build configuration
    build: {
        target: "riscv64",
        optimize: true,
    },
}
```

## Features

- **Capability Declaration**: Packages declare required capabilities
- **Signature Verification**: All packages cryptographically signed
- **Reproducible Builds**: Bit-identical builds from source
- **Offline Mode**: Work without internet connection
- **Version Pinning**: Lock file for reproducibility

## Commands

```bash
athon-pkg init              # Initialize new package
athon-pkg install <pkg>     # Install package
athon-pkg build             # Build current package
athon-pkg publish           # Publish to registry
athon-pkg verify <pkg>      # Verify package signature
athon-pkg audit             # Audit capabilities
```

## Registry

- Decentralized registry (no single point of failure)
- Content-addressed storage
- Cryptographic verification
- Capability metadata

## Status

- [ ] Package format specification
- [ ] Signature verification
- [ ] Dependency resolution
- [ ] Build system integration
- [ ] Registry protocol
- [ ] CLI tool

## Next Steps

1. Define package format
2. Implement signature verification
3. Build dependency resolver
4. Create registry protocol
5. Develop CLI tool
