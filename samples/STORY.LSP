; STORY.LSP - How We Did It: AutoLISP Schaltplan Generation
; The technical workflow from 1991, now running in Rust
; English narrative with authentic German terms

(setq *FRAME-WIDTH* 400)
(setq *FRAME-HEIGHT* 300)
(setq *FRAME-Y* 0)

(defun NEXT-FRAME (title / y)
  (setq y *FRAME-Y*)
  (command "LINE" (list 0 y) (list *FRAME-WIDTH* y) "")
  (command "LINE" (list *FRAME-WIDTH* y) (list *FRAME-WIDTH* (+ y *FRAME-HEIGHT*)) "")
  (command "LINE" (list *FRAME-WIDTH* (+ y *FRAME-HEIGHT*)) (list 0 (+ y *FRAME-HEIGHT*)) "")
  (command "LINE" (list 0 (+ y *FRAME-HEIGHT*)) (list 0 y) "")
  (command "TEXT" (list 20 (+ y 270)) 10 0 title)
  (setq *FRAME-Y* (+ *FRAME-Y* *FRAME-HEIGHT* 20))
  y
)

(defun TXT (x y h txt)
  (command "TEXT" (list x y) h 0 txt)
)

; ============================================
; FRAME 1: Title
; ============================================
(defun FRAME-01 ()
  (setq y (NEXT-FRAME ""))
  (TXT 60 (+ y 200) 14 "Schaltplan Generation")
  (TXT 100 (+ y 170) 10 "with AutoLISP")
  (TXT 50 (+ y 120) 8 "How we automated CAD in 1991")
  (TXT 80 (+ y 80) 6 "Elektrotechnik Trahe GmbH")
  (TXT 90 (+ y 60) 5 "Unterneukirchen, Bayern")
)

; ============================================
; FRAME 2: The Challenge
; ============================================
(defun FRAME-02 ()
  (setq y (NEXT-FRAME "The Challenge"))
  (TXT 20 (+ y 230) 7 "We needed hundreds of Schaltplaene")
  (TXT 20 (+ y 210) 7 "(electrical circuit diagrams)")
  (TXT 20 (+ y 180) 7 "Each one: Schuetz, Motor, Sicherung,")
  (TXT 20 (+ y 160) 7 "Motorschutzschalter, Klemmen...")
  (TXT 20 (+ y 120) 7 "Drawing each by hand?")
  (TXT 20 (+ y 100) 10 "Impossible.")
  (TXT 20 (+ y 60) 6 "We needed automation.")
)

; ============================================
; FRAME 3: The Data - CSV
; ============================================
(defun FRAME-03 ()
  (setq y (NEXT-FRAME "The Data: Komponentenliste"))
  ; CSV box
  (command "LINE" (list 20 (+ y 80)) (list 380 (+ y 80)) "")
  (command "LINE" (list 380 (+ y 80)) (list 380 (+ y 230)) "")
  (command "LINE" (list 380 (+ y 230)) (list 20 (+ y 230)) "")
  (command "LINE" (list 20 (+ y 230)) (list 20 (+ y 80)) "")
  (TXT 25 (+ y 215) 5 "START;MOTOR_ST;01-K1")
  (TXT 25 (+ y 200) 5 "K1;Schuetz;LC1-D18;Telemecanique")
  (TXT 25 (+ y 185) 5 "Q1;Motorschutzschalter;GV2-M14")
  (TXT 25 (+ y 170) 5 "F1;Sicherung;10A;gL")
  (TXT 25 (+ y 155) 5 "STOP")
  (TXT 25 (+ y 135) 5 "START;STERN_DR;02-K1")
  (TXT 25 (+ y 120) 5 "K1;Hauptschuetz;LC1-D25")
  (TXT 25 (+ y 105) 5 "K2;Sternschuetz;LC1-D18")
  (TXT 25 (+ y 90) 5 "...")
  (TXT 20 (+ y 55) 6 "Semicolon-delimited, German style")
)

; ============================================
; FRAME 4: CSV Format Explained
; ============================================
(defun FRAME-04 ()
  (setq y (NEXT-FRAME "CSV Format"))
  (TXT 20 (+ y 230) 7 "START ; TPL_NAME ; DRAWING_NAME")
  (TXT 40 (+ y 210) 6 "-> Begin new Schaltplan")
  (TXT 40 (+ y 195) 6 "-> Which template to use")
  (TXT 40 (+ y 180) 6 "-> Output filename")
  (TXT 20 (+ y 150) 7 "COMPONENT ; TYPE ; VALUE ; EXTRA")
  (TXT 40 (+ y 130) 6 "-> 5-12 lines per drawing")
  (TXT 20 (+ y 100) 7 "STOP")
  (TXT 40 (+ y 80) 6 "-> End of this Schaltplan")
  (TXT 20 (+ y 50) 6 "Exported from dBase III or Excel")
)

; ============================================
; FRAME 5: Templates (TPL)
; ============================================
(defun FRAME-05 ()
  (setq y (NEXT-FRAME "The Templates: TPL"))
  (TXT 20 (+ y 230) 7 "Each TPL defines a Schaltplan type:")
  (TXT 30 (+ y 200) 6 "MOTOR_ST - Motorstarter")
  (TXT 50 (+ y 185) 5 "Direct start with contactor")
  (TXT 30 (+ y 160) 6 "STERN_DR - Stern-Dreieck")
  (TXT 50 (+ y 145) 5 "Star-delta motor starter")
  (TXT 30 (+ y 120) 6 "WENDE   - Wendeschuetz")
  (TXT 50 (+ y 105) 5 "Reversing contactor circuit")
  (TXT 30 (+ y 80) 6 "DIREKT  - Direktanlauf")
  (TXT 50 (+ y 65) 5 "Simple direct-on-line")
  (TXT 20 (+ y 40) 5 "Each TPL is a .LSP file with drawing code")
)

; ============================================
; FRAME 6: The TPL Code
; ============================================
(defun FRAME-06 ()
  (setq y (NEXT-FRAME "Inside a TPL File"))
  ; Code box
  (command "LINE" (list 15 (+ y 60)) (list 385 (+ y 60)) "")
  (command "LINE" (list 385 (+ y 60)) (list 385 (+ y 240)) "")
  (command "LINE" (list 385 (+ y 240)) (list 15 (+ y 240)) "")
  (command "LINE" (list 15 (+ y 240)) (list 15 (+ y 60)) "")
  (TXT 20 (+ y 225) 5 "; MOTOR_ST.LSP")
  (TXT 20 (+ y 210) 5 "(defun MOTOR-ST-DRAW (data)")
  (TXT 20 (+ y 195) 5 "  ; Draw 3-phase power rails")
  (TXT 20 (+ y 180) 5 "  (DRAW-RAILS 50 100 150)")
  (TXT 20 (+ y 165) 5 "  ; Insert Schuetz symbol")
  (TXT 20 (+ y 150) 5 "  (INSERT-SCHUETZ K1-POS)")
  (TXT 20 (+ y 135) 5 "  ; Insert Motorschutz")
  (TXT 20 (+ y 120) 5 "  (INSERT-MOTORSCHUTZ Q1-POS)")
  (TXT 20 (+ y 105) 5 "  ; Draw Motor symbol")
  (TXT 20 (+ y 90) 5 "  (DRAW-MOTOR M-POS)")
  (TXT 20 (+ y 75) 5 "  ; Add labels from CSV")
  (TXT 20 (+ y 65) 5 "  (LABEL-COMPONENTS data))")
)

; ============================================
; FRAME 7: The Symbols - DIN
; ============================================
(defun FRAME-07 ()
  (setq y (NEXT-FRAME "DIN Symbols"))
  (TXT 20 (+ y 230) 6 "All symbols follow DIN standards:")
  ; Schuetz symbol
  (command "LINE" (list 40 (+ y 180)) (list 40 (+ y 200)) "")
  (command "LINE" (list 40 (+ y 180)) (list 50 (+ y 170)) "")
  (command "LINE" (list 50 (+ y 170)) (list 50 (+ y 160)) "")
  (TXT 60 (+ y 175) 5 "Schuetz (Contactor)")
  ; Motor symbol
  (command "CIRCLE" (list 40 (+ y 120)) 15)
  (TXT 35 (+ y 115) 6 "M")
  (TXT 60 (+ y 115) 5 "Motor")
  ; Sicherung symbol
  (command "LINE" (list 30 (+ y 75)) (list 50 (+ y 75)) "")
  (command "LINE" (list 35 (+ y 70)) (list 35 (+ y 80)) "")
  (command "LINE" (list 35 (+ y 70)) (list 45 (+ y 80)) "")
  (command "LINE" (list 45 (+ y 70)) (list 45 (+ y 80)) "")
  (TXT 60 (+ y 72) 5 "Sicherung (Fuse)")
)

; ============================================
; FRAME 8: The Generation Process
; ============================================
(defun FRAME-08 ()
  (setq y (NEXT-FRAME "The Process"))
  (TXT 20 (+ y 220) 6 "1. Load CSV-LOADH function")
  (TXT 20 (+ y 200) 6 "2. Parse START/STOP blocks")
  (TXT 20 (+ y 180) 6 "3. For each block:")
  (TXT 40 (+ y 160) 5 "- Load TPL file")
  (TXT 40 (+ y 145) 5 "- Call TPL-DRAW with component data")
  (TXT 40 (+ y 130) 5 "- TPL draws the Grundschaltung")
  (TXT 40 (+ y 115) 5 "- Insert component symbols")
  (TXT 40 (+ y 100) 5 "- Add labels and Bezeichnungen")
  (TXT 40 (+ y 85) 5 "- Save as DWG")
  (TXT 40 (+ y 70) 5 "- Send to Druckwarteschlange")
  (TXT 20 (+ y 45) 6 "4. Next drawing...")
)

; ============================================
; FRAME 9: Show a Schaltplan
; ============================================
(defun FRAME-09 ()
  (setq y (NEXT-FRAME "Result: Schaltplan"))
  ; Three phase lines L1 L2 L3
  (command "LINE" (list 80 (+ y 230)) (list 80 (+ y 70)) "")
  (command "LINE" (list 150 (+ y 230)) (list 150 (+ y 70)) "")
  (command "LINE" (list 220 (+ y 230)) (list 220 (+ y 70)) "")
  (TXT 75 (+ y 240) 5 "L1")
  (TXT 145 (+ y 240) 5 "L2")
  (TXT 215 (+ y 240) 5 "L3")
  ; Sicherung F1
  (command "LINE" (list 75 (+ y 210)) (list 85 (+ y 210)) "")
  (command "LINE" (list 145 (+ y 210)) (list 155 (+ y 210)) "")
  (command "LINE" (list 215 (+ y 210)) (list 225 (+ y 210)) "")
  (TXT 240 (+ y 207) 5 "F1")
  ; Schuetz K1 - NO contacts
  (command "CIRCLE" (list 80 (+ y 175)) 6)
  (command "CIRCLE" (list 150 (+ y 175)) 6)
  (command "CIRCLE" (list 220 (+ y 175)) 6)
  (TXT 240 (+ y 172) 5 "K1")
  ; Motorschutz Q1
  (command "LINE" (list 75 (+ y 145)) (list 85 (+ y 135)) "")
  (command "LINE" (list 145 (+ y 145)) (list 155 (+ y 135)) "")
  (command "LINE" (list 215 (+ y 145)) (list 225 (+ y 135)) "")
  (TXT 240 (+ y 137) 5 "Q1")
  ; Motor M1
  (command "CIRCLE" (list 150 (+ y 95)) 20)
  (TXT 143 (+ y 90) 8 "M")
  (command "LINE" (list 80 (+ y 125)) (list 80 (+ y 115)) "")
  (command "LINE" (list 80 (+ y 115)) (list 130 (+ y 95)) "")
  (command "LINE" (list 150 (+ y 125)) (list 150 (+ y 115)) "")
  (command "LINE" (list 220 (+ y 125)) (list 220 (+ y 115)) "")
  (command "LINE" (list 220 (+ y 115)) (list 170 (+ y 95)) "")
  ; Title block
  (command "LINE" (list 280 (+ y 50)) (list 380 (+ y 50)) "")
  (command "LINE" (list 380 (+ y 50)) (list 380 (+ y 80)) "")
  (command "LINE" (list 380 (+ y 80)) (list 280 (+ y 80)) "")
  (command "LINE" (list 280 (+ y 80)) (list 280 (+ y 50)) "")
  (TXT 285 (+ y 65) 4 "01-K1")
  (TXT 285 (+ y 55) 3 "MOTOR_ST")
)

; ============================================
; FRAME 10: Batch Processing
; ============================================
(defun FRAME-10 ()
  (setq y (NEXT-FRAME "Batch Processing"))
  (TXT 20 (+ y 220) 6 "One CSV file = many drawings")
  ; Progress display
  (command "LINE" (list 30 (+ y 120)) (list 370 (+ y 120)) "")
  (command "LINE" (list 370 (+ y 120)) (list 370 (+ y 190)) "")
  (command "LINE" (list 370 (+ y 190)) (list 30 (+ y 190)) "")
  (command "LINE" (list 30 (+ y 190)) (list 30 (+ y 120)) "")
  (TXT 35 (+ y 175) 5 "Processing: KOMPONENTEN.CSV")
  (TXT 35 (+ y 160) 5 "[=====>                  ] 23%")
  (TXT 35 (+ y 145) 5 "Drawing: 05-K1 (MOTOR_ST)")
  (TXT 35 (+ y 130) 5 "Entities: 47  |  Queue: 4 jobs")
  (TXT 20 (+ y 95) 6 "We would start it, go for Kaffee,")
  (TXT 20 (+ y 75) 6 "come back to stack of printed plans")
)

; ============================================
; FRAME 11: The Print Queue
; ============================================
(defun FRAME-11 ()
  (setq y (NEXT-FRAME "Druckwarteschlange"))
  (TXT 20 (+ y 220) 6 "Print queue written in Turbo Pascal")
  ; Queue display
  (command "LINE" (list 30 (+ y 100)) (list 250 (+ y 100)) "")
  (command "LINE" (list 250 (+ y 100)) (list 250 (+ y 195)) "")
  (command "LINE" (list 250 (+ y 195)) (list 30 (+ y 195)) "")
  (command "LINE" (list 30 (+ y 195)) (list 30 (+ y 100)) "")
  (TXT 35 (+ y 180) 5 "PRINTQ v1.0")
  (TXT 35 (+ y 165) 5 "[1] 01-K1.DWG  PRINTING...")
  (TXT 35 (+ y 150) 5 "[2] 02-K1.DWG  WAITING")
  (TXT 35 (+ y 135) 5 "[3] 03-K1.DWG  WAITING")
  (TXT 35 (+ y 120) 5 "[4] 04-S1.DWG  WAITING")
  (TXT 35 (+ y 105) 5 "[5] 05-K1.DWG  WAITING")
  ; Printer
  (command "LINE" (list 280 (+ y 130)) (list 370 (+ y 130)) "")
  (command "LINE" (list 370 (+ y 130)) (list 370 (+ y 180)) "")
  (command "LINE" (list 370 (+ y 180)) (list 280 (+ y 180)) "")
  (command "LINE" (list 280 (+ y 180)) (list 280 (+ y 130)) "")
  (TXT 290 (+ y 150) 5 "HP LaserJet")
  (TXT 300 (+ y 138) 4 "III")
  (TXT 20 (+ y 70) 6 "AutoCAD did not wait for printer")
  (TXT 20 (+ y 50) 6 "Queue kept it fed continuously")
)

; ============================================
; FRAME 12: Now in Rust
; ============================================
(defun FRAME-12 ()
  (setq y (NEXT-FRAME "2024: rust-autolisp"))
  (TXT 20 (+ y 220) 6 "Same engine, new implementation")
  (TXT 20 (+ y 190) 5 "// Load and execute AutoLISP")
  (TXT 20 (+ y 175) 5 "let mut engine = SchaltplanEngine::new();")
  (TXT 20 (+ y 160) 5 "engine.load_template(\"MOTOR_ST\", code);")
  (TXT 20 (+ y 145) 5 "let specs = engine.process_csv(data);")
  (TXT 20 (+ y 130) 5 "engine.generate_all(&specs);")
  (TXT 20 (+ y 100) 6 "Output: SVG, JSON")
  (TXT 20 (+ y 80) 6 "The same workflow,")
  (TXT 20 (+ y 60) 6 "33 years later")
)

; ============================================
; FRAME 13: This Slideshow
; ============================================
(defun FRAME-13 ()
  (setq y (NEXT-FRAME "This Slideshow"))
  (TXT 20 (+ y 210) 6 "What you are watching right now:")
  (TXT 30 (+ y 180) 5 "1. STORY.LSP - AutoLISP source code")
  (TXT 30 (+ y 160) 5 "2. cargo run -- samples/STORY.LSP")
  (TXT 30 (+ y 140) 5 "3. rust-autolisp executes the LISP")
  (TXT 30 (+ y 120) 5 "4. Generates STORY.json (248 entities)")
  (TXT 30 (+ y 100) 5 "5. HTML viewer renders each frame")
  (TXT 20 (+ y 60) 7 "Not a slideshow of images.")
  (TXT 20 (+ y 40) 7 "Generated by code. Live.")
)

; ============================================
; MAIN
; ============================================
(defun C:STORY ()
  (princ "\n=== Generating Story ===\n")
  (FRAME-01) (princ "1 ")
  (FRAME-02) (princ "2 ")
  (FRAME-03) (princ "3 ")
  (FRAME-04) (princ "4 ")
  (FRAME-05) (princ "5 ")
  (FRAME-06) (princ "6 ")
  (FRAME-07) (princ "7 ")
  (FRAME-08) (princ "8 ")
  (FRAME-09) (princ "9 ")
  (FRAME-10) (princ "10 ")
  (FRAME-11) (princ "11 ")
  (FRAME-12) (princ "12 ")
  (FRAME-13) (princ "13 ")
  (princ "\n=== Done! ===\n")
)

(C:STORY)
