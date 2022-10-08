(get-buffer-create "hi")                ;#<buffer hi>
(make-indirect-buffer "hi" "hi2")       ;#<buffer hi2>
(buffer-base-buffer (get-buffer "hi2")) ;#<buffer hi>

(with-current-buffer "hi"
  (insert "oh")
  (buffer-string))                      ;"ohoh"

(with-current-buffer "hi2"
  (buffer-string))                      ;"ohoh"

(kill-buffer "hi")                      ;t
(kill-buffer "hi2")                     ;ERROR



