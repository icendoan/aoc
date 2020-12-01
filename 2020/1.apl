(s e nl) ← ⎕NGET '1.input' 
x  ← ⍎ s[⍸s = ⎕UCS nl] ← ' ' 
p1 ← ×/ x[⊃⍸ 2020 = x ∘.+ x]
p2 ← ×/ x[⊃⍸⊃2020=∘.+/x x x]
