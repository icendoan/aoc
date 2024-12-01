text ← ¯1 ↓ ⊃ ⎕NGET'1.input' 
⊢ p1 ← +/⍎¨(text = 1⌽text)/text
⊢ p2 ← +/⍎¨(text = ((⍴text)÷2)⌽text)/text
