."\\l i.k"                                                   / load intcode interpreter
program:`i$","\:*0:"7.input";                                / read program
ex:{ 0 {[input;phase] runio[phase,input] program; OUT }/ x}; / Run with reset IO, seeding the input with previous output and phase
p1:{|/,/ex'prm 5};                                           / Run for each permutation of phases, and find the maximum
/ from here on in, it's mostly about juggling lookups in global io and position tables
/ resume sets the state for the VM with the passed id, runs it until it stops (for whatever reason)
/ and then saves the resulting states in the lookup arrays
resume:{[id] IN::IO@i:5\id-1; OUT::IO id; (data;ptr):pred upd/ (DATA id;PTR id); PTR[id]:ptr; IO[id]::OUT; IO[i]::IN; DATA[id]:data; (data;ptr) };
/ e2 initialises the input queues with the permutation of phases and then resumes them all in order
e2:{ IO::,:'x; IO[0],::0; resume'!5 };
/ r2 resumes round-robin until all of them have HALTed
r2:{ IO::5#,!0;DATA::5#,program;PTR::5#0; {~&/ ({[x;i] 99=x i}.)'x } {resume'!#x}/ e2[x]; **IO };
/ p2 checks each permutation and finds the maximum output
p2:{|/r2'5+prm 5};
