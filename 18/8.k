p:{r:*x;h:2#x:last x;c:(*h)p/(();2_x);m:(last h)#last c;(r,,(h;*c;m);(#m)_last c)};
x:**p@(();`i$" "\:*1:"8.input");
Z:{$[^x;0;x]};
p1:{+/$[#x 1;p1'x 1;0],+/last x};
p2:{$[#x 1;+/Z'(p2'(x 1))@-1+last x;Z@+/last x]};
