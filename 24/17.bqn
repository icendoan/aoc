Regs ← {((32‿1 •bit._cast ⋈)¨ 𝕩) ∾ ⋈⟨⟩} 
NZ ← { ∨´ 0 ≠ ⊑ 𝕩}
Decode ← {(⟨"adv","bxl","bst","jnz","bxc","out","bdv","cdv"⟩ ⊏˜ ⊢) ⌾ ⊏˘ (∘‿2 ⥊ ⊢) 𝕩}
b1 ← 64↑32‿1 •bit._cast ⋈1
b5 ← 64↑32‿1 •bit._cast ⋈5
Main ← {𝕊a‿b‿c‿o:
b ↩ 64 ↑ 3 ↑ a # bst 4
b ↩ b1 ≠ b     # bxl 1
c ↩ 64 ↑ (1‿8 •bit._cast 8 ↑ 3 ↑ b) ↓ a # cdv 5
b ↩ b5 ≠ b     # bxl 5
b ↩ b ≠ c      # bxc 0
a ↩ 64 ↑ 3 ↓ a # adv 3
o ↩ o ∾ ⟨1, 8⟩ •bit._cast 8 ↑ 3 ↑ b # out 5
⟨a,b,c,o⟩
} •_while_ NZ
p1 ← ¯1 ⊑ Main Regs ⟨64196994,0,0⟩
p ← ⟨2,4,1,1,7,5,1,5,4,0,0,3,5,5,3,0⟩
chunks ← 3 ↑¨ (8‿1 •bit._cast ⋈)¨ ↕8
S ← {m←(𝕩={⊑⎊¯1 ¯1⊑Main⟨𝕩,64↑0,64↑0,""⟩}¨a←64↑¨⥊chunks∾⌜𝕨)⋄m / a}
p2 ← ⌊´ +´¨ (2⋆↕64) ×⚇1 c←¯1⊑(<64↑¨chunks)S`⌽p
