input ← ⊃ ⎕NGET'../5.input'1
⎕IO←0
init  ← ((0 127) (0 7))
front ← { ((start end) h) ← ⍵ ⋄ ((start (⌊2 ÷⍨ start + end)) h) }
back  ← { ((start end) h) ← ⍵ ⋄ (((⌈2 ÷⍨ start + end) end) h) }
left  ← { (v (start end)) ← ⍵ ⋄ (v (start (⌊2 ÷⍨ start + end)))}
right ← { (v (start end)) ← ⍵ ⋄ (v ((⌈2 ÷⍨ start + end) end)) }
step  ← { ⍺='F': front ⍵ ⋄ ⍺='B': back ⍵ ⋄ ⍺='L': left ⍵ ⋄ ⍺='R': right ⍵ ⋄ ⍵ }
id    ← {+/8 1 × ⊃¨⊃step/(⌽⍵),⊂init}
ids   ← id¨input
⊢ p1  ← ⌈/ids
p2    ← (⍳1+p1)~ids
⊢ p2  ← ⊃(~(1 = p2-¯1⌽p2)∨(1 = (1⌽p2)-p2))/p2
