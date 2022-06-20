prologues := 3;
outputtemplate := "%j-%c.mps";
outputformat := "svg";

beginfig(1);
  u=1cm;
  draw origin -- (4*u,4*u) -- (4*u,0) -- (0,4*u);
  pickup pencircle scaled 4pt;
  for i=0 upto 4:
    for j=0 upto 4:
      drawdot (i*u,j*u);
    endfor
  endfor
endfig;
end
