;; the cmakes configs

(keymapp cmake-mode-map)

(define-skeleton cmake-boiler-plate
  "Insert the boiler plate"
  nil
  "cmake_minimum_required(VERSION 3.21)" \n
  "project(" (skeleton-read "Project name: ") " VERSION 1.1)" \n
  "add_executable(" _ ")"
  )

(define-key cmake-mode-map (kbd "\C-c f")
  (lambda () nil (interactive) (insert "吃葡萄不吐葡萄皮")))

(define-key cmake-mode-map (kbd "\C-c m")
  'cmake-boiler-plate)

(when (boundp 'cmake-mode-abbrev-table)
  (clear-abbrev-table cmake-mode-abbrev-table))

(define-abbrev-table 'cmake-mode-abbrev-table
  '(
    ("hh" "hihi")
    ))



