(define-skeleton go-insert-function
  "insert a function"
  > "func " (skeleton-read "Function name: ") "("
  (skeleton-read "Args: ") ") " (skeleton-read "Return val(s): ") "{" \n
  > _ \n
  > "}"
  )

(define-skeleton go-insert-main
  "Insert the boil-plate "
  > "package main" \n \n
  > "import(" \n  > "\"fmt\"" \n > ")"\n \n
  > "func main(){" \n > _ \n > "}"
  )

(define-skeleton go-say
  "say th"
  > "fmt.Println(" _ ")")

(define-skeleton go-print
  "say th withour new line"
  > "fmt.Print(" _ ")")


(define-skeleton go-make-channel
  "Insert a chanel"
  > "make(chan " _ ")")

(define-skeleton go-switch
  "Insert a switch statement"
  > "switch " "{" \n
  > _ \n
  > "default:" \n
  > (skeleton-read "default: ") \n
  > "}"
  )

(define-skeleton go-err
  "handle the error"
  > "if err != nil{" \n > _ \n > "}"
  )

(define-skeleton go-struct
  "Insert a struct and a bracket"
  > "struct {" \n > _ \n "}"
  )

(define-skeleton go-case
  "Insert a case to be used in a switch statement."
  > "case " (skeleton-read "Case: ") ": "
  )

(define-key go-mode-map (kbd "\C-c f") 'c-doxygen-doc-this-file)
(define-key go-mode-map (kbd "\C-c m") 'go-insert-main)
(define-key go-mode-map (kbd "\C-c v") 'go-say)
(define-key go-mode-map (kbd "\C-c c") 'go-make-channel)
(define-key go-mode-map (kbd "\C-c p") 'go-print)
(define-key go-mode-map (kbd "\C-c d") 'c-doxygen-block-ready-to-Mj)


(load (concat path-template "do2-skl.el")) ;t


;; define abbrev for specific major mode
;; the first part of the name should be the value of the variable major-mode of that mode
;; e.g. for go-mode, name should be go-mode-abbrev-table

(when (boundp 'go-mode-abbrev-table)
  (clear-abbrev-table go-mode-abbrev-table))

(define-abbrev-table 'go-mode-abbrev-table
  '(
    ("im" "import")
    ("pk" "package")
    ("st" "string")
    ("uncat" "Uncategorized")
    ))

(define-abbrev go-mode-abbrev-table "sw" "" 'go-switch)
(define-abbrev go-mode-abbrev-table "ca" "" 'go-case)
(define-abbrev go-mode-abbrev-table "fun" "" 'go-insert-function)
;; (define-abbrev go-mode-abbrev-table "str" "" 'go-struct)
(define-abbrev go-mode-abbrev-table "qq" "" 'go-err)
(define-abbrev go-mode-abbrev-table "bb" "log.Fatal(err)")


(setq skeleton-further-elements '((abbrev-mode nil)))
(electric-pair-mode)
