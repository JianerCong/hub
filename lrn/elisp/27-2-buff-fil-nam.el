(buffer-name)                           ;"27-2-buff-nam.el"
(setq x (get-buffer "*scratch*"))       ;#<buffer *scratch*>
(kill-buffer x)                         ;t
(buffer-name x)                         ;nil
x                                       ;#<killed buffer>


;; rename this buffer
(rename-buffer "NewNameForThisBuffer")

;; find buffer
(get-buffer "*scratch*")                ;#<buffer *scratch*>

;; Get a name
(generate-new-buffer-name "oh")         ;"oh"

;; buffer file name
(buffer-file-name)                      ;"/home/me/Templates/lrn/elisp/27-2-buff-nam.el"
(buffer-file-name (other-buffer))       ;nil
buffer-file-name                        ;"/home/me/Templates/lrn/elisp/27-2-buff-nam.el"
buffer-file-truename                    ;"~/Templates/lrn/elisp/27-2-buff-nam.el"


(get-file-buffer "27-2-buff-fil-nam.el")       ;#<buffer 27-2-buff-fil-nam.el>
;; rename file
(set-visited-file-name "27-2-buff-fil-nam.el") ;t
list-buffers-directory                  ;nil
