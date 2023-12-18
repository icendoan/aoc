Split ←  (⊢-˜+`×¬)⊸⊔ 
lines ← •file.Lines "8.in"
n ← ≠course ← "LR" ⊐ ⊑ lines
nodes‿left‿right ← <˘⍉> 0‿2‿3 ⊏⚇1‿¯1 (⊢ /˜ ⊢ ∊ (('0'+↕10)∾'A'+↕26)˙)⚇¯2 ' '⊸=⊸Split¨ 2 ↓ lines
map ← nodes ⊐⚇2 left ⋈ right
src‿dst ← nodes ⊐ "AAA"‿"ZZZ"

Walk ← {𝕊x‿i: ⟨x ⊏ map ⊑˜ course ⊑˜ n | i, i+1⟩ }
•Show p1 ← ¯1 ⊑ Walk •_while_ (Dst ≠ ⊑⍟2) ⟨src, 0⟩ 

sources ← / 'A' = ¯1 ⊑¨ nodes
dests ← / 'Z' = ¯1 ⊑¨ nodes

•Show p2 ← •math.LCM´ (¯1 ⊑ Walk •_while_ (¬∘⊑ ⊑ ∊ Dests))¨ sources ⋈¨ 0
