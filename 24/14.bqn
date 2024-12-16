Split  ← (⊢-˜+`×¬)∘=⊔⊢
robots ← •ParseFloat⚇1 ',' Split⚇1 2↓⚇1 ' ' Split¨ •file.Lines "14.in"
starts ← > ⊑¨robots
steps  ← >1⊑¨robots
bounds ← 101‿103
SF     ← {𝕊stops:
  irr  ← ∨´˘ stops =⎉1 ⌊ bounds÷2
  ×´ ≠¨⊔⊐ (bounds÷2) >⎉1 (¬irr) / stops
}
p1     ← SF bounds |⎉1 starts + 100 × steps
p2     ← /(⊢=⌊´) SF˘ bounds |⎉1 starts + steps ×⎉2‿0 ↕10000
