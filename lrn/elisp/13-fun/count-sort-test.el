
(defun test-get-rand-vec ()
  (report "rand-vec")
  (setq l (get-rand-vec 5 10))
  (message "Should be 5, it is %d" (length l))
  (message "Should be smaller than 10 , it is %d" (seq-max l))
  )

(defun test-hist-bin ()
  (report "hist-bin")
  (message "Should be [0 2 1 0 2], it is %s"
           (princ  (hist-bin '(1 1 2 4 4) 5))
           )
  )

(defun test-accu ()
  (report "accu")
  (message "Should be [1 3 6], it's %s" (accu [1 2 3]))
  (message "Should be [1 3 5 9 9 12], it's %s" (accu [1 2 2 4 0 3]))
  )

(defun expect-equal (a b)
  (setq s (if (equal a b) "🐸" "😭"))
  (message "%s: Should be %s, it is %s" s (princ  a) (princ  b)
           )
  )

(defun test-count-sort ()
  (report "count-sort")
  (expect-equal [0 1 1 2 3] (count-sort [2 3 1 1 0] 4))
  (setq l (get-rand-vec 5 9))
  (expect-equal (vconcat (seq-sort `< l)) (count-sort l (1+ (seq-max l))))
  )

(test-get-rand-vec)
(test-hist-bin)
(test-accu)
(test-count-sort)

