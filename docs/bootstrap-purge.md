# The Bootstrap Purge

Currently, we rely on a Stage 0 bootstrap compiler written in Rust. This is a temporary evil.

Our goal is to reach a point where the Athōn compiler (written in Athōn) can compile itself. Once this "self-hosting" loop is closed and verified, we will remove the Rust bootstrap compiler from the repository.

Future versions will be built using the previous version's binary, forming an unbroken chain of trust back to the original audited source.
