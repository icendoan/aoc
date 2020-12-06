nl ← ⎕UCS 10
input ← {⍵⊆⍨{1++\{⍵∧⍵=1⌽⍵} ⍵ = nl} ⍵} ⊃ ⎕NGET '../6.input'
⊢ p1 ← +/¯1+(⍴∪)¨{x←⍵⋄x[⍸x=nl]←' '⋄x}¨input
⊢ p2 ← +/{⍴⊃∩/⍵}¨{((~⍵=nl)×1++\⍵=nl)⊆⍵}¨input
