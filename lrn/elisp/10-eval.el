;;      Self-evaluating form (non-list / symbol)

(numberp '1)                            ;t
(eval 1)                                ;1
(numberp ''1)                           ;nil

;;      Manually make expr
(setq s (list 'print (current-buffer))) ;(print #<buffer 10-eval.el>)
(eval s)                                ;#<buffer 10-eval.el>


;;      Evaluating a symbol gets its value
(setq x 1)                              ;1
(eval 'x)                               ;1
;; Note: variable whose name starts with : and t/nil are special. They are
;; self-evaluating
(eval ':hi)                             ;:hi
(eval 't)                               ;t

;;      List form
;; Function indirection
(symbol-function 'car)                  ;#<subr car>
(fset 'f 'car)                          ;car
(fset 'g 'f)                            ;f
(g '(1 2))                              ;1
(indirect-function 'g)                  ;#<subr car>

;;      Macro: expand before eval
(defmacro cadr (x)
  (list 'car (list 'cdr x)))            ;cadr
(cadr '(1 2))                           ;2
