;;; TEST.LSP - Testprogramm fuer rust-autolisp
;;; Demonstriert die Funktionalitaet des Interpreters
;;;

(princ "\n=== RUST-AUTOLISP TEST ===\n")

;; Test 1: Grundlegende Arithmetik
(princ "\n[1] Arithmetik-Test:\n")
(princ "    (+ 10 20 30) = ")
(princ (+ 10 20 30))

(princ "\n    (* 5 5) = ")
(princ (* 5 5))

(princ "\n    (/ 100 4) = ")
(princ (/ 100 4))

;; Test 2: Variablen
(princ "\n\n[2] Variablen-Test:\n")
(setq x 42)
(setq name "Schuetz K1")
(princ "    x = ")
(princ x)
(princ "\n    name = ")
(princ name)

;; Test 3: Funktionen
(princ "\n\n[3] Funktions-Test:\n")
(defun quadrat (n)
  (* n n)
)
(princ "    (quadrat 7) = ")
(princ (quadrat 7))

(defun celsius-zu-fahrenheit (c)
  (+ (* c 1.8) 32)
)
(princ "\n    20 Grad Celsius = ")
(princ (celsius-zu-fahrenheit 20))
(princ " Fahrenheit")

;; Test 4: Listen
(princ "\n\n[4] Listen-Test:\n")
(setq koordinaten '(100.0 200.0 0.0))
(princ "    Punkt: ")
(princ koordinaten)
(princ "\n    X = ")
(princ (car koordinaten))
(princ ", Y = ")
(princ (cadr koordinaten))

;; Test 5: String-Operationen
(princ "\n\n[5] String-Test:\n")
(setq bauteil (strcat "Siemens" " " "3RT1015"))
(princ "    Bauteil: ")
(princ bauteil)
(princ "\n    Laenge: ")
(princ (strlen bauteil))

;; Test 6: Bedingungen
(princ "\n\n[6] Bedingungs-Test:\n")
(setq spannung 230)
(princ "    Spannung: ")
(princ spannung)
(princ "V -> ")
(if (> spannung 100)
  (princ "GEFAEHRLICH!")
  (princ "OK")
)

;; Test 7: Schleife
(princ "\n\n[7] Schleifen-Test:\n")
(princ "    Zaehlen: ")
(setq i 1)
(repeat 5
  (princ i)
  (princ " ")
  (setq i (1+ i))
)

;; Test 8: AutoCAD-Befehle (simuliert)
(princ "\n\n[8] AutoCAD-Befehls-Test:\n")
(princ "    Zeichne Linie von (0,0) nach (100,100)\n")
(command "LINE" '(0 0) '(100 100) "")

(princ "    Zeichne Kreis bei (50,50) r=25\n")
(command "CIRCLE" '(50 50) 25)

;; Test 9: Geometrie-Funktionen
(princ "\n\n[9] Geometrie-Test:\n")
(setq p1 '(0.0 0.0))
(setq p2 '(100.0 100.0))
(princ "    Abstand von (0,0) zu (100,100) = ")
(princ (distance p1 p2))

(princ "\n    Winkel = ")
(princ (angtos (angle p1 p2) 0 2))
(princ " Grad")

;; Abschluss
(princ "\n\n=== TEST ABGESCHLOSSEN ===\n")
(princ)
