% Use label
prologues := 3;
outputtemplate := "%j-%c.mps";
outputformat := "svg";

beginfig(1);
  u = 1cm;
  for i := 1 upto 10:
    for j := 1 upto 10:
      drawdot (i*u,j*u);
    endfor
  endfor
  label.top("inside the brain of a duck",(5*u,5*u))
endfig;

beginfig(2);
  a=.7in;
  b=.5in;

  z0 = origin;
  z1 = -z3 = (a,0);
  z2 = -z4 = (0,b);

  draw z1 -- z0 -- z2;
  draw z1..z2..z3..z4..cycle;

  label.top("Major", .5[z0,z1]);
  label.lft("Minor", .5[z0,z2]);
  dotlabel.bot("(0,0)",z0);
  picture p;
  p := thelabel.ulft("'You didn't exactly {\it miss}, said Pooh", (a,b));
  draw p;
endfig;

beginfig(3);
  for i:=0 upto 5:
    z[i] = 1in * (i,sqrt i);
    drawdot z[i];
  endfor
  % same as dotlabel.rt("0",z0); dotlabel.rt("1", z1),...,
  dotlabels.rt(0,1,2,3,4,5);
  show "The default font is", defaultfont,
    "The default scale", defaultscale,"Where scale of 1 is 10pt";
    % "fontsize is",
    % fontsize;
  defaultfont :="ptmr8r";
endfig;

beginfig(4);
  % tex it
  numeric u;
  u = 1cm;
  draw (0*u,2*u)--(0*u,0*u)--(4*u,0*u);
  pickup pencircle scaled  1pt;
  draw (0,0){up}
    for i=1 upto 8:
    ..(i/2,sqrt(i/2))*u
  endfor;
  label.lrt(btex $\sqrt x$ etex, (3,sqrt 3)*u);
  label.bot(btex $x$ etex, (2u,0));
  label.lft(btex $y$ etex, (0,u));
endfig;

beginfig(5);
  % The result of btex  etex is a picture that can be rotated.
  numeric ux,uy;
  120ux=1.2in; 4uy=2.4in;
  draw (0,4uy) -- (0,0) -- (120ux,0);
  pickup pencircle scaled  1pt;
  draw (0,uy){right}
    for ix=1 upto 8:
    ..(15ix*ux, uy*2/(1+cosd 15ix))
  endfor;
  label.bot(btex $x$ axis etex, (60ux,0));
  label.lft(btex $y$ axis etex rotated 90, (0,2uy));

  label.lft(btex $\displaystyle y={2\over1+\cos x}$ etex, (120ux, 4uy));
  show "MPTEXPRE is ", MPTEXPRE;
  % P24 shows you how to include macros in tex.
endfig;

beginfig(6);
  % the infont operator that changes string to picture
  u := 1cm;
  pickup pencircle scaled  1pt;
  for i := 1 upto 10:
    for j := 1 upto 10:
      drawdot (i*u,j*u);
    endfor
  endfor
  picture p, q;
  p := "duck" infont defaultfont scaled 2.0 rotated 45;
  label.top(p,(5*u,5*u));
  draw bbox p;

  % q := "Pooh" infont defaultfont scaled 2.0 rotated -45;
  q := "Pooh" infont defaultfont scaled 2.0;
  label.top(q,(10u, 5u));
  draw bbox q;
  % Same as draw bbox q
  % ... ????
  % pickup pencircle scaled  2pt
  % draw llcorner q -- lrcorner q -- urcorner q -- ulcorner q -- cycle
endfig;

beginfig(7);

  path p;
  u := 1cm;
  p = (-1u,0)..(0,-1u)..(1u,0);
  fill p{up}..(0,0){-1,-2}..{up}cycle withcolor (1,0.5,0);
  draw p..(0,1u)..cycle;
endfig;

beginfig(8);
  path a, b, aa, ab;
  a = fullcircle scaled 2u;
  b = a shifted (0,1u);
  aa = halfcircle scaled 2u;
  ab = buildcycle(a,b);
  picture pa, pb;
  pa = thelabel(btex $A$ etex, (0,-.5u));
  pb = thelabel(btex $B$ etex, (0,1.5u));
  fill a withcolor .7white;
  fill b withcolor .7white;
  fill ab withcolor .4white;
  % fill aa--cycle withcolor (0,0.8,0);
  % draw aa;
  % Make the bounding box of pa white
  % unfill bbox pa;
  draw pa;
  % unfill bbox pb;
  draw pb;
  label.lft(btex $U$ etex, (-1u,.5u));
  draw bbox currentpicture;
endfig;
end
