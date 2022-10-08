;;{{{ public my-outline-toggle-global

(defun my-outline-toggle-global ()
  "Show or hide all outlines"
  (interactive)
  (if my-outline-global
      (outline-show-all)
    (outline-hide-body)
    )
  (setq-default my-outline-global (not my-outline-global))
  )
(defvar my-outline-global t "Whether the buffer is outline-folded.
The companion variable for my-outline-toggle-global.")

;;}}}
;;{{{ public my-outline-toggle-show-hide

(defun my-outline-toggle-show-hide ()
  "Toggle the visibility of a subtree.
According to the variable `my-outline-show-hide-style' which can
  be either `simple' or `org-mode', this function will call the
  corresponding functions successively to change the visibility
  of a outline-subtree.

If `my-outline-show-hide-style' is set to `simple', then we will
walk through the following functions:

(#'outline-hide-entry #'outline-show-entry)

If `my-outline-show-hide-style' is set to `org-mode', then we will
walk through the following functions:

(#'outline-show-subtree #'outline-show-branches
#'outline-show-children #'outline-hide-leaves)
"
  (interactive)
  (if (eq my-outline-show-hide-style 'simple)
    (my-call-func-from-states my-outline-show-hide-simple-functions)
    (my-call-func-from-states my-outline-show-hide-org-mode-functions)
      )
  )

;;}}}

(defvar my-outline-show-hide-style 'org-mode
  "Options for `my-outline-toggle-show-hide'.
Valid values are `simple' and `org-mode'")

(defun my-outline-handle-simple ()
  "Call the corresponding functions from
  `my-outline-show-hide-simple-functions' according to `my-outline-state'."
  )

;;{{{ my-call-func-from-states

(defun my-call-func-from-states (l)
  "Call the function in lists according to `my-outline-state',
  then update `my-outline-state'"
  ;; (message "Start: Now state is %d" my-outline-state)
  (setq n my-outline-state)
  (setq n (mod n (length l)))
  (funcall (elt l n))
  (setq my-outline-state (1+ n))
  ;; (message "End: Now state is %d" my-outline-state)
  )

;; (defun f2 ()
;;   (message "f2 is called")
;;   "f2 is called")
;; (defun f1 ()
;;   (message "f1 is called")
;;   "f1 is called")
;; (setq l (list #'f1 #'f2))
;; (my-call-func-from-states l)
;; (my-call-func-from-states l)
;; (my-call-func-from-states l)
;; (my-call-func-from-states l)
;; (my-call-func-from-states l)

;;}}}
;;{{{ The two function lists

(defvar my-outline-show-hide-simple-functions
  (list #'outline-hide-entry #'outline-show-entry)
  "The functions to walk through for `my-outline-global' when
  `my-outline-show-hide-style' is set to `simple'")

(defvar my-outline-show-hide-org-mode-functions
  (list #'outline-hide-subtree #'outline-show-branches
        #'outline-show-subtree
        )
  "The functions to walk through for `my-outline-global' when
  `my-outline-show-hide-style' is set to `org-mode'")

;;}}}
;;{{{ The shared state variable

(defvar my-outline-state
  0
  "A counter variable that stores the state when
  `my-outline-toggle-show-hide' walks through the functions. Note
  that both `simple' and `org-mode' function lists get and set
  this variable, so one less `defvar' is needed. (The author is a
  bit proud of this.). This var should be updated by calling
  `my-increment-outline-state'
"
  )

;;}}}

(provide 'myy-code-outline-modes)
