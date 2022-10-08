
(keymapp web-mode-map)                ;t


(define-key web-mode-map (kbd "\C-c v") (lambda ()
                                          nil (interactive)
                                          (skeleton-insert '(nil "console.log(" _ ")"))))

(when (boundp 'web-mode-abbrev-table)
  (clear-abbrev-table web-mode-abbrev-table))

(define-abbrev-table 'web-mode-abbrev-table
  '(
    ("hh" "hihi")
    ("vv" "" (lambda () (skeleton-insert '(nil "<view class=\"" _ "\"></view>"))))
    ))


(setq skeleton-pair t)                  ;t
(setq skeleton-pair-alist '(
                            ;; -1 means '(delete-char -1)
                            (?`  _ ?`)
                            (?$  ?{ _ ?})
                            ;; (?\( _ "''")
                            )
      )
(define-key web-mode-map "`" 'skeleton-pair-insert-maybe)
(define-key web-mode-map "$" 'skeleton-pair-insert-maybe)
(define-key web-mode-map "'" 'skeleton-pair-insert-maybe)

