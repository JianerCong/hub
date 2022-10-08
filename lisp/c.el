(load-file (concat path-template "c-shared.el"))



(setq c-my-includes-alist
      '(
        ("l" . "<stdlib.h>")
        ("i" . "<stdio.h>")
        ("t" . "<time.h>")
        ("s" . "<string.h>")
        ("r" . "<regex.h>")
        ("n" . "<stdint.h>")            ;int8_t and uint8_t UINT8_MAX
        )
      )


(define-skeleton c-add-my-lib
  "Include my lib"
  > "#ifdef _WIN32
#include \"C:\\Users\\congj\\AppData\\Roaming\\Templates\\mylib.h\"
#else
#ifdef __arm__
#include \"/home/pi/Templates/mylib.h\"
#else
#include \"/home/me/Templates/mylib.h\"
#endif
#endif"
  )




(define-skeleton c-include
  "insert some include directive"
  nil
  '(setq p  "Enter the next include (e.g. <iostream> or <stdio.h>). ")
  > ((skeleton-read (concat p (alist-to-menu c-my-includes-alist))) "#include "
     str
     (delete-and-handle-choice str c-my-includes-alist)
     \n)
  )


(define-key c-mode-map (kbd "\C-c i") 'c-include)
(define-key c-mode-map (kbd "\C-c v") 'c-say)
(define-key c-mode-map (kbd "\C-c l") 'c-add-my-lib)

