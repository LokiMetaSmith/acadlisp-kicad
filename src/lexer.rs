// AutoLISP Lexer - Compatible with AutoCAD 9/10 (DOS era)
// Handles the limited character set and syntax of 1988-era AutoLISP

#[derive(Debug, Clone, PartialEq)]
pub enum Token {
    LParen,
    RParen,
    Quote,
    Symbol(String),
    String(String),
    Integer(i32),
    Real(f64),
    Nil,
    T,
}

pub struct Lexer<'a> {
    input: &'a str,
    pos: usize,
}

impl<'a> Lexer<'a> {
    pub fn new(input: &'a str) -> Self {
        Lexer { input, pos: 0 }
    }

    fn peek(&self) -> Option<char> {
        self.input[self.pos..].chars().next()
    }

    fn advance(&mut self) -> Option<char> {
        let c = self.peek()?;
        self.pos += c.len_utf8();
        Some(c)
    }

    fn skip_whitespace(&mut self) {
        while let Some(c) = self.peek() {
            if c.is_whitespace() {
                self.advance();
            } else {
                break;
            }
        }
    }

    fn skip_comment(&mut self) {
        // AutoLISP comments start with ; and go to end of line
        if self.peek() == Some(';') {
            while let Some(c) = self.advance() {
                if c == '\n' {
                    break;
                }
            }
        }
    }

    fn read_string(&mut self) -> Token {
        self.advance(); // consume opening "
        let mut s = String::new();
        while let Some(c) = self.advance() {
            if c == '"' {
                break;
            } else if c == '\\' {
                // Escape sequences (limited in DOS era)
                if let Some(escaped) = self.advance() {
                    match escaped {
                        'n' => s.push('\n'),
                        'r' => s.push('\r'),
                        't' => s.push('\t'),
                        '"' => s.push('"'),
                        '\\' => s.push('\\'),
                        _ => {
                            s.push('\\');
                            s.push(escaped);
                        }
                    }
                }
            } else {
                s.push(c);
            }
        }
        Token::String(s)
    }

    fn read_number_or_symbol(&mut self) -> Token {
        let start = self.pos;
        let mut has_dot = false;
        let mut has_digit = false;
        let first_char = self.peek().unwrap();
        let is_negative = first_char == '-';

        if is_negative || first_char == '+' {
            self.advance();
        }

        while let Some(c) = self.peek() {
            if c.is_ascii_digit() {
                has_digit = true;
                self.advance();
            } else if c == '.' && !has_dot {
                has_dot = true;
                self.advance();
            } else if c.is_whitespace() || c == '(' || c == ')' || c == '"' || c == ';' || c == '\''
            {
                break;
            } else {
                // Not a pure number, read as symbol
                while let Some(c) = self.peek() {
                    if c.is_whitespace()
                        || c == '('
                        || c == ')'
                        || c == '"'
                        || c == ';'
                        || c == '\''
                    {
                        break;
                    }
                    self.advance();
                }
                let sym = self.input[start..self.pos].to_uppercase();
                return match sym.as_str() {
                    "NIL" => Token::Nil,
                    "T" => Token::T,
                    _ => Token::Symbol(sym),
                };
            }
        }

        let text = &self.input[start..self.pos];

        if !has_digit {
            let sym = text.to_uppercase();
            return match sym.as_str() {
                "NIL" => Token::Nil,
                "T" => Token::T,
                _ => Token::Symbol(sym),
            };
        }

        if has_dot {
            Token::Real(text.parse().unwrap_or(0.0))
        } else {
            Token::Integer(text.parse().unwrap_or(0))
        }
    }

    fn read_symbol(&mut self) -> Token {
        let start = self.pos;
        while let Some(c) = self.peek() {
            if c.is_whitespace() || c == '(' || c == ')' || c == '"' || c == ';' || c == '\'' {
                break;
            }
            self.advance();
        }
        let sym = self.input[start..self.pos].to_uppercase();
        match sym.as_str() {
            "NIL" => Token::Nil,
            "T" => Token::T,
            _ => Token::Symbol(sym),
        }
    }

    pub fn next_token(&mut self) -> Option<Token> {
        loop {
            self.skip_whitespace();

            match self.peek()? {
                ';' => {
                    self.skip_comment();
                    continue;
                }
                '(' => {
                    self.advance();
                    return Some(Token::LParen);
                }
                ')' => {
                    self.advance();
                    return Some(Token::RParen);
                }
                '\'' => {
                    self.advance();
                    return Some(Token::Quote);
                }
                '"' => {
                    return Some(self.read_string());
                }
                c if c.is_ascii_digit() => {
                    return Some(self.read_number_or_symbol());
                }
                '-' | '+' => {
                    return Some(self.read_number_or_symbol());
                }
                '.' => {
                    return Some(self.read_number_or_symbol());
                }
                _ => {
                    return Some(self.read_symbol());
                }
            }
        }
    }

    pub fn tokenize(&mut self) -> Vec<Token> {
        let mut tokens = Vec::new();
        while let Some(token) = self.next_token() {
            tokens.push(token);
        }
        tokens
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_basic_tokens() {
        let mut lexer = Lexer::new("(defun test (x) (* x 2))");
        let tokens = lexer.tokenize();
        assert_eq!(tokens[0], Token::LParen);
        assert_eq!(tokens[1], Token::Symbol("DEFUN".to_string()));
    }

    #[test]
    fn test_numbers() {
        let mut lexer = Lexer::new("42 3.15 -17 -2.5");
        let tokens = lexer.tokenize();
        assert_eq!(tokens[0], Token::Integer(42));
        assert_eq!(tokens[1], Token::Real(3.15)); // Avoid 3.14 which clippy flags as PI
        assert_eq!(tokens[2], Token::Integer(-17));
        assert_eq!(tokens[3], Token::Real(-2.5));
    }

    #[test]
    fn test_strings() {
        let mut lexer = Lexer::new("\"hello\" \"world\\n\"");
        let tokens = lexer.tokenize();
        assert_eq!(tokens[0], Token::String("hello".to_string()));
        assert_eq!(tokens[1], Token::String("world\n".to_string()));
    }
}
