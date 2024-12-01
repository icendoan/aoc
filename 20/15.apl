input ← 6 3 15 13 1 0
test ← 0 3 6
⍝ very slow but does get the answer
game ← { k ← 1500⌶ ⍵ ⋄ v ← 1 + ⍳≢⍵ ⋄ { ⍺ - ⍺ { ⍵∊k: (v[k⍳⍵]←⍺)⊢v[k⍳⍵] ⋄ (k,←⍵)⊢(v,←⍺)⊢⍺ } ⍵ }/⌽(⊃⌽⍵),(≢⍵)↓⍳⍺ }
⍝ much much faster
⎕io ← 0
faster ← { A ← ⍺/⍺ ⋄ A[¯1↓⍵]←1↓⍳≢⍵ ⋄ { 0⌈⍺-((A[⍵]←⍺)⊢A[⍵]) }/⌽(⊃⌽⍵),(≢⍵)↓⍳⍺ }
⊢ p1 ← 2020 faster input
⊢ p2 ← 3e7 faster input
