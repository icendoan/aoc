input:100 6 25 # `i$'*0:"8.input";                    / Read the input file, parse each digit as an int, and then shape into an 100x6x25 array, or 100 layers of the image
p1:{(+//x=1)*(+//x=2)}@input@{&x=&/x}@{+//0=x}'input; / Sum the number of zeros (+//0=x) in each layer, find the index of the minimum, and multiply the numbers of 1s and 2s
p2:" #"@{$[x=2;y;x]}''/input;                         / Fold each layer down, preferring anything to 2, and render with " " for white and "#" for black
