Split  ← (⊢-˜+`×¬)∘=⊔⊢
text ← •file.Lines "19.in"
sizes ← ≠¨ towels ← ∨ (' '≠⊢)⊸/¨ ',' Split ⊑text
designs ← 2 ↓ text
cache ← ⟨⟩ •HashMap ⟨⟩
counts ← ⟨""⟩ •Hashmap ⟨1⟩
Possible ← {
 Possible "": 1;
 Possible design:
 { cache.Has design ? cache.Get design;
   prefixes ← towels ≡¨ (sizes⌊≠design) ↑¨ <design
   { ∨´prefixes?
      r ← ∨´ Possible¨ subs ← (prefixes / sizes) ↓¨ <design
      c ← (0 counts.Get design) + +´ 0 counts.Get¨ subs
      design cache.Set r
      design counts.Set c
      r
      ;
      design cache.Set 0
      design counts.Set 0
      0
    }
 }
}
p1 ← +´ Possible¨ designs
p2 ← +´ counts.Get¨ designs
