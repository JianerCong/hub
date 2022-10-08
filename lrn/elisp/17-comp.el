;; Byte-compiling
(defun simple-loop (n)
  "Returns the time in s ,to loop n times"
  (let ((t1 (float-time)))
    (while (< 0 (setq n (1- n))))
    (- (float-time) t1)
    )
  )                                     ;simple-loop

(simple-loop 5e7)                       ;4.11790919303894
;; 4.159248828887939


(byte-compile 'simple-loop)             ;#[(n) "\302 \303	S\211W\204 \302 Z)\207" [t1 n float-time 0] 3 "Returns the time in s ,to loop n times"]

(simple-loop 5e7)                       ;1.2349741458892822
;; 1.479093074798584

;; The command that compile the defun at point.
(compile-defun)

(defun f ()
  2)                                    ;f
f
(f)                                     ;2


(byte-compile-file "hi.el")
