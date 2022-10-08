;;      Send input to process

(start-process "MyProcess" "*scratch*" "bash") ;#<process MyProcess>
(process-send-string "MyProcess" "ls\n")       ;nil
(delete-process "MyProcess")                   ;nil

(start-process "MyProcess" "*scratch*" "bash") ;#<process MyProcess>
(process-list)                                 ;(#<process MyProcess>)
;; send an control-C
(interrupt-process "MyProcess")                ;"MyProcess"
(process-list)                                 ;(#<process MyProcess>)
(kill-process "MyProcess")                     ;"MyProcess"
(process-list)                                 ;nil


;;      Output
process-adaptive-read-buffering         ;t
(start-process "MyProcess" "*scratch*" "bash") ;#<process MyProcess>
(process-buffer (get-process "MyProcess"))     ;#<buffer *scratch*>
(process-mark (get-process "MyProcess"))       ;#<marker at 45 in *scratch*>
(get-buffer-process "*scratch*")               ;#<process MyProcess>

;;      Filter
(defun keep-output (p o)
  (setq kept (cons p o)))               ;keep-output

(defvar kept nil)                       ;kept
(set-process-filter (get-process "MyProcess") 'keep-output) ;keep-output

(process-send-string "MyProcess" "echo hi\n") ;nil
kept
;; (#<process MyProcess> . "hi
me@linux-box:~/Templates/lrn/elisp/38-proc$ ")






