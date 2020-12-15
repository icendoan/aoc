use std::collections::BTreeMap;

fn speak(latest: usize, turn: usize, spoken: &mut BTreeMap<usize, usize>) -> usize {
    spoken
	.insert(latest, turn)
	.map(|previous| turn - previous)
	.unwrap_or(0)
}

fn main() {
    let start = 6;
    let mut spoken = BTreeMap::new();
    spoken.insert(6, 1);
    spoken.insert(3, 2);
    spoken.insert(15, 3);
    spoken.insert(13, 4);
    spoken.insert(1, 5);
    let mut latest = 0;
    for i in start..30_000_000 {
	latest = speak(latest, i, &mut spoken);
	if i == 2019 {
	    println!("p1: {}", latest);
	}
    }

    println!("p2: {}", latest);
}
