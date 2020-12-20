#![feature(str_split_once)]
#![allow(dead_code)]

use std::io::{self, BufRead, BufReader};
use std::fs;
use std::path::Path;
use std::collections::{HashMap, HashSet};
use std::str::FromStr;

fn main() {
    day15();
    day16();
}

fn day15() {
    let start = 6;
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

fn file<P: AsRef<Path>, S, T>(x: P, state: &mut S, cb: fn(&str, &mut S) -> T) -> Result<Vec<T>, io::Error> {
    let f = fs::File::open(x)?;
    let mut b = BufReader::new(f);
    let mut v = Vec::new();
    let mut s = String::new();
    while let Ok(n) = b.read_line(&mut s) {
        if n <= 1 {
            break;
        }
        v.push(cb(s.as_str(), state));
        s.clear();
    }
    Ok(v)
}

fn day16() {
    fn parse_ticket(s: &str, _: &mut ()) -> Vec<u64> {
        s.trim().split(',').map(|s| u64::from_str(s.trim())).collect::<Result<Vec<_>, _>>().unwrap()
    }

    #[derive(Debug, Copy, Clone)]
    struct Rule {
        either: (u64, u64),
        or: (u64, u64),
    }

    impl Rule {
        fn test(&self, x: u64) -> bool {
            ((self.either.0 <= x) && (self.either.1 >= x)) || ((self.or.0 <= x) && (self.or.1 >= x))
        }
    }

    fn parse_rule(s: &str, m: &mut HashMap<String, Rule>) {
        let (name, s) = s.split_once(':').unwrap();
        let v = s
            .split(|c: char| !c.is_digit(10))
            .filter_map(|s| if s.trim().is_empty() { None } else { Some(s.trim()) })
            .map(|s| u64::from_str(s.trim())).collect::<Result<Vec<u64>, _>>().unwrap();
        match v[..] {
            [a, b, c, d] => m.insert(name.to_owned(), Rule { either: (a, b), or: (c, d) }),
            _ => unreachable!()
        };
    }

    let mut rules = HashMap::new();
    let ticket = [127, 109, 139, 113, 67, 137, 71, 97, 53, 103, 163, 167, 131, 83, 157, 101, 107, 79, 73, 89];
    let nearby = file("16.tickets.input", &mut (), parse_ticket).unwrap();
    file("16.rules.input", &mut rules, parse_rule).unwrap();

    let mut rate = 0;
    let mut mask = HashSet::new();
    for (i, t) in nearby.iter().enumerate() {
        for field in t {
            if rules.values().all(|rule| !rule.test(*field)) {
                rate += field;
                mask.insert(i);
            }
        }
    }
    println!("p1: {}", rate);

    let mut departure: u64 = 1;
    let mut constraints = Vec::new();
    for x in 0..20 {
        let mut valid: HashSet<String> = rules.keys().cloned().collect();

        for (i, t) in nearby.iter().enumerate() {
            if mask.contains(&i) {
                continue;
            }

            let field = t[x];
            for (name, rule) in &rules {
                if !rule.test(field) {
                    valid.remove(name);
                }
            }
        }

        constraints.push(valid);
    }

    while !constraints.is_empty() && !constraints.iter().all(HashSet::is_empty) {
        let candidate = constraints.iter().position(|c| c.len() == 1).unwrap();
        let field = constraints[candidate].iter().next().unwrap().clone();

        if field.starts_with("departure") {
            departure *= ticket[candidate];
        }

        for set in &mut constraints {
            set.remove(&field);
        }
    }

    println!("p2: {}", departure);
}
