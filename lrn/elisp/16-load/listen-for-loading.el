after-load-functions                    ;(elisp--font-lock-flush-elisp-buffers
                                        ;evil-update-pending-maps
                                        ;spacemacs/diminish-hook
                                        ;evil-define-key-in-emoji-cheat-sheet-plus-buffer-mode-map
                                        ;evil-define-key-in-macrostep-keymap)

;; Listen to loading
(add-to-list 'after-load-functions (lambda (x) (message "Oh you load %s" x)))
(load-file "f1.el")                     ;t

;; Listen to loading f1
(with-eval-after-load "f1.el" (message "Welcome to f1 🐸")) ;"Welcome to f1 🐸"

(with-eval-after-load 'f2 (message "Welcome to f2 🐸")) ;nil
(provide 'f2)                                           ;f2
;; Welcome to f2 🐸
