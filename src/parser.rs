// AutoLISP Parser - S-expression parser for AutoCAD 9/10 dialect

use crate::lexer::{Lexer, Token};

#[derive(Debug, Clone, PartialEq)]
pub enum Expr {
    Nil,
    T,
    Integer(i32),
    Real(f64),
    String(String),
    Symbol(String),
    List(Vec<Expr>),
    Quote(Box<Expr>),
}

impl Expr {
    pub fn is_nil(&self) -> bool {
        match self {
            Expr::Nil => true,
            Expr::List(v) => v.is_empty(),
            _ => false,
        }
    }

    pub fn is_truthy(&self) -> bool {
        !self.is_nil()
    }

    pub fn as_integer(&self) -> Option<i32> {
        match self {
            Expr::Integer(i) => Some(*i),
            Expr::Real(r) => Some(*r as i32),
            _ => None,
        }
    }

    pub fn as_real(&self) -> Option<f64> {
        match self {
            Expr::Integer(i) => Some(*i as f64),
            Expr::Real(r) => Some(*r),
            _ => None,
        }
    }

    #[allow(dead_code)]
    pub fn as_string(&self) -> Option<&str> {
        match self {
            Expr::String(s) => Some(s),
            _ => None,
        }
    }

    #[allow(dead_code)]
    pub fn as_symbol(&self) -> Option<&str> {
        match self {
            Expr::Symbol(s) => Some(s),
            _ => None,
        }
    }

    #[allow(dead_code)]
    pub fn as_list(&self) -> Option<&Vec<Expr>> {
        match self {
            Expr::List(v) => Some(v),
            _ => None,
        }
    }
}

impl std::fmt::Display for Expr {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Expr::Nil => write!(f, "nil"),
            Expr::T => write!(f, "T"),
            Expr::Integer(i) => write!(f, "{}", i),
            Expr::Real(r) => write!(f, "{}", r),
            Expr::String(s) => write!(f, "\"{}\"", s),
            Expr::Symbol(s) => write!(f, "{}", s),
            Expr::List(items) => {
                write!(f, "(")?;
                for (i, item) in items.iter().enumerate() {
                    if i > 0 {
                        write!(f, " ")?;
                    }
                    write!(f, "{}", item)?;
                }
                write!(f, ")")
            }
            Expr::Quote(e) => write!(f, "'{}", e),
        }
    }
}

pub struct Parser {
    tokens: Vec<Token>,
    pos: usize,
}

impl Parser {
    pub fn new(tokens: Vec<Token>) -> Self {
        Parser { tokens, pos: 0 }
    }

    pub fn from_input(input: &str) -> Self {
        let mut lexer = Lexer::new(input);
        let tokens = lexer.tokenize();
        Parser::new(tokens)
    }

    fn peek(&self) -> Option<&Token> {
        self.tokens.get(self.pos)
    }

    fn advance(&mut self) -> Option<&Token> {
        let token = self.tokens.get(self.pos)?;
        self.pos += 1;
        Some(token)
    }

    pub fn parse_expr(&mut self) -> Option<Expr> {
        let token = self.advance()?.clone();
        match token {
            Token::LParen => {
                let mut items = Vec::new();
                loop {
                    match self.peek() {
                        None => break,
                        Some(Token::RParen) => {
                            self.advance();
                            break;
                        }
                        _ => {
                            if let Some(expr) = self.parse_expr() {
                                items.push(expr);
                            }
                        }
                    }
                }
                Some(Expr::List(items))
            }
            Token::RParen => None, // Unexpected, ignore
            Token::Quote => {
                let expr = self.parse_expr()?;
                Some(Expr::Quote(Box::new(expr)))
            }
            Token::Symbol(s) => Some(Expr::Symbol(s)),
            Token::String(s) => Some(Expr::String(s)),
            Token::Integer(i) => Some(Expr::Integer(i)),
            Token::Real(r) => Some(Expr::Real(r)),
            Token::Nil => Some(Expr::Nil),
            Token::T => Some(Expr::T),
        }
    }

    pub fn parse_all(&mut self) -> Vec<Expr> {
        let mut exprs = Vec::new();
        while self.pos < self.tokens.len() {
            if let Some(expr) = self.parse_expr() {
                exprs.push(expr);
            }
        }
        exprs
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_simple() {
        let mut parser = Parser::from_input("(+ 1 2)");
        let expr = parser.parse_expr().unwrap();
        if let Expr::List(items) = expr {
            assert_eq!(items.len(), 3);
            assert_eq!(items[0], Expr::Symbol("+".to_string()));
            assert_eq!(items[1], Expr::Integer(1));
            assert_eq!(items[2], Expr::Integer(2));
        } else {
            panic!("Expected list");
        }
    }

    #[test]
    fn test_parse_nested() {
        let mut parser = Parser::from_input("(defun square (x) (* x x))");
        let expr = parser.parse_expr().unwrap();
        if let Expr::List(items) = expr {
            assert_eq!(items.len(), 4);
            assert_eq!(items[0], Expr::Symbol("DEFUN".to_string()));
        } else {
            panic!("Expected list");
        }
    }

    #[test]
    fn test_parse_quote() {
        let mut parser = Parser::from_input("'(1 2 3)");
        let expr = parser.parse_expr().unwrap();
        assert!(matches!(expr, Expr::Quote(_)));
    }
}
