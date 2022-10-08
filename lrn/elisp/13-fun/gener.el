;; Generic function (skipped)
(cl-defgeneric f (x) (:documentation "a simple function"))
(cl-defmethod f '(x integer) (x) (1+ x))         ;f
(cl-defmethod f '(x string) (x) (concat x "+1")) ;f

(f 1)
