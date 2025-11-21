// Lexer module for Athōn bootstrap compiler

#[derive(Clone, Copy, PartialEq, Debug)]
pub enum TokenKind {
    Fn,
    Let,
    If,
    Else,
    While,
    For,
    In,
    Return,
    Break,
    Continue,
    Struct,
    Enum,
    Match,
    Import,
    True,
    False,
    Type,
    Trait,
    Impl,
    Pub,
    Identifier,
    Number,
    LParen,
    RParen,
    LBrace,
    RBrace,
    LBracket,
    RBracket,
    Semicolon,
    Comma,
    Colon,
    DoubleColon,
    Dot,
    DotDot,
    Equals,
    EqualsEquals,
    NotEquals,
    LessThan,
    GreaterThan,
    LessEquals,
    GreaterEquals,
    Plus,
    Minus,
    Star,
    Slash,
    And,
    Or,
    Not,
    Arrow,
    FatArrow,
    Pipe,
    StringLiteral,
    CharLiteral,
    Underscore,
    EOF,
    Unknown,
}

#[derive(Clone, Debug)]
pub struct Token {
    pub kind: TokenKind,
    pub text: String,
    pub line: usize,
    pub column: usize,
}

pub struct Lexer {
    pub input: Vec<u8>,
    pub pos: usize,
    pub line: usize,
    pub column: usize,
}

impl Lexer {
    pub fn new(input: &str) -> Self {
        Self {
            input: input.as_bytes().to_vec(),
            pos: 0,
            line: 1,
            column: 1,
        }
    }

    fn peek(&self) -> u8 {
        if self.pos >= self.input.len() {
            0
        } else {
            self.input[self.pos]
        }
    }

    fn peek_ahead(&self, offset: usize) -> u8 {
        let pos = self.pos + offset;
        if pos >= self.input.len() {
            0
        } else {
            self.input[pos]
        }
    }

    fn advance(&mut self) {
        if self.pos < self.input.len() && self.input[self.pos] == b'\n' {
            self.line += 1;
            self.column = 1;
        } else {
            self.column += 1;
        }
        self.pos += 1;
    }

    pub fn next_token(&mut self) -> Token {
        loop {
            // Skip whitespace
            while matches!(self.peek(), b' ' | b'\n' | b'\t' | b'\r') {
                self.advance();
            }

            // Skip comments
            if self.peek() == b'/' {
                if self.peek_ahead(1) == b'/' {
                    // Single-line comment
                    self.advance();
                    self.advance();
                    while self.peek() != 0 && self.peek() != b'\n' {
                        self.advance();
                    }
                    continue;
                } else if self.peek_ahead(1) == b'*' {
                    // Multi-line comment
                    self.advance();
                    self.advance();
                    while self.peek() != 0 {
                        if self.peek() == b'*' && self.peek_ahead(1) == b'/' {
                            self.advance();
                            self.advance();
                            break;
                        }
                        self.advance();
                    }
                    continue;
                }
            }

            break;
        }

        let start = self.pos;
        let c = self.peek();

        if c == 0 {
            return Token {
                kind: TokenKind::EOF,
                text: String::new(),
                line: self.line,
                column: self.column,
            };
        }

        match c {
            b'{' => {
                self.advance();
                self.make_token(TokenKind::LBrace, start)
            }
            b'}' => {
                self.advance();
                self.make_token(TokenKind::RBrace, start)
            }
            b'[' => {
                self.advance();
                self.make_token(TokenKind::LBracket, start)
            }
            b']' => {
                self.advance();
                self.make_token(TokenKind::RBracket, start)
            }
            b'(' => {
                self.advance();
                self.make_token(TokenKind::LParen, start)
            }
            b')' => {
                self.advance();
                self.make_token(TokenKind::RParen, start)
            }
            b';' => {
                self.advance();
                self.make_token(TokenKind::Semicolon, start)
            }
            b',' => {
                self.advance();
                self.make_token(TokenKind::Comma, start)
            }
            b':' => {
                self.advance();
                if self.peek() == b':' {
                    self.advance();
                    self.make_token(TokenKind::DoubleColon, start)
                } else {
                    self.make_token(TokenKind::Colon, start)
                }
            }
            b'=' => {
                self.advance();
                if self.peek() == b'=' {
                    self.advance();
                    self.make_token(TokenKind::EqualsEquals, start)
                } else if self.peek() == b'>' {
                    self.advance();
                    self.make_token(TokenKind::FatArrow, start)
                } else {
                    self.make_token(TokenKind::Equals, start)
                }
            }
            b'!' => {
                self.advance();
                if self.peek() == b'=' {
                    self.advance();
                    self.make_token(TokenKind::NotEquals, start)
                } else {
                    self.make_token(TokenKind::Not, start)
                }
            }
            b'<' => {
                self.advance();
                if self.peek() == b'=' {
                    self.advance();
                    self.make_token(TokenKind::LessEquals, start)
                } else {
                    self.make_token(TokenKind::LessThan, start)
                }
            }
            b'>' => {
                self.advance();
                if self.peek() == b'=' {
                    self.advance();
                    self.make_token(TokenKind::GreaterEquals, start)
                } else {
                    self.make_token(TokenKind::GreaterThan, start)
                }
            }
            b'&' => {
                self.advance();
                if self.peek() == b'&' {
                    self.advance();
                    self.make_token(TokenKind::And, start)
                } else {
                    self.make_token(TokenKind::Unknown, start)
                }
            }
            b'|' => {
                self.advance();
                if self.peek() == b'|' {
                    self.advance();
                    self.make_token(TokenKind::Or, start)
                } else {
                    self.make_token(TokenKind::Pipe, start)
                }
            }
            b'.' => {
                self.advance();
                if self.peek() == b'.' {
                    self.advance();
                    self.make_token(TokenKind::DotDot, start)
                } else {
                    self.make_token(TokenKind::Dot, start)
                }
            }
            b'+' => {
                self.advance();
                self.make_token(TokenKind::Plus, start)
            }
            b'*' => {
                self.advance();
                self.make_token(TokenKind::Star, start)
            }
            b'/' => {
                self.advance();
                self.make_token(TokenKind::Slash, start)
            }
            b'-' => {
                self.advance();
                if self.peek() == b'>' {
                    self.advance();
                    self.make_token(TokenKind::Arrow, start)
                } else {
                    self.make_token(TokenKind::Minus, start)
                }
            }
            b'_' => {
                if !is_alnum(self.peek_ahead(1)) {
                    self.advance();
                    self.make_token(TokenKind::Underscore, start)
                } else {
                    let token_line = self.line;
                    let token_col = self.column;
                    while is_alnum(self.peek()) {
                        self.advance();
                    }
                    let text = String::from_utf8_lossy(&self.input[start..self.pos]).into_owned();
                    Token {
                        kind: TokenKind::Identifier,
                        text,
                        line: token_line,
                        column: token_col,
                    }
                }
            }
            b'\'' => {
                let token_line = self.line;
                let token_col = self.column;
                self.advance(); // Advance past the opening '\''

                let char_start = self.pos;
                if self.peek() == b'\\' {
                    // Check for escape sequence
                    self.advance(); // Advance past '\\'
                    match self.peek() {
                        b'n' | b'r' | b't' | b'\\' | b'\'' | b'0' => {
                            self.advance(); // Advance past the escaped char
                        }
                        _ => {
                            // Unknown escape sequence, treat as error or literal char
                            // For now, just advance past it and let the closing quote check handle it
                            self.advance();
                        }
                    }
                } else if self.peek() != b'\'' && self.peek() != 0 {
                    self.advance(); // Advance past the character
                } else {
                    // Empty char literal or EOF immediately after opening quote
                    // This will be caught by the closing quote check
                }
                let char_end = self.pos;

                if self.peek() != b'\'' {
                    eprintln!(
                        "Error: Expected closing quote for char literal at line {}, column {}",
                        token_line, token_col
                    );
                    std::process::exit(1);
                }
                self.advance(); // Advance past the closing '\''

                Token {
                    kind: TokenKind::CharLiteral,
                    text: String::from_utf8_lossy(&self.input[char_start..char_end]).into_owned(),
                    line: token_line,
                    column: token_col,
                }
            }
            b'"' => {
                let token_line = self.line;
                let token_col = self.column;
                self.advance();
                
                // Parse string with escape sequences
                let mut string_content = String::new();
                while self.peek() != 0 && self.peek() != b'"' {
                    if self.peek() == b'\\' {
                        // Handle escape sequences
                        self.advance();
                        match self.peek() {
                            b'n' => {
                                string_content.push('\n');
                                self.advance();
                            }
                            b't' => {
                                string_content.push('\t');
                                self.advance();
                            }
                            b'r' => {
                                string_content.push('\r');
                                self.advance();
                            }
                            b'\\' => {
                                string_content.push('\\');
                                self.advance();
                            }
                            b'"' => {
                                string_content.push('"');
                                self.advance();
                            }
                            b'0' => {
                                string_content.push('\0');
                                self.advance();
                            }
                            _ => {
                                // Unknown escape sequence, just include the backslash
                                string_content.push('\\');
                            }
                        }
                    } else {
                        string_content.push(self.peek() as char);
                        self.advance();
                    }
                }
                
                if self.peek() == b'"' {
                    self.advance();
                }
                Token {
                    kind: TokenKind::StringLiteral,
                    text: string_content,
                    line: token_line,
                    column: token_col,
                }
            }
            _ if is_digit(c) => {
                while is_digit(self.peek()) {
                    self.advance();
                }
                self.make_token(TokenKind::Number, start)
            }
            _ if is_alpha(c) => {
                let token_line = self.line;
                let token_col = self.column;
                while is_alnum(self.peek()) {
                    self.advance();
                }
                let text = String::from_utf8_lossy(&self.input[start..self.pos]).into_owned();
                let kind = match text.as_str() {
                    "fn" => TokenKind::Fn,
                    "let" => TokenKind::Let,
                    "if" => TokenKind::If,
                    "else" => TokenKind::Else,
                    "while" => TokenKind::While,
                    "for" => TokenKind::For,
                    "in" => TokenKind::In,
                    "return" => TokenKind::Return,
                    "break" => TokenKind::Break,
                    "continue" => TokenKind::Continue,
                    "struct" => TokenKind::Struct,
                    "enum" => TokenKind::Enum,
                    "match" => TokenKind::Match,
                    "import" => TokenKind::Import,
                    "true" => TokenKind::True,
                    "false" => TokenKind::False,
                    "type" => TokenKind::Type,
                    "trait" => TokenKind::Trait,
                    "impl" => TokenKind::Impl,
                    "pub" => TokenKind::Pub,
                    _ => TokenKind::Identifier,
                };
                Token {
                    kind,
                    text,
                    line: token_line,
                    column: token_col,
                }
            }
            _ => {
                self.advance();
                self.make_token(TokenKind::Unknown, start)
            }
        }
    }

    fn make_token(&self, kind: TokenKind, start: usize) -> Token {
        Token {
            kind,
            text: String::from_utf8_lossy(&self.input[start..self.pos]).into_owned(),
            line: self.line,
            column: self.column - (self.pos - start),
        }
    }
}

fn is_alpha(c: u8) -> bool {
    (b'a'..=b'z').contains(&c) || (b'A'..=b'Z').contains(&c) || c == b'_'
}

fn is_digit(c: u8) -> bool {
    (b'0'..=b'9').contains(&c)
}

fn is_alnum(c: u8) -> bool {
    is_alpha(c) || is_digit(c)
}
