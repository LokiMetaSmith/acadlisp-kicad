;;; ACAD_SIM.LSP - Simulated AutoCAD R10 Screen Display
;;; Creates visual representation of how AutoCAD looked in 1991
;;; For rust-autolisp demonstration
;;;

;;; ============================================
;;; SCREEN CONSTANTS (CGA/EGA/VGA era)
;;; ============================================

(setq *SCREEN-W* 1024)
(setq *SCREEN-H* 768)
(setq *MENU-W* 120)
(setq *CMD-H* 80)
(setq *STATUS-H* 25)

;;; AutoCAD R10 Colors (approximate)
(setq *COL-BG* 0)       ; Black background
(setq *COL-MENU* 1)     ; Red menu area
(setq *COL-DRAW* 7)     ; White drawing area border
(setq *COL-CMD* 8)      ; Gray command line
(setq *COL-TEXT* 7)     ; White text
(setq *COL-CURSOR* 2)   ; Yellow crosshair
(setq *COL-GRID* 8)     ; Gray grid

;;; ============================================
;;; DRAW AUTOCAD INTERFACE
;;; ============================================

(defun DRAW-ACAD-SCREEN (frame-num title cmd-text / y-off)
  "Draw a simulated AutoCAD R10 screen"
  (setq y-off (* frame-num (+ *SCREEN-H* 50)))

  ;; Main screen border
  (command "COLOR" 7)
  (command "LINE"
    (list 0 y-off)
    (list *SCREEN-W* y-off)
    (list *SCREEN-W* (+ y-off *SCREEN-H*))
    (list 0 (+ y-off *SCREEN-H*))
    "C")

  ;; Title bar (blue)
  (command "COLOR" 5)
  (command "LINE"
    (list 0 (+ y-off (- *SCREEN-H* 25)))
    (list *SCREEN-W* (+ y-off (- *SCREEN-H* 25)))
    (list *SCREEN-W* (+ y-off *SCREEN-H*))
    (list 0 (+ y-off *SCREEN-H*))
    "C")
  (command "COLOR" 7)
  (command "TEXT"
    (list 10 (+ y-off (- *SCREEN-H* 18)))
    12
    0
    (strcat "AutoCAD Release 10 - " title))

  ;; Right side menu area (dark red)
  (command "COLOR" 1)
  (command "LINE"
    (list (- *SCREEN-W* *MENU-W*) y-off)
    (list *SCREEN-W* y-off)
    (list *SCREEN-W* (+ y-off (- *SCREEN-H* 25)))
    (list (- *SCREEN-W* *MENU-W*) (+ y-off (- *SCREEN-H* 25)))
    "C")

  ;; Menu items
  (command "COLOR" 7)
  (command "TEXT" (list (- *SCREEN-W* 115) (+ y-off (- *SCREEN-H* 50))) 8 0 "AutoCAD")
  (command "TEXT" (list (- *SCREEN-W* 115) (+ y-off (- *SCREEN-H* 65))) 6 0 "* * * *")
  (command "TEXT" (list (- *SCREEN-W* 110) (+ y-off (- *SCREEN-H* 85))) 7 0 "BLOCKS")
  (command "TEXT" (list (- *SCREEN-W* 110) (+ y-off (- *SCREEN-H* 100))) 7 0 "DIM:")
  (command "TEXT" (list (- *SCREEN-W* 110) (+ y-off (- *SCREEN-H* 115))) 7 0 "DISPLAY")
  (command "TEXT" (list (- *SCREEN-W* 110) (+ y-off (- *SCREEN-H* 130))) 7 0 "DRAW")
  (command "TEXT" (list (- *SCREEN-W* 110) (+ y-off (- *SCREEN-H* 145))) 7 0 "EDIT")
  (command "TEXT" (list (- *SCREEN-W* 110) (+ y-off (- *SCREEN-H* 160))) 7 0 "INQUIRY")
  (command "TEXT" (list (- *SCREEN-W* 110) (+ y-off (- *SCREEN-H* 175))) 7 0 "LAYER:")
  (command "TEXT" (list (- *SCREEN-W* 110) (+ y-off (- *SCREEN-H* 190))) 7 0 "SETTINGS")
  (command "TEXT" (list (- *SCREEN-W* 110) (+ y-off (- *SCREEN-H* 205))) 7 0 "PLOT")
  (command "TEXT" (list (- *SCREEN-W* 110) (+ y-off (- *SCREEN-H* 220))) 7 0 "UTILITY")
  (command "TEXT" (list (- *SCREEN-W* 110) (+ y-off (- *SCREEN-H* 235))) 7 0 "3D")
  (command "COLOR" 2)
  (command "TEXT" (list (- *SCREEN-W* 110) (+ y-off (- *SCREEN-H* 260))) 7 0 "SAVE:")

  ;; Command line area (bottom)
  (command "COLOR" 8)
  (command "LINE"
    (list 0 y-off)
    (list (- *SCREEN-W* *MENU-W*) y-off)
    (list (- *SCREEN-W* *MENU-W*) (+ y-off *CMD-H*))
    (list 0 (+ y-off *CMD-H*))
    "C")

  ;; Command text
  (command "COLOR" 7)
  (command "TEXT" (list 5 (+ y-off 60)) 7 0 "Command:")
  (command "COLOR" 3)
  (command "TEXT" (list 70 (+ y-off 60)) 7 0 cmd-text)

  ;; Status line
  (command "COLOR" 8)
  (command "LINE"
    (list 0 (+ y-off *CMD-H*))
    (list (- *SCREEN-W* *MENU-W*) (+ y-off *CMD-H*))
    "")
  (command "COLOR" 7)
  (command "TEXT" (list 5 (+ y-off 20)) 6 0 "Layer: 0")
  (command "TEXT" (list 100 (+ y-off 20)) 6 0 "Ortho")
  (command "TEXT" (list 160 (+ y-off 20)) 6 0 "Snap")
  (command "TEXT" (list 220 (+ y-off 20)) 6 0 "<Coords on>")

  ;; Drawing area grid
  (command "COLOR" 8)
  (setq gx 50)
  (while (< gx (- *SCREEN-W* *MENU-W* 50))
    (command "LINE"
      (list gx (+ y-off *CMD-H* 20))
      (list gx (+ y-off (- *SCREEN-H* 45)))
      "")
    (setq gx (+ gx 80))
  )
  (setq gy (+ *CMD-H* 100))
  (while (< gy (- *SCREEN-H* 50))
    (command "LINE"
      (list 20 (+ y-off gy))
      (list (- *SCREEN-W* *MENU-W* 20) (+ y-off gy))
      "")
    (setq gy (+ gy 80))
  )

  ;; Crosshair cursor
  (command "COLOR" 2)
  (command "LINE"
    (list 400 (+ y-off 350))
    (list 400 (+ y-off 450))
    "")
  (command "LINE"
    (list 350 (+ y-off 400))
    (list 450 (+ y-off 400))
    "")

  ;; Frame label
  (command "COLOR" 9)
  (command "TEXT"
    (list 10 (+ y-off *SCREEN-H* 10))
    10
    0
    (strcat "Screenshot " (itoa (1+ frame-num))))

  y-off
)

;;; ============================================
;;; SCREENSHOT 1: LOADING AUTOLISP
;;; ============================================

(defun SCREENSHOT-1 ()
  (princ "\n  Screenshot 1: Loading LISP files...\n")
  (setq y (DRAW-ACAD-SCREEN 0 "ELEKTRIK.DWG" "(load \"SCHALT\")"))

  ;; Show loading message in drawing area
  (command "COLOR" 7)
  (command "TEXT" (list 50 (+ y 600)) 10 0 "Loading LISP files...")
  (command "COLOR" 3)
  (command "TEXT" (list 50 (+ y 570)) 8 0 "CSVREAD.LSP geladen - CSV Funktionen bereit.")
  (command "TEXT" (list 50 (+ y 550)) 8 0 "EBLOCKS.LSP geladen - Elektrosymbole bereit.")
  (command "TEXT" (list 50 (+ y 530)) 8 0 "Befehle: SCHUETZ, SCHALTER, KREUZSCH, WECHSELS...")
  (command "TEXT" (list 50 (+ y 510)) 8 0 "SCHALT.LSP geladen.")
  (command "TEXT" (list 50 (+ y 490)) 8 0 "Befehle: SCHALTGEN (Batch), SCHALTONE (Einzeln)")

  ;; Command history
  (command "COLOR" 7)
  (command "TEXT" (list 5 (+ y 45)) 6 0 "Command: (load \"CSVREAD\")")
  (command "TEXT" (list 5 (+ y 35)) 6 0 "Command: (load \"EBLOCKS\")")
)

;;; ============================================
;;; SCREENSHOT 2: RUNNING SCHALTGEN
;;; ============================================

(defun SCREENSHOT-2 ()
  (princ "\n  Screenshot 2: Running SCHALTGEN batch...\n")
  (setq y (DRAW-ACAD-SCREEN 1 "ELEKTRIK.DWG" "SCHALTGEN"))

  ;; Show batch processing output
  (command "COLOR" 7)
  (command "TEXT" (list 50 (+ y 620)) 10 0 "=== SCHALTPLAN-GENERATOR v1.0 ===")
  (command "TEXT" (list 50 (+ y 600)) 8 0 "    Schmidt & Weber GmbH 1991")

  (command "COLOR" 9)
  (command "TEXT" (list 50 (+ y 570)) 8 0 "CSV-Datei (z.B. KOMPONEN.CSV): KOMPONEN.CSV")
  (command "TEXT" (list 50 (+ y 550)) 8 0 "Lade KOMPONEN.CSV...")
  (command "TEXT" (list 50 (+ y 530)) 8 0 "23 Datensaetze gefunden.")

  (command "COLOR" 3)
  (command "TEXT" (list 50 (+ y 500)) 7 0 "[1/23] K1 -> C:\\ACAD\\PROJEKTE\\K1.DWG")
  (command "TEXT" (list 400 (+ y 500)) 7 0 "Zeichne SCHUETZ: K1 [OK]")
  (command "TEXT" (list 50 (+ y 485)) 7 0 "[2/23] K2 -> C:\\ACAD\\PROJEKTE\\K2.DWG")
  (command "TEXT" (list 400 (+ y 485)) 7 0 "Zeichne SCHUETZ: K2 [OK]")
  (command "TEXT" (list 50 (+ y 470)) 7 0 "[3/23] K3 -> C:\\ACAD\\PROJEKTE\\K3.DWG")
  (command "TEXT" (list 400 (+ y 470)) 7 0 "Zeichne SCHUETZ: K3 [OK]")
  (command "TEXT" (list 50 (+ y 455)) 7 0 "[4/23] K4 -> C:\\ACAD\\PROJEKTE\\K4.DWG")
  (command "TEXT" (list 400 (+ y 455)) 7 0 "Zeichne SCHUETZ: K4 [OK]")
  (command "TEXT" (list 50 (+ y 440)) 7 0 "[5/23] K5 -> C:\\ACAD\\PROJEKTE\\K5.DWG")
  (command "TEXT" (list 400 (+ y 440)) 7 0 "Zeichne RELAIS: K5 [OK]")
  (command "COLOR" 8)
  (command "TEXT" (list 50 (+ y 420)) 7 0 "... processing ...")

  ;; Progress indicator
  (command "COLOR" 2)
  (command "LINE" (list 50 (+ y 400)) (list 350 (+ y 400)) "")
  (command "COLOR" 3)
  (command "LINE" (list 50 (+ y 400)) (list 150 (+ y 400)) "")
)

;;; ============================================
;;; SCREENSHOT 3: DRAWING A SCHUETZ
;;; ============================================

(defun SCREENSHOT-3 ()
  (princ "\n  Screenshot 3: Drawing Schuetz symbol...\n")
  (setq y (DRAW-ACAD-SCREEN 2 "K1.DWG" ""))

  ;; Draw a Schuetz symbol in the drawing area
  (command "COLOR" 7)

  ;; Schuetz body
  (command "LINE"
    (list 300 (+ y 300))
    (list 400 (+ y 300))
    (list 400 (+ y 500))
    (list 300 (+ y 500))
    "C")

  ;; Coil symbol (waves)
  (command "ARC"
    (list 320 (+ y 340))
    (list 350 (+ y 360))
    (list 380 (+ y 340)))
  (command "ARC"
    (list 320 (+ y 380))
    (list 350 (+ y 400))
    (list 380 (+ y 380)))
  (command "ARC"
    (list 320 (+ y 420))
    (list 350 (+ y 440))
    (list 380 (+ y 420)))

  ;; Terminals
  (command "LINE"
    (list 350 (+ y 300))
    (list 350 (+ y 260))
    "")
  (command "LINE"
    (list 350 (+ y 500))
    (list 350 (+ y 540))
    "")

  ;; Terminal labels
  (command "TEXT" (list 360 (+ y 250)) 8 0 "A2")
  (command "TEXT" (list 360 (+ y 545)) 8 0 "A1")

  ;; Designation
  (command "COLOR" 3)
  (command "TEXT" (list 420 (+ y 400)) 15 0 "K1")
  (command "COLOR" 9)
  (command "TEXT" (list 420 (+ y 370)) 8 0 "24V DC")
  (command "TEXT" (list 420 (+ y 350)) 6 0 "Siemens")
  (command "TEXT" (list 420 (+ y 335)) 6 0 "3RT1015")

  ;; Dashed line to contacts
  (command "COLOR" 8)
  (command "LINE"
    (list 400 (+ y 400))
    (list 500 (+ y 400))
    "")

  ;; Main contacts
  (command "COLOR" 7)
  (command "CIRCLE" (list 550 (+ y 450)) 8)
  (command "CIRCLE" (list 600 (+ y 450)) 8)
  (command "LINE"
    (list 555 (+ y 450))
    (list 590 (+ y 470))
    "")
  (command "TEXT" (list 555 (+ y 430)) 6 0 "13")
  (command "TEXT" (list 605 (+ y 430)) 6 0 "14")

  ;; Second contact pair
  (command "CIRCLE" (list 550 (+ y 350)) 8)
  (command "CIRCLE" (list 600 (+ y 350)) 8)
  (command "LINE"
    (list 555 (+ y 350))
    (list 590 (+ y 370))
    "")
  (command "TEXT" (list 555 (+ y 330)) 6 0 "23")
  (command "TEXT" (list 605 (+ y 330)) 6 0 "24")

  ;; Command showing
  (command "COLOR" 3)
  (command "TEXT" (list 70 (+ y 60)) 7 0 "Symbol K1 gezeichnet.")
)

;;; ============================================
;;; SCREENSHOT 4: BATCH COMPLETE
;;; ============================================

(defun SCREENSHOT-4 ()
  (princ "\n  Screenshot 4: Batch complete...\n")
  (setq y (DRAW-ACAD-SCREEN 3 "ELEKTRIK.DWG" ""))

  ;; Summary box
  (command "COLOR" 3)
  (command "LINE"
    (list 150 (+ y 350))
    (list 700 (+ y 350))
    (list 700 (+ y 600))
    (list 150 (+ y 600))
    "C")

  (command "COLOR" 7)
  (command "TEXT" (list 180 (+ y 570)) 12 0 "=================================")
  (command "TEXT" (list 180 (+ y 545)) 10 0 "BATCH PROCESSING COMPLETE")
  (command "TEXT" (list 180 (+ y 520)) 12 0 "=================================")

  (command "COLOR" 9)
  (command "TEXT" (list 200 (+ y 485)) 9 0 "Verarbeitet: 23 Datensaetze")
  (command "COLOR" 3)
  (command "TEXT" (list 200 (+ y 460)) 9 0 "Erfolgreich: 23")
  (command "COLOR" 1)
  (command "TEXT" (list 200 (+ y 435)) 9 0 "Fehler:       0")

  (command "COLOR" 7)
  (command "TEXT" (list 200 (+ y 400)) 8 0 "Erzeugte DWG-Dateien:")
  (command "COLOR" 9)
  (command "TEXT" (list 220 (+ y 380)) 7 0 "K1.DWG, K2.DWG, K3.DWG, K4.DWG,")
  (command "TEXT" (list 220 (+ y 365)) 7 0 "K5.DWG, K6.DWG, S1.DWG, S2.DWG,")
  (command "TEXT" (list 220 (+ y 350)) 7 0 "S3.DWG, S4.DWG, S5.DWG, S6.DWG,")
  (command "TEXT" (list 220 (+ y 335)) 7 0 "F1.DWG ... M1.DWG, M2.DWG, X1.DWG")

  ;; Time stamp
  (command "COLOR" 8)
  (command "TEXT" (list 400 (+ y 160)) 8 0 "Completed: 14:32:45")
  (command "TEXT" (list 400 (+ y 145)) 8 0 "Total time: 2 min 34 sec")

  ;; Command line
  (command "COLOR" 7)
  (command "TEXT" (list 5 (+ y 45)) 6 0 "Command: SCHALTGEN completed.")
)

;;; ============================================
;;; SCREENSHOT 5: FILE MANAGER VIEW
;;; ============================================

(defun SCREENSHOT-5 ()
  (princ "\n  Screenshot 5: DOS file listing...\n")
  (setq y (DRAW-ACAD-SCREEN 4 "[DOS Shell] - File Manager" ""))

  ;; DOS-style directory listing
  (command "COLOR" 7)
  (command "TEXT" (list 50 (+ y 620)) 8 0 "C:\\ACAD\\PROJEKTE>dir *.dwg")
  (command "TEXT" (list 50 (+ y 600)) 8 0 "")
  (command "TEXT" (list 50 (+ y 585)) 7 0 " Volume in drive C is AUTOCAD")
  (command "TEXT" (list 50 (+ y 570)) 7 0 " Directory of C:\\ACAD\\PROJEKTE")
  (command "TEXT" (list 50 (+ y 550)) 7 0 "")

  (command "COLOR" 3)
  (command "TEXT" (list 50 (+ y 530)) 7 0 "K1       DWG     12,543  12-15-91   2:32p")
  (command "TEXT" (list 50 (+ y 515)) 7 0 "K2       DWG     12,298  12-15-91   2:32p")
  (command "TEXT" (list 50 (+ y 500)) 7 0 "K3       DWG     12,876  12-15-91   2:32p")
  (command "TEXT" (list 50 (+ y 485)) 7 0 "K4       DWG     12,102  12-15-91   2:33p")
  (command "TEXT" (list 50 (+ y 470)) 7 0 "K5       DWG      8,234  12-15-91   2:33p")
  (command "TEXT" (list 50 (+ y 455)) 7 0 "K6       DWG      8,567  12-15-91   2:33p")
  (command "TEXT" (list 50 (+ y 440)) 7 0 "S1       DWG      5,432  12-15-91   2:33p")
  (command "TEXT" (list 50 (+ y 425)) 7 0 "S2       DWG      4,987  12-15-91   2:33p")
  (command "TEXT" (list 50 (+ y 410)) 7 0 "S3       DWG      4,876  12-15-91   2:34p")
  (command "TEXT" (list 50 (+ y 395)) 7 0 "S4       DWG      6,234  12-15-91   2:34p")
  (command "TEXT" (list 50 (+ y 380)) 7 0 "S5       DWG      6,123  12-15-91   2:34p")
  (command "TEXT" (list 50 (+ y 365)) 7 0 "S6       DWG      7,654  12-15-91   2:34p")
  (command "TEXT" (list 50 (+ y 350)) 7 0 "F1       DWG      3,456  12-15-91   2:34p")
  (command "COLOR" 8)
  (command "TEXT" (list 50 (+ y 330)) 7 0 "        ...more files...")

  (command "COLOR" 7)
  (command "TEXT" (list 50 (+ y 300)) 7 0 "       23 file(s)    189,234 bytes")
  (command "TEXT" (list 50 (+ y 285)) 7 0 "                  45,234,567 bytes free")

  (command "COLOR" 3)
  (command "TEXT" (list 50 (+ y 250)) 8 0 "C:\\ACAD\\PROJEKTE>_")
)

;;; ============================================
;;; SCREENSHOT 6: PLOTTING
;;; ============================================

(defun SCREENSHOT-6 ()
  (princ "\n  Screenshot 6: Plotting to HP plotter...\n")
  (setq y (DRAW-ACAD-SCREEN 5 "K1.DWG - PLOT" "PLOT"))

  ;; Plot dialog simulation
  (command "COLOR" 7)
  (command "LINE"
    (list 200 (+ y 300))
    (list 700 (+ y 300))
    (list 700 (+ y 600))
    (list 200 (+ y 600))
    "C")

  (command "COLOR" 9)
  (command "TEXT" (list 350 (+ y 580)) 10 0 "PLOT CONFIGURATION")

  (command "COLOR" 7)
  (command "TEXT" (list 220 (+ y 540)) 8 0 "Device:     HP-GL Plotter (COM1)")
  (command "TEXT" (list 220 (+ y 520)) 8 0 "Paper size: A3 (420 x 297 mm)")
  (command "TEXT" (list 220 (+ y 500)) 8 0 "Scale:      1:1")
  (command "TEXT" (list 220 (+ y 480)) 8 0 "Rotation:   0 degrees")
  (command "TEXT" (list 220 (+ y 460)) 8 0 "Origin:     0.00, 0.00")

  (command "COLOR" 3)
  (command "TEXT" (list 220 (+ y 420)) 8 0 "Plot area:  Limits")
  (command "TEXT" (list 220 (+ y 400)) 8 0 "Pen width:  0.35 mm")

  ;; Buttons
  (command "COLOR" 7)
  (command "LINE"
    (list 300 (+ y 330))
    (list 400 (+ y 330))
    (list 400 (+ y 360))
    (list 300 (+ y 360))
    "C")
  (command "TEXT" (list 325 (+ y 340)) 8 0 "PLOT")

  (command "LINE"
    (list 450 (+ y 330))
    (list 550 (+ y 330))
    (list 550 (+ y 360))
    (list 450 (+ y 360))
    "C")
  (command "TEXT" (list 470 (+ y 340)) 8 0 "CANCEL")

  ;; Preview
  (command "COLOR" 8)
  (command "LINE"
    (list 550 (+ y 400))
    (list 680 (+ y 400))
    (list 680 (+ y 550))
    (list 550 (+ y 550))
    "C")
  (command "COLOR" 3)
  (command "TEXT" (list 570 (+ y 530)) 6 0 "Preview:")
  ;; Mini symbol
  (command "COLOR" 7)
  (command "LINE"
    (list 590 (+ y 440))
    (list 640 (+ y 440))
    (list 640 (+ y 510))
    (list 590 (+ y 510))
    "C")
)

;;; ============================================
;;; MAIN: GENERATE ALL SCREENSHOTS
;;; ============================================

(princ "\n")
(princ "╔════════════════════════════════════════════════════════════════╗\n")
(princ "║        AUTOCAD R10 SIMULATION - SCREENSHOT SERIES              ║\n")
(princ "║                                                                ║\n")
(princ "║   Simulating the 1991 AutoCAD workflow visually                ║\n")
(princ "╚════════════════════════════════════════════════════════════════╝\n")
(princ "\n")

(princ "Generating simulated AutoCAD R10 screenshots...\n")

(SCREENSHOT-1)
(SCREENSHOT-2)
(SCREENSHOT-3)
(SCREENSHOT-4)
(SCREENSHOT-5)
(SCREENSHOT-6)

(princ "\n")
(princ "╔════════════════════════════════════════════════════════════════╗\n")
(princ "║              6 SCREENSHOTS GENERATED                           ║\n")
(princ "╠════════════════════════════════════════════════════════════════╣\n")
(princ "║   1. Loading LISP files                                        ║\n")
(princ "║   2. Running SCHALTGEN batch processor                         ║\n")
(princ "║   3. Drawing Schuetz (contactor) symbol                        ║\n")
(princ "║   4. Batch processing complete                                 ║\n")
(princ "║   5. DOS directory listing of DWG files                        ║\n")
(princ "║   6. HP Plotter configuration                                  ║\n")
(princ "║                                                                ║\n")
(princ "║   Output: output/ACAD_SIM.svg                                  ║\n")
(princ "╚════════════════════════════════════════════════════════════════╝\n")
(princ)
