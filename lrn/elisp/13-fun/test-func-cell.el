(load-file "func-cell.el")

(defun test-monster ()
  (report "monster")
  (setq m (init-shooting-star-dragon))
  (shw m)
  )


(defun test-evnt-trigger ()
  "test basic envt functionality"
  (report "evnt trigger")
  (setq m1 (init-m "Cliball" 300 200))
  (setq m2 (init-m "E-HERO Clay Man" 800 2000))
  (evnt-trigger 'evnt-atk-claim m1 m2)
  ;; (evnt-trigger evnt-btl "GuGong" "Shutting Star Drag")
  )

(defun test-evnt-lisn ()
  (report "evnt-lisn" )
  (message "Before listening : %s" (princ  evnt-atk-claim))
  (evnt-lisn 'evnt-atk-claim (lambda (l)
                               (message "戦闘を無効になれ")
                               )
             )
  (message "After listening : %s" (princ evnt-atk-claim)
           )
  )

(defun test-try-catch ()
  (report "try-catch")
  (setq m1 (init-m "Cliball" 300 200))
  (setq m2 (init-m "E-HERO Clay Man" 800 2000))
  (evnt-lisn 'evnt-atk-claim
             (lambda (l)
               (message "Shooting star dragonの効果発動")
               (throw 'atk-stopped "戦闘を無効になれ")
               )
             (lambda (l)
               (message "それはどうかな"))
             )
  (evnt-trigger 'evnt-atk-claim m1 m2)
  )


;; (test-monster)
;; (test-evnt-trigger)
;; (test-evnt-lisn)
(test-try-catch)

