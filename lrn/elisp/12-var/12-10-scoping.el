;; Dynamic bindings (default): use the most recently defined.
(setq x -99)                            ;-99

;; free variable x
(defun getx()
  x)                                    ;getx
;; dynamically bound
(let ((x 1))
  (getx))                               ;1
(getx)                                  ;-99


;; One usage of lexical scoping: temporarily disable a setting
(defun search-for-abc ()
    "Search for the sting \"abc\", case insensitivelly"
    (interactive)
  (let ((case-fold-search t))
    (re-search-forward "abc")
    )
  )

;; Lexical bindings
lexical-binding                         ;nil
(setq lexical-binding t)                ;t

(defun gety()
  y)                                    ;gety

(let ((y 1))
  (gety))                               ;ERROR


;; Use lexical binding to make closure
(defvar f nil)                          ;f
(let ((x 0))
  (setq f (lambda ()
            (setq x (1+ x))
            )
        )
  )                                     ;(closure ((x . 0) t) nil (setq x (1+ x)))
f                                       ;(closure ((x . 0) t) nil (setq x (1+ x)))
(funcall f)                             ;1
(funcall f)                             ;2
f                                       ;(closure ((x . 2) t) nil (setq x (1+ x)))

;; Turn off lexical binding
(setq lexical-binding nil)              ;nil
