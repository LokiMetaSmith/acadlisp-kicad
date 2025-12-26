#[cfg(test)]
mod tests {
    use super::*;
    use crate::interpreter::Interpreter;
    use crate::kicad;

    #[test]
    fn test_kicad_symbol_generation() {
        let mut interp = Interpreter::new();

        // Define a simple symbol: a box with two pins
        let code = r#"
            (kicad-prop "Reference" "U1" 0 5 0 1.27 1)
            (kicad-prop "Value" "TEST_SYM" 0 -5 0 1.27 1)
            (command "LINE" '(-5 5) '(5 5) "")
            (command "LINE" '(5 5) '(5 -5) "")
            (command "LINE" '(5 -5) '(-5 -5) "")
            (command "LINE" '(-5 -5) '(-5 5) "")
            (kicad-pin "IN" "1" "input" "line" -7.54 0 2.54 0)
            (kicad-pin "OUT" "2" "output" "line" 7.54 0 2.54 180)
        "#;

        interp.run(code);

        let sym = kicad::to_kicad_sym(&interp.drawing.entities, "MyLib", "MySym");

        // Basic validation
        assert!(sym.contains("(kicad_symbol_lib"));
        assert!(sym.contains("(symbol \"MyLib:MySym\""));
        assert!(sym.contains("(property \"Reference\" \"U1\""));
        assert!(sym.contains("(property \"Value\" \"TEST_SYM\""));

        // Check for geometry
        assert!(sym.contains("(polyline (pts (xy -5 5) (xy 5 5))"));

        // Check for pins
        assert!(sym.contains("(pin input line (at -7.54 0 0)"));
        assert!(sym.contains("(name \"IN\""));
        assert!(sym.contains("(number \"1\""));

        println!("{}", sym);
    }
}
