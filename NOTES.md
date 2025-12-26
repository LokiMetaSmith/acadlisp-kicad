# rust-autolisp: Development Notes

## The Story Behind This Project

### Historical Context (1991)

- **Location**: Unterneukirchen, Bavaria, Germany
- **Company**: Elektrotechnik Trahe GmbH (brother's electrical company)
- **Problem**: Needed hundreds of Schaltpläne (electrical circuit diagrams), professional CAD work unaffordable
- **Solution**: Medicine student (me) wrote automation system

### The Original Tech Stack

- **Hardware**: 486DX-50 with 8MB RAM
- **Boot Disk**: Special B: drive with memory optimization
  - HIMEM.SYS + EMM386.EXE
  - 605KB conventional RAM (AutoCAD required this)
- **Software**:
  - AutoCAD Release 9/10 (DOS)
  - AutoLISP for drawing generation
  - Turbo Pascal for print queue management
- **Printer**: HP LaserJet III (expensive at the time)

### The Workflow

1. CSV file with component data (German semicolon-delimited)
2. Format: START;TEMPLATE;DRAWING_NAME followed by component lines, then STOP
3. 5-12 components per drawing
4. Multiple templates: MOTOR_ST (motor starter), STERN_DR (star-delta), WENDE (reversing), LICHT (lighting), DIREKT (direct control)
5. AutoLISP reads CSV, generates DWG files
6. Print queue (Turbo Pascal) spools to LaserJet
7. Result: ~99.5% time savings vs manual drawing

### Personal Impact

- Was studying medicine at the time
- Got so deep into this automation work that it derailed medical studies
- "Thinking a bit too long I can do both" - but both medicine and IT are too demanding
- Became a developer instead

### Post-DOS Life

- The DOS/Windows experience was so frustrating → bought Macintosh Quadra 700
- Did NOT run System 6/7 - ran **A/UX** (Apple's Unix)
- A/UX was free for students
- When Linux m68k emerged: first to compile and upload MC68040-optimized kernel and libraries

---

## Current Rust Implementation

### Architecture

```
src/
├── lib.rs          # Library API (SchaltplanEngine)
├── main.rs         # CLI binary
├── lexer.rs        # AutoLISP tokenizer
├── parser.rs       # S-expression parser
└── interpreter.rs  # AutoLISP evaluator + drawing simulation
```

### Library API (`lib.rs`)

```rust
use rust_autolisp::{SchaltplanEngine, run_lisp, Expr, DrawEntity};

// Simple evaluation
let (results, entities) = run_lisp("(+ 1 2 3)");

// Full engine
let mut engine = SchaltplanEngine::new();
engine
    .set_company("Elektrotechnik Trahe GmbH")
    .set_project("Industriesteuerung")
    .set_output_dir("output");

// Load templates
engine.load_template("MOTOR_ST", lsp_code);
engine.load_template_file("STERN_DR", "templates/stern_dr.lsp")?;
engine.load_templates_dir("templates/")?;

// Process CSV
let specs = engine.process_csv(csv_data);
// specs: Vec<DrawingSpec> with name, template, components

// Generate all drawings
let results = engine.generate_all(&specs);
// Creates SVG + JSON files in output_dir
```

### Supported AutoLISP Functions

#### Arithmetic
`+`, `-`, `*`, `/`, `1+`, `1-`, `ABS`, `MAX`, `MIN`, `REM`, `GCD`, `SIN`, `COS`, `ATAN`, `SQRT`, `EXPT`, `EXP`, `LOG`, `FIX`, `FLOAT`

#### Comparison
`=`, `/=`, `<`, `>`, `<=`, `>=`, `EQ`, `EQUAL`

#### Logical
`AND`, `OR`, `NOT`, `NULL`

#### List Operations
`CAR`, `CDR`, `CADR`, `CADDR`, `CAAR`, `CADAR`, `CDDR`, `CONS`, `LIST`, `APPEND`, `REVERSE`, `LENGTH`, `NTH`, `LAST`, `MEMBER`, `ASSOC`, `SUBST`, `MAPCAR`

#### String Operations
`STRCAT`, `STRLEN`, `SUBSTR`, `STRCASE`, `ASCII`, `CHR`, `ATOI`, `ATOF`, `ITOA`, `RTOS`, `ANGTOS`, `READ`

#### Control Flow
`IF`, `COND`, `WHILE`, `REPEAT`, `PROGN`, `FOREACH`

#### I/O
`PRINC`, `PRINT`, `PRIN1`, `PROMPT`, `TERPRI`, `OPEN`, `CLOSE`, `READ-LINE`, `READ-CHAR`, `WRITE-LINE`, `WRITE-CHAR`, `FINDFILE`

#### AutoCAD Simulation
`COMMAND` - Simulates LINE, CIRCLE, TEXT, INSERT commands
`GETVAR`, `SETVAR` - System variables
`ENTMAKE` - Entity creation
`DEFUN` - Function definition
`SETQ` - Variable assignment

### Drawing Output

Entities generated:
- `Line { x1, y1, x2, y2, layer }`
- `Circle { cx, cy, radius, layer }`
- `Arc { cx, cy, radius, start_angle, end_angle, layer }`
- `Text { x, y, height, text, layer }`
- `Point { x, y, layer }`
- `Insert { block_name, x, y, scale, rotation, layer }`

Output formats:
- **SVG** - Viewable in browser, dark theme with green/blue lines
- **JSON** - Machine-readable entity list

### CSV Format

```csv
# Comment lines start with #
START;TEMPLATE_NAME;DRAWING_NAME
COMPONENT;TYPE;VALUE;EXTRA_FIELDS...
COMPONENT;TYPE;VALUE
STOP

START;NEXT_TEMPLATE;NEXT_DRAWING
...
STOP
```

Example:
```csv
START;MOTOR_ST;01-K1
K1;Schütz;LC1-D18;Telemecanique
Q1;Motorschutzschalter;GV2-M14;6-10A
F1;Sicherung;10A;gL
STOP
```

### Bugs Fixed During Development

1. **TEXT command showing "0"**
   - Problem: LSP used `(command "TEXT" point height rotation text)` with 4 args
   - Interpreter expected 3 args: `(point height text)`
   - Fix: Check `args.len() >= 4` to get text from `args[3]`

2. **Global variables not updating in functions**
   - Problem: `*FRAME-NUM*` stayed at 0 when modified inside defun
   - Root cause: `set_var()` always wrote to local scope
   - Fix: Check if name starts with `*` or exists in globals → write to global scope

### Examples

```bash
# Simple library usage
cargo run --example simple

# Full 1991 workflow recreation
cargo run --example trahe_elektrotechnik

# CLI usage
cargo run -- samples/test.lsp
cargo run -- -i   # Interactive REPL
```

---

## TODO / Future Work

- [ ] More AutoCAD commands (ARC, PLINE, DIMENSION)
- [ ] Block definitions (BLOCK/ENDBLK)
- [ ] Layer management with colors
- [ ] DXF output (actual CAD format)
- [ ] Template library with real DIN-compliant electrical symbols
- [ ] Interactive mode with step-by-step visualization
- [ ] WASM build for browser demo

---

## For the HN Story

Key narrative points:
1. Medicine student, 1991, Bavaria
2. Brother's company needed Schaltpläne, couldn't afford professionals
3. AutoLISP + Turbo Pascal automation saved the business
4. 486DX-50, boot disk for 605KB conventional RAM
5. Got so deep into it, lost track of medicine
6. DOS disgust → Macintosh Quadra 700 → A/UX (Apple Unix)
7. Early Linux m68k contributor - first MC68040 optimized kernel upload
8. 30+ years later: recreating the engine in Rust
