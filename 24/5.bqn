rules‿prints ← (/ ⟨⟩ ≡⚇1 ⊢)⊸(↑⋈(1+⊢)⊸↓) •file.Lines "5.in"
Split ← (⊢-˜+`×¬)∘=⊔⊢
rules (•ParseFloat⚇¯2 '|' Split¨ ⊢)↩
prints (•ParseFloat⚇¯2 ',' Split¨ ⊢)↩
before‿after ← <˘⍉> rules
after ↩ (⊐before) ⊔ after
before ⍷↩
A←{(before⊐𝕩)⊏(⋈⟨⟩)∾˜after}
Check ← {𝕊p: ¬∨´∾(1↓↑p)∊¨A p}
p1 ← +´ (⌊2÷˜≠)⊸⊑¨ Check¨⊸/ prints
bad←(¬Check)¨⊸/ prints
Fix←(⍒∘(+´¨) ⊢ ∊⚇∞‿1 A)⊸⊏
p2 ← +´ (⌊2÷˜≠)⊸⊑¨ Fix¨ bad
