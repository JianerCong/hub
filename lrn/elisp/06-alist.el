;; Association list (alist)

;; Look up (default testing equality with equal)
(setq l '((a . A)
          (b . B)
          (c . C)))                     ;((a . A) (b . B) (c . C))
(assoc 'a l)                            ;(a . A)
(cdr (assoc 'a l))                      ;A
(assoc 'd l)                            ;nil
;; look-up with default value
(alist-get 'd l 'DEFAULT)               ;DEFAULT


;; change equal function
(assoc 'a l 'eq)                     ;(a . A)

;; Inverse look up
(rassoc 'A l)                           ;(a . A)

;; 2-level deep copy
(copy-alist l)                          ;((a . A) (b . B) (c . C))

;; delete all entries with a key
(assq-delete-all 'a
                 '((a . A) (b . B)
                   (c .C) (a . D)))      ;((b . B) (c \.C))

;; alist as an environment
(setq l '((a . 1) (b . 2)))             ;((a . 1) (b . 2))
(let-alist l
  (message (format ".a is bind to %d and .b to %d" .a .b))
  )                                     ;".a is bind to 1 and .b to 2"
