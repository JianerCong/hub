(define-skeleton mp-fig
  "Insert a figure env"
  > "beginfig(" (skeleton-read "figure number : ") ");" \n
  > _  "\nendfig;"
  )

(load (concat path-template "delete-and-handle-choice.el")) ;t
(setq mp-shorthand-alist
      '(
        ("o" . "origin")
        ))

(define-skeleton mp-draw-line
  "draw a line"
  > "draw " (skeleton-read "First point: ")
  ((skeleton-read "More Points:") " -- " str ) ";"
  )

(define-skeleton mp-draw-dot
  "Draw a dot"
  > "drawdot " _ ";")

(define-skeleton mp-tex-label
  "Insert a tex string"
  nil
  "btex " _ " etex")

(define-skeleton mp-for
  "a for construct"
  > "for " (skeleton-read "Condition: ") ":" \n
  > _ \n
  > "endfor")

(define-skeleton mp-group
  "Insert a group"
  > "begingroup" \n
  > _ \n
  > "endgroup")

(define-skeleton mp-def
  "Insert a def"
  > "def " _ \n
  > "enddef;")

(define-skeleton mp-boilerplates
  "Insert some configs"
  > "prologues := 3;" \n
  > "outputtemplate := \"%j-%c.mps\";" \n
  > "outputformat := \"svg\";" \n \n
  > "beginfig(1);" \n
  > _ 
  "\nendfig;\nend")


(fset 'mp-add-unit
      (kmacro-lambda-form [?\C-\M-% ?\\ ?\( ?, ?\\ ?| ?\) ?\\ ?\) return ?* ?u ?\\ ?1 return ?!] 0 "%d"))

(keymapp metapost-mode-map)             ;t
(define-key metapost-mode-map (kbd "\C-c f") 'mp-fig)
(define-key metapost-mode-map (kbd "\C-c b") 'mp-boilerplates)
(define-key metapost-mode-map (kbd "\C-c u") 'mp-add-unit)

(when (boundp 'metapost-mode-abbrev-table)
  (clear-abbrev-table metapost-mode-abbrev-table))

(define-abbrev-table 'metapost-mode-abbrev-table
  '(
    ("hh" "hihi")
    ("u=" "u = 1cm;\n")
    ))


(define-abbrev metapost-mode-abbrev-table "dl" "" 'mp-draw-line)
(define-abbrev metapost-mode-abbrev-table "dd" "" 'mp-draw-dot)
(define-abbrev metapost-mode-abbrev-table "fr" "" 'mp-for)
(define-abbrev metapost-mode-abbrev-table "tx" "" 'mp-tex-label)
(define-abbrev metapost-mode-abbrev-table "dtl" "dotlabel.")
(define-abbrev metapost-mode-abbrev-table "def" "" 'mp-def)
(define-abbrev metapost-mode-abbrev-table "grp" "" 'mp-group)

;; Change width
(define-abbrev metapost-mode-abbrev-table "chwd" "pickup pencircle scaled ")

(setq skeleton-pair t)                  ;t
(setq skeleton-pair-alist '(
                            ;; -1 means '(delete-char -1)
                            (?\" -1 ?` ?` _ "''")
                            )
      )
(define-key metapost-mode-map "$" 'skeleton-pair-insert-maybe)
