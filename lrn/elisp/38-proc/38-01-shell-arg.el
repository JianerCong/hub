(shell-quote-argument "hi > hi.txt")    ;"hi\\ \\>\\ hi.txt"

;; Split: the second argument is the regex of seperator
(split-string-and-unquote "echo hi there") ;("echo" "hi" "there")
(split-string-and-unquote "echo+hi+oh" "\\+") ;("echo" "hi" "oh")
(split-string-and-unquote
 "A and B and C" "\\s-+and\\s-+")       ;("A" "B" "C")

;; Combine
(setq l '("Kartana" "Kangaskhan" "Crayfish" "Tadpoles"))      ;("Kartana" "Kangaskhan")
;; ("Kartana" "Kangaskhan" "Crayfish" "Tadpoles")

(combine-and-quote-strings l " and ")   ;"Kartana and Kangaskhan and Crayfish and Tadpoles"

