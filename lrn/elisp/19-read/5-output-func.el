;;      PrintLine
standard-output                         ;t
(let (
      (standard-output (current-buffer))
      )
  (progn (print 'The\ cat\ in)
         (print "the hat")
         (print "is back")
         )
  )
;; The\ cat\ in

;; "the hat"

;; "is back"

;;      See that a newline is inserted after each statement
;;      Use prin1 to avoid newline
(let (
      (standard-output (current-buffer))
      )
  (progn (prin1 'The\ cat\ in)
         (prin1 " the hat")
         (prin1 " is back")
         )
  )
;; The\ cat\ in" the hat"" is back"

;;      Use princ to print for human
(let (
      (standard-output (current-buffer))
      )
  (progn (princ 'The\ cat\ in)
         (princ " the hat")
         (princ " is back")
         )
  )
;; The cat in the hat is back


;;      Write a char

(let (
      (standard-output (current-buffer))
      )
  (write-char ?a)
  (terpri) ;print a newline
  (write-char ?b)
  (terpri)
  (write-char ?c)
  )
;; a
;; b
;; c

;;      Print to string
(prin1-to-string 'hi) ;"hi"
(prin1-to-string (mark-marker)) ;"#<marker at 932 in 5-output-func.el>"
(prin1-to-string "hi")          ;"\"hi\""
;;      No-escape = ture
(prin1-to-string "hi" t) ;"hi"

;; Print nicely

(let (
      (standard-output (current-buffer))
      )
  (pp '(1 2 (3 4 (5) 6) 7 8))
  )
;; (1 2
;;    (3 4
;;       (5)
;;       6)
;;    7 8)

