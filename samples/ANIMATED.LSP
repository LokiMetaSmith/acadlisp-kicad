;;; ANIMATED.LSP - Watch the drawings being created!
;;; Shows the actual drawing process with print queue
;;;
;;; Features:
;;; - Drawing commands visible (CMDECHO on!)
;;; - Lines appearing step by step
;;; - Symbols being constructed
;;; - Print queue filling up while next drawing starts
;;;

;;; ============================================
;;; CONFIGURATION
;;; ============================================

(setq *SCREEN-W* 1920)
(setq *SCREEN-H* 1080)
(setq *FRAME-NUM* 0)
(setq *FRAME-Y* 0)

;; Print queue state
(setq *PRINT-QUEUE* nil)
(setq *QUEUE-COUNT* 0)

;;; ============================================
;;; FRAME HELPERS
;;; ============================================

(defun NEXT-FRAME (title duration)
  (setq *FRAME-NUM* (1+ *FRAME-NUM*))
  (setq *FRAME-Y* (* (1- *FRAME-NUM*) (+ *SCREEN-H* 20)))

  ;; Black background
  (command "COLOR" 0)
  (command "LINE"
    (list 0 *FRAME-Y*)
    (list *SCREEN-W* *FRAME-Y*)
    (list *SCREEN-W* (+ *FRAME-Y* *SCREEN-H*))
    (list 0 (+ *FRAME-Y* *SCREEN-H*))
    "C")

  ;; Frame info
  (command "COLOR" 8)
  (command "TEXT" (list 20 (+ *FRAME-Y* 20)) 10 0
    (strcat "Frame " (itoa *FRAME-NUM*) " | " title))

  *FRAME-Y*
)

(defun DRAW-ACAD-SCREEN (show-slow-mode)
  "Draw AutoCAD screen layout with drawing area and command line"
  ;; Main drawing area (black)
  (command "COLOR" 0)
  (command "LINE"
    (list 50 (+ *FRAME-Y* 180))
    (list 1400 (+ *FRAME-Y* 180))
    (list 1400 (+ *FRAME-Y* 950))
    (list 50 (+ *FRAME-Y* 950))
    "C")

  ;; Drawing area border
  (command "COLOR" 8)
  (command "LINE"
    (list 50 (+ *FRAME-Y* 180))
    (list 1400 (+ *FRAME-Y* 180))
    (list 1400 (+ *FRAME-Y* 950))
    (list 50 (+ *FRAME-Y* 950))
    "C")

  ;; Menu bar at top
  (command "COLOR" 7)
  (command "LINE"
    (list 50 (+ *FRAME-Y* 950))
    (list 1400 (+ *FRAME-Y* 950))
    (list 1400 (+ *FRAME-Y* 980))
    (list 50 (+ *FRAME-Y* 980))
    "C")
  (command "COLOR" 0)
  (command "TEXT" (list 70 (+ *FRAME-Y* 960)) 10 0 "File  Edit  View  Draw  Modify  Settings  Help")

  ;; Command line area
  (command "COLOR" 7)
  (command "LINE"
    (list 50 (+ *FRAME-Y* 100))
    (list 1400 (+ *FRAME-Y* 100))
    (list 1400 (+ *FRAME-Y* 175))
    (list 50 (+ *FRAME-Y* 175))
    "C")

  ;; Status bar
  (command "COLOR" 8)
  (command "LINE"
    (list 50 (+ *FRAME-Y* 70))
    (list 1400 (+ *FRAME-Y* 70))
    (list 1400 (+ *FRAME-Y* 95))
    (list 50 (+ *FRAME-Y* 95))
    "C")
  (command "COLOR" 7)
  (command "TEXT" (list 60 (+ *FRAME-Y* 78)) 8 0 "Layer: 0   Ortho   Snap   Grid")

  ;; Slow mode indicator
  (if show-slow-mode
    (progn
      (command "COLOR" 2)
      (command "TEXT" (list 1100 (+ *FRAME-Y* 960)) 10 0 "SLOW MODE")
      (command "COLOR" 8)
      (command "TEXT" (list 1100 (+ *FRAME-Y* 78)) 8 0 "CMDECHO=1 BLIPMODE=1")
    )
  )
)

(defun DRAW-PRINT-QUEUE ()
  "Draw the print queue panel on the right"
  ;; Print queue panel
  (command "COLOR" 8)
  (command "LINE"
    (list 1450 (+ *FRAME-Y* 180))
    (list 1870 (+ *FRAME-Y* 180))
    (list 1870 (+ *FRAME-Y* 950))
    (list 1450 (+ *FRAME-Y* 950))
    "C")

  ;; Header
  (command "COLOR" 4)
  (command "LINE"
    (list 1450 (+ *FRAME-Y* 900))
    (list 1870 (+ *FRAME-Y* 900))
    (list 1870 (+ *FRAME-Y* 950))
    (list 1450 (+ *FRAME-Y* 950))
    "C")
  (command "COLOR" 7)
  (command "TEXT" (list 1480 (+ *FRAME-Y* 920)) 14 0 "HP LaserJet III")
  (command "COLOR" 9)
  (command "TEXT" (list 1480 (+ *FRAME-Y* 875)) 10 0 "Print Queue:")
)

(defun DRAW-QUEUE-ITEM (index name status)
  "Draw a single item in the print queue"
  (setq item-y (- 850 (* index 35)))

  (cond
    ((= status "PRINTING")
      (command "COLOR" 2)
      (command "TEXT" (list 1470 (+ *FRAME-Y* item-y)) 10 0
        (strcat "[>>] " name ".DWG - PRINTING...")))
    ((= status "QUEUED")
      (command "COLOR" 7)
      (command "TEXT" (list 1470 (+ *FRAME-Y* item-y)) 10 0
        (strcat "[" (itoa (1+ index)) "] " name ".DWG - Queued")))
    ((= status "DONE")
      (command "COLOR" 8)
      (command "TEXT" (list 1470 (+ *FRAME-Y* item-y)) 10 0
        (strcat "[OK] " name ".DWG - Done")))
  )
)

(defun CMD-LINE (y text color)
  "Draw command line output"
  (command "COLOR" color)
  (command "TEXT" (list 60 (+ *FRAME-Y* y)) 10 0 text)
)

;;; ============================================
;;; SYMBOL DRAWING ANIMATIONS
;;; ============================================

(defun DRAW-SCHUETZ-STEP1 (cx cy label)
  "Draw Schütz - Step 1: Basic rectangle"
  ;; Just the outer rectangle
  (command "COLOR" 3)
  (command "LINE"
    (list cx (+ *FRAME-Y* cy))
    (list (+ cx 100) (+ *FRAME-Y* cy))
    (list (+ cx 100) (+ *FRAME-Y* cy 150))
    (list cx (+ *FRAME-Y* cy 150))
    "C")
)

(defun DRAW-SCHUETZ-STEP2 (cx cy label)
  "Draw Schütz - Step 2: Add coil windings"
  ;; Rectangle
  (command "COLOR" 3)
  (command "LINE"
    (list cx (+ *FRAME-Y* cy))
    (list (+ cx 100) (+ *FRAME-Y* cy))
    (list (+ cx 100) (+ *FRAME-Y* cy 150))
    (list cx (+ *FRAME-Y* cy 150))
    "C")

  ;; Coil arcs
  (command "COLOR" 6)
  (command "ARC"
    (list (+ cx 20) (+ *FRAME-Y* cy 30))
    (list (+ cx 50) (+ *FRAME-Y* cy 50))
    (list (+ cx 80) (+ *FRAME-Y* cy 30)))
  (command "ARC"
    (list (+ cx 20) (+ *FRAME-Y* cy 60))
    (list (+ cx 50) (+ *FRAME-Y* cy 80))
    (list (+ cx 80) (+ *FRAME-Y* cy 60)))
  (command "ARC"
    (list (+ cx 20) (+ *FRAME-Y* cy 90))
    (list (+ cx 50) (+ *FRAME-Y* cy 110))
    (list (+ cx 80) (+ *FRAME-Y* cy 90)))
)

(defun DRAW-SCHUETZ-STEP3 (cx cy label)
  "Draw Schütz - Step 3: Add terminals and label"
  ;; Rectangle
  (command "COLOR" 3)
  (command "LINE"
    (list cx (+ *FRAME-Y* cy))
    (list (+ cx 100) (+ *FRAME-Y* cy))
    (list (+ cx 100) (+ *FRAME-Y* cy 150))
    (list cx (+ *FRAME-Y* cy 150))
    "C")

  ;; Coil arcs
  (command "COLOR" 6)
  (command "ARC"
    (list (+ cx 20) (+ *FRAME-Y* cy 30))
    (list (+ cx 50) (+ *FRAME-Y* cy 50))
    (list (+ cx 80) (+ *FRAME-Y* cy 30)))
  (command "ARC"
    (list (+ cx 20) (+ *FRAME-Y* cy 60))
    (list (+ cx 50) (+ *FRAME-Y* cy 80))
    (list (+ cx 80) (+ *FRAME-Y* cy 60)))
  (command "ARC"
    (list (+ cx 20) (+ *FRAME-Y* cy 90))
    (list (+ cx 50) (+ *FRAME-Y* cy 110))
    (list (+ cx 80) (+ *FRAME-Y* cy 90)))

  ;; Terminals
  (command "COLOR" 7)
  (command "LINE" (list (+ cx 50) (+ *FRAME-Y* cy)) (list (+ cx 50) (+ *FRAME-Y* cy -30)) "")
  (command "LINE" (list (+ cx 50) (+ *FRAME-Y* cy 150)) (list (+ cx 50) (+ *FRAME-Y* cy 180)) "")

  ;; Terminal labels
  (command "TEXT" (list (+ cx 60) (+ *FRAME-Y* cy -25)) 10 0 "A1")
  (command "TEXT" (list (+ cx 60) (+ *FRAME-Y* cy 175)) 10 0 "A2")

  ;; Component label
  (command "COLOR" 2)
  (command "TEXT" (list (+ cx 110) (+ *FRAME-Y* cy 70)) 18 0 label)
)

(defun DRAW-MOTOR-STEP1 (cx cy label)
  "Draw Motor - Step 1: Circle"
  (command "COLOR" 3)
  (command "CIRCLE" (list cx (+ *FRAME-Y* cy)) 60)
)

(defun DRAW-MOTOR-STEP2 (cx cy label)
  "Draw Motor - Step 2: Add M and 3~"
  (command "COLOR" 3)
  (command "CIRCLE" (list cx (+ *FRAME-Y* cy)) 60)
  (command "COLOR" 7)
  (command "TEXT" (list (- cx 20) (+ *FRAME-Y* cy -10)) 35 0 "M")
  (command "TEXT" (list (- cx 15) (+ *FRAME-Y* cy 30)) 18 0 "3~")
)

(defun DRAW-MOTOR-STEP3 (cx cy label)
  "Draw Motor - Step 3: Add terminals and label"
  (command "COLOR" 3)
  (command "CIRCLE" (list cx (+ *FRAME-Y* cy)) 60)
  (command "COLOR" 7)
  (command "TEXT" (list (- cx 20) (+ *FRAME-Y* cy -10)) 35 0 "M")
  (command "TEXT" (list (- cx 15) (+ *FRAME-Y* cy 30)) 18 0 "3~")

  ;; Terminal lines
  (command "LINE" (list (- cx 30) (+ *FRAME-Y* cy 60)) (list (- cx 30) (+ *FRAME-Y* cy 100)) "")
  (command "LINE" (list cx (+ *FRAME-Y* cy 60)) (list cx (+ *FRAME-Y* cy 100)) "")
  (command "LINE" (list (+ cx 30) (+ *FRAME-Y* cy 60)) (list (+ cx 30) (+ *FRAME-Y* cy 100)) "")

  ;; Phase labels
  (command "COLOR" 1)
  (command "TEXT" (list (- cx 35) (+ *FRAME-Y* cy 115)) 10 0 "U")
  (command "COLOR" 2)
  (command "TEXT" (list (- cx 5) (+ *FRAME-Y* cy 115)) 10 0 "V")
  (command "COLOR" 4)
  (command "TEXT" (list (+ cx 25) (+ *FRAME-Y* cy 115)) 10 0 "W")

  ;; Component label
  (command "COLOR" 2)
  (command "TEXT" (list (+ cx 80) (+ *FRAME-Y* cy)) 18 0 label)
)

(defun DRAW-SCHALTER-STEP1 (cx cy label)
  "Draw Switch - Step 1: Contacts"
  (command "COLOR" 3)
  (command "CIRCLE" (list cx (+ *FRAME-Y* cy)) 8)
  (command "CIRCLE" (list (+ cx 60) (+ *FRAME-Y* cy)) 8)
)

(defun DRAW-SCHALTER-STEP2 (cx cy label)
  "Draw Switch - Step 2: Add switch arm"
  (command "COLOR" 3)
  (command "CIRCLE" (list cx (+ *FRAME-Y* cy)) 8)
  (command "CIRCLE" (list (+ cx 60) (+ *FRAME-Y* cy)) 8)
  ;; Switch arm (open position)
  (command "COLOR" 7)
  (command "LINE"
    (list (+ cx 8) (+ *FRAME-Y* cy))
    (list (+ cx 45) (+ *FRAME-Y* cy 25))
    "")
)

(defun DRAW-SCHALTER-STEP3 (cx cy label)
  "Draw Switch - Step 3: Add terminals and label"
  (command "COLOR" 3)
  (command "CIRCLE" (list cx (+ *FRAME-Y* cy)) 8)
  (command "CIRCLE" (list (+ cx 60) (+ *FRAME-Y* cy)) 8)
  (command "COLOR" 7)
  (command "LINE"
    (list (+ cx 8) (+ *FRAME-Y* cy))
    (list (+ cx 45) (+ *FRAME-Y* cy 25))
    "")

  ;; Terminals
  (command "LINE" (list cx (+ *FRAME-Y* cy -8)) (list cx (+ *FRAME-Y* cy -40)) "")
  (command "LINE" (list (+ cx 60) (+ *FRAME-Y* cy -8)) (list (+ cx 60) (+ *FRAME-Y* cy -40)) "")

  ;; Label
  (command "COLOR" 2)
  (command "TEXT" (list (+ cx 20) (+ *FRAME-Y* cy 50)) 14 0 label)
)

;;; ============================================
;;; ANIMATED DRAWING SCENES
;;; ============================================

(defun SCENE-DRAW-K1 ()
  "Animate drawing K1 (Schütz)"
  (princ "\n=== Drawing K1 ===\n")

  ;; Step 1: Start drawing
  (NEXT-FRAME "Drawing K1 - Rectangle" 3)
  (DRAW-ACAD-SCREEN T)
  (DRAW-PRINT-QUEUE)

  (CMD-LINE 160 "Command: LINE" 7)
  (CMD-LINE 145 "Specify first point: 200,400" 3)
  (CMD-LINE 130 "Specify next point: 300,400" 3)
  (CMD-LINE 115 "..." 8)

  (DRAW-SCHUETZ-STEP1 600 500 "K1")

  (command "COLOR" 9)
  (command "TEXT" (list 100 (+ *FRAME-Y* 850)) 12 0 "Drawing: K1.DWG")
  (command "TEXT" (list 100 (+ *FRAME-Y* 820)) 10 0 "Component: SCHUETZ (Contactor)")
  (command "TEXT" (list 100 (+ *FRAME-Y* 790)) 10 0 "Value: 24V DC | Siemens 3RT1015")

  ;; Step 2: Add coils
  (NEXT-FRAME "Drawing K1 - Coil Arcs" 3)
  (DRAW-ACAD-SCREEN T)
  (DRAW-PRINT-QUEUE)

  (CMD-LINE 160 "Command: ARC" 7)
  (CMD-LINE 145 "Specify start point: 220,430" 3)
  (CMD-LINE 130 "Specify second point: 250,450" 3)
  (CMD-LINE 115 "Specify end point: 280,430" 3)

  (DRAW-SCHUETZ-STEP2 600 500 "K1")

  (command "COLOR" 9)
  (command "TEXT" (list 100 (+ *FRAME-Y* 850)) 12 0 "Drawing: K1.DWG")
  (command "TEXT" (list 100 (+ *FRAME-Y* 820)) 10 0 "Adding coil windings (3 arcs)")

  ;; Step 3: Complete with terminals
  (NEXT-FRAME "Drawing K1 - Complete" 3)
  (DRAW-ACAD-SCREEN T)
  (DRAW-PRINT-QUEUE)

  (CMD-LINE 160 "Command: TEXT" 7)
  (CMD-LINE 145 "Insertion point: 310,470" 3)
  (CMD-LINE 130 "Text: K1" 2)
  (CMD-LINE 115 "Command: SAVE" 7)

  (DRAW-SCHUETZ-STEP3 600 500 "K1")

  (command "COLOR" 2)
  (command "TEXT" (list 100 (+ *FRAME-Y* 850)) 14 0 "K1.DWG SAVED!")
  (command "TEXT" (list 100 (+ *FRAME-Y* 810)) 10 0 "Sending to print queue...")

  ;; Step 4: Sent to queue, start K2
  (NEXT-FRAME "K1 -> Queue, Drawing K2" 4)
  (DRAW-ACAD-SCREEN T)
  (DRAW-PRINT-QUEUE)
  (DRAW-QUEUE-ITEM 0 "K1" "PRINTING")

  (CMD-LINE 160 "K1.DWG sent to LPT1: (HP LaserJet III)" 2)
  (CMD-LINE 145 "" 7)
  (CMD-LINE 130 "Loading next: K2 (SCHUETZ, 24V DC)" 7)
  (CMD-LINE 115 "Command: LINE" 7)

  ;; Start drawing K2
  (DRAW-SCHUETZ-STEP1 600 500 "K2")

  (command "COLOR" 9)
  (command "TEXT" (list 100 (+ *FRAME-Y* 850)) 12 0 "Drawing: K2.DWG")
  (command "TEXT" (list 100 (+ *FRAME-Y* 820)) 10 0 "K1 is printing in background!")
)

(defun SCENE-DRAW-K2-AND-QUEUE ()
  "Continue with K2, queue fills up"
  (princ "\n=== Drawing K2 with queue ===\n")

  ;; K2 complete, K3 starting
  (NEXT-FRAME "K2 Complete, K3 Starting" 4)
  (DRAW-ACAD-SCREEN T)
  (DRAW-PRINT-QUEUE)
  (DRAW-QUEUE-ITEM 0 "K1" "DONE")
  (DRAW-QUEUE-ITEM 1 "K2" "PRINTING")

  (CMD-LINE 160 "K2.DWG saved and queued" 2)
  (CMD-LINE 145 "Loading: K3 (SCHUETZ, 24V DC)" 7)
  (CMD-LINE 130 "Command: LINE" 7)

  (DRAW-SCHUETZ-STEP2 600 500 "K3")

  (command "COLOR" 9)
  (command "TEXT" (list 100 (+ *FRAME-Y* 850)) 12 0 "Drawing: K3.DWG")

  ;; Queue building up
  (NEXT-FRAME "Queue Building Up" 4)
  (DRAW-ACAD-SCREEN T)
  (DRAW-PRINT-QUEUE)
  (DRAW-QUEUE-ITEM 0 "K1" "DONE")
  (DRAW-QUEUE-ITEM 1 "K2" "DONE")
  (DRAW-QUEUE-ITEM 2 "K3" "PRINTING")
  (DRAW-QUEUE-ITEM 3 "K4" "QUEUED")

  (CMD-LINE 160 "K4.DWG queued" 2)
  (CMD-LINE 145 "Loading: S1 (SCHALTER, 230V)" 7)
  (CMD-LINE 130 "Command: CIRCLE" 7)

  (DRAW-SCHALTER-STEP2 600 550 "S1")

  (command "COLOR" 9)
  (command "TEXT" (list 100 (+ *FRAME-Y* 850)) 12 0 "Drawing: S1.DWG (Switch)")
  (command "TEXT" (list 100 (+ *FRAME-Y* 820)) 10 0 "Printer busy - queue has 2 jobs waiting")
)

(defun SCENE-DRAW-MOTOR ()
  "Draw motor M1"
  (princ "\n=== Drawing Motor M1 ===\n")

  ;; Motor step 1
  (NEXT-FRAME "Drawing M1 - Circle" 3)
  (DRAW-ACAD-SCREEN T)
  (DRAW-PRINT-QUEUE)
  (DRAW-QUEUE-ITEM 0 "K1" "DONE")
  (DRAW-QUEUE-ITEM 1 "K2" "DONE")
  (DRAW-QUEUE-ITEM 2 "K3" "DONE")
  (DRAW-QUEUE-ITEM 3 "K4" "DONE")
  (DRAW-QUEUE-ITEM 4 "S1" "PRINTING")
  (DRAW-QUEUE-ITEM 5 "S2" "QUEUED")

  (CMD-LINE 160 "Command: CIRCLE" 7)
  (CMD-LINE 145 "Center point: 400,500" 3)
  (CMD-LINE 130 "Radius: 60" 3)

  (DRAW-MOTOR-STEP1 600 500 "M1")

  (command "COLOR" 9)
  (command "TEXT" (list 100 (+ *FRAME-Y* 850)) 12 0 "Drawing: M1.DWG")
  (command "TEXT" (list 100 (+ *FRAME-Y* 820)) 10 0 "Component: MOTOR (5.5kW Three-phase)")

  ;; Motor step 2
  (NEXT-FRAME "Drawing M1 - Adding M 3~" 3)
  (DRAW-ACAD-SCREEN T)
  (DRAW-PRINT-QUEUE)
  (DRAW-QUEUE-ITEM 0 "K3" "DONE")
  (DRAW-QUEUE-ITEM 1 "K4" "DONE")
  (DRAW-QUEUE-ITEM 2 "S1" "DONE")
  (DRAW-QUEUE-ITEM 3 "S2" "PRINTING")
  (DRAW-QUEUE-ITEM 4 "S3" "QUEUED")
  (DRAW-QUEUE-ITEM 5 "M1" "QUEUED")

  (CMD-LINE 160 "Command: TEXT" 7)
  (CMD-LINE 145 "Insertion point: 380,490" 3)
  (CMD-LINE 130 "Text height: 35" 3)
  (CMD-LINE 115 "Text: M" 2)

  (DRAW-MOTOR-STEP2 600 500 "M1")

  ;; Motor complete
  (NEXT-FRAME "Drawing M1 - Complete" 3)
  (DRAW-ACAD-SCREEN T)
  (DRAW-PRINT-QUEUE)
  (DRAW-QUEUE-ITEM 0 "S1" "DONE")
  (DRAW-QUEUE-ITEM 1 "S2" "DONE")
  (DRAW-QUEUE-ITEM 2 "S3" "DONE")
  (DRAW-QUEUE-ITEM 3 "M1" "PRINTING")
  (DRAW-QUEUE-ITEM 4 "M2" "QUEUED")

  (CMD-LINE 160 "Command: SAVE" 7)
  (CMD-LINE 145 "M1.DWG saved" 2)
  (CMD-LINE 130 "Sending to queue..." 7)

  (DRAW-MOTOR-STEP3 600 500 "M1")

  (command "COLOR" 2)
  (command "TEXT" (list 100 (+ *FRAME-Y* 850)) 14 0 "M1.DWG - 5.5kW Siemens Motor")
  (command "TEXT" (list 100 (+ *FRAME-Y* 810)) 10 0 "Queue: 2 jobs | Printed: 9 pages")
)

(defun SCENE-QUEUE-FULL ()
  "Show queue getting full, drawings flying"
  (princ "\n=== Queue Full - Printer Busy! ===\n")

  (NEXT-FRAME "Queue Nearly Full!" 5)
  (DRAW-ACAD-SCREEN T)
  (DRAW-PRINT-QUEUE)

  ;; Full queue
  (DRAW-QUEUE-ITEM 0 "S3" "DONE")
  (DRAW-QUEUE-ITEM 1 "M1" "DONE")
  (DRAW-QUEUE-ITEM 2 "M2" "DONE")
  (DRAW-QUEUE-ITEM 3 "M3" "PRINTING")
  (DRAW-QUEUE-ITEM 4 "F1" "QUEUED")
  (DRAW-QUEUE-ITEM 5 "F2" "QUEUED")
  (DRAW-QUEUE-ITEM 6 "F3" "QUEUED")
  (DRAW-QUEUE-ITEM 7 "R1" "QUEUED")

  ;; Drawing the last few
  (DRAW-SCHALTER-STEP3 600 550 "R2")

  (CMD-LINE 160 "[21/23] R2 (RELAIS)" 2)
  (CMD-LINE 145 "Command: SAVE" 7)
  (CMD-LINE 130 "Queue: 5 jobs waiting" 1)

  (command "COLOR" 1)
  (command "TEXT" (list 100 (+ *FRAME-Y* 850)) 14 0 "PRINTER BUSY!")
  (command "COLOR" 9)
  (command "TEXT" (list 100 (+ *FRAME-Y* 810)) 10 0 "5 drawings in queue - LaserJet can't keep up!")
  (command "TEXT" (list 100 (+ *FRAME-Y* 780)) 10 0 "But AutoLISP doesn't wait - it keeps drawing!")

  ;; Speed doesn't matter
  (NEXT-FRAME "Speed Doesn't Matter!" 5)
  (DRAW-ACAD-SCREEN T)
  (DRAW-PRINT-QUEUE)

  (DRAW-QUEUE-ITEM 0 "M2" "DONE")
  (DRAW-QUEUE-ITEM 1 "M3" "DONE")
  (DRAW-QUEUE-ITEM 2 "F1" "DONE")
  (DRAW-QUEUE-ITEM 3 "F2" "PRINTING")
  (DRAW-QUEUE-ITEM 4 "F3" "QUEUED")
  (DRAW-QUEUE-ITEM 5 "R1" "QUEUED")
  (DRAW-QUEUE-ITEM 6 "R2" "QUEUED")
  (DRAW-QUEUE-ITEM 7 "KS1" "QUEUED")

  ;; Last drawing
  (DRAW-SCHUETZ-STEP3 600 500 "KS1")

  (CMD-LINE 160 "[23/23] KS1 (KREUZSCHALTER)" 2)
  (CMD-LINE 145 "Command: SAVE" 7)
  (CMD-LINE 130 "ALL DRAWINGS COMPLETE!" 2)

  (command "COLOR" 3)
  (command "TEXT" (list 100 (+ *FRAME-Y* 850)) 18 0 "ALL 23 DRAWINGS DONE!")
  (command "COLOR" 9)
  (command "TEXT" (list 100 (+ *FRAME-Y* 800)) 12 0 "Drawing time: 2 min 34 sec")
  (command "TEXT" (list 100 (+ *FRAME-Y* 770)) 12 0 "Print queue: Still 4 jobs printing...")
  (command "COLOR" 7)
  (command "TEXT" (list 100 (+ *FRAME-Y* 720)) 10 0 "The slow mode let us watch the magic happen!")
  (command "TEXT" (list 100 (+ *FRAME-Y* 690)) 10 0 "But the printer is the bottleneck - not AutoLISP!")
)

(defun SCENE-PRINTING-COMPLETE ()
  "Final: all printed"
  (princ "\n=== Printing Complete ===\n")

  (NEXT-FRAME "Printing Complete!" 6)

  ;; Black background
  (command "COLOR" 0)
  (command "LINE"
    (list 0 *FRAME-Y*)
    (list *SCREEN-W* *FRAME-Y*)
    (list *SCREEN-W* (+ *FRAME-Y* *SCREEN-H*))
    (list 0 (+ *FRAME-Y* *SCREEN-H*))
    "C")

  ;; Stack of printed pages
  (command "COLOR" 7)
  (setq py 300)
  (repeat 23
    (command "LINE"
      (list 600 (+ *FRAME-Y* py))
      (list 1000 (+ *FRAME-Y* py))
      (list 1000 (+ *FRAME-Y* (+ py 3)))
      (list 600 (+ *FRAME-Y* (+ py 3)))
      "C")
    (setq py (+ py 4))
  )

  ;; Top page with drawing
  (command "LINE"
    (list 600 (+ *FRAME-Y* py))
    (list 1000 (+ *FRAME-Y* py))
    (list 1000 (+ *FRAME-Y* (+ py 80)))
    (list 600 (+ *FRAME-Y* (+ py 80)))
    "C")
  (command "COLOR" 8)
  (command "CIRCLE" (list 800 (+ *FRAME-Y* (+ py 40))) 25)
  (command "TEXT" (list 790 (+ *FRAME-Y* (+ py 35))) 15 0 "M")

  ;; Stats
  (command "COLOR" 2)
  (command "TEXT" (list 600 (+ *FRAME-Y* 800)) 40 0 "23 PAGES")
  (command "COLOR" 7)
  (command "TEXT" (list 600 (+ *FRAME-Y* 740)) 18 0 "Printed on HP LaserJet III")

  (command "COLOR" 9)
  (command "TEXT" (list 600 (+ *FRAME-Y* 670)) 14 0 "Drawing time:  2 min 34 sec")
  (command "TEXT" (list 600 (+ *FRAME-Y* 630)) 14 0 "Print time:    2 min 52 sec (8 ppm)")
  (command "TEXT" (list 600 (+ *FRAME-Y* 590)) 14 0 "Total time:    < 3 minutes")

  (command "COLOR" 3)
  (command "TEXT" (list 600 (+ *FRAME-Y* 520)) 25 0 "Manual would take 5+ HOURS")

  (command "COLOR" 2)
  (command "TEXT" (list 700 (+ *FRAME-Y* 450)) 35 0 "99.3% SAVED")
)

;;; ============================================
;;; MAIN
;;; ============================================

(defun C:ANIMATED ()
  (princ "\n")
  (princ "============================================\n")
  (princ "  ANIMATED DRAWING DEMO\n")
  (princ "  Watch AutoLISP draw in slow mode!\n")
  (princ "============================================\n")
  (princ "\n")

  (setq *FRAME-NUM* 0)
  (setq *FRAME-Y* 0)

  (SCENE-DRAW-K1)
  (SCENE-DRAW-K2-AND-QUEUE)
  (SCENE-DRAW-MOTOR)
  (SCENE-QUEUE-FULL)
  (SCENE-PRINTING-COMPLETE)

  (princ "\n")
  (princ "============================================\n")
  (princ (strcat "  Total frames: " (itoa *FRAME-NUM*) "\n"))
  (princ "============================================\n")

  (princ)
)

(C:ANIMATED)
