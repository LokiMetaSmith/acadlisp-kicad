//! Simple example showing basic library usage
//!
//! Run with: cargo run --example simple

use acadlisp::{run_lisp, SchaltplanEngine};

fn main() {
    println!("=== rust-autolisp Library Examples ===\n");

    // Example 1: Direct AutoLISP evaluation
    println!("1. Direct AutoLISP evaluation:");
    let (results, _) = run_lisp("(+ 10 20 30)");
    println!("   (+ 10 20 30) = {:?}", results[0]);

    let (results, _) = run_lisp(
        r#"
        (defun factorial (n)
            (if (<= n 1)
                1
                (* n (factorial (1- n)))))
        (factorial 5)
    "#,
    );
    println!("   (factorial 5) = {:?}\n", results.last().unwrap());

    // Example 2: Using the engine for drawings
    println!("2. Drawing generation:");
    let mut engine = SchaltplanEngine::new();

    // Define a simple drawing function
    engine.eval(
        r#"
        (defun draw-box (x y w h)
            (command "LINE" (list x y) (list (+ x w) y) "")
            (command "LINE" (list (+ x w) y) (list (+ x w) (+ y h)) "")
            (command "LINE" (list (+ x w) (+ y h)) (list x (+ y h)) "")
            (command "LINE" (list x (+ y h)) (list x y) ""))
    "#,
    );

    engine.eval("(draw-box 0 0 100 50)");
    engine.eval(r#"(command "TEXT" '(10 20) 5 0 "Hello from Rust!")"#);

    let entities = engine.get_entities();
    println!("   Created {} entities", entities.len());
    for e in entities {
        println!("   - {:?}", e);
    }

    // Example 3: CSV processing
    println!("\n3. CSV processing:");
    let csv = "START;MOTOR;Pump-01\nK1;Contactor;LC1D18\nQ1;Breaker;GV2M14\nSTOP";
    let specs = engine.process_csv(csv);
    println!("   Parsed {} drawing(s) from CSV:", specs.len());
    for spec in &specs {
        println!(
            "   - {} using template '{}' ({} components)",
            spec.name,
            spec.template,
            spec.components.len()
        );
    }

    println!("\n=== Done! ===");
}
