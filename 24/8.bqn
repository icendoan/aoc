map    ← > •file.Lines "8.in"
coords ← {((≠map) (⌊∘÷˜ ⋈ |) ⊢)¨ /⥊𝕩=map}¨ (⍷ ('.' ≠ ⊢)⊸/) ⥊map
Bounds ← {(∧´¨ 0⊸≤∧(≠map)⊸>)⊸/ 𝕩}
Anti   ← {(¬𝕩∊˜⊢)⊸/ Bounds  ⥊                   (⊢--)⌜˜ 𝕩}
Reso   ← {          Bounds ∾⥊ (⊢+⚇1‿¯1(↕≠map)×⚇¯1‿1-)⌜˜ 𝕩}
p1‿p2  ← ≠∘⍷∘∾¨ ⟨anti, reso⟩ {𝕎¨𝕩}¨ <coords
