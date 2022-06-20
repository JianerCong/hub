(keymapp ess-mode-map)

(define-skeleton R-insert-a-series-of-env-get
  "Insert a series of . <- env_get(eee,\".\")"
  nil
  '(setq p  "Enter the next ")
  > (
     (skeleton-read "key: ") ;if this returns nil, finish loop
     str " <- env_get(eee,\"" str  "\")" \n
     )
  )

(define-skeleton R-insert-a-series-of-p
  "Insert a series of val <- p(.,.)"
  nil
  '(setq p  "Enter the next ")
  > (
     (skeleton-read "key: ") ;if this returns nil, finish loop
     "val <- p(\""
     str "\",\"" (skeleton-read "value: ")
     "\")" \n
     )
  )

(define-key ess-mode-map (kbd "\C-c f")
  (lambda () nil (interactive) (insert "吃葡萄不吐葡萄皮")))

(define-key ess-mode-map (kbd "\C-c v")
  (lambda () nil (interactive) (skeleton-insert '(nil "message(" _ ")")))
  )

(when (boundp 'ess-mode-abbrev-table)
  (clear-abbrev-table ess-mode-abbrev-table))

(define-abbrev-table 'ess-mode-abbrev-table
  '(
    ("libt" "library(tidyverse)")
    ("mylibr" "if (.Platform$OS.type == 'unix'){
  source('~/Templates/scripts/mylib.R')
}else{
  source('c:/Users/congj/AppData/Roaming/Templates/scripts/mylib.R')
}")
    ("func" "" (lambda () (skeleton-insert '(nil "function(" _ ")"))))
    ("tt" "TRUE")
    ("ff" "FALSE")
    )
  )


(setq skeleton-pair t)
;; (define-key ess-mode-map "$" 'skeleton-pair-insert-maybe)

