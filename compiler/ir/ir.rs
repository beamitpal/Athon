// Athōn Intermediate Representation (AIR)
// SSA-based typed IR for optimization and code generation

/// IR Module - top-level container
#[derive(Debug, Clone)]
pub struct Module {
    pub name: String,
    pub functions: Vec<Function>,
    pub structs: Vec<StructDef>,
    pub enums: Vec<EnumDef>,
}

/// Function definition in IR
#[derive(Debug, Clone)]
pub struct Function {
    pub name: String,
    pub params: Vec<(String, Type)>,
    pub return_type: Type,
    pub blocks: Vec<BasicBlock>,
}

/// Basic block - sequence of instructions with single entry/exit
#[derive(Debug, Clone)]
pub struct BasicBlock {
    pub label: String,
    pub instructions: Vec<Instruction>,
    pub terminator: Terminator,
}

/// IR Instructions
#[derive(Debug, Clone)]
pub enum Instruction {
    /// Allocate local variable: %dest = alloc type
    Alloc { dest: Register, ty: Type },
    
    /// Load value: %dest = load %ptr
    Load { dest: Register, ptr: Register },
    
    /// Store value: store %ptr, %val
    Store { ptr: Register, value: Register },
    
    /// Binary operation: %dest = binop %left, %right
    BinOp {
        dest: Register,
        op: BinOp,
        left: Register,
        right: Register,
    },
    
    /// Unary operation: %dest = unop %operand
    UnaryOp {
        dest: Register,
        op: UnaryOp,
        operand: Register,
    },
    
    /// Function call: %dest = call @func(%args...)
    Call {
        dest: Option<Register>,
        func: String,
        args: Vec<Register>,
    },
    
    /// Constant integer: %dest = const_int value
    ConstInt { dest: Register, value: i32 },
    
    /// Constant boolean: %dest = const_bool value
    ConstBool { dest: Register, value: bool },
    
    /// Constant string: %dest = const_string value
    ConstString { dest: Register, value: String },
    
    /// Array allocation: %dest = array_alloc size
    ArrayAlloc { dest: Register, size: usize },
    
    /// Array store: array_store %array, %index, %value
    ArrayStore {
        array: Register,
        index: Register,
        value: Register,
    },
    
    /// Array load: %dest = array_load %array, %index
    ArrayLoad {
        dest: Register,
        array: Register,
        index: Register,
    },
    
    /// Struct allocation: %dest = struct_alloc struct_name
    StructAlloc { dest: Register, struct_name: String },
    
    /// Struct field store: struct_store %struct, field_name, %value
    StructStore {
        struct_reg: Register,
        field: String,
        value: Register,
    },
    
    /// Struct field load: %dest = struct_load %struct, field_name
    StructLoad {
        dest: Register,
        struct_reg: Register,
        field: String,
    },
    
    /// Phi node for SSA: %dest = phi [%val1, label1], [%val2, label2]
    Phi {
        dest: Register,
        incoming: Vec<(Register, String)>,
    },
}

/// Control flow terminators (end of basic block)
#[derive(Debug, Clone)]
pub enum Terminator {
    /// Unconditional branch: br label
    Branch { target: String },
    
    /// Conditional branch: condbr %cond, true_label, false_label
    CondBranch {
        condition: Register,
        true_label: String,
        false_label: String,
    },
    
    /// Return: ret %value or ret void
    Return { value: Option<Register> },
}

/// Register (SSA value)
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub struct Register {
    pub name: String,
    pub id: usize,
}

impl Register {
    pub fn new(name: &str, id: usize) -> Self {
        Register {
            name: name.to_string(),
            id,
        }
    }
    
    pub fn to_string(&self) -> String {
        format!("%{}.{}", self.name, self.id)
    }
}

/// Type system
#[derive(Debug, Clone, PartialEq)]
pub enum Type {
    Void,
    Int,
    Bool,
    String,
    Array(Box<Type>, usize),
    Struct(String),
    Enum(String),
    Ptr(Box<Type>),
}

/// Binary operators
#[derive(Debug, Clone, Copy)]
pub enum BinOp {
    Add,
    Sub,
    Mul,
    Div,
    Eq,
    NotEq,
    Lt,
    Gt,
    LtEq,
    GtEq,
    And,
    Or,
}

/// Unary operators
#[derive(Debug, Clone, Copy)]
pub enum UnaryOp {
    Not,
    Neg,
}

/// Struct definition
#[derive(Debug, Clone)]
pub struct StructDef {
    pub name: String,
    pub fields: Vec<(String, Type)>,
}

/// Enum definition
#[derive(Debug, Clone)]
pub struct EnumDef {
    pub name: String,
    pub variants: Vec<String>,
}

impl Module {
    pub fn new(name: String) -> Self {
        Module {
            name,
            functions: Vec::new(),
            structs: Vec::new(),
            enums: Vec::new(),
        }
    }
}

impl Function {
    pub fn new(name: String, params: Vec<(String, Type)>, return_type: Type) -> Self {
        Function {
            name,
            params,
            return_type,
            blocks: Vec::new(),
        }
    }
}

impl BasicBlock {
    pub fn new(label: String) -> Self {
        BasicBlock {
            label,
            instructions: Vec::new(),
            terminator: Terminator::Return { value: None },
        }
    }
}
