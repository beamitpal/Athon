// Athōn Bootstrap Compiler - CLI Entry Point
// Compiles Athōn source code to C

use athon_bootstrap::{emit_c, Parser};
use std::process;

fn main() {
    // Read source file from command-line argument
    let args: Vec<String> = std::env::args().collect();

    if args.len() < 2 {
        eprintln!("Usage: {} <source.at>", args[0]);
        eprintln!("Example: {} examples/hello.at", args[0]);
        process::exit(1);
    }

    let filename = &args[1];

    let source = match std::fs::read_to_string(filename) {
        Ok(content) => content,
        Err(err) => {
            eprintln!("Error reading file '{}': {}", filename, err);
            process::exit(1);
        }
    };

    // Parse the source code
    let mut parser = Parser::new(&source);
    let program = parser.parse_program();

    // Generate and output C code
    emit_c(&program);
}
