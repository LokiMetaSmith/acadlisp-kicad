;;; WORKFLOW.LSP - Complete AutoCAD Workflow Demonstration
;;; "The AutoLISP Story: From CSV to Laser Printer"
;;;
;;; Shows the authentic 1991 workflow:
;;; 1. Start AutoCAD R10 with ACAD.DWG template
;;; 2. ACAD.LSP auto-loads and imports libraries
;;; 3. User types SCHALTGEN command
;;; 4. System reads KOMPONEN.CSV
;;; 5. Batch generates all drawings
;;; 6. Sends to HP LaserJet III (expensive!)
;;;

;;; ============================================
;;; CONFIGURATION
;;; ============================================

(setq *SCREEN-W* 1920)
(setq *SCREEN-H* 1080)
(setq *FRAME-NUM* 0)
(setq *FRAME-Y* 0)

;;; ============================================
;;; FRAME HELPERS
;;; ============================================

(defun NEXT-FRAME (title duration)
  "Start new frame with title"
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
    (strcat "Frame " (itoa *FRAME-NUM*) " | " (itoa duration) "s | " title))

  *FRAME-Y*
)

(defun DOS-PROMPT (y-pos text)
  "Draw DOS command prompt style text"
  (command "COLOR" 7)
  (command "TEXT" (list 50 (+ *FRAME-Y* y-pos)) 14 0 text)
)

(defun DOS-RESPONSE (y-pos text)
  "Draw DOS response text (dimmer)"
  (command "COLOR" 8)
  (command "TEXT" (list 50 (+ *FRAME-Y* y-pos)) 12 0 text)
)

(defun ACAD-COMMAND (y-pos text)
  "Draw AutoCAD command line"
  (command "COLOR" 7)
  (command "TEXT" (list 50 (+ *FRAME-Y* y-pos)) 12 0
    (strcat "Command: " text))
)

(defun ACAD-RESPONSE (y-pos text)
  "Draw AutoCAD response"
  (command "COLOR" 3)
  (command "TEXT" (list 50 (+ *FRAME-Y* y-pos)) 11 0 text)
)

(defun NARRATOR (text)
  "Draw narrator text at bottom"
  (command "COLOR" 2)
  (command "LINE"
    (list 40 (+ *FRAME-Y* 60))
    (list (- *SCREEN-W* 40) (+ *FRAME-Y* 60))
    (list (- *SCREEN-W* 40) (+ *FRAME-Y* 130))
    (list 40 (+ *FRAME-Y* 130))
    "C")
  (command "COLOR" 0)
  (command "LINE"
    (list 42 (+ *FRAME-Y* 62))
    (list (- *SCREEN-W* 42) (+ *FRAME-Y* 62))
    (list (- *SCREEN-W* 42) (+ *FRAME-Y* 128))
    (list 42 (+ *FRAME-Y* 128))
    "C")
  (command "COLOR" 2)
  (command "TEXT" (list 60 (+ *FRAME-Y* 90)) 14 0 text)
)

(defun DRAW-MONITOR (x y scale label)
  "Draw a CRT monitor"
  (setq mw (* 200 scale))
  (setq mh (* 160 scale))

  ;; Monitor body
  (command "COLOR" 8)
  (command "LINE"
    (list x (+ *FRAME-Y* y))
    (list (+ x mw) (+ *FRAME-Y* y))
    (list (+ x mw) (+ *FRAME-Y* y mh))
    (list x (+ *FRAME-Y* y mh))
    "C")

  ;; Screen (green phosphor)
  (command "COLOR" 0)
  (command "LINE"
    (list (+ x (* 15 scale)) (+ *FRAME-Y* y (* 15 scale)))
    (list (+ x mw (* -15 scale)) (+ *FRAME-Y* y (* 15 scale)))
    (list (+ x mw (* -15 scale)) (+ *FRAME-Y* y mh (* -30 scale)))
    (list (+ x (* 15 scale)) (+ *FRAME-Y* y mh (* -30 scale)))
    "C")

  ;; Stand
  (command "COLOR" 8)
  (command "LINE"
    (list (+ x (* 70 scale)) (+ *FRAME-Y* y))
    (list (+ x (* 130 scale)) (+ *FRAME-Y* y))
    (list (+ x (* 130 scale)) (+ *FRAME-Y* y (* -20 scale)))
    (list (+ x (* 70 scale)) (+ *FRAME-Y* y (* -20 scale)))
    "C")

  ;; Label
  (command "COLOR" 7)
  (command "TEXT" (list (+ x (* 10 scale)) (+ *FRAME-Y* y mh (* -50 scale))) (* 8 scale) 0 label)
)

(defun DRAW-PRINTER (x y scale)
  "Draw HP LaserJet III printer"
  (setq pw (* 250 scale))
  (setq ph (* 120 scale))

  ;; Printer body
  (command "COLOR" 7)
  (command "LINE"
    (list x (+ *FRAME-Y* y))
    (list (+ x pw) (+ *FRAME-Y* y))
    (list (+ x pw) (+ *FRAME-Y* y ph))
    (list x (+ *FRAME-Y* y ph))
    "C")

  ;; Paper tray
  (command "COLOR" 8)
  (command "LINE"
    (list (+ x (* 20 scale)) (+ *FRAME-Y* y ph))
    (list (+ x pw (* -20 scale)) (+ *FRAME-Y* y ph))
    (list (+ x pw (* -20 scale)) (+ *FRAME-Y* y ph (* 40 scale)))
    (list (+ x (* 20 scale)) (+ *FRAME-Y* y ph (* 40 scale)))
    "C")

  ;; Output paper slot
  (command "LINE"
    (list (+ x (* 40 scale)) (+ *FRAME-Y* y (* -10 scale)))
    (list (+ x pw (* -40 scale)) (+ *FRAME-Y* y (* -10 scale)))
    "")

  ;; HP Logo
  (command "COLOR" 4)
  (command "TEXT" (list (+ x (* 10 scale)) (+ *FRAME-Y* y (* 20 scale))) (* 12 scale) 0 "HP")
  (command "COLOR" 7)
  (command "TEXT" (list (+ x (* 50 scale)) (+ *FRAME-Y* y (* 20 scale))) (* 8 scale) 0 "LaserJet III")

  ;; Price tag
  (command "COLOR" 1)
  (command "TEXT" (list (+ x pw (* 10 scale)) (+ *FRAME-Y* y (* 60 scale))) (* 10 scale) 0 "DM 8,500!")
)

;;; ============================================
;;; SCENE 1: DOS BOOT / START AUTOCAD
;;; ============================================

(defun SCENE-1-BOOT ()
  (princ "\n=== Scene 1: Boot and Start AutoCAD ===\n")

  ;; Frame 1: Boot disk
  (NEXT-FRAME "Boot Disk B:" 6)
  (DOS-PROMPT 900 "Insert AutoCAD Boot Disk in Drive B:")
  (DOS-PROMPT 850 "")
  (DOS-RESPONSE 820 "486DX-50 with 8MB RAM")
  (DOS-RESPONSE 790 "Memory optimized for AutoCAD: 605KB conventional free")
  (DOS-RESPONSE 760 "HIMEM.SYS + EMM386.EXE loaded")
  (DOS-RESPONSE 730 "")
  (DOS-RESPONSE 700 "B:\\>")
  (NARRATOR "A special boot disk B: is required! AutoCAD needs precisely optimized memory - 605KB conventional RAM free.")

  ;; Frame 2: DOS prompt after boot
  (NEXT-FRAME "DOS Prompt" 4)
  (DOS-PROMPT 900 "B:\\>C:")
  (DOS-PROMPT 860 "C:\\>")
  (NARRATOR "December 1991. Munich. The workday begins at Schmidt & Weber GmbH.")

  ;; Frame 2: Change to ACAD directory
  (NEXT-FRAME "CD to AutoCAD" 4)
  (DOS-PROMPT 900 "C:\\>cd ACAD")
  (DOS-PROMPT 860 "C:\\ACAD>")
  (NARRATOR "The engineer navigates to the AutoCAD directory.")

  ;; Frame 3: Directory listing
  (NEXT-FRAME "DIR command" 5)
  (DOS-PROMPT 950 "C:\\ACAD>dir *.lsp")
  (DOS-RESPONSE 910 "")
  (DOS-RESPONSE 880 " Volume in drive C is SYSTEM")
  (DOS-RESPONSE 850 " Directory of C:\\ACAD")
  (DOS-RESPONSE 810 "")
  (DOS-RESPONSE 780 "ACAD     LSP     2,345  12-01-91   8:15a")
  (DOS-RESPONSE 750 "CSVREAD  LSP     3,892  11-15-91  10:22a")
  (DOS-RESPONSE 720 "EBLOCKS  LSP     8,234  11-20-91   2:45p")
  (DOS-RESPONSE 690 "SCHALT   LSP     4,567  12-10-91   4:30p")
  (DOS-RESPONSE 650 "       4 file(s)     19,038 bytes")
  (DOS-RESPONSE 620 "       2,458,624 bytes free")
  (NARRATOR "The LSP files are ready. ACAD.LSP will auto-load when AutoCAD starts.")

  ;; Frame 4: Start AutoCAD
  (NEXT-FRAME "Launch AutoCAD" 4)
  (DOS-PROMPT 900 "C:\\ACAD>acad")
  (DOS-RESPONSE 850 "")
  (DOS-RESPONSE 820 "Loading AutoCAD Release 10...")
  (NARRATOR "AutoCAD Release 10 starts loading. This takes about 30 seconds on a 386.")

  ;; Frame 5: AutoCAD splash
  (NEXT-FRAME "AutoCAD Splash" 5)
  (command "COLOR" 4)
  (command "TEXT" (list 600 (+ *FRAME-Y* 700)) 50 0 "AutoCAD")
  (command "COLOR" 7)
  (command "TEXT" (list 600 (+ *FRAME-Y* 620)) 25 0 "Release 10")
  (command "TEXT" (list 600 (+ *FRAME-Y* 560)) 15 0 "Copyright (C) 1982-1989 Autodesk, Inc.")
  (command "COLOR" 8)
  (command "TEXT" (list 600 (+ *FRAME-Y* 480)) 12 0 "Serial Number: 117-12345678")
  (command "TEXT" (list 600 (+ *FRAME-Y* 450)) 12 0 "Licensed to: Schmidt & Weber GmbH")
  (NARRATOR "AutoCAD Release 10 - the industry standard for CAD in 1991.")
)

;;; ============================================
;;; SCENE 2: ACAD.LSP AUTO-LOAD
;;; ============================================

(defun SCENE-2-AUTOLOAD ()
  (princ "\n=== Scene 2: ACAD.LSP Auto-Load ===\n")

  ;; Frame 6: Loading ACAD.LSP
  (NEXT-FRAME "ACAD.LSP Loading" 6)

  ;; AutoCAD screen simulation
  (command "COLOR" 0)
  (command "LINE"
    (list 100 (+ *FRAME-Y* 200))
    (list 1820 (+ *FRAME-Y* 200))
    (list 1820 (+ *FRAME-Y* 950))
    (list 100 (+ *FRAME-Y* 950))
    "C")

  ;; Command line area
  (command "COLOR" 7)
  (command "TEXT" (list 120 (+ *FRAME-Y* 350)) 11 0 "Loading ACAD.LSP...")
  (command "COLOR" 3)
  (command "TEXT" (list 120 (+ *FRAME-Y* 320)) 10 0 "  Loading CSVREAD.LSP... OK")
  (command "TEXT" (list 120 (+ *FRAME-Y* 295)) 10 0 "  Loading EBLOCKS.LSP... OK")
  (command "TEXT" (list 120 (+ *FRAME-Y* 270)) 10 0 "  Loading SCHALT.LSP... OK")
  (command "COLOR" 2)
  (command "TEXT" (list 120 (+ *FRAME-Y* 240)) 11 0 "Schaltplan-Generator v1.0 ready!")
  (command "TEXT" (list 120 (+ *FRAME-Y* 215)) 10 0 "Type SCHALTGEN to generate drawings from CSV")

  (NARRATOR "ACAD.LSP loads automatically and imports all required libraries.")

  ;; Frame 7: Ready state
  (NEXT-FRAME "System Ready" 4)

  ;; AutoCAD drawing area (black)
  (command "COLOR" 0)
  (command "LINE"
    (list 100 (+ *FRAME-Y* 200))
    (list 1820 (+ *FRAME-Y* 200))
    (list 1820 (+ *FRAME-Y* 950))
    (list 100 (+ *FRAME-Y* 950))
    "C")

  ;; Grid dots
  (command "COLOR" 8)
  (setq gx 200)
  (repeat 16
    (setq gy 300)
    (repeat 6
      (command "CIRCLE" (list gx (+ *FRAME-Y* gy)) 1)
      (setq gy (+ gy 100))
    )
    (setq gx (+ gx 100))
  )

  ;; Command prompt
  (command "COLOR" 7)
  (command "TEXT" (list 120 (+ *FRAME-Y* 250)) 12 0 "Command: _")

  ;; Status bar
  (command "COLOR" 8)
  (command "LINE"
    (list 100 (+ *FRAME-Y* 180))
    (list 1820 (+ *FRAME-Y* 180))
    (list 1820 (+ *FRAME-Y* 200))
    (list 100 (+ *FRAME-Y* 200))
    "C")
  (command "COLOR" 7)
  (command "TEXT" (list 120 (+ *FRAME-Y* 188)) 8 0
    "Layer: 0    Ortho    Snap    Grid    0.000,0.000")

  (NARRATOR "The drawing environment is ready. The engineer is about to type the magic command...")
)

;;; ============================================
;;; SCENE 3: RUN SCHALTGEN COMMAND
;;; ============================================

(defun SCENE-3-SCHALTGEN ()
  (princ "\n=== Scene 3: SCHALTGEN Command ===\n")

  ;; Frame 8: Type command
  (NEXT-FRAME "Type SCHALTGEN" 5)

  ;; AutoCAD screen
  (command "COLOR" 0)
  (command "LINE"
    (list 100 (+ *FRAME-Y* 200))
    (list 1820 (+ *FRAME-Y* 200))
    (list 1820 (+ *FRAME-Y* 950))
    (list 100 (+ *FRAME-Y* 950))
    "C")

  ;; Command being typed
  (command "COLOR" 7)
  (command "TEXT" (list 120 (+ *FRAME-Y* 250)) 14 0 "Command: SCHALTGEN")

  ;; Big display of command
  (command "COLOR" 3)
  (command "TEXT" (list 500 (+ *FRAME-Y* 600)) 60 0 "SCHALTGEN")
  (command "COLOR" 9)
  (command "TEXT" (list 500 (+ *FRAME-Y* 500)) 20 0 "The batch drawing generator command")

  (NARRATOR "SCHALTGEN - one command to generate all electrical drawings from CSV data.")

  ;; Frame 9: Prompt for CSV file
  (NEXT-FRAME "CSV File Prompt" 5)

  (command "COLOR" 0)
  (command "LINE"
    (list 100 (+ *FRAME-Y* 200))
    (list 1820 (+ *FRAME-Y* 200))
    (list 1820 (+ *FRAME-Y* 950))
    (list 100 (+ *FRAME-Y* 950))
    "C")

  (command "COLOR" 7)
  (command "TEXT" (list 120 (+ *FRAME-Y* 350)) 12 0 "Command: SCHALTGEN")
  (command "COLOR" 3)
  (command "TEXT" (list 120 (+ *FRAME-Y* 320)) 12 0 "=== SCHALTPLAN GENERATOR v1.0 ===")
  (command "COLOR" 7)
  (command "TEXT" (list 120 (+ *FRAME-Y* 290)) 12 0 "CSV-Datei [KOMPONEN.CSV]: _")

  (NARRATOR "The system prompts for the CSV file. KOMPONEN.CSV contains all component data.")

  ;; Frame 10: Loading CSV
  (NEXT-FRAME "Loading CSV" 6)

  (command "COLOR" 0)
  (command "LINE"
    (list 100 (+ *FRAME-Y* 200))
    (list 1820 (+ *FRAME-Y* 200))
    (list 1820 (+ *FRAME-Y* 950))
    (list 100 (+ *FRAME-Y* 950))
    "C")

  (command "COLOR" 7)
  (command "TEXT" (list 120 (+ *FRAME-Y* 400)) 12 0 "CSV-Datei [KOMPONEN.CSV]: KOMPONEN.CSV")
  (command "COLOR" 3)
  (command "TEXT" (list 120 (+ *FRAME-Y* 370)) 11 0 "Loading KOMPONEN.CSV...")
  (command "TEXT" (list 120 (+ *FRAME-Y* 340)) 11 0 "Parsing with semicolon delimiter (German format)...")
  (command "COLOR" 2)
  (command "TEXT" (list 120 (+ *FRAME-Y* 300)) 12 0 "Found 23 components:")
  (command "COLOR" 7)
  (command "TEXT" (list 140 (+ *FRAME-Y* 270)) 10 0 "- 8 x SCHUETZ (Contactor)")
  (command "TEXT" (list 140 (+ *FRAME-Y* 245)) 10 0 "- 5 x SCHALTER (Switch)")
  (command "TEXT" (list 140 (+ *FRAME-Y* 220)) 10 0 "- 4 x MOTOR (Three-phase motor)")
  (command "TEXT" (list 140 (+ *FRAME-Y* 195)) 10 0 "- 3 x SICHERUNG (Fuse)")
  (command "TEXT" (list 140 (+ *FRAME-Y* 170)) 10 0 "- 2 x RELAIS (Relay)")
  (command "TEXT" (list 140 (+ *FRAME-Y* 145)) 10 0 "- 1 x KREUZSCHALTER (4-way switch)")

  (NARRATOR "CSV loaded! 23 components across 6 types. Each will become a separate drawing.")
)

;;; ============================================
;;; SCENE 4: BATCH PROCESSING
;;; ============================================

(defun SCENE-4-BATCH ()
  (princ "\n=== Scene 4: Batch Processing ===\n")

  ;; Frame 11: Processing starts
  (NEXT-FRAME "Processing Starts" 4)

  (command "COLOR" 0)
  (command "LINE"
    (list 100 (+ *FRAME-Y* 200))
    (list 1820 (+ *FRAME-Y* 200))
    (list 1820 (+ *FRAME-Y* 950))
    (list 100 (+ *FRAME-Y* 950))
    "C")

  (command "COLOR" 2)
  (command "TEXT" (list 120 (+ *FRAME-Y* 850)) 14 0 "Starting batch generation...")
  (command "COLOR" 7)
  (command "TEXT" (list 120 (+ *FRAME-Y* 800)) 12 0 "[1/23] K1 - SCHUETZ - 24V DC - Siemens")
  (command "COLOR" 3)
  (command "TEXT" (list 140 (+ *FRAME-Y* 770)) 10 0 "Creating new drawing: K1.DWG")
  (command "TEXT" (list 140 (+ *FRAME-Y* 745)) 10 0 "Drawing SCHUETZ symbol at 100,100")
  (command "TEXT" (list 140 (+ *FRAME-Y* 720)) 10 0 "Adding designation: K1")
  (command "TEXT" (list 140 (+ *FRAME-Y* 695)) 10 0 "Adding specifications: 24V DC")
  (command "COLOR" 2)
  (command "TEXT" (list 140 (+ *FRAME-Y* 665)) 10 0 "Saving K1.DWG... OK")

  ;; Progress bar
  (command "COLOR" 8)
  (command "LINE"
    (list 120 (+ *FRAME-Y* 250))
    (list 1700 (+ *FRAME-Y* 250))
    (list 1700 (+ *FRAME-Y* 280))
    (list 120 (+ *FRAME-Y* 280))
    "C")
  (command "COLOR" 3)
  (command "LINE"
    (list 122 (+ *FRAME-Y* 252))
    (list 190 (+ *FRAME-Y* 252))
    (list 190 (+ *FRAME-Y* 278))
    (list 122 (+ *FRAME-Y* 278))
    "C")
  (command "COLOR" 7)
  (command "TEXT" (list 120 (+ *FRAME-Y* 220)) 10 0 "Progress: 1/23 (4%)")

  (NARRATOR "Watch the automation in action! Each component is processed automatically.")

  ;; Frame 12: Mid-processing
  (NEXT-FRAME "Processing K5" 4)

  (command "COLOR" 0)
  (command "LINE"
    (list 100 (+ *FRAME-Y* 200))
    (list 1820 (+ *FRAME-Y* 200))
    (list 1820 (+ *FRAME-Y* 950))
    (list 100 (+ *FRAME-Y* 950))
    "C")

  (command "COLOR" 8)
  (command "TEXT" (list 120 (+ *FRAME-Y* 880)) 10 0 "[1/23] K1 - SCHUETZ ... OK")
  (command "TEXT" (list 120 (+ *FRAME-Y* 855)) 10 0 "[2/23] K2 - SCHUETZ ... OK")
  (command "TEXT" (list 120 (+ *FRAME-Y* 830)) 10 0 "[3/23] K3 - SCHUETZ ... OK")
  (command "TEXT" (list 120 (+ *FRAME-Y* 805)) 10 0 "[4/23] K4 - SCHUETZ ... OK")

  (command "COLOR" 7)
  (command "TEXT" (list 120 (+ *FRAME-Y* 770)) 12 0 "[5/23] S1 - SCHALTER - 230V AC - ABB")
  (command "COLOR" 3)
  (command "TEXT" (list 140 (+ *FRAME-Y* 740)) 10 0 "Creating new drawing: S1.DWG")
  (command "TEXT" (list 140 (+ *FRAME-Y* 715)) 10 0 "Drawing SCHALTER symbol at 100,100")
  (command "TEXT" (list 140 (+ *FRAME-Y* 690)) 10 0 "Adding contact configuration...")

  ;; Progress bar - 22%
  (command "COLOR" 8)
  (command "LINE"
    (list 120 (+ *FRAME-Y* 250))
    (list 1700 (+ *FRAME-Y* 250))
    (list 1700 (+ *FRAME-Y* 280))
    (list 120 (+ *FRAME-Y* 280))
    "C")
  (command "COLOR" 3)
  (command "LINE"
    (list 122 (+ *FRAME-Y* 252))
    (list 470 (+ *FRAME-Y* 252))
    (list 470 (+ *FRAME-Y* 278))
    (list 122 (+ *FRAME-Y* 278))
    "C")
  (command "COLOR" 7)
  (command "TEXT" (list 120 (+ *FRAME-Y* 220)) 10 0 "Progress: 5/23 (22%)")

  (NARRATOR "The system processes each row from the CSV. Switch S1 is being drawn now.")

  ;; Frame 13: Motor processing
  (NEXT-FRAME "Processing Motors" 5)

  (command "COLOR" 0)
  (command "LINE"
    (list 100 (+ *FRAME-Y* 200))
    (list 1820 (+ *FRAME-Y* 200))
    (list 1820 (+ *FRAME-Y* 950))
    (list 100 (+ *FRAME-Y* 950))
    "C")

  ;; Show motor being drawn
  (command "COLOR" 7)
  (command "TEXT" (list 120 (+ *FRAME-Y* 900)) 12 0 "[14/23] M1 - MOTOR - 5.5kW - Siemens")
  (command "COLOR" 3)
  (command "TEXT" (list 140 (+ *FRAME-Y* 870)) 10 0 "Creating M1.DWG...")

  ;; Drawing preview
  (command "COLOR" 7)
  (command "CIRCLE" (list 1200 (+ *FRAME-Y* 600)) 100)
  (command "TEXT" (list 1160 (+ *FRAME-Y* 580)) 40 0 "M")
  (command "TEXT" (list 1170 (+ *FRAME-Y* 640)) 20 0 "3~")

  ;; Terminal connections
  (command "LINE" (list 1140 (+ *FRAME-Y* 700)) (list 1140 (+ *FRAME-Y* 780)) "")
  (command "LINE" (list 1200 (+ *FRAME-Y* 700)) (list 1200 (+ *FRAME-Y* 780)) "")
  (command "LINE" (list 1260 (+ *FRAME-Y* 700)) (list 1260 (+ *FRAME-Y* 780)) "")

  (command "COLOR" 1)
  (command "TEXT" (list 1130 (+ *FRAME-Y* 800)) 12 0 "U")
  (command "COLOR" 2)
  (command "TEXT" (list 1190 (+ *FRAME-Y* 800)) 12 0 "V")
  (command "COLOR" 4)
  (command "TEXT" (list 1250 (+ *FRAME-Y* 800)) 12 0 "W")

  (command "COLOR" 7)
  (command "TEXT" (list 1320 (+ *FRAME-Y* 600)) 14 0 "M1")
  (command "TEXT" (list 1320 (+ *FRAME-Y* 560)) 12 0 "5.5 kW")
  (command "TEXT" (list 1320 (+ *FRAME-Y* 530)) 10 0 "Siemens 1LA7113-4AA")

  ;; Progress bar - 61%
  (command "COLOR" 8)
  (command "LINE"
    (list 120 (+ *FRAME-Y* 250))
    (list 1700 (+ *FRAME-Y* 250))
    (list 1700 (+ *FRAME-Y* 280))
    (list 120 (+ *FRAME-Y* 280))
    "C")
  (command "COLOR" 3)
  (command "LINE"
    (list 122 (+ *FRAME-Y* 252))
    (list 1085 (+ *FRAME-Y* 252))
    (list 1085 (+ *FRAME-Y* 278))
    (list 122 (+ *FRAME-Y* 278))
    "C")
  (command "COLOR" 7)
  (command "TEXT" (list 120 (+ *FRAME-Y* 220)) 10 0 "Progress: 14/23 (61%)")

  (NARRATOR "A 5.5kW three-phase motor symbol with all specifications from the CSV data.")

  ;; Frame 14: Complete!
  (NEXT-FRAME "Batch Complete" 6)

  (command "COLOR" 0)
  (command "LINE"
    (list 100 (+ *FRAME-Y* 200))
    (list 1820 (+ *FRAME-Y* 200))
    (list 1820 (+ *FRAME-Y* 950))
    (list 100 (+ *FRAME-Y* 950))
    "C")

  (command "COLOR" 2)
  (command "TEXT" (list 500 (+ *FRAME-Y* 700)) 50 0 "COMPLETE!")

  (command "COLOR" 7)
  (command "TEXT" (list 400 (+ *FRAME-Y* 580)) 20 0 "23 drawings generated successfully")

  (command "COLOR" 3)
  (command "TEXT" (list 400 (+ *FRAME-Y* 500)) 15 0 "Time elapsed: 2 minutes 34 seconds")
  (command "COLOR" 9)
  (command "TEXT" (list 400 (+ *FRAME-Y* 460)) 12 0 "Manual drawing time would be: 5+ hours")
  (command "COLOR" 2)
  (command "TEXT" (list 400 (+ *FRAME-Y* 420)) 18 0 "TIME SAVED: 99.3%")

  ;; Full progress bar
  (command "COLOR" 8)
  (command "LINE"
    (list 120 (+ *FRAME-Y* 250))
    (list 1700 (+ *FRAME-Y* 250))
    (list 1700 (+ *FRAME-Y* 280))
    (list 120 (+ *FRAME-Y* 280))
    "C")
  (command "COLOR" 2)
  (command "LINE"
    (list 122 (+ *FRAME-Y* 252))
    (list 1698 (+ *FRAME-Y* 252))
    (list 1698 (+ *FRAME-Y* 278))
    (list 122 (+ *FRAME-Y* 278))
    "C")
  (command "COLOR" 7)
  (command "TEXT" (list 120 (+ *FRAME-Y* 220)) 10 0 "Progress: 23/23 (100%)")

  (NARRATOR "23 drawings in under 3 minutes. What would take all morning is done before the first coffee break!")
)

;;; ============================================
;;; SCENE 5: PRINTING TO LASER PRINTER
;;; ============================================

(defun SCENE-5-PRINTING ()
  (princ "\n=== Scene 5: Printing ===\n")

  ;; Frame 15: Print command
  (NEXT-FRAME "Print Queue" 5)

  (command "COLOR" 0)
  (command "LINE"
    (list 100 (+ *FRAME-Y* 200))
    (list 1820 (+ *FRAME-Y* 200))
    (list 1820 (+ *FRAME-Y* 950))
    (list 100 (+ *FRAME-Y* 950))
    "C")

  (command "COLOR" 7)
  (command "TEXT" (list 120 (+ *FRAME-Y* 900)) 12 0 "Command: BATCHPLOT")
  (command "COLOR" 3)
  (command "TEXT" (list 120 (+ *FRAME-Y* 860)) 12 0 "=== BATCH PLOT TO HP LASERJET III ===")

  (command "COLOR" 7)
  (command "TEXT" (list 120 (+ *FRAME-Y* 800)) 11 0 "Queueing 23 drawings for print...")
  (command "TEXT" (list 140 (+ *FRAME-Y* 770)) 10 0 "K1.DWG -> LPT1: (HP LaserJet III)")
  (command "TEXT" (list 140 (+ *FRAME-Y* 745)) 10 0 "K2.DWG -> LPT1: (HP LaserJet III)")
  (command "TEXT" (list 140 (+ *FRAME-Y* 720)) 10 0 "K3.DWG -> LPT1: (HP LaserJet III)")
  (command "COLOR" 8)
  (command "TEXT" (list 140 (+ *FRAME-Y* 695)) 10 0 "... 20 more drawings ...")

  (command "COLOR" 2)
  (command "TEXT" (list 120 (+ *FRAME-Y* 640)) 12 0 "Print job sent to HP LaserJet III on LPT1:")

  ;; Printer illustration
  (DRAW-PRINTER 1100 400 1.5)

  (NARRATOR "The drawings are sent to the HP LaserJet III - a DM 8,500 investment that prints A4 at 8 pages/minute.")

  ;; Frame 16: Printing in progress
  (NEXT-FRAME "Printing..." 6)

  (command "COLOR" 0)
  (command "LINE"
    (list 100 (+ *FRAME-Y* 200))
    (list 1820 (+ *FRAME-Y* 200))
    (list 1820 (+ *FRAME-Y* 950))
    (list 100 (+ *FRAME-Y* 950))
    "C")

  ;; Large printer with paper coming out
  (command "COLOR" 7)
  ;; Printer body
  (command "LINE"
    (list 600 (+ *FRAME-Y* 350))
    (list 1300 (+ *FRAME-Y* 350))
    (list 1300 (+ *FRAME-Y* 600))
    (list 600 (+ *FRAME-Y* 600))
    "C")

  ;; Paper tray
  (command "LINE"
    (list 700 (+ *FRAME-Y* 600))
    (list 1200 (+ *FRAME-Y* 600))
    (list 1200 (+ *FRAME-Y* 700))
    (list 700 (+ *FRAME-Y* 700))
    "C")

  ;; Papers coming out (stack)
  (setq paper-y 300)
  (setq paper-num 1)
  (repeat 8
    (command "COLOR" 7)
    (command "LINE"
      (list 750 (+ *FRAME-Y* paper-y))
      (list 1150 (+ *FRAME-Y* paper-y))
      (list 1150 (+ *FRAME-Y* paper-y 40))
      (list 750 (+ *FRAME-Y* paper-y 40))
      "C")
    ;; Drawing on paper
    (command "COLOR" 8)
    (command "LINE"
      (list 800 (+ *FRAME-Y* paper-y 10))
      (list 850 (+ *FRAME-Y* paper-y 10))
      (list 850 (+ *FRAME-Y* paper-y 30))
      (list 800 (+ *FRAME-Y* paper-y 30))
      "C")
    (command "TEXT" (list 870 (+ *FRAME-Y* paper-y 20)) 8 0
      (strcat "K" (itoa paper-num)))

    (setq paper-y (- paper-y 45))
    (setq paper-num (1+ paper-num))
  )

  ;; HP label
  (command "COLOR" 4)
  (command "TEXT" (list 620 (+ *FRAME-Y* 380)) 25 0 "HP")
  (command "COLOR" 7)
  (command "TEXT" (list 700 (+ *FRAME-Y* 380)) 15 0 "LaserJet III")

  ;; Status
  (command "COLOR" 3)
  (command "TEXT" (list 620 (+ *FRAME-Y* 750)) 15 0 "Printing: 8/23")
  (command "TEXT" (list 620 (+ *FRAME-Y* 720)) 12 0 "Speed: 8 pages/minute")

  ;; Cost note
  (command "COLOR" 1)
  (command "TEXT" (list 1350 (+ *FRAME-Y* 500)) 12 0 "DM 8,500")
  (command "COLOR" 8)
  (command "TEXT" (list 1350 (+ *FRAME-Y* 470)) 10 0 "(1991 price)")
  (command "TEXT" (list 1350 (+ *FRAME-Y* 440)) 10 0 "= $5,000 USD")

  (NARRATOR "The LaserJet III prints page after page. At DM 8,500 it was a major investment, but essential for quality output.")

  ;; Frame 17: Complete stack
  (NEXT-FRAME "Print Complete" 5)

  (command "COLOR" 0)
  (command "LINE"
    (list 100 (+ *FRAME-Y* 200))
    (list 1820 (+ *FRAME-Y* 200))
    (list 1820 (+ *FRAME-Y* 950))
    (list 100 (+ *FRAME-Y* 950))
    "C")

  ;; Stack of printed pages
  (command "COLOR" 7)
  (setq stack-y 300)
  (repeat 23
    (command "LINE"
      (list 700 (+ *FRAME-Y* stack-y))
      (list 1200 (+ *FRAME-Y* stack-y))
      (list 1200 (+ *FRAME-Y* stack-y 3))
      (list 700 (+ *FRAME-Y* stack-y 3))
      "C")
    (setq stack-y (+ stack-y 4))
  )

  ;; Top page with drawing
  (command "LINE"
    (list 700 (+ *FRAME-Y* stack-y))
    (list 1200 (+ *FRAME-Y* stack-y))
    (list 1200 (+ *FRAME-Y* stack-y 120))
    (list 700 (+ *FRAME-Y* stack-y 120))
    "C")

  ;; Drawing on top page
  (command "COLOR" 8)
  (command "CIRCLE" (list 950 (+ *FRAME-Y* stack-y 60)) 30)
  (command "TEXT" (list 940 (+ *FRAME-Y* stack-y 55)) 15 0 "M")
  (command "TEXT" (list 1000 (+ *FRAME-Y* stack-y 60)) 10 0 "M4")

  ;; Count label
  (command "COLOR" 2)
  (command "TEXT" (list 800 (+ *FRAME-Y* 700)) 40 0 "23 Pages")
  (command "COLOR" 7)
  (command "TEXT" (list 800 (+ *FRAME-Y* 640)) 15 0 "Ready for the project folder")

  ;; Title block simulation
  (command "COLOR" 7)
  (command "LINE"
    (list 1300 (+ *FRAME-Y* 400))
    (list 1700 (+ *FRAME-Y* 400))
    (list 1700 (+ *FRAME-Y* 600))
    (list 1300 (+ *FRAME-Y* 600))
    "C")
  (command "TEXT" (list 1320 (+ *FRAME-Y* 560)) 12 0 "Schmidt & Weber GmbH")
  (command "TEXT" (list 1320 (+ *FRAME-Y* 530)) 10 0 "Projekt: Fabrikhalle")
  (command "TEXT" (list 1320 (+ *FRAME-Y* 500)) 10 0 "Datum: 15.12.1991")
  (command "COLOR" 3)
  (command "TEXT" (list 1320 (+ *FRAME-Y* 460)) 14 0 "Erstellt mit AutoLISP")

  (NARRATOR "23 professional drawings, printed and ready. The project documentation is complete.")
)

;;; ============================================
;;; SCENE 6: FINALE
;;; ============================================

(defun SCENE-6-FINALE ()
  (princ "\n=== Scene 6: Finale ===\n")

  ;; Frame 18: Summary
  (NEXT-FRAME "The Result" 8)

  ;; Split screen: Before / After
  (command "COLOR" 7)
  (command "LINE" (list 960 (+ *FRAME-Y* 250)) (list 960 (+ *FRAME-Y* 900)) "")

  ;; LEFT: Manual way
  (command "COLOR" 1)
  (command "TEXT" (list 200 (+ *FRAME-Y* 850)) 25 0 "MANUAL METHOD")
  (command "COLOR" 7)
  (command "TEXT" (list 200 (+ *FRAME-Y* 780)) 14 0 "Draw each symbol by hand")
  (command "TEXT" (list 200 (+ *FRAME-Y* 740)) 14 0 "15 minutes per symbol")
  (command "TEXT" (list 200 (+ *FRAME-Y* 700)) 14 0 "23 symbols = 5.75 hours = 345 min")
  (command "COLOR" 1)
  (command "TEXT" (list 200 (+ *FRAME-Y* 640)) 20 0 "COST: DM 489")
  (command "COLOR" 8)
  (command "TEXT" (list 200 (+ *FRAME-Y* 600)) 12 0 "(at DM 85/hour labor)")

  ;; RIGHT: AutoLISP way
  (command "COLOR" 2)
  (command "TEXT" (list 1050 (+ *FRAME-Y* 850)) 25 0 "AUTOLISP METHOD")
  (command "COLOR" 7)
  (command "TEXT" (list 1050 (+ *FRAME-Y* 780)) 14 0 "Type SCHALTGEN, press Enter")
  (command "TEXT" (list 1050 (+ *FRAME-Y* 740)) 14 0 "2.5 minutes total")
  (command "TEXT" (list 1050 (+ *FRAME-Y* 700)) 14 0 "23 perfect drawings")
  (command "COLOR" 2)
  (command "TEXT" (list 1050 (+ *FRAME-Y* 640)) 20 0 "COST: DM 3.50")
  (command "COLOR" 8)
  (command "TEXT" (list 1050 (+ *FRAME-Y* 600)) 12 0 "(2.5 min at DM 85/hour)")

  ;; Savings
  (command "COLOR" 3)
  (command "TEXT" (list 400 (+ *FRAME-Y* 480)) 35 0 "TIME SAVED: 99.3%")
  (command "COLOR" 9)
  (command "TEXT" (list 400 (+ *FRAME-Y* 420)) 18 0 "345 min -> 2.5 min per batch")
  (command "TEXT" (list 400 (+ *FRAME-Y* 380)) 15 0 "For 50 projects/year: DM 24,275 saved annually")

  (NARRATOR "The math is simple. AutoLISP automation pays for itself many times over.")

  ;; Frame 19: Final message
  (NEXT-FRAME "The End" 10)

  (command "COLOR" 3)
  (command "TEXT" (list 550 (+ *FRAME-Y* 650)) 50 0 "AUTOLISP")
  (command "COLOR" 7)
  (command "TEXT" (list 500 (+ *FRAME-Y* 550)) 25 0 "Automation for the DOS Era")

  (command "COLOR" 9)
  (command "TEXT" (list 500 (+ *FRAME-Y* 450)) 15 0 "This workflow ran in engineering offices across Germany")
  (command "TEXT" (list 500 (+ *FRAME-Y* 420)) 15 0 "from 1986 until the Windows transition in the mid-1990s")

  (command "COLOR" 8)
  (command "TEXT" (list 500 (+ *FRAME-Y* 350)) 12 0 "The same .LSP files still run in modern AutoCAD today.")
  (command "TEXT" (list 500 (+ *FRAME-Y* 320)) 12 0 "And now, in rust-autolisp, they run without AutoCAD at all.")

  (command "COLOR" 3)
  (command "TEXT" (list 700 (+ *FRAME-Y* 220)) 20 0 "rust-autolisp")
  (command "COLOR" 8)
  (command "TEXT" (list 650 (+ *FRAME-Y* 180)) 12 0 "Preserving the automation heritage")

  (NARRATOR "Thank you for watching. The code lives on.")
)

;;; ============================================
;;; MAIN ENTRY POINT
;;; ============================================

(defun C:WORKFLOW ()
  "Generate complete workflow demonstration"
  (princ "\n")
  (princ "============================================\n")
  (princ "  THE AUTOLISP STORY: WORKFLOW DEMO\n")
  (princ "  From CSV to Laser Printer\n")
  (princ "============================================\n")
  (princ "\n")

  ;; Reset
  (setq *FRAME-NUM* 0)
  (setq *FRAME-Y* 0)

  ;; Generate all scenes
  (SCENE-1-BOOT)
  (SCENE-2-AUTOLOAD)
  (SCENE-3-SCHALTGEN)
  (SCENE-4-BATCH)
  (SCENE-5-PRINTING)
  (SCENE-6-FINALE)

  (princ "\n")
  (princ "============================================\n")
  (princ (strcat "  Total frames: " (itoa *FRAME-NUM*) "\n"))
  (princ "  Workflow demo complete!\n")
  (princ "============================================\n")

  (princ)
)

;;; Auto-run
(C:WORKFLOW)
