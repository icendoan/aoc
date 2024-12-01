// Both of the below have very similar structure
// They call a predicate on each split integer from a range of integers
// 10\:1234 → 1 2 3 4
// And then sum the output - counting number of matching values
// p1's predicate reads: 
//  all digits except the first are not less than their predecessor,
//  and there is at least one digit that matches its predecessor
// p2's predicate reads:
//  all digits except the first are not less than their predecessor
//  and there is at least one segment of length 2 of the same digit
p1:+/({(&/1_~<':x)&(|/=':x)}@10\:)'{x+!y-x}.;
p2:+/({(&/1_~<':x)&2 in#:'(&~=':x)_x}@10\:)'{x+!y-x}.;
