;; Create a buffer
(get-buffer-create "hi")                ;#<buffer hi>

;; Insert some text
(with-current-buffer "hi"
  (insert "aa bb ccc dddd")
  )

;; What's the mark location now?
(with-current-buffer "hi"
  (mark)
  )                                     ;1

;; Read from buffer
(read (get-buffer "hi"))                ;aa
(read (get-buffer "hi"))                ;bb
(read (get-buffer "hi"))                ;ccc
(read (get-buffer "hi"))                ;dddd
(read (get-buffer "hi"))                ;EOF

;; Rewind
(setq m (set-marker (make-marker)
                    1
                    (get-buffer "hi"))) ;#<marker at 1 in hi>

;; Read from a marker
(read m)                                ;aa
(read m)                                ;bb
(read m)                                ;ccc

;; --------------------------------------------------
;; Read from string
(read "(aa bb) ccc d")                  ;(aa bb)

;;      Read from minibuffer
(setq ans (read t))
ans                                     ;2


;;      Read from a custome char stream
;; Step 1 set up a char list
(setq useless-list (append "XY()" nil)) ;(88 89 40 41)
;; Step 2 define the stream which is a function
(defun useless-stream (&optional unread)
  (if unread
      ;; Return the char
      (setq useless-list (cons unread useless-list))
    ;; Else, pop the first char in the list
    (prog1 (car useless-list)
      (setq useless-list (cdr useless-list))
      )
    )
  )                                     ;useless-stream
;; Step 4 Use
(read 'useless-stream)                  ;XY
(read 'useless-stream)                  ;nil
