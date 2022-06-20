;; the hooks
(autoload 'folding-mode          "folding" "Folding mode" t)
  ;; (if (require 'folding nil 'noerror)
  ;;     (folding-mode-add-find-file-hook)
;;   (message "Library `folding' not found"))


(add-hook 'prog-mode-hook 'show-paren-mode)
(add-hook 'prog-mode-hook 'column-number-mode)
(add-hook 'prog-mode-hook 'electric-pair-mode)
(add-hook 'prog-mode-hook 'hungry-delete-mode)
(add-hook 'prog-mode-hook 'global-linum-mode)
(add-hook 'prog-mode-hook 'folding-mode)
(add-hook 'org-mode-hook 'auto-fill-mode)

;; Enable rainbow paren
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(add-hook 'LaTex-mode-hook #'rainbow-delimiters-mode)
(add-hook 'LaTeX-mode-hook 'TeX-fold-mode)
(add-hook 'LaTeX-mode-hook 'outline-minor-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-cdlatex)   ; with AUCTeX LaTeX mode

;; Implementation to be defined in my-default.el
(add-hook 'prog-mode-hook
          (lambda ()
            (define-key evil-normal-state-local-map (kbd "TAB") 'folding-toggle-show-hide)
            (define-key evil-normal-state-local-map (kbd "<backtab>") 'my-folding-toggle-global)
            (define-key evil-visual-state-map (kbd "TAB") 'folding-fold-region)
            )
          )

;; (add-hook 'LaTeX-mode-hook
;;           (lambda ()
;;             (define-key evil-normal-state-local-map (kbd "TAB") 'my-outline-toggle-show-hide)
;;             (define-key evil-normal-state-local-map (kbd "<backtab>") 'my-outline-toggle-global)
;;             )
;;           )

(provide 'my-hooks)
