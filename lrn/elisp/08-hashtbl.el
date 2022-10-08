;; the hash table

;; create empty hash table
(setq m (make-hash-table))

(puthash 1 "one" m)
(puthash 2 "two" m)
(puthash 3 "hi" m)                      ;"hi"
(remhash 3 m)                           ;nil

(if (setq v (gethash 2 m))
    (message (format "Value found to be %s" v))
  (message "Value not found")
  )
;; Map
(maphash (lambda (k v)
           (print (format "%5d %s" k v)))
         m)


;;      Additional key-word args
;;      Do not do the following:
(setq m2 (make-hash-table :test 'eq))
(puthash "hi" 1 m2)                     ;1
(puthash "hi" 2 m2)                     ;2
m2                                      ;#s(hash-table size 65 test eq rehash-size 1.5 rehash-threshold 0.8125 data ("hi" 1 "hi" 2))
(gethash "hi" m2)                       ;nil

;;      Size
(setq m3 (make-hash-table :size 5))
