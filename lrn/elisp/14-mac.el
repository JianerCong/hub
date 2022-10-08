;; Macro works on unevaluated expr
;; Try inline-function first


;; Example: replace (inc x) with (setq x (1+ x))
(defmacro inc (x)
  (list 'setq x (list '1+ x))
  )
(setq x 1)
(inc x)
x
(macrop 'inc)                           ;t
(eval (list 'setq 'x 1))
x

(macroexpand '(inc x))                  ;(setq x (1+ x))

;; We note that x is quoted -> passed to the macro
;; -> macro evaluated.

(defmacro inc2 (x)
  (list 'progn (list 'inc x) (list 'inc x))
  )
;; Expand all macro
(macroexpand-all '(inc2 x))             ;(progn (setq x (1+ x)) (setq x (1+ x)))


;; You can use ` to shorten the list syntex
(defmacro inc (x)
  `(setq x (1+ x))
  )

(macroexpand '(inc x))                  ;(setq x (1+ x))


;; Okay
(defmacro f (x)
  (list 'quote x))                      ;f
(f y)                                   ;y

;; Not Okay
(defmacro g (x)
  `(quote x))                           ;g
(g y)                                   ;x

;; Okay
(defmacro h (x)
  `(quote ,x))                          ;h
(h y)                                   ;y

;; Macro replace all x that needs to be eval, with the actual arguments

(defmacro report-value (x)
  `(progn
     (message "🐸 The value of %s : %s" (quote ,x) x)
     )
  )
(setq y 2)
(report-value y)                        ;"The value of y : 2"



