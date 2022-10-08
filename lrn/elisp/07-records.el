;; Records likes vectors. Slots can be accessed by aref. Can be copied by
;; copy-sequence.
(setq r (record 'my-record  2 nil))     ;#s(my-record 2 nil)
(recordp r)                             ;t
(recordp #s(a))                         ;t
(setq r2 (make-record 'hi 3 'Z))        ;#s(hi Z Z Z)
(aref r 0)                              ;my-record
(aref r 1)                              ;2
