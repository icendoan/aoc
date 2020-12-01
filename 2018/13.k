x:1:"13.input";
initial:"^>v<"=/:\:x;
positions:{{(,//x;0)}' l ,/:' (&:'x) l:&|/'x};
d:`U`R`D`L;
dirs:d!(-1 0;0 1;1 0;0 -1);
/ (x,y) d n
cond:{x ~ ?x:*:'x};
map:{ $[x in"<>";"-";x in "v^";"|";x] }''x;
draw:{ map {x[(*y) 0]:@[x[(*y) 0];(*y) 1;"^>v<"@d?last y]; x}/ x };
track:{ map[**x][last*x] };
corner:{ x[2]:`R`L`U`D`L`R`D`U@(,/d,/:\:"/\\")?(last x;track x); x };
inter:{ x[2]:d@4!(d?x[2]) + (3!x 1) - 1; x[1]:1+x 1; x };
cd:{ $["+"=c:track x;inter x;c in "/\\";corner x;x] };
mv:{ ((*x) + dirs last x; x 1; x 2) };
sort:{x@<*:'x}
start:sort @ ,/ (positions' initial) ,'' d;
carts:start;
collisions:();
move:{ new:cd mv carts x; c:*&(*:'carts) ~\: *new; $[^c; carts[x]:new; collide[x;c]]; }
collide:{ collisions::collisions , ,carts y; carts[x]:Ø; carts[y]:Ø; }
filter:{ x @ & ~ x ~\: Ø };
tick:{ { $[~^carts x;move x; ] }' !#carts; carts::sort filter carts; carts }
p1:{{(#start)=#carts} tick/ x; |**collisions}
p2:{{1<#carts} tick/ x;|**carts}
