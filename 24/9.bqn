fs←'0'-˜¯1↓•file.Chars"9.in"
files‿space ← <˘⍉ ↑‿2 ⥊ fs
# this is smarter but doesn't work :(
taken ← (⊢ × (⌽files) ≥ 2 ÷˜ ⊢) ((+´space) ⌊ ⊢)⌾(+`) ⌽files
fills ← (¯1+≠files) - space ⊔○/ taken
left  ← ⊔˜ / files - ⌽((1‿0 × ⊢)⌾(2‿∘ ⥊ ⊢)) taken
n ← left ⌈○≠ fills
blocks ← ∾ left ∾¨○((≠fs)↑⊢) fills
checksum ← +´ blocks × ↕≠blocks

# this is stupid but works fine
exp ← (⌊÷⟜2)⌾((/0=2|sa)⊏⊢) '.'¨⌾((/2|sa)⊏⊢) sa ← fs / ↕≠fs
C ← (⊑∘/ ⋈ ¯1 ⊑ /∘¬) '.' = ⊢
S ← {x←C 𝕩⋄ ⌽⌾(x⊏⊢) 𝕩}
Compact ← S •_while_ (<´C)
ChkSum ← (+´⊢×↕∘≠) {0¨⌾(('.'=𝕩)⊸/) 𝕩}
P1 ← ChkSum Compact

P2 ← {𝕊·:
  e ← exp  
  (⌽↕≠files) {
    id𝕊size:
      •Show id
      src  ← / id = e
      gaps ← ((⊑src) > ⊢)⊸/ / (size⥊'.') ⍷ e
      { 0≠≠gaps ?  
        sel ← ((↕size) + ⊑gaps) ∾ src 
        e (size ⌽ ⊢) ⌾ (sel ⊏ ⊢) ↩
        ; 
        @ }
  }¨ ⌽files 
  e
}
