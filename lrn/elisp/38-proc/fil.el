;; Process filter

(start-process "MyProcess" "*scratch*" "bash") ;#<process MyProcess>
(set-process-filter (get-process "MyProcess") (lambda (p s)
                                                (message "Process %s says:\n %s\n" (process-name p) s)
                                                )
                    )
;; When a process has a non-default filter, its buffer is not used for output.
;; Instead, each time it does output, the entire string of output is
;; passed to the filter.
;; The filter gets two arguments: the process and the string of output.
(process-send-string "MyProcess" "ls\n")
(delete-process "MyProcess")
