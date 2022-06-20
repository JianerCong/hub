


(defun sql-make-skeleton-head (s1 &optional s2)
  "Make a skeleton of s1 _ ;. "
  (unless s2 (setq s2 ";"))
  (lexical-let ((s1 s1)
                (s2 s2)
                )
    #'(lambda ()
        (interactive)
        (skeleton-insert (list nil s1 " " '_ s2))
        )
    )
  ;; So the following defuns can retire

  ;; (define-skeleton sql-create-table
  ;;   "Create a table"
  ;;   nil
  ;;   "CREATE TABLE " _ ";")

  ;; (define-skeleton sql-drop-table
  ;;   "DROP a table"
  ;;   nil
  ;;   "DROP TABLE " _ ";")

  ;; (defun sql-select ()
  ;;   (skeleton-insert '(nil "SELECT" _ ";"))
  ;;   )
  )

(define-skeleton c-big-comment
  "a big comment block"
  nil
  > "/*" \n
  _ \n
  "*/"
  )

(fset 'sql-select (sql-make-skeleton-head "SELECT"))
(fset 'sql-create-table (sql-make-skeleton-head "CREATE TABLE"))
(fset 'sql-drop-table (sql-make-skeleton-head "DROP TABLE"))
(fset 'sql-say (sql-make-skeleton-head "SELECT " " msg;"))

(defun sql-make-skeleton (s1 s2 s3)
  "Make a tiny skeleton.
s1 is inserted at the front, s2 is the prompt string, s3 is
inserted after the prompt.
"
  (lexical-let ((s1 (concat s1 " "))
                (s2 s2)
                (s3 (concat " " s3 " "))
                )
    #'(lambda ()
       (skeleton-insert (list nil s1 (list 'skeleton-read s2)  s3 '_ ";"))
      )
    )
  ;; So the following defun can retire
  ;; (define-skeleton sql-select-from
  ;;   "SELECT sth"
  ;;   nil
  ;;   >"SELECT " (skeleton-read "Select what:")  " FROM " _ " ;")

  ;; (define-skeleton sql-insert-into
  ;;   "Insert a row"
  ;;   nil
  ;;   >"INSERT INTO " (skeleton-read "Table Name:") " VALUES " _ ";")
  )

(fset 'sql-select-from (sql-make-skeleton "SELECT" "What to select:" "FROM"))
(fset 'sql-insert-into (sql-make-skeleton "INSERT INTO" "Table Name:" "VALUES"))
(fset 'sql-update-set (sql-make-skeleton "UPDATE " "Table Name:" "SET"))

(fset 'f (sql-make-skeleton "f1" "f2" "f3"))
;; Worked

(fset 'sql-alter-table (sql-make-skeleton "ALTER TABLE" "Table name: " ""))


(when (boundp 'sql-mode-abbrev-table)
  (clear-abbrev-table sql-mode-abbrev-table))
(define-abbrev-table 'sql-mode-abbrev-table
  '(
    ("us" "" sql-update-set)
    ("sl" "" sql-select)
    ("sf" "" sql-select-from)
    ("ii" "" sql-insert-into)
    ("ct" "" sql-create-table)
    ("dt" "" sql-drop-table)
    ("at" "" sql-alter-table)
    ("pk" "PRIMARY KEY")
    ("tx" "TEXT")
    ("cr" "CONSTRAINT")
    ("ob" "ORDER BY")
    ("wh" "WHERE")
    ("sd" "SELECT DISTINCT")
    ("fr" "FROM")
    ("ij" "INNER JOIN")
    ("li" "LIKE")
    ("un" "UNION")
    ("ir" "INTERSECT")
    ("gb" "GROUP BY")
    ("hv" "HAVING")
    ("sint" "SMALLINT")
    ("unsi" "UNSIGNED")
    ("auic" "AUTO_INCREMENT")
    ("re" "REFERENCES")
    ("fk" "FOREIGN KEY")
    ("le" "LEFT")
    ("ri" "RIGHT")
    ("ca" "CASE")
    ("wn" "WHEN")
    ("th" "THEN")
    ("el" "ELSE")
    ("st" "START TRANSACTION;")
    ("sp" "SAVEPOINT")
    ("rs" "ROLLBACK TO SAVEPOINT")
    ("rb" "ROLLBACK")
    ("cm" "COMMIT;")
    )
  )

(fset 'sql-paste-output2
   [?\M-x ?t ?e ?x backspace backspace backspace ?f ?u ?n ?d ?a tab return ?p ?\M-x ?s ?q ?l ?- ?m ?o ?d ?e return ?` ?` ?V ?` ?` ?\C-x ?\C-\;])


(keymapp sql-mode-map)
(define-key sql-mode-map (kbd "\C-c f")
  (lambda () nil (interactive) (insert "吃葡萄不吐葡萄皮")))

(setq skeleton-pair t)
(define-key sql-mode-map "$" 'skeleton-pair-insert-maybe)
(define-key sql-mode-map (kbd "C-c p") 'sql-paste-output2)
(define-key sql-mode-map (kbd "C-c v") 'sql-say)
(define-key sql-mode-map (kbd "C-c k") 'c-big-comment)

