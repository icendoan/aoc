#!/bin/env BQN

days   ← •Import¨ ('1'+↕3)∾¨<".bqn"
inputs ← ({".input"≡¯6↑𝕩}¨/⊢) •file.List "."
Run    ← {
 prelude ← 𝕨.Prelude ∘ 𝕨.Parser 𝕩
 coda    ← 𝕨.Coda    ∘ 𝕨.Parser 𝕩
 prelude‿coda
}
•Show (≠days)‿3 ⥊ ∾ (1+↕≠days) ∾¨ days Run¨ (≠days)↑inputs
