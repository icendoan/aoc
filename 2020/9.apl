⎕IO←0
sums ← +\ data ← {x←⍵⋄x[⍸x=⎕UCS 10]←' '⋄⍎x}⊃⎕NGET'../9.input'
scan ← { b ← ⌊⍺÷2 ⋄ m ← ~b↓(-b)↓(({ h ← ¯1 ↓ ⍵ ⋄ t ← ⊃ ¯1 ↑ ⍵ ⋄ t ∊ (∘.+⍨ h) × ~∘.=⍨⍳⍴h }⌺(1+⍺)) ⍵) ⋄ m / ⍺↓⍵ }
check ← { ⍸p1 = sums - (-⍵)⌽sums }
chksum ← { y ← x[z← ⊃ {(⍵≥2)/⍵} ⍸0≠⊃¨x←check¨⍳⍴⍵] ⋄ (⌈/+⌊/) ⍵[y-⍳z]}
p1 ← 25 scan data
p2 ← chksum data
