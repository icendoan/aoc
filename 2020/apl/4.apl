:Namespace aoc4
⎕IO←0 ⍝ index from zero
text ← ⊃ ⎕NGET'../4.input'
fields ← 'byr' 'iyr' 'eyr' 'hgt' 'hcl' 'ecl' 'pid' ⍝ 'cid' is optional
nl←⎕UCS 10
blkid ← {1++\{⍵∧⍵=1⌽⍵} ⍵ = nl}
blocks ← {{x←⍵⋄x[⍸x=nl]←' '⋄x}¨⍵⊆⍨blkid ⍵}
keys ← { ((~⍵∊' :')∧(~2|+\⍵∊' :'))⊆⍵ }
vals ← { ((~⍵∊' :')∧( 2|+\⍵∊' :'))⊆⍵ }
get  ← { ⍺∊keys ⍵: ⊃(vals ⍵)[(keys ⍵) ⍳ ⍺] ⋄ '' }
int  ← { (⍺=⍴⍵)∧(∧/⍵∊'0123456789'): ⍎⍵ ⋄ ¯1 }
contains ← { (⍺[0]≤⍵)∧(⍺[1]≥⍵) }
hgt  ← { ('cm'≡¯2↑⍵): 150 193 contains 3 int ¯2↓⍵ ⋄ 59 76 contains 2 int ¯2↓⍵ }
hcl  ← { (7=⍴⍵): (⍵[0] = '#') ∧ ∧/(1↓⍵)∊'01234567898abcdef' ⋄ 0 }
chk  ← {
  byr ← 1920 2002 contains 4 int (⊂'byr') get ⍵
  iyr ← 2010 2020 contains 4 int (⊂'iyr') get ⍵
  eyr ← 2020 2030 contains 4 int (⊂'eyr') get ⍵
  hgt ← hgt (⊂'hgt') get ⍵
  hcl ← hcl (⊂'hcl') get ⍵
  ecl ← (⊂(⊂'ecl') get ⍵) ∊ 'amb' 'blu' 'brn' 'gry' 'grn' 'hzl' 'oth'
  pid ← (⊂'pid') get ⍵ ⋄ pid ← (9=⍴pid)∧∧/pid∊'0123456789'
  ∧/ byr iyr eyr hgt hcl ecl pid
 }
⊢ p1 ← +/∧/¨(⊂fields) ∊¨ keys¨ blocks text
⊢ p2 ← +/chk¨blocks text
:EndNamespace
