;; Quote
(quote x)                               ;x
'x                                      ;x

;; Backquote partially eval.
'(a (+ 1 1) b)                          ;(a (+ 1 1) b)
`(a (+ 1 1) b)                          ;(a (+ 1 1) b)
`(a ,(+ 1 1) b)                        ;(a 2 b)

;; splice (deprac operator) eval-then-flatten.
(setq l '(1 2))                         ;(1 2)
`(0 ,@l 3 ,@l)                          ;(0 1 2 3 1 2)

;; Mutable
(list '+ 1 2)                           ;(+ 1 2)
;; Immutable
'(+ 1 2)                                ;(+ 1 2)


