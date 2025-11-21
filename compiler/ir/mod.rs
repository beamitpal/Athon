// IR module - Athōn Intermediate Representation

pub mod ir;
pub mod ir_gen;
pub mod printer;

pub use ir::*;
pub use ir_gen::IRGenerator;
pub use printer::print_module;
