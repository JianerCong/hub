(setq hippie-expand-try-function-list '(try-expand-debbrev
					try-expand-debbrev-all-buffers
					try-expand-debbrev-from-kill
					try-complete-file-name-partially
					try-complete-file-name
					try-expand-all-abbrevs
					try-expand-list
					try-expand-line
					try-complete-lisp-symbol-partially
					try-complete-lisp-symbol))

;; -*- coding: utf-8; lexical-binding: t; -*-
;; sample use of abbrev

(clear-abbrev-table global-abbrev-table)

(define-abbrev-table 'global-abbrev-table
  '(
    ;; programing
    ("rt" "return" )
    ("sth" "something" )

    ;; ("str" "string" )
    ("stru" "struct" )
    ("ifc" "interface")
    ("ra" "⇒")
    ;; regex
    ("xaz" "\\([A-Za-z0-9]+\\)" )
    ;; unicode
    ("hr" "--------------------------------------------------" )
    ("eface" "◉_◉")
    ("ecry" "😭")
    ("ethk" "🤔")
    ("ehan" "😓")
    ("efrog" "🐸")
    ("eparrot" "🦜")
    ("eturtle" "🐢")
    ;; ("esloth" "🦥")
    ("enice" "👍")
    ("ebye" "👋")
    ("edrip" "💧")
    ("eheart" "💙")
    ("esnow" "❄")
    ("echeck" "✅️")
    ("ecross" "❌️")
    ("etrash" "🚮️")
    ("egear" "⚙️")
    ("eearth" "🌍️")
    ("eglobe" "🌐️")
    ("ebook" "📗️")
    ))



(set-default 'abbrev-mode t)

(setq save-abbrevs nil)
(global-set-key (kbd "s-/") 'hippie-expand)

(provide 'my-abbrev-and-expand)
