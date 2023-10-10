;; the hooks

(autoload 'folding-mode          "folding" "Folding mode" t)
(autoload 'wat-mode          "wat-mode" "Wasm Text mode" t)
;; (message "my hooks loaded")
;; load folding.el when 'folding-mode is required
  ;; (if (require 'folding nil 'noerror)
  ;;     (folding-mode-add-find-file-hook)
  ;; (message "Library `folding' not found"))


(add-hook 'prog-mode-hook 'show-paren-mode)
(add-hook 'prog-mode-hook 'flycheck-mode)
(add-hook 'prog-mode-hook 'column-number-mode)
(add-hook 'prog-mode-hook 'electric-pair-mode)
(add-hook 'prog-mode-hook 'hs-minor-mode)

(add-hook 'prog-mode-hook 'hungry-delete-mode)
(add-hook 'prog-mode-hook 'global-linum-mode)

;; 🦜 : I feel like hs-minor mode is better than folding mode. Folding mode is a
;; bit slow.. Don't know why..

;; (add-hook 'prog-mode-hook 'folding-mode)
(add-hook 'org-mode-hook 'auto-fill-mode)

;; Enable rainbow paren
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(if (load "auctex.el" t)                ;t means noerror
    (progn
      ;; (load "preview-latex.el" nil t t)
      (add-hook 'LaTex-mode-hook #'rainbow-delimiters-mode)
      (add-hook 'LaTeX-mode-hook 'TeX-fold-mode)
      (add-hook 'LaTeX-mode-hook 'outline-minor-mode)
      (add-hook 'LaTeX-mode-hook 'yas-minor-mode)
      (add-hook 'LaTeX-mode-hook 'turn-on-cdlatex)   ; with AUCTeX LaTeX mode


      ;; 🐢 : These cdlatex settings must be loaded in the hook.
      (add-hook 'cdlatex-mode-hook
                ;; 🦜 : I feel like cdlatex's font insertion is handier than
                ;; the C-x C-f [..] command of AuCTeX....
                ;; You can just use 'a to insert your font for change the font
                ;; of previous word.

                ;; 🐢 : Yeah. But I feel like cdlatex is not good at turning an
                ;; selected buffer of text into a fonted one. So let's keep both.
                (lambda ()
                  (setq cdlatex-math-modify-alist
                        '(
                          (?a "\\cola" "\\cola" t nil nil)
                          (?b "\\colb" "\\colb" t nil nil)
                          (?c "\\colc" "\\colc" t nil nil)
                          (?A "\\Cola" "\\Cola" t nil nil)
                          (?z "\\colz" "\\colz" t nil nil)
                          (?Z "\\colZ" "\\colZ" t nil nil)
                          )
                        )
                  )
                )

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

;; 🦜 : I feel like it's just better to use [SPC]-z-c for folding
(add-hook 'sclang-mode-hook 'sclang-extensions-mode)



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
         ("\\.wat\\'" . wat-mode)
         )
       auto-mode-alist))
(message "my-hook loaded")


(provide 'my-hooks)
