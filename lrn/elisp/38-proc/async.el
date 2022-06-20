;; An asynchronous process is controlled either via a pty (pseudo-terminal) [interactive] or a pipe[efficient]. 
(make-process :name "MyProcess")        ;#<process MyProcess>
(make-process :name "MyProcess2" :buffer (get-buffer "*scratch*")) ;#<process MyProcess2>
(make-process :name "MyProcess3" :buffer (get-buffer "*scratch*") :command '(nil)) ;#<process MyProcess3>

(delete-process "MyProcess")            ;nil
(delete-process "MyProcess2")           ;nil
(delete-process "MyProcess3")           ;nil

(make-process :name "MyProcess" :buffer (get-buffer "*scratch*") :command '("bash")) ;#<process MyProcess>
;; Doesn't quiet work.
(delete-process "MyProcess")            ;nil

(make-process :name "MyProcess" :buffer (get-buffer "*scratch*") :command '("echo" "hi")) ;#<process MyProcess>
;; Work

(make-process :name "MyProcess" :buffer (get-buffer "*scratch*") :command '("ls")) ;#<process MyProcess>


;;      Higher level
(start-process "my-process" "*scratch*" "ls" "-l" "/home/me") ;#<process my-process>
(start-process "my-process" "*scratch*" "sleep" "10")         ;#<process my-process>

;; Process connection type is terminal?
process-connection-type                 ;t
;; Delete
delete-exited-processes                 ;t

;;      Info
(make-process :name "p1")               ;#<process p1>
(make-process :name "p2")               ;#<process p2>
;; List process
(list-processes)                        ;nil
;; List process in *scratch*
(list-processes nil (get-buffer "*scratch*")) ;nil
(get-process "p1")                            ;#<process p1>
(process-list)                                ;(#<process p2> #<process p1>)
(start-process "p3" "*scratch*" "sleep" "100") ;#<process p3>
(process-command (get-process "p3"))           ;("sleep" "100")
(process-name (get-process "p1"))              ;"p1"
(process-status "p1")                          ;run
(process-live-p (get-process "p1"))            ;(run open listen connect stop)
(process-plist (get-process "p1"))             ;nil
(delete-process "p1")                          ;nil
(delete-process "p2")                          ;nil



