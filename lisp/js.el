
(keymapp js2-mode-map)                  ;t
(define-key js2-mode-map (kbd "\C-c v") (lambda ()
                                          nil (interactive)
                                          (skeleton-insert '(nil "process.stdout.write(" _ ");"))))
(when (boundp 'js2-mode-abbrev-table)
  (clear-abbrev-table js2-mode-abbrev-table))

(define-abbrev-table 'js2-mode-abbrev-table
  '(
    ("hh" "hihi")
    )) 
