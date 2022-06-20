;; Two ways to set-up autoload
;; 1. call (autoload)
;; 2. use magic comment


;; View an auto-load function
(symbol-function 'run-prolog)           ;(autoload "prolog" 1441256 t nil)
;;                                                 ^filename  ^doc  ^interactive ^not macro/keymap

load-suffixes                           ;(".elc" ".el")

;; mark f from f1.el
(autoload 'f "/home/me/Templates/lrn/elisp/16-load/f1.el" "a function to be loaded" t nil) ;f

(f)

;; Is is auto load?
(autoloadp (symbol-function 'run-prolog)) ;t



