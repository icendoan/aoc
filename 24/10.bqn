map ← '0' -˜ > •file.Lines "10.in"
Coord ← ≠∘⊏ (⌊∘÷˜ ⋈¨ |) /∘⥊∘⊢
Bounds ← (∧´¨ (0 ≤ ⊢) ∧ ((≠map) > ⊢))⊸/
dirs ← ⟨1‿0, 0‿¯1, ¯1‿0, 0‿1⟩
Search ← {
 𝕊⟨⟩: ⟨⟩;
 𝕊x:
 b ← Bounds¨ (<dirs) +⚇¯1‿1¨ x
 h ← 1 = (b ⊑ map) -¨ 𝕩 ⊑ map
 { ∨´∨´¨h ? ⍷∾ h /¨ b ; x }
}
p1  ← +´ ≠¨Search⍟9¨ ⋈¨ Coord    0=map
Car ← (≠⊸⥊˜ (« ⋈ ») ⊢) ∾ («˘ ⋈ »˘)
h   ← (1 = (0 Car ⊢) - <) map
p2  ← +´ ⥊ (+´ h × 0 Car ⊢)⍟9 9=map
