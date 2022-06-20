features                                ;(skeleton helm-external helm-net
                                        ;browse-url xml helm-descbinds helm-mode
                                        ;helm-files tramp tramp-compat
                                        ;tramp-loaddefs trampver ucs-normalize
                                        ;parse-time helm-buffers helm-occur
                                        ;helm-tags helm-locate helm-grep
                                        ;helm-regexp helm-utils helm-help
                                        ;helm-types helm async-bytecomp
                                        ;helm-global-bindings helm-source
                                        ;helm-multi-match helm-lib projectile
                                        ;grep ibuf-ext ibuffer ibuffer-loaddefs
                                        ;my-abbrev-and-expand my-modes
                                        ;my-buffer-init my-default winner vc-git
                                        ;diff-mode recentf tree-widget
                                        ;company-files company-keywords
                                        ;company-etags company-gtags
                                        ;company-dabbrev-code company-dabbrev
                                        ;company-semantic company-template
                                        ;company-capf company overseer pkg-info
                                        ;epl f compile auto-compile packed
                                        ;elisp-slime-nav etags xref project
                                        ;flycheck-elsa flycheck-package
                                        ;package-lint let-alist imenu finder
                                        ;paren hungry-delete linum
                                        ;folding-isearch folding goto-addr
                                        ;bug-reference flycheck-pos-tip pos-tip
                                        ;flycheck json map find-func
                                        ;yasnippet-snippets yasnippet elec-pair
                                        ;async saveplace savehist emr popup s
                                        ;dash noutline outline hybrid-mode
                                        ;evil-evilified-state which-key
                                        ;use-package use-package-ensure
                                        ;use-package-delight
                                        ;use-package-diminish
                                        ;use-package-bind-key bind-key hydra lv
                                        ;evil evil-integration evil-maps
                                        ;evil-commands reveal flyspell ispell
                                        ;evil-jumps evil-command-window
                                        ;evil-types evil-search evil-ex shell
                                        ;pcomplete comint ansi-color evil-macros
                                        ;evil-repeat evil-states evil-core
                                        ;evil-common windmove calc calc-loaddefs
                                        ;calc-macs thingatpt rect evil-digraphs
                                        ;evil-vars diminish ring mm-archive
                                        ;message dired dired-loaddefs rfc822 mml
                                        ;mml-sec epa gnus-util rmail
                                        ;rmail-loaddefs mailabbrev gmm-utils
                                        ;mailheader mail-utils network-stream
                                        ;starttls url-http tls gnutls url-gw nsm
                                        ;rmc puny url-cache url-auth url
                                        ;url-proxy url-privacy url-expand
                                        ;url-methods url-history url-cookie
                                        ;url-domsuf url-util mailcap quelpa
                                        ;mm-decode mm-bodies mm-encode
                                        ;mail-parse rfc2231 rfc2047 rfc2045
                                        ;mm-util ietf-drums mail-prsvr lisp-mnt
                                        ;help-fns radix-tree hl-line xt-mouse
                                        ;autorevert filenotify bind-map
                                        ;use-package-core cl-extra disp-table
                                        ;monokai-theme format-spec finder-inf
                                        ;tex-site helm-easymenu cl info my-hooks
                                        ;ido-vertical-mode ido core-spacemacs
                                        ;core-spacebind core-use-package-ext
                                        ;core-transient-state core-micro-state
                                        ;core-early-funcs core-toggle
                                        ;core-keybindings core-fonts-support
                                        ;core-themes-support core-display-init
                                        ;core-jump core-release-management
                                        ;core-custom-settings
                                        ;core-configuration-layer eieio-compat
                                        ;core-progress-bar core-spacemacs-buffer
                                        ;core-funcs spacemacs-ht inline
                                        ;help-mode warnings package url-handlers
                                        ;url-parse auth-source cl-seq
                                        ;password-cache url-vars eieio
                                        ;eieio-core eieio-loaddefs epg
                                        ;epg-config core-command-line core-debug
                                        ;edmacro kmacro derived profiler
                                        ;core-hooks page-break-lines easy-mmode
                                        ;core-env load-env-vars rx
                                        ;core-dotspacemacs advice pcase
                                        ;core-customization validate cus-edit
                                        ;easymenu cus-start cus-load wid-edit
                                        ;seq byte-opt bytecomp byte-compile
                                        ;cconv core-emacs-backports
                                        ;core-compilation subr-x core-dumper
                                        ;spinner cl-macs gv cl-loaddefs cl-lib
                                        ;core-load-paths core-versions time-date
                                        ;mule-util china-util tooltip eldoc
                                        ;electric uniquify ediff-hook vc-hooks
                                        ;lisp-float-type mwheel term/x-win x-win
                                        ;term/common-win x-dnd tool-bar dnd
                                        ;fontset image regexp-opt fringe
                                        ;tabulated-list replace newcomment
                                        ;text-mode elisp-mode lisp-mode
                                        ;prog-mode register page menu-bar
                                        ;rfn-eshadow isearch timer select
                                        ;scroll-bar mouse jit-lock font-lock
                                        ;syntax facemenu font-core
                                        ;term/tty-colors frame cl-generic cham
                                        ;georgian utf-8-lang misc-lang
                                        ;vietnamese tibetan thai tai-viet lao
                                        ;korean japanese eucjp-ms cp51932 hebrew
                                        ;greek romanian slovak czech european
                                        ;ethiopic indian cyrillic chinese
                                        ;composite charscript charprop
                                        ;case-table epa-hook jka-cmpr-hook help
                                        ;simple abbrev obarray minibuffer
                                        ;cl-preloaded nadvice loaddefs button
                                        ;faces cus-face macroexp files
                                        ;text-properties overlay sha1 md5 base64
                                        ;format env code-pages mule custom
                                        ;widget hashtable-print-readable
                                        ;backquote threads dbusbind inotify
                                        ;lcms2 dynamic-setting
                                        ;system-font-setting font-render-setting
                                        ;move-toolbar gtk x-toolkit x multi-tty
                                        ;make-network-process emacs)


(set-difference '(1 2 3) '(1 2))        ;(3)
(provide 'my-feature)                   ;my-feature
(featurep 'my-feature)                  ;t
;; Push the my-feature into features
(pop features)                          ;my-feature
(featurep 'my-feature)                  ;nil

;; Require
;;Try load f4.el
(add-to-list 'load-path
             (file-name-directory (buffer-file-name)) ;"/home/me/Templates/lrn/elisp/16-load/"
             )
(require 'f4)                           ;f4
var-in-f4                               ;2
(unload-feature 'f4)                    ;nil
(boundp 'var-in-f4)                     ;nil

;; Explicitly load f5.el
(require 'big-feature-in-f5 "f5.el")    ;big-feature-in-f5
;; Remove path
(pop load-path)                         ;"/home/me/Templates/lrn/elisp/16-load/"

;; the unload event
unload-feature-special-hooks            ;(after-change-functions
                                        ;after-insert-file-functions
                                        ;after-make-frame-functions
                                        ;auto-coding-functions
                                        ;auto-fill-function
                                        ;before-change-functions
                                        ;blink-paren-function
                                        ;buffer-access-fontify-functions
                                        ;choose-completion-string-functions
                                        ;comint-output-filter-functions
                                        ;command-line-functions
                                        ;comment-indent-function
                                        ;compilation-finish-functions
                                        ;delete-frame-functions
                                        ;disabled-command-function
                                        ;fill-nobreak-predicate
                                        ;find-directory-functions
                                        ;find-file-not-found-functions
                                        ;font-lock-fontify-buffer-function
                                        ;font-lock-fontify-region-function
                                        ;font-lock-mark-block-function
                                        ;font-lock-syntactic-face-function
                                        ;font-lock-unfontify-buffer-function
                                        ;font-lock-unfontify-region-function
                                        ;kill-buffer-query-functions
                                        ;kill-emacs-query-functions
                                        ;lisp-indent-function
                                        ;mouse-position-function
                                        ;redisplay-end-trigger-functions
                                        ;suspend-tty-functions
                                        ;temp-buffer-show-function
                                        ;window-scroll-functions
                                        ;window-size-change-functions
                                        ;write-contents-functions
                                        ;write-file-functions
                                        ;write-region-annotate-functions)

;; Each function takes one argument, the absolute filename to be unload
