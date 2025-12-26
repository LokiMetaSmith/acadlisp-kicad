;;; EBLOCKS.LSP - Elektrische Symbole Block-Definitionen
;;; Elektrotechnik Planungsbuero Schmidt & Weber GmbH
;;; Muenchen, Februar 1991
;;; Fuer AutoCAD Release 10
;;;
;;; Definiert die Grundsymbole fuer Schaltplaene nach DIN
;;; Alle Masse in mm (Zeichnungseinheiten)
;;;

;;; Globale Einstellungen
(setq *E-SCALE* 1.0)      ; Skalierungsfaktor
(setq *E-LAYER* "SYMBOLE") ; Layer fuer Symbole
(setq *E-TXTHGT* 2.5)     ; Standard Texthoehe

;;; ============================================
;;; SCHUETZ - Leistungsschuetz (Contactor)
;;; DIN-Symbol: Spule mit Schaltkontakten
;;; ============================================
(defun C:SCHUETZ (/ pt)
  (setq pt (getpoint "\nEinfuegepunkt Schuetz: "))
  (if pt (DRAW-SCHUETZ pt 1.0 0.0))
  (princ)
)

(defun DRAW-SCHUETZ (pt scale rot / x y x1 y1 x2 y2)
  (setq x (car pt))
  (setq y (cadr pt))

  ;; Spulenkoerper (Rechteck)
  (command "LINE"
    (list x y)
    (list (+ x (* 10 scale)) y)
    (list (+ x (* 10 scale)) (+ y (* 20 scale)))
    (list x (+ y (* 20 scale)))
    "C")

  ;; Spulensymbol (Halbkreise innen)
  (command "ARC"
    (list (+ x (* 3 scale)) (+ y (* 5 scale)))
    (list (+ x (* 5 scale)) (+ y (* 7 scale)))
    (list (+ x (* 7 scale)) (+ y (* 5 scale))))

  (command "ARC"
    (list (+ x (* 3 scale)) (+ y (* 10 scale)))
    (list (+ x (* 5 scale)) (+ y (* 12 scale)))
    (list (+ x (* 7 scale)) (+ y (* 10 scale))))

  (command "ARC"
    (list (+ x (* 3 scale)) (+ y (* 15 scale)))
    (list (+ x (* 5 scale)) (+ y (* 17 scale)))
    (list (+ x (* 7 scale)) (+ y (* 15 scale))))

  ;; Anschlusspunkte A1/A2
  (command "LINE"
    (list (+ x (* 5 scale)) y)
    (list (+ x (* 5 scale)) (- y (* 3 scale)))
    "")

  (command "LINE"
    (list (+ x (* 5 scale)) (+ y (* 20 scale)))
    (list (+ x (* 5 scale)) (+ y (* 23 scale)))
    "")

  ;; Betaetigungslinie (gestrichelt zum Kontakt)
  (setvar "CELTYPE" "DASHED")
  (command "LINE"
    (list (+ x (* 10 scale)) (+ y (* 10 scale)))
    (list (+ x (* 20 scale)) (+ y (* 10 scale)))
    "")
  (setvar "CELTYPE" "BYLAYER")

  pt
)

;;; ============================================
;;; SCHALTER - Einfacher Schalter
;;; ============================================
(defun C:SCHALTER (/ pt)
  (setq pt (getpoint "\nEinfuegepunkt Schalter: "))
  (if pt (DRAW-SCHALTER pt 1.0 0.0 nil))
  (princ)
)

(defun DRAW-SCHALTER (pt scale rot closed / x y)
  (setq x (car pt))
  (setq y (cadr pt))

  ;; Anschlusspunkte (kleine Kreise)
  (command "CIRCLE"
    (list x y)
    (* 1.0 scale))

  (command "CIRCLE"
    (list (+ x (* 15 scale)) y)
    (* 1.0 scale))

  ;; Schaltbruecke
  (if closed
    ;; Geschlossen - horizontal
    (command "LINE"
      (list (+ x (* 1 scale)) y)
      (list (+ x (* 14 scale)) y)
      "")
    ;; Offen - schraeg nach oben
    (command "LINE"
      (list (+ x (* 1 scale)) y)
      (list (+ x (* 12 scale)) (+ y (* 5 scale)))
      "")
  )

  pt
)

;;; ============================================
;;; KREUZSCH - Kreuzschalter (4-Wege)
;;; Fuer Flurbeleuchtung mit 3+ Schaltstellen
;;; ============================================
(defun C:KREUZSCH (/ pt)
  (setq pt (getpoint "\nEinfuegepunkt Kreuzschalter: "))
  (if pt (DRAW-KREUZSCH pt 1.0 0.0))
  (princ)
)

(defun DRAW-KREUZSCH (pt scale rot / x y)
  (setq x (car pt))
  (setq y (cadr pt))

  ;; Gehaeuse (Quadrat)
  (command "LINE"
    (list x y)
    (list (+ x (* 20 scale)) y)
    (list (+ x (* 20 scale)) (+ y (* 20 scale)))
    (list x (+ y (* 20 scale)))
    "C")

  ;; Eingaenge links
  (command "CIRCLE"
    (list x (+ y (* 5 scale)))
    (* 1.0 scale))
  (command "CIRCLE"
    (list x (+ y (* 15 scale)))
    (* 1.0 scale))

  ;; Ausgaenge rechts
  (command "CIRCLE"
    (list (+ x (* 20 scale)) (+ y (* 5 scale)))
    (* 1.0 scale))
  (command "CIRCLE"
    (list (+ x (* 20 scale)) (+ y (* 15 scale)))
    (* 1.0 scale))

  ;; Kreuzverbindungen (das "Kreuz")
  (command "LINE"
    (list (+ x (* 1 scale)) (+ y (* 5 scale)))
    (list (+ x (* 19 scale)) (+ y (* 15 scale)))
    "")
  (command "LINE"
    (list (+ x (* 1 scale)) (+ y (* 15 scale)))
    (list (+ x (* 19 scale)) (+ y (* 5 scale)))
    "")

  ;; Umschalter-Bruecke (beweglich - gestrichelt)
  (setvar "CELTYPE" "DASHED")
  (command "LINE"
    (list (+ x (* 8 scale)) (+ y (* 3 scale)))
    (list (+ x (* 12 scale)) (+ y (* 17 scale)))
    "")
  (setvar "CELTYPE" "BYLAYER")

  pt
)

;;; ============================================
;;; WECHSELS - Wechselschalter (3-Wege)
;;; ============================================
(defun C:WECHSELS (/ pt)
  (setq pt (getpoint "\nEinfuegepunkt Wechselschalter: "))
  (if pt (DRAW-WECHSELS pt 1.0 0.0))
  (princ)
)

(defun DRAW-WECHSELS (pt scale rot / x y)
  (setq x (car pt))
  (setq y (cadr pt))

  ;; Eingang
  (command "CIRCLE"
    (list x (+ y (* 10 scale)))
    (* 1.0 scale))

  ;; Zwei Ausgaenge
  (command "CIRCLE"
    (list (+ x (* 15 scale)) (+ y (* 5 scale)))
    (* 1.0 scale))
  (command "CIRCLE"
    (list (+ x (* 15 scale)) (+ y (* 15 scale)))
    (* 1.0 scale))

  ;; Schaltbruecke zum oberen Ausgang
  (command "LINE"
    (list (+ x (* 1 scale)) (+ y (* 10 scale)))
    (list (+ x (* 13 scale)) (+ y (* 5 scale)))
    "")

  ;; Pfeil fuer Umschaltmoeglichkeit
  (command "LINE"
    (list (+ x (* 7 scale)) (+ y (* 7 scale)))
    (list (+ x (* 9 scale)) (+ y (* 12 scale)))
    "")

  pt
)

;;; ============================================
;;; SICHERG - Sicherung
;;; ============================================
(defun C:SICHERG (/ pt)
  (setq pt (getpoint "\nEinfuegepunkt Sicherung: "))
  (if pt (DRAW-SICHERG pt 1.0 0.0))
  (princ)
)

(defun DRAW-SICHERG (pt scale rot / x y)
  (setq x (car pt))
  (setq y (cadr pt))

  ;; Rechteck (Sicherungskoerper)
  (command "LINE"
    (list x y)
    (list (+ x (* 20 scale)) y)
    (list (+ x (* 20 scale)) (+ y (* 5 scale)))
    (list x (+ y (* 5 scale)))
    "C")

  ;; Schmelzdraht (Linie durch Mitte)
  (command "LINE"
    (list x (+ y (* 2.5 scale)))
    (list (+ x (* 20 scale)) (+ y (* 2.5 scale)))
    "")

  ;; Anschluesse
  (command "LINE"
    (list (- x (* 3 scale)) (+ y (* 2.5 scale)))
    (list x (+ y (* 2.5 scale)))
    "")
  (command "LINE"
    (list (+ x (* 20 scale)) (+ y (* 2.5 scale)))
    (list (+ x (* 23 scale)) (+ y (* 2.5 scale)))
    "")

  pt
)

;;; ============================================
;;; RELAIS - Relais/Hilfsschuetz
;;; ============================================
(defun C:RELAIS (/ pt)
  (setq pt (getpoint "\nEinfuegepunkt Relais: "))
  (if pt (DRAW-RELAIS pt 1.0 0.0))
  (princ)
)

(defun DRAW-RELAIS (pt scale rot / x y)
  (setq x (car pt))
  (setq y (cadr pt))

  ;; Spulenkoerper (schmaler als Schuetz)
  (command "LINE"
    (list x y)
    (list (+ x (* 8 scale)) y)
    (list (+ x (* 8 scale)) (+ y (* 15 scale)))
    (list x (+ y (* 15 scale)))
    "C")

  ;; K-Symbol in der Mitte
  (command "TEXT"
    (list (+ x (* 2 scale)) (+ y (* 6 scale)))
    (* 3 scale)
    0
    "K")

  ;; Anschluesse
  (command "LINE"
    (list (+ x (* 4 scale)) y)
    (list (+ x (* 4 scale)) (- y (* 3 scale)))
    "")
  (command "LINE"
    (list (+ x (* 4 scale)) (+ y (* 15 scale)))
    (list (+ x (* 4 scale)) (+ y (* 18 scale)))
    "")

  pt
)

;;; ============================================
;;; MOTOR - Drehstrommotor
;;; ============================================
(defun C:MOTOR (/ pt)
  (setq pt (getpoint "\nEinfuegepunkt Motor: "))
  (if pt (DRAW-MOTOR pt 1.0 0.0))
  (princ)
)

(defun DRAW-MOTOR (pt scale rot / x y r)
  (setq x (car pt))
  (setq y (cadr pt))
  (setq r (* 10 scale))

  ;; Motorkreis
  (command "CIRCLE"
    (list x y)
    r)

  ;; M-Symbol
  (command "TEXT"
    (list (- x (* 3 scale)) (- y (* 2 scale)))
    (* 5 scale)
    0
    "M")

  ;; Drehstrom-Kennzeichnung (3~)
  (command "TEXT"
    (list (- x (* 5 scale)) (+ y (* 4 scale)))
    (* 2.5 scale)
    0
    "3~")

  ;; Anschluesse oben (U, V, W)
  (command "LINE"
    (list (- x (* 5 scale)) (+ y r))
    (list (- x (* 5 scale)) (+ y r (* 5 scale)))
    "")
  (command "LINE"
    (list x (+ y r))
    (list x (+ y r (* 5 scale)))
    "")
  (command "LINE"
    (list (+ x (* 5 scale)) (+ y r))
    (list (+ x (* 5 scale)) (+ y r (* 5 scale)))
    "")

  pt
)

;;; ============================================
;;; KLEMME - Anschlussklemme
;;; ============================================
(defun DRAW-KLEMME (pt scale / x y)
  (setq x (car pt))
  (setq y (cadr pt))

  ;; Kleiner gefuellter Kreis
  (command "DONUT"
    0
    (* 1.5 scale)
    (list x y)
    "")

  pt
)

(princ "\nEBLOCKS.LSP geladen - Elektrosymbole bereit.")
(princ "\nBefehle: SCHUETZ, SCHALTER, KREUZSCH, WECHSELS, SICHERG, RELAIS, MOTOR")
(princ)
