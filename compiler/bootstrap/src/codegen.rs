// Code generation module for Ath??n bootstrap compiler

use crate::ast::*;
use std::process;

// --- Helper Functions ---

fn escape_string_for_c(s: &str) -> String {
    let mut result = String::new();
    for ch in s.chars() {
        match ch {
            '\n' => result.push_str("\\n"),
            '\t' => result.push_str("\\t"),
            '\r' => result.push_str("\\r"),
            '\\' => result.push_str("\\\\"),
            '"' => result.push_str("\\\""),
            '\0' => result.push_str("\\0"),
            _ => result.push(ch),
        }
    }
    result
}

// --- Codegen ---

pub fn emit_c(program: &Program) {
    // Build a set of enum names for type checking
    let enum_names: std::collections::HashSet<String> = program
        .enums
        .iter()
        .map(|e| e.name.clone())
        .collect();
    
    // Build a set of type alias names
    let type_alias_names: std::collections::HashSet<String> = program
        .type_aliases
        .iter()
        .map(|ta| ta.name.clone())
        .collect();
    
    println!("#include <stdio.h>");
    println!("#include <string.h>");
    println!("#include <stdlib.h>");
    println!();
    
    // Emit type aliases as C typedefs
    for type_alias in &program.type_aliases {
        let c_target_type = get_c_type(&type_alias.target_type, &enum_names, &type_alias_names);
        println!("typedef {} {};", c_target_type, type_alias.name);
    }
    if !program.type_aliases.is_empty() {
        println!();
    }

    // Emit math helper functions
    println!("// Math helper functions");
    println!("int __athon_pow(int base, int exp) {{");
    println!("    if (exp < 0) return 0;");
    println!("    int result = 1;");
    println!("    for (int i = 0; i < exp; i++) {{");
    println!("        result *= base;");
    println!("    }}");
    println!("    return result;");
    println!("}}");
    println!();
    println!("int __athon_sqrt(int x) {{");
    println!("    if (x < 0) return 0;");
    println!("    if (x == 0) return 0;");
    println!("    int result = x;");
    println!("    int prev = 0;");
    println!("    while (result != prev) {{");
    println!("        prev = result;");
    println!("        result = (result + x / result) / 2;");
    println!("    }}");
    println!("    return result;");
    println!("}}");
    println!();

    // Emit file I/O helper functions
    println!("// File I/O helper functions");
    println!("char* __athon_file_read(const char* filename) {{");
    println!("    FILE* file = fopen(filename, \"r\");");
    println!("    if (!file) return \"\";");
    println!("    fseek(file, 0, SEEK_END);");
    println!("    long size = ftell(file);");
    println!("    fseek(file, 0, SEEK_SET);");
    println!("    char* buffer = (char*)malloc(size + 1);");
    println!("    if (!buffer) {{ fclose(file); return \"\"; }}");
    println!("    fread(buffer, 1, size, file);");
    println!("    buffer[size] = '\\0';");
    println!("    fclose(file);");
    println!("    return buffer;");
    println!("}}");
    println!();
    println!("int __athon_file_write(const char* filename, const char* content) {{");
    println!("    FILE* file = fopen(filename, \"w\");");
    println!("    if (!file) return 0;");
    println!("    fputs(content, file);");
    println!("    fclose(file);");
    println!("    return 1;");
    println!("}}");
    println!();
    println!("int __athon_file_append(const char* filename, const char* content) {{");
    println!("    FILE* file = fopen(filename, \"a\");");
    println!("    if (!file) return 0;");
    println!("    fputs(content, file);");
    println!("    fclose(file);");
    println!("    return 1;");
    println!("}}");
    println!();
    println!("int __athon_file_exists(const char* filename) {{");
    println!("    FILE* file = fopen(filename, \"r\");");
    println!("    if (file) {{");
    println!("        fclose(file);");
    println!("        return 1;");
    println!("    }}");
    println!("    return 0;");
    println!("}}");
    println!();

    // Emit string helper functions
    println!("// String helper functions");
    println!("char* __athon_substring(const char* str, int start, int length) {{");
    println!("    int str_len = strlen(str);");
    println!("    if (start < 0 || start >= str_len || length <= 0) return \"\";");
    println!("    if (start + length > str_len) length = str_len - start;");
    println!("    char* result = (char*)malloc(length + 1);");
    println!("    if (!result) return \"\";");
    println!("    strncpy(result, str + start, length);");
    println!("    result[length] = '\\0';");
    println!("    return result;");
    println!("}}");
    println!();

    // Emit struct definitions
    for struct_def in &program.structs {
        if struct_def.type_params.is_empty() {
            // Non-generic struct
            println!("struct {} {{", struct_def.name);
            for field in &struct_def.fields {
                let c_type = match field.type_name.as_str() {
                    "int" => "int",
                    "bool" => "int",
                    "string" => "const char*",
                    _ => &field.type_name,
                };
                println!("    {} {};", c_type, field.name);
            }
            println!("}};");
            println!();
        } else {
            // Generic struct - emit as comment for now
            // In a full implementation, we'd track instantiations and generate concrete types
            println!("// Generic struct {} with type parameters: {}", 
                struct_def.name, 
                struct_def.type_params.join(", "));
            println!("// Note: Generic structs require monomorphization at usage sites");
            println!();
        }
    }

    // Emit enum definitions
    for enum_def in &program.enums {
        println!("enum {} {{", enum_def.name);
        for variant in &enum_def.variants {
            println!("    {},", variant);
        }
        println!("}};");
        println!();
    }

    // Emit union type definitions
    for union_type in &program.unions {
        println!("// Union type: {}", union_type.name);
        println!("enum {}_Tag {{", union_type.name);
        for variant in &union_type.variants {
            println!("    {}_Tag_{},", union_type.name, variant.name);
        }
        println!("}};");
        println!();
        
        println!("struct {} {{", union_type.name);
        println!("    enum {}_Tag tag;", union_type.name);
        println!("    union {{");
        for variant in &union_type.variants {
            if let Some(assoc_type) = &variant.associated_type {
                let c_type = get_c_type(assoc_type, &enum_names, &type_alias_names);
                println!("        {} {};", c_type, variant.name.to_lowercase());
            }
        }
        println!("    }} data;");
        println!("}};");
        println!();
    }

    // Emit trait definitions as vtables
    for trait_def in &program.traits {
        println!("// Trait: {}", trait_def.name);
        println!("struct {}_VTable {{", trait_def.name);
        for method in &trait_def.methods {
            let return_type = method.return_type.as_deref().unwrap_or("void");
            let c_return_type = get_c_type(return_type, &enum_names, &type_alias_names);
            print!("    {} (*{})(", c_return_type, method.name);
            for (i, param) in method.params.iter().enumerate() {
                if i > 0 {
                    print!(", ");
                }
                let c_type = get_c_type(&param.type_name, &enum_names, &type_alias_names);
                print!("{}", c_type);
            }
            println!(");");
        }
        println!("}};");
        println!();
    }

    // Emit trait implementations
    for impl_block in &program.impls {
        println!("// Impl {} for {}", impl_block.trait_name, impl_block.type_name);
        
        // Emit each method
        for method in &impl_block.methods {
            emit_function(method, &enum_names, &type_alias_names);
            println!();
        }
        
        // Emit vtable instance
        println!("struct {}_VTable {}_{}_vtable = {{", 
            impl_block.trait_name, 
            impl_block.type_name,
            impl_block.trait_name);
        for method in &impl_block.methods {
            println!("    .{} = {},", method.name, method.name);
        }
        println!("}};");
        println!();
    }

    // Emit all non-main functions
    for func in &program.functions {
        if func.name != "main" {
            if func.type_params.is_empty() {
                // Non-generic function
                emit_function(func, &enum_names, &type_alias_names);
                println!();
            } else {
                // Generic function - emit as comment
                println!("// Generic function {} with type parameters: {}", 
                    func.name, 
                    func.type_params.join(", "));
                println!("// Note: Generic functions require monomorphization at call sites");
                println!();
            }
        }
    }

    // Emit main function last
    for func in &program.functions {
        if func.name == "main" {
            emit_function_as_main(func);
        }
    }
}

fn get_c_type(type_name: &str, enum_names: &std::collections::HashSet<String>, type_alias_names: &std::collections::HashSet<String>) -> String {
    match type_name {
        "int" => "int".to_string(),
        "bool" => "int".to_string(),
        "string" => "const char*".to_string(),
        "void" => "void".to_string(),
        _ => {
            if enum_names.contains(type_name) {
                format!("enum {}", type_name)
            } else if type_alias_names.contains(type_name) {
                // Type alias - use directly (already typedef'd)
                type_name.to_string()
            } else {
                // Struct type
                format!("struct {}", type_name)
            }
        }
    }
}

fn emit_function(func: &Function, enum_names: &std::collections::HashSet<String>, type_alias_names: &std::collections::HashSet<String>) {
    let return_type = func.return_type.as_deref().unwrap_or("void");
    let c_return_type = get_c_type(return_type, enum_names, type_alias_names);

    print!("{} {}(", c_return_type, func.name);

    for (i, param) in func.params.iter().enumerate() {
        if i > 0 {
            print!(", ");
        }
        let c_type = get_c_type(&param.type_name, enum_names, type_alias_names);
        print!("{} {}", c_type, param.name);
    }

    println!(") {{");

    for stmt in &func.body {
        emit_statement(stmt, 1);
    }

    println!("}}");
}

fn emit_function_as_main(func: &Function) {
    println!("int main() {{");

    for stmt in &func.body {
        emit_statement(stmt, 1);
    }

    println!("    return 0;");
    println!("}}");
}

fn emit_statement(stmt: &Statement, indent: usize) {
    let ind = "    ".repeat(indent);
    match stmt {
        Statement::Let { name, value } => {
            // Determine type based on value
            match value {
                Expr::String(_) => {
                    // String literal - use const char*
                    print!("{}const char* {} = ", ind, name);
                    emit_expr(value);
                    println!(";");
                }
                Expr::ArrayLiteral(_) => {
                    // Array - use int[]
                    print!("{}int {}[] = ", ind, name);
                    emit_expr(value);
                    println!(";");
                }
                Expr::StructLiteral { struct_name, .. } => {
                    // Struct literal - use struct type
                    print!("{}struct {} {} = ", ind, struct_name, name);
                    emit_expr(value);
                    println!(";");
                }
                Expr::Call { name: fn_name, .. } if fn_name == "length" => {
                    // strlen returns size_t, but we'll use int for simplicity
                    print!("{}int {} = ", ind, name);
                    emit_expr(value);
                    println!(";");
                }
                Expr::Call { name: fn_name, .. } if fn_name == "file_read" => {
                    // file_read returns char*
                    print!("{}char* {} = ", ind, name);
                    emit_expr(value);
                    println!(";");
                }
                Expr::Call { name: fn_name, .. } if fn_name == "substring" => {
                    // substring returns char*
                    print!("{}char* {} = ", ind, name);
                    emit_expr(value);
                    println!(";");
                }
                _ => {
                    // Default to int for numbers, booleans, expressions
                    print!("{}int {} = ", ind, name);
                    emit_expr(value);
                    println!(";");
                }
            }
        }
        Statement::Assign { name, value } => {
            print!("{}{} = ", ind, name);
            emit_expr(value);
            println!(";");
        }
        Statement::Return { value } => {
            if let Some(expr) = value {
                print!("{}return ", ind);
                emit_expr(expr);
                println!(";");
            } else {
                println!("{}return;", ind);
            }
        }
        Statement::Break => {
            println!("{}break;", ind);
        }
        Statement::Continue => {
            println!("{}continue;", ind);
        }
        Statement::If {
            condition,
            then_block,
            else_block,
        } => {
            print!("{}if (", ind);
            emit_expr(condition);
            println!(") {{");

            for stmt in then_block {
                emit_statement(stmt, indent + 1);
            }

            if let Some(else_stmts) = else_block {
                println!("{}}} else {{", ind);
                for stmt in else_stmts {
                    emit_statement(stmt, indent + 1);
                }
            }

            println!("{}}}", ind);
        }
        Statement::While { condition, body } => {
            print!("{}while (", ind);
            emit_expr(condition);
            println!(") {{");

            for stmt in body {
                emit_statement(stmt, indent + 1);
            }

            println!("{}}}", ind);
        }
        Statement::For {
            loop_var,
            start,
            end,
            body,
        } => {
            // Desugar to C for loop
            print!("{}for (int {} = ", ind, loop_var);
            emit_expr(start);
            print!("; {} < ", loop_var);
            emit_expr(end);
            println!("; {}++) {{", loop_var);

            for stmt in body {
                emit_statement(stmt, indent + 1);
            }

            println!("{}}}", ind);
        }
        Statement::Match { value, arms } => {
            // Generate a temporary variable to hold the match value
            println!("{}{{", ind);
            print!("{}    int __match_val = ", ind);
            emit_expr(value);
            println!(";");

            // Generate if-else chain for pattern matching
            let mut first = true;

            for arm in arms {
                match &arm.pattern {
                    Pattern::Wildcard => {
                        // Wildcard always matches - emit as final else
                        if !first {
                            print!("{}    }} else {{", ind);
                        } else {
                            print!("{}    {{", ind);
                        }
                        println!();
                        for stmt in &arm.body {
                            emit_statement(stmt, indent + 2);
                        }
                    }
                    Pattern::Number(n) => {
                        if first {
                            print!("{}    if (__match_val == {}) {{", ind, n);
                            first = false;
                        } else {
                            print!("{}    }} else if (__match_val == {}) {{", ind, n);
                        }
                        println!();
                        for stmt in &arm.body {
                            emit_statement(stmt, indent + 2);
                        }
                    }
                    Pattern::Boolean(b) => {
                        let val = if *b { 1 } else { 0 };
                        if first {
                            print!("{}    if (__match_val == {}) {{", ind, val);
                            first = false;
                        } else {
                            print!("{}    }} else if (__match_val == {}) {{", ind, val);
                        }
                        println!();
                        for stmt in &arm.body {
                            emit_statement(stmt, indent + 2);
                        }
                    }
                    Pattern::EnumVariant {
                        enum_name: _,
                        variant,
                    } => {
                        if first {
                            print!("{}    if (__match_val == {}) {{", ind, variant);
                            first = false;
                        } else {
                            print!("{}    }} else if (__match_val == {}) {{", ind, variant);
                        }
                        println!();
                        for stmt in &arm.body {
                            emit_statement(stmt, indent + 2);
                        }
                    }
                }
            }

            println!("{}    }}", ind);
            println!("{}}}", ind);
        }
        Statement::Expr(expr) => {
            print!("{}", ind);
            match expr {
                Expr::Call { name, args } if name == "print" => {
                    if args.is_empty() {
                        println!("printf(\"\\n\");");
                    } else if args.len() == 1 {
                        // Single argument - legacy behavior
                        let arg = &args[0];
                        match arg {
                            Expr::String(s) => {
                                println!("printf(\"{}\");", escape_string_for_c(s));
                            }
                            _ => {
                                print!("printf(\"%d\\n\", ");
                                emit_expr(arg);
                                println!(");");
                            }
                        }
                    } else {
                        // Multiple arguments - format string style
                        if let Expr::String(format_str) = &args[0] {
                            // Convert {} to appropriate format specifiers
                            // For now, we'll use %s for strings and %d for numbers
                            // This is a simplification - proper implementation would need type inference
                            let mut c_format = format_str.clone();

                            // Count placeholders
                            let _placeholder_count = format_str.matches("{}").count();

                            // Replace with %d by default (could be improved with type checking)
                            c_format = c_format.replace("{}", "%d");

                            // Escape the format string for C
                            let escaped_format = escape_string_for_c(&c_format);
                            print!("printf(\"{}\"", escaped_format);

                            // Emit remaining arguments
                            for arg in &args[1..] {
                                print!(", ");
                                emit_expr(arg);
                            }
                            println!(");");
                        } else {
                            eprintln!("Error: First argument to print must be a string");
                            process::exit(1);
                        }
                    }
                }
                _ => {
                    emit_expr(expr);
                    println!(";");
                }
            }
        }
    }
}

fn emit_expr(expr: &Expr) {
    match expr {
        Expr::Number(n) => print!("{}", n),
        Expr::Boolean(b) => print!("{}", if *b { 1 } else { 0 }),
        Expr::Char(c) => match c {
            '\n' => print!("'\\n'"),
            '\r' => print!("'\\r'"),
            '\t' => print!("'\\t'"),
            '\\' => print!("'\\\\'"),
            '\'' => print!("'\\''"),
            '\0' => print!("'\\0'"),
            _ => print!("'{}'", c),
        },
        Expr::String(s) => print!("\"{}\"", escape_string_for_c(s)),
        Expr::Variable(name) => print!("{}", name),
        Expr::ArrayLiteral(elements) => {
            print!("{{");
            for (i, elem) in elements.iter().enumerate() {
                if i > 0 {
                    print!(", ");
                }
                emit_expr(elem);
            }
            print!("}}");
        }
        Expr::ArrayIndex { array, index } => {
            emit_expr(array);
            print!("[");
            emit_expr(index);
            print!("]");
        }
        Expr::StructLiteral {
            struct_name,
            fields,
        } => {
            print!("(struct {}) {{", struct_name);
            for (i, (field_name, value)) in fields.iter().enumerate() {
                if i > 0 {
                    print!(", ");
                }
                print!(".{} = ", field_name);
                emit_expr(value);
            }
            print!("}}");
        }
        Expr::MemberAccess { object, member } => {
            emit_expr(object);
            print!(".{}", member);
        }
        Expr::EnumVariant {
            enum_name: _,
            variant,
        } => {
            // In C, just use the variant name
            print!("{}", variant);
        }
        Expr::Binary { left, op, right } => {
            print!("(");
            emit_expr(left);
            let op_str = match op {
                BinOp::Add => " + ",
                BinOp::Sub => " - ",
                BinOp::Mul => " * ",
                BinOp::Div => " / ",
                BinOp::Eq => " == ",
                BinOp::NotEq => " != ",
                BinOp::Lt => " < ",
                BinOp::Gt => " > ",
                BinOp::LtEq => " <= ",
                BinOp::GtEq => " >= ",
                BinOp::And => " && ",
                BinOp::Or => " || ",
            };
            print!("{}", op_str);
            emit_expr(right);
            print!(")");
        }
        Expr::Unary { op, operand } => {
            match op {
                UnaryOp::Not => print!("!"),
                UnaryOp::Neg => print!("-"),
            }
            emit_expr(operand);
        }
        Expr::Call { name, args } => {
            // Handle built-in functions
            match name.as_str() {
                "length" => {
                    // C strlen function
                    print!("strlen(");
                    if let Some(arg) = args.first() {
                        emit_expr(arg);
                    }
                    print!(")");
                }
                "concat" => {
                    // String concatenation using strcat
                    // Note: This is unsafe in real code, needs buffer management
                    print!("strcat(");
                    if args.len() >= 2 {
                        emit_expr(&args[0]);
                        print!(", ");
                        emit_expr(&args[1]);
                    }
                    print!(")");
                }
                "compare" => {
                    // String comparison using strcmp
                    print!("strcmp(");
                    if args.len() >= 2 {
                        emit_expr(&args[0]);
                        print!(", ");
                        emit_expr(&args[1]);
                    }
                    print!(")");
                }
                "array_length" => {
                    // Array length - compile-time only
                    // In C, we use sizeof(arr)/sizeof(arr[0])
                    print!("(sizeof(");
                    if let Some(arg) = args.first() {
                        emit_expr(arg);
                    }
                    print!(") / sizeof((");
                    if let Some(arg) = args.first() {
                        emit_expr(arg);
                    }
                    print!(")[0]))");
                }
                "substring" => {
                    // Extract substring: substring(str, start, length)
                    print!("__athon_substring(");
                    if args.len() >= 3 {
                        emit_expr(&args[0]);
                        print!(", ");
                        emit_expr(&args[1]);
                        print!(", ");
                        emit_expr(&args[2]);
                    }
                    print!(")");
                }
                // Math functions
                "abs" => {
                    print!("abs(");
                    if let Some(arg) = args.first() {
                        emit_expr(arg);
                    }
                    print!(")");
                }
                "min" => {
                    print!("((");
                    if args.len() >= 2 {
                        emit_expr(&args[0]);
                        print!(") < (");
                        emit_expr(&args[1]);
                        print!(") ? (");
                        emit_expr(&args[0]);
                        print!(") : (");
                        emit_expr(&args[1]);
                    }
                    print!("))");
                }
                "max" => {
                    print!("((");
                    if args.len() >= 2 {
                        emit_expr(&args[0]);
                        print!(") > (");
                        emit_expr(&args[1]);
                        print!(") ? (");
                        emit_expr(&args[0]);
                        print!(") : (");
                        emit_expr(&args[1]);
                    }
                    print!("))");
                }
                "pow" => {
                    // Generate inline power calculation
                    print!("__athon_pow(");
                    if args.len() >= 2 {
                        emit_expr(&args[0]);
                        print!(", ");
                        emit_expr(&args[1]);
                    }
                    print!(")");
                }
                "sqrt" => {
                    // Integer square root
                    print!("__athon_sqrt(");
                    if let Some(arg) = args.first() {
                        emit_expr(arg);
                    }
                    print!(")");
                }
                "mod" => {
                    print!("((");
                    if args.len() >= 2 {
                        emit_expr(&args[0]);
                        print!(") % (");
                        emit_expr(&args[1]);
                    }
                    print!("))");
                }
                // File I/O functions
                "file_read" => {
                    print!("__athon_file_read(");
                    if let Some(arg) = args.first() {
                        emit_expr(arg);
                    }
                    print!(")");
                }
                "file_write" => {
                    print!("__athon_file_write(");
                    if args.len() >= 2 {
                        emit_expr(&args[0]);
                        print!(", ");
                        emit_expr(&args[1]);
                    }
                    print!(")");
                }
                "file_append" => {
                    print!("__athon_file_append(");
                    if args.len() >= 2 {
                        emit_expr(&args[0]);
                        print!(", ");
                        emit_expr(&args[1]);
                    }
                    print!(")");
                }
                "file_exists" => {
                    print!("__athon_file_exists(");
                    if let Some(arg) = args.first() {
                        emit_expr(arg);
                    }
                    print!(")");
                }
                _ => {
                    // Regular function call
                    print!("{}(", name);
                    for (i, arg) in args.iter().enumerate() {
                        if i > 0 {
                            print!(", ");
                        }
                        emit_expr(arg);
                    }
                    print!(")");
                }
            }
        }
    }
}
