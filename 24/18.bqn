Split  ← (⊢-˜+`×¬)∘=⊔⊢
coords ← •ParseFloat⚇1 ',' Split¨ •file.Lines "18.in"
h‿w ← 71‿71
basis ← ⟨1‿0, ¯1‿0, 0‿1, 0‿¯1⟩
Bounds ← (∧´ (h‿w > ⊢) ∧ (0 ≤ ⊢))¨⊸/
Advance ← { 𝕊maze‿scores‿set:
  adj ← Bounds¨ <˘ set +⌜ basis
  exi ← adj ⊑ scores
  new ← (≠¨adj) ⥊¨ 1 + set ⊑ scores 
  imp ← new < exi
  leg ← ¬ adj ⊑ maze 
  msk ← imp ∧ leg
  a   ← ∾ msk /¨ adj
  b   ← ∾ msk /¨ new ⌊ exi
  c   ← ⌊´¨ a ⊐⊸⊔ b
  scores c⌾((⍷a)⊑⊢) ↩
  ⟨maze, scores, ⍷a⟩
}
maze ← ⍉ (↕h‿w) ∊ 1024 ↑ coords
scores ← 0⌾⊑ h‿w ⥊ ∞
costs ← 1 ⊑ Advance •_while_ {0≠≠2⊑𝕩} ⟨maze, scores, ⋈0‿0⟩
p1←¯1⊑⥊costs
p2←¯1⊑/∞= {𝕊coords:
 m←maze∨⍉(↕h‿w)∊coords
 ¯1⊑⥊1⊑Advance •_while_ {0≠≠2⊑𝕩} ⟨m, scores, ⋈0‿0⟩
}¨ ↑coords 
