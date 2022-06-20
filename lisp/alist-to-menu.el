(defvar alist-to-menu-item-per-row 5 "The number of items per row for the function alist-to-menu")

(defun alist-to-menu (l)
  "Turn an alist to a string menu"
  (defun alist-to-string (l)
    "convert an alist to a menu"
    (mapcar (lambda (x)
              (format "%5s : %5s" (car x) (cdr x))
              )
            l
            )
    )

  (defun alist-string-to-menu (s)
    "Concat a list of string, joint with \n"
    (setq n 0)                          ;5 items per row
    (seq-reduce (lambda (s1 s2)
                  (progn
                    (setq n (+ n 1))
                    (if (eq (mod n alist-to-menu-item-per-row) 0)
                        (concat s1 "\n" s2)
                      (concat s1 "\t" s2)
                      )
                    )
                  )
                s
                ""
                )
    )

  (concat "Options:\n"
          (alist-string-to-menu (alist-to-string l))
          "\n")
  )

(provide 'alist-to-menu)

;; Following are test -------------------------------------------------- 

;; (defun alist-to-string (l)
;;   "convert an alist to a menu"
;;   (mapcar (lambda (x)
;;             (format "%5s : %5s" (car x) (cdr x))
;;             )
;;           l
;;           )
;;   )


;; (defun alist-string-to-menu (s)
;;   "Concat a list of string, joint with \n"
;;   (setq n 0)                          ;5 items per row
;;   (seq-reduce (lambda (s1 s2)
;;                 (progn
;;                   (setq n (+ n 1))
;;                   (if (eq (mod n 5) 0)
;;                       (concat s1 "\n" s2)
;;                     (concat s1 "\t" s2)
;;                     )
;;                   )
;;                 )
;;               s
;;               ""
;;               )
;;   )                                   ;alist-string-to-menu

;; ;; (eq (mod 2 5) 0)                        ;nil
;; ;; (concat "a" "b" "c")                    ;"abc"
;; ;; (seq-reduce '+ '(1 2 3) 0)              ;6
;; ;; (alist-string-to-menu '("hi" "oh"))     ;"	hi	oh"
;; ;; (alist-to-string c-my-includes-alist)   ;("  ios : <iostream>" "  str : <string>")
