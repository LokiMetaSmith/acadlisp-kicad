;;; RENDER.LSP - Complete Pipeline Visualization
;;; Shows: LSP Code → CSV Data → Rendered Output
;;;
;;; This creates a 3-panel display:
;;;   Panel 1: The AutoLISP source code (syntax highlighted)
;;;   Panel 2: The CSV data being imported
;;;   Panel 3: The actual rendered electrical symbols
;;;

;;; ============================================
;;; CONFIGURATION
;;; ============================================

(setq *PANEL-W* 600)
(setq *PANEL-H* 800)
(setq *PANEL-GAP* 50)
(setq *CODE-LINE-H* 14)

;;; ============================================
;;; PANEL 1: LSP SOURCE CODE DISPLAY
;;; ============================================

(defun DRAW-CODE-PANEL (x y)
  "Draw the LSP source code panel with syntax highlighting"

  ;; Panel frame
  (command "COLOR" 9)
  (command "LINE"
    (list x y)
    (list (+ x *PANEL-W*) y)
    (list (+ x *PANEL-W*) (+ y *PANEL-H*))
    (list x (+ y *PANEL-H*))
    "C")

  ;; Title bar
  (command "COLOR" 4)
  (command "LINE"
    (list x (+ y (- *PANEL-H* 40)))
    (list (+ x *PANEL-W*) (+ y (- *PANEL-H* 40)))
    (list (+ x *PANEL-W*) (+ y *PANEL-H*))
    (list x (+ y *PANEL-H*))
    "C")

  (command "COLOR" 7)
  (command "TEXT" (list (+ x 15) (+ y (- *PANEL-H* 28))) 12 0 "SCHALT.LSP - AutoLISP Source Code")

  ;; Code background (dark)
  (command "COLOR" 250)
  (command "LINE"
    (list (+ x 5) (+ y 5))
    (list (+ x (- *PANEL-W* 5)) (+ y 5))
    (list (+ x (- *PANEL-W* 5)) (+ y (- *PANEL-H* 45)))
    (list (+ x 5) (+ y (- *PANEL-H* 45)))
    "C")

  ;; Line numbers column
  (command "COLOR" 8)
  (command "LINE"
    (list (+ x 40) (+ y 5))
    (list (+ x 40) (+ y (- *PANEL-H* 45)))
    "")

  ;; Code content with syntax highlighting
  (setq line-y (+ y (- *PANEL-H* 65)))
  (setq line-num 1)

  ;; Comment - green
  (command "COLOR" 3)
  (command "TEXT" (list (+ x 10) line-y) 5 0 (itoa line-num))
  (command "TEXT" (list (+ x 50) line-y) 6 0 ";;; SCHALT.LSP - Schaltplan Generator")
  (setq line-y (- line-y *CODE-LINE-H*))
  (setq line-num (1+ line-num))

  (command "TEXT" (list (+ x 10) line-y) 5 0 (itoa line-num))
  (command "TEXT" (list (+ x 50) line-y) 6 0 ";;; Schmidt & Weber GmbH 1991")
  (setq line-y (- line-y *CODE-LINE-H*))
  (setq line-num (1+ line-num))

  ;; Empty line
  (command "COLOR" 8)
  (command "TEXT" (list (+ x 10) line-y) 5 0 (itoa line-num))
  (setq line-y (- line-y *CODE-LINE-H*))
  (setq line-num (1+ line-num))

  ;; Setq - keyword in blue, string in yellow
  (command "COLOR" 8)
  (command "TEXT" (list (+ x 10) line-y) 5 0 (itoa line-num))
  (command "COLOR" 5)
  (command "TEXT" (list (+ x 50) line-y) 6 0 "(setq")
  (command "COLOR" 6)
  (command "TEXT" (list (+ x 90) line-y) 6 0 "*SCHALT-TYPES*")
  (setq line-y (- line-y *CODE-LINE-H*))
  (setq line-num (1+ line-num))

  ;; List opening
  (command "COLOR" 8)
  (command "TEXT" (list (+ x 10) line-y) 5 0 (itoa line-num))
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 50) line-y) 6 0 "  (list")
  (setq line-y (- line-y *CODE-LINE-H*))
  (setq line-num (1+ line-num))

  ;; Cons pairs - string in yellow, symbol in cyan
  (command "COLOR" 8)
  (command "TEXT" (list (+ x 10) line-y) 5 0 (itoa line-num))
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 50) line-y) 6 0 "    (cons")
  (command "COLOR" 2)
  (command "TEXT" (list (+ x 100) line-y) 6 0 "\"SCHUETZ\"")
  (command "COLOR" 6)
  (command "TEXT" (list (+ x 175) line-y) 6 0 "'DRAW-SCHUETZ)")
  (setq line-y (- line-y *CODE-LINE-H*))
  (setq line-num (1+ line-num))

  (command "COLOR" 8)
  (command "TEXT" (list (+ x 10) line-y) 5 0 (itoa line-num))
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 50) line-y) 6 0 "    (cons")
  (command "COLOR" 2)
  (command "TEXT" (list (+ x 100) line-y) 6 0 "\"SCHALTER\"")
  (command "COLOR" 6)
  (command "TEXT" (list (+ x 185) line-y) 6 0 "'DRAW-SCHALTER)")
  (setq line-y (- line-y *CODE-LINE-H*))
  (setq line-num (1+ line-num))

  (command "COLOR" 8)
  (command "TEXT" (list (+ x 10) line-y) 5 0 (itoa line-num))
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 50) line-y) 6 0 "    (cons")
  (command "COLOR" 2)
  (command "TEXT" (list (+ x 100) line-y) 6 0 "\"MOTOR\"")
  (command "COLOR" 6)
  (command "TEXT" (list (+ x 160) line-y) 6 0 "'DRAW-MOTOR)")
  (setq line-y (- line-y *CODE-LINE-H*))
  (setq line-num (1+ line-num))

  ;; Close list
  (command "COLOR" 8)
  (command "TEXT" (list (+ x 10) line-y) 5 0 (itoa line-num))
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 50) line-y) 6 0 "  ))")
  (setq line-y (- line-y (* *CODE-LINE-H* 2)))
  (setq line-num (1+ line-num))

  ;; Defun - function definition
  (command "COLOR" 8)
  (command "TEXT" (list (+ x 10) line-y) 5 0 (itoa line-num))
  (command "COLOR" 5)
  (command "TEXT" (list (+ x 50) line-y) 6 0 "(defun")
  (command "COLOR" 6)
  (command "TEXT" (list (+ x 100) line-y) 6 0 "SCHALT-PROCESS")
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 210) line-y) 6 0 "(row idx)")
  (setq line-y (- line-y *CODE-LINE-H*))
  (setq line-num (1+ line-num))

  ;; Function body
  (command "COLOR" 3)
  (command "TEXT" (list (+ x 10) line-y) 5 0 (itoa line-num))
  (command "TEXT" (list (+ x 50) line-y) 6 0 "  ;; Get component type from CSV row")
  (setq line-y (- line-y *CODE-LINE-H*))
  (setq line-num (1+ line-num))

  (command "COLOR" 8)
  (command "TEXT" (list (+ x 10) line-y) 5 0 (itoa line-num))
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 50) line-y) 6 0 "  (")
  (command "COLOR" 5)
  (command "TEXT" (list (+ x 58) line-y) 6 0 "setq")
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 90) line-y) 6 0 "typ (CSV-GET")
  (command "COLOR" 2)
  (command "TEXT" (list (+ x 185) line-y) 6 0 "\"TYP\"")
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 225) line-y) 6 0 "row))")
  (setq line-y (- line-y *CODE-LINE-H*))
  (setq line-num (1+ line-num))

  (command "COLOR" 8)
  (command "TEXT" (list (+ x 10) line-y) 5 0 (itoa line-num))
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 50) line-y) 6 0 "  (")
  (command "COLOR" 5)
  (command "TEXT" (list (+ x 58) line-y) 6 0 "setq")
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 90) line-y) 6 0 "bezeich (CSV-GET")
  (command "COLOR" 2)
  (command "TEXT" (list (+ x 210) line-y) 6 0 "\"BEZEICHNUNG\"")
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 310) line-y) 6 0 "row))")
  (setq line-y (- line-y *CODE-LINE-H*))
  (setq line-num (1+ line-num))

  ;; More code...
  (command "COLOR" 3)
  (command "TEXT" (list (+ x 10) line-y) 5 0 (itoa line-num))
  (command "TEXT" (list (+ x 50) line-y) 6 0 "  ;; Find drawing function for type")
  (setq line-y (- line-y *CODE-LINE-H*))
  (setq line-num (1+ line-num))

  (command "COLOR" 8)
  (command "TEXT" (list (+ x 10) line-y) 5 0 (itoa line-num))
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 50) line-y) 6 0 "  (")
  (command "COLOR" 5)
  (command "TEXT" (list (+ x 58) line-y) 6 0 "setq")
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 90) line-y) 6 0 "func (SCHALT-GETFUNC typ))")
  (setq line-y (- line-y *CODE-LINE-H*))
  (setq line-num (1+ line-num))

  (command "COLOR" 3)
  (command "TEXT" (list (+ x 10) line-y) 5 0 (itoa line-num))
  (command "TEXT" (list (+ x 50) line-y) 6 0 "  ;; Call the drawing function")
  (setq line-y (- line-y *CODE-LINE-H*))
  (setq line-num (1+ line-num))

  (command "COLOR" 8)
  (command "TEXT" (list (+ x 10) line-y) 5 0 (itoa line-num))
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 50) line-y) 6 0 "  (")
  (command "COLOR" 5)
  (command "TEXT" (list (+ x 58) line-y) 6 0 "apply")
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 95) line-y) 6 0 "func (list pt scale rot))")
  (setq line-y (- line-y *CODE-LINE-H*))
  (setq line-num (1+ line-num))

  (command "COLOR" 8)
  (command "TEXT" (list (+ x 10) line-y) 5 0 (itoa line-num))
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 50) line-y) 6 0 ")")
  (setq line-y (- line-y (* *CODE-LINE-H* 2)))
  (setq line-num (1+ line-num))

  ;; Main function
  (command "COLOR" 8)
  (command "TEXT" (list (+ x 10) line-y) 5 0 (itoa line-num))
  (command "COLOR" 5)
  (command "TEXT" (list (+ x 50) line-y) 6 0 "(defun")
  (command "COLOR" 1)
  (command "TEXT" (list (+ x 100) line-y) 6 0 "C:SCHALTGEN")
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 195) line-y) 6 0 "()")
  (setq line-y (- line-y *CODE-LINE-H*))
  (setq line-num (1+ line-num))

  (command "COLOR" 8)
  (command "TEXT" (list (+ x 10) line-y) 5 0 (itoa line-num))
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 50) line-y) 6 0 "  (")
  (command "COLOR" 5)
  (command "TEXT" (list (+ x 58) line-y) 6 0 "setq")
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 90) line-y) 6 0 "data (CSV-LOADH")
  (command "COLOR" 2)
  (command "TEXT" (list (+ x 210) line-y) 6 0 "\"KOMPONEN.CSV\"")
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 325) line-y) 6 0 "))")
  (setq line-y (- line-y *CODE-LINE-H*))
  (setq line-num (1+ line-num))

  (command "COLOR" 8)
  (command "TEXT" (list (+ x 10) line-y) 5 0 (itoa line-num))
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 50) line-y) 6 0 "  (")
  (command "COLOR" 5)
  (command "TEXT" (list (+ x 58) line-y) 6 0 "foreach")
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 110) line-y) 6 0 "row data")
  (setq line-y (- line-y *CODE-LINE-H*))
  (setq line-num (1+ line-num))

  (command "COLOR" 8)
  (command "TEXT" (list (+ x 10) line-y) 5 0 (itoa line-num))
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 50) line-y) 6 0 "    (SCHALT-PROCESS row idx)")
  (setq line-y (- line-y *CODE-LINE-H*))
  (setq line-num (1+ line-num))

  (command "COLOR" 8)
  (command "TEXT" (list (+ x 10) line-y) 5 0 (itoa line-num))
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 50) line-y) 6 0 "  ))")

  ;; Arrow to next panel
  (command "COLOR" 3)
  (command "LINE"
    (list (+ x *PANEL-W* 10) (+ y (/ *PANEL-H* 2)))
    (list (+ x *PANEL-W* 40) (+ y (/ *PANEL-H* 2)))
    "")
  (command "LINE"
    (list (+ x *PANEL-W* 30) (+ y (/ *PANEL-H* 2) 10))
    (list (+ x *PANEL-W* 40) (+ y (/ *PANEL-H* 2)))
    (list (+ x *PANEL-W* 30) (+ y (/ *PANEL-H* 2) -10))
    "")
  (command "TEXT" (list (+ x *PANEL-W* 5) (+ y (/ *PANEL-H* 2) 20)) 6 0 "reads")
)

;;; ============================================
;;; PANEL 2: CSV DATA DISPLAY
;;; ============================================

(defun DRAW-CSV-PANEL (x y)
  "Draw the CSV data panel"

  ;; Panel frame
  (command "COLOR" 9)
  (command "LINE"
    (list x y)
    (list (+ x *PANEL-W*) y)
    (list (+ x *PANEL-W*) (+ y *PANEL-H*))
    (list x (+ y *PANEL-H*))
    "C")

  ;; Title bar
  (command "COLOR" 2)
  (command "LINE"
    (list x (+ y (- *PANEL-H* 40)))
    (list (+ x *PANEL-W*) (+ y (- *PANEL-H* 40)))
    (list (+ x *PANEL-W*) (+ y *PANEL-H*))
    (list x (+ y *PANEL-H*))
    "C")

  (command "COLOR" 7)
  (command "TEXT" (list (+ x 15) (+ y (- *PANEL-H* 28))) 12 0 "KOMPONEN.CSV - Component Data")

  ;; Spreadsheet grid
  (setq row-h 28)
  (setq col-w 110)
  (setq start-y (+ y (- *PANEL-H* 80)))

  ;; Header row (blue background)
  (command "COLOR" 4)
  (command "LINE"
    (list (+ x 10) start-y)
    (list (+ x (- *PANEL-W* 10)) start-y)
    (list (+ x (- *PANEL-W* 10)) (+ start-y row-h))
    (list (+ x 10) (+ start-y row-h))
    "C")

  ;; Column headers
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 20) (+ start-y 8)) 7 0 "TYP")
  (command "TEXT" (list (+ x 130) (+ start-y 8)) 7 0 "BEZEICHNUNG")
  (command "TEXT" (list (+ x 260) (+ start-y 8)) 7 0 "WERT")
  (command "TEXT" (list (+ x 370) (+ start-y 8)) 7 0 "HERSTELLER")
  (command "TEXT" (list (+ x 490) (+ start-y 8)) 7 0 "BESTELLNR")

  ;; Column dividers
  (command "COLOR" 8)
  (command "LINE" (list (+ x 120) start-y) (list (+ x 120) (+ y 50)) "")
  (command "LINE" (list (+ x 250) start-y) (list (+ x 250) (+ y 50)) "")
  (command "LINE" (list (+ x 360) start-y) (list (+ x 360) (+ y 50)) "")
  (command "LINE" (list (+ x 480) start-y) (list (+ x 480) (+ y 50)) "")

  ;; Data rows
  (setq data-rows '(
    ("SCHUETZ" "K1" "24V DC" "Siemens" "3RT1015")
    ("SCHUETZ" "K2" "24V DC" "Siemens" "3RT1015")
    ("SCHUETZ" "K3" "230V AC" "Siemens" "3RT1016")
    ("RELAIS" "K5" "24V DC" "Siemens" "3RH1122")
    ("SCHALTER" "S1" "" "Moeller" "P1-25")
    ("SCHALTER" "S2" "" "Moeller" "M22-D-G")
    ("WECHSELSCH" "S4" "" "B-Jaeger" "2000/6US")
    ("KREUZSCH" "S6" "" "B-Jaeger" "2000/7US")
    ("SICHERUNG" "F1" "16A gL" "Siemens" "5SG7611")
    ("SICHERUNG" "F2" "16A gL" "Siemens" "5SG7611")
    ("MOTOR" "M1" "5.5kW" "Siemens" "1LA7113")
    ("MOTOR" "M2" "3.0kW" "Siemens" "1LA7106")
    ("KLEMME" "X1-1" "" "Weidmuell" "SAK 4")
  ))

  (setq row-y (- start-y row-h))
  (setq row-idx 0)
  (foreach row data-rows
    ;; Alternating row background
    (if (= (rem row-idx 2) 0)
      (command "COLOR" 250)
      (command "COLOR" 8)
    )

    ;; Row highlight for first few (being processed)
    (if (< row-idx 5)
      (progn
        (command "COLOR" 80)
        (command "LINE"
          (list (+ x 10) row-y)
          (list (+ x (- *PANEL-W* 10)) row-y)
          (list (+ x (- *PANEL-W* 10)) (+ row-y row-h))
          (list (+ x 10) (+ row-y row-h))
          "C")
      )
    )

    ;; Row data
    (command "COLOR" 3)
    (command "TEXT" (list (+ x 20) (+ row-y 8)) 6 0 (nth 0 row))
    (command "COLOR" 7)
    (command "TEXT" (list (+ x 130) (+ row-y 8)) 6 0 (nth 1 row))
    (command "COLOR" 9)
    (command "TEXT" (list (+ x 260) (+ row-y 8)) 6 0 (nth 2 row))
    (command "COLOR" 8)
    (command "TEXT" (list (+ x 370) (+ row-y 8)) 6 0 (nth 3 row))
    (command "TEXT" (list (+ x 490) (+ row-y 8)) 6 0 (nth 4 row))

    ;; Row divider
    (command "COLOR" 8)
    (command "LINE"
      (list (+ x 10) row-y)
      (list (+ x (- *PANEL-W* 10)) row-y)
      "")

    (setq row-y (- row-y row-h))
    (setq row-idx (1+ row-idx))
  )

  ;; Processing indicator
  (command "COLOR" 3)
  (command "TEXT" (list (+ x 20) (+ y 30)) 8 0 "Processing row 5 of 23...")

  ;; Progress bar
  (command "COLOR" 8)
  (command "LINE"
    (list (+ x 200) (+ y 25))
    (list (+ x 500) (+ y 25))
    (list (+ x 500) (+ y 40))
    (list (+ x 200) (+ y 40))
    "C")
  (command "COLOR" 3)
  (command "LINE"
    (list (+ x 202) (+ y 27))
    (list (+ x 280) (+ y 27))
    (list (+ x 280) (+ y 38))
    (list (+ x 202) (+ y 38))
    "C")

  ;; Arrow to next panel
  (command "COLOR" 3)
  (command "LINE"
    (list (+ x *PANEL-W* 10) (+ y (/ *PANEL-H* 2)))
    (list (+ x *PANEL-W* 40) (+ y (/ *PANEL-H* 2)))
    "")
  (command "LINE"
    (list (+ x *PANEL-W* 30) (+ y (/ *PANEL-H* 2) 10))
    (list (+ x *PANEL-W* 40) (+ y (/ *PANEL-H* 2)))
    (list (+ x *PANEL-W* 30) (+ y (/ *PANEL-H* 2) -10))
    "")
  (command "TEXT" (list (+ x *PANEL-W* 5) (+ y (/ *PANEL-H* 2) 20)) 6 0 "generates")
)

;;; ============================================
;;; PANEL 3: RENDERED OUTPUT
;;; ============================================

(defun DRAW-OUTPUT-PANEL (x y)
  "Draw the rendered electrical symbols"

  ;; Panel frame
  (command "COLOR" 9)
  (command "LINE"
    (list x y)
    (list (+ x *PANEL-W*) y)
    (list (+ x *PANEL-W*) (+ y *PANEL-H*))
    (list x (+ y *PANEL-H*))
    "C")

  ;; Title bar
  (command "COLOR" 3)
  (command "LINE"
    (list x (+ y (- *PANEL-H* 40)))
    (list (+ x *PANEL-W*) (+ y (- *PANEL-H* 40)))
    (list (+ x *PANEL-W*) (+ y *PANEL-H*))
    (list x (+ y *PANEL-H*))
    "C")

  (command "COLOR" 7)
  (command "TEXT" (list (+ x 15) (+ y (- *PANEL-H* 28))) 12 0 "Rendered Output - AutoCAD Drawing")

  ;; Grid background
  (command "COLOR" 8)
  (setq gx (+ x 20))
  (while (< gx (+ x (- *PANEL-W* 20)))
    (command "LINE"
      (list gx (+ y 20))
      (list gx (+ y (- *PANEL-H* 60)))
      "")
    (setq gx (+ gx 50))
  )
  (setq gy (+ y 20))
  (while (< gy (+ y (- *PANEL-H* 60)))
    (command "LINE"
      (list (+ x 20) gy)
      (list (+ x (- *PANEL-W* 20)) gy)
      "")
    (setq gy (+ gy 50))
  )

  ;; === SCHUETZ K1 ===
  (setq sx (+ x 80))
  (setq sy (+ y 580))

  (command "COLOR" 7)
  ;; Coil body
  (command "LINE"
    (list sx sy)
    (list (+ sx 50) sy)
    (list (+ sx 50) (+ sy 80))
    (list sx (+ sy 80))
    "C")

  ;; Coil windings
  (command "ARC"
    (list (+ sx 10) (+ sy 20))
    (list (+ sx 25) (+ sy 30))
    (list (+ sx 40) (+ sy 20)))
  (command "ARC"
    (list (+ sx 10) (+ sy 40))
    (list (+ sx 25) (+ sy 50))
    (list (+ sx 40) (+ sy 40)))
  (command "ARC"
    (list (+ sx 10) (+ sy 60))
    (list (+ sx 25) (+ sy 70))
    (list (+ sx 40) (+ sy 60)))

  ;; Terminals
  (command "LINE" (list (+ sx 25) sy) (list (+ sx 25) (- sy 15)) "")
  (command "LINE" (list (+ sx 25) (+ sy 80)) (list (+ sx 25) (+ sy 95)) "")

  ;; Label
  (command "COLOR" 3)
  (command "TEXT" (list (+ sx 60) (+ sy 35)) 10 0 "K1")
  (command "COLOR" 9)
  (command "TEXT" (list (+ sx 60) (+ sy 20)) 6 0 "24V DC")

  ;; === SCHUETZ K2 ===
  (setq sx (+ x 200))

  (command "COLOR" 7)
  (command "LINE"
    (list sx sy)
    (list (+ sx 50) sy)
    (list (+ sx 50) (+ sy 80))
    (list sx (+ sy 80))
    "C")

  (command "ARC"
    (list (+ sx 10) (+ sy 20))
    (list (+ sx 25) (+ sy 30))
    (list (+ sx 40) (+ sy 20)))
  (command "ARC"
    (list (+ sx 10) (+ sy 40))
    (list (+ sx 25) (+ sy 50))
    (list (+ sx 40) (+ sy 40)))
  (command "ARC"
    (list (+ sx 10) (+ sy 60))
    (list (+ sx 25) (+ sy 70))
    (list (+ sx 40) (+ sy 60)))

  (command "LINE" (list (+ sx 25) sy) (list (+ sx 25) (- sy 15)) "")
  (command "LINE" (list (+ sx 25) (+ sy 80)) (list (+ sx 25) (+ sy 95)) "")

  (command "COLOR" 3)
  (command "TEXT" (list (+ sx 60) (+ sy 35)) 10 0 "K2")
  (command "COLOR" 9)
  (command "TEXT" (list (+ sx 60) (+ sy 20)) 6 0 "24V DC")

  ;; === RELAIS K5 ===
  (setq sx (+ x 320))
  (setq sy (+ y 580))

  (command "COLOR" 7)
  (command "LINE"
    (list sx sy)
    (list (+ sx 40) sy)
    (list (+ sx 40) (+ sy 60))
    (list sx (+ sy 60))
    "C")

  (command "TEXT" (list (+ sx 12) (+ sy 25)) 12 0 "K")

  (command "LINE" (list (+ sx 20) sy) (list (+ sx 20) (- sy 15)) "")
  (command "LINE" (list (+ sx 20) (+ sy 60)) (list (+ sx 20) (+ sy 75)) "")

  (command "COLOR" 3)
  (command "TEXT" (list (+ sx 50) (+ sy 25)) 10 0 "K5")
  (command "COLOR" 9)
  (command "TEXT" (list (+ sx 50) (+ sy 10)) 6 0 "Relais")

  ;; === SCHALTER S1 ===
  (setq sx (+ x 80))
  (setq sy (+ y 420))

  (command "COLOR" 7)
  (command "CIRCLE" (list sx sy) 6)
  (command "CIRCLE" (list (+ sx 60) sy) 6)
  (command "LINE" (list (+ sx 6) sy) (list (+ sx 50) (+ sy 15)) "")

  (command "COLOR" 3)
  (command "TEXT" (list (+ sx 20) (+ sy 25)) 10 0 "S1")
  (command "COLOR" 9)
  (command "TEXT" (list (+ sx 20) (- sy 20)) 6 0 "Hauptschalter")

  ;; === SCHALTER S2 ===
  (setq sx (+ x 200))

  (command "COLOR" 7)
  (command "CIRCLE" (list sx sy) 6)
  (command "CIRCLE" (list (+ sx 60) sy) 6)
  (command "LINE" (list (+ sx 6) sy) (list (+ sx 50) (+ sy 15)) "")

  (command "COLOR" 3)
  (command "TEXT" (list (+ sx 20) (+ sy 25)) 10 0 "S2")
  (command "COLOR" 9)
  (command "TEXT" (list (+ sx 20) (- sy 20)) 6 0 "EIN gruen")

  ;; === MOTOR M1 ===
  (setq sx (+ x 400))
  (setq sy (+ y 580))

  (command "COLOR" 7)
  (command "CIRCLE" (list sx sy) 40)
  (command "TEXT" (list (- sx 12) (- sy 5)) 18 0 "M")
  (command "TEXT" (list (- sx 10) (+ sy 15)) 8 0 "3~")

  ;; Motor terminals
  (command "LINE" (list (- sx 20) (+ sy 40)) (list (- sx 20) (+ sy 60)) "")
  (command "LINE" (list sx (+ sy 40)) (list sx (+ sy 60)) "")
  (command "LINE" (list (+ sx 20) (+ sy 40)) (list (+ sx 20) (+ sy 60)) "")

  (command "COLOR" 3)
  (command "TEXT" (list (+ sx 50) sy) 10 0 "M1")
  (command "COLOR" 9)
  (command "TEXT" (list (+ sx 50) (- sy 15)) 6 0 "5.5 kW")
  (command "TEXT" (list (+ sx 50) (- sy 30)) 6 0 "1450 U/min")

  ;; === SICHERUNG F1 ===
  (setq sx (+ x 80))
  (setq sy (+ y 280))

  (command "COLOR" 7)
  (command "LINE"
    (list sx sy)
    (list (+ sx 60) sy)
    (list (+ sx 60) (+ sy 20))
    (list sx (+ sy 20))
    "C")
  (command "LINE"
    (list sx (+ sy 10))
    (list (+ sx 60) (+ sy 10))
    "")

  (command "COLOR" 3)
  (command "TEXT" (list (+ sx 70) (+ sy 5)) 10 0 "F1")
  (command "COLOR" 9)
  (command "TEXT" (list (+ sx 70) (- sy 10)) 6 0 "16A gL")

  ;; === KLEMME X1 ===
  (setq sx (+ x 80))
  (setq sy (+ y 180))

  (command "COLOR" 7)
  (setq ki 0)
  (repeat 5
    (command "CIRCLE" (list (+ sx (* ki 30)) sy) 8)
    (command "TEXT" (list (+ sx (* ki 30) -3) (+ sy 20)) 5 0 (itoa (1+ ki)))
    (setq ki (1+ ki))
  )

  (command "COLOR" 3)
  (command "TEXT" (list (+ sx 160) sy) 10 0 "X1")
  (command "COLOR" 9)
  (command "TEXT" (list (+ sx 160) (- sy 15)) 6 0 "Klemmenleiste")

  ;; Output file indicators
  (command "COLOR" 2)
  (command "TEXT" (list (+ x 350) (+ y 100)) 7 0 "Generated files:")
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 350) (+ y 80)) 6 0 "K1.DWG  K2.DWG  K3.DWG")
  (command "TEXT" (list (+ x 350) (+ y 65)) 6 0 "K5.DWG  S1.DWG  S2.DWG")
  (command "TEXT" (list (+ x 350) (+ y 50)) 6 0 "M1.DWG  F1.DWG  X1.DWG")
  (command "TEXT" (list (+ x 350) (+ y 35)) 6 0 "...")
)

;;; ============================================
;;; MAIN TITLE
;;; ============================================

(defun DRAW-TITLE ()
  (command "COLOR" 7)
  (command "TEXT" (list 50 880) 20 0 "AutoLISP Pipeline: Code -> CSV -> Rendered Output")
  (command "COLOR" 9)
  (command "TEXT" (list 50 850) 10 0 "rust-autolisp demonstration - Schmidt & Weber GmbH 1991")

  (command "COLOR" 8)
  (command "LINE" (list 50 840) (list 1900 840) "")
)

;;; ============================================
;;; MAIN
;;; ============================================

(princ "\n")
(princ "╔════════════════════════════════════════════════════════════════╗\n")
(princ "║     AUTOLISP PIPELINE VISUALIZATION                            ║\n")
(princ "║                                                                ║\n")
(princ "║     Panel 1: LSP Source Code (syntax highlighted)              ║\n")
(princ "║     Panel 2: CSV Data Import                                   ║\n")
(princ "║     Panel 3: Rendered Electrical Symbols                       ║\n")
(princ "╚════════════════════════════════════════════════════════════════╝\n")
(princ "\n")

(DRAW-TITLE)

(princ "Drawing Panel 1: LSP Source Code...\n")
(DRAW-CODE-PANEL 50 50)

(princ "Drawing Panel 2: CSV Data...\n")
(DRAW-CSV-PANEL 700 50)

(princ "Drawing Panel 3: Rendered Output...\n")
(DRAW-OUTPUT-PANEL 1350 50)

(princ "\n")
(princ "╔════════════════════════════════════════════════════════════════╗\n")
(princ "║                    PIPELINE COMPLETE                           ║\n")
(princ "╠════════════════════════════════════════════════════════════════╣\n")
(princ "║   Output: output/RENDER.svg                                    ║\n")
(princ "║                                                                ║\n")
(princ "║   Shows the complete flow:                                     ║\n")
(princ "║   SCHALT.LSP code -> KOMPONEN.CSV data -> DWG symbols          ║\n")
(princ "╚════════════════════════════════════════════════════════════════╝\n")
(princ)
