;;; SCHALT.LSP - Schaltplan-Generator aus CSV-Daten
;;; Elektrotechnik Planungsbuero Schmidt & Weber GmbH
;;; Muenchen, Maerz 1991
;;; Fuer AutoCAD Release 10
;;;
;;; Hauptprogramm zur automatischen Erzeugung von Schaltplaenen
;;; aus CSV-Stuecklisten. Generiert separate DWG-Dateien fuer
;;; jeden Datensatz (jede Zeile = ein Bauteil).
;;;
;;; ACHTUNG: Vor Verwendung muessen geladen sein:
;;;   (load "CSVREAD")
;;;   (load "EBLOCKS")
;;;

;;; Konfiguration
(setq *SCHALT-OUTDIR* "C:\\ACAD\\PROJEKTE\\")  ; Ausgabeverzeichnis
(setq *SCHALT-TEMPLATE* "C:\\ACAD\\TEMPLATE\\A4.DWG")  ; Vorlage
(setq *SCHALT-XSTART* 50.0)   ; X-Startposition auf Blatt
(setq *SCHALT-YSTART* 250.0)  ; Y-Startposition auf Blatt
(setq *SCHALT-XGRID* 40.0)    ; X-Raster fuer Symbole
(setq *SCHALT-YGRID* 30.0)    ; Y-Raster fuer Symbole

;;; Mapping von Bauteiltypen zu Zeichenfunktionen
;;; CSV-Typ -> (Funktion Parameter)
(setq *SCHALT-TYPES*
  (list
    (cons "SCHUETZ" 'DRAW-SCHUETZ)
    (cons "SCHALTER" 'DRAW-SCHALTER)
    (cons "KREUZSCHALTER" 'DRAW-KREUZSCH)
    (cons "WECHSELSCHALTER" 'DRAW-WECHSELS)
    (cons "SICHERUNG" 'DRAW-SICHERG)
    (cons "RELAIS" 'DRAW-RELAIS)
    (cons "MOTOR" 'DRAW-MOTOR)
    (cons "KLEMME" 'DRAW-KLEMME)
    ;; Aliase (deutsche Schreibweisen)
    (cons "SCHUTZ" 'DRAW-SCHUETZ)
    (cons "SCHÜTZ" 'DRAW-SCHUETZ)
    (cons "SWITCH" 'DRAW-SCHALTER)
    (cons "FUSE" 'DRAW-SICHERG)
  )
)

;;; Funktion: Bauteiltyp auf Zeichenfunktion abbilden
(defun SCHALT-GETFUNC (typ / entry)
  (setq typ (strcase typ))  ; Grossbuchstaben
  (setq entry (assoc typ *SCHALT-TYPES*))
  (if entry
    (cdr entry)
    nil
  )
)

;;; Funktion: Einzelnes Bauteil verarbeiten
;;; row - Assoziationsliste mit Bauteil-Daten
;;; idx - Zeilennummer (fuer Positionierung)
;;;
(defun SCHALT-PROCESS (row idx / typ func pos x y bezeich wert)
  ;; Spalten aus CSV lesen
  (setq typ (CSV-GET "TYP" row))
  (setq bezeich (CSV-GET "BEZEICHNUNG" row))
  (setq wert (CSV-GET "WERT" row))

  ;; Position berechnen (Raster)
  (setq x (+ *SCHALT-XSTART* (* (rem idx 5) *SCHALT-XGRID*)))
  (setq y (- *SCHALT-YSTART* (* (/ idx 5) *SCHALT-YGRID*)))
  (setq pos (list x y))

  ;; Zeichenfunktion ermitteln
  (setq func (SCHALT-GETFUNC typ))

  (if func
    (progn
      (princ (strcat "\n  Zeichne " typ ": " bezeich))

      ;; Symbol zeichnen
      (apply func (list pos 1.0 0.0))

      ;; Bezeichnung hinzufuegen
      (if bezeich
        (command "TEXT"
          (list x (- y 5))
          *E-TXTHGT*
          0
          bezeich)
      )

      ;; Wert hinzufuegen (falls vorhanden)
      (if (and wert (/= wert ""))
        (command "TEXT"
          (list x (- y 8))
          (* *E-TXTHGT* 0.8)
          0
          wert)
      )

      T  ; Erfolg
    )
    (progn
      (princ (strcat "\n  *** Unbekannter Typ: " typ))
      nil
    )
  )
)

;;; ============================================
;;; HAUPTFUNKTION: CSV zu DWG Batch-Verarbeitung
;;; ============================================
;;;
;;; Fuer jede Zeile in der CSV-Datei wird eine
;;; separate DWG-Datei erzeugt. Dateiname wird
;;; aus der BEZEICHNUNG-Spalte generiert.
;;;

(defun C:SCHALTGEN (/ csvfile data row fname outfile idx erfolg)
  (princ "\n=== SCHALTPLAN-GENERATOR v1.0 ===")
  (princ "\n    Schmidt & Weber GmbH 1991")
  (princ "\n")

  ;; CSV-Datei auswaehlen
  (setq csvfile (getstring "\nCSV-Datei (z.B. KOMPONEN.CSV): "))
  (if (= csvfile "") (setq csvfile "KOMPONEN.CSV"))

  ;; Pruefen ob Datei existiert
  (if (not (findfile csvfile))
    (progn
      (princ (strcat "\n*** FEHLER: Datei nicht gefunden: " csvfile))
      (exit)
    )
  )

  ;; CSV laden
  (princ (strcat "\nLade " csvfile "..."))
  (setq data (CSV-LOADH csvfile))

  (if (null data)
    (progn
      (princ "\n*** FEHLER: CSV-Datei konnte nicht gelesen werden!")
      (exit)
    )
  )

  (princ (strcat "\n" (itoa (length data)) " Datensaetze gefunden."))
  (princ "\n")

  ;; Jeden Datensatz verarbeiten
  (setq idx 0)
  (setq erfolg 0)

  (foreach row data
    (princ (strcat "\n[" (itoa (1+ idx)) "/" (itoa (length data)) "] "))

    ;; Dateinamen aus BEZEICHNUNG generieren
    (setq fname (CSV-GET "BEZEICHNUNG" row))
    (if (null fname) (setq fname (strcat "TEIL" (itoa idx))))

    ;; Dateiname bereinigen (nur 8 Zeichen, keine Sonderzeichen)
    (setq fname (SCHALT-CLEANNAME fname))
    (setq outfile (strcat *SCHALT-OUTDIR* fname ".DWG"))

    (princ (strcat fname " -> " outfile))

    ;; Neues Template oeffnen (falls vorhanden)
    ; (command "NEW" *SCHALT-TEMPLATE*)

    ;; Bauteil zeichnen
    (if (SCHALT-PROCESS row idx)
      (progn
        ;; Zeichnung speichern
        ; (command "SAVEAS" "" outfile)
        (princ " [OK]")
        (setq erfolg (1+ erfolg))
      )
      (princ " [FEHLER]")
    )

    (setq idx (1+ idx))
  )

  ;; Zusammenfassung
  (princ "\n")
  (princ "\n=================================")
  (princ (strcat "\nVerarbeitet: " (itoa idx) " Datensaetze"))
  (princ (strcat "\nErfolgreich: " (itoa erfolg)))
  (princ (strcat "\nFehler:      " (itoa (- idx erfolg))))
  (princ "\n=================================")
  (princ)
)

;;; Hilfsfunktion: Dateinamen bereinigen (8.3 DOS-konform)
(defun SCHALT-CLEANNAME (name / result ch i)
  (setq result "")
  (setq i 1)

  (while (and (<= i (strlen name)) (< (strlen result) 8))
    (setq ch (ascii (substr name i 1)))
    (cond
      ;; Buchstaben A-Z, a-z
      ((and (>= ch 65) (<= ch 90))
       (setq result (strcat result (chr ch))))
      ((and (>= ch 97) (<= ch 122))
       (setq result (strcat result (chr (- ch 32)))))  ; Gross
      ;; Ziffern 0-9
      ((and (>= ch 48) (<= ch 57))
       (setq result (strcat result (chr ch))))
      ;; Alles andere ignorieren
    )
    (setq i (1+ i))
  )

  (if (= result "") (setq result "NONAME"))
  result
)

;;; ============================================
;;; EINZELZEICHNUNG: Ein Bauteil interaktiv
;;; ============================================
(defun C:SCHALTONE (/ typ bezeich wert pos func)
  (princ "\n--- Einzelbauteil zeichnen ---")

  (setq typ (getstring "\nBauteiltyp (SCHUETZ/SCHALTER/RELAIS/...): "))
  (setq bezeich (getstring T "\nBezeichnung: "))
  (setq wert (getstring T "\nWert/Parameter: "))
  (setq pos (getpoint "\nEinfuegepunkt: "))

  (if (null pos) (exit))

  (setq func (SCHALT-GETFUNC typ))
  (if func
    (progn
      (apply func (list pos 1.0 0.0))
      (if (/= bezeich "")
        (command "TEXT" (list (car pos) (- (cadr pos) 5)) *E-TXTHGT* 0 bezeich))
      (if (/= wert "")
        (command "TEXT" (list (car pos) (- (cadr pos) 8)) (* *E-TXTHGT* 0.8) 0 wert))
      (princ "\nBauteil gezeichnet.")
    )
    (princ (strcat "\n*** Unbekannter Typ: " typ))
  )
  (princ)
)

(princ "\nSCHALT.LSP geladen.")
(princ "\nBefehle: SCHALTGEN (Batch), SCHALTONE (Einzeln)")
(princ)
