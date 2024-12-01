⟨left, right⟩ ← •ParseFloat⚇¯2 ((5↑¨⊢) ⋈ 8↓¨⊢) •file.Lines "1.in"
p1 ← +´ left |∘-○∧ right
p2 ← left (+´⊣×⊐˜⊏0∾˜1+⊒⌾⌽∘⊢) right
•Show p1‿p2
