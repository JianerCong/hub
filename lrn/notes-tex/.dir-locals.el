;;; Directory Local Variables
;;; For more information see (info "(emacs) Directory Variables")

(
 (latex-mode . (
                (mode . LaTeX)
                (TeX-engine . luatex)
                (TeX-master . "m.tex")
                (TeX-command-extra-options . "-shell-escape")
                (TeX-parse-self . t)
                (TeX-auto-save . t)
                )
  )
 (LaTeX-mode . (
                (TeX-engine . luatex)
                (TeX-master . "m.tex")
                (TeX-command-extra-options . "-shell-escape")
                (TeX-parse-self . t)
                (TeX-auto-save . t)
                )
             )
 )


;; Local Variables:
;; mode: emacs-lisp
;; End:
