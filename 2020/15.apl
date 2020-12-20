input ← 6 3 15 13 1 0
test ← 0 3 6
upd ← { (n t p x) ← ⍵ ⋄ ⎕←'upd',t[x]⋄ i←n⍳⍺ ⋄ y ← 1+t[x] ⋄ p[i] ← t[i] ⋄ t[i] ← y ⋄ (n t p i) }
asc ← { (n t p x) ← ⍵ ⋄ ⎕←'asc',t[x]⋄ i ← ⍋n ⋄ (1500⌶ n[i]) (t[i]) (p[i]) (i⍳x) }
step ← { (n t p i) ← ⍵ ⋄ last ← n[i] ⋄ next ← (t[i]-p[i]) × (p[i]>0) ⋄ next ∊ n: next upd ⍵ ⋄ asc ((n,next) (t,1+t[i]) (p,0) (1+⍴n)) }
extr ← {(n t _ _) ← ⍵ ⋄ n[⍸⍺=t]} 
p1 ← 2020 extr (step⍣2020) ((1500⌶input) (⍳⍴input) ((⍴input)⍴0) (⍴input))
⍝ p2 ← 30000000 extr (step⍣3000000) ((1500⌶input) (⍳⍴input) ((⍴input)⍴0) (⍴input)) ⍝ todo: fix, make fast
