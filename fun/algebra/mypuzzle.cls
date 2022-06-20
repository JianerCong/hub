\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mypuzzle}[2014/08/16 My Puzzle LaTeX class]


\LoadClass{article}
\RequirePackage{amssymb}
\RequirePackage{amsthm}
\RequirePackage{tikz}
\RequirePackage{tcolorbox}
\RequirePackage{marginnote}

\RequirePackage{geometry}
\geometry{
  a4paper,
  % total={170mm,257mm},
  right=10mm,
  left=50mm,
  top=20mm,
}

\theoremstyle{definition}
\renewcommand{\qedsymbol}{$\blacksquare$}

\setlength{\parindent}{0pt}

\renewcommand{\maketitle}{%
  % \fontsize{50}{60}\fontseries{b}%
  {
    \Huge
    \@title
  }

  \newdimen\myx%
  \myx=6pt
  \begin{tikzpicture}
    % \pgfpathcircle{\pgfpointorigin}{3pt}
    \pgfpathrectanglecorners{%
      \pgfpointorigin%
    }{%
      \pgfpoint{\myx}{-\myx}%
    }
    \pgfusepath{fill}
    \pgfpathmoveto{\pgfpointorigin}
    \pgfpathlineto{\pgfpoint{\textwidth}{0}}
    \pgfusepath{stroke}
  \end{tikzpicture}
  \medskip
}

\newcounter{question}[section]   %define a counter (renewed at each section)
\newenvironment{qst}{
  % \emph{Question} \quad
  \refstepcounter{question}
  \reversemarginpar\marginnote{
    \begin{tikzpicture}
      \node[above,font=\bf] (q) {QUESTION};
      \node[font=\large\bf,anchor=north east,
      fill=black, text=white,
      xshift=-10pt, text width=0.35cm,
      text height=0.4cm,
      text depth=0.15cm,
      text centered] at (q.south east) {\thequestion};
    \end{tikzpicture}
  }[-0.5cm]                        %shift down 0 cm
}{
  \medskip
}
\newenvironment{prf}{
  \begin{tcolorbox}[title=Proof]
      }{
        \hfill \qedsymbol%
  \end{tcolorbox}
}

% \renewcommand{\normalsize}{\fontsize{9}{10}\selectfont}
% \setlength{\textwidth}{15.5cm}
% \setlength{\textheight}{22cm}
% \setcounter{secnumdepth}{0}