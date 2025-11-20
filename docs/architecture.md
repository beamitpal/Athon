# Architecture

The Athōn compiler follows a traditional pipeline but with strict separation of concerns:

1. **Frontend**: Parses source into AST.
2. **Type Checker**: Enforces capability and region rules. This is the most critical component for security.
3. **IR Gen**: Lowers AST to AIR (Athōn IR).
4. **Optimization**: Performs deterministic optimizations on AIR.
5. **Backend**: Lowers AIR to machine code (ELF generation).

The entire pipeline is designed to be library-ified, but currently lives in the monorepo as a single build unit to ensure version consistency.
