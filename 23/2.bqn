text ←  •file.Lines "2.in"

StripHeaders ← ':'⊸(2⊸+⟜⊑∘/∘= ↓ ⊢)¨ # Drop the "Game N: " prefix
Split ←  (⊢-˜+`×¬)⊸⊔ # from bqncrate, splits on a boolean mask left argument
Clean ← (','≠⊢)⊸/ ⚇ ¯3 # Remove any trailing commas

games ←  ((0<≠¨)⊸/ ' '⊸= Split ⊢)⚇ ¯2 (';'⊸= Split ⊢)⚇ ¯1 StripHeaders text # Split into games and turns
games ↩  ⍉∘(∘‿2⊸⥊ ) ⚇ 0‿¯2 Clean games # Remove commas, shape into arrays of [counts, colours]
games ↩  •ParseFloat¨⌾⊏⚇ ¯2 games # Convert the counts to numbers

# Now each game looks like this:
# ┌─                                                       
# · ┌─               ┌─                       ┌─           
#   ╵ 3      4       ╵ 1     2       6        ╵ 2          
#    "blue" "red"     "red" "green" "blue"     "green"    
#                 ┘                        ┘           ┘  
#                                                        ┘

max_counts ←  12‿13‿14
colours ←  "red"‿"green"‿"blue"
SelectCounts ←  colours ⊐⚇ 2 1 ⊏¨ ⊢ # Classify the `colours` array by the values in the block (e.g. "blue" "red")
CheckCount ←  ∧´∘∾  ⊏¨ ≤ SelectCounts ⊏⚇ 1 max_counts˙ # Select the classified `max_counts` and compare them to the values - if any are greater than, then returns false
GetCounts ←  (colours ⊐⚇ 2˜ 1 ⊏¨ ⊢) ⊏⟜(∾ ⟜0‿0‿0)⚇ 1 ⊏¨ # Shuffle the counts into ⟨"red", "green", "blue"⟩ order, filling with zeroes

p1 ←  +´ 1 + / CheckCount¨ games # Sum the indices (starting at 1) of the games that pass CheckCount
p2 ←  +´ ×´¨ (⌈˝∘> GetCounts)¨ games # Get the max number of cubes in each game, take their row-wise product, and sum

•Show p1‿p2