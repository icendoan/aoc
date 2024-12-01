x ← 265149
signum←{(⍵>0)-(⍵<0)}
abs ← {⍵×signum ⍵}
big ← {⍸(⍵∧~1⌽⍵)}x>2××⍨⍳⌊x*0.5  
small ← (big big , big + 1 1)-⍨⌊/abs x - 2×¯1 0 + big * 2
