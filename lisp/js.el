
(keymapp js2-mode-map)                  ;t
(define-key js2-mode-map (kbd "\C-c v") (lambda ()
                                          nil (interactive)
                                          (skeleton-insert '(nil "console.log(" _ ");"))))
(when (boundp 'js2-mode-abbrev-table)
  (clear-abbrev-table js2-mode-abbrev-table))

(define-abbrev-table 'js2-mode-abbrev-table
  '(
    ("cst" "const")
    ("th" "THREE")
    ("func" "" (lambda () (skeleton-insert '(nil "function(" _ ")"))))
    )) 

(setq skeleton-pair t)                  ;t
(setq skeleton-pair-alist '(
                            ;; -1 means '(delete-char -1)
                            (?`  _ ?`)
                            (?$  ?{ _ ?})
                            ;; (?\( _ "''")
                            )
      )

(define-key js2-mode-map "`" 'skeleton-pair-insert-maybe)
(define-key js2-mode-map "$" 'skeleton-pair-insert-maybe)
(define-key js2-mode-map "'" 'skeleton-pair-insert-maybe)

(electric-pair-mode)
