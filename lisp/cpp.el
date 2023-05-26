(load-file (concat path-template "c-shared.el"))

(define-skeleton cpp-boost-unit-test-boilerplate
  "Insert a boost-unit test"
  nil
  "#define BOOST_TEST_MAIN" \n
  "#include <boost/test/unit_test.hpp>" \n
 "BOOST_AUTO_TEST_CASE(test_1) {" \n
 "BOOST_CHECK(1 == 1);" \n
 "} // BOOST_AUTO_TEST_CASE(test_no_1)" \n
)

(define-skeleton cpp-show-one-values
  "insert a r.show(a,b,c)"
  nil
  '(setq p  "Enter the next ")
  > (
     (skeleton-read "value:")           ;if this returns nil, finish loop
     "s.show(" str ",\""
     (skeleton-read "name:") "\",\""
     (skeleton-read "unit:") "\");"
     \n
     )
  )

(define-skeleton cpp-ostream-say
  "insert the cout << overloading"
  nil
  "friend ostream& operator<<(ostream& os, const "
  (setq c (skeleton-read "Class name ?"))
   "& " (substring c 0 1) "){" \n
  _ \n
  "return os;" \n
  "};")

(define-skeleton cpp-say
  "say something "
  > "cout << " _  ";")

(define-skeleton cpp-say-err
  "say something to stderr"
  > "cerr << " _  ";")

(setq c-my-using-alist
      '(
        ("o" . "std::cout")
        ("e" . "std::endl")
        ("r" . "std::cerr")
        ("i" . "std::cin")
        ("v" . "std::vector")
        ("m" . "std::unordered_map")
        ("s" . "std::string")
        ("of" . "std::ofstream")
        ("if" . "std::ifstream")
        ("bf" . "boost::format")
        ))

(define-skeleton cpp-using-std
  "using std::something"
  " "
  '(setq p "Enter the next  (e.g. std::cout? ): " )
  > ((skeleton-read (concat p (alist-to-menu c-my-using-alist)))
     "using " str
     (delete-and-handle-choice str c-my-using-alist)
     ";" \n))

(setq cpp-my-includes-alist
      '(
        ("i" . "<iostream>")
        ("o" . "<cstdio>")
        ("s" . "<string>")
        ("v" . "<vector>")
        ("m" . "<unordered_map>")
        ("f" . "<fstream>")
        ("c" . "<cstdlib>")
        ("ct" . "<ctime>")
        ("ci" . "<cstdio>")
        ("ex" . "<stdexcept>")
        ("a" . "<algorithm>")
        ("f" . "<functional>")
        ("F" . "<boost/format.hpp>")
        )
      )

(define-skeleton cpp-include
  "insert some include directive"
  " "
  '(setq p  "Enter the next include (e.g. <iostream> or <stdio.h>). ")
  > ((skeleton-read (concat p (alist-to-menu cpp-my-includes-alist))) "#include "
     str
     (delete-and-handle-choice str cpp-my-includes-alist)
     \n)
  )

;; Most abbrev are defined in c-shared.el
(define-abbrev c++-mode-abbrev-table "vve" "" 'cpp-say-err)

;;a function that modifies the value of type V
(define-abbrev c++-mode-abbrev-table "fv" "void (*f)(V&)")

(define-key c++-mode-map (kbd "\C-c v") 'c-say)
(define-key c++-mode-map (kbd "\C-c o") 'cpp-ostream-say)
(define-key c++-mode-map (kbd "\C-c u") 'cpp-using-std)
(define-key c++-mode-map (kbd "\C-c w") 'cpp-add-my-lib)
(define-key c++-mode-map (kbd "\C-c i") 'cpp-include)
(define-key c++-mode-map (kbd "\C-c s") 'cpp-show-one-values)
(define-key c++-mode-map (kbd "\C-c b") 'cpp-boost-unit-test-boilerplate)


;; Fold all: folding-whole-buffer
;; (folding-add-to-marks-list 'c++-mode "#{{{" "#}}}" nil t)
