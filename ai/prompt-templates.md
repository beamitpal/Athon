# AI Prompt Templates

## 1. Spec Draft

"Draft a technical specification for [FEATURE] in Athōn. Focus on capability security and memory safety. Invariants: [LIST]."

## 2. Parser Generator

"Generate a recursive descent parser function in Rust for the following EBNF grammar rule: [RULE]. Use the `Parser` struct stub provided."

## 3. Test Generation

"Given the following function [FUNC], generate 5 edge-case unit tests. Focus on boundary conditions and invalid inputs."

## 4. IR Design

"Propose an IR instruction set for [FEATURE]. Ensure it is deterministic and typed. Output format: Markdown list of ops."

## 5. Codegen Snippet

"Write a Rust function to emit x86_64 machine code for the [OP] instruction. Use the `ElfEmitter` struct."

## 6. Audit Diff

"Analyze the following diff for security vulnerabilities. Look specifically for capability leaks or unchecked array access. Diff: [DIFF]"
