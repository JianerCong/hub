;; Sequence

;; is sequence?
(sequencep [1 2])                       ;t
(sequencep "hi")                        ;t
(sequencep '(1 2))                      ;t
(sequencep (make-bool-vector 5 nil))    ;t

;; length
(length [1 2])                          ;2

;; index
(elt [1 2] 1)                           ;2

;; copy
(copy-sequence [1 2])                   ;[1 2]



;; misc
(reverse '(1 2 3))                      ;(3 2 1)

;; modify the original seq while reversing.
(nreverse '(1 2 3))                     ;(3 2 1)

;; Note: for vector and list only
(sort [2 3 1] '<)                          ;[1 2 3]
(sort ['(1 . a) '(3 . c) '(2 . b)]
      (lambda (x y) (< (car (eval x)) (car (eval y)))))
;;[(quote (1 . a)) (quote (2 . b)) (quote (3 . c)) ]

;; Return all but the first n element
(seq-drop '(a b c d) 2)                 ;(c d)
;; Return the first n element
(seq-take '(a b c d) 2)                 ;(a b)

;; keep taking/dropping from head until a condition returns nil
(seq-take-while (lambda (x) (< x 3)) [1 2 3 4]) ;[1 2]
(seq-drop-while (lambda (x) (< x 3)) [1 2 3 4]) ;[3 4]

;; for each
(seq-map #'1+ '(1 2 3))                 ;(2 3 4)
(seq-map #'symbol-name [hi oh])         ;("hi" "oh")
;; do for side effect
(seq-do (lambda (x) (message (format "hi %s" x))) '("a" "b"))
;; loop for index AND element
(seq-map-indexed (lambda (x i) (list i x)) '(a b c)) ;((0 a) (1 b) (2 c))

;; map for all sequences (ends with the shortest sequence)
(seq-mapn #'+ '(1 2) '(1 2))            ;(2 4)

;; filter
(seq-filter (lambda (x) (> x 0)) '(1 -1 2 -2)) ;(1 2)
;; reduce (call a binary function concesutively for a sequence with a initial value )
(seq-reduce #'+ [1 2 3] 0)              ;6

;; apply and return the first non-nil value.
;;      Does this sequence contains number ?
(seq-some #'numberp ["ab" 1 nil])       ;t
;;      What is that number?
(seq-find #'numberp ["ab" 1 nil 2])     ;1
;;      Find with default value.
(seq-find #'numberp ["a" nil] 2)        ;2
;;      Is all of them number?
(seq-every-p #'numberp [1 2 3])         ;t
;;      Is it empty?
(seq-empty-p "")                        ;t
;;      How many of them?
(seq-count (lambda (x) (> x 0)) [-1 0 1 2]) ;2

;;      Sort
(seq-sort #'> [2 1 3])                  ;[3 2 1]
;;      Sort by
(seq-sort-by #'seq-length #'> ["aa" "a" "aaa"]) ;["aaa" "aa" "a"]
;;      Contains?
(seq-contains '(x y) 'x)                ;x
;;      Equal set (Default uses equal)
(seq-set-equal-p '(x y)'(y x))          ;t
(seq-set-equal-p "hi" "ih")             ;t
(seq-set-equal-p '("a" "b") '("a" "b") #'eq) ;nil
;;      Find index
(seq-position '(a b c) 'b)              ;1
(seq-position '(a b c) 'd)              ;nil
;;      Find unique
(seq-uniq '(1 2 2))                     ;(1 2)
(seq-uniq '(1 2 1.0) )
;;      Find sub-sequence
(seq-subseq '(1 2 3 4) 1)               ;(2 3 4)
(seq-subseq '(1 2 3 4) 1 3)             ;(2 3)
(seq-subseq '(1 2 3 4) -3 -1)           ;(2 3)
;;      Concat
(seq-concatenate 'list [1 2] '(3 4) [5 6]) ;(1 2 3 4 5 6)
(seq-concatenate 'string "hi " "there")    ;"hi there"
;;      Map then concatenate
(seq-mapcat #'seq-reverse '((2 1) (4 3))) ;(1 2 3 4)
;;      Group by index
(seq-partition '(0 1 2 3 4) 2)            ;((0 1) (2 3) (4))
;;      Intersection/Difference
(seq-intersection [1 2 3] [2 3 4])      ;(2 3)
(seq-difference [1 2 3] [2 3 4])        ;(1)
;;      Group by
(seq-group-by #'integerp '(1 1.2 2 2.2)) ;((t 1 2) (nil 1.2 2.2))
(seq-group-by #'car '((a 1) (b 2) (c 3) (a 4)))
;; ((b (b 2)) (c (c 3)) (a (a 1) (a 4)))

;;      Convert sequence type
(seq-into [1 2 3] 'list)

;;      Max/Minimum number ?
(seq-min [2 1 3])                       ;1


;; Do-list
(dolist (x '(1 2))
  (message (format "Hi %d" x))
  )
;;      My Reverse
(let ((res nil))
  (dolist (x '(1 2) res)
    (setq res (cons x res))
    )
  )
;; (2 1)

(seq-doseq (x '(1 2))
  (message (format "Hi %d" x))
  )

;;      Multiple assignment(let) with sequence
(seq-let [a b] [1 2 3]
  (list a b))                           ;(1 2)

(seq-let (_ a _ b) '(1 2 3 4)
  (list a b))                           ;(2 4)
(seq-let [a b &rest others] [1 2 3 4]
  others)                               ;[3 4]

;;      Sample
(seq-random-elt [1 2 3])                ;1
