;; Create buffer
(get-buffer-create "hi")                ;#<buffer hi>
(buffer-list)                           ;(#<buffer 27-9-create-buff.el> #<buffer  *Minibuf-1*> #<buffer 27-5-buff-misc.el> #<buffer *scratch*> #<buffer *spacemacs*> #<buffer  *Minibuf-0*> #<buffer *Messages*> #<buffer  *code-conversion-work*> #<buffer  *Echo Area 0*> #<buffer  *Echo Area 1*> #<buffer  *which-key*> #<buffer hi> #<buffer *helm find files*>)

;; Get buffer while checking naming conflicts.
(generate-new-buffer "hi")              ;#<buffer hi<2>>

;; Kill
(kill-buffer "hi")                      ;t
kill-buffer-query-functions             ;(process-kill-buffer-query-function)
kill-buffer-hook                        ;(evil-swap-out-markers auto-revert-notify-rm-watch t)
(buffer-live-p "hi")                    ;nil
buffer-save-without-query               ;nil
