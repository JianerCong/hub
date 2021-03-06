;;      Ring : fixed-size container
(setq r (make-ring 2))                  ;(0 0 . [nil nil])
(ring-p r)                              ;t
(ring-insert r 2)                       ;2
(ring-empty-p r)                        ;nil
(ring-ref r 0)                          ;2
(ring-size r)                           ;2
(ring-length r)                         ;1
;;      Ring is first in first out(queue-like)
(ring-remove r)                         ;2
r                                       ;(0 0 . [nil nil])
(ring-insert-at-beginning r 1)          ;1
(ring-insert-at-beginning r 2)          ;2
r                                       ;(0 2 . [2 1])
(ring-insert-at-beginning r 3)          ;2
r                                       ;(1 2 . [2 3])


;;      Bool-vector
(setq b (make-bool-vector 3 nil))       ;#&3" "
(vconcat b)                             ;[nil nil nil]
(setq b2 (bool-vector t nil t))         ;#&3""
(vconcat (bool-vector-intersection b b2))
;; [nil nil nil]
