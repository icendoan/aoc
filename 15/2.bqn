Cut      ← ({¯1 + (1-𝕩) × 1+ +`𝕩} ∘ =) ⊔ ⊢
Int      ← { c ← 𝕩-'0' ⋄ ⊑ +´ c × ⌽10⋆↕≢c }
Parser   ⇐ (Int¨∘('x'⊸Cut))¨∘•file.Lines
choices  ← /˘¬=⌜˜↕3
Wrapping ← (⌊´ +´ 2⊸×) choices ×˝∘⍉∘⊏ ⊢
Prelude  ⇐ +´ Wrapping¨
Ribbon   ← ×´ ⊸ + ⟜ (2⊸×⟜(⌊´) choices +˝∘⍉∘⊏ ⊢)
Coda     ⇐ +´ ∘ (Ribbon¨)
