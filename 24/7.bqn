Split ← (⊢-˜+`×¬)∘=⊔⊢
ans‿ins ← <˘⍉> ⟨•ParseFloat, (•ParseFloat¨) ' ' Split 1 ↓ ⊢⟩ {𝕎𝕩}¨⚇∞‿¯1 ':' Split¨ •file.Lines "7.in"
T ← {𝕊op: {
   w 𝕊 ⟨⟩: 𝕨=0;
   w 𝕊 ⟨x⟩:𝕨=x;
   w T x: { w<0 ? 0; { h←op {𝕎𝕩}¨ <2↑x ⋄ ∨´ w T¨ h ∾¨ <2↓x }}
  }
}
t1 ← (T ⟨+´,×´⟩)
C  ← (⊣×10⋆·⌈10⋆⁼1+⊢) + ⊢
t2 ← (T ⟨+´,×´,C´⟩)
p1 ← +´ (ans T1¨ ins)⊸/ ans
p2 ← +´ (ans T2¨ ins)⊸/ ans
