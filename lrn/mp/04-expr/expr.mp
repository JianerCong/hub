prologues := 3;
outputtemplate := "%j-%c.mps";
outputformat := "svg";

beginfig(1);
  show epsilon, warningcheck, tracingonline;
  % b1 := true;
  % b2 := true or false;
  % s := "Hi";
  show "Hi mpost 2 square is",2**2,
    "The length of app is",
    length "app",
    "Apple & tree is",
    "Apple" & " tree",
    "The first two letters are",
    substring (0,2) of "abcde",
    "The x-part and y-part of (2,1) are:",
    xpart (2,1), ypart (2,1),
    "abs (-2) is", abs(-2),
    "floor(2.3) is", floor(2.3),
    "round(5.5) is", round 5.5,
    "sqrt(2) is", sqrt 2,
    "If on a line (a,b), t = 0 means a and t = 1 means b, then ",
    "t = 2 at line (1,3) i:", 2[1,3];

  % p and a.b is pai
  pair p, a.b;
  p = (2,1);
  % q is an array of numeric
  numeric q[];

  % use type as predicate >>
  show "Is p a pair ? (should be ture): it is",
    pair p;


endfig;

beginfig(2);
  % draw a grid with array notation:
  u = 1cm;
  pickup pencircle scaled  4pt;
  numeric a;
  a = 10;

  for i:= -1 upto a:
    for j := -5 upto 5:
      z[i]a[j] = (i*u,j*u);
      drawdot z[i]a[j];
      endfor
    endfor

  pickup pencircle scaled  5pt;
  for i:= 0 upto a:
    % Convert i from [0,a] to [0,360] => =* 360/a = 36
    draw (i * u, 5*sind(i*360/a)*u )..((i-1)*u, 5*sind((i-1)*360/a)*u);
  endfor
endfig;

beginfig(3);
  % Declare multidimentional array.
  path p[]q[], pq[] [];
  % so p2q3 and pq1.4 5 are both path.
  p1q1 = (0,0) -- (0,1);

  % internal var can only be changed via ":="
  newinternal string s;
  s := "hi";
  show s, p1q1;
endfig;
end
