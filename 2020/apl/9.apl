⎕IO←0
data ← {x←⍵⋄x[⍸x=⎕UCS 10]←' '⋄⍎x}⊃⎕NGET'../9.input'
scan ← { b ← ⌊⍺÷2 ⋄ m ← ~b↓(-b)↓(({ h ← ¯1 ↓ ⍵ ⋄ t ← ⊃ ¯1 ↑ ⍵ ⋄ t ∊ (∘.+⍨ h) × ~∘.=⍨⍳⍴h }⌺(1+⍺)) ⍵) ⋄ m / ⍺↓⍵ }
search ← { x ← ⊃¨⍸¨p1 = (2+⍳¯2+⍴⍵) {(+/⊢⌺⍺)⍵}¨ ⊂⍵ ⋄ size ← ⊃ 2 + ⍸x≠0 ⋄ start ← x[size-2] - ⌊size÷2 ⋄ ⍵[start+⍳size] }
p1 ← 25 scan data
p2 ← (⌈/+⌊/) search data
