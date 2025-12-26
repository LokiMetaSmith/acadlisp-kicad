;;; REALWORK.LSP - The REAL Workflow!
;;;
;;; Each drawing is a COMPLETE Schaltkreis (circuit diagram):
;;; 1. CSV contains: TPL;NAME;components...
;;; 2. TPL (template) is loaded first - contains title block, frame, basic circuit
;;; 3. Components from CSV are drawn INTO the template
;;; 4. Result: Complete, valid electrical schematic ready for production
;;;
;;; Example CSV row:
;;; MOTOR_ST;M1-ANLAUF;SCHUETZ;K1;SCHUETZ;K2;MOTOR;M1;SICHERUNG;F1;RELAIS;R1
;;;
;;; This creates: Motor starter circuit M1-ANLAUF using template MOTOR_ST.DWG
;;; with contactors K1, K2, motor M1, fuse F1, relay R1
;;;

(setq *SCREEN-W* 1920)
(setq *SCREEN-H* 1080)
(setq *FRAME-NUM* 0)
(setq *FRAME-Y* 0)

;;; ============================================
;;; HELPERS
;;; ============================================

(defun NEXT-FRAME (title duration)
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

(defun NARRATOR (text)
  (command "COLOR" 2)
  (command "LINE" (list 40 (+ *FRAME-Y* 50)) (list 1880 (+ *FRAME-Y* 50))
    (list 1880 (+ *FRAME-Y* 110)) (list 40 (+ *FRAME-Y* 110)) "C")
  (command "COLOR" 0)
  (command "LINE" (list 42 (+ *FRAME-Y* 52)) (list 1878 (+ *FRAME-Y* 52))
    (list 1878 (+ *FRAME-Y* 108)) (list 42 (+ *FRAME-Y* 108)) "C")
  (command "COLOR" 2)
  (command "TEXT" (list 60 (+ *FRAME-Y* 75)) 14 0 text)
)

;;; ============================================
;;; DRAW DIN A3 DRAWING FRAME WITH TITLE BLOCK
;;; ============================================

(defun DRAW-TEMPLATE-FRAME (tpl-name drawing-name)
  "Draw the DIN A3 drawing frame with title block"

  ;; Outer frame (A3 = 420x297mm, scaled)
  (command "COLOR" 7)
  (command "LINE"
    (list 100 (+ *FRAME-Y* 200))
    (list 1700 (+ *FRAME-Y* 200))
    (list 1700 (+ *FRAME-Y* 950))
    (list 100 (+ *FRAME-Y* 950))
    "C")

  ;; Inner margin
  (command "COLOR" 8)
  (command "LINE"
    (list 120 (+ *FRAME-Y* 220))
    (list 1680 (+ *FRAME-Y* 220))
    (list 1680 (+ *FRAME-Y* 930))
    (list 120 (+ *FRAME-Y* 930))
    "C")

  ;; Title block (bottom right, DIN standard)
  (command "COLOR" 7)
  ;; Outer title block
  (command "LINE"
    (list 1200 (+ *FRAME-Y* 200))
    (list 1700 (+ *FRAME-Y* 200))
    (list 1700 (+ *FRAME-Y* 350))
    (list 1200 (+ *FRAME-Y* 350))
    "C")

  ;; Title block divisions
  (command "LINE" (list 1200 (+ *FRAME-Y* 320)) (list 1700 (+ *FRAME-Y* 320)) "")
  (command "LINE" (list 1200 (+ *FRAME-Y* 290)) (list 1700 (+ *FRAME-Y* 290)) "")
  (command "LINE" (list 1200 (+ *FRAME-Y* 260)) (list 1700 (+ *FRAME-Y* 260)) "")
  (command "LINE" (list 1200 (+ *FRAME-Y* 230)) (list 1700 (+ *FRAME-Y* 230)) "")
  (command "LINE" (list 1450 (+ *FRAME-Y* 200)) (list 1450 (+ *FRAME-Y* 290)) "")

  ;; Company name
  (command "COLOR" 7)
  (command "TEXT" (list 1220 (+ *FRAME-Y* 330)) 12 0 "Schmidt & Weber GmbH")
  (command "COLOR" 8)
  (command "TEXT" (list 1500 (+ *FRAME-Y* 330)) 8 0 "Muenchen")

  ;; Drawing title
  (command "COLOR" 2)
  (command "TEXT" (list 1220 (+ *FRAME-Y* 298)) 14 0 drawing-name)

  ;; Template name
  (command "COLOR" 9)
  (command "TEXT" (list 1220 (+ *FRAME-Y* 268)) 10 0 (strcat "TPL: " tpl-name))

  ;; Drawing number and date
  (command "COLOR" 7)
  (command "TEXT" (list 1220 (+ *FRAME-Y* 240)) 8 0 "Blatt: 1/1")
  (command "TEXT" (list 1460 (+ *FRAME-Y* 240)) 8 0 "15.12.1991")

  ;; Scale and drawn by
  (command "TEXT" (list 1220 (+ *FRAME-Y* 212)) 8 0 "M 1:1")
  (command "TEXT" (list 1460 (+ *FRAME-Y* 212)) 8 0 "AutoLISP")
)

;;; ============================================
;;; DRAW MOTOR STARTER CIRCUIT (MOTOR_ST template)
;;; ============================================

(defun DRAW-MOTOR-STARTER-BASE ()
  "Draw the base motor starter circuit from template"

  ;; Power rails (3-phase: L1, L2, L3)
  (command "COLOR" 1)
  (command "LINE" (list 300 (+ *FRAME-Y* 900)) (list 300 (+ *FRAME-Y* 400)) "")
  (command "TEXT" (list 290 (+ *FRAME-Y* 920)) 10 0 "L1")

  (command "COLOR" 2)
  (command "LINE" (list 500 (+ *FRAME-Y* 900)) (list 500 (+ *FRAME-Y* 400)) "")
  (command "TEXT" (list 490 (+ *FRAME-Y* 920)) 10 0 "L2")

  (command "COLOR" 4)
  (command "LINE" (list 700 (+ *FRAME-Y* 900)) (list 700 (+ *FRAME-Y* 400)) "")
  (command "TEXT" (list 690 (+ *FRAME-Y* 920)) 10 0 "L3")

  ;; Neutral
  (command "COLOR" 7)
  (command "LINE" (list 900 (+ *FRAME-Y* 900)) (list 900 (+ *FRAME-Y* 400)) "")
  (command "TEXT" (list 890 (+ *FRAME-Y* 920)) 10 0 "N")

  ;; PE (ground)
  (command "COLOR" 3)
  (command "LINE" (list 1000 (+ *FRAME-Y* 900)) (list 1000 (+ *FRAME-Y* 400)) "")
  (command "TEXT" (list 985 (+ *FRAME-Y* 920)) 10 0 "PE")

  ;; Connection points (placeholder boxes where components go)
  (command "COLOR" 8)
  ;; Fuse position
  (command "LINE" (list 280 (+ *FRAME-Y* 820)) (list 320 (+ *FRAME-Y* 820))
    (list 320 (+ *FRAME-Y* 780)) (list 280 (+ *FRAME-Y* 780)) "C")
  (command "LINE" (list 480 (+ *FRAME-Y* 820)) (list 520 (+ *FRAME-Y* 820))
    (list 520 (+ *FRAME-Y* 780)) (list 480 (+ *FRAME-Y* 780)) "C")
  (command "LINE" (list 680 (+ *FRAME-Y* 820)) (list 720 (+ *FRAME-Y* 820))
    (list 720 (+ *FRAME-Y* 780)) (list 680 (+ *FRAME-Y* 780)) "C")

  ;; Contactor K1 position
  (command "LINE" (list 270 (+ *FRAME-Y* 700)) (list 330 (+ *FRAME-Y* 700))
    (list 330 (+ *FRAME-Y* 620)) (list 270 (+ *FRAME-Y* 620)) "C")
  (command "LINE" (list 470 (+ *FRAME-Y* 700)) (list 530 (+ *FRAME-Y* 700))
    (list 530 (+ *FRAME-Y* 620)) (list 470 (+ *FRAME-Y* 620)) "C")
  (command "LINE" (list 670 (+ *FRAME-Y* 700)) (list 730 (+ *FRAME-Y* 700))
    (list 730 (+ *FRAME-Y* 620)) (list 670 (+ *FRAME-Y* 620)) "C")

  ;; Motor position
  (command "CIRCLE" (list 500 (+ *FRAME-Y* 480)) 70)

  ;; Control circuit area (right side)
  (command "COLOR" 8)
  (command "LINE" (list 1100 (+ *FRAME-Y* 850)) (list 1100 (+ *FRAME-Y* 400)) "")
  (command "TEXT" (list 1080 (+ *FRAME-Y* 870)) 8 0 "24V")
  (command "LINE" (list 1500 (+ *FRAME-Y* 850)) (list 1500 (+ *FRAME-Y* 400)) "")
  (command "TEXT" (list 1480 (+ *FRAME-Y* 870)) 8 0 "0V")
)

(defun DRAW-FUSE (x y label)
  "Draw fuse symbol at position"
  (command "COLOR" 7)
  ;; Fuse body
  (command "LINE" (list (- x 15) (+ *FRAME-Y* y)) (list (+ x 15) (+ *FRAME-Y* y))
    (list (+ x 15) (+ *FRAME-Y* y -40)) (list (- x 15) (+ *FRAME-Y* y -40)) "C")
  ;; Fuse element
  (command "LINE" (list (- x 15) (+ *FRAME-Y* y -20)) (list (+ x 15) (+ *FRAME-Y* y -20)) "")
  ;; Label
  (command "COLOR" 2)
  (command "TEXT" (list (+ x 20) (+ *FRAME-Y* y -15)) 10 0 label)
)

(defun DRAW-CONTACTOR-CONTACT (x y label)
  "Draw contactor main contact"
  (command "COLOR" 7)
  ;; Contact points
  (command "LINE" (list x (+ *FRAME-Y* y)) (list x (+ *FRAME-Y* y -15)) "")
  (command "LINE" (list x (+ *FRAME-Y* y -55)) (list x (+ *FRAME-Y* y -70)) "")
  ;; Moving contact (open)
  (command "LINE" (list x (+ *FRAME-Y* y -15)) (list (+ x 20) (+ *FRAME-Y* y -45)) "")
  ;; Actuator line
  (command "COLOR" 8)
  (command "LINE" (list (+ x 10) (+ *FRAME-Y* y -30)) (list (+ x 50) (+ *FRAME-Y* y -30)) "")
  ;; Label
  (command "COLOR" 2)
  (command "TEXT" (list (+ x 25) (+ *FRAME-Y* y -15)) 10 0 label)
)

(defun DRAW-CONTACTOR-COIL (x y label)
  "Draw contactor coil in control circuit"
  (command "COLOR" 7)
  ;; Coil rectangle
  (command "LINE" (list (- x 20) (+ *FRAME-Y* y)) (list (+ x 20) (+ *FRAME-Y* y))
    (list (+ x 20) (+ *FRAME-Y* y -60)) (list (- x 20) (+ *FRAME-Y* y -60)) "C")
  ;; Coil symbol (arcs)
  (command "COLOR" 6)
  (command "ARC" (list (- x 10) (+ *FRAME-Y* y -15)) (list x (+ *FRAME-Y* y -10))
    (list (+ x 10) (+ *FRAME-Y* y -15)))
  (command "ARC" (list (- x 10) (+ *FRAME-Y* y -30)) (list x (+ *FRAME-Y* y -25))
    (list (+ x 10) (+ *FRAME-Y* y -30)))
  (command "ARC" (list (- x 10) (+ *FRAME-Y* y -45)) (list x (+ *FRAME-Y* y -40))
    (list (+ x 10) (+ *FRAME-Y* y -45)))
  ;; Label
  (command "COLOR" 2)
  (command "TEXT" (list (+ x 30) (+ *FRAME-Y* y -25)) 12 0 label)
  ;; Terminal labels
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 25) (+ *FRAME-Y* y 5)) 8 0 "A1")
  (command "TEXT" (list (+ x 25) (+ *FRAME-Y* y -65)) 8 0 "A2")
)

(defun DRAW-MOTOR-SYMBOL (x y label power)
  "Draw three-phase motor"
  (command "COLOR" 7)
  (command "CIRCLE" (list x (+ *FRAME-Y* y)) 50)
  (command "TEXT" (list (- x 15) (+ *FRAME-Y* y -10)) 30 0 "M")
  (command "TEXT" (list (- x 12) (+ *FRAME-Y* y 25)) 15 0 "3~")
  ;; Terminals
  (command "LINE" (list (- x 25) (+ *FRAME-Y* y 50)) (list (- x 25) (+ *FRAME-Y* y 80)) "")
  (command "LINE" (list x (+ *FRAME-Y* y 50)) (list x (+ *FRAME-Y* y 80)) "")
  (command "LINE" (list (+ x 25) (+ *FRAME-Y* y 50)) (list (+ x 25) (+ *FRAME-Y* y 80)) "")
  ;; Label
  (command "COLOR" 2)
  (command "TEXT" (list (+ x 60) (+ *FRAME-Y* y -10)) 14 0 label)
  (command "COLOR" 9)
  (command "TEXT" (list (+ x 60) (+ *FRAME-Y* y 15)) 10 0 power)
)

(defun DRAW-RELAY-COIL (x y label)
  "Draw relay coil"
  (command "COLOR" 7)
  (command "LINE" (list (- x 15) (+ *FRAME-Y* y)) (list (+ x 15) (+ *FRAME-Y* y))
    (list (+ x 15) (+ *FRAME-Y* y -40)) (list (- x 15) (+ *FRAME-Y* y -40)) "C")
  ;; Relay symbol (rectangle with line)
  (command "LINE" (list (- x 10) (+ *FRAME-Y* y -10)) (list (+ x 10) (+ *FRAME-Y* y -10))
    (list (+ x 10) (+ *FRAME-Y* y -30)) (list (- x 10) (+ *FRAME-Y* y -30)) "C")
  (command "COLOR" 2)
  (command "TEXT" (list (+ x 20) (+ *FRAME-Y* y -15)) 10 0 label)
)

;;; ============================================
;;; ANIMATION SCENES
;;; ============================================

(defun SCENE-EXPLAIN-CSV ()
  "Show the CSV structure"
  (princ "\n=== CSV Structure ===\n")

  (NEXT-FRAME "The CSV Structure" 6)

  (command "COLOR" 7)
  (command "TEXT" (list 200 (+ *FRAME-Y* 900)) 20 0 "KOMPONEN.CSV - Each row = One COMPLETE drawing!")

  ;; CSV content box
  (command "COLOR" 8)
  (command "LINE" (list 150 (+ *FRAME-Y* 550)) (list 1750 (+ *FRAME-Y* 550))
    (list 1750 (+ *FRAME-Y* 850)) (list 150 (+ *FRAME-Y* 850)) "C")

  ;; Header row
  (command "COLOR" 4)
  (command "TEXT" (list 170 (+ *FRAME-Y* 820)) 12 0
    "TPL;NAME;TYP1;BEZ1;TYP2;BEZ2;TYP3;BEZ3;TYP4;BEZ4;TYP5;BEZ5")

  ;; Data rows
  (command "COLOR" 3)
  (command "TEXT" (list 170 (+ *FRAME-Y* 780)) 11 0
    "MOTOR_ST;M1-ANLAUF;SCHUETZ;K1;SCHUETZ;K2;MOTOR;M1;SICHERG;F1;RELAIS;R1")
  (command "TEXT" (list 170 (+ *FRAME-Y* 750)) 11 0
    "MOTOR_ST;M2-LUEFTER;SCHUETZ;K3;SCHUETZ;K4;MOTOR;M2;SICHERG;F2;RELAIS;R2")
  (command "TEXT" (list 170 (+ *FRAME-Y* 720)) 11 0
    "STERN_DR;M3-PUMPE;SCHUETZ;K5;SCHUETZ;K6;SCHUETZ;K7;MOTOR;M3;SICHERG;F3")
  (command "TEXT" (list 170 (+ *FRAME-Y* 690)) 11 0
    "DIREKT;S1-LICHT;SCHALTER;S1;SCHALTER;S2;SICHERG;F4;;;;;;")
  (command "COLOR" 8)
  (command "TEXT" (list 170 (+ *FRAME-Y* 650)) 10 0
    "... 19 more circuits ...")

  ;; Explanation
  (command "COLOR" 9)
  (command "TEXT" (list 200 (+ *FRAME-Y* 500)) 14 0 "TPL = Template file (MOTOR_ST.DWG, STERN_DR.DWG, DIREKT.DWG)")
  (command "TEXT" (list 200 (+ *FRAME-Y* 460)) 14 0 "NAME = Drawing name / circuit identifier")
  (command "TEXT" (list 200 (+ *FRAME-Y* 420)) 14 0 "TYPn;BEZn = Component type and designation pairs")

  (command "COLOR" 2)
  (command "TEXT" (list 200 (+ *FRAME-Y* 350)) 16 0 "Each row creates ONE COMPLETE Schaltkreis!")
  (command "TEXT" (list 200 (+ *FRAME-Y* 310)) 12 0 "The template provides the base circuit - CSV fills in the specific components")

  (NARRATOR "Each CSV row defines a complete circuit diagram. TPL names the template, then component pairs fill it in.")
)

(defun SCENE-LOAD-TEMPLATE ()
  "Show template being loaded"
  (princ "\n=== Loading Template ===\n")

  (NEXT-FRAME "Step 1: Load Template MOTOR_ST.DWG" 5)

  ;; Command line
  (command "COLOR" 7)
  (command "TEXT" (list 100 (+ *FRAME-Y* 980)) 12 0 "Command: (LOAD-TPL \"MOTOR_ST\")")
  (command "COLOR" 3)
  (command "TEXT" (list 100 (+ *FRAME-Y* 960)) 10 0 "Loading template: C:\\ACAD\\TPL\\MOTOR_ST.DWG")
  (command "TEXT" (list 100 (+ *FRAME-Y* 940)) 10 0 "Template loaded - Motor starter base circuit ready")

  ;; Draw template frame
  (DRAW-TEMPLATE-FRAME "MOTOR_ST" "M1-ANLAUF")

  ;; Draw base circuit from template
  (DRAW-MOTOR-STARTER-BASE)

  (command "COLOR" 9)
  (command "TEXT" (list 150 (+ *FRAME-Y* 380)) 12 0 "Template contains:")
  (command "TEXT" (list 170 (+ *FRAME-Y* 355)) 10 0 "- DIN A3 frame with title block")
  (command "TEXT" (list 170 (+ *FRAME-Y* 335)) 10 0 "- 3-phase power rails (L1, L2, L3, N, PE)")
  (command "TEXT" (list 170 (+ *FRAME-Y* 315)) 10 0 "- 24V control circuit")
  (command "TEXT" (list 170 (+ *FRAME-Y* 295)) 10 0 "- Placeholder positions for components")

  (NARRATOR "Template MOTOR_ST.DWG loaded. It has the standard motor starter layout - now we fill in the components!")
)

(defun SCENE-ADD-COMPONENTS ()
  "Show components being added"
  (princ "\n=== Adding Components ===\n")

  ;; Add fuses
  (NEXT-FRAME "Step 2: Add Fuses F1" 4)
  (DRAW-TEMPLATE-FRAME "MOTOR_ST" "M1-ANLAUF")
  (DRAW-MOTOR-STARTER-BASE)

  (DRAW-FUSE 300 820 "F1")
  (DRAW-FUSE 500 820 "F1")
  (DRAW-FUSE 700 820 "F1")

  (command "COLOR" 7)
  (command "TEXT" (list 100 (+ *FRAME-Y* 980)) 10 0 "Command: (DRAW-SICHERG '(300 820) \"F1\")")
  (command "COLOR" 3)
  (command "TEXT" (list 100 (+ *FRAME-Y* 960)) 10 0 "Drawing fuse F1 at positions L1, L2, L3")

  (NARRATOR "Fuses F1 added to all three phases - protection for the motor circuit.")

  ;; Add main contactor K1
  (NEXT-FRAME "Step 3: Add Contactor K1" 4)
  (DRAW-TEMPLATE-FRAME "MOTOR_ST" "M1-ANLAUF")
  (DRAW-MOTOR-STARTER-BASE)
  (DRAW-FUSE 300 820 "F1")
  (DRAW-FUSE 500 820 "F1")
  (DRAW-FUSE 700 820 "F1")

  (DRAW-CONTACTOR-CONTACT 300 700 "K1")
  (DRAW-CONTACTOR-CONTACT 500 700 "K1")
  (DRAW-CONTACTOR-CONTACT 700 700 "K1")

  ;; K1 coil in control circuit
  (DRAW-CONTACTOR-COIL 1300 750 "K1")

  (command "COLOR" 7)
  (command "TEXT" (list 100 (+ *FRAME-Y* 980)) 10 0 "Command: (DRAW-SCHUETZ '(300 700) \"K1\")")
  (command "COLOR" 3)
  (command "TEXT" (list 100 (+ *FRAME-Y* 960)) 10 0 "Drawing main contactor K1 - contacts + coil")

  (NARRATOR "Contactor K1 added - main contacts in power circuit, coil in 24V control circuit.")

  ;; Add motor
  (NEXT-FRAME "Step 4: Add Motor M1" 4)
  (DRAW-TEMPLATE-FRAME "MOTOR_ST" "M1-ANLAUF")
  (DRAW-MOTOR-STARTER-BASE)
  (DRAW-FUSE 300 820 "F1")
  (DRAW-FUSE 500 820 "F1")
  (DRAW-FUSE 700 820 "F1")
  (DRAW-CONTACTOR-CONTACT 300 700 "K1")
  (DRAW-CONTACTOR-CONTACT 500 700 "K1")
  (DRAW-CONTACTOR-CONTACT 700 700 "K1")
  (DRAW-CONTACTOR-COIL 1300 750 "K1")

  (DRAW-MOTOR-SYMBOL 500 480 "M1" "5.5kW")

  (command "COLOR" 7)
  (command "TEXT" (list 100 (+ *FRAME-Y* 980)) 10 0 "Command: (DRAW-MOTOR '(500 480) \"M1\" \"5.5kW\")")
  (command "COLOR" 3)
  (command "TEXT" (list 100 (+ *FRAME-Y* 960)) 10 0 "Drawing motor M1 - 5.5kW three-phase")

  (NARRATOR "Motor M1 (5.5kW) added - connected to the three phases through K1.")

  ;; Add relay
  (NEXT-FRAME "Step 5: Add Relay R1 - COMPLETE!" 5)
  (DRAW-TEMPLATE-FRAME "MOTOR_ST" "M1-ANLAUF")
  (DRAW-MOTOR-STARTER-BASE)
  (DRAW-FUSE 300 820 "F1")
  (DRAW-FUSE 500 820 "F1")
  (DRAW-FUSE 700 820 "F1")
  (DRAW-CONTACTOR-CONTACT 300 700 "K1")
  (DRAW-CONTACTOR-CONTACT 500 700 "K1")
  (DRAW-CONTACTOR-CONTACT 700 700 "K1")
  (DRAW-CONTACTOR-COIL 1300 750 "K1")
  (DRAW-MOTOR-SYMBOL 500 480 "M1" "5.5kW")

  (DRAW-RELAY-COIL 1300 600 "R1")

  ;; Connection lines in control circuit
  (command "COLOR" 7)
  (command "LINE" (list 1100 (+ *FRAME-Y* 750)) (list 1280 (+ *FRAME-Y* 750)) "")
  (command "LINE" (list 1320 (+ *FRAME-Y* 690)) (list 1320 (+ *FRAME-Y* 600)) "")
  (command "LINE" (list 1300 (+ *FRAME-Y* 560)) (list 1300 (+ *FRAME-Y* 500)) "")
  (command "LINE" (list 1300 (+ *FRAME-Y* 500)) (list 1500 (+ *FRAME-Y* 500)) "")

  (command "COLOR" 2)
  (command "TEXT" (list 100 (+ *FRAME-Y* 980)) 12 0 "M1-ANLAUF.DWG - COMPLETE!")
  (command "COLOR" 3)
  (command "TEXT" (list 100 (+ *FRAME-Y* 960)) 10 0 "Saving and sending to print queue...")

  (NARRATOR "Circuit M1-ANLAUF complete! A valid motor starter schematic ready for production.")
)

(defun SCENE-MULTIPLE-DRAWINGS ()
  "Show multiple complete drawings"
  (princ "\n=== Multiple Complete Drawings ===\n")

  (NEXT-FRAME "23 Complete Circuit Diagrams" 6)

  (command "COLOR" 7)
  (command "TEXT" (list 300 (+ *FRAME-Y* 950)) 25 0 "23 Complete Schaltkreise Generated!")

  ;; Show small previews of different circuits
  ;; Circuit 1: Motor starter
  (command "COLOR" 8)
  (command "LINE" (list 150 (+ *FRAME-Y* 550)) (list 550 (+ *FRAME-Y* 550))
    (list 550 (+ *FRAME-Y* 850)) (list 150 (+ *FRAME-Y* 850)) "C")
  (command "COLOR" 7)
  (command "TEXT" (list 170 (+ *FRAME-Y* 820)) 10 0 "M1-ANLAUF")
  (command "COLOR" 8)
  (command "CIRCLE" (list 350 (+ *FRAME-Y* 650)) 30)
  (command "TEXT" (list 340 (+ *FRAME-Y* 645)) 15 0 "M")
  (command "LINE" (list 250 (+ *FRAME-Y* 750)) (list 250 (+ *FRAME-Y* 600)) "")
  (command "LINE" (list 350 (+ *FRAME-Y* 750)) (list 350 (+ *FRAME-Y* 700)) "")
  (command "LINE" (list 450 (+ *FRAME-Y* 750)) (list 450 (+ *FRAME-Y* 600)) "")

  ;; Circuit 2: Star-Delta
  (command "LINE" (list 600 (+ *FRAME-Y* 550)) (list 1000 (+ *FRAME-Y* 550))
    (list 1000 (+ *FRAME-Y* 850)) (list 600 (+ *FRAME-Y* 850)) "C")
  (command "COLOR" 7)
  (command "TEXT" (list 620 (+ *FRAME-Y* 820)) 10 0 "M3-PUMPE (Y/D)")
  (command "COLOR" 8)
  (command "CIRCLE" (list 800 (+ *FRAME-Y* 620)) 30)
  (command "TEXT" (list 790 (+ *FRAME-Y* 615)) 15 0 "M")
  ;; Star-delta contactors
  (command "LINE" (list 700 (+ *FRAME-Y* 750)) (list 700 (+ *FRAME-Y* 700)) "")
  (command "LINE" (list 800 (+ *FRAME-Y* 750)) (list 800 (+ *FRAME-Y* 700)) "")
  (command "LINE" (list 900 (+ *FRAME-Y* 750)) (list 900 (+ *FRAME-Y* 700)) "")
  (command "TEXT" (list 680 (+ *FRAME-Y* 770)) 8 0 "K5")
  (command "TEXT" (list 780 (+ *FRAME-Y* 770)) 8 0 "K6")
  (command "TEXT" (list 880 (+ *FRAME-Y* 770)) 8 0 "K7")

  ;; Circuit 3: Direct switch
  (command "LINE" (list 1050 (+ *FRAME-Y* 550)) (list 1450 (+ *FRAME-Y* 550))
    (list 1450 (+ *FRAME-Y* 850)) (list 1050 (+ *FRAME-Y* 850)) "C")
  (command "COLOR" 7)
  (command "TEXT" (list 1070 (+ *FRAME-Y* 820)) 10 0 "S1-LICHT")
  (command "COLOR" 8)
  ;; Simple switch circuit
  (command "LINE" (list 1150 (+ *FRAME-Y* 750)) (list 1150 (+ *FRAME-Y* 600)) "")
  (command "LINE" (list 1350 (+ *FRAME-Y* 750)) (list 1350 (+ *FRAME-Y* 600)) "")
  (command "CIRCLE" (list 1150 (+ *FRAME-Y* 680)) 8)
  (command "CIRCLE" (list 1200 (+ *FRAME-Y* 680)) 8)
  (command "TEXT" (list 1160 (+ *FRAME-Y* 650)) 8 0 "S1")

  ;; More circuits indicator
  (command "LINE" (list 1500 (+ *FRAME-Y* 550)) (list 1800 (+ *FRAME-Y* 550))
    (list 1800 (+ *FRAME-Y* 850)) (list 1500 (+ *FRAME-Y* 850)) "C")
  (command "COLOR" 7)
  (command "TEXT" (list 1580 (+ *FRAME-Y* 720)) 20 0 "+20")
  (command "TEXT" (list 1560 (+ *FRAME-Y* 680)) 12 0 "more...")

  ;; Stats
  (command "COLOR" 2)
  (command "TEXT" (list 200 (+ *FRAME-Y* 450)) 16 0 "Each drawing is a COMPLETE, VALID circuit diagram")
  (command "COLOR" 9)
  (command "TEXT" (list 200 (+ *FRAME-Y* 410)) 12 0 "- 8 Motor starter circuits (MOTOR_ST template)")
  (command "TEXT" (list 200 (+ *FRAME-Y* 380)) 12 0 "- 4 Star-Delta starter circuits (STERN_DR template)")
  (command "TEXT" (list 200 (+ *FRAME-Y* 350)) 12 0 "- 6 Direct switching circuits (DIREKT template)")
  (command "TEXT" (list 200 (+ *FRAME-Y* 320)) 12 0 "- 5 Lighting/auxiliary circuits (AUX template)")

  (command "COLOR" 3)
  (command "TEXT" (list 200 (+ *FRAME-Y* 260)) 18 0 "All ready for production - send to LaserJet!")

  (NARRATOR "23 complete circuit diagrams - each a valid schematic that can go directly to manufacturing!")
)

(defun SCENE-FINAL ()
  "Final summary"
  (princ "\n=== Final ===\n")

  (NEXT-FRAME "The Power of Templates + CSV" 8)

  (command "COLOR" 3)
  (command "TEXT" (list 400 (+ *FRAME-Y* 850)) 35 0 "TEMPLATE + CSV")
  (command "COLOR" 7)
  (command "TEXT" (list 400 (+ *FRAME-Y* 780)) 20 0 "= Complete Production Drawings")

  ;; Flow diagram
  (command "COLOR" 9)
  ;; CSV box
  (command "LINE" (list 200 (+ *FRAME-Y* 550)) (list 450 (+ *FRAME-Y* 550))
    (list 450 (+ *FRAME-Y* 650)) (list 200 (+ *FRAME-Y* 650)) "C")
  (command "TEXT" (list 250 (+ *FRAME-Y* 590)) 14 0 "KOMPONEN.CSV")
  (command "COLOR" 8)
  (command "TEXT" (list 220 (+ *FRAME-Y* 560)) 8 0 "23 circuit definitions")

  ;; Arrow
  (command "COLOR" 7)
  (command "LINE" (list 450 (+ *FRAME-Y* 600)) (list 550 (+ *FRAME-Y* 600)) "")
  (command "TEXT" (list 480 (+ *FRAME-Y* 620)) 10 0 "+")

  ;; Template box
  (command "COLOR" 9)
  (command "LINE" (list 550 (+ *FRAME-Y* 550)) (list 800 (+ *FRAME-Y* 550))
    (list 800 (+ *FRAME-Y* 650)) (list 550 (+ *FRAME-Y* 650)) "C")
  (command "TEXT" (list 600 (+ *FRAME-Y* 590)) 14 0 "Templates")
  (command "COLOR" 8)
  (command "TEXT" (list 570 (+ *FRAME-Y* 560)) 8 0 "MOTOR_ST, STERN_DR...")

  ;; Arrow
  (command "COLOR" 7)
  (command "LINE" (list 800 (+ *FRAME-Y* 600)) (list 900 (+ *FRAME-Y* 600)) "")
  (command "TEXT" (list 830 (+ *FRAME-Y* 620)) 10 0 "=")

  ;; Result box
  (command "COLOR" 2)
  (command "LINE" (list 900 (+ *FRAME-Y* 530)) (list 1250 (+ *FRAME-Y* 530))
    (list 1250 (+ *FRAME-Y* 670)) (list 900 (+ *FRAME-Y* 670)) "C")
  (command "TEXT" (list 950 (+ *FRAME-Y* 610)) 14 0 "23 Complete")
  (command "TEXT" (list 950 (+ *FRAME-Y* 580)) 14 0 "Schaltkreise")
  (command "COLOR" 9)
  (command "TEXT" (list 950 (+ *FRAME-Y* 545)) 10 0 "Ready for production!")

  ;; Arrow to printer
  (command "COLOR" 7)
  (command "LINE" (list 1250 (+ *FRAME-Y* 600)) (list 1350 (+ *FRAME-Y* 600)) "")

  ;; Printer
  (command "COLOR" 7)
  (command "LINE" (list 1350 (+ *FRAME-Y* 530)) (list 1600 (+ *FRAME-Y* 530))
    (list 1600 (+ *FRAME-Y* 670)) (list 1350 (+ *FRAME-Y* 670)) "C")
  (command "COLOR" 4)
  (command "TEXT" (list 1380 (+ *FRAME-Y* 620)) 12 0 "HP LaserJet")
  (command "COLOR" 7)
  (command "TEXT" (list 1400 (+ *FRAME-Y* 580)) 10 0 "23 pages")

  ;; Bottom stats
  (command "COLOR" 3)
  (command "TEXT" (list 300 (+ *FRAME-Y* 400)) 25 0 "Manual: 5+ hours per circuit x 23 = 115+ hours")
  (command "COLOR" 2)
  (command "TEXT" (list 300 (+ *FRAME-Y* 350)) 25 0 "AutoLISP: 2.5 minutes for ALL 23 circuits")

  (command "COLOR" 1)
  (command "TEXT" (list 500 (+ *FRAME-Y* 280)) 35 0 "TIME SAVED: 99.96%")

  (NARRATOR "Templates + CSV + AutoLISP = Complete production drawings in minutes instead of weeks!")
)

;;; ============================================
;;; MAIN
;;; ============================================

(defun C:REALWORK ()
  (princ "\n")
  (princ "============================================\n")
  (princ "  THE REAL WORKFLOW\n")
  (princ "  Templates + CSV = Complete Circuits\n")
  (princ "============================================\n")
  (princ "\n")

  (setq *FRAME-NUM* 0)
  (setq *FRAME-Y* 0)

  (SCENE-EXPLAIN-CSV)
  (SCENE-LOAD-TEMPLATE)
  (SCENE-ADD-COMPONENTS)
  (SCENE-MULTIPLE-DRAWINGS)
  (SCENE-FINAL)

  (princ "\n")
  (princ "============================================\n")
  (princ (strcat "  Total frames: " (itoa *FRAME-NUM*) "\n"))
  (princ "============================================\n")

  (princ)
)

(C:REALWORK)
