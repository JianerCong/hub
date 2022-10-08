
(load (concat path-template "alist-to-menu.el"))
(load (concat path-template "do2-skl.el")) ;t
(load (concat path-template "delete-and-handle-choice.el")) ;t
(load-file "~/Templates/lisp/c-shared.el")

(setq alist-to-menu-item-per-row 3)
(setq csharp-my-using-alist
      '(
        ("s" . "System")
        ;; ("i" . "System.Runtime.InteropServices")
        ;; ("c" . "System.ComponentModel")
        ("t" . "System.Threading")
        ;; ("rf" . "System.Reflection")
        ;; ("rs" . "System.Resources")
        ;; ("gl" . "System.Globalization")
        ("gr" . "System.Collections.Generic")
        ("l" . "System.Linq")
        ("i" . "System.IO")
        )
      )

(define-skeleton csharp-display-this
  "display something"
  nil
  >  "Console.WriteLine(\"" (setq s (skeleton-read "name:")) " is : {0}\", " s ");"
  )

(define-skeleton csharp-display-these
  "display something"
  nil
  >  ( (skeleton-read "name: ")
       "Console.WriteLine(\"" str " is : {0}\", " str ");" \n
       )
  )

(define-skeleton csharp-using-something
  "using something"
  " "
  '(setq p "Enter the next (e.g. cout? ): " )
  > ((skeleton-read (concat p (alist-to-menu csharp-my-using-alist)))
     "using " str
     (delete-and-handle-choice str csharp-my-using-alist)
     ";" \n))

(keymapp csharp-mode-map)
(define-key csharp-mode-map (kbd "\C-c f")
  (lambda () nil (interactive) (insert "吃葡萄不吐葡萄皮")))

(define-skeleton csharp-say
  "say sth"
  nil
  "Console.WriteLine(" _ ");"\n)


(define-skeleton csharp-print
  "say sth"
  nil
  "Console.Write(" _ ");"\n)

(define-skeleton csharp-insert-my_test-block
  "insert a block that will be run when MY_TEST is defined"
  nil
  "#if MY_TEST" \n
  _
  "#endif")

(define-key csharp-mode-map (kbd "\C-c v") 'csharp-say)
(define-key csharp-mode-map (kbd "\C-c p") 'csharp-print)
(define-key csharp-mode-map (kbd "\C-c u") 'csharp-using-something)
(define-key csharp-mode-map (kbd "\C-c y") 'c-paste-defun-header-here)
(define-key csharp-mode-map (kbd "\C-c d") 'csharp-display-these)
(define-key csharp-mode-map (kbd "\C-c t") 'csharp-insert-my_test-block)
(define-key csharp-mode-map (kbd "\C-c k") 'c-big-comment)


(when (boundp 'csharp-mode-abbrev-table)
  (clear-abbrev-table csharp-mode-abbrev-table))

(define-abbrev-table 'csharp-mode-abbrev-table
  '(
    ("hh" "hihi")
    ("qq" "Environment.Exit(1)")
    ("ea" "" (lambda () nil nil (skeleton-insert '(nil "throw new ArgumentException(" _ ");"))))
    ("thr" "" (lambda () nil nil (skeleton-insert '(nil "throw new " _ ";"))))
    ("fori" "" (lambda () nil nil (skeleton-insert
                                   '(nil
                                     > "for (int i=0;i<" (skeleton-read "Limit (e.g. N) : ") ";i++){" \n
                                     > _ \n
                                     > "}")
                                   )
                 )
     )
    )
  )
