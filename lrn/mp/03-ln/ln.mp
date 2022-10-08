prologues := 3;
outputtemplate := "%j-%c.mps";
outputformat := "svg";


beginfig(1);
% Solve linear equation
  a+b = 3;
  2a = b+3;
  show a,b;
endfig;

beginfig(2);
  % zn is the abbrev of (xn,yn)
  % So you can mix z and xy:
  z1=-z2=(.2in,0);
  x3=-x6=.3in;
  x3+y3=x6+y6=1.1in;

  z4=1/3[z3,z6];
  z5=2/3[z3,z6];

  % z20 is the intersectionpoint of z1-z3 and z2-z4
  % z50 is at an unknown position along the line [z1,z3]
  z50=aa[z1,z3];
  % Equivalent Toni :
  %  z50 = z1 + whatever*(z3-z1)

  % whatever is just an anonymous var
  z20=whatever[z1,z3]=whatever[z2,z4];
  z30=whatever[z1,z4]=whatever[z2,z5];
  z40=whatever[z1,z5]=whatever[z2,z6];

  draw z1 -- z20 -- z2 -- z30 -- z1 -- z40 -- z2;
  pickup pencircle scaled  1pt;
  draw z1 -- z2;
  draw z3 -- z6;
  pickup pencircle scaled  4pt;
  drawdot z1; drawdot z2; drawdot z3; drawdot z4;
  drawdot z5; drawdot z6; drawdot z20; drawdot z30;
  drawdot z40;
endfig;
end
