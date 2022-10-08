


(defun delete-and-handle-choice (s l)
  "handle the choice based on the string s. If s can be found in
the table l (an alist) then insert the coresponding value. return
s if not found."
  (delete-backward-char (length s))
  ;; If s is found in the alist, put the coresponding words.
  (if (assoc s l)
      (cdr (assoc s l))
    s
    )
  )

(provide 'delete-and-handle-choice)
