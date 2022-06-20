;; plist (k1 v1 k2 v2 ...)

;; Basic
;; get using eq
(plist-get '(x 4 y 3) 'x)               ;4
(plist-get '(x 4 y 3) 'z)               ;nil
;; get using equal
(lax-plist-get '(1.0 1 2.0 2) 1.0)      ;1

(setq l (list 'x t 'y 2))               ;(x t y 2)
(plist-put l 'z 3)                      ;(x t y 2 z 3)

;; Does this property exists ?
(plist-member l 'x)                     ;(x t y 2 z 3)
(plist-member l 'a)                     ;nil

