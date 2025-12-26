;;; DWGGEN.LSP - Deep Dive into DWG Generation
;;;
;;; The HEART of the system: How AutoLISP generates complete drawings
;;; Step by step, command by command, line by line
;;;

(setq *SCREEN-W* 1920)
(setq *SCREEN-H* 1080)
(setq *FRAME-NUM* 0)
(setq *FRAME-Y* 0)

;;; ============================================
;;; HELPERS
;;; ============================================

(defun NEXT-FRAME (title)
  (setq *FRAME-NUM* (1+ *FRAME-NUM*))
  (setq *FRAME-Y* (* (1- *FRAME-NUM*) (+ *SCREEN-H* 20)))
  (command "COLOR" 0)
  (command "LINE" (list 0 *FRAME-Y*) (list *SCREEN-W* *FRAME-Y*)
    (list *SCREEN-W* (+ *FRAME-Y* *SCREEN-H*)) (list 0 (+ *FRAME-Y* *SCREEN-H*)) "C")
  (command "COLOR" 8)
  (command "TEXT" (list 20 (+ *FRAME-Y* 20)) 10 0
    (strcat "Frame " (itoa *FRAME-NUM*) " | " title))
  *FRAME-Y*
)

(defun DRAW-ACAD-WINDOW ()
  "Draw AutoCAD R10 window frame"
  ;; Drawing area
  (command "COLOR" 0)
  (command "LINE" (list 50 (+ *FRAME-Y* 150)) (list 1400 (+ *FRAME-Y* 150))
    (list 1400 (+ *FRAME-Y* 900)) (list 50 (+ *FRAME-Y* 900)) "C")
  ;; Border
  (command "COLOR" 8)
  (command "LINE" (list 50 (+ *FRAME-Y* 150)) (list 1400 (+ *FRAME-Y* 150))
    (list 1400 (+ *FRAME-Y* 900)) (list 50 (+ *FRAME-Y* 900)) "C")
  ;; Menu bar
  (command "COLOR" 7)
  (command "LINE" (list 50 (+ *FRAME-Y* 900)) (list 1400 (+ *FRAME-Y* 900))
    (list 1400 (+ *FRAME-Y* 930)) (list 50 (+ *FRAME-Y* 930)) "C")
  (command "COLOR" 0)
  (command "TEXT" (list 60 (+ *FRAME-Y* 910)) 10 0 "AutoCAD R10 - [M1-ANLAUF.DWG]")
  ;; Command area
  (command "COLOR" 7)
  (command "LINE" (list 50 (+ *FRAME-Y* 70)) (list 1400 (+ *FRAME-Y* 70))
    (list 1400 (+ *FRAME-Y* 145)) (list 50 (+ *FRAME-Y* 145)) "C")
)

(defun DRAW-CODE-PANEL ()
  "Draw the code/log panel on the right"
  (command "COLOR" 8)
  (command "LINE" (list 1420 (+ *FRAME-Y* 150)) (list 1880 (+ *FRAME-Y* 150))
    (list 1880 (+ *FRAME-Y* 930)) (list 1420 (+ *FRAME-Y* 930)) "C")
  (command "COLOR" 5)
  (command "TEXT" (list 1440 (+ *FRAME-Y* 910)) 10 0 "AutoLISP Execution Log")
)

(defun CMD (y text)
  (command "COLOR" 7)
  (command "TEXT" (list 60 (+ *FRAME-Y* y)) 10 0 text)
)

(defun CMD-GREEN (y text)
  (command "COLOR" 3)
  (command "TEXT" (list 60 (+ *FRAME-Y* y)) 10 0 text)
)

(defun CMD-YELLOW (y text)
  (command "COLOR" 2)
  (command "TEXT" (list 60 (+ *FRAME-Y* y)) 10 0 text)
)

(defun LOG (y text color)
  (command "COLOR" color)
  (command "TEXT" (list 1440 (+ *FRAME-Y* y)) 8 0 text)
)

(defun NARRATOR (text)
  (command "COLOR" 2)
  (command "LINE" (list 50 (+ *FRAME-Y* 940)) (list 1880 (+ *FRAME-Y* 940))
    (list 1880 (+ *FRAME-Y* 1000)) (list 50 (+ *FRAME-Y* 1000)) "C")
  (command "COLOR" 0)
  (command "LINE" (list 52 (+ *FRAME-Y* 942)) (list 1878 (+ *FRAME-Y* 942))
    (list 1878 (+ *FRAME-Y* 998)) (list 52 (+ *FRAME-Y* 998)) "C")
  (command "COLOR" 2)
  (command "TEXT" (list 70 (+ *FRAME-Y* 965)) 14 0 text)
)

;;; ============================================
;;; DRAWING ELEMENTS
;;; ============================================

(defun DRAW-DIN-FRAME ()
  "Draw DIN A3 frame"
  (command "COLOR" 7)
  ;; Outer frame
  (command "LINE" (list 80 (+ *FRAME-Y* 180)) (list 1370 (+ *FRAME-Y* 180))
    (list 1370 (+ *FRAME-Y* 870)) (list 80 (+ *FRAME-Y* 870)) "C")
  ;; Inner margin
  (command "COLOR" 8)
  (command "LINE" (list 100 (+ *FRAME-Y* 200)) (list 1350 (+ *FRAME-Y* 200))
    (list 1350 (+ *FRAME-Y* 850)) (list 100 (+ *FRAME-Y* 850)) "C")
)

(defun DRAW-TITLE-BLOCK ()
  "Draw title block"
  (command "COLOR" 7)
  (command "LINE" (list 950 (+ *FRAME-Y* 180)) (list 1370 (+ *FRAME-Y* 180))
    (list 1370 (+ *FRAME-Y* 320)) (list 950 (+ *FRAME-Y* 320)) "C")
  ;; Divisions
  (command "LINE" (list 950 (+ *FRAME-Y* 290)) (list 1370 (+ *FRAME-Y* 290)) "")
  (command "LINE" (list 950 (+ *FRAME-Y* 260)) (list 1370 (+ *FRAME-Y* 260)) "")
  (command "LINE" (list 950 (+ *FRAME-Y* 230)) (list 1370 (+ *FRAME-Y* 230)) "")
  (command "LINE" (list 1160 (+ *FRAME-Y* 180)) (list 1160 (+ *FRAME-Y* 260)) "")
)

(defun DRAW-TITLE-BLOCK-TEXT ()
  "Fill title block"
  (command "COLOR" 7)
  (command "TEXT" (list 970 (+ *FRAME-Y* 298)) 10 0 "Schmidt & Weber GmbH")
  (command "COLOR" 2)
  (command "TEXT" (list 970 (+ *FRAME-Y* 268)) 12 0 "M1-ANLAUF")
  (command "COLOR" 9)
  (command "TEXT" (list 970 (+ *FRAME-Y* 240)) 8 0 "Motor Starter Circuit")
  (command "COLOR" 7)
  (command "TEXT" (list 970 (+ *FRAME-Y* 212)) 8 0 "Scale 1:1")
  (command "TEXT" (list 1180 (+ *FRAME-Y* 212)) 8 0 "15.12.91")
  (command "TEXT" (list 970 (+ *FRAME-Y* 190)) 8 0 "Sheet 1/1")
  (command "TEXT" (list 1180 (+ *FRAME-Y* 190)) 8 0 "AutoLISP")
)

(defun DRAW-POWER-RAILS ()
  "Draw 3-phase power rails"
  (command "COLOR" 1)
  (command "LINE" (list 200 (+ *FRAME-Y* 820)) (list 200 (+ *FRAME-Y* 350)) "")
  (command "TEXT" (list 190 (+ *FRAME-Y* 835)) 10 0 "L1")
  (command "COLOR" 2)
  (command "LINE" (list 350 (+ *FRAME-Y* 820)) (list 350 (+ *FRAME-Y* 350)) "")
  (command "TEXT" (list 340 (+ *FRAME-Y* 835)) 10 0 "L2")
  (command "COLOR" 4)
  (command "LINE" (list 500 (+ *FRAME-Y* 820)) (list 500 (+ *FRAME-Y* 350)) "")
  (command "TEXT" (list 490 (+ *FRAME-Y* 835)) 10 0 "L3")
  (command "COLOR" 7)
  (command "LINE" (list 650 (+ *FRAME-Y* 820)) (list 650 (+ *FRAME-Y* 350)) "")
  (command "TEXT" (list 645 (+ *FRAME-Y* 835)) 10 0 "N")
  (command "COLOR" 3)
  (command "LINE" (list 750 (+ *FRAME-Y* 820)) (list 750 (+ *FRAME-Y* 350)) "")
  (command "TEXT" (list 740 (+ *FRAME-Y* 835)) 10 0 "PE")
)

(defun DRAW-CONTROL-RAILS ()
  "Draw 24V control circuit rails"
  (command "COLOR" 9)
  (command "LINE" (list 820 (+ *FRAME-Y* 800)) (list 820 (+ *FRAME-Y* 380)) "")
  (command "TEXT" (list 805 (+ *FRAME-Y* 815)) 8 0 "24V")
  (command "LINE" (list 920 (+ *FRAME-Y* 800)) (list 920 (+ *FRAME-Y* 380)) "")
  (command "TEXT" (list 910 (+ *FRAME-Y* 815)) 8 0 "0V")
)

(defun DRAW-FUSE (x y label)
  (command "COLOR" 7)
  (command "LINE" (list (- x 12) (+ *FRAME-Y* y)) (list (+ x 12) (+ *FRAME-Y* y))
    (list (+ x 12) (+ *FRAME-Y* (- y 35))) (list (- x 12) (+ *FRAME-Y* (- y 35))) "C")
  (command "LINE" (list (- x 12) (+ *FRAME-Y* (- y 17))) (list (+ x 12) (+ *FRAME-Y* (- y 17))) "")
  (command "COLOR" 2)
  (command "TEXT" (list (+ x 18) (+ *FRAME-Y* (- y 12))) 10 0 label)
)

(defun DRAW-CONTACTOR-MAIN (x y label)
  (command "COLOR" 7)
  ;; Contact points
  (command "LINE" (list x (+ *FRAME-Y* y)) (list x (+ *FRAME-Y* (- y 12))) "")
  (command "LINE" (list x (+ *FRAME-Y* (- y 48))) (list x (+ *FRAME-Y* (- y 60))) "")
  ;; Moving contact
  (command "LINE" (list x (+ *FRAME-Y* (- y 12))) (list (+ x 18) (+ *FRAME-Y* (- y 40))) "")
  ;; Actuator
  (command "COLOR" 8)
  (command "LINE" (list (+ x 9) (+ *FRAME-Y* (- y 26))) (list (+ x 40) (+ *FRAME-Y* (- y 26))) "")
  (command "COLOR" 2)
  (command "TEXT" (list (+ x 22) (+ *FRAME-Y* (- y 10))) 10 0 label)
)

(defun DRAW-CONTACTOR-COIL (x y label)
  (command "COLOR" 7)
  (command "LINE" (list (- x 15) (+ *FRAME-Y* y)) (list (+ x 15) (+ *FRAME-Y* y))
    (list (+ x 15) (+ *FRAME-Y* (- y 50))) (list (- x 15) (+ *FRAME-Y* (- y 50))) "C")
  (command "COLOR" 6)
  (command "ARC" (list (- x 8) (+ *FRAME-Y* (- y 12))) (list x (+ *FRAME-Y* (- y 8)))
    (list (+ x 8) (+ *FRAME-Y* (- y 12))))
  (command "ARC" (list (- x 8) (+ *FRAME-Y* (- y 25))) (list x (+ *FRAME-Y* (- y 21)))
    (list (+ x 8) (+ *FRAME-Y* (- y 25))))
  (command "ARC" (list (- x 8) (+ *FRAME-Y* (- y 38))) (list x (+ *FRAME-Y* (- y 34)))
    (list (+ x 8) (+ *FRAME-Y* (- y 38))))
  (command "COLOR" 2)
  (command "TEXT" (list (+ x 22) (+ *FRAME-Y* (- y 22))) 12 0 label)
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 18) (+ *FRAME-Y* (+ y 5))) 7 0 "A1")
  (command "TEXT" (list (+ x 18) (+ *FRAME-Y* (- y 55))) 7 0 "A2")
)

(defun DRAW-MOTOR (x y label power)
  (command "COLOR" 7)
  (command "CIRCLE" (list x (+ *FRAME-Y* y)) 45)
  (command "TEXT" (list (- x 12) (+ *FRAME-Y* (- y 8))) 28 0 "M")
  (command "TEXT" (list (- x 10) (+ *FRAME-Y* (+ y 20))) 14 0 "3~")
  ;; Terminals
  (command "LINE" (list (- x 22) (+ *FRAME-Y* (+ y 45))) (list (- x 22) (+ *FRAME-Y* (+ y 70))) "")
  (command "LINE" (list x (+ *FRAME-Y* (+ y 45))) (list x (+ *FRAME-Y* (+ y 70))) "")
  (command "LINE" (list (+ x 22) (+ *FRAME-Y* (+ y 45))) (list (+ x 22) (+ *FRAME-Y* (+ y 70))) "")
  (command "COLOR" 1)
  (command "TEXT" (list (- x 27) (+ *FRAME-Y* (+ y 80))) 8 0 "U")
  (command "COLOR" 2)
  (command "TEXT" (list (- x 5) (+ *FRAME-Y* (+ y 80))) 8 0 "V")
  (command "COLOR" 4)
  (command "TEXT" (list (+ x 18) (+ *FRAME-Y* (+ y 80))) 8 0 "W")
  (command "COLOR" 2)
  (command "TEXT" (list (+ x 55) (+ *FRAME-Y* (- y 5))) 12 0 label)
  (command "COLOR" 9)
  (command "TEXT" (list (+ x 55) (+ *FRAME-Y* (+ y 15))) 10 0 power)
)

(defun DRAW-THERMAL-RELAY (x y label)
  (command "COLOR" 7)
  (command "LINE" (list (- x 35) (+ *FRAME-Y* y)) (list (+ x 35) (+ *FRAME-Y* y))
    (list (+ x 35) (+ *FRAME-Y* (- y 40))) (list (- x 35) (+ *FRAME-Y* (- y 40))) "C")
  ;; Bimetal elements
  (command "COLOR" 6)
  (command "LINE" (list (- x 20) (+ *FRAME-Y* (- y 8))) (list (- x 20) (+ *FRAME-Y* (- y 32))) "")
  (command "LINE" (list x (+ *FRAME-Y* (- y 8))) (list x (+ *FRAME-Y* (- y 32))) "")
  (command "LINE" (list (+ x 20) (+ *FRAME-Y* (- y 8))) (list (+ x 20) (+ *FRAME-Y* (- y 32))) "")
  (command "COLOR" 2)
  (command "TEXT" (list (+ x 42) (+ *FRAME-Y* (- y 18))) 10 0 label)
)

(defun DRAW-RELAY-COIL (x y label)
  (command "COLOR" 7)
  (command "LINE" (list (- x 12) (+ *FRAME-Y* y)) (list (+ x 12) (+ *FRAME-Y* y))
    (list (+ x 12) (+ *FRAME-Y* (- y 35))) (list (- x 12) (+ *FRAME-Y* (- y 35))) "C")
  (command "LINE" (list (- x 8) (+ *FRAME-Y* (- y 8))) (list (+ x 8) (+ *FRAME-Y* (- y 8)))
    (list (+ x 8) (+ *FRAME-Y* (- y 27))) (list (- x 8) (+ *FRAME-Y* (- y 27))) "C")
  (command "COLOR" 2)
  (command "TEXT" (list (+ x 18) (+ *FRAME-Y* (- y 15))) 10 0 label)
)

;;; ============================================
;;; GENERATION SCENES - STEP BY STEP
;;; ============================================

(defun SCENE-INTRO ()
  (princ "\n=== Intro ===\n")

  (NEXT-FRAME "DWG Generation - The Heart of AutoLISP Automation")

  (command "COLOR" 3)
  (command "TEXT" (list 400 (+ *FRAME-Y* 700)) 40 0 "DWG GENERATION")
  (command "COLOR" 7)
  (command "TEXT" (list 350 (+ *FRAME-Y* 620)) 20 0 "How AutoLISP creates complete drawings")

  (command "COLOR" 9)
  (command "TEXT" (list 300 (+ *FRAME-Y* 520)) 14 0 "Watch every LINE, every ARC, every TEXT command")
  (command "TEXT" (list 300 (+ *FRAME-Y* 480)) 14 0 "as AutoLISP builds a complete Schaltkreis")

  (command "COLOR" 8)
  (command "TEXT" (list 300 (+ *FRAME-Y* 400)) 12 0 "CSV row being processed:")
  (command "COLOR" 3)
  (command "TEXT" (list 300 (+ *FRAME-Y* 360)) 11 0
    "MOTOR_ST;M1-ANLAUF;SCHUETZ;K1;MOTOR;M1;SICHERG;F1;THERMOR;T1;RELAIS;R1")

  (NARRATOR "Let's watch AutoLISP generate a complete motor starter circuit - command by command!")
)

(defun SCENE-NEW-DRAWING ()
  (princ "\n=== New Drawing ===\n")

  (NEXT-FRAME "Step 1: Create New Drawing")
  (DRAW-ACAD-WINDOW)
  (DRAW-CODE-PANEL)

  (CMD 135 "Command: NEW")
  (CMD 120 "Enter template name [MOTOR_ST]: MOTOR_ST")
  (CMD-GREEN 105 "Loading template C:\\ACAD\\TPL\\MOTOR_ST.DWT...")
  (CMD-GREEN 90 "Template loaded successfully.")

  (LOG 890 "(defun GENERATE-DWG (csv-row)" 5)
  (LOG 875 "  (setq tpl (nth 0 csv-row))" 7)
  (LOG 860 "  (setq name (nth 1 csv-row))" 7)
  (LOG 845 "  (command \"NEW\" tpl)" 3)
  (LOG 830 "  ; Template MOTOR_ST loaded" 8)
  (LOG 800 "Processing: M1-ANLAUF" 2)

  (NARRATOR "AutoLISP creates a new drawing from the MOTOR_ST template - the base motor starter layout.")
)

(defun SCENE-DRAW-FRAME ()
  (princ "\n=== Draw Frame ===\n")

  (NEXT-FRAME "Step 2: DIN A3 Frame (from template)")
  (DRAW-ACAD-WINDOW)
  (DRAW-CODE-PANEL)
  (DRAW-DIN-FRAME)

  (CMD 135 "Command: LINE")
  (CMD 120 "From point: 80,180")
  (CMD 105 "To point: 1370,180")
  (CMD 90 "To point: 1370,870")
  (CMD-GREEN 75 "Frame complete.")

  (LOG 890 "; MOTOR_ST.DWT contains:" 8)
  (LOG 875 "; - DIN A3 frame (420x297mm)" 8)
  (LOG 860 "; - Standard margins" 8)
  (LOG 845 "; - Title block outline" 8)
  (LOG 815 "(DRAW-DIN-FRAME)" 3)
  (LOG 800 "  LINE 80,180 -> 1370,870" 7)

  (NARRATOR "The template includes the standard DIN A3 drawing frame - 420x297mm at 1:1 scale.")
)

(defun SCENE-TITLE-BLOCK ()
  (princ "\n=== Title Block ===\n")

  (NEXT-FRAME "Step 3: Fill Title Block")
  (DRAW-ACAD-WINDOW)
  (DRAW-CODE-PANEL)
  (DRAW-DIN-FRAME)
  (DRAW-TITLE-BLOCK)
  (DRAW-TITLE-BLOCK-TEXT)

  (CMD 135 "Command: TEXT")
  (CMD 120 "Start point: 970,268")
  (CMD 105 "Height: 12")
  (CMD 90 "Text: M1-ANLAUF")
  (CMD-GREEN 75 "Title block filled.")

  (LOG 890 "(FILL-TITLE-BLOCK name)" 3)
  (LOG 875 "  TEXT 970,298 \"Schmidt & Weber\"" 7)
  (LOG 860 "  TEXT 970,268 name  ; M1-ANLAUF" 2)
  (LOG 845 "  TEXT 970,240 \"Motor Starter\"" 7)
  (LOG 830 "  TEXT 1180,212 (TODAY)" 7)
  (LOG 815 "  ; Date: 15.12.91" 8)

  (NARRATOR "The title block is filled with drawing name, company, date - all from the CSV and system.")
)

(defun SCENE-POWER-RAILS ()
  (princ "\n=== Power Rails ===\n")

  (NEXT-FRAME "Step 4: 3-Phase Power Rails")
  (DRAW-ACAD-WINDOW)
  (DRAW-CODE-PANEL)
  (DRAW-DIN-FRAME)
  (DRAW-TITLE-BLOCK)
  (DRAW-TITLE-BLOCK-TEXT)
  (DRAW-POWER-RAILS)

  (CMD 135 "Command: LINE")
  (CMD 120 "From point: 200,820  To: 200,350")
  (CMD 105 "Command: TEXT  Point: 190,835  Text: L1")
  (CMD 90 "Command: COLOR  New color: 2 (yellow)")
  (CMD-GREEN 75 "L1, L2, L3, N, PE rails drawn.")

  (LOG 890 "(DRAW-POWER-RAILS)" 3)
  (LOG 875 "  (command \"COLOR\" 1) ; Red" 7)
  (LOG 860 "  (command \"LINE\" '(200 820)" 7)
  (LOG 845 "                   '(200 350) \"\")" 7)
  (LOG 830 "  (command \"TEXT\" '(190 835) 10 0 \"L1\")" 7)
  (LOG 815 "  ; Repeat for L2, L3, N, PE" 8)

  (NARRATOR "Three-phase power rails L1, L2, L3 plus Neutral and Protective Earth - color coded per DIN.")
)

(defun SCENE-CONTROL-RAILS ()
  (princ "\n=== Control Rails ===\n")

  (NEXT-FRAME "Step 5: 24V Control Circuit Rails")
  (DRAW-ACAD-WINDOW)
  (DRAW-CODE-PANEL)
  (DRAW-DIN-FRAME)
  (DRAW-TITLE-BLOCK)
  (DRAW-TITLE-BLOCK-TEXT)
  (DRAW-POWER-RAILS)
  (DRAW-CONTROL-RAILS)

  (CMD 135 "Command: LINE")
  (CMD 120 "From: 820,800  To: 820,380")
  (CMD 105 "Command: TEXT  Text: 24V")
  (CMD-GREEN 90 "Control circuit rails ready.")

  (LOG 890 "(DRAW-CONTROL-RAILS)" 3)
  (LOG 875 "  ; 24V DC control voltage" 8)
  (LOG 860 "  (command \"LINE\" '(820 800)" 7)
  (LOG 845 "                   '(820 380) \"\")" 7)
  (LOG 830 "  (command \"TEXT\" ... \"24V\")" 7)
  (LOG 815 "  (command \"TEXT\" ... \"0V\")" 7)

  (NARRATOR "24V DC control circuit - separate from power circuit for safety. Standard in industrial controls.")
)

(defun SCENE-FUSES ()
  (princ "\n=== Fuses ===\n")

  (NEXT-FRAME "Step 6: Draw Fuses F1 (from CSV)")
  (DRAW-ACAD-WINDOW)
  (DRAW-CODE-PANEL)
  (DRAW-DIN-FRAME)
  (DRAW-TITLE-BLOCK)
  (DRAW-TITLE-BLOCK-TEXT)
  (DRAW-POWER-RAILS)
  (DRAW-CONTROL-RAILS)

  ;; Draw fuses
  (DRAW-FUSE 200 780 "F1")
  (DRAW-FUSE 350 780 "F1")
  (DRAW-FUSE 500 780 "F1")

  (CMD 135 "Command: LINE  ; Fuse body")
  (CMD 120 "188,780 -> 212,780 -> 212,745 -> 188,745 -> C")
  (CMD 105 "Command: LINE  ; Fuse element")
  (CMD 90 "188,763 -> 212,763")
  (CMD-GREEN 75 "Fuses F1 on L1, L2, L3 complete.")

  (LOG 890 "; CSV: SICHERG;F1" 8)
  (LOG 875 "(DRAW-SICHERG pt \"F1\")" 3)
  (LOG 860 "  (command \"LINE\" ; rectangle" 7)
  (LOG 845 "    (- x 12) y -> (+ x 12) y" 7)
  (LOG 830 "    -> (+ x 12) (- y 35)" 7)
  (LOG 815 "    -> (- x 12) (- y 35) \"C\")" 7)
  (LOG 800 "  (command \"LINE\" ; element" 7)
  (LOG 785 "    (- x 12) (- y 17)" 7)
  (LOG 770 "    (+ x 12) (- y 17) \"\")" 7)
  (LOG 755 "  (command \"TEXT\" label)" 7)

  (NARRATOR "Fuses F1 drawn on all three phases - component type SICHERG from CSV triggers DRAW-SICHERG function.")
)

(defun SCENE-CONTACTOR-MAIN ()
  (princ "\n=== Contactor Main Contacts ===\n")

  (NEXT-FRAME "Step 7: Contactor K1 - Main Contacts")
  (DRAW-ACAD-WINDOW)
  (DRAW-CODE-PANEL)
  (DRAW-DIN-FRAME)
  (DRAW-TITLE-BLOCK)
  (DRAW-TITLE-BLOCK-TEXT)
  (DRAW-POWER-RAILS)
  (DRAW-CONTROL-RAILS)
  (DRAW-FUSE 200 780 "F1")
  (DRAW-FUSE 350 780 "F1")
  (DRAW-FUSE 500 780 "F1")

  ;; Draw main contacts
  (DRAW-CONTACTOR-MAIN 200 700 "K1")
  (DRAW-CONTACTOR-MAIN 350 700 "K1")
  (DRAW-CONTACTOR-MAIN 500 700 "K1")

  (CMD 135 "Command: LINE  ; Fixed contact")
  (CMD 120 "200,700 -> 200,688")
  (CMD 105 "Command: LINE  ; Moving contact (open)")
  (CMD 90 "200,688 -> 218,660")
  (CMD-GREEN 75 "Main contacts K1 on all phases.")

  (LOG 890 "; CSV: SCHUETZ;K1" 8)
  (LOG 875 "(DRAW-SCHUETZ-MAIN pt \"K1\")" 3)
  (LOG 860 "  ; Draw on L1, L2, L3" 8)
  (LOG 845 "  (foreach phase '(200 350 500)" 7)
  (LOG 830 "    (command \"LINE\" ; contact" 7)
  (LOG 815 "      phase 700 -> phase 688)" 7)
  (LOG 800 "    (command \"LINE\" ; arm" 7)
  (LOG 785 "      phase 688 -> (+18) 660))" 7)

  (NARRATOR "Main contactor contacts K1 - these switch the motor power. Shown in 'open' (de-energized) state.")
)

(defun SCENE-CONTACTOR-COIL ()
  (princ "\n=== Contactor Coil ===\n")

  (NEXT-FRAME "Step 8: Contactor K1 - Coil in Control Circuit")
  (DRAW-ACAD-WINDOW)
  (DRAW-CODE-PANEL)
  (DRAW-DIN-FRAME)
  (DRAW-TITLE-BLOCK)
  (DRAW-TITLE-BLOCK-TEXT)
  (DRAW-POWER-RAILS)
  (DRAW-CONTROL-RAILS)
  (DRAW-FUSE 200 780 "F1")
  (DRAW-FUSE 350 780 "F1")
  (DRAW-FUSE 500 780 "F1")
  (DRAW-CONTACTOR-MAIN 200 700 "K1")
  (DRAW-CONTACTOR-MAIN 350 700 "K1")
  (DRAW-CONTACTOR-MAIN 500 700 "K1")

  ;; Draw coil
  (DRAW-CONTACTOR-COIL 870 720 "K1")

  (CMD 135 "Command: LINE  ; Coil body")
  (CMD 120 "855,720 -> 885,720 -> 885,670 -> 855,670 -> C")
  (CMD 105 "Command: ARC  ; Winding symbol")
  (CMD 90 "862,708 -> 870,712 -> 878,708")
  (CMD-GREEN 75 "Coil K1 in control circuit complete.")

  (LOG 890 "(DRAW-SCHUETZ-COIL pt \"K1\")" 3)
  (LOG 875 "  (command \"LINE\" ; body" 7)
  (LOG 860 "    (- x 15) y (+ x 15) y" 7)
  (LOG 845 "    (+ x 15) (- y 50) \"C\")" 7)
  (LOG 830 "  (command \"ARC\" ; winding 1" 7)
  (LOG 815 "    (- x 8) (- y 12)" 7)
  (LOG 800 "    x (- y 8)" 7)
  (LOG 785 "    (+ x 8) (- y 12))" 7)
  (LOG 770 "  ; Repeat for 3 windings" 8)

  (NARRATOR "Contactor coil K1 in the 24V control circuit - when energized, it closes the main contacts.")
)

(defun SCENE-THERMAL-RELAY ()
  (princ "\n=== Thermal Relay ===\n")

  (NEXT-FRAME "Step 9: Thermal Overload Relay T1")
  (DRAW-ACAD-WINDOW)
  (DRAW-CODE-PANEL)
  (DRAW-DIN-FRAME)
  (DRAW-TITLE-BLOCK)
  (DRAW-TITLE-BLOCK-TEXT)
  (DRAW-POWER-RAILS)
  (DRAW-CONTROL-RAILS)
  (DRAW-FUSE 200 780 "F1")
  (DRAW-FUSE 350 780 "F1")
  (DRAW-FUSE 500 780 "F1")
  (DRAW-CONTACTOR-MAIN 200 700 "K1")
  (DRAW-CONTACTOR-MAIN 350 700 "K1")
  (DRAW-CONTACTOR-MAIN 500 700 "K1")
  (DRAW-CONTACTOR-COIL 870 720 "K1")

  ;; Thermal relay
  (DRAW-THERMAL-RELAY 350 600 "T1")

  (CMD 135 "Command: LINE  ; Relay housing")
  (CMD 120 "315,600 -> 385,600 -> 385,560 -> 315,560 -> C")
  (CMD 105 "Command: LINE  ; Bimetal elements x3")
  (CMD-GREEN 90 "Thermal relay T1 complete.")

  (LOG 890 "; CSV: THERMOR;T1" 8)
  (LOG 875 "(DRAW-THERMOR pt \"T1\")" 3)
  (LOG 860 "  (command \"LINE\" ; housing" 7)
  (LOG 845 "    (- x 35) y -> (+ x 35) y" 7)
  (LOG 830 "    -> ... \"C\")" 7)
  (LOG 815 "  ; 3 bimetal elements" 8)
  (LOG 800 "  (foreach dx '(-20 0 20)" 7)
  (LOG 785 "    (command \"LINE\"" 7)
  (LOG 770 "      (+ x dx) (- y 8)" 7)
  (LOG 755 "      (+ x dx) (- y 32)))" 7)

  (NARRATOR "Thermal overload relay T1 - protects motor from overcurrent. Bimetal strips trip on excess heat.")
)

(defun SCENE-MOTOR ()
  (princ "\n=== Motor ===\n")

  (NEXT-FRAME "Step 10: Three-Phase Motor M1")
  (DRAW-ACAD-WINDOW)
  (DRAW-CODE-PANEL)
  (DRAW-DIN-FRAME)
  (DRAW-TITLE-BLOCK)
  (DRAW-TITLE-BLOCK-TEXT)
  (DRAW-POWER-RAILS)
  (DRAW-CONTROL-RAILS)
  (DRAW-FUSE 200 780 "F1")
  (DRAW-FUSE 350 780 "F1")
  (DRAW-FUSE 500 780 "F1")
  (DRAW-CONTACTOR-MAIN 200 700 "K1")
  (DRAW-CONTACTOR-MAIN 350 700 "K1")
  (DRAW-CONTACTOR-MAIN 500 700 "K1")
  (DRAW-CONTACTOR-COIL 870 720 "K1")
  (DRAW-THERMAL-RELAY 350 600 "T1")

  ;; Motor
  (DRAW-MOTOR 350 450 "M1" "5.5kW")

  (CMD 135 "Command: CIRCLE")
  (CMD 120 "Center: 350,450  Radius: 45")
  (CMD 105 "Command: TEXT  \"M\" and \"3~\"")
  (CMD-GREEN 90 "Motor M1 (5.5kW) complete.")

  (LOG 890 "; CSV: MOTOR;M1" 8)
  (LOG 875 "(DRAW-MOTOR pt \"M1\" \"5.5kW\")" 3)
  (LOG 860 "  (command \"CIRCLE\" pt 45)" 7)
  (LOG 845 "  (command \"TEXT\" \"M\")" 7)
  (LOG 830 "  (command \"TEXT\" \"3~\")" 7)
  (LOG 815 "  ; Terminal lines U, V, W" 8)
  (LOG 800 "  (foreach dx '(-22 0 22)" 7)
  (LOG 785 "    (command \"LINE\" ...))" 7)

  (NARRATOR "Motor M1 - 5.5kW three-phase. The circle with M and 3~ is the standard DIN symbol.")
)

(defun SCENE-CONTROL-RELAY ()
  (princ "\n=== Control Relay ===\n")

  (NEXT-FRAME "Step 11: Control Relay R1")
  (DRAW-ACAD-WINDOW)
  (DRAW-CODE-PANEL)
  (DRAW-DIN-FRAME)
  (DRAW-TITLE-BLOCK)
  (DRAW-TITLE-BLOCK-TEXT)
  (DRAW-POWER-RAILS)
  (DRAW-CONTROL-RAILS)
  (DRAW-FUSE 200 780 "F1")
  (DRAW-FUSE 350 780 "F1")
  (DRAW-FUSE 500 780 "F1")
  (DRAW-CONTACTOR-MAIN 200 700 "K1")
  (DRAW-CONTACTOR-MAIN 350 700 "K1")
  (DRAW-CONTACTOR-MAIN 500 700 "K1")
  (DRAW-CONTACTOR-COIL 870 720 "K1")
  (DRAW-THERMAL-RELAY 350 600 "T1")
  (DRAW-MOTOR 350 450 "M1" "5.5kW")

  ;; Control relay
  (DRAW-RELAY-COIL 870 620 "R1")

  (CMD 135 "Command: LINE  ; Relay coil")
  (CMD 120 "858,620 -> 882,620 -> 882,585 -> 858,585 -> C")
  (CMD-GREEN 105 "Relay R1 complete.")

  (LOG 890 "; CSV: RELAIS;R1" 8)
  (LOG 875 "(DRAW-RELAIS pt \"R1\")" 3)
  (LOG 860 "  (command \"LINE\" ; outer" 7)
  (LOG 845 "    ... \"C\")" 7)
  (LOG 830 "  (command \"LINE\" ; inner" 7)
  (LOG 815 "    ... \"C\")" 7)

  (NARRATOR "Control relay R1 - provides auxiliary contacts for status indication or interlocking.")
)

(defun SCENE-CONNECTIONS ()
  (princ "\n=== Connections ===\n")

  (NEXT-FRAME "Step 12: Wire Connections")
  (DRAW-ACAD-WINDOW)
  (DRAW-CODE-PANEL)
  (DRAW-DIN-FRAME)
  (DRAW-TITLE-BLOCK)
  (DRAW-TITLE-BLOCK-TEXT)
  (DRAW-POWER-RAILS)
  (DRAW-CONTROL-RAILS)
  (DRAW-FUSE 200 780 "F1")
  (DRAW-FUSE 350 780 "F1")
  (DRAW-FUSE 500 780 "F1")
  (DRAW-CONTACTOR-MAIN 200 700 "K1")
  (DRAW-CONTACTOR-MAIN 350 700 "K1")
  (DRAW-CONTACTOR-MAIN 500 700 "K1")
  (DRAW-CONTACTOR-COIL 870 720 "K1")
  (DRAW-THERMAL-RELAY 350 600 "T1")
  (DRAW-MOTOR 350 450 "M1" "5.5kW")
  (DRAW-RELAY-COIL 870 620 "R1")

  ;; Connection lines
  (command "COLOR" 7)
  ;; Power connections
  (command "LINE" (list 200 (+ *FRAME-Y* 640)) (list 200 (+ *FRAME-Y* 600)) "")
  (command "LINE" (list 350 (+ *FRAME-Y* 640)) (list 350 (+ *FRAME-Y* 600)) "")
  (command "LINE" (list 500 (+ *FRAME-Y* 640)) (list 500 (+ *FRAME-Y* 600)) "")
  ;; Control connections
  (command "LINE" (list 820 (+ *FRAME-Y* 720)) (list 855 (+ *FRAME-Y* 720)) "")
  (command "LINE" (list 885 (+ *FRAME-Y* 670)) (list 885 (+ *FRAME-Y* 620)) "")
  (command "LINE" (list 870 (+ *FRAME-Y* 585)) (list 870 (+ *FRAME-Y* 550)) "")
  (command "LINE" (list 870 (+ *FRAME-Y* 550)) (list 920 (+ *FRAME-Y* 550)) "")

  (CMD 135 "Command: LINE  ; Connect components")
  (CMD 120 "200,640 -> 200,600  ; L1 to thermal")
  (CMD 105 "820,720 -> 855,720  ; 24V to K1 coil")
  (CMD-GREEN 90 "All connections complete.")

  (LOG 890 "(DRAW-CONNECTIONS)" 3)
  (LOG 875 "  ; Power circuit" 8)
  (LOG 860 "  LINE fuse -> contactor" 7)
  (LOG 845 "  LINE contactor -> thermal" 7)
  (LOG 830 "  LINE thermal -> motor" 7)
  (LOG 815 "  ; Control circuit" 8)
  (LOG 800 "  LINE 24V -> K1 coil" 7)
  (LOG 785 "  LINE K1 -> R1 -> 0V" 7)

  (NARRATOR "Wire connections complete the circuit - power flows from L1/L2/L3 through protection to motor.")
)

(defun SCENE-COMPLETE ()
  (princ "\n=== Complete ===\n")

  (NEXT-FRAME "COMPLETE: M1-ANLAUF.DWG Ready!")
  (DRAW-ACAD-WINDOW)
  (DRAW-CODE-PANEL)
  (DRAW-DIN-FRAME)
  (DRAW-TITLE-BLOCK)
  (DRAW-TITLE-BLOCK-TEXT)
  (DRAW-POWER-RAILS)
  (DRAW-CONTROL-RAILS)
  (DRAW-FUSE 200 780 "F1")
  (DRAW-FUSE 350 780 "F1")
  (DRAW-FUSE 500 780 "F1")
  (DRAW-CONTACTOR-MAIN 200 700 "K1")
  (DRAW-CONTACTOR-MAIN 350 700 "K1")
  (DRAW-CONTACTOR-MAIN 500 700 "K1")
  (DRAW-CONTACTOR-COIL 870 720 "K1")
  (DRAW-THERMAL-RELAY 350 600 "T1")
  (DRAW-MOTOR 350 450 "M1" "5.5kW")
  (DRAW-RELAY-COIL 870 620 "R1")
  ;; Connections
  (command "COLOR" 7)
  (command "LINE" (list 200 (+ *FRAME-Y* 640)) (list 200 (+ *FRAME-Y* 600)) "")
  (command "LINE" (list 350 (+ *FRAME-Y* 640)) (list 350 (+ *FRAME-Y* 600)) "")
  (command "LINE" (list 500 (+ *FRAME-Y* 640)) (list 500 (+ *FRAME-Y* 600)) "")
  (command "LINE" (list 820 (+ *FRAME-Y* 720)) (list 855 (+ *FRAME-Y* 720)) "")
  (command "LINE" (list 885 (+ *FRAME-Y* 670)) (list 885 (+ *FRAME-Y* 620)) "")
  (command "LINE" (list 870 (+ *FRAME-Y* 585)) (list 870 (+ *FRAME-Y* 550)) "")
  (command "LINE" (list 870 (+ *FRAME-Y* 550)) (list 920 (+ *FRAME-Y* 550)) "")

  (CMD 135 "Command: SAVE")
  (CMD-YELLOW 120 "Saving M1-ANLAUF.DWG...")
  (CMD-GREEN 105 "Drawing saved successfully!")
  (CMD-GREEN 90 "Sending to print queue...")

  (LOG 890 "(command \"SAVE\" name)" 3)
  (LOG 875 "; M1-ANLAUF.DWG saved!" 2)
  (LOG 860 "" 7)
  (LOG 845 "(PRINT-DWG name)" 3)
  (LOG 830 "; Sent to HP LaserJet III" 2)
  (LOG 800 "====================" 8)
  (LOG 785 "Drawing complete!" 2)
  (LOG 770 "Components: 6" 7)
  (LOG 755 "Lines: 47" 7)
  (LOG 740 "Arcs: 9" 7)
  (LOG 725 "Texts: 23" 7)
  (LOG 710 "Time: 6.8 seconds" 7)

  (NARRATOR "M1-ANLAUF.DWG complete! A valid motor starter circuit - 47 lines, 9 arcs, 23 texts in 6.8 seconds!")
)

(defun SCENE-NEXT-DRAWING ()
  (princ "\n=== Next Drawing ===\n")

  (NEXT-FRAME "Next: M2-LUEFTER.DWG (and 21 more...)")

  (command "COLOR" 7)
  (command "TEXT" (list 200 (+ *FRAME-Y* 850)) 16 0 "Drawing 1/23 complete. Processing next CSV row...")

  (command "COLOR" 8)
  (command "LINE" (list 150 (+ *FRAME-Y* 650)) (list 1750 (+ *FRAME-Y* 650))
    (list 1750 (+ *FRAME-Y* 780)) (list 150 (+ *FRAME-Y* 780)) "C")

  (command "COLOR" 3)
  (command "TEXT" (list 170 (+ *FRAME-Y* 750)) 10 0
    "MOTOR_ST;M2-LUEFTER;SCHUETZ;K2;MOTOR;M2;SICHERG;F2;THERMOR;T2;RELAIS;R2")
  (command "TEXT" (list 170 (+ *FRAME-Y* 720)) 10 0
    "STERN_DR;M3-PUMPE;SCHUETZ;K3;SCHUETZ;K4;SCHUETZ;K5;MOTOR;M3;SICHERG;F3...")
  (command "TEXT" (list 170 (+ *FRAME-Y* 690)) 10 0
    "DIREKT;L1-HALLE;SCHALTER;S1;SCHALTER;S2;SICHERG;F4")
  (command "COLOR" 8)
  (command "TEXT" (list 170 (+ *FRAME-Y* 660)) 10 0 "... 20 more rows ...")

  ;; Small preview drawings
  (command "COLOR" 7)
  (command "LINE" (list 200 (+ *FRAME-Y* 350)) (list 500 (+ *FRAME-Y* 350))
    (list 500 (+ *FRAME-Y* 550)) (list 200 (+ *FRAME-Y* 550)) "C")
  (command "TEXT" (list 220 (+ *FRAME-Y* 520)) 10 0 "M1-ANLAUF")
  (command "COLOR" 2)
  (command "TEXT" (list 220 (+ *FRAME-Y* 370)) 8 0 "DONE")

  (command "COLOR" 3)
  (command "LINE" (list 550 (+ *FRAME-Y* 350)) (list 850 (+ *FRAME-Y* 350))
    (list 850 (+ *FRAME-Y* 550)) (list 550 (+ *FRAME-Y* 550)) "C")
  (command "TEXT" (list 570 (+ *FRAME-Y* 520)) 10 0 "M2-LUEFTER")
  (command "TEXT" (list 570 (+ *FRAME-Y* 370)) 8 0 "GENERATING...")

  (command "COLOR" 8)
  (command "LINE" (list 900 (+ *FRAME-Y* 350)) (list 1200 (+ *FRAME-Y* 350))
    (list 1200 (+ *FRAME-Y* 550)) (list 900 (+ *FRAME-Y* 550)) "C")
  (command "TEXT" (list 920 (+ *FRAME-Y* 520)) 10 0 "M3-PUMPE")
  (command "TEXT" (list 920 (+ *FRAME-Y* 370)) 8 0 "Queued...")

  (command "LINE" (list 1250 (+ *FRAME-Y* 350)) (list 1550 (+ *FRAME-Y* 350))
    (list 1550 (+ *FRAME-Y* 550)) (list 1250 (+ *FRAME-Y* 550)) "C")
  (command "TEXT" (list 1350 (+ *FRAME-Y* 450)) 20 0 "+20")

  (command "COLOR" 2)
  (command "TEXT" (list 200 (+ *FRAME-Y* 280)) 14 0 "Each drawing: ~7 seconds")
  (command "TEXT" (list 200 (+ *FRAME-Y* 250)) 14 0 "23 drawings: ~2.5 minutes total")
  (command "COLOR" 9)
  (command "TEXT" (list 200 (+ *FRAME-Y* 200)) 12 0 "Meanwhile, the print queue is filling up...")

  (NARRATOR "AutoLISP moves to the next CSV row. Each complete circuit takes ~7 seconds to generate!")
)

(defun SCENE-SUMMARY ()
  (princ "\n=== Summary ===\n")

  (NEXT-FRAME "DWG Generation Summary")

  (command "COLOR" 3)
  (command "TEXT" (list 300 (+ *FRAME-Y* 850)) 30 0 "THE GENERATION PROCESS")

  (command "COLOR" 7)
  (command "TEXT" (list 200 (+ *FRAME-Y* 750)) 14 0 "For each CSV row, AutoLISP:")

  (command "COLOR" 9)
  (command "TEXT" (list 220 (+ *FRAME-Y* 700)) 12 0 "1. Creates new drawing from template (NEW)")
  (command "TEXT" (list 220 (+ *FRAME-Y* 670)) 12 0 "2. Fills title block with name, date, company")
  (command "TEXT" (list 220 (+ *FRAME-Y* 640)) 12 0 "3. Draws each component from CSV (SCHUETZ, MOTOR, etc.)")
  (command "TEXT" (list 220 (+ *FRAME-Y* 610)) 12 0 "4. Connects components with wire lines")
  (command "TEXT" (list 220 (+ *FRAME-Y* 580)) 12 0 "5. Saves the DWG file")
  (command "TEXT" (list 220 (+ *FRAME-Y* 550)) 12 0 "6. Sends to print queue")
  (command "TEXT" (list 220 (+ *FRAME-Y* 520)) 12 0 "7. Moves to next CSV row - repeat!")

  (command "COLOR" 2)
  (command "TEXT" (list 200 (+ *FRAME-Y* 440)) 16 0 "Result: 23 complete, valid circuit diagrams")
  (command "TEXT" (list 200 (+ *FRAME-Y* 400)) 14 0 "Ready for production, ready for print")

  (command "COLOR" 3)
  (command "TEXT" (list 200 (+ *FRAME-Y* 320)) 20 0 "Manual: 5+ hours per drawing x 23 = 115+ hours")
  (command "COLOR" 2)
  (command "TEXT" (list 200 (+ *FRAME-Y* 280)) 20 0 "AutoLISP: 7 seconds per drawing x 23 = 2.5 minutes")

  (command "COLOR" 1)
  (command "TEXT" (list 400 (+ *FRAME-Y* 200)) 35 0 "99.96% TIME SAVED")

  (NARRATOR "From CSV to complete DWG in seconds. This is the power of AutoLISP automation!")
)

;;; ============================================
;;; MAIN
;;; ============================================

(defun C:DWGGEN ()
  (princ "\n")
  (princ "============================================\n")
  (princ "  DWG GENERATION - Deep Dive\n")
  (princ "============================================\n")
  (princ "\n")

  (setq *FRAME-NUM* 0)
  (setq *FRAME-Y* 0)

  (SCENE-INTRO)
  (SCENE-NEW-DRAWING)
  (SCENE-DRAW-FRAME)
  (SCENE-TITLE-BLOCK)
  (SCENE-POWER-RAILS)
  (SCENE-CONTROL-RAILS)
  (SCENE-FUSES)
  (SCENE-CONTACTOR-MAIN)
  (SCENE-CONTACTOR-COIL)
  (SCENE-THERMAL-RELAY)
  (SCENE-MOTOR)
  (SCENE-CONTROL-RELAY)
  (SCENE-CONNECTIONS)
  (SCENE-COMPLETE)
  (SCENE-NEXT-DRAWING)
  (SCENE-SUMMARY)

  (princ "\n")
  (princ "============================================\n")
  (princ (strcat "  Total frames: " (itoa *FRAME-NUM*) "\n"))
  (princ "============================================\n")

  (princ)
)

(C:DWGGEN)
