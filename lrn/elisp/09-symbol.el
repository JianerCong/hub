;; Each symbol can hold a value AND a function For example, buffer-file-name
;;      symbol holds a string and a built-in function(a subroutine)
buffer-file-name                        ;"/home/me/Templates/lrn/elisp/09-symbol.el"
(symbol-function 'buffer-file-name)     ;#<subr buffer-file-name>
(buffer-file-name)                      ;"/home/me/Templates/lrn/elisp/09-symbol.el"

;; Most of the symbols are stored in an "Obarray". You can make one with
(setq my-obarray (make-vector 3 0))     ;[0 0 0]
;; Global obarray is stored in 'obarray (Do not eval this (super big))

(symbol-name 'a)                        ;"a"

;; Uninterned symbols are not on any obarray.
;; Uninterned symbols won't be hidden by other symbols
;; Make with
(make-symbol "hi")                      ;hi
(eq (make-symbol "a") 'a)               ;nil

;;      Sometimes needed to generate some uninterned symbols. Use
gensym-counter                          ;10
(gensym)                                ;g10

;;      Use intern to add a symbol to an obarray(default to global obarray)
(setq x (intern "hi"))                  ;hi
(eq x 'hi)                              ;t
(setq x (intern "hi" my-obarray))       ;hi
my-obarray                              ;[0 0 hi]
(eq x 'hi)                              ;nil

;;      Test if a symbol is interned (default in global obarray)
(intern-soft "buffer-file-name")        ;buffer-file-name
(intern-soft "OhOh")                    ;nil
(intern-soft "hi" my-obarray)           ;hi

;;      Map over obarray (default to global)
;;      How many entries in global obarray?
(setq count 0)                          ;0
(mapatoms (lambda (o) (setq count (1+ count))
            )
          )                             ;nil
count                                   ;66115


;;      Delete element from obarray (default in global)
;; Returns t if successfully deleted , else nil.
(unintern "hi" my-obarray)              ;t
my-obarray                              ;[0 0 0]

