;; Challenge: Read a spac-dilimited file into list
" Contents in hi.txt
x y z
1 1.1 \"a\"
2 2.2 \"b\"
"
(setq row '())

;; Load the file
(defun experiment ()
  (progn
    (find-file-noselect "hi.txt")           ;#<buffer hi.txt>
    (setq m (set-marker (make-marker)
                        1
                        (get-buffer "hi.txt"))) ;#<marker at 1 in hi>
    (while (setq x
                 (read m)
                 )
      (message "Value read : %s" x)
      )
    )
  "
Value read : x
Value read : y
Value read : z
Value read : 1
Value read : 1.1
Value read : a
Value read : 2
Value read : 2.2
Value read : b
"
  )

(defun read-space-delimited-file (filename)
  "Read the space-delimited file `filename'"
  (setq table '())
  (setq ncol 3)
  (setq nrow 2)
  (find-file-noselect "hi.txt")           ;#<buffer hi.txt>
  (setq m (set-marker (make-marker) 1
                      (get-buffer filename))) ;#<marker at 1 in hi>
  (defun main ()
    (dotimes (i (1+ nrow))
      (message "Getting %d th row" i)
      (push (get-row ncol) table)
      )
    table
    )
  (defun get-row (ncol)
    (message "Getting row of %d" ncol)
    (setq row '())
    (dotimes (i ncol)
      (setq v (read m))
      (message "Value read %s" v)
      (push v row)
      )
    row
    )
  (main)
  )
(setq l (read-space-delimited-file "hi.txt"))
l                                       ;(("b" 2.2 2) ("a" 1.1 1) (z y x))
