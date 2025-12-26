;;; CABINET3.LSP - 3D Schaltschrank-Visualisierung
;;; Elektrotechnik Planungsbuero Schmidt & Weber GmbH
;;; Muenchen, Oktober 1991
;;;
;;; Erzeugt beeindruckende 3D-Darstellungen von Schaltschraenken
;;; mit allen eingebauten Komponenten aus CSV-Daten.
;;;
;;; Fuer AutoCAD Release 10 mit AME (Advanced Modeling Extension)
;;;

;;; ============================================
;;; 3D GRUNDKOERPER
;;; ============================================

;;; Zeichnet einen 3D-Quader (Box)
(defun DRAW-3DBOX (pt width depth height / x y z)
  (setq x (car pt))
  (setq y (cadr pt))
  (setq z (if (caddr pt) (caddr pt) 0.0))

  ;; Bodenflaeche
  (command "3DFACE"
    (list x y z)
    (list (+ x width) y z)
    (list (+ x width) (+ y depth) z)
    (list x (+ y depth) z)
    "")

  ;; Deckflaeche
  (command "3DFACE"
    (list x y (+ z height))
    (list (+ x width) y (+ z height))
    (list (+ x width) (+ y depth) (+ z height))
    (list x (+ y depth) (+ z height))
    "")

  ;; Vorderseite
  (command "3DFACE"
    (list x y z)
    (list (+ x width) y z)
    (list (+ x width) y (+ z height))
    (list x y (+ z height))
    "")

  ;; Rueckseite
  (command "3DFACE"
    (list x (+ y depth) z)
    (list (+ x width) (+ y depth) z)
    (list (+ x width) (+ y depth) (+ z height))
    (list x (+ y depth) (+ z height))
    "")

  ;; Linke Seite
  (command "3DFACE"
    (list x y z)
    (list x (+ y depth) z)
    (list x (+ y depth) (+ z height))
    (list x y (+ z height))
    "")

  ;; Rechte Seite
  (command "3DFACE"
    (list (+ x width) y z)
    (list (+ x width) (+ y depth) z)
    (list (+ x width) (+ y depth) (+ z height))
    (list (+ x width) y (+ z height))
    "")
)

;;; Zeichnet einen 3D-Zylinder (vereinfacht als 8-Eck)
(defun DRAW-3DCYL (center radius height / x y z i ang pt1 pt2 pts)
  (setq x (car center))
  (setq y (cadr center))
  (setq z (if (caddr center) (caddr center) 0.0))
  (setq pts nil)

  ;; 8 Punkte fuer Approximation
  (setq i 0)
  (repeat 8
    (setq ang (* i (/ 3.14159 4.0)))
    (setq pts (append pts (list
      (list (+ x (* radius (cos ang)))
            (+ y (* radius (sin ang)))
            z))))
    (setq i (1+ i))
  )

  ;; Mantelflaechen
  (setq i 0)
  (repeat 8
    (setq pt1 (nth i pts))
    (setq pt2 (nth (rem (1+ i) 8) pts))
    (command "3DFACE"
      pt1
      pt2
      (list (car pt2) (cadr pt2) (+ z height))
      (list (car pt1) (cadr pt1) (+ z height))
      "")
    (setq i (1+ i))
  )
)

;;; ============================================
;;; SCHALTSCHRANK-GEHAEUSE
;;; ============================================

(defun DRAW-CABINET (pt width depth height / x y z)
  (setq x (car pt))
  (setq y (cadr pt))
  (setq z 0.0)

  (princ "\n  Zeichne Schaltschrank-Gehaeuse...")

  ;; Hauptgehaeuse (grau)
  (command "COLOR" 8)  ; Dunkelgrau
  (DRAW-3DBOX pt width depth height)

  ;; Montageplatten innen (hellgrau)
  (command "COLOR" 7)
  (DRAW-3DBOX
    (list (+ x 20) (+ y 20) 100)
    (- width 40) 3 (- height 200))

  ;; Tuer (Rahmen)
  (command "COLOR" 9)  ; Hellblau
  (command "3DFACE"
    (list x y 50)
    (list (+ x width) y 50)
    (list (+ x width) y (- height 50))
    (list x y (- height 50))
    "")

  ;; Tuergriff
  (command "COLOR" 1)  ; Rot
  (DRAW-3DBOX
    (list (- (+ x width) 80) (- y 5) (/ height 2))
    30 10 100)

  ;; Lueftungsgitter oben
  (command "COLOR" 8)
  (setq i 0)
  (repeat 10
    (command "LINE"
      (list (+ x 50 (* i 40)) y (- height 30))
      (list (+ x 50 (* i 40)) y (- height 10))
      "")
    (setq i (1+ i))
  )

  ;; Kabeleinlass unten
  (command "COLOR" 7)
  (command "CIRCLE"
    (list (+ x 100) (+ y (/ depth 2)) 20)
    30)
  (command "CIRCLE"
    (list (+ x 250) (+ y (/ depth 2)) 20)
    30)
  (command "CIRCLE"
    (list (+ x 400) (+ y (/ depth 2)) 20)
    30)
)

;;; ============================================
;;; 3D KOMPONENTEN
;;; ============================================

;;; Leistungsschuetz 3D
(defun DRAW-3DSCHUETZ (pt bezeich / x y z)
  (setq x (car pt))
  (setq y (cadr pt))
  (setq z (if (caddr pt) (caddr pt) 0.0))

  ;; Grundkoerper (schwarz)
  (command "COLOR" 250)
  (DRAW-3DBOX pt 45 35 55)

  ;; Spulenbereich oben (grau)
  (command "COLOR" 8)
  (DRAW-3DBOX (list x y (+ z 55)) 45 35 15)

  ;; Anschlussklemmen (silber)
  (command "COLOR" 7)
  (DRAW-3DBOX (list (+ x 5) (+ y 5) (+ z 70)) 8 8 10)
  (DRAW-3DBOX (list (+ x 18) (+ y 5) (+ z 70)) 8 8 10)
  (DRAW-3DBOX (list (+ x 31) (+ y 5) (+ z 70)) 8 8 10)

  ;; Hilfskontakte seitlich (orange)
  (command "COLOR" 30)
  (DRAW-3DBOX (list (+ x 45) (+ y 8) (+ z 20)) 10 20 30)

  ;; Beschriftung
  (command "COLOR" 7)
  (command "TEXT"
    (list (+ x 5) (- y 5) (+ z 30))
    3.0
    0
    bezeich)
)

;;; Motorschutzschalter 3D
(defun DRAW-3DMSS (pt bezeich / x y z)
  (setq x (car pt))
  (setq y (cadr pt))
  (setq z (if (caddr pt) (caddr pt) 0.0))

  ;; Gehaeuse (schwarz)
  (command "COLOR" 250)
  (DRAW-3DBOX pt 45 50 90)

  ;; Einstellrad vorne (rot)
  (command "COLOR" 1)
  (DRAW-3DCYL (list (+ x 22) y (+ z 60)) 10 5)

  ;; Skala
  (command "COLOR" 7)
  (command "ARC"
    (list (+ x 12) y (+ z 45))
    (list (+ x 22) y (+ z 50))
    (list (+ x 32) y (+ z 45)))

  ;; TEST-Taste (gelb)
  (command "COLOR" 2)
  (DRAW-3DBOX (list (+ x 5) (- y 5) (+ z 75)) 15 8 10)

  ;; RESET-Taste (blau)
  (command "COLOR" 5)
  (DRAW-3DBOX (list (+ x 25) (- y 5) (+ z 75)) 15 8 10)

  ;; Beschriftung
  (command "TEXT"
    (list (+ x 5) (- y 10) (+ z 30))
    3.0
    0
    bezeich)
)

;;; Sicherungsautomat 3D (Leitungsschutzschalter)
(defun DRAW-3DLS (pt bezeich ampere / x y z)
  (setq x (car pt))
  (setq y (cadr pt))
  (setq z (if (caddr pt) (caddr pt) 0.0))

  ;; Gehaeuse (schwarz, schmal)
  (command "COLOR" 250)
  (DRAW-3DBOX pt 18 65 85)

  ;; Kipphebel (blau bei EIN)
  (command "COLOR" 5)
  (DRAW-3DBOX (list (+ x 4) (- y 2) (+ z 50)) 10 8 25)

  ;; Fenster (gruen = OK)
  (command "COLOR" 3)
  (command "3DFACE"
    (list (+ x 5) y (+ z 35))
    (list (+ x 13) y (+ z 35))
    (list (+ x 13) y (+ z 45))
    (list (+ x 5) y (+ z 45))
    "")

  ;; Ampere-Wert
  (command "COLOR" 7)
  (command "TEXT"
    (list (+ x 2) (- y 5) (+ z 20))
    2.5
    0
    (strcat (itoa ampere) "A"))

  ;; Beschriftung
  (command "TEXT"
    (list (+ x 2) (- y 8) (+ z 5))
    2.0
    0
    bezeich)
)

;;; Hauptschalter 3D
(defun DRAW-3DHAUPT (pt / x y z)
  (setq x (car pt))
  (setq y (cadr pt))
  (setq z (if (caddr pt) (caddr pt) 0.0))

  ;; Grosses Gehaeuse (schwarz)
  (command "COLOR" 250)
  (DRAW-3DBOX pt 80 80 100)

  ;; Drehgriff (rot)
  (command "COLOR" 1)
  (DRAW-3DCYL (list (+ x 40) y (+ z 50)) 25 10)

  ;; Griff-Hebel
  (command "COLOR" 1)
  (DRAW-3DBOX (list (+ x 35) (- y 10) (+ z 55)) 10 20 5)

  ;; 0 / I Markierungen
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 20) (- y 15) (+ z 70)) 5 0 "0")
  (command "TEXT" (list (+ x 55) (- y 15) (+ z 70)) 5 0 "I")

  ;; Beschriftung
  (command "TEXT" (list (+ x 10) (- y 20) (+ z 10)) 4 0 "HAUPTSCHALTER")
)

;;; Klemmenleiste 3D
(defun DRAW-3DKLEMM (pt anzahl / x y z i)
  (setq x (car pt))
  (setq y (cadr pt))
  (setq z (if (caddr pt) (caddr pt) 0.0))

  ;; Tragschiene (Hutschiene)
  (command "COLOR" 7)
  (DRAW-3DBOX pt (* anzahl 10) 35 8)

  ;; Einzelne Klemmen
  (setq i 0)
  (repeat anzahl
    (command "COLOR" 8)
    (DRAW-3DBOX
      (list (+ x 2 (* i 10)) (+ y 5) (+ z 8))
      6 25 20)

    ;; Beschriftungsschild (weiss)
    (command "COLOR" 7)
    (command "3DFACE"
      (list (+ x 2 (* i 10)) y (+ z 15))
      (list (+ x 8 (* i 10)) y (+ z 15))
      (list (+ x 8 (* i 10)) y (+ z 25))
      (list (+ x 2 (* i 10)) y (+ z 25))
      "")

    ;; Nummer
    (command "TEXT"
      (list (+ x 3 (* i 10)) (- y 2) (+ z 18))
      2.0
      0
      (itoa (1+ i)))

    (setq i (1+ i))
  )
)

;;; Frequenzumrichter 3D (VFD)
(defun DRAW-3DVFD (pt bezeich kw / x y z)
  (setq x (car pt))
  (setq y (cadr pt))
  (setq z (if (caddr pt) (caddr pt) 0.0))

  ;; Grosses Gehaeuse (grau)
  (command "COLOR" 8)
  (DRAW-3DBOX pt 150 100 300)

  ;; Display (dunkelgruen)
  (command "COLOR" 80)
  (command "3DFACE"
    (list (+ x 30) y (+ z 220))
    (list (+ x 120) y (+ z 220))
    (list (+ x 120) y (+ z 260))
    (list (+ x 30) y (+ z 260))
    "")

  ;; Frequenzanzeige
  (command "COLOR" 3)
  (command "TEXT"
    (list (+ x 50) (- y 2) (+ z 235))
    8
    0
    "50.0Hz")

  ;; Bedientasten
  (command "COLOR" 2)  ; Gelb - RUN
  (DRAW-3DBOX (list (+ x 30) (- y 3) (+ z 180)) 20 8 15)
  (command "COLOR" 1)  ; Rot - STOP
  (DRAW-3DBOX (list (+ x 60) (- y 3) (+ z 180)) 20 8 15)
  (command "COLOR" 5)  ; Blau - FWD/REV
  (DRAW-3DBOX (list (+ x 90) (- y 3) (+ z 180)) 20 8 15)

  ;; Potentiometer
  (command "COLOR" 250)
  (DRAW-3DCYL (list (+ x 75) y (+ z 140)) 15 8)

  ;; Lueftungsgitter
  (command "COLOR" 250)
  (setq i 0)
  (repeat 12
    (command "LINE"
      (list (+ x 20 (* i 10)) y (+ z 20))
      (list (+ x 20 (* i 10)) y (+ z 80))
      "")
    (setq i (1+ i))
  )

  ;; Typenschild
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 10) (- y 5) (+ z 100)) 4 0 bezeich)
  (command "TEXT" (list (+ x 10) (- y 5) (+ z 90)) 3 0 (strcat (rtos kw 2 1) " kW"))
  (command "TEXT" (list (+ x 10) (- y 5) (+ z 280)) 5 0 "SIEMENS")
)

;;; SPS / PLC 3D
(defun DRAW-3DSPS (pt bezeich / x y z i)
  (setq x (car pt))
  (setq y (cadr pt))
  (setq z (if (caddr pt) (caddr pt) 0.0))

  ;; CPU-Modul (grau)
  (command "COLOR" 8)
  (DRAW-3DBOX pt 40 100 125)

  ;; Status-LEDs
  (command "COLOR" 3)  ; RUN - gruen
  (DRAW-3DCYL (list (+ x 10) y (+ z 110)) 3 3)
  (command "COLOR" 1)  ; STOP - rot
  (DRAW-3DCYL (list (+ x 20) y (+ z 110)) 3 3)
  (command "COLOR" 2)  ; ERROR - gelb
  (DRAW-3DCYL (list (+ x 30) y (+ z 110)) 3 3)

  ;; Siemens Logo
  (command "COLOR" 14)
  (command "TEXT" (list (+ x 5) (- y 3) (+ z 90)) 3 0 "SIMATIC")
  (command "TEXT" (list (+ x 5) (- y 3) (+ z 80)) 4 0 "S7-300")

  ;; E/A Module daneben
  (setq i 0)
  (repeat 4
    ;; Digital-Eingangsmodul
    (command "COLOR" 7)
    (DRAW-3DBOX
      (list (+ x 45 (* i 25)) y z)
      20 100 125)

    ;; LED-Reihe
    (command "COLOR" 3)
    (setq j 0)
    (repeat 8
      (DRAW-3DCYL
        (list (+ x 50 (* i 25)) y (+ z 30 (* j 10)))
        2 2)
      (setq j (1+ j))
    )
    (setq i (1+ i))
  )

  ;; Beschriftung
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 5) (- y 8) (+ z 5)) 3 0 bezeich)
)

;;; ============================================
;;; HAUPTFUNKTION: KOMPLETTER 3D-SCHALTSCHRANK
;;; ============================================

(defun C:CABINET3D (/ pt)
  (princ "\n=== 3D SCHALTSCHRANK-GENERATOR ===")
  (princ "\n    Schmidt & Weber GmbH 1991")
  (princ "\n")

  ;; Startpunkt
  (setq pt (getpoint "\nEinfuegepunkt Schaltschrank: "))
  (if (null pt) (setq pt '(0 0 0)))

  ;; Schrank zeichnen (600x400x2000 mm)
  (DRAW-CABINET pt 600 400 2000)

  ;; Komponenten einbauen
  (princ "\n  Baue Komponenten ein...")

  ;; Hauptschalter oben links
  (DRAW-3DHAUPT (list (+ (car pt) 50) (+ (cadr pt) 50) 1700))

  ;; Leitungsschutzschalter-Reihe
  (setq i 0)
  (repeat 12
    (DRAW-3DLS
      (list (+ (car pt) 200 (* i 22)) (+ (cadr pt) 50) 1700)
      (strcat "F" (itoa (1+ i)))
      (nth i '(16 16 16 10 10 10 6 6 6 4 4 2)))
    (setq i (1+ i))
  )

  ;; Schuetze Reihe 1
  (DRAW-3DSCHUETZ (list (+ (car pt) 50) (+ (cadr pt) 50) 1400) "K1")
  (DRAW-3DSCHUETZ (list (+ (car pt) 110) (+ (cadr pt) 50) 1400) "K2")
  (DRAW-3DSCHUETZ (list (+ (car pt) 170) (+ (cadr pt) 50) 1400) "K3")
  (DRAW-3DSCHUETZ (list (+ (car pt) 230) (+ (cadr pt) 50) 1400) "K4")

  ;; Motorschutzschalter
  (DRAW-3DMSS (list (+ (car pt) 320) (+ (cadr pt) 50) 1400) "Q1")
  (DRAW-3DMSS (list (+ (car pt) 380) (+ (cadr pt) 50) 1400) "Q2")

  ;; Frequenzumrichter
  (DRAW-3DVFD (list (+ (car pt) 50) (+ (cadr pt) 50) 900) "G120" 5.5)

  ;; SPS
  (DRAW-3DSPS (list (+ (car pt) 250) (+ (cadr pt) 50) 900) "CPU315")

  ;; Klemmenleisten unten
  (DRAW-3DKLEMM (list (+ (car pt) 50) (+ (cadr pt) 50) 200) 20)
  (DRAW-3DKLEMM (list (+ (car pt) 280) (+ (cadr pt) 50) 200) 15)

  ;; Kabel (als Linien angedeutet)
  (command "COLOR" 1)  ; L1 rot
  (command "LINE"
    (list (+ (car pt) 100) (+ (cadr pt) 300) 20)
    (list (+ (car pt) 100) (+ (cadr pt) 300) 1800)
    "")

  (command "COLOR" 2)  ; L2 gelb
  (command "LINE"
    (list (+ (car pt) 120) (+ (cadr pt) 300) 20)
    (list (+ (car pt) 120) (+ (cadr pt) 300) 1800)
    "")

  (command "COLOR" 4)  ; L3 blau
  (command "LINE"
    (list (+ (car pt) 140) (+ (cadr pt) 300) 20)
    (list (+ (car pt) 140) (+ (cadr pt) 300) 1800)
    "")

  (command "COLOR" 3)  ; PE gruen
  (command "LINE"
    (list (+ (car pt) 160) (+ (cadr pt) 300) 20)
    (list (+ (car pt) 160) (+ (cadr pt) 300) 1800)
    "")

  (princ "\n\n=== 3D-SCHALTSCHRANK FERTIG ===")
  (princ "\nKomponenten: Hauptschalter, 12x LS, 4x Schuetz,")
  (princ "\n             2x MSS, 1x VFD, 1x SPS, 2x Klemmenleiste")
  (princ)
)

(princ "\nCABINET3.LSP geladen.")
(princ "\nBefehl: CABINET3D - Erzeugt kompletten 3D-Schaltschrank")
(princ)
