#![feature(array_chunks, slice_as_chunks)]
use std::collections::HashMap;
use std::fs;
use std::io::Read;
use std::str::FromStr;
fn main() {
    let mut s = String::new();
    fs::File::open("1.in")
        .unwrap()
        .read_to_string(&mut s)
        .unwrap();
    let mut left = [0; 1000];
    let mut right = [0; 1000];
    let mut counts: HashMap<i32, i32> = HashMap::with_capacity(1000);
    let mut i = 0;
    let (chunks, _) = s.as_bytes().as_chunks::<14>();
    for chunk in chunks {
        left[i] = i32::from_str(unsafe { std::str::from_utf8_unchecked(&chunk[..5]) }).unwrap();
        right[i] = i32::from_str(unsafe { std::str::from_utf8_unchecked(&chunk[8..13]) }).unwrap();
        *counts.entry(right[i]).or_insert(0) += 1;
        i += 1;
    }
    left.sort();
    right.sort();
    let mut p1 = 0;
    let mut p2 = 0;
    for (x, y) in left.iter().zip(right) {
        p1 += i32::abs(x - y);
        p2 += x * counts.get(&x).copied().unwrap_or(0);
    }

    println!("{} {}", p1, p2);
}
