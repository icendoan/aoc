\l u.k
g:{a:*x;b:(c,'(#c;1000-#*c)#0),(1000-#c:(last x)#1;1000)#0;r[-last a]'r[-*a;b]}
x:{(`i$","\:-1_*x;`i$"x"\:last x)}'2_'" "\:'1:"3.input"
p1:{+//1<(1000 1000#0){x+g y}/ x}
p2:{M:(1000 1000#0){x+g y}/x;*1+&:r:{y~x*y:g y}[M]'x}
