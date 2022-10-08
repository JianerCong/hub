prologues := 3;
outputformat := "svg";

input TEX;
outputtemplate := "n-tex-labs.svg";
beginfig(1);
  last = 10;
  for i:=0 upto last:
    label(TEX("$n_{" & decimal(i)& "}$"),
        (5mm * i, 0));
    endfor
endfig;


outputformat := "eps";
outputtemplate := "n-latex-labs.eps";
beginfig(2);
  last := 10;
  TEXPRE("%&latex" & char(10) & "\documentclass{article}\begin{document}");
  %                 ^^^^^^^^^----the new line char
  TEXPOST("\end{document}");
  for i:=0 upto last:
    label(TEX("\( n_{" & decimal(i) & "} \)"),
        (5mm * i, 0));
  endfor
endfig;

end
