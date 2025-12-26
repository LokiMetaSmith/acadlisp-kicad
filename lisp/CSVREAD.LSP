;;; CSVREAD.LSP - CSV-Datei Lesefunktionen
;;; Elektrotechnik Planungsbuero Schmidt & Weber GmbH
;;; Muenchen, Januar 1991
;;; Fuer AutoCAD Release 10
;;;
;;; Diese Funktionen lesen CSV-Dateien Zeichen fuer Zeichen
;;; da AutoLISP keine eingebaute CSV-Unterstuetzung hat.
;;;
;;; Anpassung fuer DOS: Alle Dateinamen in 8.3 Format!
;;;

;;; Globale Variablen fuer CSV-Verarbeitung
(setq *CSV-DELIM* 59)   ; Semikolon (ASCII 59) - deutsches CSV Format!
(setq *CSV-QUOTE* 34)   ; Anfuehrungszeichen (ASCII 34)
(setq *CSV-CR* 13)      ; Carriage Return
(setq *CSV-LF* 10)      ; Line Feed

;;; Funktion: Prueft ob Zeichen ein Trennzeichen ist
;;; c - ASCII-Wert des Zeichens
(defun CSV-ISSEP (c)
  (or (= c *CSV-DELIM*)
      (= c *CSV-CR*)
      (= c *CSV-LF*))
)

;;; Funktion: Liest ein Feld aus der CSV-Datei
;;; fh - Datei-Handle
;;; Rueckgabe: (feldwert . naechstes-zeichen)
;;;
(defun CSV-FIELD (fh / ch fld inquote done)
  (setq fld "")
  (setq inquote nil)
  (setq done nil)

  (while (not done)
    (setq ch (read-char fh))
    (cond
      ;; Ende der Datei
      ((null ch)
       (setq done T))

      ;; Anfuehrungszeichen - Quote-Modus umschalten
      ((= ch *CSV-QUOTE*)
       (if inquote
         (progn
           ;; Pruefen auf escaped quote ("")
           (setq ch (read-char fh))
           (if (= ch *CSV-QUOTE*)
             (setq fld (strcat fld "\""))
             (progn
               (setq inquote nil)
               ;; Zeichen zurueck? Nein, weiter verarbeiten
               (if (CSV-ISSEP ch)
                 (setq done T)
               )
             )
           )
         )
         (setq inquote T)
       ))

      ;; Trennzeichen (nur wenn nicht in Quotes)
      ((and (not inquote) (CSV-ISSEP ch))
       (setq done T))

      ;; Normales Zeichen
      (T
       (setq fld (strcat fld (chr ch))))
    )
  )

  ;; Rueckgabe: Feldwert und ob Zeilenende
  (cons fld (or (null ch) (= ch *CSV-LF*)))
)

;;; Funktion: Liest eine komplette CSV-Zeile
;;; fh - Datei-Handle
;;; Rueckgabe: Liste von Feldwerten oder nil bei EOF
;;;
(defun CSV-LINE (fh / result fld eol)
  (setq result nil)
  (setq eol nil)

  (while (not eol)
    (setq fld (CSV-FIELD fh))
    (if (car fld)
      (setq result (append result (list (car fld))))
    )
    (setq eol (cdr fld))
  )

  (if result result nil)
)

;;; Funktion: Liest komplette CSV-Datei in Liste
;;; fname - Dateiname (8.3 Format!)
;;; Rueckgabe: Liste von Listen (Zeilen mit Feldern)
;;;
(defun CSV-LOAD (fname / fh data line)
  (setq fh (open fname "r"))
  (if fh
    (progn
      (setq data nil)
      (while (setq line (CSV-LINE fh))
        (setq data (append data (list line)))
      )
      (close fh)
      data
    )
    (progn
      (princ (strcat "\n*** FEHLER: Datei nicht gefunden: " fname))
      nil
    )
  )
)

;;; Funktion: Liest CSV mit Kopfzeile als Assoziationsliste
;;; fname - Dateiname
;;; Rueckgabe: Liste von Assoziationslisten
;;;
(defun CSV-LOADH (fname / data header rows row assoc-row i)
  (setq data (CSV-LOAD fname))
  (if data
    (progn
      (setq header (car data))
      (setq rows (cdr data))
      (setq result nil)
      (foreach row rows
        (setq assoc-row nil)
        (setq i 0)
        (foreach val row
          (if (< i (length header))
            (setq assoc-row
              (append assoc-row
                (list (cons (nth i header) val))))
          )
          (setq i (1+ i))
        )
        (setq result (append result (list assoc-row)))
      )
      result
    )
    nil
  )
)

;;; Hilfsfunktion: Wert aus Assoziationsliste holen
;;; key - Schluessel (Spaltenname)
;;; alist - Assoziationsliste einer Zeile
;;;
(defun CSV-GET (key alist)
  (cdr (assoc key alist))
)

(princ "\nCSVREAD.LSP geladen - CSV Funktionen bereit.")
(princ)
