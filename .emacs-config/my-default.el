;; no welcome screen
(setq inhibit-splash-screen 1)
(setq make-backup-files nil)
(setq auto-save-default nil)
(if (string-equal system-type "windows-nt")
    (setq-default
     shell-file-name
     "c:/Program Files/WindowsApps/Microsoft.PowerShell_7.2.6.0_x64__8wekyb3d8bbwe/pwsh.exe"
     )
  nil
  )

;; set the font
(set-face-attribute 'default nil :height 100)

;; The path for suffix-based config file
(defconst path-template "~/Templates/lisp/") ;path-template
;; add the path
(global-set-key (kbd "<f6>") 'whitespace-mode)
(global-set-key (kbd "<f8>") 'shell)
(global-set-key (kbd "C-x C-'") 'comment-line)


(define-key evil-normal-state-map (kbd "m") 'bookmark-set)
(define-key evil-normal-state-map (kbd "`") 'bookmark-jump)


(when (member "Segoe UI Emoji" (font-family-list))
  (set-fontset-font
   t 'symbol (font-spec :family "Segoe UI Emoji") nil 'prepend))

(defun start-my-emacs-server (tcp port host)
  """Start the emacs server using tcp port 1234"""
  (interactive
    (list
      (y-or-n-p "Use TCP:[yes]? ")
      (read-number "Port:[1234] " 1234)
      (read-string "Host:[localhost] " "localhost")
      )
   )

  (setq server-use-tcp tcp)
  (setq server-port port)
  (setq server-host host)

  ;; 🦜: Following is the default

  ;; (setq server-auth-dir "~/.emacs.d/server/")
  (server-start)
  )

(require 'myy-code-folding)
(require 'myy-code-outline-modes)
(provide 'my-default)

