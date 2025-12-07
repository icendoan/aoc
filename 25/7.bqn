grid ← •file.Lines "7.input"
start ← 'S' = ⊏ grid
splitters ← '^' = 1 ↓ grid
# S ← (⊣∧¬∘⊢)∨((«∨»)∧)
T ← (⊣×¬∘⊢)+((«+»)×)
# S ← 1 ⌊ T 
# original solution, using boolean logic
# p1 ← +´⥊ (>splitters) ∧ »> path ← start S` splitters
p2 ← +´ ¯1 ⊑ time ← start T` splitters
# equivalent solution, using a clamped p2
p1 ← +´⥊ (>splitters) ∧ »>1⌊time
