(org-babel-do-load-languages
  'org-babel-load-languages
  '(
     (R . t)
   )
  )

;; do not ask for elisp
(defun my-org-confirm-babel-evaluate (lang body)
  (not (string= lang "emacs-lisp")))
(setq org-confirm-babel-evaluate #'my-org-confirm-babel-evaluate)

(provide 'my-org-config)
