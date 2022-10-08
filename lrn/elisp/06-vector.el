;; Vector is like number and string: eval gives the same content.
(eval [1 b [c]])                        ;[1 b [c]]

;; Is Vector?
(vectorp [1 2])                         ;t
(vectorp "hi")                          ;nil

;; Constructor
(vector 'a 2 "hi")                      ;[a 2 "hi"]
(make-vector 3 'Z)                      ;[Z Z Z]

;;      Concat
(vconcat '(a b) '(c d))                 ;[a b c d]
(vconcat [A B] "cd" '(e))               ;[A B 99 100 e]
