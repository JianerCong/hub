(read-from-string "(setq x 1) (setq y 2)") ;((setq x 1) . 10)
;;                 01234567890
;; The cons-cell is (val . next-index)
;; So we can use this info to consecutively read lisp-expression
(setq s "(setq x 1) (setq y 2) (setq z 3)") ;"(setq x 1) (setq y 2) (setq z 3)"
(setq out (read-from-string s))             ;((setq x 1) . 10)
(setq out (read-from-string s (cdr out)))   ;((setq y 2) . 21)
(setq out (read-from-string s (cdr out)))   ;((setq z 3) . 32)
(setq out (read-from-string s (cdr out)))   ;⇒ EOF

;; The default input stream (t means minibuffer)
standard-input                          ;t



