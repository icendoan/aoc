⎕IO←0
words ← { ⍵⊆⍨~⍵∊¨⊂' ,.' }
group ← { ⍵⊆⍨~'contain' 'bag' 'bags'∊⍨⍵ }
parse ← {(,/⊃⍵),{x←(⊂'0'),⍨1⌽⍵⋄(,/2↑x),⍎2⊃x}¨ 1↓⍵ }
lines ← parse⍤group⍤words¨⊃ ⎕NGET '../7.input' 1
names ← ⊃¨lines
rules ← (⊂names) ⍳¨ ⊃¨¨ 1 ↓¨ lines
qty ← 1⊃¨¨1↓¨lines
M ← m {⍺+⍺+.×⍵}⍣≡ m ← (2/⍴ rules) ⍴ ⊃,/ qty {⊃+/⍺×(⊂⍳⍴ rules)∊¨⍵}¨ rules
⊢ p1 ← +/ 1⌊ M[;names ⍳ ⊂'shinygold']
⊢ p2 ← +/ M[names ⍳ ⊂'shinygold';]
