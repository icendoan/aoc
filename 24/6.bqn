map ← > •file.Lines "6.test"
Coord ← ≠∘⊏ (⌊∘÷˜ ⋈ |) ⊑∘/∘⥊
start ← Coord mask ← map = '^'
dirs ← ⟨"up","right","down","left"⟩
# todo: views are incorrect
views ← ⟨⊑∘⊣ ↑ 1⊸⊑∘⊣ ⊏˘ ⊢,
 ⌽ -∘⊑∘⊣ ↑ 1⊸⊑∘⊣ ⊏˘ ⊢,
 1⊸⊑∘⊣ ↑ ⊑∘⊣ ⊏ ⊢,
 ⌽ -∘(1⊸⊑)∘⊣ ↑ ⊑∘⊣ ⊏ ⊢⟩
DX ← ⊑∘/ dirs ≡⚇1‿∞ ⊢
Rot ← {(4|1+DX 𝕩)⊑dirs}
#todo: _mv ← {⟨x,y⟩ "up" _𝕣 𝕩: ⟨𝕩,y⟩; ⟨x,y⟩ "down"}
Walk ← {𝕊⟨x,y⟩‿map‿mask‿dir:
 v ← (DX dir)⊑views
 •Show saw ← ⟨x, y⟩ V map
 •Show move ← ∧` '#' ≠ saw
 mask (move ∨○•Show ⊢)⌾( ⟨x, y⟩ V ⊢)↩
 ⟨x,⊑/move⟩‿map‿mask‿(Rot dir) # todo: move correctly
}
