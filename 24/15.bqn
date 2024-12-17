text ← •file.Lines "15.in"
cut  ← ⊑/0=≠¨text
map  ←     > cut ↑ text
cmds ← ∾ (1+cut) ↓ text
dir  ← "v^<>"
Step ← {r←1+¯1⊑/1∾(∧` (1⌾⊑) 𝕩∊"O[]")∧'.'=«𝕩⋄¯1⊸⌽⌾(r↑⊢)𝕩}
View ← { map 𝕊 c:
  y‿x ← (≠∘⊏(⌊∘÷˜⋈|)⊑∘/∘⥊) map = '@'
  f   ← (⊑ dir ⊐ c) ⊑ ⟨x⊸⊏˘,x⊸⊏˘,y⊸⊏,y⊸⊏⟩
  g   ← (⊑ dir ⊐ c) ⊑ ⟨y⊸↓,⌽(y+1)⊸↑,⌽(x+1)⊸↑,x⊸↓⟩
  Step⌾G⌾F map
}
p1 ← +´∾1‿100×⚇1 (≠map) (|⋈⌊∘÷˜)¨ /⥊ 'O' = map View˜´ ⌽cmds
_fix ← {𝔽∘⊢⍟≢⟜𝔽_𝕣∘⊢⍟≢⟜𝔽𝕩}
wide ← {
  wide ← {𝕊𝕩: 
    left‿right ← <˘ 0‿1 +⌜ / (⊢∧¬∘») "OO" ⍷ ⥊𝕩
    ']'¨⌾(right ⊏ ⊢)⌾⥊ '['¨⌾(left ⊏ ⊢)⌾⥊ 𝕩
  } _fix ⥊⎉2 ⍉> 2⥊<map
  "@."⌾((0‿1+⊑/"@@"⍷⥊wide)⊏⊢)⌾⥊ wide
}
WStep ← { 
 map 𝕊 '<': map View '<' ;
 map 𝕊 '>': map View '>' ;
 map 𝕊 c:
  dir ← { c = '^' ? ¯1‿0 ; 1‿0 }
  start ← y‿x ← (≠∘⊏(⌊∘÷˜⋈|)⊑∘/∘⥊) map = '@'
  swaps ← ⟨⟩
  surface ← {𝕊𝕩:
    # flood-fill forwards along boxes, added adjacent connected boxes
    moves ← (𝕩 ⊑ map) ∊ "[]@"
    next  ← ((<dir)+¨⊢)⌾(moves⊸/) 𝕩
    knock ← next ⊑ map
    swaps ↩ swaps ∾ < 𝕩 ⋈¨○(moves⊸/) next
    boxes ← (knock ∊ "[]") / next
    left  ← (knock = '[')⊸/ 0‿1  +⚇1 next
    right ← (knock = ']')⊸/ 0‿¯1 +⚇1 next
    ∧ ⍷ next ∾ left ∾ right
  } _fix ⋈ start
  # Compute the bounding box of the changing cells
  minX‿maxX ← x (⌊´⋈⌈´) 1 ⊑¨ surface
  minY‿maxY ← y (⌊´⋈⌈´)   ⊑¨ surface
  Box ← (<minX + ↕(1+maxX) - minX) ⊏˘ (minY + ↕(1+maxY) - minY) ⊏ ⊢
  # If the surface is just '.' then the move can happen
  { "." ≡ ⍷ surface ⊑ map
    ? { 𝕊⟨⟩: map; 𝕊𝕩: map ⌽⌾(𝕩⊑⊢)↩ }¨ ⌽∾swaps ⋄ map
    ; map
  }
}
# dbg ← (↕∘≠ ∾˘ ⊢) (' '‿wide) ∾ ⍉cmds ≍ (<wide) WStep` cmds # pair each state with its index and command
p2 ← +´∾1‿100×⚇1 (≠⊏wide) (|⋈⌊∘÷˜)¨ /⥊ '[' = wide WStep˜´ ⌽cmds
