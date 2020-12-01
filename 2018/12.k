\l u.k
x:1:"12.input";
state:(5#0) , ("#"=15_*x) , 5#0;
slice:{{x@y+(!5)-2}[x]'2+!(#x)};
rules:{(*x;*last x:"#"=(+\0 5 4)_x)}'2_x;
trim:{(5+ -(#x)-last&x)_x};
s:{trim 0 0 , (Z'(last'rules)@*:'&:'slice[x] ~/:\: *:' rules)}
p1:{+/-5+&20 s/x}
p2:{(50000000000-98*+/x)+/-5+&x:98 s/x} / does not actually work due to int size limitations, k4 solves fine
