maze   ← >•file.Lines "16.in"
# N E S W
basis  ← ⟨¯1‿0,0‿1,1‿0,0‿¯1⟩
start  ← ⟨(≠maze)-2, 1⟩
end    ← ⟨1, (≠maze)-2⟩
scores ← ⟨1000,0,1000,2000⟩⌾(start ⊑ ⊢) (4⥊∞)¨ maze
steps  ← (-↕4) ⌽¨ <⟨1,1001,2001,1001⟩
Advance ← { 𝕊scores‿set:
  adj ← set +⌜ basis
  exi ← adj ⊑ scores
  new ← > (set ⊑ scores) +⚇1‿2 steps
  imp ← ∨´¨ new < exi
  leg ← (adj ⊑ maze) ∊ "SE."
  msk ← imp ∧ leg
  a   ← msk /○⥊ adj
  b   ← msk /○⥊ new ⌊ exi
  c   ← ⌊´¨ a ⊐⊸⊔ b
  scores c⌾((⍷a)⊑⊢) ↩
  ⟨scores, ⍷msk/○⥊adj⟩
}
⟨paths, ·⟩ ← Advance •_while_ {0≠≠1⊑𝕩} ⟨ scores, ⋈start⟩
⟨shtap, ·⟩ ← Advance •_while_ {0≠≠1⊑𝕩} ⟨0¨⌾(end⊑⊢) (4⥊∞)¨ maze, ⋈end⟩
p1 ← ⌊´ ⟨1, (≠maze)-2⟩ ⊑ paths
p2 ← +´ ⥊ (⊢∧·∨´⟨«,»,«˘,»˘⟩{𝕎𝕩}¨<) p1 ≥ shtap +○(⌊´¨) paths
