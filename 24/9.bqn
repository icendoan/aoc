fs←'0'-˜¯1↓•file.Chars"9.in"
files‿space ← <˘⍉ ↑‿2 ⥊ fs
taken ← (⊢ × (⌽files) = ⊢) ((+´space) ⌊ ⊢)⌾(+`) ⌽ files
fills ← (¯1+≠files) - space ⊔○/ taken
left  ← ⊔˜ / files - ⌽taken
n ← left ⌈○≠ fills
blocks ← ∾ left ∾¨○((≠fs)↑⊢) fills
checksum ← +´ blocks × ↕≠blocks
