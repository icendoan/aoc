⎕IO←0
data ←90 95 ⍴ ⊃,/'L'=⊃⎕NGET'../11.input' 1
occupy ← {n←(+/+⌿2=⍵)-2=s←⍵[1;1]⋄(s=2)∧(n≥4): 1 ⋄ (s=1)∧(n=0): 2 ⋄ s}⌺3 3
metric ← {0.5*⍨+⌿2*⍨⍺-⍵}
cast ← { (⊂⍵) ~⍨ {⍵[⍋⍵]} {(∧/¨((⊂⍴data)>¨⍵)∧⍵≥0)/⍵} (⊂⍵) + (⊂⍺) × (,¨⍨(⍳⌈/)) ⍴data }
neighbours←{{⊃,/∪⍵} {((⊂0 0)~⍨,∘.,⍨¯1 0 1){(⊂c){x←⍸⍵⋄0<⍴⍵:(⊃⍺)[⊃⍸⍵]⋄⍳0}∨/¨(⊂1 2)=data[c←⍵{⍵[⍋(⊂⍺)metric¨⍵]}⍺ cast ⍵]}¨⊂⍵} ⍵}
seats ← ⍸data
n ← neighbours¨seats
step ← seats∘{ state ← ⍵ ⋄ s ← ⍵[⍺] ⋄ nb ← (⊂⍵) {+/2=⊃(⊂⍺){⍺[⍵]}¨n[⍵]}¨ ⍳⍴seats ⋄ state[seats] ← 1+((s=2)∧(nb≤4))∨(s=1)∧(nb=0) ⋄ state }
p1 ← +/+⌿2=occupy⍣≡ data
p2 ← +/+⌿2=step⍣≡ data
