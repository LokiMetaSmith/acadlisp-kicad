;;; SLIDES.LSP - Slideshow: AutoLISP Import System Demo
;;; Elektrotechnik Planungsbuero Schmidt & Weber GmbH
;;; Muenchen, 1991
;;;
;;; Demonstrates how .LSP files are loaded and chained together
;;; in the 1991 AutoCAD DOS workflow.
;;;

;;; ============================================
;;; SLIDESHOW CONFIGURATION
;;; ============================================

(setq *SLIDE-WIDTH* 800)
(setq *SLIDE-HEIGHT* 500)
(setq *SLIDE-MARGIN* 30)
(setq *SLIDE-NUM* 0)
(setq *SLIDE-Y-OFFSET* 0)

;;; ============================================
;;; DRAWING HELPERS
;;; ============================================

(defun SLIDE-BOX (x y w h)
  "Draw a box at position"
  (command "LINE"
    (list x (+ *SLIDE-Y-OFFSET* y))
    (list (+ x w) (+ *SLIDE-Y-OFFSET* y))
    (list (+ x w) (+ *SLIDE-Y-OFFSET* y h))
    (list x (+ *SLIDE-Y-OFFSET* y h))
    "C")
)

(defun SLIDE-TEXT (x y txt size)
  "Draw text at position"
  (command "TEXT"
    (list x (+ *SLIDE-Y-OFFSET* y))
    size
    0
    txt)
)

(defun SLIDE-LINE (x1 y1 x2 y2)
  "Draw a line"
  (command "LINE"
    (list x1 (+ *SLIDE-Y-OFFSET* y1))
    (list x2 (+ *SLIDE-Y-OFFSET* y2))
    "")
)

(defun SLIDE-ARROW (x1 y1 x2 y2)
  "Draw an arrow from (x1,y1) to (x2,y2)"
  (SLIDE-LINE x1 y1 x2 y2)
  ;; Arrowhead
  (setq dx (- x2 x1))
  (setq dy (- y2 y1))
  (setq len (sqrt (+ (* dx dx) (* dy dy))))
  (if (> len 0)
    (progn
      (setq ux (/ dx len))
      (setq uy (/ dy len))
      (setq px (* uy 8))
      (setq py (* ux -8))
      (SLIDE-LINE x2 y2 (- x2 (* ux 15) px) (- y2 (* uy 15) py))
      (SLIDE-LINE x2 y2 (- x2 (* ux 15) (- px)) (- y2 (* uy 15) (- py)))
    )
  )
)

(defun SLIDE-CIRCLE (x y r)
  "Draw a circle"
  (command "CIRCLE"
    (list x (+ *SLIDE-Y-OFFSET* y))
    r)
)

(defun SLIDE-FILE-ICON (x y name highlighted)
  "Draw a file icon with name"
  ;; File shape
  (if highlighted
    (command "COLOR" 3)  ; Green for active
    (command "COLOR" 7)  ; White for normal
  )
  ;; Main rectangle
  (SLIDE-BOX x y 80 100)
  ;; Folded corner
  (SLIDE-LINE (+ x 55) y (+ x 80) (+ y 25))
  (SLIDE-LINE (+ x 55) y (+ x 55) (+ y 25))
  (SLIDE-LINE (+ x 55) (+ y 25) (+ x 80) (+ y 25))
  ;; Filename
  (command "COLOR" 7)
  (SLIDE-TEXT (+ x 5) (- y 15) name 8)
  ;; Content lines
  (command "COLOR" 8)
  (SLIDE-LINE (+ x 10) (+ y 40) (+ x 70) (+ y 40))
  (SLIDE-LINE (+ x 10) (+ y 55) (+ x 70) (+ y 55))
  (SLIDE-LINE (+ x 10) (+ y 70) (+ x 50) (+ y 70))
)

(defun NEW-SLIDE (title subtitle)
  "Start a new slide"
  (setq *SLIDE-NUM* (1+ *SLIDE-NUM*))
  (setq *SLIDE-Y-OFFSET* (* (1- *SLIDE-NUM*) (+ *SLIDE-HEIGHT* 50)))

  ;; Slide frame
  (command "COLOR" 9)
  (SLIDE-BOX 0 0 *SLIDE-WIDTH* *SLIDE-HEIGHT*)

  ;; Slide number
  (command "COLOR" 8)
  (SLIDE-TEXT 10 (- *SLIDE-HEIGHT* 20)
    (strcat "Slide " (itoa *SLIDE-NUM*))
    6)

  ;; Title bar
  (command "COLOR" 4)
  (SLIDE-BOX 0 (- *SLIDE-HEIGHT* 60) *SLIDE-WIDTH* 60)

  ;; Title text
  (command "COLOR" 7)
  (SLIDE-TEXT *SLIDE-MARGIN* (- *SLIDE-HEIGHT* 45) title 14)

  ;; Subtitle
  (command "COLOR" 9)
  (SLIDE-TEXT *SLIDE-MARGIN* (- *SLIDE-HEIGHT* 70) subtitle 8)

  ;; Footer
  (command "COLOR" 8)
  (SLIDE-LINE 0 30 *SLIDE-WIDTH* 30)
  (SLIDE-TEXT *SLIDE-MARGIN* 10
    "Schmidt & Weber GmbH - AutoLISP Training 1991"
    5)
  (SLIDE-TEXT (- *SLIDE-WIDTH* 150) 10
    "rust-autolisp Demo"
    5)
)

;;; ============================================
;;; SLIDE 1: TITLE
;;; ============================================

(defun SLIDE-1-TITLE ()
  (NEW-SLIDE
    "AutoLISP Import System"
    "How .LSP files work together in AutoCAD 9/10")

  ;; Big logo
  (command "COLOR" 3)
  (SLIDE-BOX 250 150 300 180)
  (command "COLOR" 7)
  (SLIDE-TEXT 280 290 "AutoLISP" 20)
  (SLIDE-TEXT 300 250 ".LSP" 30)
  (command "COLOR" 8)
  (SLIDE-TEXT 280 200 "The Language of" 10)
  (SLIDE-TEXT 280 180 "AutoCAD Automation" 10)

  ;; Version info
  (command "COLOR" 9)
  (SLIDE-TEXT 300 120 "AutoCAD Release 9/10" 8)
  (SLIDE-TEXT 300 100 "MS-DOS 5.0" 8)
  (SLIDE-TEXT 300 80 "386/486 PC" 8)
)

;;; ============================================
;;; SLIDE 2: THE DEPENDENCY TREE
;;; ============================================

(defun SLIDE-2-DEPS ()
  (NEW-SLIDE
    "LSP Dependency Chain"
    "Files load other files to build functionality")

  ;; ACAD.LSP at top (root)
  (command "COLOR" 2)  ; Yellow = startup
  (SLIDE-FILE-ICON 360 340 "ACAD.LSP" T)
  (command "COLOR" 2)
  (SLIDE-TEXT 350 320 "[AUTO-LOAD]" 6)

  ;; Arrow down
  (command "COLOR" 7)
  (SLIDE-ARROW 400 340 400 300)

  ;; Second level
  (command "COLOR" 3)
  (SLIDE-FILE-ICON 200 200 "CSVREAD.LSP" nil)
  (SLIDE-FILE-ICON 360 200 "EBLOCKS.LSP" nil)
  (SLIDE-FILE-ICON 520 200 "SCHALT.LSP" nil)

  ;; Arrows from ACAD.LSP
  (command "COLOR" 7)
  (SLIDE-ARROW 380 340 260 300)
  (SLIDE-ARROW 400 340 400 300)
  (SLIDE-ARROW 420 340 540 300)

  ;; Function boxes
  (command "COLOR" 9)
  (SLIDE-BOX 180 80 120 80)
  (SLIDE-TEXT 190 140 "CSV-LOAD" 6)
  (SLIDE-TEXT 190 125 "CSV-LOADH" 6)
  (SLIDE-TEXT 190 110 "CSV-GET" 6)

  (SLIDE-BOX 340 80 120 80)
  (SLIDE-TEXT 350 140 "DRAW-SCHUETZ" 5)
  (SLIDE-TEXT 350 125 "DRAW-SCHALTER" 5)
  (SLIDE-TEXT 350 110 "DRAW-MOTOR" 5)
  (SLIDE-TEXT 350 95 "..." 6)

  (SLIDE-BOX 500 80 120 80)
  (SLIDE-TEXT 510 140 "C:SCHALTGEN" 5)
  (SLIDE-TEXT 510 125 "C:SCHALTONE" 5)
  (SLIDE-TEXT 510 110 "SCHALT-PROCESS" 5)

  ;; Arrows down
  (command "COLOR" 8)
  (SLIDE-ARROW 240 200 240 160)
  (SLIDE-ARROW 400 200 400 160)
  (SLIDE-ARROW 560 200 560 160)

  ;; Legend
  (command "COLOR" 2)
  (SLIDE-BOX 50 50 15 15)
  (command "COLOR" 7)
  (SLIDE-TEXT 70 55 "= Auto-loaded at startup" 6)

  (command "COLOR" 3)
  (SLIDE-BOX 50 70 15 15)
  (command "COLOR" 7)
  (SLIDE-TEXT 70 75 "= Loaded by (load ...)" 6)
)

;;; ============================================
;;; SLIDE 3: LOAD SEQUENCE
;;; ============================================

(defun SLIDE-3-SEQUENCE ()
  (NEW-SLIDE
    "Load Sequence"
    "Step-by-step: What happens when AutoCAD starts")

  ;; Timeline
  (command "COLOR" 7)
  (SLIDE-LINE 100 380 700 380)
  (SLIDE-TEXT 720 375 "time" 6)

  ;; Step 1
  (command "COLOR" 3)
  (SLIDE-CIRCLE 150 380 10)
  (SLIDE-TEXT 140 395 "1" 8)
  (SLIDE-BOX 110 280 80 80)
  (SLIDE-TEXT 115 340 "AutoCAD" 6)
  (SLIDE-TEXT 120 325 "Starts" 6)
  (SLIDE-ARROW 150 360 150 280)

  ;; Step 2
  (command "COLOR" 2)
  (SLIDE-CIRCLE 270 380 10)
  (SLIDE-TEXT 260 395 "2" 8)
  (SLIDE-BOX 230 280 80 80)
  (SLIDE-TEXT 235 340 "ACAD.LSP" 6)
  (SLIDE-TEXT 235 325 "loaded" 6)
  (SLIDE-ARROW 270 360 270 280)

  ;; Step 3
  (command "COLOR" 9)
  (SLIDE-CIRCLE 390 380 10)
  (SLIDE-TEXT 380 395 "3" 8)
  (SLIDE-BOX 340 280 100 80)
  (SLIDE-TEXT 345 340 "(load" 6)
  (SLIDE-TEXT 350 325 "\"CSVREAD\")" 6)
  (SLIDE-ARROW 390 360 390 280)

  ;; Step 4
  (command "COLOR" 9)
  (SLIDE-CIRCLE 510 380 10)
  (SLIDE-TEXT 500 395 "4" 8)
  (SLIDE-BOX 460 280 100 80)
  (SLIDE-TEXT 465 340 "(load" 6)
  (SLIDE-TEXT 470 325 "\"EBLOCKS\")" 6)
  (SLIDE-ARROW 510 360 510 280)

  ;; Step 5
  (command "COLOR" 9)
  (SLIDE-CIRCLE 630 380 10)
  (SLIDE-TEXT 620 395 "5" 8)
  (SLIDE-BOX 580 280 100 80)
  (SLIDE-TEXT 585 340 "(load" 6)
  (SLIDE-TEXT 590 325 "\"SCHALT\")" 6)
  (SLIDE-ARROW 630 360 630 280)

  ;; Result
  (command "COLOR" 3)
  (SLIDE-BOX 200 100 400 120)
  (SLIDE-TEXT 210 200 "READY!" 14)
  (SLIDE-TEXT 210 170 "All functions available:" 8)
  (SLIDE-TEXT 210 150 "SCHALTGEN, SCHALTONE, SCHUETZ," 6)
  (SLIDE-TEXT 210 135 "SCHALTER, KREUZSCH, MOTOR, etc." 6)

  ;; Arrows down
  (command "COLOR" 8)
  (SLIDE-ARROW 400 280 400 220)
)

;;; ============================================
;;; SLIDE 4: ACAD.LSP CONTENT
;;; ============================================

(defun SLIDE-4-ACAD ()
  (NEW-SLIDE
    "ACAD.LSP - The Startup File"
    "Automatically loaded when AutoCAD starts")

  ;; Code window
  (command "COLOR" 8)
  (SLIDE-BOX 50 80 700 320)

  ;; Code content
  (command "COLOR" 3)
  (SLIDE-TEXT 60 380 ";;; ACAD.LSP - AutoCAD Startup" 7)
  (command "COLOR" 8)
  (SLIDE-TEXT 60 365 ";;; Schmidt & Weber GmbH 1991" 7)

  (command "COLOR" 7)
  (SLIDE-TEXT 60 340 "(princ \"\\nLoading modules...\")" 7)

  (command "COLOR" 2)
  (SLIDE-TEXT 60 310 ";;; CSV-Funktionen laden" 7)
  (command "COLOR" 6)
  (SLIDE-TEXT 60 295 "(load \"CSVREAD\")" 8)

  (command "COLOR" 2)
  (SLIDE-TEXT 60 265 ";;; Elektrische Symbole laden" 7)
  (command "COLOR" 6)
  (SLIDE-TEXT 60 250 "(load \"EBLOCKS\")" 8)

  (command "COLOR" 2)
  (SLIDE-TEXT 60 220 ";;; Schaltplan-Generator laden" 7)
  (command "COLOR" 6)
  (SLIDE-TEXT 60 205 "(load \"SCHALT\")" 8)

  (command "COLOR" 7)
  (SLIDE-TEXT 60 175 "(princ \"\\nReady.\")" 7)
  (SLIDE-TEXT 60 160 "(princ)" 7)

  ;; Highlight box
  (command "COLOR" 3)
  (SLIDE-BOX 55 190 200 90)

  ;; Annotation
  (command "COLOR" 3)
  (SLIDE-ARROW 260 235 350 235)
  (SLIDE-TEXT 360 230 "These (load ...) calls" 7)
  (SLIDE-TEXT 360 215 "import other .LSP files" 7)
)

;;; ============================================
;;; SLIDE 5: CSVREAD.LSP CONTENT
;;; ============================================

(defun SLIDE-5-CSVREAD ()
  (NEW-SLIDE
    "CSVREAD.LSP - CSV Parser"
    "Reads component data from CSV files")

  ;; Code window
  (command "COLOR" 8)
  (SLIDE-BOX 50 150 350 250)

  (command "COLOR" 3)
  (SLIDE-TEXT 60 380 ";;; CSVREAD.LSP" 7)

  (command "COLOR" 7)
  (SLIDE-TEXT 60 355 "(defun CSV-LOAD (fname)" 7)
  (SLIDE-TEXT 70 340 ";;; Load entire CSV" 6)
  (SLIDE-TEXT 70 325 "(setq fh (open fname \"r\"))" 6)
  (SLIDE-TEXT 70 310 "..." 6)
  (SLIDE-TEXT 60 295 ")" 7)

  (SLIDE-TEXT 60 265 "(defun CSV-LOADH (fname)" 7)
  (SLIDE-TEXT 70 250 ";;; Load with headers" 6)
  (SLIDE-TEXT 70 235 "..." 6)
  (SLIDE-TEXT 60 220 ")" 7)

  (SLIDE-TEXT 60 190 "(defun CSV-GET (key alist)" 7)
  (SLIDE-TEXT 70 175 ";;; Get value by column" 6)
  (SLIDE-TEXT 60 160 ")" 7)

  ;; CSV file example
  (command "COLOR" 2)
  (SLIDE-BOX 450 250 300 150)
  (SLIDE-TEXT 460 385 "KOMPONEN.CSV" 8)

  (command "COLOR" 7)
  (SLIDE-TEXT 460 355 "TYP;BEZEICHNUNG;WERT" 6)
  (command "COLOR" 9)
  (SLIDE-TEXT 460 340 "SCHUETZ;K1;24V DC" 6)
  (SLIDE-TEXT 460 325 "SCHUETZ;K2;24V DC" 6)
  (SLIDE-TEXT 460 310 "RELAIS;K5;24V DC" 6)
  (SLIDE-TEXT 460 295 "MOTOR;M1;5.5kW" 6)
  (SLIDE-TEXT 460 280 "..." 6)

  ;; Arrow
  (command "COLOR" 3)
  (SLIDE-ARROW 400 280 450 320)
  (SLIDE-TEXT 405 260 "reads" 7)

  ;; Output example
  (command "COLOR" 3)
  (SLIDE-BOX 450 80 300 120)
  (SLIDE-TEXT 460 180 "Returns:" 7)
  (command "COLOR" 7)
  (SLIDE-TEXT 460 160 "((\"TYP\" . \"SCHUETZ\")" 6)
  (SLIDE-TEXT 465 145 "(\"BEZEICHNUNG\" . \"K1\")" 6)
  (SLIDE-TEXT 465 130 "(\"WERT\" . \"24V DC\"))" 6)

  (command "COLOR" 3)
  (SLIDE-ARROW 550 200 550 250)
)

;;; ============================================
;;; SLIDE 6: EBLOCKS.LSP CONTENT
;;; ============================================

(defun SLIDE-6-EBLOCKS ()
  (NEW-SLIDE
    "EBLOCKS.LSP - Electrical Symbols"
    "DIN-standard symbols for circuit diagrams")

  ;; Code window
  (command "COLOR" 8)
  (SLIDE-BOX 50 200 350 200)

  (command "COLOR" 3)
  (SLIDE-TEXT 60 380 ";;; EBLOCKS.LSP" 7)

  (command "COLOR" 7)
  (SLIDE-TEXT 60 355 "(defun DRAW-SCHUETZ (pt)" 7)
  (SLIDE-TEXT 70 340 "(command \"LINE\" ...)" 6)
  (SLIDE-TEXT 70 325 "(command \"ARC\" ...)" 6)
  (SLIDE-TEXT 60 310 ")" 7)

  (SLIDE-TEXT 60 280 "(defun DRAW-SCHALTER (pt)" 7)
  (SLIDE-TEXT 60 250 "(defun DRAW-MOTOR (pt)" 7)
  (SLIDE-TEXT 60 220 "(defun DRAW-RELAIS (pt)" 7)

  ;; Symbol previews
  (command "COLOR" 7)
  (SLIDE-TEXT 450 380 "Symbols:" 8)

  ;; Schuetz symbol
  (command "COLOR" 7)
  (SLIDE-BOX 450 280 60 80)
  (SLIDE-LINE 450 320 510 320)
  (SLIDE-LINE 480 280 480 260)
  (SLIDE-LINE 480 360 480 380)
  (SLIDE-TEXT 520 320 "Schuetz" 6)

  ;; Schalter symbol
  (SLIDE-CIRCLE 460 220 5)
  (SLIDE-CIRCLE 500 220 5)
  (SLIDE-LINE 465 220 490 235)
  (SLIDE-TEXT 520 220 "Schalter" 6)

  ;; Motor symbol
  (SLIDE-CIRCLE 480 150 25)
  (SLIDE-TEXT 470 155 "M" 10)
  (SLIDE-TEXT 520 150 "Motor" 6)

  ;; Relais symbol
  (SLIDE-BOX 460 80 40 50)
  (SLIDE-TEXT 468 110 "K" 8)
  (SLIDE-TEXT 520 100 "Relais" 6)
)

;;; ============================================
;;; SLIDE 7: SCHALT.LSP CONTENT
;;; ============================================

(defun SLIDE-7-SCHALT ()
  (NEW-SLIDE
    "SCHALT.LSP - The Main Generator"
    "Combines CSV data with symbols to create drawings")

  ;; Diagram showing flow
  (command "COLOR" 9)
  (SLIDE-BOX 50 280 150 100)
  (SLIDE-TEXT 60 360 "KOMPONEN.CSV" 7)
  (SLIDE-TEXT 70 340 "Component" 6)
  (SLIDE-TEXT 70 325 "data" 6)

  (command "COLOR" 3)
  (SLIDE-ARROW 200 330 280 330)
  (SLIDE-TEXT 210 350 "CSV-LOADH" 6)

  (command "COLOR" 2)
  (SLIDE-BOX 280 260 200 140)
  (SLIDE-TEXT 290 380 "SCHALT.LSP" 8)
  (SLIDE-TEXT 300 350 "SCHALT-PROCESS" 6)
  (SLIDE-TEXT 300 330 "loops through" 6)
  (SLIDE-TEXT 300 310 "each row..." 6)

  (command "COLOR" 3)
  (SLIDE-ARROW 480 330 560 330)
  (SLIDE-TEXT 490 350 "DRAW-*" 6)

  (command "COLOR" 9)
  (SLIDE-BOX 560 280 180 100)
  (SLIDE-TEXT 570 360 "AutoCAD Drawing" 7)
  (SLIDE-TEXT 580 340 "Lines, Circles," 6)
  (SLIDE-TEXT 580 325 "Text, Symbols" 6)

  ;; Code snippet
  (command "COLOR" 8)
  (SLIDE-BOX 100 80 600 140)

  (command "COLOR" 7)
  (SLIDE-TEXT 110 200 "(defun C:SCHALTGEN ()" 7)
  (SLIDE-TEXT 120 185 "(setq data (CSV-LOADH \"KOMPONEN.CSV\"))" 6)
  (command "COLOR" 6)
  (SLIDE-TEXT 120 170 "(foreach row data" 6)
  (SLIDE-TEXT 130 155 "(setq typ (CSV-GET \"TYP\" row))" 6)
  (SLIDE-TEXT 130 140 "(setq func (SCHALT-GETFUNC typ))" 6)
  (command "COLOR" 3)
  (SLIDE-TEXT 130 125 "(apply func (list pt 1.0 0.0))" 6)
  (command "COLOR" 7)
  (SLIDE-TEXT 120 110 ")" 6)
  (SLIDE-TEXT 110 95 ")" 6)
)

;;; ============================================
;;; SLIDE 8: THE COMPLETE WORKFLOW
;;; ============================================

(defun SLIDE-8-WORKFLOW ()
  (NEW-SLIDE
    "Complete Workflow"
    "From CSV to DWG - the 1991 automation pipeline")

  ;; Step boxes
  (command "COLOR" 9)

  ;; Step 1: dBase/Excel
  (SLIDE-BOX 30 300 100 80)
  (SLIDE-TEXT 40 360 "dBase III" 6)
  (SLIDE-TEXT 40 345 "or Excel" 6)
  (SLIDE-TEXT 50 320 "(BOM)" 6)

  ;; Arrow
  (command "COLOR" 7)
  (SLIDE-ARROW 130 340 170 340)
  (SLIDE-TEXT 135 360 "export" 5)

  ;; Step 2: CSV
  (command "COLOR" 2)
  (SLIDE-BOX 170 300 100 80)
  (SLIDE-TEXT 180 360 "KOMPONEN" 6)
  (SLIDE-TEXT 190 345 ".CSV" 8)

  ;; Arrow
  (command "COLOR" 7)
  (SLIDE-ARROW 270 340 310 340)

  ;; Step 3: AutoCAD
  (command "COLOR" 3)
  (SLIDE-BOX 310 280 180 120)
  (SLIDE-TEXT 320 380 "AutoCAD R10" 8)
  (SLIDE-TEXT 330 355 "CSVREAD.LSP" 6)
  (SLIDE-TEXT 330 340 "EBLOCKS.LSP" 6)
  (SLIDE-TEXT 330 325 "SCHALT.LSP" 6)
  (SLIDE-TEXT 330 300 "(SCHALTGEN)" 7)

  ;; Arrow
  (command "COLOR" 7)
  (SLIDE-ARROW 490 340 530 340)
  (SLIDE-TEXT 495 360 "batch" 5)

  ;; Step 4: DWG files
  (command "COLOR" 6)
  (SLIDE-BOX 530 280 120 120)
  (SLIDE-TEXT 540 380 "Output:" 7)
  (SLIDE-TEXT 550 355 "K1.DWG" 6)
  (SLIDE-TEXT 550 340 "K2.DWG" 6)
  (SLIDE-TEXT 550 325 "M1.DWG" 6)
  (SLIDE-TEXT 550 310 "..." 6)

  ;; Arrow to plotter
  (SLIDE-ARROW 650 340 690 340)

  ;; Step 5: Plotter
  (command "COLOR" 1)
  (SLIDE-BOX 690 300 80 80)
  (SLIDE-TEXT 700 360 "HP" 7)
  (SLIDE-TEXT 695 345 "Plotter" 7)
  (SLIDE-TEXT 700 320 "A0-A3" 6)

  ;; Bottom summary
  (command "COLOR" 7)
  (SLIDE-BOX 100 80 600 120)
  (SLIDE-TEXT 110 180 "Result: Hundreds of drawings generated automatically!" 8)
  (command "COLOR" 9)
  (SLIDE-TEXT 120 155 "- Each component gets its own DWG file" 6)
  (SLIDE-TEXT 120 140 "- Consistent symbols from EBLOCKS.LSP" 6)
  (SLIDE-TEXT 120 125 "- Data-driven: change CSV, regenerate all" 6)
  (SLIDE-TEXT 120 110 "- Hours of work reduced to minutes" 6)
)

;;; ============================================
;;; SLIDE 9: MODERN RECREATION
;;; ============================================

(defun SLIDE-9-MODERN ()
  (NEW-SLIDE
    "rust-autolisp: Modern Recreation"
    "Running authentic 1991 code in 2024")

  ;; Comparison
  (command "COLOR" 8)
  (SLIDE-LINE 400 380 400 80)

  ;; Left: 1991
  (command "COLOR" 2)
  (SLIDE-TEXT 100 380 "1991 Original" 10)

  (command "COLOR" 7)
  (SLIDE-TEXT 60 340 "- AutoCAD R9/R10" 7)
  (SLIDE-TEXT 60 320 "- MS-DOS 5.0" 7)
  (SLIDE-TEXT 60 300 "- 386/486 PC" 7)
  (SLIDE-TEXT 60 280 "- 4 MB RAM" 7)
  (SLIDE-TEXT 60 260 "- Real .DWG output" 7)
  (SLIDE-TEXT 60 240 "- HP Plotter" 7)

  ;; Right: 2024
  (command "COLOR" 3)
  (SLIDE-TEXT 500 380 "2024 rust-autolisp" 10)

  (command "COLOR" 7)
  (SLIDE-TEXT 460 340 "- Rust interpreter" 7)
  (SLIDE-TEXT 460 320 "- Any OS" 7)
  (SLIDE-TEXT 460 300 "- Same .LSP files!" 7)
  (SLIDE-TEXT 460 280 "- SVG/JSON output" 7)
  (SLIDE-TEXT 460 260 "- Browser preview" 7)
  (SLIDE-TEXT 460 240 "- Educational tool" 7)

  ;; Bottom
  (command "COLOR" 3)
  (SLIDE-BOX 150 80 500 100)
  (SLIDE-TEXT 160 160 "The LISP files are 100% authentic!" 9)
  (command "COLOR" 9)
  (SLIDE-TEXT 170 130 "CSVREAD.LSP, EBLOCKS.LSP, SCHALT.LSP" 7)
  (SLIDE-TEXT 170 110 "would run unchanged on real AutoCAD R10" 7)
)

;;; ============================================
;;; SLIDE 10: THANK YOU
;;; ============================================

(defun SLIDE-10-END ()
  (NEW-SLIDE
    "Summary"
    "The power of AutoLISP imports")

  ;; Key points
  (command "COLOR" 3)
  (SLIDE-CIRCLE 80 350 15)
  (SLIDE-TEXT 90 355 "1" 10)
  (command "COLOR" 7)
  (SLIDE-TEXT 110 350 "ACAD.LSP auto-loads at startup" 8)

  (command "COLOR" 3)
  (SLIDE-CIRCLE 80 300 15)
  (SLIDE-TEXT 90 305 "2" 10)
  (command "COLOR" 7)
  (SLIDE-TEXT 110 300 "(load \"filename\") imports other .LSP files" 8)

  (command "COLOR" 3)
  (SLIDE-CIRCLE 80 250 15)
  (SLIDE-TEXT 90 255 "3" 10)
  (command "COLOR" 7)
  (SLIDE-TEXT 110 250 "Functions from loaded files become available" 8)

  (command "COLOR" 3)
  (SLIDE-CIRCLE 80 200 15)
  (SLIDE-TEXT 90 205 "4" 10)
  (command "COLOR" 7)
  (SLIDE-TEXT 110 200 "Modular design = reusable components" 8)

  (command "COLOR" 3)
  (SLIDE-CIRCLE 80 150 15)
  (SLIDE-TEXT 90 155 "5" 10)
  (command "COLOR" 7)
  (SLIDE-TEXT 110 150 "Data-driven automation saves time" 8)

  ;; Footer
  (command "COLOR" 2)
  (SLIDE-BOX 200 60 400 50)
  (command "COLOR" 7)
  (SLIDE-TEXT 250 90 "Thank you for watching!" 10)
)

;;; ============================================
;;; MAIN: GENERATE ALL SLIDES
;;; ============================================

(princ "\n")
(princ "╔════════════════════════════════════════════════════════════════╗\n")
(princ "║          AUTOLISP IMPORT SYSTEM - SLIDESHOW                    ║\n")
(princ "║                                                                ║\n")
(princ "║   Generating 10 slides about .LSP imports...                   ║\n")
(princ "╚════════════════════════════════════════════════════════════════╝\n")
(princ "\n")

(princ "Generating Slide 1: Title...\n")
(SLIDE-1-TITLE)

(princ "Generating Slide 2: Dependency Tree...\n")
(SLIDE-2-DEPS)

(princ "Generating Slide 3: Load Sequence...\n")
(SLIDE-3-SEQUENCE)

(princ "Generating Slide 4: ACAD.LSP...\n")
(SLIDE-4-ACAD)

(princ "Generating Slide 5: CSVREAD.LSP...\n")
(SLIDE-5-CSVREAD)

(princ "Generating Slide 6: EBLOCKS.LSP...\n")
(SLIDE-6-EBLOCKS)

(princ "Generating Slide 7: SCHALT.LSP...\n")
(SLIDE-7-SCHALT)

(princ "Generating Slide 8: Complete Workflow...\n")
(SLIDE-8-WORKFLOW)

(princ "Generating Slide 9: Modern Recreation...\n")
(SLIDE-9-MODERN)

(princ "Generating Slide 10: Summary...\n")
(SLIDE-10-END)

(princ "\n")
(princ "╔════════════════════════════════════════════════════════════════╗\n")
(princ "║                 SLIDESHOW COMPLETE!                            ║\n")
(princ "╠════════════════════════════════════════════════════════════════╣\n")
(princ "║   10 slides generated                                          ║\n")
(princ "║   Output: output/SLIDES.svg                                    ║\n")
(princ "║                                                                ║\n")
(princ "║   Open the SVG in a browser to view the slideshow!             ║\n")
(princ "╚════════════════════════════════════════════════════════════════╝\n")
(princ)
