;;; STERDRE.LSP - Stern-Dreieck-Anlasser Visualisierung
;;; Elektrotechnik Planungsbuero Trahe GmbH
;;; Unterneukirchen, Dezember 1991
;;;
;;; Erzeugt einen animierten (Multi-Frame) Schaltplan fuer
;;; die klassische Stern-Dreieck-Anlaufschaltung mit:
;;; - Stromlaufplan
;;; - 3D-Ansicht der Komponenten
;;; - Zustandsdiagramm
;;;
;;; Die wichtigste Motoranlaufschaltung der 90er Jahre!
;;;

;;; ============================================
;;; KONSTANTEN
;;; ============================================

(setq *SD-SCALE* 1.0)
(setq *SD-TXTHGT* 3.0)

;;; Farben nach DIN
(setq *COL-L1* 1)    ; Rot
(setq *COL-L2* 2)    ; Gelb
(setq *COL-L3* 4)    ; Blau
(setq *COL-N* 9)     ; Hellblau
(setq *COL-PE* 3)    ; Gruen
(setq *COL-STEU* 7)  ; Weiss (Steuerkreis)

;;; ============================================
;;; SYMBOLE FUER STROMLAUFPLAN
;;; ============================================

;;; Schuetz-Spule mit Bezeichnung
(defun DRAW-SPULE (pt name aux / x y)
  (setq x (car pt))
  (setq y (cadr pt))

  ;; Rechteck
  (command "LINE"
    (list x y)
    (list (+ x 30) y)
    (list (+ x 30) (+ y 40))
    (list x (+ y 40))
    "C")

  ;; Diagonale (Spulensymbol)
  (command "LINE"
    (list x y)
    (list (+ x 30) (+ y 40))
    "")

  ;; Bezeichnung
  (command "TEXT"
    (list (+ x 35) (+ y 15))
    *SD-TXTHGT*
    0
    name)

  ;; Hilfskontakt-Hinweis
  (if aux
    (command "TEXT"
      (list (+ x 35) (+ y 5))
      (* *SD-TXTHGT* 0.7)
      0
      aux)
  )

  ;; Anschlusspunkte
  (list
    (list (+ x 15) y)           ; A2 unten
    (list (+ x 15) (+ y 40))    ; A1 oben
  )
)

;;; Schliesser-Kontakt (NO)
(defun DRAW-SCHLIESSER (pt name / x y)
  (setq x (car pt))
  (setq y (cadr pt))

  ;; Anschlusspunkte
  (command "CIRCLE" (list x y) 2)
  (command "CIRCLE" (list (+ x 30) y) 2)

  ;; Kontaktbruecke (offen - schraeg)
  (command "LINE"
    (list (+ x 2) y)
    (list (+ x 25) (+ y 10))
    "")

  ;; Bezeichnung
  (command "TEXT"
    (list (+ x 5) (+ y 15))
    (* *SD-TXTHGT* 0.8)
    0
    name)
)

;;; Oeffner-Kontakt (NC)
(defun DRAW-OEFFNER (pt name / x y)
  (setq x (car pt))
  (setq y (cadr pt))

  ;; Anschlusspunkte
  (command "CIRCLE" (list x y) 2)
  (command "CIRCLE" (list (+ x 30) y) 2)

  ;; Kontaktbruecke (geschlossen - horizontal mit Strich)
  (command "LINE"
    (list (+ x 2) y)
    (list (+ x 28) y)
    "")
  ;; Oeffner-Markierung
  (command "LINE"
    (list (+ x 20) (- y 5))
    (list (+ x 20) (+ y 5))
    "")

  ;; Bezeichnung
  (command "TEXT"
    (list (+ x 5) (+ y 10))
    (* *SD-TXTHGT* 0.8)
    0
    name)
)

;;; Hauptkontakt (Leistung)
(defun DRAW-HAUPTKONTAKT (pt name / x y)
  (setq x (car pt))
  (setq y (cadr pt))

  ;; Dickere Punkte (Leistungskontakt)
  (command "DONUT" 0 4 (list x y) "")
  (command "DONUT" 0 4 (list (+ x 30) y) "")

  ;; Kontaktbruecke
  (command "LINE"
    (list (+ x 4) y)
    (list (+ x 22) (+ y 8))
    "")

  ;; Bezeichnung klein
  (command "TEXT"
    (list (+ x 5) (+ y 12))
    (* *SD-TXTHGT* 0.6)
    0
    name)
)

;;; Thermisches Ueberlastrelais
(defun DRAW-THERM (pt name / x y)
  (setq x (car pt))
  (setq y (cadr pt))

  ;; Gehaeuse
  (command "LINE"
    (list x y)
    (list (+ x 40) y)
    (list (+ x 40) (+ y 30))
    (list x (+ y 30))
    "C")

  ;; Bimetall-Symbol (Zickzack)
  (command "LINE"
    (list (+ x 5) (+ y 5))
    (list (+ x 12) (+ y 25))
    (list (+ x 19) (+ y 5))
    (list (+ x 26) (+ y 25))
    (list (+ x 33) (+ y 5))
    "")

  ;; Bezeichnung
  (command "TEXT"
    (list (+ x 45) (+ y 10))
    *SD-TXTHGT*
    0
    name)
)

;;; Motor-Symbol (Drehstrom)
(defun DRAW-MOTOR-SYM (pt name kw / x y r)
  (setq x (car pt))
  (setq y (cadr pt))
  (setq r 30)

  ;; Kreis
  (command "CIRCLE" (list x y) r)

  ;; M in der Mitte
  (command "TEXT"
    (list (- x 8) (- y 5))
    12
    0
    "M")

  ;; 3~ oben
  (command "TEXT"
    (list (- x 10) (+ y 10))
    8
    0
    "3~")

  ;; Anschluesse (U1, V1, W1)
  (command "LINE"
    (list (- x 15) (+ y r))
    (list (- x 15) (+ y r 20))
    "")
  (command "LINE"
    (list x (+ y r))
    (list x (+ y r 20))
    "")
  (command "LINE"
    (list (+ x 15) (+ y r))
    (list (+ x 15) (+ y r 20))
    "")

  ;; Bezeichnung
  (command "TEXT"
    (list (+ x 40) y)
    *SD-TXTHGT*
    0
    name)
  (command "TEXT"
    (list (+ x 40) (- y 10))
    (* *SD-TXTHGT* 0.8)
    0
    (strcat (rtos kw 2 1) " kW"))
)

;;; ============================================
;;; STERN-DREIECK STROMLAUFPLAN
;;; ============================================

(defun DRAW-SD-STROMLAUF (pt / x y)
  (setq x (car pt))
  (setq y (cadr pt))

  (princ "\n  Zeichne Stromlaufplan...")

  ;; Titel
  (command "COLOR" 7)
  (command "TEXT" (list x (+ y 350)) 8 0 "STERN-DREIECK-ANLAUFSCHALTUNG")
  (command "TEXT" (list x (+ y 335)) 5 0 "nach DIN EN 60947")

  ;; ========== HAUPTSTROMKREIS ==========

  (command "COLOR" 7)
  (command "TEXT" (list x (+ y 310)) 4 0 "HAUPTSTROMKREIS")

  ;; Netzanschluss L1, L2, L3
  (command "COLOR" *COL-L1*)
  (command "LINE" (list (+ x 50) (+ y 300)) (list (+ x 50) (+ y 280)) "")
  (command "TEXT" (list (+ x 45) (+ y 305)) 4 0 "L1")

  (command "COLOR" *COL-L2*)
  (command "LINE" (list (+ x 100) (+ y 300)) (list (+ x 100) (+ y 280)) "")
  (command "TEXT" (list (+ x 95) (+ y 305)) 4 0 "L2")

  (command "COLOR" *COL-L3*)
  (command "LINE" (list (+ x 150) (+ y 300)) (list (+ x 150) (+ y 280)) "")
  (command "TEXT" (list (+ x 145) (+ y 305)) 4 0 "L3")

  ;; Sicherungen F1, F2, F3
  (command "COLOR" 7)
  (DRAW-SICHERG (list (+ x 40) (+ y 250)) 1.0 0.0)
  (command "TEXT" (list (+ x 65) (+ y 255)) 3 0 "F1")
  (DRAW-SICHERG (list (+ x 90) (+ y 250)) 1.0 0.0)
  (command "TEXT" (list (+ x 115) (+ y 255)) 3 0 "F2")
  (DRAW-SICHERG (list (+ x 140) (+ y 250)) 1.0 0.0)
  (command "TEXT" (list (+ x 165) (+ y 255)) 3 0 "F3")

  ;; Netzschuetz K1 (Hauptkontakte)
  (command "COLOR" 7)
  (DRAW-HAUPTKONTAKT (list (+ x 35) (+ y 210)) "K1")
  (DRAW-HAUPTKONTAKT (list (+ x 85) (+ y 210)) "K1")
  (DRAW-HAUPTKONTAKT (list (+ x 135) (+ y 210)) "K1")

  ;; Thermisches Ueberlastrelais
  (command "COLOR" 7)
  (DRAW-THERM (list (+ x 30) (+ y 160)) "F4")

  ;; Verbindung zum Motor (oben: U1, V1, W1)
  (command "COLOR" *COL-L1*)
  (command "LINE" (list (+ x 50) (+ y 160)) (list (+ x 50) (+ y 100)) "")
  (command "COLOR" *COL-L2*)
  (command "LINE" (list (+ x 100) (+ y 160)) (list (+ x 100) (+ y 100)) "")
  (command "COLOR" *COL-L3*)
  (command "LINE" (list (+ x 150) (+ y 160)) (list (+ x 150) (+ y 100)) "")

  ;; Motor
  (command "COLOR" 7)
  (DRAW-MOTOR-SYM (list (+ x 100) (+ y 50)) "M1" 5.5)

  ;; Sternpunkt-Bruecke (K3)
  (command "COLOR" *COL-STEU*)
  (command "LINE" (list (+ x 50) (+ y 100)) (list (+ x 50) (+ y 80)) "")
  (command "LINE" (list (+ x 100) (+ y 100)) (list (+ x 100) (+ y 80)) "")
  (command "LINE" (list (+ x 150) (+ y 100)) (list (+ x 150) (+ y 80)) "")
  ;; Sternpunkt-Schuetz K3
  (DRAW-HAUPTKONTAKT (list (+ x 35) (+ y 60)) "K3")
  (DRAW-HAUPTKONTAKT (list (+ x 85) (+ y 60)) "K3")
  (DRAW-HAUPTKONTAKT (list (+ x 135) (+ y 60)) "K3")
  ;; Sternpunkt verbinden
  (command "LINE"
    (list (+ x 50) (+ y 30))
    (list (+ x 100) (+ y 30))
    (list (+ x 150) (+ y 30))
    "")
  (command "DONUT" 0 4 (list (+ x 100) (+ y 30)) "")

  ;; Dreieck-Schuetz K2
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 200) (+ y 150)) 4 0 "DREIECK:")
  (DRAW-HAUPTKONTAKT (list (+ x 200) (+ y 120)) "K2")
  (DRAW-HAUPTKONTAKT (list (+ x 200) (+ y 90)) "K2")
  (DRAW-HAUPTKONTAKT (list (+ x 200) (+ y 60)) "K2")

  ;; Dreieck-Verbindungen (U2-V1, V2-W1, W2-U1)
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 250) (+ y 125)) 2.5 0 "U2-V1")
  (command "TEXT" (list (+ x 250) (+ y 95)) 2.5 0 "V2-W1")
  (command "TEXT" (list (+ x 250) (+ y 65)) 2.5 0 "W2-U1")

  ;; ========== STEUERSTROMKREIS ==========

  (command "COLOR" 7)
  (command "TEXT" (list (+ x 300) (+ y 310)) 4 0 "STEUERSTROMKREIS")

  ;; Steuerspannung
  (command "COLOR" *COL-STEU*)
  (command "LINE"
    (list (+ x 320) (+ y 300))
    (list (+ x 320) (+ y 50))
    "")
  (command "TEXT" (list (+ x 310) (+ y 305)) 4 0 "L")

  (command "LINE"
    (list (+ x 500) (+ y 300))
    (list (+ x 500) (+ y 50))
    "")
  (command "TEXT" (list (+ x 495) (+ y 305)) 4 0 "N")

  ;; S1 - AUS-Taster (Oeffner)
  (command "COLOR" 1)  ; Rot
  (DRAW-OEFFNER (list (+ x 320) (+ y 280)) "S1")
  (command "TEXT" (list (+ x 355) (+ y 275)) 2.5 0 "AUS")

  ;; S2 - EIN-Taster (Schliesser)
  (command "COLOR" 3)  ; Gruen
  (DRAW-SCHLIESSER (list (+ x 320) (+ y 250)) "S2")
  (command "TEXT" (list (+ x 355) (+ y 245)) 2.5 0 "EIN")

  ;; Selbsthaltung K1
  (command "COLOR" 7)
  (DRAW-SCHLIESSER (list (+ x 360) (+ y 250)) "K1")

  ;; F4 Thermokontakt (Oeffner)
  (command "COLOR" 7)
  (DRAW-OEFFNER (list (+ x 320) (+ y 220)) "F4")

  ;; K1 Spule (Netzschuetz)
  (command "COLOR" 7)
  (DRAW-SPULE (list (+ x 320) (+ y 170)) "K1" "13-14")

  ;; Verriegelung K2-K3
  (command "COLOR" 7)
  (command "LINE"
    (list (+ x 350) (+ y 170))
    (list (+ x 400) (+ y 170))
    "")

  ;; K2 Zweig (Dreieck)
  (DRAW-OEFFNER (list (+ x 400) (+ y 150)) "K3")  ; Verriegelung
  (DRAW-SPULE (list (+ x 400) (+ y 100)) "K2" "")

  ;; K3 Zweig (Stern)
  (command "LINE"
    (list (+ x 430) (+ y 170))
    (list (+ x 450) (+ y 170))
    "")
  (DRAW-OEFFNER (list (+ x 450) (+ y 150)) "K2")  ; Verriegelung
  (DRAW-SCHLIESSER (list (+ x 450) (+ y 120)) "K1")  ; Nur wenn K1 an
  (DRAW-SPULE (list (+ x 450) (+ y 70)) "K3" "")

  ;; Zeitrelais T1 fuer Umschaltung
  (command "COLOR" 2)
  (command "TEXT" (list (+ x 350) (+ y 60)) 3 0 "Umschaltzeit:")
  (command "TEXT" (list (+ x 350) (+ y 50)) 3 0 "t = 3...5 s")

  ;; Legende
  (command "COLOR" 7)
  (command "TEXT" (list x (- y 10)) 3 0 "LEGENDE:")
  (command "TEXT" (list x (- y 25)) 2.5 0 "K1 = Netzschuetz")
  (command "TEXT" (list x (- y 35)) 2.5 0 "K2 = Dreieck-Schuetz")
  (command "TEXT" (list x (- y 45)) 2.5 0 "K3 = Stern-Schuetz")
  (command "TEXT" (list x (- y 55)) 2.5 0 "F1-F3 = Hauptsicherungen")
  (command "TEXT" (list x (- y 65)) 2.5 0 "F4 = Motorschutzrelais")
  (command "TEXT" (list x (- y 75)) 2.5 0 "S1 = AUS (rot)")
  (command "TEXT" (list x (- y 85)) 2.5 0 "S2 = EIN (gruen)")

  (command "TEXT" (list (+ x 200) (- y 10)) 3 0 "FUNKTIONSABLAUF:")
  (command "TEXT" (list (+ x 200) (- y 25)) 2.5 0 "1. S2 druecken -> K1 + K3 ein (Stern)")
  (command "TEXT" (list (+ x 200) (- y 35)) 2.5 0 "2. Motor laeuft im Stern an (I = 1/3)")
  (command "TEXT" (list (+ x 200) (- y 45)) 2.5 0 "3. Nach t Sekunden: K3 aus, K2 ein")
  (command "TEXT" (list (+ x 200) (- y 55)) 2.5 0 "4. Motor laeuft im Dreieck weiter")
  (command "TEXT" (list (+ x 200) (- y 65)) 2.5 0 "5. S1 druecken -> Alle Schuetze aus")
)

;;; ============================================
;;; ZUSTANDSDIAGRAMM
;;; ============================================

(defun DRAW-SD-ZUSTAND (pt / x y)
  (setq x (car pt))
  (setq y (cadr pt))

  (princ "\n  Zeichne Zustandsdiagramm...")

  ;; Titel
  (command "COLOR" 7)
  (command "TEXT" (list x (+ y 120)) 5 0 "ZUSTANDSDIAGRAMM")

  ;; Zeitachse
  (command "LINE"
    (list x y)
    (list (+ x 400) y)
    "")
  (command "TEXT" (list (+ x 390) (- y 10)) 3 0 "t")

  ;; K1 (Netzschuetz)
  (command "TEXT" (list (- x 30) (+ y 90)) 3 0 "K1")
  (command "COLOR" 3)
  (command "LINE"
    (list x (+ y 80))
    (list (+ x 50) (+ y 80))
    (list (+ x 50) (+ y 100))
    (list (+ x 350) (+ y 100))
    (list (+ x 350) (+ y 80))
    (list (+ x 400) (+ y 80))
    "")

  ;; K3 (Stern)
  (command "COLOR" 7)
  (command "TEXT" (list (- x 30) (+ y 60)) 3 0 "K3")
  (command "COLOR" 5)
  (command "LINE"
    (list x (+ y 50))
    (list (+ x 50) (+ y 50))
    (list (+ x 50) (+ y 70))
    (list (+ x 150) (+ y 70))
    (list (+ x 150) (+ y 50))
    (list (+ x 400) (+ y 50))
    "")

  ;; K2 (Dreieck)
  (command "COLOR" 7)
  (command "TEXT" (list (- x 30) (+ y 30)) 3 0 "K2")
  (command "COLOR" 1)
  (command "LINE"
    (list x (+ y 20))
    (list (+ x 170) (+ y 20))
    (list (+ x 170) (+ y 40))
    (list (+ x 350) (+ y 40))
    (list (+ x 350) (+ y 20))
    (list (+ x 400) (+ y 20))
    "")

  ;; Markierungen
  (command "COLOR" 7)
  (command "LINE" (list (+ x 50) y) (list (+ x 50) (+ y 110)) "")
  (command "TEXT" (list (+ x 45) (- y 10)) 2.5 0 "S2")

  (command "LINE" (list (+ x 150) y) (list (+ x 150) (+ y 110)) "")
  (command "TEXT" (list (+ x 145) (- y 10)) 2.5 0 "t")

  (command "LINE" (list (+ x 350) y) (list (+ x 350) (+ y 110)) "")
  (command "TEXT" (list (+ x 345) (- y 10)) 2.5 0 "S1")

  ;; Zeitangaben
  (command "TEXT" (list (+ x 85) (- y 25)) 2.5 0 "Stern")
  (command "TEXT" (list (+ x 230) (- y 25)) 2.5 0 "Dreieck")
)

;;; ============================================
;;; HAUPTFUNKTION
;;; ============================================

(defun C:STERDRE (/ pt)
  (princ "\n╔════════════════════════════════════════════╗")
  (princ "\n║   STERN-DREIECK-ANLAUFSCHALTUNG            ║")
  (princ "\n║   Die klassische Motoranlaufschaltung      ║")
  (princ "\n║   Schmidt & Weber GmbH 1991                ║")
  (princ "\n╚════════════════════════════════════════════╝")
  (princ "\n")

  (setq pt (getpoint "\nStartpunkt: "))
  (if (null pt) (setq pt '(0 0)))

  ;; Stromlaufplan zeichnen
  (DRAW-SD-STROMLAUF pt)

  ;; Zustandsdiagramm darunter
  (DRAW-SD-ZUSTAND (list (car pt) (- (cadr pt) 150)))

  (princ "\n")
  (princ "\n=== STERN-DREIECK-SCHALTUNG FERTIG ===")
  (princ "\n")
  (princ "\nDer Anlaufstrom wird auf 1/3 des Direktanlaufs reduziert!")
  (princ "\nTypische Umschaltzeit: 3-5 Sekunden")
  (princ)
)

(princ "\nSTERDRE.LSP geladen.")
(princ "\nBefehl: STERDRE - Zeichnet Stern-Dreieck-Anlaufschaltung")
(princ)
