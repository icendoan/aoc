Split ←  (⊢-˜+`×¬)⊸⊔ 
cards ← > (•ParseFloat¨ (0≠≠¨)⊸/)⚇2 (' '⊸=⊸Split¨ · '|'⊸=⊸Split ¯1 ⊑ ':'⊸=⊸Split)¨ •file.Lines "4.in"
winners ← ∊´˘ cards
•Show p1 ← +´⌊2⋆¯1+˝˘ winners
added ← (↕∘≠∾˘+˝˘) winners
F ← { w 𝕊 n‿c: m ← n ⊑ w ⋄ r ← 1+n+↕c ⋄ (m+⊢) ⌾ (r⊏⊢) w }
•Show p2 ← +´ (1⥊˜≠winners) F˜˝ ⌽ added
