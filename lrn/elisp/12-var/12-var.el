(keywordp :hi)                          ;t


;;      Local var
(setq x 2)                              ;2
(let ((x 1)
      (y x)
      )
  (list x y)
  )                                     ;(1 2)

(let* ((x 1)
       (y x)
       )
  (list x y)
  )                                     ;(1 1)
;;      Bind var before local values are computed.
;; Example: self-removing hook function
(defun g ())                            ;g
(letrec (
         (f (lambda ()
              (message "hi")
              (remove-hook 'g f)))
         )
  (add-hook 'g f)
  )                                     ;((lambda nil (message "hi") (remove-hook (quote g) f)))
(g)                                     ;nil

;;      Maximum number of local var?
max-specpdl-size                        ;1300


;;      Is a var bounded?
(setq x 1)
(boundp 'x)                             ;t

;; Unbound local variable.
(let ((x 1))
  (makunbound 'x)
  (boundp 'x))                          ;nil


(makunbound 'x)                         ;x
(boundp 'x)                             ;nil

;; Define variables with doc string.
(defconst x 2
  "a simple var")                       ;x
x                                       ;2
;; You can change const....
(setq x 3)                              ;3

;; Define + let
(defvar my-mode-map
  (let ((m (make-sparse-map))
        )
    (define-key m "\C-c\C-a" 'my-command)
    m
    )
  "My mode map")


;; Or

(defvar my-mode-map
  nil
  "My mode map")

(unless my-mode-map
  (let ((m (make-sparse-map))
        )
    (define-key m "\C-c\C-a" 'my-command)
    m
    (setq my-mode-map m)
    )
  )
