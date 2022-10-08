;;      Print to buffer
(print "hi" (get-buffer "*scratch*"))   ;"hi"

;;      Print to marker
(setq m (set-marker (make-marker)
                    1
                    (get-buffer "*scratch*"))) ;#<marker at 1 in *scratch*>
(print "oh" m)                                 ;"oh"
;;      Print to echo area
(print "hi" t)                          ;"hi"
standard-output                         ;t
(print "hi")                            ;"hi"

;;      Print to custom output
(setq last-output nil)                  ;nil
(defun eat-output (c)
  (setq last-output (cons c last-output))
  )                                     ;eat-output
(print "aabbcc" #'eat-output)           ;"aabbcc"
last-output                             ;(10 34 99 99 98 98 97 97 34 10)
(concat (nreverse last-output))         ;" \"aabbcc\" "
?\"                                     ;34
?\\                                     ;92
