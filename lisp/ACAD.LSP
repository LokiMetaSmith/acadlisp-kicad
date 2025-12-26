;;; ACAD.LSP - AutoCAD Startup-Datei
;;; Elektrotechnik Planungsbuero Schmidt & Weber GmbH
;;; Muenchen, 1991
;;;
;;; Diese Datei wird automatisch beim Start von AutoCAD geladen.
;;; Sie laedt alle benoetigten Elektrotechnik-Module.
;;;
;;; Installation:
;;;   Kopieren nach C:\ACAD\ (oder ACAD-Verzeichnis)
;;;
;;; Fuer AutoCAD Release 9/10 unter MS-DOS
;;;

(princ "\n")
(princ "╔════════════════════════════════════════════════════════════╗\n")
(princ "║   ELEKTROTECHNIK PLANUNGSBUERO SCHMIDT & WEBER GMBH        ║\n")
(princ "║                    Muenchen 1991                           ║\n")
(princ "║                                                            ║\n")
(princ "║   AutoCAD Elektrotechnik-Erweiterung v2.1                  ║\n")
(princ "╚════════════════════════════════════════════════════════════╝\n")
(princ "\n")

;;; Verzeichnis fuer LISP-Dateien
(setq *LISP-PATH* "C:\\ACAD\\LISP\\")

;;; Hilfsfunktion zum Laden mit Fehlerbehandlung
(defun SAFE-LOAD (fname / fullpath)
  (setq fullpath (strcat *LISP-PATH* fname))
  (if (findfile fullpath)
    (progn
      (princ (strcat "  Lade " fname "..."))
      (load fullpath)
      (princ " OK\n")
      T
    )
    (progn
      (princ (strcat "  *** " fname " nicht gefunden!\n"))
      nil
    )
  )
)

;;; Module laden
(princ "Initialisiere Elektrotechnik-Module:\n")
(princ "\n")

;; CSV-Lesefunktionen (fuer Stuecklisten-Import)
(SAFE-LOAD "CSVREAD.LSP")

;; Elektrische Symbole (DIN-konform)
(SAFE-LOAD "EBLOCKS.LSP")

;; Schaltplan-Generator
(SAFE-LOAD "SCHALT.LSP")

;;; Begruessung und Hilfe
(princ "\n")
(princ "Verfuegbare Befehle:\n")
(princ "  SCHALTGEN  - Schaltplaene aus CSV-Datei generieren\n")
(princ "  SCHALTONE  - Einzelnes Bauteil zeichnen\n")
(princ "  SCHUETZ    - Schuetz-Symbol einfuegen\n")
(princ "  SCHALTER   - Schalter-Symbol einfuegen\n")
(princ "  KREUZSCH   - Kreuzschalter-Symbol einfuegen\n")
(princ "  WECHSELS   - Wechselschalter-Symbol einfuegen\n")
(princ "  SICHERG    - Sicherungs-Symbol einfuegen\n")
(princ "  RELAIS     - Relais-Symbol einfuegen\n")
(princ "  MOTOR      - Motor-Symbol (Drehstrom) einfuegen\n")
(princ "\n")
(princ "Bereit.\n")
(princ)
