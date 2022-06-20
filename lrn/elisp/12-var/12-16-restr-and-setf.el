;;      Restricted as bool
byte-boolean-vars                       ;(font-use-system-font use-default-font-for-symbols x-gtk-use-system-tooltips x-gtk-file-dialog-help-text x-gtk-show-hidden-files x-gtk-use-old-file-dialog x-gtk-use-window-move x-frame-normalize-before-maximize x-mouse-click-focus-ignore-position x-underline-at-descent-line x-use-underline-position-properties cross-disabled-images xft-font-ascent-descent-override xft-ignore-color-fonts inhibit-compacting-font-caches display-raw-bytes-as-hex redisplay--inhibit-bidi display-hourglass inhibit-bidi-mirroring inhibit-free-realized-faces inhibit-eval-during-redisplay display-line-numbers-widen inhibit-menubar-update message-truncate-lines unibyte-display-via-language-environment make-cursor-line-fully-visible auto-raise-tool-bar-buttons multiple-frames highlight-nonselected-windows x-stretch-cursor inhibit-message fast-but-imprecise-scrolling window-resize-pixelwise auto-window-vscroll mode-line-in-non-selected-windows undo-inhibit-record-point visible-cursor system-uses-terminfo comment-end-can-be-escaped open-paren-in-column-0-is-defun-start multibyte-syntax-as-symbol words-include-escapes parse-sexp-lookup-properties parse-sexp-ignore-comments tooltip-reuse-hidden-frame frame-resize-pixelwise scroll-bar-adjust-thumb-portion delete-exited-processes minibuffer-allow-text-properties minibuffer-auto-raise enable-recursive-minibuffers completion-ignore-case history-delete-duplicates read-buffer-completion-ignore-case inhibit-modification-hooks indent-tabs-mode create-lockfiles inhibit-x-resources noninteractive internal--text-quoting-flag redisplay-dont-pause cursor-in-echo-area no-redraw-on-reenter visible-bell inverse-video debugger-stack-frame-as-list debugger-may-continue debug-on-next-call debug-on-quit print-quoted print-escape-multibyte print-escape-nonascii print-escape-control-characters print-escape-newlines load-prefer-newer force-load-messages load-dangerous-libraries)


(let ((load-dangerous-libraries 5))
  load-dangerous-libraries)             ;t


(setq undo-limit 5.0)                   ;Error, can only be integer

;; Using setf
(setq l '(1 2))                         ;(1 2)
(setf (car l) 2)                        ;2
l                                       ;(2 2)


