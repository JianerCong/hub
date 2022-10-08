(buffer-modified-p)                         ;t
(set-buffer-modified-p (buffer-modified-p)) ;nil

;;      Read only
buffer-read-only                        ;nil
inhibit-read-only                       ;nil

;; Throw error is buffer is read only
(barf-if-buffer-read-only)              ;nil


;;      buffer list
(buffer-list)                           ;(#<buffer 27-5-buff-misc.el> #<buffer  *Minibuf-1*> #<buffer *spacemacs*> #<buffer *scratch*> #<buffer  *Minibuf-0*> #<buffer *Messages*> #<buffer  *code-conversion-work*> #<buffer  *Echo Area 0*> #<buffer  *Echo Area 1*> #<buffer  *which-key*> #<buffer *helm-mode-spacemacs/rename-current-buffer-file*>)

(mapcar #'buffer-name (buffer-list))    ;("27-5-buff-misc.el" " *Minibuf-1*" "*spacemacs*" "*scratch*" " *Minibuf-0*" "*Messages*" " *code-conversion-work*" " *Echo Area 0*" " *Echo Area 1*" " *which-key*" "*helm-mode-spacemacs/rename-current-buffer-file*")


;; Special buffers
(other-buffer)                          ;#<buffer *spacemacs*>
(last-buffer)                           ;#<buffer *Messages*>
;; Put a buffer to the end of the list.
(bury-buffer "*scratch*")               ;nil
;; Switch to the last buffer in the list
(unbury-buffer)

;; Functions to be run when buffer-list get updated.
buffer-list-update-hook                 ;nil


;;      Swap buffer content
(with-current-buffer (get-buffer-create "hi")
  (insert "oh")
  (buffer-string))                      ;"oh"

(with-current-buffer (get-buffer-create "oh")
  (insert "hi")
  (buffer-string))                      ;"hi"

(with-current-buffer "hi"
  (buffer-swap-text (get-buffer "oh"))
  (buffer-string))                      ;"hi"


