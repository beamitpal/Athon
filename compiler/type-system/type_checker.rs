// Type Checker for Athōn
// Validates types, checks capability safety, and ensures correctness

use std::collections::HashMap;

/// Type information
#[derive(Debug, Clone, PartialEq)]
pub enum Type {
    Void,
    Int,
    Bool,
    String,
    Array(Box<Type>),
    Struct(String),
    Enum(String),
    Unknown,
}

/// Variable state for linear/affine type checking
#[derive(Debug, Clone, PartialEq)]
pub enum VarState {
    Alive,
    Moved,
    Consumed,
}

/// Variable information in context
#[derive(Debug, Clone)]
pub struct VarInfo {
    pub name: String,
    pub ty: Type,
    pub state: VarState,
    pub is_linear: bool,
}

/// Type checking context
pub struct TypeContext {
    vars: HashMap<String, VarInfo>,
    functions: HashMap<String, FunctionSignature>,
    structs: HashMap<String, StructInfo>,
    enums: HashMap<String, EnumInfo>,
}

#[derive(Debug, Clone)]
pub struct FunctionSignature {
    pub params: Vec<(String, Type)>,
    pub return_type: Type,
}

#[derive(Debug, Clone)]
pub struct StructInfo {
    pub fields: HashMap<String, Type>,
}

#[derive(Debug, Clone)]
pub struct EnumInfo {
    pub variants: Vec<String>,
}

impl TypeContext {
    pub fn new() -> Self {
        TypeContext {
            vars: HashMap::new(),
            functions: HashMap::new(),
            structs: HashMap::new(),
            enums: HashMap::new(),
        }
    }
    
    /// Add a variable to the context
    pub fn add_var(&mut self, name: String, ty: Type, is_linear: bool) {
        self.vars.insert(
            name.clone(),
            VarInfo {
                name,
                ty,
                state: VarState::Alive,
                is_linear,
            },
        );
    }
    
    /// Get variable type
    pub fn get_var_type(&self, name: &str) -> Result<Type, String> {
        self.vars
            .get(name)
            .map(|v| v.ty.clone())
            .ok_or_else(|| format!("Undefined variable: {}", name))
    }
    
    /// Check if variable can be used (not moved)
    pub fn check_var_use(&mut self, name: &str) -> Result<(), String> {
        let var = self.vars.get_mut(name)
            .ok_or_else(|| format!("Undefined variable: {}", name))?;
        
        match var.state {
            VarState::Alive => {
                if var.is_linear {
                    var.state = VarState::Moved;
                }
                Ok(())
            }
            VarState::Moved => Err(format!("Use of moved value: {}", name)),
            VarState::Consumed => Err(format!("Use of consumed value: {}", name)),
        }
    }
    
    /// Add a function signature
    pub fn add_function(&mut self, name: String, params: Vec<(String, Type)>, return_type: Type) {
        self.functions.insert(
            name,
            FunctionSignature {
                params,
                return_type,
            },
        );
    }
    
    /// Get function signature
    pub fn get_function(&self, name: &str) -> Result<&FunctionSignature, String> {
        self.functions
            .get(name)
            .ok_or_else(|| format!("Undefined function: {}", name))
    }
    
    /// Add struct definition
    pub fn add_struct(&mut self, name: String, fields: Vec<(String, Type)>) {
        let field_map: HashMap<String, Type> = fields.into_iter().collect();
        self.structs.insert(name, StructInfo { fields: field_map });
    }
    
    /// Get struct field type
    pub fn get_struct_field(&self, struct_name: &str, field: &str) -> Result<Type, String> {
        let struct_info = self.structs
            .get(struct_name)
            .ok_or_else(|| format!("Undefined struct: {}", struct_name))?;
        
        struct_info.fields
            .get(field)
            .cloned()
            .ok_or_else(|| format!("Struct {} has no field {}", struct_name, field))
    }
    
    /// Add enum definition
    pub fn add_enum(&mut self, name: String, variants: Vec<String>) {
        self.enums.insert(name, EnumInfo { variants });
    }
    
    /// Check if enum variant exists
    pub fn check_enum_variant(&self, enum_name: &str, variant: &str) -> Result<(), String> {
        let enum_info = self.enums
            .get(enum_name)
            .ok_or_else(|| format!("Undefined enum: {}", enum_name))?;
        
        if enum_info.variants.contains(&variant.to_string()) {
            Ok(())
        } else {
            Err(format!("Enum {} has no variant {}", enum_name, variant))
        }
    }
}

/// Type checker
pub struct TypeChecker {
    context: TypeContext,
}

impl TypeChecker {
    pub fn new() -> Self {
        TypeChecker {
            context: TypeContext::new(),
        }
    }
    
    /// Get the context (for testing/inspection)
    pub fn context(&self) -> &TypeContext {
        &self.context
    }
    
    /// Get mutable context
    pub fn context_mut(&mut self) -> &mut TypeContext {
        &mut self.context
    }
    
    /// Check binary operation type
    pub fn check_binop(&self, op: &str, left: &Type, right: &Type) -> Result<Type, String> {
        match op {
            "+" | "-" | "*" | "/" => {
                if *left == Type::Int && *right == Type::Int {
                    Ok(Type::Int)
                } else {
                    Err(format!("Arithmetic operation requires int operands, got {:?} and {:?}", left, right))
                }
            }
            "==" | "!=" | "<" | ">" | "<=" | ">=" => {
                if left == right {
                    Ok(Type::Bool)
                } else {
                    Err(format!("Comparison requires same types, got {:?} and {:?}", left, right))
                }
            }
            "&&" | "||" => {
                if *left == Type::Bool && *right == Type::Bool {
                    Ok(Type::Bool)
                } else {
                    Err(format!("Logical operation requires bool operands, got {:?} and {:?}", left, right))
                }
            }
            _ => Err(format!("Unknown binary operator: {}", op)),
        }
    }
    
    /// Check unary operation type
    pub fn check_unary(&self, op: &str, operand: &Type) -> Result<Type, String> {
        match op {
            "!" => {
                if *operand == Type::Bool {
                    Ok(Type::Bool)
                } else {
                    Err(format!("Logical NOT requires bool operand, got {:?}", operand))
                }
            }
            "-" => {
                if *operand == Type::Int {
                    Ok(Type::Int)
                } else {
                    Err(format!("Negation requires int operand, got {:?}", operand))
                }
            }
            _ => Err(format!("Unknown unary operator: {}", op)),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    
    #[test]
    fn test_var_context() {
        let mut ctx = TypeContext::new();
        ctx.add_var("x".to_string(), Type::Int, false);
        
        assert_eq!(ctx.get_var_type("x").unwrap(), Type::Int);
        assert!(ctx.check_var_use("x").is_ok());
    }
    
    #[test]
    fn test_linear_var() {
        let mut ctx = TypeContext::new();
        ctx.add_var("cap".to_string(), Type::Int, true);
        
        assert!(ctx.check_var_use("cap").is_ok());
        assert!(ctx.check_var_use("cap").is_err()); // Second use should fail
    }
    
    #[test]
    fn test_binop_types() {
        let checker = TypeChecker::new();
        
        assert_eq!(checker.check_binop("+", &Type::Int, &Type::Int).unwrap(), Type::Int);
        assert_eq!(checker.check_binop("==", &Type::Int, &Type::Int).unwrap(), Type::Bool);
        assert!(checker.check_binop("+", &Type::Int, &Type::Bool).is_err());
    }
}
