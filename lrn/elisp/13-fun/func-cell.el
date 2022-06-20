;; set the value cell
(setq f (lambda () 1))                  ;(lambda nil 1)
;; set the function cell
(fset 'f (lambda () 2))                 ;(lambda nil 2)
;; call the function cell
(f)                                     ;2
;; call the value cell
(funcall f)                             ;1


;; the function cell of a function
(defun b (n) (+ n 1))                   ;b
(symbol-function 'b)                    ;(lambda (n) (+ n 1))
(fset 'b 'd)                            ;d
(symbol-function 'b)                    ;d
;; Does b has a function cell?
(fboundp 'b)                            ;t
(fmakunbound 'b)                        ;b
(fboundp 'b)                            ;nil


(defun init-m (n atk def)
  "Initialize a monster whose name is n"
  (list n atk def)
  )

(defun atk (m)
  "get the attck of a monster"
  (cadr m))

(defun def (m)
  "get the defence of a monster"
  (caddr m))

(defun nam (m)
  "get the name of a monster"
  (car m))

(defun shw (m)
  "show the monster"
  (message "Monster Card: %10s ATK: %5d DEF: %5d"
           (nam m) (atk m) (def m))
  )

(if (boundp 'evnt-atk-claim) (makunbound 'evnt-atk-claim))
(if (boundp 'evnt-btl) (makunbound 'evnt-btl))
(if (boundp 'evnt-mon-eff) (makunbound 'evnt-mon-eff))

(defun init-shooting-star-dragon ()
  (setq m (init-m "Shooting star dragon" 3300 2800))
  (evnt-lisn evnt-atk-claim (lambda (l)
                              (message "Shooting star dragon の効果発動.")
                              (evnt-trigger evnt-mon-eff)
                              (message "自分を解放、攻撃を無効。")
                              )
             )
  m
  )

;; is it callable ?(Does it has an object in its function cell)
(defvar evnt-atk-claim '(
                         (lambda (l)
                           ;; (message "l is %s" (princ l))
                           (message "%s が%sに　攻撃" (nam (car l)) (nam (cadr l))))
                         )
  "the event to be triggered when one claim an attack
the listener functions are expected to handle the arguments
(l), in which:
(car l) : the attacker
(cadr l): the attackee
l : the additional info passed to listener"
  )               ;nil

;; q is the symbol that this event will be catching.
(setplist 'evnt-atk-claim '(q atk-stopped))

(defvar evnt-btl '(
                   (lambda (l) (message "%s と%s　のバトル." (nam (car l)) (nam (cadr l)) ))
                   )
  "The battle. The listeners are expected to accept
(l). See evnt-atk-claim.")
(setplist 'evnt-btl '(q atk-stopped))

(defvar evnt-mon-eff '(
                       (lambda (l) (message "%s の　効果発動。" (name (car l))))
                       )
  )
(setplist 'evnt-mon-eff '(q eff-stopped))

(defvar evnt-turn-end '(
                        (lambda () (message "Turn ended"))
                        ))
(setplist 'evnt-turn-end '(q gg))
;; evnt-turn-end can be interrupted only if game is over

(defun evnt-lisn (e &rest f)
  "Add the function f to the listener list
of event e"
  (set-default-toplevel-value e
                              (append (eval e) f)
                              )
  )

(defun evnt-trigger (e &rest i)
  "trigger the event e with the info i.
For each f in e:
    try f(i)
    catch e: stop
"
  (setq r (get e 'q))
  ;; (message "i is %s. Is it a list? :%s . What is car %s" (princ i) (listp i) (car i))
  (message "the symboll to catch is %s" (symbol-name r))
  (setq err
        (catch r
          (mapcar (lambda (f) (funcall f i)) (eval e))
          )
        )
(if err
    (message "NANI? %s" err)
  )
)

