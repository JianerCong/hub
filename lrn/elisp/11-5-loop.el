
(setq n 0)                              ;0
(while (< n 4)
  (print (format "Loop %d" n))
  (setq n (1+ n))
  )                                     ;nil

(dotimes (i 3)
  (print (format "Hi %d" i)))
;; 0,1,2
