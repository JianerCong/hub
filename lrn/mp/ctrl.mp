
prologues := 3;
outputtemplate := "%j-%c.mps";
outputformat := "svg";

beginfig(1);
  u = 1cm;
  z0 = (3*u,3*u) ;
  z1 = (3.1*u,2.4*u); z2 = (4.5*u,1.6*u);
  z3 = (6.2*u,1.9*u); z4 = (6.5*u,2.6*u); z5 = (5.95*u,2.5*u);
  z6 = (4.5*u,2.5*u); z7 = (3.5*u,3.1*u);
  % you can add control points
  pickup pencircle scaled  1pt;
  draw z0..controls (3*u,4*u) and (2*u,2*u)
    ..z1..z2..z3..z4..z5..z6..z7..cycle;
endfig;


beginfig(2);
  % Use arrow to guide
  % u = 1cm;
  z0 = (0*u,0*u); z1 = (1*u,1*u); z2 = (0.5*u,2*u); z3 = (0.25*u,1.5*u);
  z4 = (0.3*u,1.25*u);

  draw z0..z1{up}..z2{left}..z3..z4;
endfig;

beginfig(3);
  % Speficy an in/out degree. The {dir 0} is {right} and {dir 90} is {up}
  for a=0 upto 7:
    draw (0,0){dir 45}..{dir 10a}(6cm,0);
  endfor
  for a=0 upto 7:
    draw origin{dir 45}..{dir -10a}(9cm,0);
  endfor
endfig;

beginfig(4);
  % You can suppress inflation point by using ...
  z0 = (0*u,0*u); z1 = (5*u,1*u); z2 = (10*u,0*u);
  draw z0{up}..z1{right}..z2{down};
  pickup pencircle scaled  4pt;
  draw z0{up}...z1{right}...z2{down};

  % You can also increse tension
  z0 := (0*u,5*u); z1 := (5*u,20*u); z2 := (10*u,20*u); z3 := (15*u,5*u);
  draw z0..z1..z2..z3;
  draw z0..z1..tension 1.3 ..z2..z3;
  draw z0..z1..tension 1.5 and 1..z2..z3;
endfig;
end
