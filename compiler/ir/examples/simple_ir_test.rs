// Example: Simple IR generation test
// Demonstrates generating IR for a basic function

use std::path::PathBuf;

// Mock IR types for standalone example
mod ir {
    pub use super::super::super::ir::*;
}

fn main() {
    println!("=== Athōn IR Generation Example ===\n");
    
    // Create IR generator
    let mut gen = ir::IRGenerator::new("example".to_string());
    
    // Example 1: Simple arithmetic function
    // fn add(a: int, b: int) -> int {
    //     return a + b;
    // }
    println!("Example 1: Simple arithmetic function");
    gen.start_function(
        "add".to_string(),
        vec![
            ("a".to_string(), ir::Type::Int),
            ("b".to_string(), ir::Type::Int),
        ],
        ir::Type::Int,
    );
    
    let a_reg = gen.gen_variable("a").unwrap();
    let b_reg = gen.gen_variable("b").unwrap();
    let result = gen.gen_binop(ir::BinOp::Add, a_reg, b_reg);
    gen.gen_return(Some(result));
    
    // Example 2: Conditional function
    // fn max(x: int, y: int) -> int {
    //     if x > y {
    //         return x;
    //     } else {
    //         return y;
    //     }
    // }
    println!("\nExample 2: Conditional function");
    gen.start_function(
        "max".to_string(),
        vec![
            ("x".to_string(), ir::Type::Int),
            ("y".to_string(), ir::Type::Int),
        ],
        ir::Type::Int,
    );
    
    let x_reg = gen.gen_variable("x").unwrap();
    let y_reg = gen.gen_variable("y").unwrap();
    let cond = gen.gen_binop(ir::BinOp::Gt, x_reg.clone(), y_reg.clone());
    
    gen.gen_cond_branch(cond, "then".to_string(), "else".to_string());
    
    gen.start_block("then".to_string());
    gen.gen_return(Some(x_reg));
    
    gen.start_block("else".to_string());
    gen.gen_return(Some(y_reg));
    
    // Example 3: Function with constants
    // fn answer() -> int {
    //     return 42;
    // }
    println!("\nExample 3: Function with constants");
    gen.start_function("answer".to_string(), vec![], ir::Type::Int);
    
    let const_reg = gen.gen_const_int(42);
    gen.gen_return(Some(const_reg));
    
    // Get the module and print it
    let module = gen.finish();
    let ir_text = ir::print_module(&module);
    
    println!("\n=== Generated IR ===\n");
    println!("{}", ir_text);
    
    println!("\n=== IR Generation Complete ===");
}
