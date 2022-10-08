;; Write a function that ask for  your name and say hi .
(progn
  (defun get-time-greeting ()
    (setq x (what-time-is-it-now))
    (cond ((or (> x 22) (< x 3))
           "I knew you are awake too")
          ((> x 20) "Good Night")
          ((> x 17) "Good Evening")
          ((> x 12) "Good Afternoon")
          (t "Morning")
          )
    )
  (defun what-time-is-it-now ()
    "Get the hour now"
    (elt (decode-time) 2)
    )
  (message
   "%s. %s" (get-time-greeting)
   (read-string "What is your name?: ")
   )
  )
