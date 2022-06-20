prologues := 3;
outputtemplate := "%j-%c.mps";
outputformat := "svg";

beginfig(1);
  def MyRotateAbout(expr z, d) =
    shifted -z rotated d shifted z
  enddef;

  path p;
  u := 3cm;
  p = (-1u,0)..(0,-1u)..(1u,0);
  fill p{up}..(0,0){-1,-2}..{up}cycle withcolor (1,0.5,0);
  draw p..(0,1u)..cycle;
  picture pic;
  pic = currentpicture;
  for i := 1 upto 5:
    draw pic MyRotateAbout((2u,2u),i*360/5);
  endfor
    % fill p{up}..(0,0){-1,-2}..{up}cycle
      % MyRotateAbout((2u,2u),i*18);
endfig;

beginfig(2);
  % Hands-on
  path p;
  p = fullcircle scaled 0.5u;
  fill p;
  numeric r;
  r = 1u;
  path outerring;
  outerring = fullcircle scaled r;

  path d ;
  d = (-.1u,0)..(0,-.1u)..(.1u,0);
  picture fish;
  fish := image(
      fill d{up}..(0,0){-1,-2}..{up}cycle;
    );

  draw outerring;
  for j:= 0 upto 2:
    draw fish scaled 1.5 rotated 200 shifted (r*0.1,r*0.53) rotatedaround((0,0),j*120);
  endfor
endfig;

marksize=4pt;

def draw_mark(expr p,a) =
  % Draw a mark at point a on curve p.
  % Where a is an arctime on p;
  begingroup
    save t, dm;
    pair dm; t = arctime a of p;
    show "at 0.5 arclength, t is ", t;
    dm = marksize * unitvector direction t of p
      rotated 90;
    draw (-.5dm .. 0.5dm) shifted point t of p;
  endgroup
enddef;

def draw_marked(expr p, n) =
  % draw n small marks at the middle point of p
  begingroup
    save amid;
    amid = .5*arclength p;
    for i = -(n-1)/2 upto (n-1)/2:
      draw_mark(p, amid+.6marksize*i);
    endfor
    draw p;
  endgroup
enddef;

def min(expr a, b) =
  if a < b:
    a
  else:
    b
  fi
enddef;

angle_radius = .09in;
def mark_angle(expr a,  b, c, n) =
  begingroup
    save s, p; path p;
    p = unitvector(a-b){(a-b) rotated 90}..unitvector(c-b);
    s = .9marksize/length(point 1 of p - point 0 of p);
    s := min(s,angle_radius);
    draw_marked(p scaled s shifted b, n);
  endgroup
enddef;

def mark_rt_angle(expr a, b,c) =
  draw ((1,0)--(1,1)--(0,1))
    zscaled(angle_radius * unitvector(a-b)) shifted b
  enddef;

beginfig(3);
  pair a,b,c,d;
  u := 1in;
  b = (0,0); c = (1.5u,0); a=(0,.6u);
  % the relationship between d-c and a-b expressed as an linear-equation.
  d-c = (a-b) rotated 25;

  z0=.5[a,d];
  z1=.5[b,c];
  % Specify perpendicular relationship to evaluate z.p
  (z.p-z0) dotprod (d-a) = 0;
  (z.p-z1) dotprod (c-b) = 0;

  draw a--d;
  draw b--c;

  draw z0--z.p--z1;
  draw_marked(a--b,1);
  draw_marked(c--d,1);
  draw_marked(a--z.p, 2);
  draw_marked(d--z.p, 2);
  draw_marked(b--z.p, 3);
  draw_marked(c--z.p, 3);

  mark_angle(z.p, b,a,1);
  mark_angle(z.p, c,d,1);
  mark_angle(z.p, c,b,2);
  mark_angle(c, b , z.p ,2);
  mark_rt_angle(z.p,z0 ,a);
  mark_rt_angle(z.p,z1 ,b);

  dotlabel.lft("a",a);
  dotlabel.lft("b",b);
  dotlabel.bot("c",c);
  dotlabel.llft("d",d);
  dotlabel.llft("z.p",z.p);
endfig;


beginfig(4);
  % Suffix and Text param;
  def ignore(expr a) = enddef;
  def my_hide(text t) = ignore(begingroup t; 0 endgroup) enddef;
  % show my_hide(numeric a, b; a+b=3; a-b=1) a; %shows >> 2;

  % incre
  def incr(suffix $) = begingroup $:=$+1; endgroup enddef;
  x = 1;
  for i:=0 upto 3:
    incr(x);
    show "x now is ", x;
  endfor
endfig;



% Suffix arguments
def getmid(suffix p) =
  % THis macro defines 3 arrays for the suffix p. Which implies that
  %  getmid(q) will produce three variables q.mid, q.off and q.dir
  pair p.mid[], p.off[], p.dir[];
  % p is expected to be a closed path
  for i=0 upto 36:
    % dir(x) => (cos(x), sin(x)) [Numeric -> pair]
    p.dir[i] = dir(5*i);
    % from 0 to 180 step 36
    p.mid[i]+p.off[i] = directionpoint p.dir[i] of p;
    % directionpoint => the point on path p, which has direction p.dir[i]
    p.mid[i]-p.off[i] = directionpoint -p.dir[i] of p;
  endfor
enddef;

def joinup(suffix  pt, d)(expr n) =
  begingroup
    % Get a path that pass through each point pt_i in pt and also has directions d_i
    % in d. Bot pt and d has n elements in them
    save r, g; path r;
    r = pt[0]{d[0]};
    for i=1 upto n:
      g:= if (pt[i]-pt[i-1]) dotprod d[i] <0: - fi 1;
      r := r{g*d[i-1]}...{g*d[i]}pt[i];
    endfor
    r
  endgroup
enddef;

beginfig(5);
  path p,q;
  p = ((5,2)...(3,4)...(1,3)...(-2,-3)...(0,-5)...(3,-4)
      ...(5,-3)...cycle) scaled .3cm shifted (0,5cm);
  getmid(p);
  draw p;
  % draw joinup(p.mid, p.dir)(36);
  % Draw an inner loop of p
  drawoptions(dashed evenly);
  for i=0 upto 3:
    draw p.mid[9i]-p.off[9i]..p.mid[9i]+p.off[9i];
    % draw -p.off[9i]..p.off[9i];
    endfor
endfig;


def myarrow(expr p)=
  % draw an arrow about curve p
  begingroup
    save amid,t,tr,h,w,ang;
    amid = .5*arclength p;
    path tr;                    %the triangle

    t = arctime amid of p;
    h = .1*(arclength p);
    w = h;

    show "t is ", t, "h is " ,h;
    ang = angle direction t of p;
    show "angle is", ang;

    tr = (0,0)--(-h,w)--(-h,-w)--cycle;
    tr := tr rotated ang;
    tr := tr shifted point t of p;
    fill tr;
    show "amid is ", amid, "tr is", tr;
    draw p;
  endgroup
enddef;



outputtemplate := "my-arrow.svg";
beginfig(6);
  path p;
  p = (0,0)--(1u,1u);
  myarrow(p);
endfig;

end
