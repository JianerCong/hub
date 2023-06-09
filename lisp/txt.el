;; the cmakes configs

(keymapp cmake-mode-map)

(define-skeleton cmake-boiler-plate
  "Insert the boiler plate"
  nil
  "cmake_minimum_required(VERSION 3.21)" \n
  "project(" (skeleton-read "Project name: ") " VERSION 1.1)" \n
  "add_executable(" _ ")"
  )

(define-skeleton cmake-boost-boiler-plate
  "A Boost unit test boiler plate"
  nil
  "cmake_minimum_required(VERSION 3.21)" \n
  "project(hi VERSION 1.1)" \n
  "find_package(Boost REQUIRED unit_test_framework) # add the executable" \n
  "add_executable(main test.cpp)" \n
  "target_link_libraries(main PUBLIC Boost::unit_test_framework)" \n
  "add_custom_target(run ALL main --log_level=all COMMENT \"Runing App 🐸\")"
)

(define-key cmake-mode-map (kbd "\C-c f")
  (lambda () nil (interactive) (insert "吃葡萄不吐葡萄皮")))

(define-key cmake-mode-map (kbd "\C-c m") 'cmake-boiler-plate)
(define-key cmake-mode-map (kbd "\C-c b") 'cmake-boost-boiler-plate)

(when (boundp 'cmake-mode-abbrev-table)
  (clear-abbrev-table cmake-mode-abbrev-table))

(define-abbrev-table 'cmake-mode-abbrev-table
  '(
    ("hh" "hihi")

    ("msg" "" (lambda () (skeleton-insert
                         '(nil "message(" _ ")")
                         )
                )
     )
    ))



