(setq m (make-char-table 'number 0))    ;#^[0 nil number 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]


(char-table-p m)                        ;t
(char-table-subtype m)                  ;number
(setq n (make-char-table 'number 0))
(set-char-table-parent m n)             ;#^[0 nil number 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
(char-table-parent m)                   ;#^[0 nil number 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]


;; Extra slots are specified by the subtype.
;;      Each display table has 6 slots.
(symbol-plist 'display-table)           ;(char-table-extra-slots 6)
(setq n (make-char-table 'display-table 0)) ;#^[0 nil display-table 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
(set-char-table-extra-slot n 0 2)           ;2
(char-table-extra-slot n 0)                 ;2

;; set and get
(aset n ?a 1)                           ;1
(aset n ?b 2)                           ;2
(aref n ?a)                             ;1

;;      Get a range
(char-table-range n '(?a . ?c))         ;1

;;      Map for all non-nil entries.
;;      Always returns nol, for side-effects only.
(map-char-table (lambda (k v)
                  (if (consp k)
                      (print (format "key %c ~ %c : value %g" (car k) (cdr k) v))
                    (print (format "key %c: value %g" k v)))
                      )
                n)
;; nil
