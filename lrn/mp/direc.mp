prologues := 3;
outputtemplate := "%j-%c.mps";
outputformat := "svg";

beginfig(1);
  % Speficy an in/out degree. The {dir 0} is {right} and {dir 90} is {up}
  for a=0 upto 7:
    draw (0,0){dir 45}..{dir 10a}(6cm,0);
  endfor
  for a=0 upto 7:
    draw origin{dir 45}..{dir -10a}(9cm,0);
  endfor
endfig;
end
