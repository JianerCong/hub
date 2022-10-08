(defun load-buffer-init-file ()
  "Load initfile specific to the buffer"
  (interactive)
  (defun add-el (s)
    "append .el to string"
    (concat s ".el")
    )



  (defun get-file-extension (fname)
    "get the file extension"
    (last-list-object (split-string fname "[.]"))
    )



  (defun last-list-object (l)
    "return the last object in a list"
    (let (
	  (len (safe-length l))
	  )
      (nth (- len 1) l)
      )
    )

  (let*
      (
       (bn (buffer-name))
       (ext (get-file-extension bn))
       (f1 (add-el bn))
       (f2 (add-el (concat "./" ext)))
       (f3 (add-el (concat "../" ext)))
       (f4 (add-el (concat path-template ext)))
       )
    (cond
     ((file-exists-p f1) (load-file f1 ) (message f1 "is loaded"))
     ((file-exists-p f2) (load-file f2 ) (message f2 "is loaded"))
     ((file-exists-p f3) (load-file f3 ) (message f3 "is loaded"))
     ((file-exists-p f4) (load-file f4 ) (message f4 "is loaded"))
     (t (message "No approprate file for this buffer-name is found :< "))
     )

    )

  )

(global-set-key (kbd "<f5>") 'load-buffer-init-file)
;; Test-----------------------------------------------
;; (load-buffer-init-file)


;; (last-list-object '(1 2 3))
;; (get-file-extension "yah.txt")
;; (add-el "yah.txt")

(provide 'my-buffer-init)
