Split ← (⊢-˜+`×¬)∘=⊔⊢
stones ← •ParseFloat¨ ' ' Split ¯1 ↓ •file.Chars "11.in"
Rule  ← (0 = ⊢) + (2 × 2 | ⌊∘•math.Log10∘(1 ⌈ ⊢))
SN    ← (10 ⋆ · ⌈ 2 ÷˜ •math.Log10)⊸(⌊∘÷˜ ⋈ |)
Blink ← { 𝕊x‿n:
 r ← Rule x
 x 1¨⌾((1=r)⊸/) ↩
 x SN¨⌾((2=r)⊸/) ↩
 x (2024×⊢)⌾((0=r)⊸/) ↩
 n ↩ (≠¨x)/n
 x ∾↩
 n ↩ +´¨ x ⊐⊸⊔ n
 ⟨⍷x,n⟩
}
p1‿p2 ← +´¨ 1 ⊑¨ Blink⍟25‿75 stones
