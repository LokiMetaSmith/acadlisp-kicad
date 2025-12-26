;;; FABRIK.LSP - 3D Fabrikhalle mit Maschinen
;;; Elektrotechnik Planungsbuero Schmidt & Weber GmbH
;;; Muenchen, November 1991
;;;
;;; Erzeugt eine komplette 3D-Fabrikhalle mit:
;;; - Foerderbaendern
;;; - CNC-Maschinen
;;; - Roboterarmen
;;; - Schaltschraenken
;;; - Beleuchtung
;;;
;;; Fuer AutoCAD Release 10 mit AME
;;;

;;; ============================================
;;; GEBAEUDE-GRUNDSTRUKTUR
;;; ============================================

(defun DRAW-HALLE (pt laenge breite hoehe / x y z)
  (setq x (car pt))
  (setq y (cadr pt))
  (setq z 0)

  (princ "\n  Zeichne Hallenstruktur...")

  ;; Boden (Beton - grau)
  (command "COLOR" 8)
  (command "3DFACE"
    (list x y z)
    (list (+ x laenge) y z)
    (list (+ x laenge) (+ y breite) z)
    (list x (+ y breite) z)
    "")

  ;; Bodengitter-Muster
  (command "COLOR" 7)
  (setq i 0)
  (while (< (* i 500) laenge)
    (command "LINE"
      (list (+ x (* i 500)) y 1)
      (list (+ x (* i 500)) (+ y breite) 1)
      "")
    (setq i (1+ i))
  )
  (setq i 0)
  (while (< (* i 500) breite)
    (command "LINE"
      (list x (+ y (* i 500)) 1)
      (list (+ x laenge) (+ y (* i 500)) 1)
      "")
    (setq i (1+ i))
  )

  ;; Stahltraeger (Stuetzen)
  (command "COLOR" 254)
  (setq i 0)
  (while (<= (* i 3000) laenge)
    ;; Vordere Reihe
    (DRAW-3DBOX (list (+ x (* i 3000)) y 0) 200 200 hoehe)
    ;; Hintere Reihe
    (DRAW-3DBOX (list (+ x (* i 3000)) (+ y (- breite 200)) 0) 200 200 hoehe)
    (setq i (1+ i))
  )

  ;; Quertraeger oben
  (setq i 0)
  (while (<= (* i 3000) laenge)
    (DRAW-3DBOX
      (list (+ x (* i 3000)) y hoehe)
      200 breite 150)
    (setq i (1+ i))
  )

  ;; Dach (Trapezblech-Optik)
  (command "COLOR" 7)
  (setq i 0)
  (while (< (* i 200) laenge)
    (command "3DFACE"
      (list (+ x (* i 200)) y (+ hoehe 150))
      (list (+ x (* i 200) 100) y (+ hoehe 250))
      (list (+ x (* i 200) 100) (+ y breite) (+ hoehe 250))
      (list (+ x (* i 200)) (+ y breite) (+ hoehe 150))
      "")
    (command "3DFACE"
      (list (+ x (* i 200) 100) y (+ hoehe 250))
      (list (+ x (* i 200) 200) y (+ hoehe 150))
      (list (+ x (* i 200) 200) (+ y breite) (+ hoehe 150))
      (list (+ x (* i 200) 100) (+ y breite) (+ hoehe 250))
      "")
    (setq i (1+ i))
  )
)

;;; ============================================
;;; FOERDERBAND
;;; ============================================

(defun DRAW-FOERDER (pt laenge breite hoehe richtung / x y z)
  (setq x (car pt))
  (setq y (cadr pt))
  (setq z (if (caddr pt) (caddr pt) 0.0))

  (princ (strcat "\n  Zeichne Foerderband (" (rtos laenge 2 0) "mm)..."))

  ;; Stahlgestell (gelb - Sicherheitsfarbe)
  (command "COLOR" 2)
  (if (= richtung 0)  ; horizontal in X-Richtung
    (progn
      ;; Seitentraeger
      (DRAW-3DBOX (list x y z) laenge 30 (- hoehe 100))
      (DRAW-3DBOX (list x (+ y (- breite 30)) z) laenge 30 (- hoehe 100))
      ;; Querstreben
      (setq i 0)
      (while (< (* i 500) laenge)
        (DRAW-3DBOX
          (list (+ x (* i 500)) (+ y 30) z)
          30 (- breite 60) 30)
        (setq i (1+ i))
      )
    )
    (progn  ; horizontal in Y-Richtung
      (DRAW-3DBOX (list x y z) 30 laenge (- hoehe 100))
      (DRAW-3DBOX (list (+ x (- breite 30)) y z) 30 laenge (- hoehe 100))
    )
  )

  ;; Gurtband (schwarz)
  (command "COLOR" 250)
  (if (= richtung 0)
    (DRAW-3DBOX (list x (+ y 30) (- hoehe 100)) laenge (- breite 60) 20)
    (DRAW-3DBOX (list (+ x 30) y (- hoehe 100)) (- breite 60) laenge 20)
  )

  ;; Umlenkrollen (rot)
  (command "COLOR" 1)
  (if (= richtung 0)
    (progn
      (DRAW-3DCYL (list x (+ y (/ breite 2)) (- hoehe 50)) (/ breite 3) 30)
      (DRAW-3DCYL (list (+ x laenge) (+ y (/ breite 2)) (- hoehe 50)) (/ breite 3) 30)
    )
  )

  ;; Antriebsmotor
  (command "COLOR" 8)
  (DRAW-3DBOX (list (+ x laenge 10) (+ y (/ breite 2) -40) (- hoehe 150)) 150 80 100)
  (command "COLOR" 9)
  (DRAW-3DCYL (list (+ x laenge 10) (+ y (/ breite 2)) (- hoehe 100)) 30 60)

  ;; Sicherheitslichtschranke
  (command "COLOR" 1)
  (DRAW-3DBOX (list (+ x 100) (- y 20) 0) 20 20 (+ hoehe 200))
  (DRAW-3DBOX (list (+ x 100) (+ y breite) 0) 20 20 (+ hoehe 200))
  ;; Lichtstrahl (rot gestrichelt)
  (command "COLOR" 1)
  (command "LINE"
    (list (+ x 110) y (+ hoehe 180))
    (list (+ x 110) (+ y breite) (+ hoehe 180))
    "")
)

;;; ============================================
;;; CNC-FRAESMASCHINE
;;; ============================================

(defun DRAW-CNC (pt bezeich / x y z)
  (setq x (car pt))
  (setq y (cadr pt))
  (setq z (if (caddr pt) (caddr pt) 0.0))

  (princ (strcat "\n  Zeichne CNC-Maschine " bezeich "..."))

  ;; Maschinenbett (gruen)
  (command "COLOR" 80)
  (DRAW-3DBOX pt 2000 1500 400)

  ;; Saeule (grau)
  (command "COLOR" 8)
  (DRAW-3DBOX (list (+ x 200) (+ y 1200) (+ z 400)) 400 200 1800)

  ;; Spindelkopf (beweglich)
  (command "COLOR" 8)
  (DRAW-3DBOX (list (+ x 200) (+ y 400) (+ z 1600)) 400 600 300)

  ;; Spindel
  (command "COLOR" 7)
  (DRAW-3DCYL (list (+ x 400) (+ y 700) (+ z 1600)) 50 -400)

  ;; Werkzeugaufnahme
  (command "COLOR" 254)
  (DRAW-3DCYL (list (+ x 400) (+ y 700) (+ z 1200)) 30 50)

  ;; Arbeitstisch (T-Nuten)
  (command "COLOR" 7)
  (DRAW-3DBOX (list (+ x 400) (+ y 200) (+ z 400)) 1200 800 100)
  (command "COLOR" 250)
  (setq i 0)
  (repeat 6
    (command "LINE"
      (list (+ x 450) (+ y 250 (* i 130)) (+ z 501))
      (list (+ x 1550) (+ y 250 (* i 130)) (+ z 501))
      "")
    (setq i (1+ i))
  )

  ;; Steuerpult
  (command "COLOR" 8)
  (DRAW-3DBOX (list (+ x 1700) (+ y 500) (+ z 800)) 300 400 700)
  ;; Bildschirm
  (command "COLOR" 80)
  (command "3DFACE"
    (list (+ x 1700) (+ y 550) (+ z 1200))
    (list (+ x 1700) (+ y 550) (+ z 1450))
    (list (+ x 1700) (+ y 850) (+ z 1450))
    (list (+ x 1700) (+ y 850) (+ z 1200))
    "")
  ;; Tastatur
  (command "COLOR" 250)
  (DRAW-3DBOX (list (+ x 1700) (+ y 550) (+ z 1000)) 50 300 30)

  ;; Not-Aus (rot)
  (command "COLOR" 1)
  (DRAW-3DCYL (list (+ x 1750) (+ y 450) (+ z 1100)) 30 40)

  ;; Kuehlmittelbehaelter
  (command "COLOR" 5)
  (DRAW-3DBOX (list (+ x 1800) (+ y 100) z) 150 300 600)

  ;; Spaene-Wanne
  (command "COLOR" 7)
  (DRAW-3DBOX (list (+ x 300) y z) 1300 150 200)

  ;; Typenschild
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 100) (- y 50) (+ z 350)) 30 0 bezeich)
  (command "TEXT" (list (+ x 100) (- y 50) (+ z 300)) 20 0 "DECKEL MAHO")
)

;;; ============================================
;;; INDUSTRIEROBOTER
;;; ============================================

(defun DRAW-ROBOT (pt bezeich / x y z)
  (setq x (car pt))
  (setq y (cadr pt))
  (setq z (if (caddr pt) (caddr pt) 0.0))

  (princ (strcat "\n  Zeichne Roboter " bezeich "..."))

  ;; Sockel (gelb/schwarz Sicherheitsmarkierung)
  (command "COLOR" 2)
  (DRAW-3DBOX pt 400 400 100)
  (command "COLOR" 250)
  (DRAW-3DBOX (list (+ x 20) (+ y 20) z) 360 360 100)

  ;; Drehachse 1 (Basis)
  (command "COLOR" 252)
  (DRAW-3DCYL (list (+ x 200) (+ y 200) (+ z 100)) 180 150)

  ;; Karussell
  (command "COLOR" 252)
  (DRAW-3DBOX (list (+ x 50) (+ y 100) (+ z 250)) 300 200 200)

  ;; Oberarm (Achse 2)
  (command "COLOR" 252)
  (DRAW-3DBOX (list (+ x 100) (+ y 150) (+ z 450)) 200 100 600)

  ;; Ellbogen-Gelenk
  (command "COLOR" 250)
  (DRAW-3DCYL (list (+ x 200) (+ y 200) (+ z 1050)) 60 100)

  ;; Unterarm (Achse 3)
  (command "COLOR" 252)
  (DRAW-3DBOX (list (+ x 120) (+ y 150) (+ z 1100)) 160 100 500)

  ;; Handgelenk (Achse 4, 5)
  (command "COLOR" 250)
  (DRAW-3DCYL (list (+ x 200) (+ y 200) (+ z 1600)) 50 80)

  ;; Greifer/Flansch (Achse 6)
  (command "COLOR" 7)
  (DRAW-3DCYL (list (+ x 200) (+ y 200) (+ z 1680)) 40 50)

  ;; Werkzeug (Schweisszange)
  (command "COLOR" 9)
  (DRAW-3DBOX (list (+ x 160) (+ y 160) (+ z 1730)) 80 80 150)
  ;; Elektroden
  (command "COLOR" 254)
  (DRAW-3DCYL (list (+ x 180) (+ y 200) (+ z 1880)) 10 50)
  (DRAW-3DCYL (list (+ x 220) (+ y 200) (+ z 1880)) 10 50)

  ;; Kabel/Schlauchpaket
  (command "COLOR" 250)
  (DRAW-3DCYL (list (+ x 250) (+ y 200) (+ z 450)) 25 700)

  ;; Steuerungsschrank
  (command "COLOR" 8)
  (DRAW-3DBOX (list (+ x 500) (+ y 100) z) 400 300 1500)
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 520) (+ y 80) (+ z 1400)) 25 0 "KUKA")
  (command "COLOR" 252)
  (command "TEXT" (list (+ x 520) (+ y 80) (+ z 1350)) 20 0 bezeich)

  ;; Bedienpanel (Teach-Pendant)
  (command "COLOR" 2)
  (DRAW-3DBOX (list (+ x 520) (- y 50) (+ z 1000)) 100 60 200)

  ;; Sicherheitszaun (gelb)
  (command "COLOR" 2)
  ;; Pfosten
  (DRAW-3DBOX (list (- x 300) (- y 300) z) 50 50 1200)
  (DRAW-3DBOX (list (+ x 700) (- y 300) z) 50 50 1200)
  (DRAW-3DBOX (list (- x 300) (+ y 700) z) 50 50 1200)
  (DRAW-3DBOX (list (+ x 700) (+ y 700) z) 50 50 1200)
  ;; Gitter (vereinfacht als Linien)
  (command "COLOR" 2)
  (setq i 0)
  (repeat 10
    (command "LINE"
      (list (- x 275) (- y 275) (+ z (* i 120)))
      (list (+ x 725) (- y 275) (+ z (* i 120)))
      "")
    (setq i (1+ i))
  )
)

;;; ============================================
;;; BELEUCHTUNG
;;; ============================================

(defun DRAW-HALLENLAMPE (pt / x y z)
  (setq x (car pt))
  (setq y (cadr pt))
  (setq z (caddr pt))

  ;; Aufhaengung
  (command "COLOR" 8)
  (DRAW-3DCYL (list x y z) 20 -200)

  ;; Lampengehaeuse
  (command "COLOR" 7)
  (DRAW-3DBOX (list (- x 150) (- y 75) (- z 250)) 300 150 50)

  ;; Leuchtflaeche (gelb = an)
  (command "COLOR" 2)
  (command "3DFACE"
    (list (- x 140) (- y 65) (- z 250))
    (list (+ x 140) (- y 65) (- z 250))
    (list (+ x 140) (+ y 65) (- z 250))
    (list (- x 140) (+ y 65) (- z 250))
    "")
)

;;; ============================================
;;; SCHALTSCHRANK (vereinfacht)
;;; ============================================

(defun DRAW-FABRIK-SCHRANK (pt bezeich / x y z)
  (setq x (car pt))
  (setq y (cadr pt))
  (setq z (if (caddr pt) (caddr pt) 0.0))

  ;; Gehaeuse
  (command "COLOR" 7)
  (DRAW-3DBOX pt 800 400 2000)

  ;; Tuer
  (command "COLOR" 8)
  (command "3DFACE"
    (list x y (+ z 50))
    (list (+ x 800) y (+ z 50))
    (list (+ x 800) y (+ z 1950))
    (list x y (+ z 1950))
    "")

  ;; Siemens-Logo
  (command "COLOR" 14)
  (command "TEXT" (list (+ x 250) (- y 10) (+ z 1800)) 40 0 "SIEMENS")

  ;; Bezeichnung
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 100) (- y 10) (+ z 1000)) 50 0 bezeich)

  ;; Lueftungsgitter
  (command "COLOR" 250)
  (setq i 0)
  (repeat 8
    (command "LINE"
      (list (+ x 100 (* i 80)) y (+ z 100))
      (list (+ x 100 (* i 80)) y (+ z 250))
      "")
    (setq i (1+ i))
  )

  ;; Status-Leuchten
  (command "COLOR" 3)  ; Power = gruen
  (DRAW-3DCYL (list (+ x 700) y (+ z 1800)) 15 10)
  (command "COLOR" 1)  ; Stoerung = rot (aus)
  (DRAW-3DCYL (list (+ x 700) y (+ z 1750)) 15 10)
)

;;; ============================================
;;; HAUPTFUNKTION: KOMPLETTE FABRIKHALLE
;;; ============================================

(defun C:FABRIK3D (/ pt)
  (princ "\n╔════════════════════════════════════════╗")
  (princ "\n║   3D FABRIKHALLEN-GENERATOR            ║")
  (princ "\n║   Schmidt & Weber GmbH 1991            ║")
  (princ "\n╚════════════════════════════════════════╝")
  (princ "\n")

  (setq pt (getpoint "\nStartpunkt der Halle: "))
  (if (null pt) (setq pt '(0 0 0)))

  ;; Hallengebaeude (12m x 20m x 8m)
  (DRAW-HALLE pt 20000 12000 8000)

  ;; Beleuchtung
  (princ "\n  Installiere Hallenbeleuchtung...")
  (setq i 0)
  (repeat 6
    (setq j 0)
    (repeat 3
      (DRAW-HALLENLAMPE
        (list (+ (car pt) 2000 (* i 3000))
              (+ (cadr pt) 2000 (* j 4000))
              8000))
      (setq j (1+ j))
    )
    (setq i (1+ i))
  )

  ;; Produktionslinie 1: Foerderbaender
  (princ "\n  Baue Produktionslinie 1...")
  (DRAW-FOERDER (list (+ (car pt) 1000) (+ (cadr pt) 1000) 0) 4000 600 900 0)
  (DRAW-FOERDER (list (+ (car pt) 5500) (+ (cadr pt) 1000) 0) 4000 600 900 0)
  (DRAW-FOERDER (list (+ (car pt) 10000) (+ (cadr pt) 1000) 0) 4000 600 900 0)

  ;; CNC-Maschinen
  (princ "\n  Installiere CNC-Maschinen...")
  (DRAW-CNC (list (+ (car pt) 1000) (+ (cadr pt) 3500) 0) "DMC-65V")
  (DRAW-CNC (list (+ (car pt) 5000) (+ (cadr pt) 3500) 0) "DMC-65V")
  (DRAW-CNC (list (+ (car pt) 9000) (+ (cadr pt) 3500) 0) "DMU-50")

  ;; Schweissroboter
  (princ "\n  Positioniere Industrieroboter...")
  (DRAW-ROBOT (list (+ (car pt) 2000) (+ (cadr pt) 7000) 0) "KR-150")
  (DRAW-ROBOT (list (+ (car pt) 6000) (+ (cadr pt) 7000) 0) "KR-150")
  (DRAW-ROBOT (list (+ (car pt) 10000) (+ (cadr pt) 7000) 0) "KR-210")

  ;; Schaltschraenke
  (princ "\n  Installiere Schaltschraenke...")
  (DRAW-FABRIK-SCHRANK (list (+ (car pt) 15000) (+ (cadr pt) 1000) 0) "=+E01")
  (DRAW-FABRIK-SCHRANK (list (+ (car pt) 16000) (+ (cadr pt) 1000) 0) "=+E02")
  (DRAW-FABRIK-SCHRANK (list (+ (car pt) 17000) (+ (cadr pt) 1000) 0) "=+E03")

  ;; Produktionslinie 2 (hinten)
  (DRAW-FOERDER (list (+ (car pt) 1000) (+ (cadr pt) 10000) 0) 8000 800 1100 0)

  (princ "\n")
  (princ "\n╔════════════════════════════════════════╗")
  (princ "\n║   3D-FABRIKHALLE FERTIGGESTELLT        ║")
  (princ "\n╠════════════════════════════════════════╣")
  (princ "\n║   Hallengroesse:  20m x 12m x 8m       ║")
  (princ "\n║   Foerderbaender: 4 Stueck             ║")
  (princ "\n║   CNC-Maschinen:  3 Stueck             ║")
  (princ "\n║   Roboter:        3 Stueck             ║")
  (princ "\n║   Schaltschraenke: 3 Stueck            ║")
  (princ "\n║   Hallenlampen:   18 Stueck            ║")
  (princ "\n╚════════════════════════════════════════╝")
  (princ)
)

(princ "\nFABRIK.LSP geladen.")
(princ "\nBefehl: FABRIK3D - Erzeugt komplette 3D-Fabrikhalle")
(princ)
