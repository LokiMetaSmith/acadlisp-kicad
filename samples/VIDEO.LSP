;;; VIDEO.LSP - Generate frames for 10-minute documentary video
;;; "The AutoLISP Story: Automation in 1991"
;;;
;;; Generates keyframes that will be compiled into MP4
;;; Each frame is a complete scene with narration text
;;;

;;; ============================================
;;; VIDEO CONFIGURATION
;;; ============================================

(setq *FRAME-W* 1920)
(setq *FRAME-H* 1080)
(setq *FRAME-NUM* 0)
(setq *FRAME-Y* 0)

;;; ============================================
;;; FRAME HELPERS
;;; ============================================

(defun NEW-FRAME (duration-sec)
  "Start a new video frame"
  (setq *FRAME-NUM* (1+ *FRAME-NUM*))
  (setq *FRAME-Y* (* (1- *FRAME-NUM*) (+ *FRAME-H* 20)))

  ;; Frame background
  (command "COLOR" 250)
  (command "LINE"
    (list 0 *FRAME-Y*)
    (list *FRAME-W* *FRAME-Y*)
    (list *FRAME-W* (+ *FRAME-Y* *FRAME-H*))
    (list 0 (+ *FRAME-Y* *FRAME-H*))
    "C")

  ;; Frame number indicator
  (command "COLOR" 8)
  (command "TEXT"
    (list 10 (+ *FRAME-Y* *FRAME-H* -20))
    8 0
    (strcat "Frame " (itoa *FRAME-NUM*) " | " (itoa duration-sec) "s"))

  *FRAME-Y*
)

(defun TITLE-TEXT (txt y-pos size)
  "Draw centered title text"
  (command "TEXT"
    (list (/ *FRAME-W* 2) (+ *FRAME-Y* y-pos))
    size 0 txt)
)

(defun NARRATION (txt)
  "Draw narration text at bottom"
  (command "COLOR" 7)
  ;; Background bar
  (command "LINE"
    (list 0 (+ *FRAME-Y* 50))
    (list *FRAME-W* (+ *FRAME-Y* 50))
    (list *FRAME-W* (+ *FRAME-Y* 120))
    (list 0 (+ *FRAME-Y* 120))
    "C")
  (command "COLOR" 250)
  (command "LINE"
    (list 5 (+ *FRAME-Y* 55))
    (list (- *FRAME-W* 5) (+ *FRAME-Y* 55))
    (list (- *FRAME-W* 5) (+ *FRAME-Y* 115))
    (list 5 (+ *FRAME-Y* 115))
    "C")
  (command "COLOR" 7)
  (command "TEXT"
    (list 50 (+ *FRAME-Y* 80))
    14 0 txt)
)

(defun TIMECODE (minutes seconds)
  "Draw timecode"
  (command "COLOR" 1)
  (command "TEXT"
    (list (- *FRAME-W* 150) (+ *FRAME-Y* *FRAME-H* -30))
    12 0
    (strcat (itoa minutes) ":"
            (if (< seconds 10) "0" "")
            (itoa seconds)))
)

;;; ============================================
;;; SCENE 1: TITLE SEQUENCE (0:00 - 0:30)
;;; ============================================

(defun SCENE-1-TITLE ()
  (princ "\n=== SCENE 1: Title Sequence ===\n")

  ;; Frame 1: Black with fade in text
  (NEW-FRAME 5)
  (command "COLOR" 3)
  (TITLE-TEXT "THE AUTOLISP STORY" 600 40)
  (command "COLOR" 9)
  (TITLE-TEXT "Automation in the Age of DOS" 520 20)
  (TIMECODE 0 0)

  ;; Frame 2: Subtitle
  (NEW-FRAME 5)
  (command "COLOR" 3)
  (TITLE-TEXT "THE AUTOLISP STORY" 650 40)
  (command "COLOR" 9)
  (TITLE-TEXT "Automation in the Age of DOS" 580 20)
  (command "COLOR" 7)
  (TITLE-TEXT "A rust-autolisp Documentary" 450 15)
  (command "COLOR" 8)
  (TITLE-TEXT "Schmidt & Weber GmbH - München, 1991" 400 12)
  (TIMECODE 0 5)

  ;; Frame 3: Era establishing
  (NEW-FRAME 10)
  (command "COLOR" 7)
  (TITLE-TEXT "The Year is 1991" 700 35)
  (command "COLOR" 9)
  (TITLE-TEXT "The Berlin Wall has fallen" 600 18)
  (TITLE-TEXT "The Soviet Union is dissolving" 560 18)
  (TITLE-TEXT "And in Munich, engineers are writing code..." 480 18)
  (NARRATION "In a small engineering office in Munich, a revolution in CAD automation is taking place.")
  (TIMECODE 0 10)

  ;; Frame 4: The office
  (NEW-FRAME 10)
  ;; Draw office scene
  (command "COLOR" 8)
  ;; Desk
  (command "LINE"
    (list 200 (+ *FRAME-Y* 300))
    (list 800 (+ *FRAME-Y* 300))
    (list 800 (+ *FRAME-Y* 350))
    (list 200 (+ *FRAME-Y* 350))
    "C")
  ;; Computer (386)
  (command "COLOR" 7)
  (command "LINE"
    (list 300 (+ *FRAME-Y* 350))
    (list 500 (+ *FRAME-Y* 350))
    (list 500 (+ *FRAME-Y* 550))
    (list 300 (+ *FRAME-Y* 550))
    "C")
  ;; Screen (green on black)
  (command "COLOR" 250)
  (command "LINE"
    (list 320 (+ *FRAME-Y* 400))
    (list 480 (+ *FRAME-Y* 400))
    (list 480 (+ *FRAME-Y* 530))
    (list 320 (+ *FRAME-Y* 530))
    "C")
  (command "COLOR" 3)
  (command "TEXT" (list 330 (+ *FRAME-Y* 500)) 8 0 "C:\\ACAD>_")

  ;; Person silhouette
  (command "COLOR" 8)
  (command "CIRCLE" (list 650 (+ *FRAME-Y* 500)) 40)
  (command "LINE"
    (list 650 (+ *FRAME-Y* 460))
    (list 650 (+ *FRAME-Y* 300))
    "")

  (command "COLOR" 7)
  (TITLE-TEXT "Elektrotechnik Planungsbüro" 800 25)
  (TITLE-TEXT "Schmidt & Weber GmbH" 750 20)

  (NARRATION "At Schmidt & Weber, electrical engineers face a challenge: hundreds of circuit diagrams to create.")
  (TIMECODE 0 20)
)

;;; ============================================
;;; SCENE 2: THE PROBLEM (0:30 - 1:30)
;;; ============================================

(defun SCENE-2-PROBLEM ()
  (princ "\n=== SCENE 2: The Problem ===\n")

  ;; Frame 5: Stack of drawings
  (NEW-FRAME 15)
  (command "COLOR" 7)
  (TITLE-TEXT "The Challenge" 900 30)

  ;; Stack of paper
  (setq i 0)
  (repeat 20
    (command "COLOR" 7)
    (command "LINE"
      (list (+ 400 (* i 3)) (+ *FRAME-Y* 300 (* i 5)))
      (list (+ 700 (* i 3)) (+ *FRAME-Y* 300 (* i 5)))
      (list (+ 700 (* i 3)) (+ *FRAME-Y* 500 (* i 5)))
      (list (+ 400 (* i 3)) (+ *FRAME-Y* 500 (* i 5)))
      "C")
    (setq i (1+ i))
  )

  (command "COLOR" 1)
  (TITLE-TEXT "500+ Drawings Per Project" 600 20)

  (NARRATION "Each project requires hundreds of individual drawings. Each Schütz, Schalter, Motor needs its own file.")
  (TIMECODE 0 30)

  ;; Frame 6: Time problem
  (NEW-FRAME 15)
  (command "COLOR" 7)
  (TITLE-TEXT "Manual Drawing Time" 850 25)

  ;; Clock
  (command "CIRCLE" (list 960 (+ *FRAME-Y* 500)) 150)
  (command "LINE"
    (list 960 (+ *FRAME-Y* 500))
    (list 960 (+ *FRAME-Y* 620))
    "")
  (command "LINE"
    (list 960 (+ *FRAME-Y* 500))
    (list 1050 (+ *FRAME-Y* 550))
    "")

  (command "COLOR" 1)
  (command "TEXT" (list 300 (+ *FRAME-Y* 550)) 30 0 "15 min")
  (command "COLOR" 7)
  (command "TEXT" (list 300 (+ *FRAME-Y* 480)) 15 0 "per symbol")

  (command "COLOR" 2)
  (command "TEXT" (list 300 (+ *FRAME-Y* 380)) 20 0 "= 125 hours")
  (command "TEXT" (list 300 (+ *FRAME-Y* 330)) 15 0 "for 500 drawings")

  (NARRATION "Drawing each symbol manually takes 15 minutes. For a full project, that's over 3 weeks of work!")
  (TIMECODE 0 45)

  ;; Frame 7: The cost
  (NEW-FRAME 15)
  (command "COLOR" 7)
  (TITLE-TEXT "The Cost of Manual Work" 900 25)

  (command "COLOR" 1)
  (command "TEXT" (list 400 (+ *FRAME-Y* 600)) 40 0 "DM 15,000")
  (command "COLOR" 7)
  (command "TEXT" (list 400 (+ *FRAME-Y* 530)) 15 0 "Labor cost per project")

  (command "COLOR" 2)
  (command "TEXT" (list 400 (+ *FRAME-Y* 400)) 20 0 "There must be a better way...")

  (NARRATION "The labor cost is enormous. The engineers know there must be a way to automate this repetitive work.")
  (TIMECODE 1 0)

  ;; Frame 8: The idea
  (NEW-FRAME 15)
  (command "COLOR" 3)
  (TITLE-TEXT "The Idea" 900 35)

  ;; Light bulb
  (command "COLOR" 2)
  (command "CIRCLE" (list 960 (+ *FRAME-Y* 550)) 80)
  (command "LINE"
    (list 920 (+ *FRAME-Y* 470))
    (list 1000 (+ *FRAME-Y* 470))
    (list 1000 (+ *FRAME-Y* 430))
    (list 920 (+ *FRAME-Y* 430))
    "C")

  (command "COLOR" 7)
  (command "TEXT" (list 300 (+ *FRAME-Y* 600)) 18 0 "What if the computer")
  (command "TEXT" (list 300 (+ *FRAME-Y* 560)) 18 0 "could draw for us?")

  (command "COLOR" 3)
  (command "TEXT" (list 300 (+ *FRAME-Y* 450)) 25 0 "AutoLISP")
  (command "COLOR" 9)
  (command "TEXT" (list 300 (+ *FRAME-Y* 400)) 12 0 "The programming language built into AutoCAD")

  (NARRATION "AutoCAD comes with a secret weapon: AutoLISP. A programming language that can control the CAD software.")
  (TIMECODE 1 15)
)

;;; ============================================
;;; SCENE 3: AUTOLISP INTRODUCTION (1:30 - 3:00)
;;; ============================================

(defun SCENE-3-AUTOLISP ()
  (princ "\n=== SCENE 3: AutoLISP Introduction ===\n")

  ;; Frame 9: What is AutoLISP
  (NEW-FRAME 15)
  (command "COLOR" 3)
  (TITLE-TEXT "What is AutoLISP?" 900 30)

  (command "COLOR" 7)
  (command "TEXT" (list 200 (+ *FRAME-Y* 700)) 15 0 "• A dialect of LISP (1958)")
  (command "TEXT" (list 200 (+ *FRAME-Y* 650)) 15 0 "• Built into AutoCAD since 1986")
  (command "TEXT" (list 200 (+ *FRAME-Y* 600)) 15 0 "• Can read files, do math, draw geometry")
  (command "TEXT" (list 200 (+ *FRAME-Y* 550)) 15 0 "• Runs directly in AutoCAD command line")

  (command "COLOR" 9)
  (command "TEXT" (list 1000 (+ *FRAME-Y* 600)) 20 0 "(+ 1 2)")
  (command "COLOR" 3)
  (command "TEXT" (list 1000 (+ *FRAME-Y* 550)) 20 0 "=> 3")

  (NARRATION "AutoLISP is a programming language embedded in AutoCAD. It uses parentheses for everything.")
  (TIMECODE 1 30)

  ;; Frame 10: LISP syntax
  (NEW-FRAME 20)
  (command "COLOR" 3)
  (TITLE-TEXT "The Language of Parentheses" 900 25)

  (command "COLOR" 8)
  (command "LINE"
    (list 200 (+ *FRAME-Y* 300))
    (list 1700 (+ *FRAME-Y* 300))
    (list 1700 (+ *FRAME-Y* 750))
    (list 200 (+ *FRAME-Y* 750))
    "C")

  (command "COLOR" 5)
  (command "TEXT" (list 250 (+ *FRAME-Y* 700)) 12 0 "(defun")
  (command "COLOR" 6)
  (command "TEXT" (list 360 (+ *FRAME-Y* 700)) 12 0 "DRAW-SCHUETZ")
  (command "COLOR" 7)
  (command "TEXT" (list 540 (+ *FRAME-Y* 700)) 12 0 "(pt)")

  (command "COLOR" 3)
  (command "TEXT" (list 270 (+ *FRAME-Y* 650)) 10 0 ";; Draw a contactor symbol at point pt")

  (command "COLOR" 7)
  (command "TEXT" (list 270 (+ *FRAME-Y* 600)) 12 0 "(command \"LINE\"")
  (command "COLOR" 9)
  (command "TEXT" (list 470 (+ *FRAME-Y* 600)) 12 0 "pt")
  (command "COLOR" 7)
  (command "TEXT" (list 500 (+ *FRAME-Y* 600)) 12 0 "(list (+ x 50) y)")

  (command "TEXT" (list 270 (+ *FRAME-Y* 550)) 12 0 "(command \"ARC\" ...)")
  (command "TEXT" (list 270 (+ *FRAME-Y* 500)) 12 0 "(command \"TEXT\" bezeichnung)")

  (command "COLOR" 7)
  (command "TEXT" (list 250 (+ *FRAME-Y* 450)) 12 0 ")")

  (NARRATION "A LISP function starts with DEFUN. It can issue AutoCAD commands like LINE, ARC, and TEXT.")
  (TIMECODE 1 50)

  ;; Frame 11: Building blocks
  (NEW-FRAME 20)
  (command "COLOR" 7)
  (TITLE-TEXT "Building Blocks" 950 25)

  ;; Show modular files
  (command "COLOR" 2)
  (command "LINE"
    (list 300 (+ *FRAME-Y* 600))
    (list 500 (+ *FRAME-Y* 600))
    (list 500 (+ *FRAME-Y* 750))
    (list 300 (+ *FRAME-Y* 750))
    "C")
  (command "COLOR" 7)
  (command "TEXT" (list 320 (+ *FRAME-Y* 700)) 12 0 "CSVREAD.LSP")
  (command "COLOR" 9)
  (command "TEXT" (list 320 (+ *FRAME-Y* 660)) 8 0 "Parse CSV files")
  (command "TEXT" (list 320 (+ *FRAME-Y* 640)) 8 0 "char by char")

  (command "COLOR" 3)
  (command "LINE"
    (list 600 (+ *FRAME-Y* 600))
    (list 800 (+ *FRAME-Y* 600))
    (list 800 (+ *FRAME-Y* 750))
    (list 600 (+ *FRAME-Y* 750))
    "C")
  (command "COLOR" 7)
  (command "TEXT" (list 620 (+ *FRAME-Y* 700)) 12 0 "EBLOCKS.LSP")
  (command "COLOR" 9)
  (command "TEXT" (list 620 (+ *FRAME-Y* 660)) 8 0 "Electrical symbols")
  (command "TEXT" (list 620 (+ *FRAME-Y* 640)) 8 0 "DIN standard")

  (command "COLOR" 6)
  (command "LINE"
    (list 900 (+ *FRAME-Y* 600))
    (list 1100 (+ *FRAME-Y* 600))
    (list 1100 (+ *FRAME-Y* 750))
    (list 900 (+ *FRAME-Y* 750))
    "C")
  (command "COLOR" 7)
  (command "TEXT" (list 920 (+ *FRAME-Y* 700)) 12 0 "SCHALT.LSP")
  (command "COLOR" 9)
  (command "TEXT" (list 920 (+ *FRAME-Y* 660)) 8 0 "Main generator")
  (command "TEXT" (list 920 (+ *FRAME-Y* 640)) 8 0 "batch processing")

  ;; Arrows connecting them
  (command "COLOR" 7)
  (command "LINE" (list 500 (+ *FRAME-Y* 675)) (list 600 (+ *FRAME-Y* 675)) "")
  (command "LINE" (list 800 (+ *FRAME-Y* 675)) (list 900 (+ *FRAME-Y* 675)) "")

  (NARRATION "The system is modular: CSVREAD parses data, EBLOCKS defines symbols, SCHALT orchestrates everything.")
  (TIMECODE 2 10)

  ;; Frame 12: The (load) command
  (NEW-FRAME 20)
  (command "COLOR" 7)
  (TITLE-TEXT "The Import System" 950 25)

  (command "COLOR" 2)
  (command "TEXT" (list 400 (+ *FRAME-Y* 700)) 18 0 "ACAD.LSP")
  (command "COLOR" 9)
  (command "TEXT" (list 400 (+ *FRAME-Y* 650)) 10 0 "(loaded automatically at startup)")

  ;; Arrows down
  (command "COLOR" 7)
  (command "LINE"
    (list 500 (+ *FRAME-Y* 630))
    (list 500 (+ *FRAME-Y* 580))
    "")

  (command "COLOR" 7)
  (command "TEXT" (list 300 (+ *FRAME-Y* 550)) 14 0 "(load \"CSVREAD\")")
  (command "TEXT" (list 300 (+ *FRAME-Y* 500)) 14 0 "(load \"EBLOCKS\")")
  (command "TEXT" (list 300 (+ *FRAME-Y* 450)) 14 0 "(load \"SCHALT\")")

  (command "COLOR" 3)
  (command "TEXT" (list 700 (+ *FRAME-Y* 500)) 15 0 "=> All functions ready!")

  (NARRATION "ACAD.LSP loads at startup and uses (load) to import other files. This creates the complete system.")
  (TIMECODE 2 30)

  ;; Frame 13: Strong typing note
  (NEW-FRAME 15)
  (command "COLOR" 1)
  (TITLE-TEXT "Type Safety in AutoLISP" 900 25)

  (command "COLOR" 7)
  (command "TEXT" (list 250 (+ *FRAME-Y* 700)) 14 0 "AutoLISP has strict runtime type checking:")

  (command "COLOR" 3)
  (command "TEXT" (list 300 (+ *FRAME-Y* 620)) 12 0 "(+ 1 2)          => 3")
  (command "COLOR" 1)
  (command "TEXT" (list 300 (+ *FRAME-Y* 570)) 12 0 "(+ 1 \"hello\")    => ERROR!")

  (command "COLOR" 7)
  (command "TEXT" (list 300 (+ *FRAME-Y* 480)) 12 0 "(strcat \"A\" \"B\") => \"AB\"")
  (command "COLOR" 1)
  (command "TEXT" (list 300 (+ *FRAME-Y* 430)) 12 0 "(strcat \"A\" 42)   => ERROR!")

  (command "COLOR" 9)
  (command "TEXT" (list 800 (+ *FRAME-Y* 550)) 10 0 "You cannot mix types!")
  (command "TEXT" (list 800 (+ *FRAME-Y* 510)) 10 0 "The interpreter will reject it.")

  (NARRATION "AutoLISP enforces strict types at runtime. You cannot add a number to a string - it will error immediately.")
  (TIMECODE 2 45)
)

;;; ============================================
;;; SCENE 4: THE CSV DATA (3:00 - 4:00)
;;; ============================================

(defun SCENE-4-CSV ()
  (princ "\n=== SCENE 4: The CSV Data ===\n")

  ;; Frame 14: Where does data come from?
  (NEW-FRAME 15)
  (command "COLOR" 7)
  (TITLE-TEXT "Where Does the Data Come From?" 900 25)

  ;; dBase III box
  (command "COLOR" 4)
  (command "LINE"
    (list 300 (+ *FRAME-Y* 500))
    (list 550 (+ *FRAME-Y* 500))
    (list 550 (+ *FRAME-Y* 700))
    (list 300 (+ *FRAME-Y* 700))
    "C")
  (command "COLOR" 7)
  (command "TEXT" (list 350 (+ *FRAME-Y* 620)) 18 0 "dBase III")
  (command "COLOR" 9)
  (command "TEXT" (list 330 (+ *FRAME-Y* 560)) 10 0 "Database software")
  (command "TEXT" (list 330 (+ *FRAME-Y* 530)) 10 0 "from 1984")

  ;; Arrow
  (command "COLOR" 7)
  (command "LINE"
    (list 550 (+ *FRAME-Y* 600))
    (list 650 (+ *FRAME-Y* 600))
    "")
  (command "TEXT" (list 570 (+ *FRAME-Y* 630)) 10 0 "export")

  ;; CSV file
  (command "COLOR" 2)
  (command "LINE"
    (list 650 (+ *FRAME-Y* 500))
    (list 900 (+ *FRAME-Y* 500))
    (list 900 (+ *FRAME-Y* 700))
    (list 650 (+ *FRAME-Y* 700))
    "C")
  (command "COLOR" 7)
  (command "TEXT" (list 680 (+ *FRAME-Y* 620)) 15 0 "KOMPONEN.CSV")
  (command "COLOR" 9)
  (command "TEXT" (list 680 (+ *FRAME-Y* 560)) 8 0 "TYP;BEZEICHNUNG;WERT")
  (command "TEXT" (list 680 (+ *FRAME-Y* 540)) 8 0 "SCHUETZ;K1;24V DC")

  (NARRATION "Engineers maintain component lists in dBase III database. They export to CSV for AutoCAD processing.")
  (TIMECODE 3 0)

  ;; Frame 15: CSV structure
  (NEW-FRAME 20)
  (command "COLOR" 7)
  (TITLE-TEXT "KOMPONEN.CSV - Component List" 950 20)

  ;; Table header
  (command "COLOR" 4)
  (command "LINE"
    (list 200 (+ *FRAME-Y* 720))
    (list 1700 (+ *FRAME-Y* 720))
    (list 1700 (+ *FRAME-Y* 780))
    (list 200 (+ *FRAME-Y* 780))
    "C")

  (command "COLOR" 7)
  (command "TEXT" (list 220 (+ *FRAME-Y* 745)) 12 0 "TYP")
  (command "TEXT" (list 400 (+ *FRAME-Y* 745)) 12 0 "BEZEICHNUNG")
  (command "TEXT" (list 650 (+ *FRAME-Y* 745)) 12 0 "WERT")
  (command "TEXT" (list 900 (+ *FRAME-Y* 745)) 12 0 "HERSTELLER")
  (command "TEXT" (list 1200 (+ *FRAME-Y* 745)) 12 0 "BESTELLNR")

  ;; Data rows
  (command "COLOR" 3)
  (command "TEXT" (list 220 (+ *FRAME-Y* 690)) 10 0 "SCHUETZ")
  (command "COLOR" 7)
  (command "TEXT" (list 400 (+ *FRAME-Y* 690)) 10 0 "K1")
  (command "TEXT" (list 650 (+ *FRAME-Y* 690)) 10 0 "24V DC")
  (command "TEXT" (list 900 (+ *FRAME-Y* 690)) 10 0 "Siemens")
  (command "TEXT" (list 1200 (+ *FRAME-Y* 690)) 10 0 "3RT1015-1BB41")

  (command "COLOR" 3)
  (command "TEXT" (list 220 (+ *FRAME-Y* 650)) 10 0 "SCHUETZ")
  (command "COLOR" 7)
  (command "TEXT" (list 400 (+ *FRAME-Y* 650)) 10 0 "K2")
  (command "TEXT" (list 650 (+ *FRAME-Y* 650)) 10 0 "24V DC")
  (command "TEXT" (list 900 (+ *FRAME-Y* 650)) 10 0 "Siemens")
  (command "TEXT" (list 1200 (+ *FRAME-Y* 650)) 10 0 "3RT1015-1BB41")

  (command "COLOR" 3)
  (command "TEXT" (list 220 (+ *FRAME-Y* 610)) 10 0 "MOTOR")
  (command "COLOR" 7)
  (command "TEXT" (list 400 (+ *FRAME-Y* 610)) 10 0 "M1")
  (command "TEXT" (list 650 (+ *FRAME-Y* 610)) 10 0 "5.5kW")
  (command "TEXT" (list 900 (+ *FRAME-Y* 610)) 10 0 "Siemens")
  (command "TEXT" (list 1200 (+ *FRAME-Y* 610)) 10 0 "1LA7113-4AA")

  (command "COLOR" 8)
  (command "TEXT" (list 220 (+ *FRAME-Y* 560)) 10 0 "... 20 more rows ...")

  (NARRATION "Each row defines one component: its type, designation, electrical value, manufacturer, and order number.")
  (TIMECODE 3 20)

  ;; Frame 16: German CSV format
  (NEW-FRAME 15)
  (command "COLOR" 2)
  (TITLE-TEXT "German CSV Format" 900 25)

  (command "COLOR" 7)
  (command "TEXT" (list 300 (+ *FRAME-Y* 700)) 15 0 "In Germany, CSV uses SEMICOLON, not comma!")

  (command "COLOR" 9)
  (command "TEXT" (list 350 (+ *FRAME-Y* 620)) 14 0 "TYP;BEZEICHNUNG;WERT;HERSTELLER")

  (command "COLOR" 7)
  (command "TEXT" (list 300 (+ *FRAME-Y* 550)) 12 0 "Why? Because Germans use comma for decimals:")
  (command "COLOR" 3)
  (command "TEXT" (list 350 (+ *FRAME-Y* 500)) 14 0 "3,14159  (not 3.14159)")

  (command "COLOR" 9)
  (command "TEXT" (list 300 (+ *FRAME-Y* 420)) 12 0 "CSVREAD.LSP handles this with:")
  (command "COLOR" 7)
  (command "TEXT" (list 350 (+ *FRAME-Y* 380)) 12 0 "(setq *CSV-DELIM* 59)  ; ASCII for semicolon")

  (NARRATION "German CSV uses semicolon as delimiter because comma is the decimal separator. Our parser handles this.")
  (TIMECODE 3 35)
)

;;; ============================================
;;; SCENE 5: THE SYMBOLS (4:00 - 5:30)
;;; ============================================

(defun SCENE-5-SYMBOLS ()
  (princ "\n=== SCENE 5: Electrical Symbols ===\n")

  ;; Frame 17: DIN Standard
  (NEW-FRAME 15)
  (command "COLOR" 7)
  (TITLE-TEXT "Electrical Symbols - DIN Standard" 950 25)

  (command "COLOR" 9)
  (command "TEXT" (list 300 (+ *FRAME-Y* 750)) 12 0 "All symbols follow DIN EN 60617")
  (command "TEXT" (list 300 (+ *FRAME-Y* 720)) 12 0 "The German/European standard for electrical schematics")

  ;; Grid of symbols
  (DRAW-SYMBOL-GRID *FRAME-Y*)

  (NARRATION "Every symbol must conform to DIN standards. These standards ensure drawings are universally understood.")
  (TIMECODE 4 0)

  ;; Frame 18: Schuetz detail
  (NEW-FRAME 20)
  (command "COLOR" 7)
  (TITLE-TEXT "Schütz (Contactor)" 950 25)

  ;; Large Schuetz drawing
  (setq cx 600)
  (setq cy (+ *FRAME-Y* 500))

  (command "COLOR" 7)
  ;; Coil body
  (command "LINE"
    (list cx cy)
    (list (+ cx 150) cy)
    (list (+ cx 150) (+ cy 250))
    (list cx (+ cy 250))
    "C")

  ;; Coil windings
  (command "ARC"
    (list (+ cx 30) (+ cy 50))
    (list (+ cx 75) (+ cy 80))
    (list (+ cx 120) (+ cy 50)))
  (command "ARC"
    (list (+ cx 30) (+ cy 100))
    (list (+ cx 75) (+ cy 130))
    (list (+ cx 120) (+ cy 100)))
  (command "ARC"
    (list (+ cx 30) (+ cy 150))
    (list (+ cx 75) (+ cy 180))
    (list (+ cx 120) (+ cy 150)))

  ;; Terminals
  (command "LINE" (list (+ cx 75) cy) (list (+ cx 75) (- cy 40)) "")
  (command "LINE" (list (+ cx 75) (+ cy 250)) (list (+ cx 75) (+ cy 290)) "")

  ;; Labels
  (command "COLOR" 3)
  (command "TEXT" (list (+ cx 90) (- cy 50)) 15 0 "A2")
  (command "TEXT" (list (+ cx 90) (+ cy 295)) 15 0 "A1")

  ;; Explanation
  (command "COLOR" 9)
  (command "TEXT" (list 1000 (+ *FRAME-Y* 700)) 12 0 "Coil symbol shows")
  (command "TEXT" (list 1000 (+ *FRAME-Y* 670)) 12 0 "electromagnetic windings")
  (command "TEXT" (list 1000 (+ *FRAME-Y* 600)) 12 0 "A1/A2 = Coil terminals")
  (command "TEXT" (list 1000 (+ *FRAME-Y* 550)) 12 0 "When energized, contacts close")

  (NARRATION "A Schütz is a contactor - an electrically controlled switch for high-power circuits. The coil creates a magnetic field.")
  (TIMECODE 4 20)

  ;; Frame 19: Motor symbol
  (NEW-FRAME 15)
  (command "COLOR" 7)
  (TITLE-TEXT "Motor Symbol (Drehstrommotor)" 950 25)

  ;; Large motor
  (setq cx 700)
  (setq cy (+ *FRAME-Y* 500))

  (command "CIRCLE" (list cx cy) 120)
  (command "TEXT" (list (- cx 30) (- cy 15)) 50 0 "M")
  (command "TEXT" (list (- cx 25) (+ cy 45)) 25 0 "3~")

  ;; Terminals U V W
  (command "LINE" (list (- cx 60) (+ cy 120)) (list (- cx 60) (+ cy 180)) "")
  (command "LINE" (list cx (+ cy 120)) (list cx (+ cy 180)) "")
  (command "LINE" (list (+ cx 60) (+ cy 120)) (list (+ cx 60) (+ cy 180)) "")

  (command "COLOR" 1)
  (command "TEXT" (list (- cx 70) (+ cy 200)) 12 0 "U")
  (command "COLOR" 2)
  (command "TEXT" (list (- cx 10) (+ cy 200)) 12 0 "V")
  (command "COLOR" 4)
  (command "TEXT" (list (+ cx 50) (+ cy 200)) 12 0 "W")

  (command "COLOR" 9)
  (command "TEXT" (list 1000 (+ *FRAME-Y* 650)) 12 0 "M = Motor")
  (command "TEXT" (list 1000 (+ *FRAME-Y* 610)) 12 0 "3~ = Three-phase AC")
  (command "TEXT" (list 1000 (+ *FRAME-Y* 560)) 12 0 "U, V, W = Phase connections")

  (NARRATION "Three-phase motors are the workhorses of industry. The 3~ symbol indicates three-phase alternating current.")
  (TIMECODE 4 35)

  ;; Frame 20: All symbols overview
  (NEW-FRAME 20)
  (command "COLOR" 7)
  (TITLE-TEXT "EBLOCKS.LSP - Symbol Library" 950 20)

  (command "COLOR" 9)
  (command "TEXT" (list 200 (+ *FRAME-Y* 750)) 12 0 "Each symbol is a function:")

  (command "COLOR" 7)
  (command "TEXT" (list 250 (+ *FRAME-Y* 700)) 10 0 "DRAW-SCHUETZ    - Contactor")
  (command "TEXT" (list 250 (+ *FRAME-Y* 670)) 10 0 "DRAW-SCHALTER   - Switch")
  (command "TEXT" (list 250 (+ *FRAME-Y* 640)) 10 0 "DRAW-KREUZSCH   - 4-way switch")
  (command "TEXT" (list 250 (+ *FRAME-Y* 610)) 10 0 "DRAW-WECHSELS   - 3-way switch")
  (command "TEXT" (list 250 (+ *FRAME-Y* 580)) 10 0 "DRAW-SICHERG    - Fuse")
  (command "TEXT" (list 250 (+ *FRAME-Y* 550)) 10 0 "DRAW-RELAIS     - Relay")
  (command "TEXT" (list 250 (+ *FRAME-Y* 520)) 10 0 "DRAW-MOTOR      - Motor")
  (command "TEXT" (list 250 (+ *FRAME-Y* 490)) 10 0 "DRAW-KLEMME     - Terminal")

  ;; Small symbol previews
  (DRAW-MINI-SYMBOLS (+ *FRAME-Y* 400))

  (NARRATION "EBLOCKS.LSP contains all symbol drawing functions. Each takes a point and draws the complete symbol.")
  (TIMECODE 5 0)
)

(defun DRAW-SYMBOL-GRID (y-base)
  "Draw a grid of small symbols"
  ;; Simplified - just boxes with labels
  (command "COLOR" 7)
  (setq sx 300)
  (setq sy (+ y-base 450))

  ;; Schuetz
  (command "LINE" (list sx sy) (list (+ sx 60) sy) (list (+ sx 60) (+ sy 80)) (list sx (+ sy 80)) "C")
  (command "TEXT" (list (+ sx 10) (+ sy 100)) 8 0 "Schütz")

  ;; Schalter
  (setq sx 450)
  (command "CIRCLE" (list sx (+ sy 40)) 10)
  (command "CIRCLE" (list (+ sx 50) (+ sy 40)) 10)
  (command "LINE" (list (+ sx 10) (+ sy 40)) (list (+ sx 35) (+ sy 55)) "")
  (command "TEXT" (list sx (+ sy 100)) 8 0 "Schalter")

  ;; Motor
  (setq sx 600)
  (command "CIRCLE" (list (+ sx 30) (+ sy 40)) 35)
  (command "TEXT" (list (+ sx 20) (+ sy 35)) 15 0 "M")
  (command "TEXT" (list sx (+ sy 100)) 8 0 "Motor")

  ;; Sicherung
  (setq sx 750)
  (command "LINE" (list sx (+ sy 30)) (list (+ sx 60) (+ sy 30)) (list (+ sx 60) (+ sy 50)) (list sx (+ sy 50)) "C")
  (command "LINE" (list sx (+ sy 40)) (list (+ sx 60) (+ sy 40)) "")
  (command "TEXT" (list sx (+ sy 100)) 8 0 "Sicherung")
)

(defun DRAW-MINI-SYMBOLS (y-base)
  "Draw mini symbol row"
  (command "COLOR" 7)
  ;; Just show small boxes representing each
  (setq sx 700)
  (command "LINE" (list sx y-base) (list (+ sx 40) y-base) (list (+ sx 40) (+ y-base 50)) (list sx (+ y-base 50)) "C")
  (command "CIRCLE" (list (+ sx 100) (+ y-base 25)) 20)
  (command "LINE" (list (+ sx 150) (+ y-base 20)) (list (+ sx 200) (+ y-base 30)) "")
)

;;; ============================================
;;; SCENE 6: BATCH PROCESSING (5:30 - 7:00)
;;; ============================================

(defun SCENE-6-BATCH ()
  (princ "\n=== SCENE 6: Batch Processing ===\n")

  ;; Frame 21: The magic command
  (NEW-FRAME 15)
  (command "COLOR" 3)
  (TITLE-TEXT "The Magic Command" 900 30)

  (command "COLOR" 250)
  (command "LINE"
    (list 400 (+ *FRAME-Y* 450))
    (list 1500 (+ *FRAME-Y* 450))
    (list 1500 (+ *FRAME-Y* 600))
    (list 400 (+ *FRAME-Y* 600))
    "C")

  (command "COLOR" 7)
  (command "TEXT" (list 450 (+ *FRAME-Y* 550)) 15 0 "Command:")
  (command "COLOR" 3)
  (command "TEXT" (list 620 (+ *FRAME-Y* 550)) 25 0 "SCHALTGEN")

  (command "COLOR" 9)
  (command "TEXT" (list 450 (+ *FRAME-Y* 490)) 12 0 "CSV-Datei: KOMPONEN.CSV")

  (NARRATION "One command. SCHALTGEN. Type it and watch the magic happen. The computer takes over.")
  (TIMECODE 5 30)

  ;; Frame 22: Processing animation frame 1
  (NEW-FRAME 10)
  (command "COLOR" 7)
  (TITLE-TEXT "Batch Processing..." 950 20)

  (command "COLOR" 3)
  (command "TEXT" (list 300 (+ *FRAME-Y* 700)) 12 0 "[1/23] Processing K1...")
  (command "TEXT" (list 600 (+ *FRAME-Y* 700)) 10 0 "SCHUETZ -> DRAW-SCHUETZ")

  ;; Show K1 being drawn
  (command "COLOR" 7)
  (command "LINE"
    (list 800 (+ *FRAME-Y* 500))
    (list 900 (+ *FRAME-Y* 500))
    (list 900 (+ *FRAME-Y* 650))
    (list 800 (+ *FRAME-Y* 650))
    "C")
  (command "TEXT" (list 920 (+ *FRAME-Y* 570)) 15 0 "K1")

  ;; Progress bar
  (command "COLOR" 8)
  (command "LINE"
    (list 300 (+ *FRAME-Y* 300))
    (list 1600 (+ *FRAME-Y* 300))
    (list 1600 (+ *FRAME-Y* 340))
    (list 300 (+ *FRAME-Y* 340))
    "C")
  (command "COLOR" 3)
  (command "LINE"
    (list 302 (+ *FRAME-Y* 302))
    (list 360 (+ *FRAME-Y* 302))
    (list 360 (+ *FRAME-Y* 338))
    (list 302 (+ *FRAME-Y* 338))
    "C")
  (command "COLOR" 7)
  (command "TEXT" (list 300 (+ *FRAME-Y* 260)) 10 0 "4% complete")

  (NARRATION "Row by row, the system reads the CSV. For each component, it finds the right drawing function.")
  (TIMECODE 5 40)

  ;; Frame 23: Processing animation frame 2
  (NEW-FRAME 10)
  (command "COLOR" 7)
  (TITLE-TEXT "Batch Processing..." 950 20)

  (command "COLOR" 3)
  (command "TEXT" (list 300 (+ *FRAME-Y* 700)) 12 0 "[12/23] Processing M1...")
  (command "TEXT" (list 600 (+ *FRAME-Y* 700)) 10 0 "MOTOR -> DRAW-MOTOR")

  ;; Show motor being drawn
  (command "COLOR" 7)
  (command "CIRCLE" (list 850 (+ *FRAME-Y* 550)) 60)
  (command "TEXT" (list 830 (+ *FRAME-Y* 540)) 25 0 "M")
  (command "TEXT" (list 930 (+ *FRAME-Y* 550)) 15 0 "M1")
  (command "TEXT" (list 930 (+ *FRAME-Y* 520)) 10 0 "5.5 kW")

  ;; Progress bar - 50%
  (command "COLOR" 8)
  (command "LINE"
    (list 300 (+ *FRAME-Y* 300))
    (list 1600 (+ *FRAME-Y* 300))
    (list 1600 (+ *FRAME-Y* 340))
    (list 300 (+ *FRAME-Y* 340))
    "C")
  (command "COLOR" 3)
  (command "LINE"
    (list 302 (+ *FRAME-Y* 302))
    (list 950 (+ *FRAME-Y* 302))
    (list 950 (+ *FRAME-Y* 338))
    (list 302 (+ *FRAME-Y* 338))
    "C")
  (command "COLOR" 7)
  (command "TEXT" (list 300 (+ *FRAME-Y* 260)) 10 0 "52% complete")

  (NARRATION "Each symbol is drawn in its own DWG file. The motor M1 gets its specifications from the CSV data.")
  (TIMECODE 5 50)

  ;; Frame 24: Complete!
  (NEW-FRAME 15)
  (command "COLOR" 3)
  (TITLE-TEXT "BATCH COMPLETE!" 900 35)

  ;; Results box
  (command "COLOR" 3)
  (command "LINE"
    (list 400 (+ *FRAME-Y* 400))
    (list 1500 (+ *FRAME-Y* 400))
    (list 1500 (+ *FRAME-Y* 700))
    (list 400 (+ *FRAME-Y* 700))
    "C")

  (command "COLOR" 7)
  (command "TEXT" (list 500 (+ *FRAME-Y* 650)) 18 0 "Processed:  23 components")
  (command "COLOR" 3)
  (command "TEXT" (list 500 (+ *FRAME-Y* 600)) 18 0 "Generated:  23 DWG files")
  (command "COLOR" 9)
  (command "TEXT" (list 500 (+ *FRAME-Y* 550)) 18 0 "Time:       2 minutes 34 seconds")

  (command "COLOR" 2)
  (command "TEXT" (list 500 (+ *FRAME-Y* 470)) 15 0 "Manual time would be: 5+ hours")
  (command "COLOR" 3)
  (command "TEXT" (list 500 (+ *FRAME-Y* 430)) 15 0 "Time saved: 97%!")

  (NARRATION "23 drawings in under 3 minutes. What would have taken an engineer all day is now done before coffee break.")
  (TIMECODE 6 5)

  ;; Frame 25: The output files
  (NEW-FRAME 20)
  (command "COLOR" 7)
  (TITLE-TEXT "Generated Files" 950 25)

  ;; DOS directory listing style
  (command "COLOR" 250)
  (command "LINE"
    (list 300 (+ *FRAME-Y* 300))
    (list 1600 (+ *FRAME-Y* 300))
    (list 1600 (+ *FRAME-Y* 800))
    (list 300 (+ *FRAME-Y* 800))
    "C")

  (command "COLOR" 3)
  (command "TEXT" (list 350 (+ *FRAME-Y* 760)) 10 0 "C:\\ACAD\\PROJEKTE>dir *.dwg")

  (command "COLOR" 7)
  (command "TEXT" (list 350 (+ *FRAME-Y* 720)) 9 0 "K1       DWG    12,543  12-15-91  2:32p")
  (command "TEXT" (list 350 (+ *FRAME-Y* 695)) 9 0 "K2       DWG    12,298  12-15-91  2:32p")
  (command "TEXT" (list 350 (+ *FRAME-Y* 670)) 9 0 "K3       DWG    12,876  12-15-91  2:32p")
  (command "TEXT" (list 350 (+ *FRAME-Y* 645)) 9 0 "K4       DWG    12,102  12-15-91  2:33p")
  (command "TEXT" (list 350 (+ *FRAME-Y* 620)) 9 0 "K5       DWG     8,234  12-15-91  2:33p")
  (command "TEXT" (list 350 (+ *FRAME-Y* 595)) 9 0 "S1       DWG     5,432  12-15-91  2:33p")
  (command "TEXT" (list 350 (+ *FRAME-Y* 570)) 9 0 "S2       DWG     4,987  12-15-91  2:33p")
  (command "TEXT" (list 350 (+ *FRAME-Y* 545)) 9 0 "M1       DWG    15,678  12-15-91  2:34p")
  (command "TEXT" (list 350 (+ *FRAME-Y* 520)) 9 0 "M2       DWG    14,234  12-15-91  2:34p")
  (command "COLOR" 8)
  (command "TEXT" (list 350 (+ *FRAME-Y* 490)) 9 0 "...more files...")

  (command "COLOR" 7)
  (command "TEXT" (list 350 (+ *FRAME-Y* 440)) 9 0 "      23 file(s)    245,678 bytes")

  (NARRATION "Each component has its own DWG file. The files are ready to open in AutoCAD or send to the plotter.")
  (TIMECODE 6 25)

  ;; Frame 26: Plotting
  (NEW-FRAME 15)
  (command "COLOR" 7)
  (TITLE-TEXT "Sending to the Plotter" 950 25)

  ;; HP Plotter drawing
  (command "COLOR" 8)
  (command "LINE"
    (list 600 (+ *FRAME-Y* 350))
    (list 1300 (+ *FRAME-Y* 350))
    (list 1300 (+ *FRAME-Y* 650))
    (list 600 (+ *FRAME-Y* 650))
    "C")

  (command "COLOR" 7)
  (command "TEXT" (list 650 (+ *FRAME-Y* 600)) 20 0 "HP DesignJet")

  ;; Paper coming out
  (command "COLOR" 7)
  (command "LINE"
    (list 700 (+ *FRAME-Y* 350))
    (list 1200 (+ *FRAME-Y* 350))
    (list 1200 (+ *FRAME-Y* 250))
    (list 700 (+ *FRAME-Y* 250))
    "C")

  ;; Drawing on paper
  (command "COLOR" 9)
  (command "LINE"
    (list 800 (+ *FRAME-Y* 270))
    (list 880 (+ *FRAME-Y* 270))
    (list 880 (+ *FRAME-Y* 330))
    (list 800 (+ *FRAME-Y* 330))
    "C")
  (command "TEXT" (list 920 (+ *FRAME-Y* 300)) 10 0 "K1")

  (NARRATION "The HP plotter prints each drawing on paper. A3, A2, even A0 for large schematics. The physical output.")
  (TIMECODE 6 40)
)

;;; ============================================
;;; SCENE 7: THE LEGACY (7:00 - 8:30)
;;; ============================================

(defun SCENE-7-LEGACY ()
  (princ "\n=== SCENE 7: The Legacy ===\n")

  ;; Frame 27: Impact
  (NEW-FRAME 20)
  (command "COLOR" 3)
  (TITLE-TEXT "The Impact" 900 30)

  (command "COLOR" 7)
  (command "TEXT" (list 300 (+ *FRAME-Y* 700)) 15 0 "What Schmidt & Weber achieved:")

  (command "COLOR" 9)
  (command "TEXT" (list 350 (+ *FRAME-Y* 640)) 12 0 "• 97% reduction in drawing time")
  (command "TEXT" (list 350 (+ *FRAME-Y* 600)) 12 0 "• Consistent, error-free symbols")
  (command "TEXT" (list 350 (+ *FRAME-Y* 560)) 12 0 "• Data-driven: change CSV, regenerate all")
  (command "TEXT" (list 350 (+ *FRAME-Y* 520)) 12 0 "• Reusable code for future projects")
  (command "TEXT" (list 350 (+ *FRAME-Y* 480)) 12 0 "• Competitive advantage in bidding")

  (NARRATION "This automation gave the firm a massive competitive advantage. They could deliver faster and cheaper.")
  (TIMECODE 7 0)

  ;; Frame 28: Spread of the idea
  (NEW-FRAME 20)
  (command "COLOR" 7)
  (TITLE-TEXT "The Spread of Automation" 950 25)

  (command "COLOR" 9)
  (command "TEXT" (list 200 (+ *FRAME-Y* 700)) 12 0 "Soon, engineering firms across Germany adopted similar systems:")

  ;; Map-like representation
  (command "COLOR" 8)
  (command "CIRCLE" (list 960 (+ *FRAME-Y* 500)) 200)

  (command "COLOR" 3)
  (command "CIRCLE" (list 900 (+ *FRAME-Y* 550)) 10)
  (command "TEXT" (list 920 (+ *FRAME-Y* 550)) 8 0 "München")

  (command "CIRCLE" (list 850 (+ *FRAME-Y* 620)) 8)
  (command "TEXT" (list 870 (+ *FRAME-Y* 620)) 8 0 "Stuttgart")

  (command "CIRCLE" (list 1000 (+ *FRAME-Y* 650)) 8)
  (command "TEXT" (list 1020 (+ *FRAME-Y* 650)) 8 0 "Frankfurt")

  (command "CIRCLE" (list 1050 (+ *FRAME-Y* 550)) 8)
  (command "TEXT" (list 1070 (+ *FRAME-Y* 550)) 8 0 "Berlin")

  (command "CIRCLE" (list 900 (+ *FRAME-Y* 450)) 8)
  (command "TEXT" (list 920 (+ *FRAME-Y* 450)) 8 0 "Hamburg")

  (NARRATION "The idea spread. AutoLISP became the standard tool for CAD automation throughout the industry.")
  (TIMECODE 7 20)

  ;; Frame 29: Evolution
  (NEW-FRAME 20)
  (command "COLOR" 7)
  (TITLE-TEXT "Evolution of AutoCAD" 950 25)

  ;; Timeline
  (command "COLOR" 8)
  (command "LINE"
    (list 200 (+ *FRAME-Y* 450))
    (list 1700 (+ *FRAME-Y* 450))
    "")

  (command "COLOR" 3)
  (command "TEXT" (list 250 (+ *FRAME-Y* 500)) 10 0 "1986")
  (command "TEXT" (list 250 (+ *FRAME-Y* 420)) 8 0 "AutoLISP")
  (command "TEXT" (list 250 (+ *FRAME-Y* 400)) 8 0 "introduced")

  (command "TEXT" (list 500 (+ *FRAME-Y* 500)) 10 0 "1991")
  (command "COLOR" 2)
  (command "TEXT" (list 500 (+ *FRAME-Y* 420)) 8 0 "Our Story")

  (command "COLOR" 7)
  (command "TEXT" (list 750 (+ *FRAME-Y* 500)) 10 0 "1997")
  (command "TEXT" (list 750 (+ *FRAME-Y* 420)) 8 0 "Visual LISP")

  (command "TEXT" (list 1000 (+ *FRAME-Y* 500)) 10 0 "2000s")
  (command "TEXT" (list 1000 (+ *FRAME-Y* 420)) 8 0 ".NET API")

  (command "TEXT" (list 1300 (+ *FRAME-Y* 500)) 10 0 "2024")
  (command "COLOR" 3)
  (command "TEXT" (list 1300 (+ *FRAME-Y* 420)) 8 0 "rust-autolisp")

  (NARRATION "AutoLISP evolved over decades. Modern AutoCAD has new APIs, but the original code still runs!")
  (TIMECODE 7 40)

  ;; Frame 30: The recreation
  (NEW-FRAME 20)
  (command "COLOR" 3)
  (TITLE-TEXT "rust-autolisp: A Modern Recreation" 950 25)

  (command "COLOR" 7)
  (command "TEXT" (list 300 (+ *FRAME-Y* 700)) 14 0 "In 2024, we recreated this 1991 system in Rust:")

  (command "COLOR" 9)
  (command "TEXT" (list 350 (+ *FRAME-Y* 640)) 12 0 "• Full AutoLISP interpreter")
  (command "TEXT" (list 350 (+ *FRAME-Y* 600)) 12 0 "• Runs the original .LSP files unchanged")
  (command "TEXT" (list 350 (+ *FRAME-Y* 560)) 12 0 "• Outputs SVG instead of DWG")
  (command "TEXT" (list 350 (+ *FRAME-Y* 520)) 12 0 "• Educational tool to understand the era")

  (command "COLOR" 3)
  (command "TEXT" (list 300 (+ *FRAME-Y* 440)) 14 0 "The .LSP files in this project are 100% authentic")
  (command "TEXT" (list 300 (+ *FRAME-Y* 400)) 14 0 "They would run on real AutoCAD Release 10!")

  (NARRATION "rust-autolisp lets us experience this 1991 workflow today. The same code, running 33 years later.")
  (TIMECODE 8 0)
)

;;; ============================================
;;; SCENE 8: CONCLUSION (8:30 - 10:00)
;;; ============================================

(defun SCENE-8-CONCLUSION ()
  (princ "\n=== SCENE 8: Conclusion ===\n")

  ;; Frame 31: Lessons learned
  (NEW-FRAME 20)
  (command "COLOR" 7)
  (TITLE-TEXT "Lessons from 1991" 900 30)

  (command "COLOR" 3)
  (command "TEXT" (list 300 (+ *FRAME-Y* 700)) 14 0 "1. Automation pays off")
  (command "COLOR" 9)
  (command "TEXT" (list 350 (+ *FRAME-Y* 660)) 10 0 "Even with limited tools, creative solutions save time")

  (command "COLOR" 3)
  (command "TEXT" (list 300 (+ *FRAME-Y* 600)) 14 0 "2. Modular design works")
  (command "COLOR" 9)
  (command "TEXT" (list 350 (+ *FRAME-Y* 560)) 10 0 "CSVREAD + EBLOCKS + SCHALT = complete system")

  (command "COLOR" 3)
  (command "TEXT" (list 300 (+ *FRAME-Y* 500)) 14 0 "3. Data-driven is powerful")
  (command "COLOR" 9)
  (command "TEXT" (list 350 (+ *FRAME-Y* 460)) 10 0 "Change the CSV, regenerate everything")

  (command "COLOR" 3)
  (command "TEXT" (list 300 (+ *FRAME-Y* 400)) 14 0 "4. Good code lasts")
  (command "COLOR" 9)
  (command "TEXT" (list 350 (+ *FRAME-Y* 360)) 10 0 "These .LSP files still work after 33 years")

  (NARRATION "The lessons from 1991 still apply today. Automation, modularity, data-driven design, and clean code.")
  (TIMECODE 8 30)

  ;; Frame 32: Thank you
  (NEW-FRAME 20)
  (command "COLOR" 3)
  (TITLE-TEXT "Thank You" 700 50)

  (command "COLOR" 7)
  (TITLE-TEXT "for watching" 600 20)

  (command "COLOR" 9)
  (TITLE-TEXT "The AutoLISP Story" 500 15)
  (TITLE-TEXT "Automation in the Age of DOS" 470 15)

  (command "COLOR" 8)
  (TITLE-TEXT "A rust-autolisp Documentary" 380 12)

  (NARRATION "Thank you for watching The AutoLISP Story. The code that powered 1991 engineering lives on.")
  (TIMECODE 9 0)

  ;; Frame 33: Credits
  (NEW-FRAME 30)
  (command "COLOR" 7)
  (TITLE-TEXT "CREDITS" 900 25)

  (command "COLOR" 9)
  (command "TEXT" (list 700 (+ *FRAME-Y* 750)) 12 0 "rust-autolisp")
  (command "COLOR" 7)
  (command "TEXT" (list 700 (+ *FRAME-Y* 720)) 10 0 "AutoLISP Interpreter in Rust")

  (command "COLOR" 9)
  (command "TEXT" (list 700 (+ *FRAME-Y* 650)) 12 0 "Historical Inspiration")
  (command "COLOR" 7)
  (command "TEXT" (list 700 (+ *FRAME-Y* 620)) 10 0 "German Electrical Engineering Firms, 1991")

  (command "COLOR" 9)
  (command "TEXT" (list 700 (+ *FRAME-Y* 550)) 12 0 "Technologies Featured")
  (command "COLOR" 7)
  (command "TEXT" (list 700 (+ *FRAME-Y* 520)) 10 0 "AutoCAD Release 10, AutoLISP, DOS 5.0")
  (command "TEXT" (list 700 (+ *FRAME-Y* 490)) 10 0 "dBase III, HP DesignJet Plotters")

  (command "COLOR" 9)
  (command "TEXT" (list 700 (+ *FRAME-Y* 420)) 12 0 "Electrical Standards")
  (command "COLOR" 7)
  (command "TEXT" (list 700 (+ *FRAME-Y* 390)) 10 0 "DIN EN 60617 - Graphical Symbols")

  (command "COLOR" 8)
  (command "TEXT" (list 700 (+ *FRAME-Y* 300)) 10 0 "Created with rust-autolisp")
  (command "TEXT" (list 700 (+ *FRAME-Y* 270)) 10 0 "2024")

  (NARRATION "")
  (TIMECODE 9 30)

  ;; Frame 34: Final frame - Logo
  (NEW-FRAME 30)
  (command "COLOR" 3)
  (TITLE-TEXT "rust-autolisp" 650 60)

  (command "COLOR" 9)
  (TITLE-TEXT "Preserving the automation heritage" 550 18)
  (TITLE-TEXT "of the DOS era" 510 18)

  ;; Decorative brackets
  (command "COLOR" 7)
  (command "TEXT" (list 600 (+ *FRAME-Y* 700)) 80 0 "(")
  (command "TEXT" (list 1250 (+ *FRAME-Y* 700)) 80 0 ")")

  (command "COLOR" 8)
  (TITLE-TEXT "github.com/rust-autolisp" 350 12)

  (NARRATION "Visit the rust-autolisp project to explore the code and run it yourself.")
  (TIMECODE 10 0)
)

;;; ============================================
;;; MAIN ENTRY POINT
;;; ============================================

(defun C:VIDEO ()
  "Generate all video frames"
  (princ "\n")
  (princ "============================================\n")
  (princ "  THE AUTOLISP STORY - Video Frame Generator\n")
  (princ "  10-minute documentary\n")
  (princ "============================================\n")
  (princ "\n")

  ;; Reset frame counter
  (setq *FRAME-NUM* 0)
  (setq *FRAME-Y* 0)

  ;; Generate all scenes
  (SCENE-1-TITLE)
  (SCENE-2-PROBLEM)
  (SCENE-3-AUTOLISP)
  (SCENE-4-CSV)
  (SCENE-5-SYMBOLS)
  (SCENE-6-BATCH)
  (SCENE-7-LEGACY)
  (SCENE-8-CONCLUSION)

  (princ "\n")
  (princ "============================================\n")
  (princ (strcat "  Total frames generated: " (itoa *FRAME-NUM*) "\n"))
  (princ "  Ready for video compilation!\n")
  (princ "============================================\n")

  (princ)
)

;;; Auto-run when loaded
(C:VIDEO)