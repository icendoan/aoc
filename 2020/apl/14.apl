⎕io←0
input  ← {0 2⊃¨⊂(' '≠⍵)⊆⍵}¨⊃⎕nget'../14.input' 1
pmask  ← { (k v _) ← ⍺ ⋄ m ← ((⍸'0'=⍵) (⍸'1'=⍵)) ⋄ (k v m) }
pset   ← { (p x) ← ⍵ ⋄ p ← ⍎ p~'mem[]' ⋄ (p (⍎x)) }
mask   ← { (o i) ← ⍺ ⋄ x ← (36⍴2)⊤⍵ ⋄ x[i] ← 1 ⋄ x[o] ← 0 ⋄ (36⍴2)⊥x }
upd    ← { (k v m) ← ⍺ ⋄ (ptr data) ← ⍵ ⋄ v[⍸ptr=k] ← m mask data ⋄ (k v m) }
set    ← { (k v m) ← ⍺ ⋄ (ptr data) ← ⍵ ⋄ ptr ∊ k: ⍺ upd ⍵ ⋄ ((k,ptr) (v,m mask data) m) }
run    ← { (ins arg) ← ⍺ ⋄ ins ≡ 'mask': ⍵ pmask arg ⋄ ⍵ set pset ⍺ }
decode ← { i ← (⍳36)~⊃,/⍺ ⋄ base ← (36⍴2)⊤⍵ ⋄ base[1⊃⍺]←1 ⋄ base ← ((2*⍴i),36) ⍴ base ⋄ base[;i] ← ⍉((⍴i)⍴2)⊤⍳2*⍴i ⋄ (⊂36⍴2)⊥¨↓base }
set2   ← { (k v m) ← ⍺ ⋄ (ptr data) ← ⍵ ⋄ masks ← m decode ptr ⋄ v[⍸u←(k∊masks)]←data ⋄ ((k,masks~k) (v,(⍴masks~k)⍴data) m) }
run2   ← { (ins arg) ← ⍺ ⋄ ins≡'mask': ⍵ pmask arg ⋄ ⍵ set2 pset ⍺ }
init   ← (⍬ ⍬ (⍬ ⍬))
⊢ p1 ← +/1⊃⊃run/(⌽input),⊂init
⊢ p2 ← +/1⊃⊃run2/(⌽input),⊂init
