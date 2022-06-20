
(defun g ()
  (throw 'e "oh")
  ;; Throw the error 'e and make the catch clause return "oh"
  "No")                                 ;g

(defun f ()
  (print
   (catch 'e
     (g))
   )
  (print (format "Yes"))
  ) ;; f

(f)                                     ;"Yes"


(defun p1 (i)
  (print "p1's term"))

(defun p2 (i)
  (print "p2's term")
  (when (> i 1)
    (print "神の召喚")
    (throw 'over "p2")
    )
  )

(defun go ()
  "Play the games"
  (dotimes (i 3)
    (p1 i)
    (p2 i)
    )
  )

(defun game ()
  (print (format "Winner is %s"
                 (catch 'over
                   (go)
                   )
                 )
         )
  "Game is over"
  )

(game)

;;      Error
(error "Oh")                            ;
(error "Hi %s" "an error")              ;

;;      Define errors
;; Each error symbol has a perent. 'error is the root of error hierarchy.
;; When defining an error, specify its parent. (Default is 'error)
(define-error 'my-error "程序死了")     ;"程序死了"
(define-error 'my-error2 "原因不明" 'my-error) ;"原因不明"

(signal 'my-error '())
(signal 'my-error2 '(x y z))

(signal 'wrong-number-of-arguments '(x y)) ;

;; Use user errors
(user-error "oh")

;;      Clean up with unwind-protect
(unwind-protect
    (error "oh")
  (message "hi"))                       ;message always called.

(let ((buffer (get-buffer-create " *temp*")))
  (with-current-buffer buffer
    (unwind-protect
        (insert "oh")
      "Do something"
      (kill-buffer buffer))))

;;      Handle errors
(condition-case nil
    (signal 'my-error '())                                  ;Protected form thousand lines goes here.
  (my-error "Oh")                                           ;If my-error is caught: return...
  (error "Fine")                                            ;Else return ...
  )                                     ;"Oh"

;;      Turn on debugger even error is handled.
(condition-case nil
    (signal 'error '())
  ((debug error) nil))

;; Conditional case and catch-throw are independent.
(define-error 'e1 "e1" 'my-error)       ;"e1"
(define-error 'e2 "e2" 'my-error)       ;"e2"

(condition-case err
    (signal 'e1 "Ah?")
  ;; Handle both e1 and e2
  ((e1 e2) "oh")
  (error (progn
           (message "Error says %s" (error-message-string err))
           ;; re-throw
           ;; (signal (car err) (cdr err))
           )
         )
  )                                     ;"oh"


