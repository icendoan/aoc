Split ← (⊢-˜+`×¬)∘=⊔⊢
reports ← •ParseFloat⚇¯2 ' ' Split¨ •file.Lines "2.in"
Monotonic ← 1=·≠∘⍷∘×1↓⊢-»
Bounded ← ((1≤⊢) ∧´∘∧ 3≥⊢)∘(|1↓⊢-»)
p1 ← +´ (Monotonic ∧ Bounded)¨ reports
