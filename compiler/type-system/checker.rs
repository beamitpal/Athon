// Type Checker Stub
// Validates capability rules.

struct Context {
    vars: Vec<VarInfo>,
}

struct VarInfo {
    name: String,
    ty: Type,
    state: VarState,
}

enum VarState {
    Alive,
    Moved,
    Consumed,
}

impl Context {
    fn check_move(&mut self, name: &str) -> Result<(), String> {
        let var = self.find_var(name)?;
        if var.state != VarState::Alive {
            return Err(format!("Use of moved value: {}", name));
        }
        var.state = VarState::Moved;
        Ok(())
    }
}

pub fn check_expr(ctx: &mut Context, expr: &Expr) -> Result<Type, String> {
    match expr {
        Expr::Variable(name) => {
            // If type is linear/affine, mark as moved
            ctx.check_move(name)?;
            Ok(ctx.get_type(name))
        }
        // ...
        _ => Ok(Type::Void),
    }
}
