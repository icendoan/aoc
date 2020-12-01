input:`i$","\:,/0:`2.input;                                                          / read input, splitting each line on commas and parsing each segment as an integer
upd:{[x;ip] (@[x;x 3+ip;((::;+;*) x ip). x@x 1+ip+!2];ip+4)}.;                       / takes a state array and an instruction index, indexes into an array of operations by the opcode (0=crash), amends the state in that place, and returns the pair.
                                                                                     / the . suffix is important: it unpacks its arguments by default, so this function, despite looking dyadic, is monadic, and accepts a pair of state and index
pred:{[x;ip] ~99=x ip}.;                                                             / stop if the opcode is 99
run:{pred upd/ (x;0)};                                                               / run until opcode 99 is hit with an instruction index of 0, yielding the end (state; index) pair
p1:**run input;                                                                      / the first element of the end pair is the state, the first element of which is the answer
p2:*&19690720=(**:)'R:run' 1,/:(,/(!100),/:\:!100),\:3_input;                        / amend the input with a 1 X Y suffix for each combination of 0 to 99, run each one, and find the first index of the program returning 19690720
