sections ← ((¯1+¬×1++`) 0=≠¨)⊸⊔ •file.Lines "5.test"
Split ←  (⊢-˜+`×¬)⊸⊔ 
seeds ← •ParseFloat¨ (0≠≠¨)⊸/ ' '⊸=⊸Split ¯1 ⊑ ':'⊸=⊸Split ⊑⍟2 sections
raw ← (•ParseFloat¨ ' '⊸=⊸Split)⚇¯2 1 ↓¨ 1 ↓ sections
Unpack ← {(⍋∘⊏ ⊏⎉1 ⊢) ∾´˘⍉> {𝕊⟨d,s,l⟩:⟨⟨s,s+l+1⟩,⟨d,s+l+1⟩⟩}¨ 𝕩}
maps ← Unpack¨ raw

Ranges ← { 0⊸∾ ∾⟜1e5 𝕨 ⊏ 𝕩 }

Apply ← { m𝕊x: s ← m ⊏⊸⍋ x ⋄ (s ⊏ 1 Ranges m) + x - s ⊏ 0 Ranges m }

MakeRange ← { 𝕊⟨dst,src,len⟩: { 
 ⟨dst, src, len, end⟩ ⇐ ⟨dst, src, len, ¯1 + src + len⟩
 fmt ⇐ "(" ∾ (•Fmt src) ∾ "-" ∾ (•Fmt end) ∾ ") → (" ∾ (•Fmt dst) ∾ "-" ∾ (•Fmt dst + len - 1) ∾ ")"
 Contains ⇐ (src≤⊢)∧((src+len)>⊢)
 Map ⇐ Dst + ⊢ - Src 
 Overlaps ⇐ { 𝕊𝕩: (Contains 𝕩.src) ∨ (Contains 𝕩.end) ∨ (𝕩.Contains src) ∨ (𝕩.Contains end) }
 } 
}
stupid_maps ← MakeRange⚇¯2 raw
ApplyStupid ← { ranges 𝕊 x: range ← (⊑⎊¯1 / ranges { 𝕨.Contains 𝕩 }¨ x) ⊑ ranges ∾ MakeRange ⟨0,0,1e9⟩ ⋄ range.Map 𝕩 }

locations ← ⍉> ApplyStupid˜⎉0‿1` seeds <⊸∾ stupid_maps
•Show p1 ← ⌊´¯1⊏˘locations
seed_ranges ← <˘ ∘‿2 ⥊ seeds

m←1⊑ms←⊑stupid_maps
s←⊑seed_ranges

SplitAndMap ← { map 𝕊 ⟨start, length⟩:
 end ← start + length - 1
 
}
