h‿w ← ≢ maze ← '#' = text ← > •file.Lines "20.in"
basis ← ⟨1‿0, ¯1‿0, 0‿1, 0‿¯1⟩
start ← w (⌊∘÷˜ ∾ |) /⥊text='S'
end   ← w (⌊∘÷˜ ∾ |) /⥊text='E'
Bounds ← (∧´ (h‿w > ⊢) ∧ (0 ≤ ⊢))¨⊸/
scores ← 0 ⌾ (start ⊑ ⊢) h‿w ⥊ ∞
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
A ← Advance •_while_ {0≠≠2⊑𝕩}
costs ← 1 ⊑ A ⟨maze, scores, ⋈start⟩
inf ← (≠maze) ⥊ ∞
shifts ← ⟨«˘, »˘, «, »⟩
#cheats ← shifts {(inf 𝕎 inf 𝕎 𝕩) - 𝕩 + 2}¨ <costs
Fil ← {(∞ > ⊢)⊸/ (0 < ⊢)⊸/ =˜⊸/ 𝕩}
Cheat ← {𝕊n: Fil ⥊∾ shifts {(inf 𝕎⍟n 𝕩) - 𝕩 + n}¨ <costs }
p1 ← +´ 100 ≤ Cheat 2
exp ← ¯20 ⌽ ¯20 ⌽˘ costs⌾(h ↑ w ↑˘ ⊢) (h‿w + 40‿40) ⥊ ∞
dist ← {m←⥊𝕩>20⋄∞¨⌾(m⊸/)⌾⥊ 𝕩}  (+○|)⌜˜ ¯20+↕41
p2 ← +´⥊ cheats ← {+´99<Fil ⥊ (𝕩 - 20‿20 ⊑ 𝕩) - dist}⎉2 41‿41 ↕ exp
