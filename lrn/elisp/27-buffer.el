(bufferp (current-buffer))              ;t

;; Use current buffer
(current-buffer)                        ;#<buffer 27-buffer.el>
;; This function does not switch to that buffer
(set-buffer "*scratch*")

;; Do something temperarily with a buffer and turn back.
;;      Method 1: Save this an go there
(let ((oldbuf (current-buffer)))
  (save-current-buffer
    (set-buffer "*scratch*")
    (insert "hi"))
  )
;;      Method 2: With there
(with-current-buffer "*scratch*"
  (insert "hi"))                        ;nil

;; Use temp buffer
(with-temp-buffer
  (insert "Hi")
  (insert " there.")
  ;;return the buffer content with
  (buffer-string)
  )                                     ;"Hi there."

