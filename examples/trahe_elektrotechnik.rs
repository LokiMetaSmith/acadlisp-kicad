//! Example: Elektrotechnik Trahe GmbH - Schaltplan Generation
//!
//! This example recreates the 1991 workflow where AutoLISP automation
//! generated hundreds of electrical circuit diagrams from CSV data.
//!
//! Run with: cargo run --example trahe_elektrotechnik

use acadlisp::{DrawEntity, SchaltplanEngine};

fn main() {
    println!("=== Elektrotechnik Trahe GmbH ===");
    println!("    Unterneukirchen, Bayern");
    println!("    Schaltplan-Generator 1991");
    println!();

    // Create engine with company config
    let mut engine = SchaltplanEngine::new();
    engine
        .set_company("Elektrotechnik Trahe GmbH")
        .set_project("Industriesteuerung")
        .set_output_dir("output/trahe");

    // Load the Schaltplan template (inline for this example)
    engine.load_template("MOTOR_ST", MOTOR_STARTER_TEMPLATE);
    engine.load_template("STERN_DR", STAR_DELTA_TEMPLATE);
    engine.load_template("DIREKT", DIRECT_START_TEMPLATE);

    // Process CSV data - this is how it was done in 1991!
    // The CSV would come from dBase or early Excel
    let csv_data = r#"
# Elektrotechnik Trahe GmbH - Komponentenliste
# Projekt: Industrieanlage Huber & Söhne
# Erstellt: 15.03.1991

START;MOTOR_ST;01-K1
K1;Schütz;LC1-D18;Telemecanique
Q1;Motorschutzschalter;GV2-M14;6-10A
F1;Sicherung;10A;gL
STOP

START;STERN_DR;02-K1
K1;Hauptschütz;LC1-D25;Telemecanique
K2;Sternschütz;LC1-D18;Telemecanique
K3;Dreieckschütz;LC1-D18;Telemecanique
K4;Zeitrelais;RE7-RM11;2s
Q1;Motorschutzschalter;GV2-M20;13-18A
STOP

START;MOTOR_ST;03-K1
K1;Schütz;LC1-D09;Telemecanique
Q1;Motorschutzschalter;GV2-M08;2.5-4A
F1;Sicherung;6A;gL
STOP

START;DIREKT;04-S1
S1;Taster;XB2-BA21;grün
S2;Taster;XB2-BA42;rot
H1;Meldeleuchte;XB2-BV63;grün
H2;Meldeleuchte;XB2-BV64;rot
STOP

START;MOTOR_ST;05-K1
K1;Schütz;LC1-D32;Telemecanique
Q1;Motorschutzschalter;GV2-M22;17-23A
F1;Sicherung;25A;gL
STOP
"#;

    // Parse CSV into drawing specs
    let drawings = engine.process_csv(csv_data);
    println!("Parsed {} drawings from CSV", drawings.len());
    println!();

    // Generate each drawing
    for spec in &drawings {
        println!("Generating: {} (Template: {})", spec.name, spec.template);
        println!("  Components: {}", spec.components.len());
        for comp in &spec.components {
            if let (Some(name), Some(typ)) = (comp.get("NAME"), comp.get("TYPE")) {
                let value = comp.get("VALUE").map(|s| s.as_str()).unwrap_or("");
                println!("    - {} : {} {}", name, typ, value);
            }
        }
    }
    println!();

    // Generate all drawings to output files
    let results = engine.generate_all(&drawings);

    println!("=== Generation Complete ===");
    for result in &results {
        println!("Drawing: {}", result.name);
        println!("  Entities: {}", result.entities.len());
        if let Some(svg) = &result.svg_path {
            println!("  SVG: {}", svg);
        }
        if let Some(json) = &result.json_path {
            println!("  JSON: {}", json);
        }

        // Show entity breakdown
        let mut lines = 0;
        let mut circles = 0;
        let mut texts = 0;
        let mut inserts = 0;
        for entity in &result.entities {
            match entity {
                DrawEntity::Line { .. } => lines += 1,
                DrawEntity::Circle { .. } => circles += 1,
                DrawEntity::Text { .. } => texts += 1,
                DrawEntity::Insert { .. } => inserts += 1,
                _ => {}
            }
        }
        if !result.entities.is_empty() {
            println!(
                "    Lines: {}, Circles: {}, Texts: {}, Blocks: {}",
                lines, circles, texts, inserts
            );
        }
    }

    // Show interpreter output
    let output = engine.get_output();
    if !output.is_empty() {
        println!();
        println!("=== AutoLISP Output ===");
        for line in output {
            if !line.is_empty() {
                println!("{}", line);
            }
        }
    }
}

// Motor Starter Template (Motorstarter mit Schütz und Motorschutzschalter)
const MOTOR_STARTER_TEMPLATE: &str = r#"
; MOTOR_ST.LSP - Motorstarter Schaltplan
; Elektrotechnik Trahe GmbH, 1991

(defun MOTOR_ST-GENERATE ()
  (princ "\nGenerating Motor Starter Schaltplan...")

  ; Title block
  (command "TEXT" '(10 280) 5 0 *DRAWING-NAME*)
  (command "TEXT" '(10 270) 3 0 *COMPANY*)
  (command "TEXT" '(10 262) 2.5 0 *PROJECT*)

  ; Power supply rails (L1, L2, L3)
  (command "LINE" '(50 250) '(50 50) "")
  (command "LINE" '(100 250) '(100 50) "")
  (command "LINE" '(150 250) '(150 50) "")
  (command "TEXT" '(48 255) 3 0 "L1")
  (command "TEXT" '(98 255) 3 0 "L2")
  (command "TEXT" '(148 255) 3 0 "L3")

  ; Main contactor K1
  (command "LINE" '(50 200) '(150 200) "")  ; horizontal connection
  (command "CIRCLE" '(50 190) 5)   ; K1 contact L1
  (command "CIRCLE" '(100 190) 5)  ; K1 contact L2
  (command "CIRCLE" '(150 190) 5)  ; K1 contact L3
  (command "TEXT" '(160 188) 3 0 "K1")

  ; Motor protection Q1
  (command "LINE" '(50 180) '(50 150) "")
  (command "LINE" '(100 180) '(100 150) "")
  (command "LINE" '(150 180) '(150 150) "")
  (command "LINE" '(45 155) '(55 145) "")   ; thermal element
  (command "LINE" '(95 155) '(105 145) "")
  (command "LINE" '(145 155) '(155 145) "")
  (command "TEXT" '(160 150) 3 0 "Q1")

  ; Motor symbol
  (command "CIRCLE" '(100 100) 20)
  (command "TEXT" '(90 95) 5 0 "M")
  (command "TEXT" '(110 95) 3 0 "3~")

  ; Connection to motor
  (command "LINE" '(50 140) '(50 120) "")
  (command "LINE" '(50 120) '(80 100) "")
  (command "LINE" '(100 140) '(100 120) "")
  (command "LINE" '(150 140) '(150 120) "")
  (command "LINE" '(150 120) '(120 100) "")

  ; Ground
  (command "LINE" '(100 80) '(100 60) "")
  (command "LINE" '(90 60) '(110 60) "")
  (command "LINE" '(93 57) '(107 57) "")
  (command "LINE" '(96 54) '(104 54) "")

  (princ " Done!")
)
"#;

// Star-Delta Template (Stern-Dreieck-Anlauf)
const STAR_DELTA_TEMPLATE: &str = r#"
; STERN_DR.LSP - Stern-Dreieck Anlaufschaltung
; Elektrotechnik Trahe GmbH, 1991

(defun STERN_DR-GENERATE ()
  (princ "\nGenerating Star-Delta Starter Schaltplan...")

  ; Title
  (command "TEXT" '(10 280) 5 0 *DRAWING-NAME*)
  (command "TEXT" '(10 270) 3 0 "Stern-Dreieck Anlauf")

  ; Three phase supply
  (command "LINE" '(50 250) '(50 50) "")
  (command "LINE" '(100 250) '(100 50) "")
  (command "LINE" '(150 250) '(150 50) "")
  (command "TEXT" '(48 255) 3 0 "L1")
  (command "TEXT" '(98 255) 3 0 "L2")
  (command "TEXT" '(148 255) 3 0 "L3")

  ; Main contactor K1
  (command "CIRCLE" '(50 220) 5)
  (command "CIRCLE" '(100 220) 5)
  (command "CIRCLE" '(150 220) 5)
  (command "TEXT" '(160 218) 3 0 "K1")

  ; Star contactor K2
  (command "CIRCLE" '(50 180) 5)
  (command "CIRCLE" '(100 180) 5)
  (command "CIRCLE" '(150 180) 5)
  (command "TEXT" '(160 178) 3 0 "K2")
  (command "TEXT" '(175 178) 2 0 "Y")

  ; Delta contactor K3
  (command "CIRCLE" '(50 140) 5)
  (command "CIRCLE" '(100 140) 5)
  (command "CIRCLE" '(150 140) 5)
  (command "TEXT" '(160 138) 3 0 "K3")
  (command "TEXT" '(175 138) 2 0 "D")

  ; Motor
  (command "CIRCLE" '(100 80) 25)
  (command "TEXT" '(90 75) 6 0 "M")
  (command "TEXT" '(110 75) 4 0 "3~")

  (princ " Done!")
)
"#;

// Direct Start Template
const DIRECT_START_TEMPLATE: &str = r#"
; DIREKT.LSP - Direktanlauf Steuerung
; Elektrotechnik Trahe GmbH, 1991

(defun DIREKT-GENERATE ()
  (princ "\nGenerating Direct Control Schaltplan...")

  ; Title
  (command "TEXT" '(10 280) 5 0 *DRAWING-NAME*)
  (command "TEXT" '(10 270) 3 0 "Steuerkreis")

  ; Control voltage
  (command "LINE" '(30 250) '(30 50) "")
  (command "LINE" '(200 250) '(200 50) "")
  (command "TEXT" '(25 255) 3 0 "+24V")
  (command "TEXT" '(195 255) 3 0 "0V")

  ; Start button S1
  (command "LINE" '(30 200) '(60 200) "")
  (command "LINE" '(70 205) '(90 200) "")  ; NO contact
  (command "LINE" '(90 200) '(120 200) "")
  (command "TEXT" '(75 215) 3 0 "S1")

  ; Stop button S2
  (command "LINE" '(120 200) '(130 200) "")
  (command "LINE" '(130 200) '(140 205) "")  ; NC contact
  (command "LINE" '(140 200) '(170 200) "")
  (command "TEXT" '(133 215) 3 0 "S2")

  ; Indicator lights
  (command "CIRCLE" '(50 120) 8)
  (command "TEXT" '(45 115) 4 0 "H1")
  (command "CIRCLE" '(100 120) 8)
  (command "TEXT" '(95 115) 4 0 "H2")

  (princ " Done!")
)
"#;
