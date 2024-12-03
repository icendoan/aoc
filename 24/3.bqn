text ← •file.Chars "3.in"
Parse ← {𝕊text: 
starts ← "mul(" ⍷ text
spans  ← ((≠text) > ⊢)⊸/¨ (4+↕8) +⚇1‿0 / starts
fragments ← spans ⊏⚇1 text
ends ← (')' ⍷¨ ⊢) fragments
args ← (⊑¨/¨ ∨´¨⊸/ ends) ↑¨ (ends (∨´¨⊸/) ⊢) fragments
Split ← (⊢-˜+`×¬)∘=⊔⊢
nums ← (2=≠¨)⊸/ •ParseFloat⎊0⚇¯2 ',' Split¨ args
nums
}
p1 ← +´×´¨ Parse text
p2 ← +´×´¨ Parse (0 ≤ · {𝕨𝕊0:𝕨;𝕩}` (-´ ≠↑¨ "do()"‿"don't()" ⍷⚇1‿∞ ⊢))⊸/ text
