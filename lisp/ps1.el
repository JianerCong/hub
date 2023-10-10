
(keymapp powershell-mode-map)
(define-key powershell-mode-map (kbd "\C-c f")
  (lambda () nil (interactive) (insert "吃葡萄不吐葡萄皮")))

(when (boundp 'powershell-mode-abbrev-table)
  (clear-abbrev-table powershell-mode-abbrev-table))

(define-abbrev-table 'powershell-mode-abbrev-table
  '(
    ("hh" "hihi")
    ("wh" "Write-Host")
    ;; ("wh" "" (lambda () (skeleton-insert '(nil "\\[" _ "\\]"))))
    ))


(setq skeleton-pair t)
;; (define-key powershell-mode-map "$" 'skeleton-pair-insert-maybe)

