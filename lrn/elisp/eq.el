;; Use eq unless you are comparing sequences atomically or comparing floats.
(eq 1 1)                                ;t
(eq 'a 'a)                              ;t

(eq 1.0 1.0)                            ;nil
(equal 1.0 1.0)                            ;t
(eq ?a ?a)                              ;t

(eq "hi" "hi")                          ;nil
(equal "hi" "hi")                       ;t

(eq (point-marker) (point-marker))      ;nil
(equal (point-marker) (point-marker))      ;t

(eq '(1 (2)) '(1 (2)))                  ;nil
(equal '(1 (2)) '(1 (2)))                  ;t

(eq [1 2] [1 2])                        ;nil
(equal [1 2] [1 2])                        ;t

;; x and y are equal iff
;; (equal (car x) (car y))
;; (equal (cdr x) (cdr y))


(eql 'a 'a)                             ;t
(eql 1.0 1.0)                           ;t
(eql "hi" "hi")                         ;nil
(eql [1 2] [1 2])                       ;nil
