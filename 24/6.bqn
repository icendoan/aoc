map   ← > •file.Lines "6.in"
Coord ← ≠∘⊏ (⌊∘÷˜ ⋈ |) ⊑∘/∘⥊
start ← Coord mask ← map = '^'
dirs  ← ⟨"up","right","down","left"⟩
basis ← ⟨¯1‿0, 0‿1, 1‿0, 0‿¯1⟩
views ← ⟨
 ⌽ (1 + ⊑∘⊣)   ↑ 1⊸⊑∘⊣ ⊏˘ ⊢, # up
 (1⊸⊑∘⊣)       ↓   ⊑∘⊣ ⊏  ⊢, # right
   (⊑∘⊣)       ↓ 1⊸⊑∘⊣ ⊏˘ ⊢, # down
 ⌽ (1 + 1⊸⊑)∘⊣ ↑   ⊑∘⊣ ⊏  ⊢  # left
 ⟩
DX ← ⊑∘/ dirs ≡⚇1‿∞ ⊢
Rot ← {(4|1+DX 𝕩)⊑dirs}
Walk ← {𝕊⟨x,y⟩‿map‿mask‿dir‿posns‿u‿done:
 v    ← (DX dir)⊑views
 saw  ← ⟨x, y⟩ V map
 move ← ∧` '#' ≠ saw
 next ← (move ∨ ⊢)⌾( ⟨x, y⟩ V ⊢) mask
 nd   ← Rot dir
 b    ← basis ⊑˜ DX dir
 n    ← (x‿y + (¯1⊑/move) × b)
 nn   ← n ∾ <nd
 rep  ← ∨´ nn ≡⚇2 posns
 n‿map‿next‿nd‿(nn <⊸∾ posns)‿rep‿(rep ∨ ∧´move)
}
p1 ← +´ ⥊ 2 ⊑ w ← Walk •_while_ (¬¯1⊑⊢) ⟨start, map, mask, "up", ⟨start∾<"up"⟩, 0, 0⟩
p2 ← +´ {¯2 ⊑ Walk •_while_ (¬¯1⊑⊢) ⟨start, '#'⌾(𝕩 ⊑ ⊢) map, mask, "up", ⟨start∾<"up"⟩, 0, 0⟩}¨ (⥊(2⊑w)∧¬mask)⊸/ ⥊↕≢map
