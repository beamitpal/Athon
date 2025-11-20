# Bootstrap Notes

- The bootstrap compiler is temporary. Once Stage 1 (written in Athōn) is working, this directory will be frozen or removed.
- We use `no_std` Rust to ensure we don't accidentally rely on complex standard library features that are hard to implement in Athōn.
- The target output of this bootstrap compiler is C99, which can then be compiled by GCC/Clang to produce the Stage 1 binary.
