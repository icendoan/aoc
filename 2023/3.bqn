Pad ←  {row ← ((≠⊏𝕩)⥊ '.') ⋄ '.' ∾ ˘ '.' ∾ ˜˘ row ∾ ˜ row ∾  𝕩}
grid ←  Pad > •file.Lines "3.in" # 76390429 is the wrong answer
digits ←  '0' + ↕ 10

# Part 1
MaskAdj ←  («⌈»⌈⊢) {𝔽˘∘𝔽} # if a 1 is in a cell, put a 1 in every adjacent cell
ExtendDigitRanges ←  (1<⊢) ∘ ((⌈×0≠⊢)`{𝔽⌾⌽ 𝔽}˘) ∘ (∧+⊢) # 'wash' intersections back and forward along the rows
ClassifyMask← (+`»⊸<)×⊢ # assigns each block of 1s in a mask a unique id

symbols ←  (digits ∾ ".") (⍷ ¬∘∊˜/⊢) ⥊ grid
adjacent ←  MaskAdj grid ∊ symbols
matches ←  adjacent ExtendDigitRanges grid ∊ digits
•Show p1 ←  +´ •ParseFloat¨ (matches ∾ ˘ 0) (¯1+ClassifyMask)⊸⊔ ○  ⥊  (grid ∾ ˘ '.') 

# Part 2
has_two_numbers ←  MaskAdj 2 = m ←  ¯1⊸⌽{𝔽𝔽˘} (≢grid) ↑  ((⌈´∘ClassifyMask∘⥊  ¯1 ⌽{𝔽𝔽˘} 5‿5↑  ⊢ ∊ Digits) ∧ '*' = 1‿1 ⊑ ⊢)⎉ 2 3‿3 ↕ grid
gears ←  has_two_numbers ExtendDigitRanges grid ∊ digits
paired ←  (⌈×0≠⊢)`{𝔽𝔽⌾⌽}˘ gears (×⌈⊣) MaskAdj ((⊢×+`)'*'=⊢)⌾⥊  grid
number_ids ←  ¯1 + ClassifyMask⌾⥊  gears
all_gears ← •ParseFloat¨ number_ids ⊔○ ⥊ grid
gear_ids ← ⊑¨ number_ids ⊔○ ⥊  paired

•Show p2 ←  +´×´¨ (0≠≠¨)⊸/ gear_ids ⊔ all_gears
