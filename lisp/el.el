;; elisp skeletons

(define-skeleton skeleton-skel
  "Interactive skeleton for writing skeletons."
  > "(define-skeleton " (skeleton-read "Skeleton name: ") \n
  > "\"" (skeleton-read "Docstring: ") "\""
  > ("Content line: " \n str) _ ")")

(define-skeleton skeleton-mode-boilder-plate
  "Insert some boilerplate mode for all mode customazation"
  nil
  '(setq s (skeleton-read "What's the mode name(e.g. c): "))
  (format
   "
  (keymapp %s-mode-map)
  (define-key %s-mode-map (kbd \"\\C-c f\")
(lambda () nil (interactive) (insert \"吃葡萄不吐葡萄皮\")))

  (when (boundp '%s-mode-abbrev-table)
    (clear-abbrev-table %s-mode-abbrev-table))

  (define-abbrev-table '%s-mode-abbrev-table
    '(
      (\"hh\" \"hihi\")
      ))


(setq skeleton-pair t)
(define-key %s-mode-map \"$\" 'skeleton-pair-insert-maybe)

" s s s s s s)


  )

(defun report (s)
  (message "Testing %s\n" (concat s (make-string (- 40 (length s)) ?-)))
  )

(define-skeleton elisp-say
  "say sth"
  >"(message " _ ")")

(define-skeleton elisp-insert-test-defun
  "Insert a test defun"
  "What is your defun to be tested: "
  > "(defun test-"str" ()"\n
  > "(report \"" str "\")"
  \n > _ \n ")"
  )


(fset 'elisp-comment-then-eval
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("\273" 0 "%d")) arg)))
(fset 'elisp-comment-eval-return
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([134217787 21 24 5 return] 0 "%d")) arg)))

(keymapp emacs-lisp-mode-map)
(define-key emacs-lisp-mode-map (kbd "\C-c\C-q") 'skeleton-skel)
(define-key emacs-lisp-mode-map (kbd "\C-c e") 'elisp-comment-eval-return)
(define-key emacs-lisp-mode-map (kbd "\C-c v") 'elisp-say)
(define-key emacs-lisp-mode-map (kbd "\C-c t") 'elisp-insert-test-defun)
(define-key emacs-lisp-mode-map (kbd "\C-c \C-s") 'skeleton-mode-boilder-plate)
(define-key emacs-lisp-mode-map (kbd "\C-c g") 'go-to-my-custom-group)

(clear-abbrev-table emacs-lisp-mode-abbrev-table)
(define-abbrev-table 'emacs-lisp-mode-abbrev-table
  '(
    ("ro" ";; ⇒")
    ("hd" ";;     ")
    ("pr" "print")
    ("fm" "format")
    )
  )

(define-abbrev emacs-lisp-mode-abbrev-table "2s"
  "" (lambda () nil (interactive)
       (skeleton-insert '(nil "(princ "_ ")")))
  )


(fset 'go-to-my-custom-group
      [?\M-x ?c ?u ?s ?t ?o backspace return ?i tab return ?G ?3 ?k return])
