;; the hooks
(autoload 'folding-mode          "folding" "Folding mode" t)
;; load folding.el when 'folding-mode is required
  ;; (if (require 'folding nil 'noerror)
  ;;     (folding-mode-add-find-file-hook)
  ;; (message "Library `folding' not found"))


(add-hook 'prog-mode-hook 'show-paren-mode)
(add-hook 'prog-mode-hook 'column-number-mode)
(add-hook 'prog-mode-hook 'electric-pair-mode)

(add-hook 'prog-mode-hook 'hungry-delete-mode)
(add-hook 'prog-mode-hook 'global-linum-mode)
(add-hook 'prog-mode-hook 'folding-mode)
(add-hook 'org-mode-hook 'auto-fill-mode)

(message "my hooks loaded")
;; Enable rainbow paren
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(if (load "auctex.el" t)                ;t means noerror
    (progn
      ;; (load "preview-latex.el" nil t t)
      (add-hook 'LaTex-mode-hook #'rainbow-delimiters-mode)
      (add-hook 'LaTeX-mode-hook 'TeX-fold-mode)
      (add-hook 'LaTeX-mode-hook 'outline-minor-mode)
      (add-hook 'LaTeX-mode-hook 'turn-on-cdlatex)   ; with AUCTeX LaTeX mode
      )
  (message "Library `auctex' not found, skipping config")
)

;; Implementation to be defined in my-default.el
(add-hook 'prog-mode-hook
          (lambda ()
            (define-key evil-normal-state-local-map (kbd "TAB") 'folding-toggle-show-hide)
            (define-key evil-normal-state-local-map (kbd "<backtab>") 'my-folding-toggle-global)
            (define-key evil-visual-state-map (kbd "TAB") 'folding-fold-region)
            )
          )

(setq auto-mode-alist
      (append
       ;; File name (within directory) starts with a dot.
       '(("/\\.[^/]*\\'" . fundamental-mode)
         ;; File name has no dot.
         ("/[^\\./]*\\'" . fundamental-mode)
         ;; File name ends in ‘.C’.
         ("\\.C\\'" . c++-mode)
         ;; File name ends in ‘.vue’.
         ("\\.vue\\'" . web-mode)

         ("\\.wxml\\'" . web-mode)
         ("\\.wxss\\'" . css-mode)
         )
       auto-mode-alist))
(message "my-hook loaded")


(provide 'my-hooks)
