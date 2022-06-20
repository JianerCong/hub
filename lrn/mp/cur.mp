prologues := 3;
outputtemplate := "%j-%c.mps";
outputformat := "svg";

beginfig(1);
  u = 0.5cm;
  z0 = (1*u,7*u); z1 = (0*u,4*u);
  z2 = (2*u,1*u); z3 = (5*u,0*u);
  z4 = (8*u,1*u); z5 = (9*u,3*u);
  z6 = (9.2*u,5*u); z7 = (8.5*u,7*u);
  z8 = (8*u,8.5*u); z9 = (6*u,7*u);
  z10 = (4.5*u,7.5*u); z11 = (3*u,7*u);
  z12 = (2*u,9*u);


  
  % Outline
  draw z0..z1..z2..z3..z4..z5..z6..z7--z8--z9..z10..z11--z12--cycle;

  % Two eyes
  pickup pencircle scaled  4pt;
  drawdot (3*u,5*u);
  drawdot (7*u,5*u);


  endfig;
  end
