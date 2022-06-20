(defun f (x) (+ 1 x))                   ;f
(func-arity 'f)                         ;(1 . 1)
(functionp 'f)                          ;t

;; is subrouting?
(subrp 'message)                        ;nil
(subrp (symbol-function 'message))      ;t
(byte-code-function-p (symbol-function 'next-line)) ;t
(subr-arity (symbol-function 'message))             ;(1 . many)


;; lambda
(funcall (lambda (a b) (+ a b)) 1 2)    ;3


;; arg list
(defun f (a b &optional c d &rest e)
  (if (and c d)
      (+ a b c d (apply '+ e))
    (+ a b)
      )
  )

(f 1 2)                                 ;3
(f 1 2 3)                               ;3
(f 1 2 3 4)                             ;10
(f 1 2 3 4 5)                           ;15
(funcall (symbol-function 'f) 1 2 3 4)  ;10

;; apply
(setq f 'list)                          ;list
(funcall f 'x 'y)                       ;(x y)
(apply '+ '(1 2 3))                     ;6

;; make a partial function
(defalias '2+ (apply-partially '+ 2)
  "plus 2")                             ;2+
(2+ 2)                                  ;4
;; Same as
(defun 3+ (x &rest l)
  "plus 3"
  (+ 3 x (apply '+ l)))                 ;3+
(3+ 2)                                  ;5
(3+ 1 1 1)                              ;6

;; special
(identity 1)                            ;1
(ignore 1 2 3)                          ;nil

;; quote a function but note that the two are the function
(quote (lambda () 2))
(function (lambda () 2))                ;(lambda nil 2)
#'(lambda () 2)                         ;(lambda nil 2)

;; an example of changing the property
(message (make-string 50 ?-))
(message "Gameが始まりだ")
(setplist 'p1 '(name "YUSEI" LP 4000))
(defun show-player (s)
  (message "%s は　まだ %dLPがある" (get s 'name) (get s 'LP)))
(defun chg-properties (s p f)
  "Apply the function f to the property o of symbol s"
  (put s p (funcall f (get s p)))
  )
(defun eff-D-HERO-DOGMA (p)
  (message "D-HERO Dogma の効果発動。%s のLifeを半分になる。" (get p 'name))
  (chg-properties p 'LP (lambda (x) (/ x 2)))
  )

(show-player 'p1)
(eff-D-HERO-DOGMA 'p1)
(show-player 'p1)
