// Athōn Bootstrap Compiler Library
// Stage 0 compiler written in Rust, compiles Athōn to C

pub mod lexer;
pub mod ast;
pub mod parser;
pub mod codegen;

// Re-export main types for convenience
pub use lexer::{Lexer, Token, TokenKind};
pub use ast::{Program, Function, Statement, Expr};
pub use parser::Parser;
pub use codegen::emit_c;
