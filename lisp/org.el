;; active Babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (R . t)
   (shell . t)
   (python . t)
   ;; (emacs-lisp . t)
   )
 )

(defvar org-what-lang-is-for "csharp"
  "which code block to use"
  ) ; which code block to use

(define-skeleton org-insert-code-in-template
  "Insert the copied code into a code block in the buffer"
  nil
  "#+begin_src " org-what-lang-is-for \n
  '(yank) \n
  "#+end_src" \n
  )

;; Allow code be executed freely
(custom-set-variables '(org-confirm-babel-evaluate nil))

(keymapp org-mode-map)
(define-key org-mode-map (kbd "\C-c f") 'org-insert-code-in-template)

(when (boundp 'org-mode-abbrev-table)
  (clear-abbrev-table org-mode-abbrev-table))

(define-abbrev-table 'org-mode-abbrev-table
  '(
    ("hh" "hihi")
    ("ma" "" (lambda () nil (interactive)
               (skeleton-insert '(nil "\\(" _ "\\)")
                                )
               )
     )
    ))


(setq skeleton-pair t)
(define-key org-mode-map "~" 'skeleton-pair-insert-maybe)

