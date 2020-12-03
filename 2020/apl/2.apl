x ← {s ← (1++\⍵=' ') × ~⍵=' ' ⋄ r ← (s=1)/⍵ ⋄ r[⍸r='-'] ← ' ' ⋄ r ← ⍎r ⋄ c ← ⊃(s=2)/⍵ ⋄ p ← (s=3)/⍵ ⋄ r c p} ¨ s ← ⊃ ⎕NGET'2.input'1
⊢ p1 ← +/{((min max) c p) ← ⍵ ⋄ n ← +/c=p ⋄ (min ≤ n) ∧ (max ≥ n)}¨x
⊢ p2 ← +/{(r c p) ← ⍵ ⋄ 1=+/r∊(⍸c = p) }¨x
