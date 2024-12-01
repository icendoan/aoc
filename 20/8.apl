⎕IO←0
(ins arg) ← ({(⊃¨⍵) (1⊃¨⍵)}) {(x y)←⍵⋄(x (⍎y))}⍤((~' '=⊢)⊆⊢)¨⊃⎕NGET'../8.input'1
ins ← 'nop' 'acc' 'jmp' (⍳⍤1 1) ins
tgt ← ((⍳⍴ins) + ((ins≠2)×((⍴ins)/1)) + ((ins=2)×arg))
stp ← {(1⊃⍺)≡1⊃⍵}
run ← {(ip visited) ← ⍵ ⋄ ((⍺,⍴⍺)[ip] (∪ visited,ip))}
vst ← 1 ⊃ tgt (run⍣stp) 0 (⍳0)
⊢ p1 ← +/ ((ins = 1) × arg)[1⊃tgt (run⍣stp) 0 (⍳0)]
end ← {∪{⍵[⍋⍵]}⍵,⊃,/⍸¨⍵⍷¨⊂tgt}⍣≡ ⍸tgt≥⍴tgt
brk ← ⊃ vst[⍸((0=ins[vst])∧(vst+arg[vst])∊end)∨(2=ins[vst])∧(1+vst)∊end]
fix ← ins ⋄ fix[brk] ← 2×ins[brk]=0
tfx ← (⍳⍴fix) + ((fix≠2)×((⍴fix)/1)) + ((fix=2)×arg)
ter ← {⊃⍵≥⍴ins}
⊢ p2 ← +/ (((fix = 1) × arg),0)[1⊃tfx (run⍣ter) 0 (⍳0)]
