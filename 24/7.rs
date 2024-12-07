use std::fs;
use std::str::FromStr;
fn main() {
    let data: Vec<(u64, Vec<u64>)> = fs::read_to_string("7.in")
        .unwrap()
        .split("\n")
        .filter(|l| !l.is_empty())
        .map(|l| {
            let (ans, i) = l.split_once(':').unwrap();
            let ins = i
                .trim()
                .split(' ')
                .map(|x| u64::from_str(x).unwrap())
                .collect();
            (u64::from_str(ans).unwrap(), ins)
        })
        .collect();

    let mut p1 = 0;
    let mut p2 = 0;
    for (desired, stack) in data {
        let r = check(desired, stack[0], &stack[1..], false);
        p1 += (1 == r & 1) as u64 * desired;
        p2 += (2 == r & 2) as u64 * desired;
    }

    println!("{} {}", p1, p2);
}

fn cat(x: u64, y: u64) -> u64 {
    (x * u64::pow(10, 1 + u64::ilog10(y + 1))) + y
}

fn check(desired: u64, acc: u64, stack: &[u64], use_cat: bool) -> u64 {
    if stack.is_empty() {
        return ((desired == acc) as u64) * (if use_cat { 2 } else { 3 });
    }
    let a = check(desired, acc + stack[0], &stack[1..], use_cat);
    if a != 0 {
        return a;
    }
    let b = check(desired, acc * stack[0], &stack[1..], use_cat);
    if b != 0 {
        return b;
    }
    check(desired, cat(acc, stack[0]), &stack[1..], true)
}
