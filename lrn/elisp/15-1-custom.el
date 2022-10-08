;; Group is a like a folder of customization variable


(defgroup my-group nil
  "My First group"
  :version "1.0.0"
  :prefix "my-"
  :group 'emacs)


(defcustom my-fruit-of-the-day 'orange
  ;; option^^^^^^^^^^^^^^^^^^^^  ^^^^^^ the "standard value"
  "Which fruit my ate for breakfirst. Can be `orange', `apple'
  or `grapes'"
  :type '(choice (const orange) (const apple) (const grapes))
  )
"""
If the option already has a default value:
   Use that value
Else if User has set a value in the Customization:
   Use that value
Else:
   Use the (eval standard-value) is used
"""

;; Usually we use C-M-x (eval-defun) to eval the defcustom forms, which will
;; invokes the :set methods if one exits.

;; How to define a set function (the default is set-default)
;; How to define a get function (the default is default-value)

(defcustom my-name 'cccccje
  "The user id of my"
  :type '(choice (const cccccje) (const cje))
  :initialize (lambda (x y)
                (message "Initialize function called for %s <- %s" x y)
                ;; (custom-initialize-set x y) ;or
                (custom-initialize-reset x y)
                ;;Call the verbose :set constructor which get the y value from
                ;;:get
                )
  :set (lambda (x y) "The verbose set function"
         (message "Set function called for %s <- %s" x y)
         (set-default x y)
         )
  ;; Do not play with :get
  :get (lambda (x) "The answer you get if you ask cje's name"
         (format ":get methods called for D-HERO redy, but not %s" (symbol-name x))
         (default-value x)
         )
  )


;; Use :require to load a feature
(defcustom my-ex nil
  "Non-nil means my is here. Although the variable name is
my-ex, in the Customization Interface, it's called my-exist"
  :tag "Do I exist ?"
  :type 'boolean
  ;; :local t                              ;make this variable buffer local
  :require 'c-mode                      ;require a mode
  )

;; (custom-add-frequent-value 'emacs-lisp-mode-hook
;;                            (lambda () (message "My lisp init is called"))
;;                            )

my-ex                                  ;nil
(symbol-plist 'my-ex)                  ;(standard-value (nil) custom-tag "cje-exist" custom-type boolean custom-requests nil variable-documentation "Non-nil means cje is here. Although the variable name is cje-ex, in the Customization Interface, it's called cje-exist")
