use std::collections::HashMap;

fn main() {
    let start = 3;
    let mut spoken = HashMap::new();
    spoken.insert(6, 1);
    spoken.insert(3, 2);
    spoken.insert(15, 3);
    spoken.insert(13, 4);
    spoken.insert(1, 5);
    let mut latest = 6;
    for i in start..30_000_000 {

	latest = spoken.insert(latest, i)
	    .map(|previous| i - previous)
	    .unwrap_or(0);

	if i == 2019 {
	    println!("p1: {}", latest);
	}
    }

    println!("p2: {}", latest);
}
