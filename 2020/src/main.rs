#![feature(str_split_once)]
#![feature(const_generics)]
#![feature(split_inclusive)]
#![feature(array_chunks)]
#![allow(dead_code, incomplete_features)]

use std::io::{self, BufRead, BufReader};
use std::fs;
use std::path::Path;
use std::collections::{HashMap, HashSet};
use std::str::FromStr;
use std::mem;

fn main() {
    //day15();
    //day16();
    //day17();
    //day18();
    day19();
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
            println!("15.1: {}", latest);
        }
    }

    println!("15.2: {}", latest);
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
    println!("16.1: {}", rate);

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

    println!("16.2: {}", departure);
}

fn day17() {
    struct Neighbours<const N: usize> {
        base: [i64; N],
        counter: usize,
    }

    impl<const N: usize> Neighbours<N> {
        fn new(base: [i64; N]) -> Neighbours<N> {
            Neighbours { base, counter: 0 }
        }
    }

    impl<const N: usize> Iterator for Neighbours<N> {
        type Item = [i64; N];
        fn next(&mut self) -> Option<[i64; N]> {
            if self.counter >= 3usize.pow(N as u32) {
                return None;
            }
            let mut place = self.counter as i64;
            let mut offset = self.base.clone();

            for i in 0..N {
                offset[i] += (place % 3) - 1;
                place /= 3;
            }

            self.counter += 1;
            Some(offset)
        }
    }

    fn step<const N: usize>(alive: &mut HashSet<[i64; N]>,
                            output: &mut HashSet<[i64; N]>,
                            considered: &mut HashMap<[i64; N], usize>) -> usize {
        output.clear();
        considered.clear();
        for coord in alive.iter() {
            for neighbour in Neighbours::new(*coord) {
                considered.entry(neighbour)
                    .and_modify(|x| *x += 1)
                    .or_insert(1);
            }
        }

        for (coord, count) in considered.drain() {
            if count == 3 || (alive.contains(&coord) && count == 4) {
                output.insert(coord.clone());
            }
        }

        output.len()
    }

    fn parse(s: &str, _: &mut ()) -> Vec<usize> {
        s.chars()
            .enumerate()
            .filter_map(|(i, c)| if c == '#' { Some(i) } else { None })
            .collect()
    }

    let mut alive = HashSet::new();
    let mut output = HashSet::new();
    let mut considered = HashMap::new();

    for (x, row) in file("17.input", &mut (), parse).unwrap().into_iter().enumerate() {
        for y in row {
            alive.insert([x as i64, y as i64, 0, 0]);
        }
    }

    for _ in 0..=6 {
        step(&mut alive, &mut output, &mut considered);
        mem::swap(&mut alive, &mut output);
    }

    println!("17: {}", output.len());
}

fn day18() {
    #[derive(Debug, PartialEq, Eq, Copy, Clone)]
    enum Token {
        Num(i64),
        Op(char),
    }

    fn lex(mut s: &str) -> (Vec<Token>, Vec<usize>) {
        let mut tokens = vec!();
        let mut depths = vec!();
        let mut depth = 0;
        while !s.is_empty() {
            let c = s.chars().next().unwrap();
            if "*+()".contains(c) {
                s = &s[1..].trim();
                match c {
                    c if c == '+' || c == '*' => {
                        tokens.push(Token::Op(c));
                        depths.push(depth);
                    }
                    '(' => depth += 1,
                    ')' => depth -= 1,
                    _ => panic!("bad char match"),
                }
            }
            let cut = s.find(|c: char| !c.is_digit(10)).unwrap_or(s.len());
            if cut > 0 {
                tokens.push(Token::Num(i64::from_str(&s[..cut]).unwrap()));
                depths.push(depth);
                s = s[cut..].trim();
            }
        }

        (tokens, depths)
    }

    fn eval((mut tokens, mut depths): (Vec<Token>, Vec<usize>), eval_expr: fn(&[Token]) -> i64) -> i64 {
        if tokens.is_empty() {
            return 0;
        }

        loop {
            if tokens.len() == 1 {
                break;
            }
            let max_depth = depths.iter().copied().max().unwrap();
            let start = depths.iter().position(|x| *x == max_depth).unwrap();
            let end = start + depths.iter().skip(start).position(|x| *x != max_depth).unwrap_or(depths.len() - start);
            let result = eval_expr(&tokens[start..end]);
            tokens.drain(start..end).for_each(mem::drop);
            depths.drain(start..end).for_each(mem::drop);
            tokens.insert(start, Token::Num(result));
            depths.insert(start, if max_depth == 0 { 0 } else { max_depth - 1 })
        }

        match tokens.pop() {
            Some(Token::Num(x)) => x,
            x => panic!("Unexpected result: {:?}", x)
        }
    }

    fn evaluate_equally(tokens: &[Token]) -> i64 {
        let mut iter = tokens.iter();
        let mut acc = match iter.next() {
            Some(Token::Num(x)) => *x,
            t => panic!("Unexpected subexpr prefix: {:?}", t),
        };
        loop {
            match (iter.next(), iter.next()) {
                (Some(Token::Op('+')), Some(Token::Num(x))) => acc += x,
                (Some(Token::Op('*')), Some(Token::Num(x))) => acc *= x,
                (None, None) => return acc,
                (x, y) => panic!("Bad subexpr: {} {:?} {:?}", acc, x, y)
            }
        }
    }

    fn evaluate_with_precedence(tokens: &[Token]) -> i64 {
        let mut iter = tokens.iter();
        let mut sums = vec!(match iter.next() {
            Some(Token::Num(x)) => *x,
            t => panic!("Unexpected subexpr prefix: {:?}", t),
        });

        loop {
            match (iter.next(), iter.next()) {
                (Some(Token::Op('+')), Some(Token::Num(x))) => sums.last_mut().map(|acc| *acc += *x).unwrap_or(()),
                (Some(Token::Op('*')), Some(Token::Num(x))) => sums.push(*x),
                (None, None) => return sums.iter().product(),
                (x, y) => panic!("Bad subexpr {:?} {:?} {:?}", sums, x, y)
            }
        }
    }

    let mut total = 0;
    file("18.input", &mut total, |s, x| *x += eval(lex(s), evaluate_equally)).unwrap();
    println!("18.1: {}", total);
    total = 0;
    file("18.input", &mut total, |s, x| *x += eval(lex(s), evaluate_with_precedence)).unwrap();
    println!("18.2: {}", total);
}

fn day19() {
    #[derive(Debug)]
    enum Rule {
        Exact(String),
        All(Vec<usize>),
        Any(Vec<Vec<usize>>),
        Rule8,
        Rule11,
    }

    fn parse_spec(s: &str) -> (usize, Rule) {
        let (id, s) = s.split_once(':').unwrap();
        let id = usize::from_str(id).unwrap();
        let s = s.trim();
        if s.starts_with('"') {
            (id, Rule::Exact(s[1..s.len() - 1].to_owned()))
        } else if s.contains('|') {
            (id, Rule::Any(s.split('|')
                .map(|s| s.split_whitespace().map(usize::from_str).collect::<Result<Vec<_>, _>>().unwrap()).collect::<Vec<_>>()))
        } else {
            (id, Rule::All(s.split_whitespace().map(usize::from_str).collect::<Result<_, _>>().unwrap()))
        }
    }

    fn matches_successively(s: &str, rules: &HashMap<usize, Rule>, ids: &[usize]) -> usize {
        let mut current = s;
        let mut consumed = 0;
        println!("Attempting match of {:?}", ids);
        for id in ids {
            println!("* submatch attempt: [{}] {}", *id, current);
            let bite = matches(current, rules, *id);
            consumed += bite;
            if bite == 0 {
                println!("Bailing at {}", id);
                return 0;
            }
            current = &s[consumed..]
        }
        println!("* matched all of {:?}", ids);
        consumed
    }

    fn matches(s: &str, rules: &HashMap<usize, Rule>, id: usize) -> usize {
        match rules.get(&id).unwrap() {
            Rule::Exact(m) => if s.starts_with(m) {
                println!("[{}] Exact match for {}", id, m);
                m.len()
            } else {
                0
            },
            Rule::Any(choices) => {
                println!("+ Matching [{}]", id);
                for c in choices {
                    let matched = matches_successively(s, rules, &c[..]);
                    if matched > 0 {
                        return matched;
                    }
                }
                0
            }
            Rule::All(ids) => {
                println!("* Matching [{}]", id);
                matches_successively(s, rules, &ids[..])
            },
            Rule::Rule8 => {
                println!("Starting rule 8");
                let mut consumed = 0;
                loop {
                    let bite = matches(&s[consumed..], rules, 42);
                    if bite == 0 {
                        return consumed;
                    }
                    consumed += bite;
                }
            },
            Rule::Rule11 => {
                println!("Starting rule 11");
                let mut consumed = 0;
                let mut required = 0;
                loop {
                    let bite = matches(&s[consumed..], rules, 42);
                    if bite == 0 {
                        break
                    }
                    required += 1;
                    consumed += bite;
                }
                consumed += matches(&s[consumed..], rules, 11);
                for _ in 0..required {
                    let bite = matches(&s[consumed..], rules, 31);
                    if bite == 0 {
                        return 0
                    }
                    consumed += bite;
                }

                consumed
            }
        }
    }

    let mut rules = HashMap::new();
    file("19.rules.1.test", &mut rules, |s, m| {
        let (id, spec) = parse_spec(s);
        m.insert(id, spec);
    }).unwrap();

    let strings = file("19.text.1.test", &mut (), |s, _| s.trim().to_owned()).unwrap();
    //println!("19.1: {}", strings.iter().filter(|s| s.len() == matches(*s, &rules, 0)).count());

    rules.insert(8, Rule::Rule8);
    rules.insert(11, Rule::Rule11);
    //for s in strings {
    //    println!("{} {}", s.len() == matches(&s, &rules, 0), s);
    //}
    //println!("19.2: {:?}", strings.iter().filter(|s| s.len() == matches(*s, &rules, 0)).collect::<Vec<_>>());
    matches("bbabbbbaabaabba", &rules, 0);
}