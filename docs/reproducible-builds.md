# Why Reproducible Builds Matter

If you cannot reproduce the binary from the source code, you cannot trust the binary. A compromised compiler could insert a backdoor into every program it compiles (the "Reflections on Trusting Trust" attack).

Athōn mitigates this by enforcing deterministic builds. Anyone, anywhere, can download the source, build it, and verify that their output bit-for-bit matches the official release. This allows for distributed auditing of the build process.
