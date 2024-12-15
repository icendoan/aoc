garden ← > •file.Lines "12.in"
class  ← 1+↕∘≠⌾⥊ garden
shifts ← ⟨»˘,»,«˘,«⟩
Adj    ← Shifts {𝕎𝕩}¨ <
mask   ← (Adj = <) garden
Merge  ← ⊢ ⌈´ Adj × Mask
_fix   ← {𝔽∘⊢⍟≢⟜𝔽_𝕣∘⊢⍟≢⟜𝔽𝕩}
groups ← 1 + ⊐⌾⥊ Merge _fix class
edges  ← (Adj ≠ <) groups
p1     ← +´ (+´¨ × ≠¨) groups ⊔○⥊ +´ (Adj ≠ <) groups
p2     ← +´ (+´¨ × ≠¨) groups ⊔○⥊ +´ edges ∧ (¯1 ⌽ edges) ∨ (¯1⌽shifts) {groups=𝕎𝕩}¨ Adj groups
