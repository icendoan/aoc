⎕io←0
input ← ⊃ ⎕nget '../13.input' 1
time ← ⍎⊃input
places ← ⍸{(~∧/¨'x'=⍵)} {(','≠⍵)⊆⍵}1⊃input
ids ← ⍎¨{((','≠⍵)⊆⍵)[places]}1⊃input
⊢ p1 ← ids { min × ⍺[⍸⍵=min←⌊/⍵]} ids - ids | time
step ← { (m c) ← ⍺ ⋄ (acc p) ← ⍵ ⋄ (m∧acc) , p + acc × ⍸c = m | (acc × ⍳m) + p }
⊢ p2 ← 15 0⍕1⊃⊃step/(ids,¨ids|ids-places)[⍋ids]
