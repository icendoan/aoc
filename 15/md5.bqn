Hash ⇐ { (MD5 @).Digest 𝕩 }
MD5 ⇐ {𝕤
 Unpack ← { 2 |⌊𝕩 ÷ 2⋆⌽↕𝕨 }
 Pack ← { +´ 𝕩 × 2⋆⌽↕𝕨 }
 Xor ← ∨-∧
 K ← {⌊|(2⋆32)×•math.Sin 1+𝕩}
 Int ← 32⊸Pack
 Bits ← 32⊸Unpack
 ToLittleEndian ← { +´ (256⋆↕4) × 8 Pack˘ 4‿8 ⥊ 𝕩 }
 FromLittleEndian ← { ∾´ ⌽ 8 Unpack¨ 256 | ⌊𝕩 ÷ 256⋆⌽↕4 }
 shifts ← 4‿4 ⥊ 7‿12‿17‿22‿5‿9‿14‿20‿4‿11‿16‿23‿6‿10‿15‿21
 state ← a0‿b0‿c0‿d0 ← 1732584193‿4023233417‿2562379262‿271733878
 Chunk ← {
    F ← {x‿y‿z ← Bits¨𝕩 ⋄ Int (x∧y)∨(¬x)∧z}
    G ← {x‿y‿z ← Bits¨𝕩 ⋄ Int (x∧z)∨y∧¬z}
    H ← {x‿y‿z ← Bits¨𝕩 ⋄ Int x Xor y Xor z}
    I ← {x‿y‿z ← Bits¨𝕩 ⋄ Int y Xor x ∨ ¬ z}
    s ← state
    msg ← ToLittleEndian˘16‿32 ⥊ 𝕩
    {
      round ← ⌊𝕩 ÷ 16
      phase ← 4|𝕩
      •Show round‿phase
      op ← round ⊑ F‿G‿H‿I
      shift ← round‿phase ⊑ shifts
      r ← phase⌽s
      sel ← round ⊑ ⊢‿{16|1+5×𝕩}‿{16|5+3×𝕩}‿{16|7×𝕩}
      h ← (2⋆32) | (1⊏r) + Int shift ⌽ Bits ((⊏r) + (Op 1↓r) + ((Sel 𝕩)⊏msg) + K 𝕩)
      s ↩ (-phase) ⌽ h ∾ 1↓r
      •Show s
    }¨↕64
    state ↩ state + s
  }
  
  Preprocess ⇐ { # 𝕩 is a byte array
    bits ← 1↓0 ∾´ 8 Unpack¨ 𝕩
    pad  ← 512 - 512 | ≠bits # number of padding bits
    bits ↩ bits ∾ 1
    bits ↩ bits ∾ (512|pad-65)↑0
    bits ↩ bits ∾ 64 Unpack 8×≠𝕩 # todo: change to little-endian
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
