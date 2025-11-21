// IR Generator - Converts AST to AIR (Athōn IR)

use crate::ir::{
    Module, Function, BasicBlock, Instruction, Terminator, Register, Type, BinOp, UnaryOp,
    StructDef, EnumDef,
};
use std::collections::HashMap;

/// IR Generator state
pub struct IRGenerator {
    module: Module,
    current_function: Option<Function>,
    current_block: Option<BasicBlock>,
    register_counter: usize,
    label_counter: usize,
    var_registers: HashMap<String, Register>,
}

impl IRGenerator {
    pub fn new(module_name: String) -> Self {
        IRGenerator {
            module: Module::new(module_name),
            current_function: None,
            current_block: None,
            register_counter: 0,
            label_counter: 0,
            var_registers: HashMap::new(),
        }
    }
    
    /// Generate a fresh register
    fn fresh_register(&mut self, name: &str) -> Register {
        let id = self.register_counter;
        self.register_counter += 1;
        Register::new(name, id)
    }
    
    /// Generate a fresh label
    fn fresh_label(&mut self, prefix: &str) -> String {
        let id = self.label_counter;
        self.label_counter += 1;
        format!("{}{}", prefix, id)
    }
    
    /// Add instruction to current block
    fn emit(&mut self, inst: Instruction) {
        if let Some(ref mut block) = self.current_block {
            block.instructions.push(inst);
        }
    }
    
    /// Set terminator for current block
    fn set_terminator(&mut self, term: Terminator) {
        if let Some(ref mut block) = self.current_block {
            block.terminator = term;
        }
    }
    
    /// Finish current block and add to function
    fn finish_block(&mut self) {
        if let Some(block) = self.current_block.take() {
            if let Some(ref mut func) = self.current_function {
                func.blocks.push(block);
            }
        }
    }
    
    /// Start a new basic block
    fn start_block(&mut self, label: String) {
        self.finish_block();
        self.current_block = Some(BasicBlock::new(label));
    }
    
    /// Convert type name to IR type
    fn convert_type(&self, type_name: &str) -> Type {
        match type_name {
            "int" => Type::Int,
            "bool" => Type::Bool,
            "string" => Type::String,
            "void" => Type::Void,
            _ => {
                // Check if it's a struct or enum
                if self.module.structs.iter().any(|s| s.name == type_name) {
                    Type::Struct(type_name.to_string())
                } else if self.module.enums.iter().any(|e| e.name == type_name) {
                    Type::Enum(type_name.to_string())
                } else {
                    Type::Void // Default fallback
                }
            }
        }
    }
    
    /// Generate IR for a constant integer
    pub fn gen_const_int(&mut self, value: i32) -> Register {
        let reg = self.fresh_register("const");
        self.emit(Instruction::ConstInt {
            dest: reg.clone(),
            value,
        });
        reg
    }
    
    /// Generate IR for a constant boolean
    pub fn gen_const_bool(&mut self, value: bool) -> Register {
        let reg = self.fresh_register("const");
        self.emit(Instruction::ConstBool {
            dest: reg.clone(),
            value,
        });
        reg
    }
    
    /// Generate IR for a constant string
    pub fn gen_const_string(&mut self, value: String) -> Register {
        let reg = self.fresh_register("str");
        self.emit(Instruction::ConstString {
            dest: reg.clone(),
            value,
        });
        reg
    }
    
    /// Generate IR for a variable reference
    pub fn gen_variable(&mut self, name: &str) -> Result<Register, String> {
        self.var_registers
            .get(name)
            .cloned()
            .ok_or_else(|| format!("Undefined variable: {}", name))
    }
    
    /// Generate IR for binary operation
    pub fn gen_binop(&mut self, op: BinOp, left: Register, right: Register) -> Register {
        let dest = self.fresh_register("binop");
        self.emit(Instruction::BinOp {
            dest: dest.clone(),
            op,
            left,
            right,
        });
        dest
    }
    
    /// Generate IR for unary operation
    pub fn gen_unary(&mut self, op: UnaryOp, operand: Register) -> Register {
        let dest = self.fresh_register("unary");
        self.emit(Instruction::UnaryOp {
            dest: dest.clone(),
            op,
            operand,
        });
        dest
    }
    
    /// Generate IR for function call
    pub fn gen_call(&mut self, func_name: String, args: Vec<Register>, has_return: bool) -> Option<Register> {
        let dest = if has_return {
            Some(self.fresh_register("call"))
        } else {
            None
        };
        
        self.emit(Instruction::Call {
            dest: dest.clone(),
            func: func_name,
            args,
        });
        
        dest
    }
    
    /// Generate IR for variable assignment
    pub fn gen_assign(&mut self, name: String, value: Register) {
        self.var_registers.insert(name, value);
    }
    
    /// Generate IR for conditional branch
    pub fn gen_cond_branch(&mut self, condition: Register, true_label: String, false_label: String) {
        self.set_terminator(Terminator::CondBranch {
            condition,
            true_label,
            false_label,
        });
    }
    
    /// Generate IR for unconditional branch
    pub fn gen_branch(&mut self, target: String) {
        self.set_terminator(Terminator::Branch { target });
    }
    
    /// Generate IR for return statement
    pub fn gen_return(&mut self, value: Option<Register>) {
        self.set_terminator(Terminator::Return { value });
    }
    
    /// Generate IR for array allocation
    pub fn gen_array_alloc(&mut self, size: usize) -> Register {
        let dest = self.fresh_register("array");
        self.emit(Instruction::ArrayAlloc {
            dest: dest.clone(),
            size,
        });
        dest
    }
    
    /// Generate IR for array load
    pub fn gen_array_load(&mut self, array: Register, index: Register) -> Register {
        let dest = self.fresh_register("elem");
        self.emit(Instruction::ArrayLoad {
            dest: dest.clone(),
            array,
            index,
        });
        dest
    }
    
    /// Generate IR for array store
    pub fn gen_array_store(&mut self, array: Register, index: Register, value: Register) {
        self.emit(Instruction::ArrayStore {
            array,
            index,
            value,
        });
    }
    
    /// Generate IR for struct allocation
    pub fn gen_struct_alloc(&mut self, struct_name: String) -> Register {
        let dest = self.fresh_register("struct");
        self.emit(Instruction::StructAlloc {
            dest: dest.clone(),
            struct_name,
        });
        dest
    }
    
    /// Generate IR for struct field load
    pub fn gen_struct_load(&mut self, struct_reg: Register, field: String) -> Register {
        let dest = self.fresh_register("field");
        self.emit(Instruction::StructLoad {
            dest: dest.clone(),
            struct_reg,
            field,
        });
        dest
    }
    
    /// Generate IR for struct field store
    pub fn gen_struct_store(&mut self, struct_reg: Register, field: String, value: Register) {
        self.emit(Instruction::StructStore {
            struct_reg,
            field,
            value,
        });
    }
    
    /// Start a new function
    pub fn start_function(&mut self, name: String, params: Vec<(String, Type)>, return_type: Type) {
        // Finish previous function if any
        self.finish_function();
        
        self.current_function = Some(Function::new(name, params.clone(), return_type));
        self.var_registers.clear();
        self.register_counter = 0;
        self.label_counter = 0;
        
        // Start entry block
        self.start_block("entry".to_string());
        
        // Create registers for parameters
        for (param_name, _) in params {
            let reg = self.fresh_register(&param_name);
            self.var_registers.insert(param_name, reg);
        }
    }
    
    /// Finish current function and add to module
    pub fn finish_function(&mut self) {
        self.finish_block();
        
        if let Some(func) = self.current_function.take() {
            self.module.functions.push(func);
        }
    }
    
    /// Add struct definition to module
    pub fn add_struct(&mut self, name: String, fields: Vec<(String, Type)>) {
        self.module.structs.push(StructDef { name, fields });
    }
    
    /// Add enum definition to module
    pub fn add_enum(&mut self, name: String, variants: Vec<String>) {
        self.module.enums.push(EnumDef { name, variants });
    }
    
    /// Get the generated module
    pub fn finish(mut self) -> Module {
        self.finish_function();
        self.module
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    
    #[test]
    fn test_const_generation() {
        let mut gen = IRGenerator::new("test".to_string());
        gen.start_function("main".to_string(), vec![], Type::Void);
        
        let r1 = gen.gen_const_int(42);
        let r2 = gen.gen_const_bool(true);
        
        assert_eq!(r1.name, "const");
        assert_eq!(r2.name, "const");
    }
    
    #[test]
    fn test_binop_generation() {
        let mut gen = IRGenerator::new("test".to_string());
        gen.start_function("main".to_string(), vec![], Type::Void);
        
        let r1 = gen.gen_const_int(10);
        let r2 = gen.gen_const_int(20);
        let r3 = gen.gen_binop(BinOp::Add, r1, r2);
        
        assert_eq!(r3.name, "binop");
    }
}
