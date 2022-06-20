;; Variable alias

(defvar x 1)                            ;x
x                                       ;1
(defvar y)                              ;y
(defvaralias 'y 'x "y is x")            ;x
y                                       ;1
x                                       ;1
(setq x 2)                              ;2
y                                       ;2


;; Change var name
