\l u.k
x:9445;
serial:9445;
stencil:{x@&&/'300>x:(,/O,/:\:O:!x)+\:y};
p:{-5+10!-100!id*x+(last y)*id:10+*y};
G:p[x]''n,/:\:n:!1+300;
P:{ *(C,'ps) @ mx @ ps:{+/G@//:stencil[x;y]}[x]'C:,/n,/:\:n:1+!(301-x) }
p1:{ -1_P 3 };
/p2: { { p[x]' {(+/'x)=x} stencil[300] x }[x]' ,/ n,/:\:n:1+!300 };
/powers:{ \ "calculating ",","/:$x; +\.+/'p[serial]''{x@=+/'x}stencil[300] x}
p2:{ i , x@i: mx @last'x:*:'P'1+!25 };
