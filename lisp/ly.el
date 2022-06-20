
  (keymapp LilyPond-mode-map)
  (define-key LilyPond-mode-map (kbd "\C-c k")
    'LilyPond-big-comment
    )

  (when (boundp 'LilyPond-mode-abbrev-table)
    (clear-abbrev-table LilyPond-mode-abbrev-table))

  (define-abbrev-table 'LilyPond-mode-abbrev-table
    '(
      ("kk" "%% ")
      ))


(define-skeleton LilyPond-big-comment
  "a big comment block"
  nil
  > "%{" \n
  _ \n
  "%}"
  )
(setq skeleton-pair t)
(define-key LilyPond-mode-map "$" 'skeleton-pair-insert-maybe)

