text ← > •file.Lines "4.in"
Diagonal ← (⊢ ↑˘ ↕ ⌽⎉0‿∞ (↕ 2 × ⊢))∘≠
cols ← <˘⍉ text
swor ← <˘⌽˘ text
sloc ← ⌽¨ cols
diag ← Diagonal⊸⊔ text
giad ← (⌽˘ Diagonal)⊸⊔ text
strings ← ⟨<˘ text, cols, swor, sloc, diag, giad, ⌽¨ diag, ⌽¨ giad⟩
p1 ← "XMAS" (+´∘∾ +´∘⍷⚇∞‿¯2) strings
diags ← ∾˝ 0‿0 (⍉ ⋈ ⍉⟜(⌽˘))⎉1‿2 3‿3 ↕ text
p2 ← +´∨´ (⥊⋈⌜˜ "MAS"‿"SAM") {𝕨≡⎉∞‿1 𝕩}¨ <diags
