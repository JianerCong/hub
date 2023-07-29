;;      Sequencing

;; Eval all and return last
(progn (print "hi")
       (print "oh"))                    ;"oh"

;; Eval all and return first
(prog1 (print "hi")
  (print "oh"))                    ;"hi"

;; If
(if nil 'yes 'no)                       ;no
;; If a condition met, do following
;; Equivalent to (if cond (progn a b c) nil)
(when t (print "hi") (print "oh"))

;; Equivalent to (if <cond> nil <body>)
;;🦜 : = (if-not ...)
(unless nil (print "hi"))  ;"hi"
;;          ^^^ called when false

;; cond
(setq x -2)                             ;-2
(cond ((> x 1) "OK")
      ((> x 0) "Fine")
      (t "NOT Okay")
      )                                 ;"NOT Okay"

;; and | or
(and 1 2 nil)                           ;nil
(or 1 2 nil)                            ;1
