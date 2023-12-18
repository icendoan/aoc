Split ←  (⊢-˜+`×¬)⊸⊔
series ← •ParseFloat¨∘(' '⊸=⊸Split)¨ •file.Lines "9.in" 
•Show p1 ← +´ (+´¯1⊑¨(1↓+`⁼)⍟(↕≠))¨ series
•Show p2 ← +´ (-´0⊑¨(1↓+`⁼)⍟(↕≠))¨ series