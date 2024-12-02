Split ← (⊢-˜+`×¬)∘=⊔⊢
reports ← •ParseFloat⚇¯2 ' ' Split¨ •file.Lines "2.in"
Signs ← × 1 ↓ ⊢ - »
Monotonic ← 1 = ≠∘⍷∘Signs
Bounded ← ((1≤⊢) ∧ 3≥⊢)∘(|1↓⊢-»)
Check ← (Monotonic ∧ ∧´∘Bounded)
p1 ← +´ safe ← Check¨ reports
Expand ← (≠⌜˜ ↕∘≠)⊸(/⎉1‿∞)
p2 ← +´ safe ∨ ∨´∘(Check˘)∘Expand¨ reports
