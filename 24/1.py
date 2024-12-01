from collections import Counter
with open("1.in", "r") as f:
    text = f.read().strip()

left, right = [], []
for line in text.split("\n"):
    words = line.split("   ")
    left.append(int(words[0]))
    right.append(int(words[1]))

p1 = 0
counts = Counter()
for x, y in zip(sorted(left), sorted(right)):
    p1 += abs(x-y)
    counts[y]+=1

p2 = 0
for x in left:
    p2 += x * counts[x]

print(p1, p2)

