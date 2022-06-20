
(keymapp cmake-mode-map)                ;t
(define-skeleton cmake-function
  "Insert a function"
  nil
  "function(" (skeleton-read "args?: ") ")" \n
  _ \n
  "endfunction()" \n
  )

(define-key cmake-mode-map (kbd "\C-c f")
  (lambda () nil (interactive) (insert "吃葡萄不吐葡萄皮")))

(when (boundp 'cmake-mode-abbrev-table)
  (clear-abbrev-table cmake-mode-abbrev-table))

(define-abbrev-table 'cmake-mode-abbrev-table
  '(
    ("hh" "hihi")
    ("func" "" cmake-function)
    ))


(setq skeleton-pair t)
;; (define-key cmake-mode-map "$" 'skeleton-pair-insert-maybe)

