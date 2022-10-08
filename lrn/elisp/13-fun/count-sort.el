

(defun get-rand-vec (n m)
  "get a n-long vector filled with integer in [0,m)"
  (setq l (make-vector n 0))
  (setq l (mapcar (lambda (x)
                    "set x to a random number"
                    (setf x (random* m))
                    )
                  l
                  )
        )
  l
  )

(defun hist-bin (v m)
  "Count the frequency of numbers stored in v.
The numbers range from [0,m)"
  (setq n (make-vector m 0))
  ;; we have to use seq-do, because we're using the side effect.
  (seq-do
    (lambda (x)
      (setf (elt n x) (1+ (elt n x)))
      )
    v
    )
  n
  )

;; should use (number-sequence 0 4)

(defun accu (v)
  "accumulate the values in v.
For i in [0,v.len-2): v[i+1] <- v[i] + v[i+1]"
  (mapcar (lambda (i)
            (setf (elt v (1+ i)) (+ (elt v i) (elt v (1+ i)))
                  )
            )
          (number-sequence 0 (- (length v) 2))
          )
  v
  )


(defun count-sort (v m)
  "Count sort the vector v, whose elements are in [0, m)"
  (message "Making vector for v : %s , m : %s" (princ  v) (princ  m)
           )
  (setq b (make-vector (length v) 0))   ;the return value
  (message "b is %s" (princ  b)
           )
  (setq c (accu (hist-bin v m)))        ;the position info
  (message "c is %s" (princ  c)
           )
  (seq-do
   (lambda (x)
     "for each element in v: c[x] tells us the index of x in b
Note that the index is one-based: that is, the index 1 is to be
placed in the first location."
     (setq i (elt c x))
     (setf (elt b (1- i)) x)
     ;; c[x]--
     (setf (elt c x) (- (elt c x) 1))
     )
   v
   )
  b
  )
