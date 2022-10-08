(setq x 2 y 2)                          ;2

;; setq changes only loca; binding
(let ((x 3))
  (setq x 4)
  x)                                    ;4
x                                       ;2

;; Mannualy quote
(set 'x 3)                              ;3
x                                       ;3

;; 
