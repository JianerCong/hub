;; Implement the following `my-write-list-to-csv'
;; (setq l '(
;;           (x y z)
;;           (1 20 "hi")
;;           (2 30 "oh")
;;           (3 40 "gu")
;;           )
;;       )
;; (setq f "output.csv")
;; (my-write-list-to-csv l f)

(defun my-write-list-to-csv (l f)
  "Write a list to a csv file.
Each element of the list is a row. The first element `(car l)'
is the header.
"
  (defun main ()
    ;; If file exist prompt "Do you wanna overwrite it?"
    (if (file-exists-p f)
        (if (prompt-for-overwrite-the-file f)
            (progn
              (delete-file f)
              (message "File %s deleted" f)
              )
          (return nil)
          )
      )
    (go)
    (with-current-buffer (get-buffer f)
      (save-buffer)
      )
    (kill-buffer f)
    (message "CSV written to %s" f)
    t
    )
  (defun go ()
    (find-file-noselect f)
    (dolist (row l)
      (write-row-as-csv row f)
      )
    )
  (defun write-row-as-csv (row f)
    "Write the list row as csv to buffer f and
append a newline"
    (prin1 (car row) (get-buffer f))                   ;print the first value
    (dolist (val (cdr row))
      ;; For the rest of the row
      (write-char ?, (get-buffer f))
      (prin1 val (get-buffer f))
      )
    (terpri (get-buffer f))             ;Write \n
    )
  (defun prompt-for-overwrite-the-file (f)
    (setq ans
          (read-string "File %s already exists, overwrite? [y/n]")
          )
    (string-equal "y" (substring ans 0 1))
    )
  (main)
  )

(progn
  (defun test-my-write-list-to-csv ()
    (setq l '(
              (x y z)
              (1 20 "hi")
              (2 30 "oh")
              (3 40 "gu")
              )
          )
    (setq f "output.csv")
    (my-write-list-to-csv l f)
    )
  (test-my-write-list-to-csv)
  )
