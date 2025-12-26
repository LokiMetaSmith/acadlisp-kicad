# acadlisp

AutoLISP interpreter and mini CAD engine in Rust, targeting WebAssembly.

Emulates CSV/TPL/LSP workflows from AutoCAD 9/10 (DOS era) for educational and archival purposes.

## Features

- AutoLISP interpreter with core functions
- CAD primitives: LINE, CIRCLE, ARC, TEXT, INSERT (blocks)
- CSV data reading for parametric drawings
- DXF export
- Runs natively and in browser (WASM)

## Try it

Live demo: [acadlisp.de](https://acadlisp.de)

## Usage

### As a library

```rust
use acadlisp::Engine;

let mut engine = Engine::new();
engine.eval("(setq x 10)");
engine.eval("(command \"LINE\" '(0 0) '(100 100) \"\")");

let entities = engine.get_entities();
let dxf = engine.export_dxf();
```

### CLI

```bash
cargo run --bin acadlisp-cli -- samples/TEST.LSP
```

### WASM

```bash
trunk serve
# Open http://localhost:8080
```

## Supported AutoLISP Functions

### Core
`setq` `defun` `if` `cond` `while` `repeat` `progn` `lambda` `apply` `mapcar` `foreach`

### Math
`+` `-` `*` `/` `1+` `1-` `abs` `sin` `cos` `atan` `sqrt` `expt` `min` `max` `rem` `gcd`

### Comparison
`=` `/=` `<` `>` `<=` `>=` `eq` `equal`

### Logic
`and` `or` `not` `null`

### List
`car` `cdr` `cons` `list` `append` `reverse` `length` `nth` `member` `assoc` `subst`

### String
`strcat` `strlen` `substr` `strcase` `atoi` `atof` `itoa` `rtos` `read`

### I/O
`print` `princ` `prin1` `terpri` `prompt`

### CAD
`command` `getvar` `setvar` `entget` `entmake` `entmod` `ssget` `sslength` `ssname`

## Building

```bash
# Native
cargo build --release

# WASM
trunk build --release
```

## License

MIT
