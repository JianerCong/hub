\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{myclass}[2014/08/16 Example LaTeX class]

\newcommand{\headlinecolor}{\normalcolor}
\RequirePackage{xcolor}
\definecolor{slcolor}{HTML}{882B21}

\DeclareOption{onecolumn}{\OptionNotUsed}
\DeclareOption{green}{\renewcommand{\headlinecolor}{\color{green}}}
\DeclareOption{red}{\renewcommand{\headlinecolor}{\color{slcolor}}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[twocolumn]{article}

\renewcommand{\maketitle}{%
  % twocolumn[text in one colum] text in two columns
  % Use this to temperarily switch back to two columns
  \twocolumn[%
  \fontsize{50}{60}\fontfamily{phv}\fontseries{b}%
  \fontshape{sl}\selectfont\headlinecolor
  \@title
  \medskip
  ]%
}

\renewcommand{\section}{%
  \@startsection
  {section}{1}{0pt}{-1.5ex plus -1ex minus -.2ex}%
  {1ex plus .2ex}{\large\sffamily\slshape\headlinecolor}%
}

\renewcommand{\normalsize}{\fontsize{9}{10}\selectfont}
\setlength{\textwidth}{17.5cm}
\setlength{\textheight}{22cm}
\setcounter{secnumdepth}{0}