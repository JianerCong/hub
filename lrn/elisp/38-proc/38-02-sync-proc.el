;; Sync process


;;      The working dir for the subproccess
default-directory                       ;"~/Templates/lrn/elisp/38-proc/"


;; Set inputfile=nil (not input), output=t (insert to current buffer before point)
(call-process "date" nil t)             ;2021年 09月 04日 星期六 13:38:20 CST
;; Output to buffer
(call-process "date" nil "*scratch*")   ;0
(call-process "date" nil (get-buffer "*scratch*")) ;0
;; Output to file
(call-process "date" nil '(:file "date.txt")) ;0

;; Discard output with nil;
(call-process "date" nil nil)           ;0


;; The forth arg is "display";If display is non-nil, then call-process
;; redisplays the buffer as output is inserted.
(call-process "date" nil "*scratch*" t) ;0

;; The rest are the arguments
(call-process "echo" nil t nil "hi")    ;hi
(call-process "sleep" nil nil nil "5")  ;0


;; Should use (sleep-for x)
(defun sleep (x)
  "Sleep x second"
  (call-process "sleep" nil nil nil (format "%d" x))
  ;; (message "Good morning 🐸")
  )

(dotimes (x 5)
  (insert (if (eq 0 (mod x 2)) "yes" "no") "?")
  (insert "..")
  (sleep-for 3)
  )

;; yes?..no?..yes?..no?..yes?..
(call-process "cat" nil t nil "date.txt") ;2021年 09月 04日 星期六 13:43:22 CST
;; Another way
;; (process-file "cat" nil t nil "date.txt") ;2021年 09月 04日 星期六 13:43:22 CST

;; Send text from start-to-end to stdin of a proc
Okay (point-at-bol) ;1296
(call-shell-region 1296 1300 "cat" nil t) ;Okay0

;; Return the string output
(shell-command-to-string "echo hi")     ;"hi"


