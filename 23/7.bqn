cards ← ⌽ "AKQJT98765432"
hands‿bids ← <˘⍉> {⟨cards ⊐ 5↑𝕩, •ParseFloat 6↓𝕩⟩}¨ •file.Lines "7.input"

Type ← +´⊒
Score ← +´ ⊏×1+↕∘≠∘⊢

order ← hands ⊐ ∾ ∧¨ Type¨⊸⊔ hands
•Show p1 ← order Score bids

JokerType ← (2÷˜⊢×1+⊢) (+´9=⊢) + · ⌈´ ⊒×9≠⊢
NullJoker ← (9 ≠ ⊢) × 1 + ⊢

order ↩ hands ⊐ ∾ ((⍋ NullJoker¨) ⊏ ⊢)¨ JokerType¨⊸⊔ hands
•Show p2 ← order Score bids
