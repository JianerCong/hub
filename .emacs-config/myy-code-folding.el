;;{{{ Folding mode Config

;; Hooks added in my-hooks.el
(if (require 'folding nil 'noerror)
    (folding-mode-add-find-file-hook)
  (message "Library `folding' not found"))

(global-set-key (kbd "\C-x n f") 'folding-shift-in)
(global-set-key (kbd "\C-x n o") 'outline-hide-other)

(defun my-folding-toggle-global ()
  "Show or hide all foldings"
  (interactive)
  (if my-folding-global
      (folding-open-buffer)
    (folding-whole-buffer)
    )
  (setq-default my-folding-global (not my-folding-global))
  )
(defvar my-folding-global t "Whether the buffer is folded")

;;}}}


(provide 'myy-code-folding)
