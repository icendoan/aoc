IN:!0j;                                                             / IO input array
OUT:!0j;                                                            / IO output array
REL:0;                                                              / Relative offset
flag:{[x] |(- 0 3 3 1 1 2 2 3 3 1@`i$100j\x)#(5#0),-2_`i$'$x}       / Opcode to flag array, padding with zero: 101 -> 1 0 0
pred:{[x;ip] ~(99=100\`i$x ip)|((0=#IN)&3=100\`i$x ip)}.;           / Stop on opcode 99 or if out of input
nop:{[x;i;f](x;i)};                                                 / NOP - returns input as-is, does not advance IP
dya:{[fn;x;i;f] (@[x;adr[x;f;i];:;`j$fn . `j$par[x;f;i]];i+4)};     / Build a 3-operand opcode with input function fn
par:{[x;f;i] (x@`i$;::;x@`i$REL+)[2#f]@'x i+1 2 };                  / Build parameters from input data and flags
adr:{[x;f;i] `i$$[0=last f;0;2=last f;REL;'`immadr]+x@i+#f};.       / Build output address
get:{[x;i;f] io:*IN; IN::1_IN; (@[x;adr[x;f;i];:;io];i+2)};         / GET - writes IO value to location
prn:{[x;i;f] OUT,:*par[x;f;i]; (x;i+2)};                            / PRN - prints parameter to output queue
jt:{[x;i;f] p:par[x;f;i];(x;$[*p;`i$p 1;i+3])};                     / JT  - sets IP to param2 when param1 is non-zero
jf:{[x;i;f] p:par[x;f;i];(x;$[*p;i+3;`i$p 1])};                     / JF  - sets IP to param2 when param1 is zero
rel:{[x;i;f] REL::REL+`i$*par[x;f;i]; (x;i+2)}                      / REL - adjust relative offset
O:(nop;dya[+];dya[*];get;prn;jt;jf;dya[<];dya[=];rel);              / Opcode table NOP ADD MUL GET PRN JT JF LT EQ REL
dbg:{[x;ip] \"IP: ",($ip)," INSTR: ",($x ip)," IN: ",($*IN)," OUT: ",($*OUT);(x;ip)}.;
upd:{[x;ip] dbg (x;ip); O[100\`i$x ip] . (x;ip;flag x ip)}.;        / Single step
run:{dbg pred upd/ (`j$x,100000#0;0)};                              / Run to completion
runio:{[i;x] REL::0; IN::i; OUT::!0; run x};                        / Run with reset IO
