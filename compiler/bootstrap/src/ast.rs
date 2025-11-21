// AST (Abstract Syntax Tree) definitions for Athōn bootstrap compiler

#[derive(Debug, Clone)]
pub enum Expr {
    Number(i32),
    Boolean(bool),
    Char(char),
    String(String),
    Variable(String),
    ArrayLiteral(Vec<Expr>),
    ArrayIndex {
        array: Box<Expr>,
        index: Box<Expr>,
    },
    StructLiteral {
        struct_name: String,
        fields: Vec<(String, Expr)>,
    },
    MemberAccess {
        object: Box<Expr>,
        member: String,
    },
    EnumVariant {
        enum_name: String,
        variant: String,
    },
    Binary {
        left: Box<Expr>,
        op: BinOp,
        right: Box<Expr>,
    },
    Unary {
        op: UnaryOp,
        operand: Box<Expr>,
    },
    Call {
        name: String,
        args: Vec<Expr>,
    },
}

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

#[derive(Debug, Clone, Copy)]
pub enum UnaryOp {
    Not,
    Neg,
}

#[derive(Debug, Clone)]
pub enum Pattern {
    Wildcard,
    Number(i32),
    Boolean(bool),
    EnumVariant { enum_name: String, variant: String },
}

#[derive(Debug)]
pub struct MatchArm {
    pub pattern: Pattern,
    pub body: Vec<Statement>,
}

#[derive(Debug)]
pub enum Statement {
    Let {
        name: String,
        value: Expr,
    },
    Assign {
        name: String,
        value: Expr,
    },
    If {
        condition: Expr,
        then_block: Vec<Statement>,
        else_block: Option<Vec<Statement>>,
    },
    While {
        condition: Expr,
        body: Vec<Statement>,
    },
    For {
        loop_var: String,
        start: Expr,
        end: Expr,
        body: Vec<Statement>,
    },
    Match {
        value: Expr,
        arms: Vec<MatchArm>,
    },
    Return {
        value: Option<Expr>,
    },
    Break,
    Continue,
    Expr(Expr),
}

#[derive(Debug, Clone)]
pub struct Parameter {
    pub name: String,
    pub type_name: String,
}

#[derive(Debug)]
pub struct Function {
    pub name: String,
    pub type_params: Vec<String>, // Generic type parameters: <T, U>
    pub params: Vec<Parameter>,
    pub return_type: Option<String>,
    pub body: Vec<Statement>,
}

#[derive(Debug, Clone)]
pub struct StructField {
    pub name: String,
    pub type_name: String,
}

#[derive(Debug)]
pub struct StructDef {
    pub name: String,
    pub type_params: Vec<String>, // Generic type parameters: <T>
    pub fields: Vec<StructField>,
}

#[derive(Debug)]
pub struct EnumDef {
    pub name: String,
    pub variants: Vec<String>,
}

#[derive(Debug, Clone)]
pub struct TypeAlias {
    pub name: String,
    pub target_type: String,
}

// Trait definition
#[derive(Debug)]
pub struct TraitDef {
    pub name: String,
    pub methods: Vec<TraitMethod>,
}

#[derive(Debug)]
pub struct TraitMethod {
    pub name: String,
    pub params: Vec<Parameter>,
    pub return_type: Option<String>,
}

// Trait implementation
#[derive(Debug)]
pub struct TraitImpl {
    pub trait_name: String,
    pub type_name: String,
    pub methods: Vec<Function>,
}

// Union type variant
#[derive(Debug, Clone)]
pub struct UnionVariant {
    pub name: String,
    pub associated_type: Option<String>, // Some(T) has associated type, None doesn't
}

// Union type definition
#[derive(Debug)]
pub struct UnionType {
    pub name: String,
    pub variants: Vec<UnionVariant>,
}

#[derive(Debug)]
pub struct Program {
    pub type_aliases: Vec<TypeAlias>,
    pub structs: Vec<StructDef>,
    pub enums: Vec<EnumDef>,
    pub unions: Vec<UnionType>,
    pub traits: Vec<TraitDef>,
    pub impls: Vec<TraitImpl>,
    pub functions: Vec<Function>,
}
