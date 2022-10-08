(require 'ox-latex)
org-latex-listings-options              ;nil
org-latex-minted-options                ;nil

(setq org-export-latex-listings 'minted)               ;minted
(add-to-list 'org-latex-packages-alist '("" "minted")) ;(("" "minted"))
org-latex-packages-alist                ;nil


(setq org-latex-listings 'minted)
(setq org-latex-custom-lang-environments
      '(
        (emacs-lisp "common-lispcode")
        ))
(setq org-latex-minted-options
      '(("frame" "lines")
        ("fontsize" "\\scriptsize")
        ("linenos" "")))
