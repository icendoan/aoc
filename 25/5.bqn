ranges‿ids ← (+`0=≠¨)⊸⊔ •file.Lines "5.input"
ranges ↩ •BQN¨ (⊢ + ('‿'-'-') × '-' = ⊢) ranges
ids (•ParseFloat¨ 1↓⊢)↩
starts‿ends ← r ← <˘⍉> ranges
In ← {s‿e 𝕊 x: (x ≥⌜ s) ∧ (x ≤⌜ e)}
p1 ← +´ ∨´˘ r In ids
M ← { 𝕊s‿e:
  # row whose start in included in an existing range
  inc←-⟜(=⌜˜↕∘≠) s‿e In s
  { 0 ≢ +´⥊ inc ?
    i←⊑/∨´˘inc 
    # the row associated with that range
    j←⊑/i⊏inc
    # rewrite the end of that range to include i
    e ((i⊑e) ⌈ ⊢)⌾(j ⊑ ⊢)↩
    # remove the i'th range
    (i≠↕≠s)⊸/¨ s‿e
    ;
    s‿e
  }
}
p2 ← +´ 1 + -˜´ M •_while_ (≢⟜M) r
