// Parser module for Athōn bootstrap compiler

use crate::ast::*;
use crate::lexer::{Lexer, Token, TokenKind};
use std::process;

pub struct Parser {
    lexer: Lexer,
    current: Token,
}
impl Parser {
    pub fn new(input: &str) -> Self {
        let mut lexer = Lexer::new(input);
        let current = lexer.next_token();
        Self { lexer, current }
    }

    fn advance(&mut self) {
        self.current = self.lexer.next_token();
    }

    fn expect(&mut self, kind: TokenKind) -> bool {
        if self.current.kind == kind {
            self.advance();
            true
        } else {
            false
        }
    }

    pub fn parse_program(&mut self) -> Program {
        let mut structs = Vec::new();
        let mut enums = Vec::new();
        let mut functions = Vec::new();

        while self.current.kind != TokenKind::EOF {
            if self.current.kind == TokenKind::Struct {
                structs.push(self.parse_struct());
            } else if self.current.kind == TokenKind::Enum {
                enums.push(self.parse_enum());
            } else if self.current.kind == TokenKind::Fn {
                functions.push(self.parse_function());
            } else {
                eprintln!(
                    "Error at line {}, column {}: Expected 'struct', 'enum', or 'fn'",
                    self.current.line, self.current.column
                );
                process::exit(1);
            }
        }

        Program {
            structs,
            enums,
            functions,
        }
    }

    fn parse_enum(&mut self) -> EnumDef {
        if !self.expect(TokenKind::Enum) {
            eprintln!(
                "Error at line {}, column {}: Expected 'enum'",
                self.current.line, self.current.column
            );
            process::exit(1);
        }

        let name = if self.current.kind == TokenKind::Identifier {
            let n = self.current.text.clone();
            self.advance();
            n
        } else {
            eprintln!(
                "Error at line {}, column {}: Expected enum name",
                self.current.line, self.current.column
            );
            process::exit(1);
        };

        if !self.expect(TokenKind::LBrace) {
            eprintln!(
                "Error at line {}, column {}: Expected '{{'",
                self.current.line, self.current.column
            );
            process::exit(1);
        }

        let mut variants = Vec::new();
        while self.current.kind != TokenKind::RBrace && self.current.kind != TokenKind::EOF {
            let variant_name = if self.current.kind == TokenKind::Identifier {
                let n = self.current.text.clone();
                self.advance();
                n
            } else {
                eprintln!(
                    "Error at line {}, column {}: Expected variant name",
                    self.current.line, self.current.column
                );
                process::exit(1);
            };

            variants.push(variant_name);

            if !self.expect(TokenKind::Comma) {
                break;
            }
        }

        if !self.expect(TokenKind::RBrace) {
            eprintln!(
                "Error at line {}, column {}: Expected '}}'",
                self.current.line, self.current.column
            );
            process::exit(1);
        }

        EnumDef { name, variants }
    }

    fn parse_struct(&mut self) -> StructDef {
        if !self.expect(TokenKind::Struct) {
            eprintln!(
                "Error at line {}, column {}: Expected 'struct'",
                self.current.line, self.current.column
            );
            process::exit(1);
        }

        let name = if self.current.kind == TokenKind::Identifier {
            let n = self.current.text.clone();
            self.advance();
            n
        } else {
            eprintln!(
                "Error at line {}, column {}: Expected struct name",
                self.current.line, self.current.column
            );
            process::exit(1);
        };

        if !self.expect(TokenKind::LBrace) {
            eprintln!(
                "Error at line {}, column {}: Expected '{{'",
                self.current.line, self.current.column
            );
            process::exit(1);
        }

        let mut fields = Vec::new();
        while self.current.kind != TokenKind::RBrace && self.current.kind != TokenKind::EOF {
            let field_name = if self.current.kind == TokenKind::Identifier {
                let n = self.current.text.clone();
                self.advance();
                n
            } else {
                eprintln!(
                    "Error at line {}, column {}: Expected field name",
                    self.current.line, self.current.column
                );
                process::exit(1);
            };

            if !self.expect(TokenKind::Colon) {
                eprintln!(
                    "Error at line {}, column {}: Expected ':' after field name",
                    self.current.line, self.current.column
                );
                process::exit(1);
            }

            let type_name = if self.current.kind == TokenKind::Identifier {
                let t = self.current.text.clone();
                self.advance();
                t
            } else {
                eprintln!(
                    "Error at line {}, column {}: Expected type",
                    self.current.line, self.current.column
                );
                process::exit(1);
            };

            fields.push(StructField {
                name: field_name,
                type_name,
            });

            if !self.expect(TokenKind::Comma) {
                break;
            }
        }

        if !self.expect(TokenKind::RBrace) {
            eprintln!(
                "Error at line {}, column {}: Expected '}}'",
                self.current.line, self.current.column
            );
            process::exit(1);
        }

        StructDef { name, fields }
    }

    fn parse_function(&mut self) -> Function {
        if !self.expect(TokenKind::Fn) {
            eprintln!(
                "Error at line {}, column {}: Expected 'fn'",
                self.current.line, self.current.column
            );
            process::exit(1);
        }

        let name = if self.current.kind == TokenKind::Identifier {
            let n = self.current.text.clone();
            self.advance();
            n
        } else {
            eprintln!(
                "Error at line {}, column {}: Expected function name",
                self.current.line, self.current.column
            );
            process::exit(1);
        };

        if !self.expect(TokenKind::LParen) {
            eprintln!("Expected '('");
            process::exit(1);
        }

        // Parse parameters
        let mut params = Vec::new();
        if self.current.kind != TokenKind::RParen {
            loop {
                let param_name = if self.current.kind == TokenKind::Identifier {
                    let n = self.current.text.clone();
                    self.advance();
                    n
                } else {
                    eprintln!("Expected parameter name");
                    process::exit(1);
                };

                if !self.expect(TokenKind::Colon) {
                    eprintln!("Expected ':' after parameter name");
                    process::exit(1);
                }

                let type_name = if self.current.kind == TokenKind::Identifier {
                    let t = self.current.text.clone();
                    self.advance();
                    t
                } else {
                    eprintln!("Expected type after ':'");
                    process::exit(1);
                };

                params.push(Parameter {
                    name: param_name,
                    type_name,
                });

                if !self.expect(TokenKind::Comma) {
                    break;
                }
            }
        }

        if !self.expect(TokenKind::RParen) {
            eprintln!("Expected ')'");
            process::exit(1);
        }

        // Parse optional return type
        let return_type = if self.current.kind == TokenKind::Arrow {
            self.advance();
            if self.current.kind == TokenKind::Identifier {
                let t = self.current.text.clone();
                self.advance();
                Some(t)
            } else {
                eprintln!("Expected return type after '->'");
                process::exit(1);
            }
        } else {
            None
        };

        if !self.expect(TokenKind::LBrace) {
            eprintln!("Expected '{{'");
            process::exit(1);
        }

        let mut statements = Vec::new();

        while self.current.kind != TokenKind::RBrace && self.current.kind != TokenKind::EOF {
            statements.push(self.parse_statement());
        }

        if !self.expect(TokenKind::RBrace) {
            eprintln!("Expected '}}'");
            process::exit(1);
        }

        Function {
            name,
            params,
            return_type,
            body: statements,
        }
    }

    fn parse_statement(&mut self) -> Statement {
        if self.current.kind == TokenKind::Let {
            self.advance();

            let name = if self.current.kind == TokenKind::Identifier {
                let n = self.current.text.clone();
                self.advance();
                n
            } else {
                eprintln!("Expected identifier after 'let'");
                process::exit(1);
            };

            if !self.expect(TokenKind::Equals) {
                eprintln!("Expected '=' after let binding");
                process::exit(1);
            }

            let value = self.parse_expr();

            if !self.expect(TokenKind::Semicolon) {
                eprintln!("Expected ';' after let statement");
                process::exit(1);
            }

            Statement::Let { name, value }
        } else if self.current.kind == TokenKind::Return {
            self.advance();

            let value = if self.current.kind != TokenKind::Semicolon {
                Some(self.parse_expr())
            } else {
                None
            };

            if !self.expect(TokenKind::Semicolon) {
                eprintln!("Expected ';' after return statement");
                process::exit(1);
            }

            Statement::Return { value }
        } else if self.current.kind == TokenKind::If {
            self.advance();

            let condition = self.parse_expr();

            if !self.expect(TokenKind::LBrace) {
                eprintln!("Expected '{{' after if condition");
                process::exit(1);
            }

            let mut then_block = Vec::new();
            while self.current.kind != TokenKind::RBrace && self.current.kind != TokenKind::EOF {
                then_block.push(self.parse_statement());
            }

            if !self.expect(TokenKind::RBrace) {
                eprintln!("Expected '}}' after if block");
                process::exit(1);
            }

            let else_block = if self.current.kind == TokenKind::Else {
                self.advance();

                if !self.expect(TokenKind::LBrace) {
                    eprintln!("Expected '{{' after else");
                    process::exit(1);
                }

                let mut else_stmts = Vec::new();
                while self.current.kind != TokenKind::RBrace && self.current.kind != TokenKind::EOF
                {
                    else_stmts.push(self.parse_statement());
                }

                if !self.expect(TokenKind::RBrace) {
                    eprintln!("Expected '}}' after else block");
                    process::exit(1);
                }

                Some(else_stmts)
            } else {
                None
            };

            Statement::If {
                condition,
                then_block,
                else_block,
            }
        } else if self.current.kind == TokenKind::While {
            self.advance();

            let condition = self.parse_expr();

            if !self.expect(TokenKind::LBrace) {
                eprintln!("Expected '{{' after while condition");
                process::exit(1);
            }

            let mut body = Vec::new();
            while self.current.kind != TokenKind::RBrace && self.current.kind != TokenKind::EOF {
                body.push(self.parse_statement());
            }

            if !self.expect(TokenKind::RBrace) {
                eprintln!("Expected '}}' after while block");
                process::exit(1);
            }

            Statement::While { condition, body }
        } else if self.current.kind == TokenKind::For {
            // Parse for loop
            self.advance();

            let loop_var = if self.current.kind == TokenKind::Identifier {
                let v = self.current.text.clone();
                self.advance();
                v
            } else {
                eprintln!("Expected loop variable after 'for'");
                process::exit(1);
            };

            if !self.expect(TokenKind::In) {
                eprintln!("Expected 'in' after loop variable");
                process::exit(1);
            }

            // Parse range start
            let start = self.parse_additive();

            if !self.expect(TokenKind::DotDot) {
                eprintln!("Expected '..' in range");
                process::exit(1);
            }

            // Parse range end
            let end = self.parse_additive();

            if !self.expect(TokenKind::LBrace) {
                eprintln!("Expected '{{' after for range");
                process::exit(1);
            }

            let mut body = Vec::new();
            while self.current.kind != TokenKind::RBrace && self.current.kind != TokenKind::EOF {
                body.push(self.parse_statement());
            }

            if !self.expect(TokenKind::RBrace) {
                eprintln!("Expected '}}' after for block");
                process::exit(1);
            }

            Statement::For {
                loop_var,
                start,
                end,
                body,
            }
        } else if self.current.kind == TokenKind::Match {
            // Parse match statement
            self.advance();

            let value = self.parse_expr();

            if !self.expect(TokenKind::LBrace) {
                eprintln!(
                    "Error at line {}, column {}: Expected '{{' after match value",
                    self.current.line, self.current.column
                );
                process::exit(1);
            }

            let mut arms = Vec::new();

            while self.current.kind != TokenKind::RBrace && self.current.kind != TokenKind::EOF {
                let pattern = self.parse_pattern();

                if !self.expect(TokenKind::FatArrow) {
                    eprintln!(
                        "Error at line {}, column {}: Expected '=>' after pattern",
                        self.current.line, self.current.column
                    );
                    process::exit(1);
                }

                // Parse arm body - can be a single expression or a block
                let mut body = Vec::new();

                if self.current.kind == TokenKind::LBrace {
                    // Block body
                    self.advance();
                    while self.current.kind != TokenKind::RBrace
                        && self.current.kind != TokenKind::EOF
                    {
                        body.push(self.parse_statement());
                    }
                    if !self.expect(TokenKind::RBrace) {
                        eprintln!(
                            "Error at line {}, column {}: Expected '}}' after match arm block",
                            self.current.line, self.current.column
                        );
                        process::exit(1);
                    }
                } else {
                    // Single expression/statement - check if it's an assignment or expression
                    // This allows expressions without semicolons in match arms
                    if self.current.kind == TokenKind::Identifier {
                        let name = self.current.text.clone();
                        let saved_pos = self.lexer.pos;
                        let saved_line = self.lexer.line;
                        let saved_column = self.lexer.column;
                        let saved_current = self.current.clone();

                        self.advance();

                        if self.current.kind == TokenKind::Equals {
                            // It's an assignment
                            self.advance();
                            let value = self.parse_expr();
                            body.push(Statement::Assign { name, value });
                        } else {
                            // Not an assignment, restore and parse as expression
                            self.lexer.pos = saved_pos;
                            self.lexer.line = saved_line;
                            self.lexer.column = saved_column;
                            self.current = saved_current;

                            let expr = self.parse_expr();
                            body.push(Statement::Expr(expr));
                        }
                    } else {
                        // Not an identifier, must be an expression
                        let expr = self.parse_expr();
                        body.push(Statement::Expr(expr));
                    }
                }

                arms.push(MatchArm { pattern, body });

                // Require comma after arm (unless it's the last one before })
                if self.current.kind != TokenKind::RBrace {
                    if !self.expect(TokenKind::Comma) {
                        eprintln!(
                            "Error at line {}, column {}: Expected ',' after match arm",
                            self.current.line, self.current.column
                        );
                        process::exit(1);
                    }
                } else {
                    // Optional comma before closing brace
                    self.expect(TokenKind::Comma);
                }
            }

            if !self.expect(TokenKind::RBrace) {
                eprintln!(
                    "Error at line {}, column {}: Expected '}}' after match arms",
                    self.current.line, self.current.column
                );
                process::exit(1);
            }

            Statement::Match { value, arms }
        } else if self.current.kind == TokenKind::Identifier {
            // Could be assignment or expression
            let name = self.current.text.clone();
            self.advance();

            if self.current.kind == TokenKind::Equals {
                // Assignment
                self.advance();
                let value = self.parse_expr();

                if !self.expect(TokenKind::Semicolon) {
                    eprintln!("Expected ';' after assignment");
                    process::exit(1);
                }

                Statement::Assign { name, value }
            } else if self.current.kind == TokenKind::LParen {
                // Function call
                self.advance();
                let mut args = Vec::new();

                if self.current.kind != TokenKind::RParen {
                    args.push(self.parse_expr());
                    while self.expect(TokenKind::Comma) {
                        args.push(self.parse_expr());
                    }
                }

                if !self.expect(TokenKind::RParen) {
                    eprintln!("Expected ')' in function call");
                    process::exit(1);
                }

                if self.current.kind == TokenKind::Semicolon {
                    self.advance();
                }

                Statement::Expr(Expr::Call { name, args })
            } else {
                eprintln!("Unexpected token after identifier");
                process::exit(1);
            }
        } else {
            let expr = self.parse_expr();
            if self.current.kind == TokenKind::Semicolon {
                self.advance();
            }
            Statement::Expr(expr)
        }
    }

    fn parse_pattern(&mut self) -> Pattern {
        match self.current.kind {
            TokenKind::Underscore => {
                self.advance();
                Pattern::Wildcard
            }
            TokenKind::Number => {
                let num: i32 = self.current.text.parse().unwrap_or(0);
                self.advance();
                Pattern::Number(num)
            }
            TokenKind::True => {
                self.advance();
                Pattern::Boolean(true)
            }
            TokenKind::False => {
                self.advance();
                Pattern::Boolean(false)
            }
            TokenKind::Identifier => {
                let name = self.current.text.clone();
                self.advance();

                if self.current.kind == TokenKind::DoubleColon {
                    // Enum variant pattern: Color::Red
                    self.advance();

                    let variant = if self.current.kind == TokenKind::Identifier {
                        let v = self.current.text.clone();
                        self.advance();
                        v
                    } else {
                        eprintln!(
                            "Error at line {}, column {}: Expected variant name after '::'",
                            self.current.line, self.current.column
                        );
                        process::exit(1);
                    };

                    Pattern::EnumVariant {
                        enum_name: name,
                        variant,
                    }
                } else {
                    eprintln!(
                        "Error at line {}, column {}: Invalid pattern, expected enum variant",
                        self.current.line, self.current.column
                    );
                    process::exit(1);
                }
            }
            _ => {
                eprintln!(
                    "Error at line {}, column {}: Expected pattern",
                    self.current.line, self.current.column
                );
                process::exit(1);
            }
        }
    }

    fn parse_expr(&mut self) -> Expr {
        self.parse_logical_or()
    }

    fn parse_logical_or(&mut self) -> Expr {
        let mut left = self.parse_logical_and();

        while self.current.kind == TokenKind::Or {
            self.advance();
            let right = self.parse_logical_and();
            left = Expr::Binary {
                left: Box::new(left),
                op: BinOp::Or,
                right: Box::new(right),
            };
        }

        left
    }

    fn parse_logical_and(&mut self) -> Expr {
        let mut left = self.parse_comparison();

        while self.current.kind == TokenKind::And {
            self.advance();
            let right = self.parse_comparison();
            left = Expr::Binary {
                left: Box::new(left),
                op: BinOp::And,
                right: Box::new(right),
            };
        }

        left
    }

    fn parse_comparison(&mut self) -> Expr {
        let mut left = self.parse_additive();

        while matches!(
            self.current.kind,
            TokenKind::EqualsEquals
                | TokenKind::NotEquals
                | TokenKind::LessThan
                | TokenKind::GreaterThan
                | TokenKind::LessEquals
                | TokenKind::GreaterEquals
        ) {
            let op = match self.current.kind {
                TokenKind::EqualsEquals => BinOp::Eq,
                TokenKind::NotEquals => BinOp::NotEq,
                TokenKind::LessThan => BinOp::Lt,
                TokenKind::GreaterThan => BinOp::Gt,
                TokenKind::LessEquals => BinOp::LtEq,
                TokenKind::GreaterEquals => BinOp::GtEq,
                _ => unreachable!(),
            };
            self.advance();
            let right = self.parse_additive();
            left = Expr::Binary {
                left: Box::new(left),
                op,
                right: Box::new(right),
            };
        }

        left
    }

    fn parse_additive(&mut self) -> Expr {
        let mut left = self.parse_multiplicative();

        while matches!(self.current.kind, TokenKind::Plus | TokenKind::Minus) {
            let op = match self.current.kind {
                TokenKind::Plus => BinOp::Add,
                TokenKind::Minus => BinOp::Sub,
                _ => unreachable!(),
            };
            self.advance();
            let right = self.parse_multiplicative();
            left = Expr::Binary {
                left: Box::new(left),
                op,
                right: Box::new(right),
            };
        }

        left
    }

    fn parse_multiplicative(&mut self) -> Expr {
        let mut left = self.parse_unary();

        while matches!(self.current.kind, TokenKind::Star | TokenKind::Slash) {
            let op = match self.current.kind {
                TokenKind::Star => BinOp::Mul,
                TokenKind::Slash => BinOp::Div,
                _ => unreachable!(),
            };
            self.advance();
            let right = self.parse_unary();
            left = Expr::Binary {
                left: Box::new(left),
                op,
                right: Box::new(right),
            };
        }

        left
    }

    fn parse_unary(&mut self) -> Expr {
        if self.current.kind == TokenKind::Not {
            self.advance();
            let operand = self.parse_unary();
            return Expr::Unary {
                op: UnaryOp::Not,
                operand: Box::new(operand),
            };
        }

        if self.current.kind == TokenKind::Minus {
            self.advance();
            let operand = self.parse_unary();
            return Expr::Unary {
                op: UnaryOp::Neg,
                operand: Box::new(operand),
            };
        }

        self.parse_primary()
    }

    fn parse_primary(&mut self) -> Expr {
        match self.current.kind {
            TokenKind::Number => {
                let num: i32 = self.current.text.parse().unwrap_or(0);
                self.advance();
                Expr::Number(num)
            }
            TokenKind::True => {
                self.advance();
                Expr::Boolean(true)
            }
            TokenKind::False => {
                self.advance();
                Expr::Boolean(false)
            }
            TokenKind::StringLiteral => {
                let s = self.current.text.clone();
                self.advance();
                Expr::String(s)
            }
            TokenKind::Identifier => {
                let name = self.current.text.clone();
                self.advance();

                if self.current.kind == TokenKind::DoubleColon {
                    // Enum variant: Color::Red
                    self.advance();

                    let variant = if self.current.kind == TokenKind::Identifier {
                        let v = self.current.text.clone();
                        self.advance();
                        v
                    } else {
                        eprintln!("Expected variant name after '::'");
                        process::exit(1);
                    };

                    Expr::EnumVariant {
                        enum_name: name,
                        variant,
                    }
                } else if self.current.kind == TokenKind::LParen {
                    // Function call
                    self.advance();
                    let mut args = Vec::new();

                    if self.current.kind != TokenKind::RParen {
                        args.push(self.parse_expr());
                        while self.expect(TokenKind::Comma) {
                            args.push(self.parse_expr());
                        }
                    }

                    if !self.expect(TokenKind::RParen) {
                        eprintln!("Expected ')' in function call");
                        process::exit(1);
                    }

                    Expr::Call { name, args }
                } else if self.current.kind == TokenKind::LBracket {
                    // Array indexing
                    self.advance();
                    let index = self.parse_expr();

                    if !self.expect(TokenKind::RBracket) {
                        eprintln!("Expected ']' in array index");
                        process::exit(1);
                    }

                    Expr::ArrayIndex {
                        array: Box::new(Expr::Variable(name)),
                        index: Box::new(index),
                    }
                } else if self.current.kind == TokenKind::LBrace {
                    // Might be struct literal: Point { x: 10, y: 20 }
                    // But only if it looks like field assignments inside
                    // Check if the next token is an identifier followed by ':'
                    // to distinguish from match arms or other block constructs

                    // Peek ahead to see if this looks like a struct literal
                    let saved_pos = self.lexer.pos;
                    let saved_line = self.lexer.line;
                    let saved_column = self.lexer.column;
                    let saved_current = self.current.clone();

                    self.advance(); // consume '{'
                    let looks_like_struct = if self.current.kind == TokenKind::Identifier {
                        let saved_pos2 = self.lexer.pos;
                        let saved_line2 = self.lexer.line;
                        let saved_column2 = self.lexer.column;
                        let saved_current2 = self.current.clone();

                        self.advance(); // consume identifier
                        let has_colon = self.current.kind == TokenKind::Colon;

                        // Restore position
                        self.lexer.pos = saved_pos2;
                        self.lexer.line = saved_line2;
                        self.lexer.column = saved_column2;
                        self.current = saved_current2;

                        has_colon
                    } else {
                        false
                    };

                    if looks_like_struct {
                        // Parse as struct literal
                        let mut fields = Vec::new();

                        while self.current.kind != TokenKind::RBrace
                            && self.current.kind != TokenKind::EOF
                        {
                            let field_name = if self.current.kind == TokenKind::Identifier {
                                let n = self.current.text.clone();
                                self.advance();
                                n
                            } else {
                                eprintln!("Expected field name in struct literal");
                                process::exit(1);
                            };

                            if !self.expect(TokenKind::Colon) {
                                eprintln!("Expected ':' after field name");
                                process::exit(1);
                            }

                            let value = self.parse_expr();
                            fields.push((field_name, value));

                            if !self.expect(TokenKind::Comma) {
                                break;
                            }
                        }

                        if !self.expect(TokenKind::RBrace) {
                            eprintln!("Expected '}}' in struct literal");
                            process::exit(1);
                        }

                        Expr::StructLiteral {
                            struct_name: name,
                            fields,
                        }
                    } else {
                        // Not a struct literal, restore position and return just the variable
                        self.lexer.pos = saved_pos;
                        self.lexer.line = saved_line;
                        self.lexer.column = saved_column;
                        self.current = saved_current;

                        Expr::Variable(name)
                    }
                } else if self.current.kind == TokenKind::Dot {
                    // Member access: p.x
                    let mut expr = Expr::Variable(name);

                    while self.current.kind == TokenKind::Dot {
                        self.advance();

                        let member = if self.current.kind == TokenKind::Identifier {
                            let m = self.current.text.clone();
                            self.advance();
                            m
                        } else {
                            eprintln!("Expected member name after '.'");
                            process::exit(1);
                        };

                        expr = Expr::MemberAccess {
                            object: Box::new(expr),
                            member,
                        };
                    }

                    expr
                } else {
                    Expr::Variable(name)
                }
            }
            TokenKind::LBracket => {
                // Array literal
                self.advance();
                let mut elements = Vec::new();

                if self.current.kind != TokenKind::RBracket {
                    elements.push(self.parse_expr());
                    while self.expect(TokenKind::Comma) {
                        elements.push(self.parse_expr());
                    }
                }

                if !self.expect(TokenKind::RBracket) {
                    eprintln!("Expected ']' in array literal");
                    process::exit(1);
                }

                Expr::ArrayLiteral(elements)
            }
            TokenKind::LParen => {
                self.advance();
                let expr = self.parse_expr();
                if !self.expect(TokenKind::RParen) {
                    eprintln!("Expected ')' after expression");
                    process::exit(1);
                }
                expr
            }
            _ => {
                eprintln!("Unexpected token in expression: {:?}", self.current);
                process::exit(1);
            }
        }
    }
}
