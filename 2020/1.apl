(s e nl) ← ⎕NGET '1.input' ⋄ x ← ⍎ s[⍸s = ⎕UCS nl] ← ' '
f  ← {×/⍵[⊃⍸⊃2020=∘.+/⍺⍴⊂⍵]}
p1 ← 2 f x
p2 ← 3 f x
