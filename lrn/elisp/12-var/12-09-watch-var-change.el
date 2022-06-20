(defun f (s nv op wh)
  (message "Oh changed to")
  ;; The symbol
  (print s)
  ;; The new value
  (print nv)
  ;; The operation
  (print op)
  ;; Where it is set.
  (print wh)
  )

(setq x 2)
(add-variable-watcher 'x 'f)
(setq x 3)
(get-variable-watchers 'x)              ;(f)
(remove-variable-watcher 'x 'f)         ;nil


;; An Example
(defun checker (s n o w)
  "Check Whether new value is positive."
  (let ((name (symbol-name s)))

    (if (not (numberp n))
        (progn
          (message "%s should be a number, not %s" name (prin1 n))
          (set s 0)
          )
      (if (> n 0)
          (message "%s set successuly to %g" name n)
        (progn
          (message "%s cannot be negative. Set to zero." name)
          (set s 0))
        )
      )
    )
  )                                     ;checker




(setq HP 4)                             ;4
(add-variable-watcher 'HP 'checker)     ;nil
(setq HP 3)                             ;3
(setq HP ?a)                            ;97
(setq HP "oh")
HP                                      ;"oh"
