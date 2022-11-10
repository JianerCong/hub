(keymapp typescript-mode-map)                  ;t
(define-key typescript-mode-map (kbd "\C-c v") (lambda ()
                                          nil (interactive)
                                          (skeleton-insert '(nil "console.log(" _ ");"))))
(when (boundp 'typescript-mode-abbrev-table)
  (clear-abbrev-table typescript-mode-abbrev-table))

(define-abbrev-table 'typescript-mode-abbrev-table
  '(
    ("hh" "hihi")
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

(define-key typescript-mode-map "`" 'skeleton-pair-insert-maybe)
(define-key typescript-mode-map "$" 'skeleton-pair-insert-maybe)
(define-key typescript-mode-map "'" 'skeleton-pair-insert-maybe)
(define-key typescript-mode-map "<" 'skeleton-pair-insert-maybe)

(electric-pair-mode)
