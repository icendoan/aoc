fuel: { 0 | (_ x % 3) - 2 }                              / returns the maximum of 0 and the floor of the input divided by three, subtracted by two
p1: +/ fuel' `i $ 0: `1.input                            / sum the fuel requirements for each line of the input, parsed as an integer
p2: +/ +/' (1 _ {x > 0} fuel\ )' `i $ 0: `1.input        / for each line of the input, parsed as an integer, calculate the series of fuel weights, from the initial weight, and then by the added weight. Drop the initial fuel weight from each, and then sum all of them.
