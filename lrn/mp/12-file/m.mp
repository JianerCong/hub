prologues := 3;
outputtemplate := "%j-%c.mps";
outputformat := "svg";

% input plain;
beginfig(1);
  for i:=0 step 2 until 10:
    % decimal : int -> str
    message "Line written " & decimal(i/2) & " times";
    write "new line" to "hi.txt";
  endfor
  write EOF to "hi.txt";


  string s;
  s = "--";
  i := 0;
  % Use while loop to readfrom file
  forever:
    exitif s=EOF;
    % decimal : int -> str
    s := readfrom "hi.txt";
    message "Line read " & decimal(i/2) & " times: " & s;
    i := i + 1;
  endfor
endfig;
end
