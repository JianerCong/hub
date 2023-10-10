
(keymapp python-mode-map)             ;t
(define-key python-mode-map (kbd "\C-c f")
  (lambda () nil (interactive) (insert "吃葡萄不吐葡萄皮"))
  )

(define-key python-mode-map (kbd "\C-c v")
  (lambda () nil (interactive) (skeleton-insert '(nil "print(" _ ")")))
  )

(when (boundp 'python-mode-abbrev-table)
  (clear-abbrev-table python-mode-abbrev-table))

(define-abbrev-table 'python-mode-abbrev-table
  '(
    ("rais" "" (lambda () nil (interactive)
                (skeleton-insert '(nil "raise Exception(" _ ")"))
                ))

    ("hdl" ""
     (lambda () nil (interactive)
       (skeleton-insert '(nil "def" _ "(self, endpoint: str, data: str) -> str:"))
                 ))
    ("mf" ""
     (lambda () nil (interactive)
       (skeleton-insert '(nil "if " _ " in metafunc.fixturenames:" \n "metafunc.parametrize"))
       )
     )
    ("ts" "test_")
    )
  )


(setq skeleton-pair t)
(define-key python-mode-map "$" 'skeleton-pair-insert-maybe)
