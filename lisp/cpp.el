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



;; (define-skeleton cpp-one-off-skeleton
;;   "🦜 : Use this to show a series of something"
;;   nil
;;   > "BOOST_CHECK_EQUAL(b1."
;;   (setq s (skeleton-read "next: ")) ",b." s ");" \n
;;   )
(define-skeleton cpp-one-off-skeleton
  "🦜 : Use this to show a series of something"
  nil
  > "BOOST_CHECK_EQUAL(b1."
  (setq s (skeleton-read "next: ")) ",b." s ");" \n
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

;; (define-skeleton cpp-ostream-say
;;   "insert the cout << overloading"
;;   nil
;;   "friend ostream& operator<<(ostream& os, const "
;;   (setq c (skeleton-read "Class name ?"))
;;    "& " (substring c 0 1) "){" \n
;;   _ \n
;;   "return os;" \n
;;   "};")


(setq c-my-using-alist
      '(
        ("o" . "std::cout")
        ("e" . "std::endl")
        ("r" . "std::cerr")
        ("i" . "std::cin")
        ("v" . "std::vector")
        ("m" . "std::unordered_map")
        ("s" . "std::string")
        ("sv" . "std::string_view")
        ("of" . "std::ofstream")
        ("if" . "std::ifstream")
        ("bf" . "boost::format")
        ))

(define-skeleton cpp-boost-add-test-suite
  "Add a BOOST_AUTO_TEST_SUITE"
  nil
  "BOOST_AUTO_TEST_SUITE(" (skeleton-read "name:") ");" \n
  _ \n
  "BOOST_AUTO_TEST_SUITE_END();"
  )

(define-skeleton cpp-boost-add-test-case
  "Add a BOOST_AUTO_TEST_CASE"
  nil
  "BOOST_AUTO_TEST_CASE(" (skeleton-read "name:") "){" \n
  _ \n
  "}"
  )

(define-skeleton cpp-boost-add-fixture-test-case
  "Add a BOOST_FIXTURE_TEST_CASE"
  nil
  "BOOST_FIXTURE_TEST_CASE(" (skeleton-read "name:") "){" \n
  _ \n
  "}"
  )

(define-skeleton cpp-add-banner
  "Add a banner"
  nil
  "// " (skeleton-read "id:") " --------------------------------------------------" \n
  "// "_
  )

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
        ("sv" . "<string_view>")
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
        ("L" . "<boost/log/trivial.hpp>>")
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
(define-abbrev c++-mode-abbrev-table "bnnr" "" 'cpp-add-banner)

(define-abbrev c++-mode-abbrev-table "lg0" "" (lambda () (skeleton-insert '(nil "BOOST_LOG_TRIVIAL(trace) << format(\"" _ "\");"))))
(define-abbrev c++-mode-abbrev-table "lg1" "" (lambda () (skeleton-insert '(nil "BOOST_LOG_TRIVIAL(debug) << format(\"" _ "\");"))))
(define-abbrev c++-mode-abbrev-table "lg2" "" (lambda () (skeleton-insert '(nil "BOOST_LOG_TRIVIAL(info) << format(\"" _ "\");"))))
(define-abbrev c++-mode-abbrev-table "lg3" "" (lambda () (skeleton-insert '(nil "BOOST_LOG_TRIVIAL(warning) << format(\"" _ "\");"))))
(define-abbrev c++-mode-abbrev-table "lg4" "" (lambda () (skeleton-insert '(nil "BOOST_LOG_TRIVIAL(error) << format(\"" _ "\");"))))
(define-abbrev c++-mode-abbrev-table "beq" "" (lambda () (skeleton-insert '(nil "BOOST_CHECK_EQUAL(" _ ");"))))
(define-abbrev c++-mode-abbrev-table "bck" "" (lambda () (skeleton-insert '(nil "BOOST_CHECK(" _ ");"))))
(define-abbrev c++-mode-abbrev-table "bct" "" (lambda () (skeleton-insert '(nil "BOOST_CHECK_THROW(" _ ",std::exception);"))))
(define-abbrev c++-mode-abbrev-table "brq" "" (lambda () (skeleton-insert '(nil "BOOST_REQUIRE(" _ ");"))))
(define-abbrev c++-mode-abbrev-table "btm" "" (lambda () (skeleton-insert '(nil "BOOST_TEST_MESSAGE(" _ ");"))))
(define-abbrev c++-mode-abbrev-table "bth" "" (lambda () (skeleton-insert '(nil "BOOST_THROW_EXCEPTION(std::runtime_error(format(\"" _ "\")));"))))
(define-abbrev c++-mode-abbrev-table "btc" "" 'cpp-boost-add-test-case)
(define-abbrev c++-mode-abbrev-table "bts" "" 'cpp-boost-add-test-suite)
(define-abbrev c++-mode-abbrev-table "bfc" "" 'cpp-boost-add-fixture-test-case)

(define-abbrev c++-mode-abbrev-table "nx" "noexcept")
(define-abbrev c++-mode-abbrev-table "js" "json::")
(define-abbrev c++-mode-abbrev-table "rdb" "rocksdb::")
(define-abbrev c++-mode-abbrev-table "fs" "filesystem::")
(define-abbrev c++-mode-abbrev-table "st" "string")
(define-abbrev c++-mode-abbrev-table "sv" "string_view")
(define-abbrev c++-mode-abbrev-table "sb" "" (lambda () (skeleton-insert '(nil "std::begin(" _ ")"))))
(define-abbrev c++-mode-abbrev-table "se" "" (lambda () (skeleton-insert '(nil "std::end(" _ ")"))))
(define-abbrev c++-mode-abbrev-table "fmt" "" (lambda () (skeleton-insert '(nil "format(\"" _ "\")"))))
(define-abbrev c++-mode-abbrev-table "ccm" "" (lambda () (skeleton-insert '(nil "/*" _ "*/"))))

;; json::value_to...
(define-abbrev c++-mode-abbrev-table "vti" "" (lambda ()
                                                (skeleton-insert '(nil
                                                                   "value_to<uint64_t>(v.at(\"" _ "\"));"))))
(define-abbrev c++-mode-abbrev-table "vts" "" (lambda ()
                                                (skeleton-insert '(nil
                                                                   "value_to<string>(v.at(\"" _ "\"));"))))

;;a function that modifies the value of type V
(define-abbrev c++-mode-abbrev-table "fv" "void (*f)(V&)")

(define-key c++-mode-map (kbd "\C-c o") 'cpp-one-off-skeleton)
(define-key c++-mode-map (kbd "\C-c u") 'cpp-using-std)
(define-key c++-mode-map (kbd "\C-c w") 'cpp-add-my-lib)
(define-key c++-mode-map (kbd "\C-c i") 'cpp-include)
(define-key c++-mode-map (kbd "\C-c s") 'cpp-show-one-values)
(define-key c++-mode-map (kbd "\C-c b") 'cpp-boost-unit-test-boilerplate)


;; Fold all: folding-whole-buffer
;; (folding-add-to-marks-list 'c++-mode "#{{{" "#}}}" nil t)
