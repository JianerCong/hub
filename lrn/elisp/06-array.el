
;;      Is array?
(arrayp [1 2])                          ;t
(arrayp "hi")                           ;t
(arrayp (make-bool-vector 5 nil))       ;t
(arrayp '(1 2))                         ;nil

;;      Index
(aref [1 2 3] 1)                        ;2
;;      Set element
(setq a [1 2])                          ;[1 2]
(aset a 0 10)                           ;10
a                                       ;[10 2]

;;      Fill an array
(setq a (copy-sequence [a b c]))        ;[a b c]
(fillarray a 0)                         ;[0 0 0]
a                                       ;[0 0 0]
