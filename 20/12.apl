⎕io←0
moves ← {(⊃⍵) (⍎1↓⍵)}¨⊃⎕NGET '../12.input' 1
⍝     N      E      S      W
car ← (0  1) (1  0) (0 ¯1) (¯1 0)
rot ← {⌊0.5 + (2 2 ⍴ 1 ¯1 1 1 × 2 1 1 2 ○ ○⍺÷180) +.× ⍵ }
move ← {(pos dir) ← ⍵ ⋄ (ins arg) ← ⍺ ⋄ ins∊'NESW': ((pos + ⊃arg × car['NESW'⍳ins]) dir) ⋄ 'L'=ins: (pos (arg rot dir)) ⋄ 'R'=ins: (pos ((-arg) rot dir)) ⋄ 'F'=ins: ((pos + arg × dir) dir) ⋄ (pos dir) }
wayp ← {(pos way) ← ⍵ ⋄ (ins arg) ← ⍺ ⋄ ins∊'NESW': (pos (way + ⊃arg × car['NESW'⍳ins])) ⋄ 'L'=ins: (pos (arg rot way)) ⋄ 'R'=ins: (pos ((-arg) rot way)) ⋄ 'F'=ins: ((pos + arg × way) way) ⋄ (pos dir) }
p1 ← +/|⊃⊃move/(⌽moves),⊂((0 0) (1 0))
p2 ← +/⊃⊃|wayp/(⌽moves),⊂((0 0) (10 1))
