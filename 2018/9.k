\l u.k
x:{x@&~^x}@`i$" "\:*1:"9.input";
N:*x;
limit:100*last x;
scores:N#0;
add:{L.ins[;x] L.shr y};
rem:{y:7 L.shl/ y;scores[N!x]:scores[N!x]+x+L.val y;L.rem y};
cnd:{~limit<*x};
stp:{ $[0=10000!*x; \*x;]; (1+*x;$[(0=23!*x)&~0=*x;rem[x 0;x 1];add[x 0;x 1]])};
p1:{scores::N#0; cnd stp/ (1;L.alloc[limit;0])};
