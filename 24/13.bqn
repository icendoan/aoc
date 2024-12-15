m ← •Import "../../bqn-libs/matrix.bqn"
Split ← (⊢-˜+`×¬)∘=⊔⊢
games ← •ParseFloat⚇1 ⟨12‿3,12‿3,9‿3⟩ ↓⚇¯2⎉∞‿1 (',' Split ⊢)¨˘ ¯1 ↓˘ ↑‿4 ⥊ •file.Lines "13.in"
Solve ← ((m.Inverse∘⍉∘≍´ 2↑⊢) m.MP ¯1 ⊑ ⊢)
P ← { 
  presses ← Solve˘ 𝕩
  valid ← ∧´˘ (1e¯3 ≥ ⊢ ⌊ ¬) | 1 | presses
  +´⥊3‿1×⎉1⌊0.5+valid/presses
}
p1 ← P games
p2 ← P (10000000000000 + ⊢)⌾(2 ⊏˘ ⊢) games
