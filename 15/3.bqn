chars     ← "<>^v"
coords    ← (¯1‿0)‿(1‿0)‿(0‿¯1)‿(0‿1)
Read      ← chars⊸⊐⊸⊏⟜coords
Parser    ⇐ Read∘•file.Chars
Delivered ← +´ 1⊸≤∘(⊑∘≢)¨∘⊔∘⊐
Prelude   ⇐ Delivered∘(+`) ⟨0‿0⟩⊸∾
Coda      ⇐ (2⊸|∘↕∘≠/⊢)⊸(Delivered∘∾○((+`)⟨0‿0⟩⊸∾))⟜((¬ 2⊸|∘↕∘≠)/⊢)
