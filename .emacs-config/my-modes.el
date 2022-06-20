;; Modes ----------------------------------------
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-hl-line-mode 1)
(global-auto-revert-mode 1)
(setq-default abbrev-mode t)
(setq-default indent-tabs-mode nil)
;; (global-hungry-delete-mode 1)
(setq-default hungry-delete-join-reluctantly t)
;; (global-linum-mode 1)



(setq auto-mode-alist
  (append
   ;; File name (within directory) starts with a dot.
   '(("/\\.[^/]*\\'" . fundamental-mode)
     ;; File name has no dot.
     ("/[^\\./]*\\'" . fundamental-mode)
     ;; File name ends in ‘.C’.
     ("\\.C\\'" . c++-mode))
   auto-mode-alist))


(provide 'my-modes)

