#!/bin/env BQN

text ←  •file.Lines "1.in"
digits ←  ⋈¨ '0' + ↕ 10
numbers ←  digits ∾  ⟨"zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"⟩

Substring ←  +˝∘> ↕ ∘≠∘⊣ ×˘ ≠∘⊢ ↑ ¨ ⍷¨⟜< # 𝕨: List of needles, 𝕩: haystack, gives a list of which-at-where
ToDigits ←  0⊸≠⊸/ 10 | ⊢                 # Filter out zeros, convert to single digit matches
FirstLastMatch ←  +´ 10‿1 × · ⍉∘> 0‿¯1 ⊏ · ToDigits Substring # Take first, last, and merge into base-10 numbers

p1 ←  +´ digits⊸FirstLastMatch¨ text
p2 ←  +´ numbers⊸FirstLastMatch¨ text

•Show p1 ∾  p2