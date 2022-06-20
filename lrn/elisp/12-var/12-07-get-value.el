(setq a 2)                              ;2
(symbol-value 'a)                       ;2

(let ((b 'a))
  (symbol-value 'b))                    ;a

(let ((b 'a))
  (symbol-value b))                     ;2

