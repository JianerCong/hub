


;; Custom type.
(defcustom my-pokemon "Phyduck"
  "The pokemon of mine"
  :type '(string)
  ;; is a list of '(typename [key-value pair ...] [args ...])
  )

;; Simple types
(defcustom my-number 11
  "my number"
  :type '(number)
  ;; number is afor regular simple type, others are: sexp float string regexp character ...
  ;; file variable face boolean key-sequence color
  )

(defcustom my-regex "my"
  "my prefix as regex"
  :type '(regex)
  )


;; Compound type
(defcustom my-birthday '(2 . 11)
  "my birthday"
  :type '(cons integer integer)
  )


(defcustom my-ygo-info '(0 200 "Angle-type")
  "my data for ygo as (atk def attribute)"
  :type '(list integer integer string)
  )


(defcustom my-mh-info '(50 "Long Sward")
  "The data for mh as (HP tools). In the Customization Group
you see that `group ' is same as 'list', just some ui
diffeerences."
  :type '(group integer string)
  )

(defcustom my-unkown-animal '(("koalas" 18) ("human" 1))
  "The animals that we knows. with (animal-name sleep-hrs)"
  :type '(alist :key-type string :value-type (group integer))
  ;; Use group for better formatting
  :options '("human")
  )

(defcustom my-ygo-data '(
                            ("Aloof Lupine" 1700 300 nil)
                            ("Blue Eyes" 3000 2500 t)
                            )
  "The ygo cards info as (NAME ATK DEF IS-NORMAL)"
  :type '(alist :value-type (group integer integer boolean))
  )


(defcustom my-ygo-data-plist '("Blue Eyes" t "Aloof Lupine" nil)
  "The ygo cards info as (name is-effect)"
  :type '(plist :key-type string :value-type (group boolean)))

(defcustom my-age 2
  "Your age can be an int or a string."
  :type '(choice (integer :tag "Your age in integer")
                 (string :tag "Or do U wanna say something?")
                 (const :tag "Don't wanna say" nil)
                 )
  )

(defcustom my-age-2 2
  "Your age can be an int or a string.
Use radio fro diffeerent UI"
  :type '(radio (integer :tag "Your age in integer")
                 (string :tag "Or do U wanna say something?")
                 (const :tag "Don't wanna say" nil)
                 )
  )

(defcustom my-should-grapes-be-green nil
  "Do you think green grapes is better than purple grapes?"
  :type '(radio (const :tag "Yes" t)
                (const :tag "No" nil)
                (other :tag "Ask" oh)
                )
  )

(defun my-frog () "A 🐸 function" (message "🐸"))
(defun my-thk () "A 🤔 function" (message "🤔"))

(defcustom my-init 'my-frog
  "What is your init function?"
  :type '(radio
          (function-item my-frog)
          (function-item my-thk)
          )
  )

(defvar my-a 1 "My var a")
(defvar my-b 1 "My var b")

(defcustom my-var 'my-a
  "My variable option can be either a or b"
  :type '(radio
          (variable-item my-a)
          (variable-item my-b)
          )
  )

;; Use set to make a checklist
(defcustom my-font nil
  "My font"
  :type '(set (const :bold)
              ;; each types can have a specified value or nil
              (const :italic)
              (cons :tag "Size" (const size) integer)
              )
  )

(defcustom my-numbers nil
  "My numbers can be any amount of integers"
  :type '(repeat integer))

;; After using INSERT in Customize:
my-numbers                              ;(3 5)


(defun valid-month (x) "test if x is 1-12"
  (if (integerp x)
      (if (and (< x 13) (> x 1))
          t
        nil
        )
    nil
    )
  )

(defcustom my-month 2
  "My month should be an integer within 1-12, or not-known"
  :type '(restricted-sexp :match-alternatives
                          (
                           valid-month
                           'not-known
                           ;; ^^^^^^^ makes not-known an options
                           )
                          )
  )

(defcustom my-SYNC-material '(tuner non-tuner)
     "My S-Summon material is a list of a tuner monster and one
     or more non-tuner monster"
     :type '(list (const tuner)
                  (const non-tuner)
                  ;; Use "set" to make an optional material
                  (repeat :inline t
                       (const non-tuner))
                  )
     )
my-SYNC-material                        ;(tuner non-tuner non-tuner non-tuner non-tuner non-tuner)

(defcustom my-XYC-material '(me t)
  "My XYZ material can be either (me t): which means Caos
  XYZ-changes. Or (me em em) which means normal OVERLAY"
  :type '(list (const me)
               (radio (const t)
                       (list :inline t
                             (const em)
                             (const em)
                             )
                       )
               )
  )

(defcustom my-int '(2)
  "A simple int but formatted.
The formated value only works for customized type."
  :type '(list (integer
                :tag "MyTAG 🐸"
                :format "The value is %v, the doc is %d, the tag is %t %[PRESS ME%]"
                :doc "MyDOC 🐸"
                ;; press button with mouse
                :action (lambda (x y) (message "You pressed the button with
x:\n\n %s\ny:\n\n %s 🐸"
                                               x y))
                :button-suffix "->"
                :button-prefix "<-"
                )
               )
  )

(defun f (w v)
  "The match function, return non-nil if the value v is
  acceptable"
  (message "🐸 Match function called for w:\n %s \n v:%s "
           w v)
  (if (eq v 2)
      nil
    t)
  )

(defcustom my-int '(4)
  "A simple int, but it cannot be set to 2"
  :type '(list (integer
                :match f
                )
               )
  )
my-int

(define-widget 'binary-tree-of-string
  'lazy                                 ;the super class(inherite this to
                                        ;prevent infinite recursion)
  "A binary tree node"
  :tag "Node"                           ;the type name
  :offset 4                             ;the tab indent in Customize
  :type '(choice (string :tag "Leaf" :value "")
                 ;; Do not use radio -> it will expand infinitely in Customize
                (cons :tag "Interior"
                      :value ("" . "")
                      binary-tree-of-string
                      binary-tree-of-string
                      )
                )
  )
;; Do M-x widget-browse

(defcustom my-tree ""
  "My binary tree of string"
  :type 'binary-tree-of-string)


;; Set variables
my-number                               ;11
(custom-set-variables '(my-number 3))   ;nil
my-number                               ;3
