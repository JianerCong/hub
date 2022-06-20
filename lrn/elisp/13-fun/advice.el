;; Advising
(defun f (x)
  (* x 2))                              ;f
(defun g (x)
  (+ x 1))                              ;g
(advice-add 'f :filter-return #'g)      ;nil
;; Use g to filter the return value.
(f 3)                                   ;7
(advice-remove 'f #'g)                  ;nil
(f 3)                                   ;6

;; Call before me
(defun f ()
  (message "Have dinner"))              ;f
(defun g ()
  (message "Wash your hand first, then:")) ;g
(advice-add 'f :before #'g)                ;nil
(f)                                        ;"Have dinner"

;; Call around me
(defun f ()
  (message "\tint x = 2;\n\treturn 0; ")) ;f
(defun g (f &rest args)
  (message "int main(void){")
  (apply f args)
  (message "}"))                        ;g

(advice-remove 'f 'g)                   ;nil
(advice-add 'f :around #'g)             ;nil
(f)                                     ;"}"


;; Override
(defun m1 ()
  (message "Draw a card.")
  )

(defun m2 ()
  (message "Discard a card.")
  )

(advice-add 'm1 :override 'm2)          ;nil
(m1)                                    ;"Discard a card."
(advice-remove 'm1 'm2)                 ;nil
(m1)                                    ;"Draw a card."

;; Before while:
(defun m3 ()
  (message "Toss a coin: if face, invalid the effect.")
  (if (eq 1 (random* 2)) t nil)
  )                                     ;m3

(advice-add 'm1 :before-while 'm3)      ;nil
(m1)

;; You can also filter var and args

;; Primitive
(defun f () 1)                          ;f
(add-function :before (lambda () (message "Ho")) '(name "g" depth 0))

;; Hands-on advice-mapc: [failed with its lexical scoping rules.]
(progn
  (setq l  (list "风" "hua" "xue" "yue")) ;
  (defun f ()
    (message "俺のターン")
    )
  (let ((i 0))
    (defvar g nil)
    (setq g (lambda () (message (nth i l))))
    (advice-add 'f :after 'g)
    (f)
    )
  )
