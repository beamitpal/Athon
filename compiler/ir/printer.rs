// IR Printer - Pretty prints AIR in textual format

use crate::ir::{Module, Function, BasicBlock, Instruction, Terminator, Register, Type, BinOp, UnaryOp};

/// Print entire module
pub fn print_module(module: &Module) -> String {
    let mut output = String::new();
    
    output.push_str(&format!("module {}\n\n", module.name));
    
    // Print struct definitions
    for struct_def in &module.structs {
        output.push_str(&format!("struct {} {{\n", struct_def.name));
        for (field_name, field_type) in &struct_def.fields {
            output.push_str(&format!("  {}: {},\n", field_name, print_type(field_type)));
        }
        output.push_str("}\n\n");
    }
    
    // Print enum definitions
    for enum_def in &module.enums {
        output.push_str(&format!("enum {} {{\n", enum_def.name));
        for variant in &enum_def.variants {
            output.push_str(&format!("  {},\n", variant));
        }
        output.push_str("}\n\n");
    }
    
    // Print functions
    for func in &module.functions {
        output.push_str(&print_function(func));
        output.push_str("\n");
    }
    
    output
}

/// Print function
fn print_function(func: &Function) -> String {
    let mut output = String::new();
    
    // Function signature
    output.push_str(&format!("fn @{}(", func.name));
    for (i, (param_name, param_type)) in func.params.iter().enumerate() {
        if i > 0 {
            output.push_str(", ");
        }
        output.push_str(&format!("%{}: {}", param_name, print_type(param_type)));
    }
    output.push_str(&format!(") -> {} {{\n", print_type(&func.return_type)));
    
    // Basic blocks
    for block in &func.blocks {
        output.push_str(&print_block(block));
    }
    
    output.push_str("}\n");
    output
}

/// Print basic block
fn print_block(block: &BasicBlock) -> String {
    let mut output = String::new();
    
    output.push_str(&format!("{}:\n", block.label));
    
    // Instructions
    for inst in &block.instructions {
        output.push_str("  ");
        output.push_str(&print_instruction(inst));
        output.push_str("\n");
    }
    
    // Terminator
    output.push_str("  ");
    output.push_str(&print_terminator(&block.terminator));
    output.push_str("\n");
    
    output
}

/// Print instruction
fn print_instruction(inst: &Instruction) -> String {
    match inst {
        Instruction::Alloc { dest, ty } => {
            format!("{} = alloc {}", print_register(dest), print_type(ty))
        }
        Instruction::Load { dest, ptr } => {
            format!("{} = load {}", print_register(dest), print_register(ptr))
        }
        Instruction::Store { ptr, value } => {
            format!("store {}, {}", print_register(ptr), print_register(value))
        }
        Instruction::BinOp { dest, op, left, right } => {
            format!(
                "{} = {} {}, {}",
                print_register(dest),
                print_binop(op),
                print_register(left),
                print_register(right)
            )
        }
        Instruction::UnaryOp { dest, op, operand } => {
            format!(
                "{} = {} {}",
                print_register(dest),
                print_unaryop(op),
                print_register(operand)
            )
        }
        Instruction::Call { dest, func, args } => {
            let args_str = args
                .iter()
                .map(print_register)
                .collect::<Vec<_>>()
                .join(", ");
            
            if let Some(d) = dest {
                format!("{} = call @{}({})", print_register(d), func, args_str)
            } else {
                format!("call @{}({})", func, args_str)
            }
        }
        Instruction::ConstInt { dest, value } => {
            format!("{} = const_int {}", print_register(dest), value)
        }
        Instruction::ConstBool { dest, value } => {
            format!("{} = const_bool {}", print_register(dest), value)
        }
        Instruction::ConstString { dest, value } => {
            format!("{} = const_string \"{}\"", print_register(dest), value)
        }
        Instruction::ArrayAlloc { dest, size } => {
            format!("{} = array_alloc {}", print_register(dest), size)
        }
        Instruction::ArrayStore { array, index, value } => {
            format!(
                "array_store {}, {}, {}",
                print_register(array),
                print_register(index),
                print_register(value)
            )
        }
        Instruction::ArrayLoad { dest, array, index } => {
            format!(
                "{} = array_load {}, {}",
                print_register(dest),
                print_register(array),
                print_register(index)
            )
        }
        Instruction::StructAlloc { dest, struct_name } => {
            format!("{} = struct_alloc {}", print_register(dest), struct_name)
        }
        Instruction::StructStore { struct_reg, field, value } => {
            format!(
                "struct_store {}, {}, {}",
                print_register(struct_reg),
                field,
                print_register(value)
            )
        }
        Instruction::StructLoad { dest, struct_reg, field } => {
            format!(
                "{} = struct_load {}, {}",
                print_register(dest),
                print_register(struct_reg),
                field
            )
        }
        Instruction::Phi { dest, incoming } => {
            let incoming_str = incoming
                .iter()
                .map(|(reg, label)| format!("[{}, {}]", print_register(reg), label))
                .collect::<Vec<_>>()
                .join(", ");
            format!("{} = phi {}", print_register(dest), incoming_str)
        }
    }
}

/// Print terminator
fn print_terminator(term: &Terminator) -> String {
    match term {
        Terminator::Branch { target } => {
            format!("br {}", target)
        }
        Terminator::CondBranch { condition, true_label, false_label } => {
            format!(
                "condbr {}, {}, {}",
                print_register(condition),
                true_label,
                false_label
            )
        }
        Terminator::Return { value } => {
            if let Some(v) = value {
                format!("ret {}", print_register(v))
            } else {
                "ret void".to_string()
            }
        }
    }
}

/// Print register
fn print_register(reg: &Register) -> String {
    reg.to_string()
}

/// Print type
fn print_type(ty: &Type) -> String {
    match ty {
        Type::Void => "void".to_string(),
        Type::Int => "int".to_string(),
        Type::Bool => "bool".to_string(),
        Type::String => "string".to_string(),
        Type::Array(elem_ty, size) => format!("[{}; {}]", print_type(elem_ty), size),
        Type::Struct(name) => format!("struct {}", name),
        Type::Enum(name) => format!("enum {}", name),
        Type::Ptr(ty) => format!("ptr<{}>", print_type(ty)),
    }
}

/// Print binary operator
fn print_binop(op: &BinOp) -> &'static str {
    match op {
        BinOp::Add => "add",
        BinOp::Sub => "sub",
        BinOp::Mul => "mul",
        BinOp::Div => "div",
        BinOp::Eq => "eq",
        BinOp::NotEq => "neq",
        BinOp::Lt => "lt",
        BinOp::Gt => "gt",
        BinOp::LtEq => "lte",
        BinOp::GtEq => "gte",
        BinOp::And => "and",
        BinOp::Or => "or",
    }
}

/// Print unary operator
fn print_unaryop(op: &UnaryOp) -> &'static str {
    match op {
        UnaryOp::Not => "not",
        UnaryOp::Neg => "neg",
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::ir::{Module, Function, BasicBlock, Instruction, Terminator, Register, Type};
    
    #[test]
    fn test_print_simple_function() {
        let mut module = Module::new("test".to_string());
        
        let mut func = Function::new("main".to_string(), vec![], Type::Void);
        let mut block = BasicBlock::new("entry".to_string());
        
        let r1 = Register::new("x", 0);
        block.instructions.push(Instruction::ConstInt {
            dest: r1.clone(),
            value: 42,
        });
        
        block.terminator = Terminator::Return { value: None };
        func.blocks.push(block);
        module.functions.push(func);
        
        let output = print_module(&module);
        assert!(output.contains("module test"));
        assert!(output.contains("fn @main"));
        assert!(output.contains("const_int 42"));
    }
}
