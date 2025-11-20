# Reproducible Builds

## Principles

1. **Determinism**: Given the same source and build environment, the output binary must be bit-for-bit identical.
2. **Hermeticity**: The build process must not access the network or undeclared file system paths.
3. **Bootstrap**: The compiler must be able to compile itself, and the resulting binary must match the previous iteration (after stabilization).

## Verification Steps

To verify a build:

1. **Environment Setup**:
   Ensure you are in a POSIX-compliant environment with the exact toolchain version specified in `compiler/bootstrap/README.md`.

2. **Double-Build**:
   Run the verification script:

   ```sh
   ./ci/repro_build.sh
   ```

   This script will:

   - Build the compiler (Stage 1).
   - Use Stage 1 to build the compiler again (Stage 2).
   - Compare the hashes of Stage 1 and Stage 2 binaries.

3. **Provenance**:
   Release artifacts include a `provenance.json` file signed by maintainers, detailing the git commit, tree hash, and build environment environment variables.

## Metadata Format Example

```json
{
  "artifact": "athon-compiler-v0.1.0",
  "sha256": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
  "git_commit": "a1b2c3d4...",
  "build_timestamp": "2024-01-01T00:00:00Z",
  "builder_id": "maintainer-key-id"
}
```
