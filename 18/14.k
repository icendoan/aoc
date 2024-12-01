input:540391;
seed:(0 1;0x0307);
digits:{`c$$[x;10\:x-0;,0]};
mod:{x-y*_x%y};
iter:{[e;r] \#r; r:r,digits (+/m: r e); (mod'[e+1+m;#r];r)} .;
print:{[e;r] ,/(("([ "@e?!#r),'($r),'(")] "@e?!#r))} .;
p1:{ (last {~(x+10)<#last y}[x] iter/ seed) x + !10 }
D:digits input;
p2:{ {(#last y)-#digits x}[x] {~D~-6#last x} iter/ seed}


//// chunked

C.N:1024;
C.new:{`chunks`active!(0#,!0;!0)}
C.add:{[x;y] $[(#y)>N:C.N-#x[`active];*(x;x[`active]:N_y;x[`chunks],:,x[`active]);*(x;x[`active],:y)]}
C.idx:{[x;y] $[(0=#x`chunks)|~(#x[`chunks])>c:_y%C.N;x[`active]mod[y;C.N];x[`chunks][c][mod[y;C.N]]]};
C.len:{(#x`active)+C.N*#x`chunks};

digits:{$[x;10\:x;,0]};
seed:(0 1;C.new[] C.add/ 3 7);
C.iter:{[e;r] r: r C.add/ digits (+/ m: C.idx[r]' e); (mod'[e+1+m;C.len r];r) } .;
C.p2:{(-#d) + C.len @ last {~ |/ x~/: -1 1_\: C.idx[last y]'( \C.len[last y])-|+1+!1+#x}[d: digits x] C.iter/ seed}
