;; Generate a series of numbers
(number-sequence 4 9) ; ⇒ (4 5 6 7 8 9)
(number-sequence 8)  ; ⇒ (8)
(number-sequence 9 4 -1) ; ⇒ (9 8 7 6 5 4)


;; Append
(append '(x y) 'z) ; ⇒ (x y . z)
(append '(x) '(y z)) ; ⇒ (x y z)
(append [a b] "cd" nil)                 ; ⇒ (a b 99 100)
;; nconc behaves like append but it dosen't copy:
(nconc '(1 2) '(3 4))                   ;(1 2 3 4)


;;Modifying list
(setq l '(a b))                         ; ⇒ (a b)
(push 'c l)                             ; ⇒ (c a b)

;; List as set
(add-to-list 'l 'd)                     ;(d c a b)
;; adding existing element to list hase effect
(add-to-list 'l 'c)                     ;(d c a b)

;; contains ? (returns the sublist that start with the specified object, returns
;; nil if not found{like the strchar() in C}). This function uses eq to test equality
(memq 'b '(a b c))                      ;(b c)
;; use memql for numbers (e.g. uses eql to test equality)
(memql 1.2 '(1.1 1.2 1.3))              ;(1.2 1.3)
;; use member to test with (equal)
(member '(2) '((1) (2)))            ;((2))
(member "oh" '("hi" "oh"))          ;("oh") 

;; Remove all that eq to an object.
(delq 'b '(a b d b))                    ;(a d)
;; Remove all that equal to an object. (destuctive)
(delete "hi" '("hi" "oh" "hi"))         ;("oh")
;; Use remove to create a copy
(setq l '("hi" "oh"))                   ;("hi" "oh")
(remove "hi" l)              ;("oh")
l                            ;("hi" "oh")
(delete "hi" l)              ;("oh")
l                            ;("hi" "oh")
;; remove can also fo any sequence (e.g. array, string)
(remove '(2) [(2) (1) (2)])             ;[(1)]
;; Test membership case-insensitively
(member-ignore-case "oh" '("HI" "OH" "HI")) ;("OH" "HI")

;; Use following to remove sth from a list .
(setq l '(a b))                         ;(a b)
(setq l (delq 'b l))                    ;(a)
;; REmove duplicates that are (equal)
(delete-duplicates '(a b a))   ;(b a)


;; Add to ordered list
(setq l '())
;; add a at position 1
(add-to-ordered-list 'l 'a 1)           ;(a)
(add-to-ordered-list 'l 'c 3)           ;(a c)
(add-to-ordered-list 'l 'b 2)           ;(a b c)
;; Change the position of b
(add-to-ordered-list 'l 'b 4)           ;(a c b)


;; Change element in lists.
(setq x (list 1 2))                     ;(1 2)
(setcar x 4)
x                                       ;(4 2)
(setcdr x '(3))                         ;(3)
x                                       ;(1 3)

