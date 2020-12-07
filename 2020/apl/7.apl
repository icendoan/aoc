⎕IO←0
text ← ⊃ ⎕NGET '../7.input' 1
words ← { ⍵⊆⍨(~⍵∊¨⊂' ,.')×1++\⍵∊¨⊂' ,.' } ⋄ triples ← { x ← ⍵⊆⍨(~'contain' 'bag' 'bags'∊⍨⍵)×1++\'contain' 'bag' 'bags'∊⍨⍵ ⋄ x }
group ← { (,/⊃⍵) , { 3=⍴⍵: ((,/1↓⍵) (⍎⊃⊃⊃(⊃⍵)[0])) ⋄ (,/⍵) 0 }¨1↓⍵ }
table ← { group triples words ⍵ }¨text ⋄ names ← ⊃¨table ⋄ rules ← {names⍳⍵}¨⊃¨¨⊃¨¨1↓¨table ⋄ parents ← {names⍳⊃¨⍵}¨⊃¨¨1↓¨table ⋄ qty ← ⊃¨¨1↓¨¨1↓¨table
m ← m {⍺+⍺+.×⍵}⍣≡ m ← (2/⍴ rules) ⍴ ⊃,/ qty {⊃+/⍺×(⊂⍳⍴ rules)∊¨⍵}¨ rules
⊢ p1 ← +/ 1⌊ m[;names⍳⊂'shinygold']
⊢ p2 ← +/ m[names⍳⊂'shinygold';]