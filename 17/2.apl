sheet ← ⍎¨⊃ ⎕NGET'2.input'1
⊢ p1 ← +/(⌈/¨sheet) - (⌊/¨sheet)
⊢ p2 ← +/ { (⌈/÷⌊/)⍵[⊃⍸(0=⍵∘.|⍵)∧~∘.=⍨⍳⍴⍵] }¨sheet
