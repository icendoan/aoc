dirs‿rots ← <˘⍉> 1 (↑⋈↓)¨ •file.Lines "1.input"
dirs ↩ -˝"RL"=⌜∾ dirs 
rots •ParseFloat¨↩
p1 ← +´ z ← 0 = ticks ← 100 | 50 +` 100 | d ← rots × dirs
p2 ← p1+´(¯1+(⌈⌈)-(⌊⌊))˝ (100 ÷˜ ⊢ ≍˜ 50 » ⊢) 50+`d
