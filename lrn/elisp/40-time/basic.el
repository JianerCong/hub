(current-time)                          ;(25006 18527 949388 590000)
(decode-time)                           ;(37 29 17 6 12 2021 1 nil 0)
;;                                        sec min hours day month year dayofweek daylightdaving? UTC offset
(defun what-time-is-it-now ()
  (elt (decode-time) 2)
  )
(what-time-is-it-now)                   ;17

