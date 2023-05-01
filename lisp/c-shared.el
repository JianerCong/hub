
(define-skeleton c-insert-test-block
  "insert a block that will be run when TEST is defined"
  nil
   "#ifdef TEST" \n
  _ \n
   "#endif")

(define-skeleton c-say
  "say something "
  > "printf(\"" _ "\");")


(define-skeleton c-big-comment
  "a big comment block"
  nil
  > "/*" \n
  _ \n
  "*/"
  )

(define-skeleton c-insert-debug-block
  "insert a block that will be run when DEBUG is defined"
  nil
   "#ifdef DEBUG" \n
   "#define P(...) printf(__VA_ARGS__)" \n
   "#endif")

(define-skeleton c-define-PAUSE
  "Define the PAUSE macro"
  nil
  "#ifdef _WIN32" \n
  "#include <windows.h>" \n
  "#else" \n
  "#include <unistd.h>" \n
  "#endif" \n
  "#ifdef _WIN32" \n
  "#define PAUSE cout.flush(); Sleep(100)" \n
  "#else" \n
  "// sleep for 5e5 micro secs" \n
  "#define PAUSE cout.flush(); usleep(1e5)" \n
  "#endif" \n
  )

(define-skeleton c-insert-main-function
  "insert the int main(void)"
  > "int main(int argc, char *argv[]){" \n > _ \n "return 0;" \n > "}")


(defun delete-and-handle-choice (s l)
  "handle the choice based on the string s. If s can be found in
the table l (an alist) then insert the coresponding value. return
s if not found."
  (delete-backward-char (length s))
  ;; If s is found in the alist, put the coresponding words.
  (if (assoc s l)
      (cdr (assoc s l))
    s
    )
  )

(load (concat path-template "alist-to-menu.el")) ;t
(load (concat path-template "do2-skl.el")) ;t
(load (concat path-template "delete-and-handle-choice.el")) ;t



(define-skeleton c-insert-void-test-function
  "Insert a void function named test()."
  nil
  > "void test_" (setq s (skeleton-read "What function to test: ")) "()"
  > "{" \n "report(\"" s "\");" \n _ "}")


(defun c-paste-defun-header-here ()
  "Paste the copied text here and append an ';'
   can be used to make header"
  (interactive)
  (yank)
  (delete-backward-char 1)
  (if (looking-back "{")
      (delete-backward-char 1)
      )
  (insert ";")
  )

(define-skeleton c-header-rule
  "insert a header rule-------"
  > (let* (
            (x (skeleton-read "Enter your header :"))
            (l (length x))
            (len-of-rule (- 50 l))
            )
       (concat "// " x " " (make-string len-of-rule ?-))
       )
  \n > _ \n
  > (concat "//  --------------------------------------------------") \n
  )

(define-skeleton c-if-windows
  "Insert windows-specific conditions"
  nil
  "#ifdef _WIN32" \n
  > \n
  "#else" \n
  > _ \n
  > "#endif")


(defun define-for-c++-and-c (key cmd)
  "Define key for both c and c++ mode"
  (define-key c-mode-map (kbd key) cmd)
  (define-key c++-mode-map (kbd key) cmd)
  )


(define-for-c++-and-c "\C-c d" 'c-doxygen-block-ready-to-Mj)
(define-for-c++-and-c "\C-c p" 'c-define-PAUSE)
(define-for-c++-and-c "\C-c g" 'c-insert-debug-block)
(define-for-c++-and-c "\C-c f" 'c-doxygen-doc-this-file)
(define-for-c++-and-c "\C-c t" 'c-insert-test-block)
(define-for-c++-and-c "\C-c m" 'c-insert-main-function)
(define-for-c++-and-c "\C-c y" 'c-paste-defun-header-here)
(define-for-c++-and-c "\C-c 1" 'c-insert-void-test-function)
(define-for-c++-and-c "\C-c r" 'c-header-rule)
(define-for-c++-and-c "\C-c w" 'c-if-windows)

;;Abrev--------------------------------------------------

(when (boundp 'c-mode-abbrev-table)
  (clear-abbrev-table c-mode-abbrev-table))
(when (boundp 'c++-mode-abbrev-table)
  (clear-abbrev-table c++-mode-abbrev-table))

(define-abbrev-table 'c-mode-abbrev-table
  '(
    ("hic" "Hello C")
    ))

(define-abbrev-table 'c++-mode-abbrev-table
  '(
    ("tt" "template<T>")
    ))

(defun define-abbrev-for-c++-and-c (pair)
  "add the key expansion pair to both c++ and c
abbrev table"
  (let (
        (key (car pair))
        (expansion (cdr pair))
        )
    (message (format "Adding for key : %s expansion : %s\n" key expansion))
    (define-abbrev c-mode-abbrev-table key expansion)
    (define-abbrev c++-mode-abbrev-table key expansion)
    )
  )



;; (define-abbrev-for-c++-and-c '("hh" . "hhhhh"))
;; Add common abbrev here
(setq c-c++-common-abbrev
      '(
        ("tpd" . "typedef")
        ("nl" . "NULL")
        ("il" . "<!")
        ("cn" . "const")
        ("sz" . "size_t")
        ("pr" . "@param")
        ("cr" . "char")
        ("vd" . "void")
        ("db" . "double")
        ;; ("def" . "define")
        ("lv" . "exit(EXIT_FAILURE);")
        ))

(mapcar 'define-abbrev-for-c++-and-c c-c++-common-abbrev)

