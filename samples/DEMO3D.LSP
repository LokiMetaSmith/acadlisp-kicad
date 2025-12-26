;;; DEMO3D.LSP - Beeindruckende 3D Demo-Szene
;;; Elektrotechnik Planungsbuero Schmidt & Weber GmbH
;;; Muenchen, Dezember 1991
;;;
;;; Erzeugt eine komplette industrielle Szene zur Demonstration
;;; aller 3D-Faehigkeiten des Systems.
;;;

(princ "\n")
(princ "╔════════════════════════════════════════════════════════════════╗\n")
(princ "║          3D INDUSTRIAL DEMO - RUST-AUTOLISP                    ║\n")
(princ "║                                                                ║\n")
(princ "║   Recreating the 1991 AutoCAD batch processing workflow        ║\n")
(princ "║   for electrical engineering drawings                          ║\n")
(princ "╚════════════════════════════════════════════════════════════════╝\n")
(princ "\n")

;;; ============================================
;;; HILFSFUNKTIONEN
;;; ============================================

(defun DRAW-BOX (pt w h / x y)
  "Zeichnet ein 2D-Rechteck"
  (setq x (car pt))
  (setq y (cadr pt))
  (command "LINE"
    pt
    (list (+ x w) y)
    (list (+ x w) (+ y h))
    (list x (+ y h))
    "C")
)

(defun DRAW-FILLED-BOX (pt w h / x y)
  "Zeichnet ein gefuelltes Rechteck mit Schraffur"
  (DRAW-BOX pt w h)
  (setq x (car pt))
  (setq y (cadr pt))
  ;; Diagonale Schraffur
  (setq i 0)
  (while (< (* i 10) (max w h))
    (command "LINE"
      (list (+ x (min (* i 10) w)) y)
      (list x (+ y (min (* i 10) h)))
      "")
    (setq i (1+ i))
  )
)

;;; ============================================
;;; INDUSTRIESZENE
;;; ============================================

(defun DRAW-INDUSTRIAL-SCENE (/ x y)
  (princ "\nZeichne industrielle Szene...\n")

  ;; Koordinatensystem-Ursprung
  (setq x 0)
  (setq y 0)

  ;; ========== BODEN UND RAHMEN ==========
  (princ "  [1/8] Grundriss und Rahmen\n")

  ;; Aussenrahmen
  (command "COLOR" 7)
  (DRAW-BOX '(0 0) 1000 700)

  ;; Bodenraster
  (command "COLOR" 8)
  (setq i 0)
  (while (<= (* i 50) 1000)
    (command "LINE"
      (list (* i 50) 0)
      (list (* i 50) 700)
      "")
    (setq i (1+ i))
  )
  (setq i 0)
  (while (<= (* i 50) 700)
    (command "LINE"
      (list 0 (* i 50))
      (list 1000 (* i 50))
      "")
    (setq i (1+ i))
  )

  ;; ========== SCHALTSCHRANK 1 ==========
  (princ "  [2/8] Schaltschrank E01\n")
  (command "COLOR" 7)
  (DRAW-BOX '(50 500) 120 150)
  (command "TEXT" '(60 660) 8 0 "=+E01")

  ;; Innenleben
  (command "COLOR" 3)  ; Gruen = Betrieb
  (command "CIRCLE" '(80 640) 5)
  (command "COLOR" 1)  ; Rot = Stoerung
  (command "CIRCLE" '(100 640) 5)

  ;; Kabel
  (command "COLOR" 4)  ; Blau
  (command "LINE" '(110 500) '(110 400) "")
  (command "LINE" '(110 400) '(200 400) "")

  ;; ========== SCHALTSCHRANK 2 ==========
  (princ "  [3/8] Schaltschrank E02\n")
  (command "COLOR" 7)
  (DRAW-BOX '(180 500) 120 150)
  (command "TEXT" '(190 660) 8 0 "=+E02")
  (command "COLOR" 3)
  (command "CIRCLE" '(210 640) 5)

  ;; ========== FREQUENZUMRICHTER ==========
  (princ "  [4/8] Frequenzumrichter\n")
  (command "COLOR" 8)
  (DRAW-BOX '(320 500) 80 150)
  (command "COLOR" 14)
  (command "TEXT" '(325 660) 5 0 "SIEMENS")
  (command "TEXT" '(325 640) 6 0 "G120")
  (command "COLOR" 80)
  (DRAW-BOX '(330 580) 60 30)
  (command "COLOR" 3)
  (command "TEXT" '(340 590) 8 0 "50Hz")

  ;; ========== SPS-SCHRANK ==========
  (princ "  [5/8] SPS-Steuerung\n")
  (command "COLOR" 7)
  (DRAW-BOX '(420 500) 100 150)
  (command "TEXT" '(430 660) 6 0 "SIMATIC")
  (command "TEXT" '(430 640) 8 0 "S7-300")

  ;; E/A Module
  (command "COLOR" 9)
  (setq i 0)
  (repeat 4
    (DRAW-BOX (list (+ 430 (* i 20)) 520) 15 80)
    ;; LEDs
    (command "COLOR" 3)
    (setq j 0)
    (repeat 8
      (command "CIRCLE" (list (+ 437 (* i 20)) (+ 530 (* j 8))) 2)
      (setq j (1+ j))
    )
    (command "COLOR" 9)
    (setq i (1+ i))
  )

  ;; ========== FOERDERBAND ==========
  (princ "  [6/8] Foerderband\n")
  (command "COLOR" 2)  ; Gelb = Sicherheit
  (DRAW-BOX '(50 250) 500 60)

  ;; Rollen
  (command "COLOR" 7)
  (command "CIRCLE" '(80 280) 25)
  (command "CIRCLE" '(520 280) 25)

  ;; Antriebsmotor
  (command "COLOR" 8)
  (DRAW-BOX '(530 260) 60 40)
  (command "COLOR" 7)
  (command "TEXT" '(535 285) 6 0 "M1")
  (command "TEXT" '(535 265) 4 0 "5.5kW")

  ;; Produkte auf Band
  (command "COLOR" 6)  ; Magenta = Produkte
  (setq i 0)
  (repeat 8
    (DRAW-BOX (list (+ 100 (* i 50)) 285) 30 20)
    (setq i (1+ i))
  )

  ;; Lichtschranke
  (command "COLOR" 1)
  (command "LINE" '(200 250) '(200 330) "")
  (command "LINE" '(200 330) '(200 310) '(195 320) '(205 320) '(200 310) "")
  (command "TEXT" '(180 340) 4 0 "B1")

  ;; ========== CNC-MASCHINE ==========
  (princ "  [7/8] CNC-Bearbeitungszentrum\n")
  (command "COLOR" 80)  ; Maschinengruen
  (DRAW-BOX '(650 400) 200 200)
  (command "COLOR" 7)
  (command "TEXT" '(660 610) 6 0 "DECKEL MAHO")
  (command "TEXT" '(660 590) 10 0 "DMC-65V")

  ;; Arbeitstisch
  (command "COLOR" 7)
  (DRAW-BOX '(680 450) 140 100)

  ;; Spindel
  (command "COLOR" 254)
  (command "CIRCLE" '(750 500) 15)
  (command "LINE" '(750 485) '(750 420) "")

  ;; Bedienpult
  (command "COLOR" 8)
  (DRAW-BOX '(860 450) 40 100)
  (command "COLOR" 80)
  (DRAW-BOX '(865 510) 30 30)
  (command "COLOR" 1)
  (command "CIRCLE" '(875 470) 8)
  (command "TEXT" '(867 458) 4 0 "NOT")

  ;; ========== ROBOTER ==========
  (princ "  [8/8] Industrieroboter\n")
  (command "COLOR" 252)  ; Orange KUKA

  ;; Sockel
  (command "COLOR" 2)
  (DRAW-BOX '(720 100) 80 30)
  (command "COLOR" 250)
  (DRAW-BOX '(730 110) 60 10)

  ;; Basis
  (command "COLOR" 252)
  (command "CIRCLE" '(760 130) 30)

  ;; Arm 1
  (command "LINE" '(760 130) '(760 220) "")
  (command "LINE" '(750 130) '(750 220) "")
  (command "LINE" '(770 130) '(770 220) "")

  ;; Ellbogen
  (command "CIRCLE" '(760 220) 15)

  ;; Arm 2
  (command "LINE" '(760 220) '(820 280) "")
  (command "LINE" '(755 225) '(815 285) "")

  ;; Greifer
  (command "COLOR" 7)
  (command "LINE" '(820 280) '(840 280) "")
  (command "LINE" '(840 270) '(840 290) "")
  (command "LINE" '(840 270) '(855 275) "")
  (command "LINE" '(840 290) '(855 285) "")

  ;; Steuerung
  (command "COLOR" 8)
  (DRAW-BOX '(820 100) 60 80)
  (command "COLOR" 7)
  (command "TEXT" '(825 170) 5 0 "KUKA")
  (command "TEXT" '(825 155) 4 0 "KR-150")

  ;; Sicherheitszaun
  (command "COLOR" 2)
  (command "LINE" '(650 80) '(900 80) "")
  (command "LINE" '(900 80) '(900 350) "")
  (command "LINE" '(650 80) '(650 350) "")

  ;; ========== BESCHRIFTUNGEN ==========
  (command "COLOR" 7)
  (command "TEXT" '(50 680) 10 0 "PRODUKTIONSHALLE - SCHMIDT & WEBER GMBH 1991")

  (command "TEXT" '(50 50) 6 0 "Legende:")
  (command "COLOR" 3)
  (command "CIRCLE" '(60 35) 4)
  (command "COLOR" 7)
  (command "TEXT" '(70 32) 5 0 "= Betrieb OK")

  (command "COLOR" 1)
  (command "CIRCLE" '(180 35) 4)
  (command "COLOR" 7)
  (command "TEXT" '(190 32) 5 0 "= Stoerung")

  (command "COLOR" 2)
  (command "LINE" '(290 30) '(290 40) "")
  (command "COLOR" 7)
  (command "TEXT" '(300 32) 5 0 "= Sicherheitsbereich")

  ;; Massstab
  (command "COLOR" 7)
  (command "LINE" '(850 30) '(950 30) "")
  (command "LINE" '(850 25) '(850 35) "")
  (command "LINE" '(950 25) '(950 35) "")
  (command "TEXT" '(880 15) 5 0 "10m")

  (princ "\nSzene fertig!\n")
)

;;; ============================================
;;; STERN-DREIECK SCHALTPLAN
;;; ============================================

(defun DRAW-STERDRE-DEMO (/ x y)
  (princ "\nZeichne Stern-Dreieck-Anlasser...\n")

  (setq x 1100)
  (setq y 0)

  ;; Rahmen
  (command "COLOR" 7)
  (DRAW-BOX (list x y) 400 700)
  (command "TEXT" (list (+ x 20) 680) 8 0 "STERN-DREIECK-ANLASSER")
  (command "TEXT" (list (+ x 20) 660) 5 0 "Motor M1: 5.5 kW")

  ;; Netzeinspeisung
  (command "COLOR" 1)  ; L1
  (command "LINE" (list (+ x 80) 620) (list (+ x 80) 550) "")
  (command "TEXT" (list (+ x 75) 630) 5 0 "L1")

  (command "COLOR" 2)  ; L2
  (command "LINE" (list (+ x 130) 620) (list (+ x 130) 550) "")
  (command "TEXT" (list (+ x 125) 630) 5 0 "L2")

  (command "COLOR" 4)  ; L3
  (command "LINE" (list (+ x 180) 620) (list (+ x 180) 550) "")
  (command "TEXT" (list (+ x 175) 630) 5 0 "L3")

  ;; Sicherungen
  (command "COLOR" 7)
  (DRAW-BOX (list (+ x 70) 520) 20 30)
  (DRAW-BOX (list (+ x 120) 520) 20 30)
  (DRAW-BOX (list (+ x 170) 520) 20 30)
  (command "TEXT" (list (+ x 200) 530) 4 0 "F1-F3")

  ;; Netzschuetz K1
  (command "COLOR" 7)
  (DRAW-BOX (list (+ x 50) 440) 160 60)
  (command "TEXT" (list (+ x 220) 465) 6 0 "K1")
  (command "TEXT" (list (+ x 220) 450) 4 0 "Netz")

  ;; Kontaktsymbole
  (command "CIRCLE" (list (+ x 80) 460) 8)
  (command "LINE" (list (+ x 80) 468) (list (+ x 80) 480) "")
  (command "CIRCLE" (list (+ x 130) 460) 8)
  (command "LINE" (list (+ x 130) 468) (list (+ x 130) 480) "")
  (command "CIRCLE" (list (+ x 180) 460) 8)
  (command "LINE" (list (+ x 180) 468) (list (+ x 180) 480) "")

  ;; Thermisches Relais
  (command "COLOR" 7)
  (DRAW-BOX (list (+ x 50) 360) 160 60)
  (command "TEXT" (list (+ x 220) 385) 6 0 "F4")
  (command "TEXT" (list (+ x 220) 370) 4 0 "Therm")

  ;; Bimetall-Symbol
  (command "LINE"
    (list (+ x 70) 370)
    (list (+ x 85) 400)
    (list (+ x 100) 370)
    (list (+ x 115) 400)
    (list (+ x 130) 370)
    "")

  ;; Motor
  (command "COLOR" 7)
  (command "CIRCLE" (list (+ x 130) 250) 50)
  (command "TEXT" (list (+ x 110) 260) 15 0 "M")
  (command "TEXT" (list (+ x 115) 235) 8 0 "3~")
  (command "TEXT" (list (+ x 190) 250) 5 0 "5.5 kW")
  (command "TEXT" (list (+ x 190) 235) 5 0 "1450 U/min")

  ;; Motoranschluesse
  (command "COLOR" 1)
  (command "LINE" (list (+ x 100) 300) (list (+ x 100) 340) "")
  (command "COLOR" 2)
  (command "LINE" (list (+ x 130) 300) (list (+ x 130) 340) "")
  (command "COLOR" 4)
  (command "LINE" (list (+ x 160) 300) (list (+ x 160) 340) "")

  ;; Stern-Schuetz K3
  (command "COLOR" 7)
  (DRAW-BOX (list (+ x 250) 300) 100 60)
  (command "TEXT" (list (+ x 260) 345) 6 0 "K3")
  (command "TEXT" (list (+ x 260) 310) 4 0 "Stern")

  ;; Sternpunkt
  (command "COLOR" 9)
  (command "LINE" (list (+ x 100) 200) (list (+ x 100) 150) (list (+ x 160) 150) "")
  (command "LINE" (list (+ x 130) 200) (list (+ x 130) 150) "")
  (command "LINE" (list (+ x 160) 200) (list (+ x 160) 150) "")
  (command "CIRCLE" (list (+ x 130) 150) 10)

  ;; Dreieck-Schuetz K2
  (command "COLOR" 7)
  (DRAW-BOX (list (+ x 250) 200) 100 60)
  (command "TEXT" (list (+ x 260) 245) 6 0 "K2")
  (command "TEXT" (list (+ x 260) 210) 4 0 "Dreieck")

  ;; Zustandsdiagramm
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 20) 120) 6 0 "Zustandsdiagramm:")

  ;; Zeitachse
  (command "LINE" (list (+ x 20) 50) (list (+ x 380) 50) "")
  (command "TEXT" (list (+ x 370) 40) 4 0 "t")

  ;; K1
  (command "TEXT" (list (+ x 5) 95) 4 0 "K1")
  (command "COLOR" 3)
  (command "LINE"
    (list (+ x 50) 85)
    (list (+ x 80) 85)
    (list (+ x 80) 100)
    (list (+ x 300) 100)
    (list (+ x 300) 85)
    (list (+ x 350) 85)
    "")

  ;; K3
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 5) 75) 4 0 "K3")
  (command "COLOR" 5)
  (command "LINE"
    (list (+ x 50) 65)
    (list (+ x 80) 65)
    (list (+ x 80) 80)
    (list (+ x 150) 80)
    (list (+ x 150) 65)
    (list (+ x 350) 65)
    "")

  ;; K2
  (command "COLOR" 7)
  (command "TEXT" (list (+ x 5) 55) 4 0 "K2")
  (command "COLOR" 1)
  (command "LINE"
    (list (+ x 50) 55)
    (list (+ x 170) 55)
    (list (+ x 170) 70)
    (list (+ x 300) 70)
    (list (+ x 300) 55)
    (list (+ x 350) 55)
    "")

  ;; Markierungen
  (command "COLOR" 7)
  (command "LINE" (list (+ x 80) 45) (list (+ x 80) 105) "")
  (command "TEXT" (list (+ x 75) 35) 3 0 "S2")

  (command "LINE" (list (+ x 150) 45) (list (+ x 150) 105) "")
  (command "TEXT" (list (+ x 145) 35) 3 0 "t=3s")

  (command "LINE" (list (+ x 300) 45) (list (+ x 300) 105) "")
  (command "TEXT" (list (+ x 295) 35) 3 0 "S1")

  (princ "Stern-Dreieck fertig!\n")
)

;;; ============================================
;;; HAUPTPROGRAMM
;;; ============================================

(princ "Starte Demo-Generierung...\n")

;; Industrieszene links
(DRAW-INDUSTRIAL-SCENE)

;; Schaltplan rechts
(DRAW-STERDRE-DEMO)

(princ "\n")
(princ "╔════════════════════════════════════════════════════════════════╗\n")
(princ "║                    DEMO ABGESCHLOSSEN                          ║\n")
(princ "╠════════════════════════════════════════════════════════════════╣\n")
(princ "║   Linke Seite:  Produktionshalle mit Maschinen                 ║\n")
(princ "║   Rechte Seite: Stern-Dreieck-Anlaufschaltung                  ║\n")
(princ "║                                                                ║\n")
(princ "║   Ausgabe: output/DEMO3D.svg und output/DEMO3D.json            ║\n")
(princ "╚════════════════════════════════════════════════════════════════╝\n")
(princ)
