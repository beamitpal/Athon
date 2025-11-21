// Athōn Bootstrap Compiler Library
// Stage 0 compiler written in Rust, compiles Athōn to C

pub mod ast;
pub mod codegen;
pub mod lexer;
pub mod parser;

// Re-export main types for convenience
pub use ast::{Expr, Function, Program, Statement};
pub use codegen::emit_c;
pub use lexer::{Lexer, Token, TokenKind};
pub use parser::Parser;
