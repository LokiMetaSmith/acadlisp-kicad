// KiCad Export Module
// Handles exporting DrawEntities to KiCad S-expression format

use crate::interpreter::DrawEntity;

/// Exports a list of DrawEntities to a KiCad Symbol Library (.kicad_sym) format
pub fn to_kicad_sym(entities: &[DrawEntity], library_name: &str, symbol_name: &str) -> String {
    let mut sexpr = String::new();

    // Standard header for V6+ symbol library
    sexpr.push_str("(kicad_symbol_lib (version 20211014) (generator acadlisp)\n");

    // Start symbol definition
    sexpr.push_str(&format!("  (symbol \"{}:{}\" (in_bom yes) (on_board yes)\n", library_name, symbol_name));

    // Separate properties, pins, and graphics
    let mut properties = Vec::new();
    let mut pins = Vec::new();
    let mut graphics = Vec::new();

    for entity in entities {
        match entity {
            DrawEntity::Property { .. } => properties.push(entity),
            DrawEntity::Pin { .. } => pins.push(entity),
            _ => graphics.push(entity),
        }
    }

    // Write properties
    // Ensure mandatory properties exist if not provided: Reference, Value, Footprint, Datasheet
    let mut has_ref = false;
    let mut has_val = false;
    let mut has_fp = false;
    let mut has_ds = false;

    for (i, prop) in properties.iter().enumerate() {
        if let DrawEntity::Property { key, value, x, y, rotation, height, visible, .. } = prop {
            if key == "Reference" { has_ref = true; }
            if key == "Value" { has_val = true; }
            if key == "Footprint" { has_fp = true; }
            if key == "Datasheet" { has_ds = true; }

            sexpr.push_str(&format!(
                "    (property \"{}\" \"{}\" (id {}) (at {} {} {}) (effects (font (size {} {})) {}))\n",
                key,
                escape_string(value),
                i,
                x, y, rotation,
                height, height,
                if *visible { "" } else { "hide" }
            ));
        }
    }

    // Add default properties if missing (simplistic ID assignment, user should really provide them)
    let next_id = properties.len();
    if !has_ref {
        sexpr.push_str(&format!("    (property \"Reference\" \"U1\" (id {}) (at 0 5 0) (effects (font (size 1.27 1.27))))\n", next_id));
    }
    if !has_val {
        sexpr.push_str(&format!("    (property \"Value\" \"{}\" (id {}) (at 0 -5 0) (effects (font (size 1.27 1.27))))\n", symbol_name, next_id + 1));
    }
    if !has_fp {
        sexpr.push_str(&format!("    (property \"Footprint\" \"\" (id {}) (at 0 0 0) (effects (font (size 1.27 1.27)) hide))\n", next_id + 2));
    }
    if !has_ds {
        sexpr.push_str(&format!("    (property \"Datasheet\" \"\" (id {}) (at 0 0 0) (effects (font (size 1.27 1.27)) hide))\n", next_id + 3));
    }

    // Symbol body (graphics and pins)
    // We wrap graphics in a symbol unit "1_1" for simplicity, although generic symbols can have multiple units.
    // For now, everything goes into unit 1, style 1.
    sexpr.push_str(&format!("    (symbol \"{}:1_1\"\n", symbol_name));

    // Graphics
    for entity in graphics {
        match entity {
            DrawEntity::Line { x1, y1, x2, y2, .. } => {
                // (polyline (pts (xy X1 Y1) (xy X2 Y2)) (stroke (width 0) (type default) (color 0 0 0 0)) (fill (type none)))
                sexpr.push_str(&format!(
                    "      (polyline (pts (xy {} {}) (xy {} {})) (stroke (width 0) (type default) (color 0 0 0 0)) (fill (type none)))\n",
                    x1, y1, x2, y2
                ));
            }
            DrawEntity::Circle { cx, cy, radius, .. } => {
                // (circle (center X Y) (radius R) (stroke (width 0) (type default) (color 0 0 0 0)) (fill (type none)))
                sexpr.push_str(&format!(
                    "      (circle (center {} {}) (radius {}) (stroke (width 0) (type default) (color 0 0 0 0)) (fill (type none)))\n",
                    cx, cy, radius
                ));
            }
            DrawEntity::Arc { cx, cy, radius, start_angle, end_angle, .. } => {
                // KiCad arcs: (arc (start X Y) (mid X Y) (end X Y) ...)
                // We have center, radius, start/end angles. Need to convert.
                // Start point
                let start_x = cx + radius * start_angle.cos();
                let start_y = cy + radius * start_angle.sin();
                // End point
                let end_x = cx + radius * end_angle.cos();
                let end_y = cy + radius * end_angle.sin();
                // Mid point (approximate for now, taking average angle)
                // Note: angles in acadlisp are radians? Yes, usually.
                let mid_angle = (start_angle + end_angle) / 2.0;
                let mid_x = cx + radius * mid_angle.cos();
                let mid_y = cy + radius * mid_angle.sin();

                sexpr.push_str(&format!(
                    "      (arc (start {} {}) (mid {} {}) (end {} {}) (stroke (width 0) (type default) (color 0 0 0 0)) (fill (type none)))\n",
                    start_x, start_y, mid_x, mid_y, end_x, end_y
                ));
            }
            DrawEntity::Text { x, y, height, text, .. } => {
                // (text "TEXT" (at X Y R) (effects (font (size H H))))
                sexpr.push_str(&format!(
                    "      (text \"{}\" (at {} {} 0) (effects (font (size {} {}))))\n",
                    escape_string(text), x, y, height, height
                ));
            }
            DrawEntity::Insert { block_name: _, x: _, y: _, .. } => {
                 // Blocks usually don't map directly unless exploded.
                 // We'll just put a placeholder rectangle for now or ignore.
                 // Ideally this would be recursive, but we don't have block definitions here easily.
                 // Just ignored for now to avoid invalid output.
            }
             _ => {} // Ignore points and others
        }
    }

    // Pins
    for pin in pins {
        if let DrawEntity::Pin { name, number, etype, style, x, y, length, rotation, .. } = pin {
            // (pin TYPE STYLE (at X Y ROT) (length LEN)
            //   (name "NAME" (effects (font (size 1.27 1.27))))
            //   (number "NUM" (effects (font (size 1.27 1.27))))
            // )
            sexpr.push_str(&format!(
                "      (pin {} {} (at {} {} {}) (length {}) \n",
                etype, style, x, y, rotation, length
            ));
            sexpr.push_str(&format!(
                "        (name \"{}\" (effects (font (size 1.27 1.27))))\n",
                escape_string(name)
            ));
            sexpr.push_str(&format!(
                "        (number \"{}\" (effects (font (size 1.27 1.27))))\n",
                escape_string(number)
            ));
            sexpr.push_str("      )\n");
        }
    }

    sexpr.push_str("    )\n"); // End symbol unit
    sexpr.push_str("  )\n"); // End symbol
    sexpr.push_str(")\n"); // End lib

    sexpr
}

fn escape_string(s: &str) -> String {
    s.replace('"', "\\\"").replace('\\', "\\\\")
}
