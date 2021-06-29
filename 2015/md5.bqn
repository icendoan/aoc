MD5 ⇐ {𝕤
 Unpack ← { 2 |⌊𝕩 ÷ 2⋆⌽↕𝕨 }
 Pack ← { +´ 𝕩 × 2⋆⌽↕𝕨 }
 Xor ← ∨-∧
 K ← {⌊(2⋆32)||(2⋆32)×•math.Sin 1+𝕩}
 #Int ← { +´ (256⋆↕4) × 8 Pack˘ 4‿8 ⥊ 𝕩 }
 Int ← 32⊸Pack
 #Bits ← { ∾´ ⌽ 8 Unpack¨ 256 | ⌊𝕩 ÷ 256⋆⌽↕4 }
 Bits ← 32⊸Unpack
 shifts ← (16↑7‿12‿17‿22)∾(16↑5‿9‿14‿20)∾(16↑4‿11‿16‿23)∾(16↑6‿10‿15‿21)
 a0‿b0‿c0‿d0 ← 1732584193‿4023233417‿2562383102‿271733878
 Chunk ← {
     m ← Int˘ 16‿32 ⥊ 𝕩 # 𝕩 is given as a single 512-bit array
     f ← 0
     a‿b‿c‿d ← Bits¨a0‿b0‿c0‿d0
     Update ← {𝕤
       f ↩ (2⋆32) | f + (Int a) + (K 𝕩) + 𝕩⊑m
       a ↩ d
       d ↩ c
       c ↩ b
       b ↩ Bits (Int b) + Int (𝕩 ⊑ shifts) ⌽ Bits f
     }
     { f ↩ Int (b∧c)∨(¬b)∧ d ⋄ Update 𝕩 }¨↕16
     { f ↩ Int (d∧b)∨   c∧¬d ⋄ Update 16 | 1 + 5×𝕩 }¨16+↕16
     { f ↩ Int b Xor c Xor d ⋄ Update 16 | 5 + 3×𝕩 }¨32+↕16
     { f ↩ Int c Xor b ∨  ¬d ⋄ Update 16 | 7×𝕩 }¨48+↕16
     a0 ↩ (2⋆32) | a0 + Int a
     b0 ↩ (2⋆32) | b0 + Int b
     c0 ↩ (2⋆32) | c0 + Int c
     d0 ↩ (2⋆32) | d0 + Int d
  }
  Preprocess ← { # 𝕩 is a byte array
    bits ← 1↓0 ∾´ 8 Unpack¨ 𝕩
    pad  ← 512 - 512 | ≠bits # number of padding bits
    bits ↩ bits ∾ 1
    bits ↩ bits ∾ (512|pad-65)↑0
    bits ↩ bits ∾ 64 Unpack 8×≠𝕩
    numChunks ← (≠bits)÷512
    chunks ← numChunks‿512 ⥊ bits
    chunks
  }
  Digest ⇐ {
    chunks ← Preprocess 𝕩
    Chunk˘chunks
    Hash @
   }
  Hash ⇐ { 𝕩 ⊢ ∾´ Hexadecimal¨ 8 Pack˘ 16‿8 ⥊ ∾´ Bits¨a0‿b0‿c0‿d0 }
 }

Hexadecimal ← { ⟨⌊𝕩÷16⋄16|𝕩⟩ ⊏⎉0‿∞ "0123456789abcdef" }
Tests ⇐ {𝕤
 SimpleHashMatches ← {𝕤
  digest ← MD5 @
  hash ← digest.Digest "The quick brown fox jumps over the lazy dog" - @
  hash ≡ "9e107d9d372bb6826bd81d3542a419d6"
  }
 SimpleHashPeriodMatches ← {𝕤
  digest ← MD5 @
  hash ← digest.Digest "The quick brown fox jumps over the lazy dog." - @
  hash ≡ "e4d909c290d0fb1ca068ffaddf22cbd0"
  }
 EmptyHashMatches ← {𝕤
   digest ← MD5 @
   hash ← digest.Digest "" - @
   hash ≡ "d41d8cd98f00b204e9800998ecf8427e"
  }

  ⟨"Simple Hash Matches"‿(SimpleHashMatches @) ⋄
   "Simple Hash With Period Matches"‿(SimpleHashPeriodMatches @) ⋄
   "Empty Hash Matches"‿(EmptyHashMatches @)⟩
 }
