msg ← <˘⍉> •file.Lines "6.in"
counts ← ⍋∘(≠¨⊐⊸⊔)¨ msg
p2‿p1 ← <˘⍉> counts (0‿¯1 ⊏ ⊏⟜⍷)¨ msg
