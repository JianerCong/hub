;; Symbol variable


(symbol-plist 'number)                  ;(widget-type (restricted-sexp :tag "Number" :value 0.0 :type-error "This field should contain a number (floating point or integer)" :match-alternatives (numberp)) widget-documentation "A number (floating point or integer)." thing-at-point number-at-point)

(get 'number 'widget-documentation)     ;"A number (floating point or integer)."

(setplist 'x '(a 1 b 2))                ;(a 1 b 2)
(symbol-plist 'x)                       ;(a 1 b 2)
(get 'x 'a)                             ;1
(put 'x 'c 3)                           ;3
(get 'x 'c)                             ;3
