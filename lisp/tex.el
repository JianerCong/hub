
(defun my-make-skeleton (s1 s2 s3 s4)
  "Make a tiny skeleton.
s1 is inserted at the front, s2 is the prompt string, s3 is
inserted after the prompt, s4 will be placed at the end. So it's
s1 <prompt s2> s3 _ s4
"
  (let ((s1 s1)
                (s2 s2)
                (s3 s3)
                (s4 s4)
                )
    #'(lambda ()
        (interactive)
        (skeleton-insert (list nil s1 (list 'skeleton-read s2)  s3 '_ s4))
        )
    )
  )

(define-skeleton tex-myset
  "Insert a MySet boiler plate"
  nil
  > (
     "variable" \n
     "\\MySet{" str "}{\\textcolor{blue}{\\texttt{"
     str
     "}}}"
     )
  )

(fset 'tex-tikz-inputpage (my-make-skeleton "\\inpage[" "page dimension:" "]{" "}"))

(define-skeleton luatex-boiler-plate
  "Insert the boiler plate"
  nil
  "\\documentclass[12pt, a4paper, oneside]{ctexart}" \n
  "\\title{" (skeleton-read "Title ?") "}" \n
  "\\usepackage{geometry}"
  "\\geometry{" \n
  "a4paper," \n
  "total={170mm,257mm}," \n
  "left=20mm," \n
  "top=20mm," \n
  "}" \n
  > "\\author{Me}" \n
  > "\\date{\\today}" \n
  > "\\begin{document}" \n
  > "\\maketitle" \n
  >  _ \n
  >"\\end{document}"
  )

(define-skeleton tex-boiler-plate
  "Insert the boiler plate"
  nil
  "\\documentclass{article}" \n
  "\\title{" (skeleton-read "Title ?") "}" \n
  "\\usepackage{geometry}"
  "\\geometry{" \n
  "a4paper," \n
  "total={170mm,257mm}," \n
  "left=20mm," \n
  "top=20mm," \n
  "}" \n
  > "\\author{Me}" \n
  > "\\date{\\today}" \n
  > "\\begin{document}" \n
  > "\\maketitle" \n
  >  _ \n
  >"\\end{document}"
  )

(define-skeleton tex-mymatrix
  "Insert a matrix boilerplate"
  nil
  "\\matrix (M-" (setq s (skeleton-read "Parent ?")) ") [myMatrix, text width=8cm]"
  " at ([shift={(1cm,-2cm)}]  " s ".south){" \n
  _ \n
  "\\\\};"
  )

(define-skeleton tex-exam-boiler-plate
  "Insert ann exam template"
  nil
  "\\documentclass{exam}" \n
  "\\begin{center}" \n
  "{\\Huge " (skeleton-read "Title ?: ")"}" \n
  "\\end{center}" \n
  "\\begin{document}" \n
  "\\begin{questions}" \n
  _ \n
  "\\end{questions}" \n
  "\\end{document}"
  )

(define-skeleton tex-tikz-boiler-plate
  "Insert the boiler plate"
  nil
  "\\documentclass[border=0.2cm]{standalone}" \n
  "\\title{" (skeleton-read "Title ?") "}" \n
  "\\author{Jianer Cong}" \n
  "\\usepackage{tikz}" \n
  "\\usetikzlibrary{shapes} % ellipse node shape" \n
  "\\usetikzlibrary{shapes.multipart} % for line breaks in node text" \n
  "\\usetikzlibrary{arrows.meta}    %-o arrow head" \n
  "\\usetikzlibrary{arrows}" \n
  "\\begin{document}" \n
  >  _ \n
  "\\end{document}")


(defun quoted-parentheses (arg)
  (interactive "P")
  ;; if the text before point is \
  (if (looking-back "\\\\")
      (skeleton-insert '(nil "(" _ "\\)") -1)
    (skeleton-pair-insert-maybe arg)))


;; (keymapp TeX-mode-map)
;; (keymapp LaTeX-mode-map)

(define-key LaTeX-mode-map (kbd "\C-c f") 'tex-boiler-plate)
(define-key LaTeX-mode-map (kbd "\C-c t") 'tex-tikz-boiler-plate)
(define-key LaTeX-mode-map (kbd "\C-c e") 'tex-exam-boiler-plate)


;; LaTeX-mode uses latex-mode-abbrev-table
(when (boundp 'latex-mode-abbrev-table)
  (clear-abbrev-table latex-mode-abbrev-table)
  (define-abbrev-table 'latex-mode-abbrev-table
    '(
      ("nd" "" (lambda () (skeleton-insert
                           '(nil "\\node (" (setq x (skeleton-read "Name: "))
                                 ") [text width=8cm] " \n
                                 "{\\begin{ifaceBox}[title=\\texttt{" x "}]" \n
                                 _ \n
                                 "\\end{ifaceBox}};"))))
      ("tw" "text width=")
      ("nt" "\\notag\\\\")
      ("nte" "\\notag")
      ("dr" "\\draw")
      ("tm" "\\times")
      ("ip" "" tex-tikz-inputpage)
      ("gt" "\\MyGet" )
      ("mb" "\\mbox")
      ("mwhr" " \\\\[-1cm]               %remove the extra spacing
  \\intertext{Where}
  \\\\[-1cm]               %remove the extra spacing")
      ("whr" "\\intertext{Where}")
      ("tx" "\\text")
      ("Ep" "\\emoji{parrot}")
      ("Et" "\\emoji{turtle}")
      ("mt" "" (lambda () (skeleton-insert '(nil "\\[" _ "\\]"))))
      ("Ca" "" (lambda () (skeleton-insert '(nil "\\Cola{" _ "}"))))
      ("ttt" "" (lambda () (skeleton-insert '(nil "[title=\\texttt{" _ "}]"))))
      ;; ("vb" "" (lambda () (skeleton-insert '(nil "\\verb|" _ "|"))))
      )
    )
  )


(when (boundp 'plain-tex-mode-abbrev-table)
  (clear-abbrev-table plain-tex-mode-abbrev-table)
  (define-abbrev-table 'plain-tex-mode-abbrev-table
    '(
      ("hh" "haha")
      ("hb" "\\hbox")
      ("Iff" "\\Leftrightarrow")
      ("na" " \\noalign{\\kern 2pt} ")
      ("hf" "\\hfil")
      ("bk" "\\bigskip")
      ("wtp" "Winnie-the-Pooh")
      ("Cr" "Christopher Robin")
      ("qd" "\\quad")
      ("ni" "\\noindent")
      ("ddd" "\\cdots")
      ("myHeader" 
  "
% Color
\\newcommand{\\mycola}{MidnightBlue}
\\newcommand{\\mycolb}{Mahogany}
\\newcommand{\\mycolc}{OliveGreen}

\\newcommand{\\cola}[1]{\\textcolor{\\mycola}{#1}}
\\newcommand{\\colb}[1]{\\textcolor{\\mycolb}{#1}}
\\newcommand{\\colc}[1]{\\textcolor{\\mycolc}{#1}}
\\newcommand{\\Cola}[1]{\\textcolor{\\mycola}{\\emph{#1}}}
\\let\\emph\\relax % there's no \\RedeclareTextFontCommand
\\DeclareTextFontCommand{\\emph}{\\bfseries\\em}
\\usepackage{fontspec}
\\setmonofont{Cascadia}[
Path=/usr/share/fonts/truetype/Cascadia_Code/,
Scale=0.85,
Extension = .ttf,
UprightFont=*Code,              %find CascadiaCode.ttf
BoldFont=*CodePL,               %find CascadiaCodePL.ttf ...
ItalicFont=*CodeItalic,
BoldItalicFont=*CodePLItalic
]
\\usepackage{minted}
\\usepackage{tcolorbox}
\\tcbuselibrary{skins}
\\tcbuselibrary{minted}
\\usepackage{tikz}
\\usetikzlibrary{shapes} % ellipse node shape
\\usetikzlibrary{shapes.multipart} % for line breaks in node text
\\usetikzlibrary{arrows.meta}    %-o arrow head
\\usetikzlibrary{arrows}
\\usetikzlibrary{matrix}


% Redefine em
% latex.sty just do: \\DeclareTextFontCommand{\\emph}{\\em}

\\let\\emph\\relax % there's no \\RedeclareTextFontCommand
\\DeclareTextFontCommand{\\emph}{\\bfseries\\em}
% cjk
\\usepackage{xeCJK}
\\usepackage{amsmath}
" \n
       )
      ))                                  ;nil
  )


;; To add a self-defined pair, first redefine this list, next define key
(setq skeleton-pair t)                  ;t
(setq skeleton-pair-alist '(
                            ;; -1 means '(delete-char -1)
                            (?\" -1 ?` ?` _ "''")
                            ;; (?\( _ "''")
                            )
      )

(when (boundp 'plain-TeX-mode-map)
  (define-key plain-TeX-mode-map "$" 'skeleton-pair-insert-maybe)
  (define-key plain-TeX-mode-map "\"" 'skeleton-pair-insert-maybe)
  (define-key plain-TeX-mode-map "(" 'quoted-parentheses)
  )

(when (boundp 'LaTeX-mode-map)
  (define-key LaTeX-mode-map "$" 'skeleton-pair-insert-maybe)
  (define-key LaTeX-mode-map "\"" 'skeleton-pair-insert-maybe)
  (define-key LaTeX-mode-map "(" 'skeleton-pair-insert-maybe)

  (when (boundp 'cdlatex-mode-map)
    ;; cdlatex overwrites the LaTeX map
    (define-key cdlatex-mode-map "(" 'skeleton-pair-insert-maybe)
    )
  (define-key LaTeX-mode-map (kbd "\C-c \C-p") 'outline-previous-visible-heading)
  (define-key LaTeX-mode-map (kbd "\C-c \C-n") 'outline-next-visible-heading)
  (define-key LaTeX-mode-map (kbd "\C-c \C-u") 'outline-up-heading)
  )



(defvar my-deletion-skeletons-alist
  '(
    (?\( . ?\))
    (?$  . ?$)
    )
  )
(defadvice delete-backward-char (before delete-empty-pair activate)
  (if (eq (cdr (assq (char-before) my-deletion-skeletons-alist)) (char-after))
      ;; if the char-after == l[char-before]
      (and (char-after) (delete-char 1)))
  )
