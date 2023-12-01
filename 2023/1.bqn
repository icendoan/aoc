#!/bin/env BQN

text ←  •file.Lines "1.in"
digits ←  ⋈¨ '0' + ↕ 10
numbers ←  digits ∾  ⟨"zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"⟩

FirstLastMatch ←  +˝ 10‿1 × · ⍉∘> 0‿¯1 ⊏ · 0⊸≠⊸/ · +˝ 10 | ↕ ∘≠∘⊣ ×˘ · > ≠∘>∘⊢ ↑ ¨ ⍷¨⟜< 

p1 ←  ⊑ +´ digits⊸FirstLastMatch¨ text
p2 ←  ⊑ +´ numbers⊸FirstLastMatch¨ text

•Show ⟨p1, p2⟩