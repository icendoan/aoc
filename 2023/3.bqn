grid ←  > •file.Lines "3.in"
digits ←  '0' + ↕ 10

# Part 1
MaskAdj ←  («⌈»⌈⊢) {𝔽˘∘𝔽} # if a 1 is in a cell, put a 1 in every adjacent cell
Extend ←  (⌈×0≠⊢)`{𝔽⌾⌽ 𝔽}˘
ExtendDigitRanges ←  (1<⊢) ∘ Extend ∘ (∧+⊢) # 'wash' intersections back and forward along the rows
ClassifyMask← (+`»⊸<)×⊢ # assigns each block of 1s in a mask a unique id

symbols ←  (digits ∾ ".") (⍷ ¬∘∊˜/⊢) ⥊ grid # Anything but a digit or a dot
adjacent ←  MaskAdj grid ∊ symbols
matches ←  adjacent ExtendDigitRanges grid ∊ digits
•Show p1 ←  +´ •ParseFloat¨ (matches ∾ ˘ 0) (¯1+ClassifyMask)⊸⊔ ○  ⥊  (grid ∾ ˘ '.') 

# Part 2
CountDistinctNumbers ←  (⌈´∘ClassifyMask∘⥊  0 ∾ ˘ ⊢ ∊ Digits) ∧ '*' = 1‿1 ⊑ ⊢ # Count the number of distinct numbers, including separated by end-of-row
has_two_numbers ←  MaskAdj 2 = m ←  ¯1⊸⌽{𝔽𝔽˘} (≢grid) ↑  CountDistinctNumbers⎉ 2 3‿3 ↕ grid # Check each window for a) having a gear and b) having exactly 2 numbers in it
gears ←  has_two_numbers ExtendDigitRanges grid ∊ digits
paired ←  Extend gears (×⌈⊣) MaskAdj ((⊢×+`)'*'=⊢)⌾⥊  grid # Give each gear a unique id, and extend it to the numbers around it, pairing them up
number_ids ←  ¯1 + ClassifyMask⌾⥊  gears # Classify the numbers
all_gears ← •ParseFloat¨ number_ids ⊔○ ⥊ grid # Extract the numbers and parse
gear_ids ←  ⊑¨ number_ids ⊔○ ⥊  paired # Group the pair ids by number id (and, because there are multi-digit numbers, take the first)

# Now gear_ids and all_gears have the same shape, and gear_ids is the pairing number for each digit adjacent to a gear

•Show p2 ←  +´×´¨ (0≠≠¨)⊸/ gear_ids ⊔ all_gears
