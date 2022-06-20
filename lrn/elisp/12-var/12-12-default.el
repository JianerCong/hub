;;      The default value <=> the glocal value of a buffer-local var
(setq x 1)                              ;1
(with-current-buffer "*scratch*"
  (make-local-variable 'x)
  (setq-local x 11)
  (print (default-value 'x))
  (print (default-boundp 'y))
  ;; y <<- 2
  (setq-default y 2)
  ;; Same as (set-default 'y 2)
  (print (default-boundp 'y))
  )
;; t
y                                       ;2

;; Note: Inside (let) above function doesn't work.
;;      Need to use top-level ...

(setq z 1)                              ;1
(let ((z 11))
  (print (default-value 'z))
  (setq-default z 2)
  )                                     ;2
z                                       ;1


(let ((z 11))
  (print (default-toplevel-value 'z))
  (set-default-toplevel-value 'z 2)
  )                                     ;nil
z                                       ;2

;;      File local variable

;; Wheather to process file-local var
enable-local-variables                  ;t

;; filenames in which file-local variables are disabled.
inhibit-local-variables-regexps         ;("\\.tar\\'" "\\.t[bg]z\\'" "\\.arc\\'" "\\.zip\\'" "\\.lzh\\'" "\\.lha\\'" "\\.zoo\\'" "\\.[jew]ar\\'" "\\.xpi\\'" "\\.rar\\'" "\\.7z\\'" "\\.sx[dmicw]\\'" "\\.odt\\'" "\\.diff\\'" "\\.patch\\'" "\\.tiff?\\'" "\\.gif\\'" "\\.png\\'" "\\.jpe?g\\'")


;;      Where to set file local var?
file-local-variables-alist              ;nil
(setq-local file-local-variables-alist '((a . 1))) ;
(hack-local-variables)                             ;

before-hack-local-variables-hook        ;nil
hack-local-variables-hook               ;(spacemacs//run-local-vars-mode-hook)

