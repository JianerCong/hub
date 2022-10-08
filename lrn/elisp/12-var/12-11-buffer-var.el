(setq x 1)                              ;1


(get-buffer-create "b1")                ;#<buffer b1>
(get-buffer-create "b2")                ;#<buffer b2>
(with-current-buffer "b1"
  (make-local-variable 'x)
  (setq x 11)
  )                                     ;11

(with-current-buffer "b2"
  (make-local-variable 'x)
  (setq x 22)
  )                                     ;22

;;      Watch local value in other buffer
(with-current-buffer "b1"
  x)                                    ;11
(with-current-buffer "b2"
  x)                                    ;22

(buffer-local-value 'x (get-buffer "b1")) ;11
(buffer-local-value 'x (get-buffer "b2")) ;22

;; Create buffer local var Method 2: Set it directly
(with-current-buffer "b1"
  (setq-local x 1)
  )                                     ;1

;; Same as make-local-variable (CANNOT BE UNDONE)
(make-variable-buffer-local 'y)         ;y


(local-variable-p 'y)                   ;nil
(local-variable-if-set-p 'y)            ;t
(kill-local-variable 'y)                ;y

;; Kill local binding and watch the global one.

(setq x 1)
(with-current-buffer "b1"
  (setq-local x 11)
  (message "Local x : %s" (prin1 x))
  (kill-local-variable 'x)
  (message "Global x : %s" (prin1 x))
  )                                     ;"Global x : 1"


;; 不要， 直接回fundamental mode 了可还行。
(kill-all-local-variables)              ;nil
;; Most of the major mode command starts with this, which brings us back to the
;; fundamental mode by erasing the variables set by previous mode.
;;
;; Most var will be erased apart from those "marked as permanent" (by adding
;; permanent-local-hook property). Therefore, major mode variables should not be
;; marked as permanent.
;;
;; This function set the local-key-map to nil.


;;      The hook to be run by kill-all-local-variables.
;;      This gives the major mode a chance to to clean up itself.
;; Usually buffer-local
change-major-mode-hook                  ;(linum-delete-overlays font-lock-change-mode t)
(local-variable-p 'change-major-mode-hook) ;t

