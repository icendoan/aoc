#![feature(str_split_once)]
#![feature(const_generics)]
#![feature(split_inclusive)]
#![feature(array_chunks)]
#![feature(bindings_after_at)]
#![allow(dead_code, incomplete_features)]

use std::io::{self, BufRead, BufReader, Read};
use std::fs;
use std::path::Path;
use std::collections::{HashMap, HashSet, BTreeMap};
use std::str::FromStr;
use std::mem;
use std::fmt;
use std::cmp;

fn main() {
    //day15();
    //day16();
    //day17();
    //day18();
    //day19();
    day20();
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

    fn run<const N: usize>() -> usize {
        let mut alive = HashSet::new();
        let mut output = HashSet::new();
        let mut considered = HashMap::new();

        for (x, row) in file("17.input", &mut (), parse).unwrap().into_iter().enumerate() {
            for y in row {
                let mut base = [0; N];
                base[0] = x as i64;
                base[1] = y as i64;
                alive.insert(base);
            }
        }

        for _ in 0..=6 {
            step(&mut alive, &mut output, &mut considered);
            mem::swap(&mut alive, &mut output);
        }

        output.len()
    }

    println!("17.1: {}", run::<3>());
    println!("17.2: {}", run::<4>());
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
        Rule0,
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
        for id in ids {
            let bite = matches(current, rules, *id);
            consumed += bite;
            if bite == 0 {
                return 0;
            }
            current = &s[consumed..]
        }
        consumed
    }

    fn matches(s: &str, rules: &HashMap<usize, Rule>, id: usize) -> usize {
        match rules.get(&id).unwrap() {
            Rule::Exact(m) => if s.starts_with(m) {
                m.len()
            } else {
                0
            },
            Rule::Any(choices) => {
                for c in choices {
                    let matched = matches_successively(s, rules, &c[..]);
                    if matched > 0 {
                        return matched;
                    }
                }
                0
            }
            Rule::All(ids) => {
                matches_successively(s, rules, &ids[..])
            }
            Rule::Rule0 => {
                let mut n = 0;
                loop {
                    let mut working = s;
                    for _ in 1..n {
                        let bite = matches(working, &rules, 42);
                        if bite > 0 {
                            working = &working[bite..];
                        } else {
                            return 0;
                        }
                    }

                    if working.is_empty() {
                        return 0;
                    }

                    for _ in 1..n - 1 {
                        let bite = matches(working, &rules, 31);
                        if bite == working.len() {
                            return s.len();
                        } else if bite > 0 {
                            working = &working[bite..];
                        } else {
                            break;
                        }
                    }
                    n += 1;
                }
            }
        }
    }

    let mut rules = HashMap::new();
    file("19.rules.input", &mut rules, |s, m| {
        let (id, spec) = parse_spec(s);
        m.insert(id, spec);
    }).unwrap();

    let strings = file("19.text.input", &mut (), |s, _| s.trim().to_owned()).unwrap();
    println!("19.1: {}", strings.iter().filter(|s| s.len() == matches(*s, &rules, 0)).count());
    rules.insert(0, Rule::Rule0);
    println!("19.2: {:?}", strings.iter().filter(|s| s.len() == matches(*s, &rules, 0)).count());
}

fn day20() {
    #[derive(Copy, Clone, PartialOrd, PartialEq, Ord, Eq, Hash)]
    struct Mask<const N: usize>([bool; N]);

    impl<const N: usize> Mask<N> {
        fn from_chars(iter: impl Iterator<Item=char>) -> Mask<N> {
            let mut e = [false; N];
            for (i, c) in iter.enumerate() {
                e[i] = c == '#';
            }
            Mask(e)
        }

        fn rev(mut self) -> Self {
            self.0.reverse();
            self
        }
    }

    impl<const N: usize> fmt::Display for Mask<N> {
        fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
            for i in 0..N {
                write!(f, "{}", if self.0[i] { '#' } else { '.' })?;
            }
            Ok(())
        }
    }

    impl<const N: usize> fmt::Debug for Mask<N> {
        fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
            write!(f, "{}", self)
        }
    }

    impl<const N: usize> Default for Mask<N> {
        fn default() -> Self {
            Mask([false; N])
        }
    }

    #[derive(Debug, Clone, Eq, PartialEq, Hash)]
    struct Tile {
        id: usize,
        edges: [Mask<10>; 4],
        image: [Mask<8>; 8],
    }

    fn rotate<const N: usize>(image: &mut [Mask<N>; N]) {
        flip(image);
        for row in image {
            row.0.reverse();
        }
    }

    fn flip<const N: usize>(image: &mut [Mask<N>; N]) {
        for i in 0..=N - 2 {
            let (head, tail) = image.split_at_mut(i + 1);
            let row_i = &mut head[i].0;
            for j in (i + 1)..=N - 1 {
                let row_j = &mut tail[j - i - 1].0;
                mem::swap(&mut row_i[j], &mut row_j[i])
            }
        }
    }

    impl Tile {
        fn rotate(&mut self) {
            rotate(&mut self.image);
        }

        fn flip(&mut self) {
            flip(&mut self.image);
        }
    }

    #[derive(Copy, Clone, PartialOrd, PartialEq, Ord, Eq, Debug)]
    enum Place {
        Empty,
        Filled {
            id: usize,
            rotation: usize,
            flipped: bool,
        },
    }

    impl Place {
        fn edge(&self, tile: &Tile, i: usize) -> Mask<10> {
            match (*self, i) {
                (Place::Empty, _) => unreachable!("which tile is that?"),
                (Place::Filled { id: _, rotation, flipped }, r) => {
                    let mut arrangement = [0, 1, 2, 3];
                    if flipped {
                        arrangement.reverse();
                    }
                    for i in 0..4 {
                        if flipped {
                            arrangement[i] = (arrangement[i] + rotation) % 4;
                        } else {
                            arrangement[i] = (arrangement[i] - rotation) % 4;
                        }
                    }

                    let i = arrangement[r];
                    let e = tile.edges[i];
                    match (rotation, i) {
                        (1, i) if (if flipped { 0 } else { 1 }) == i % 2 => e.rev(),
                        (2, _) => e.rev(),
                        (3, i) if (if flipped { 1 } else { 0 }) == i % 2 => e.rev(),
                        _ => e
                    }
                }
            }
        }
    }

    #[derive(Copy, Clone, PartialOrd, PartialEq, Ord, Eq, Debug)]
    enum Constraint {
        Unknown,
        Edge,
        Matches(Mask<10>),
    }

    const GRID_SIZE: usize = 12;
    type Grid = [[Place; GRID_SIZE]; GRID_SIZE];

    fn display(grid: &Grid) {
        for i in 0..GRID_SIZE {
            for j in 0..GRID_SIZE {
                if let Place::Filled { id, rotation, flipped } = grid[i][j] {
                    print!("[{} {} {}]", id, rotation, if flipped { 1 } else { 0 });
                } else {
                    print!("[ EMPTY  ]");
                }
            }
            println!();
        }
    }

    fn parse_tile(s: &str) -> Tile {
        let lines: Vec<&str> = s.lines().collect();
        let id = usize::from_str(&lines[0][5..9]).unwrap();
        let mut image = [Mask::default(); 8];
        for (i, m) in lines.iter()
            .skip(2)
            .map(|l| Mask::from_chars(l.chars().skip(1).take(8)))
            .take(8)
            .enumerate() {
            image[i] = m;
        }
        Tile {
            id,
            edges: [
                /* top    */ Mask::from_chars(lines[1].chars()),
                /* right  */ Mask::from_chars(lines.iter().skip(1).flat_map(|s| s.chars().rev().next())),
                /* bottom */ Mask::from_chars(lines.last().unwrap().chars()),
                /* left   */ Mask::from_chars(lines.iter().skip(1).flat_map(|s| s.chars().next())),
            ],
            image,
        }
    }

    fn constraint(grid: &Grid, tiles: &[Tile], x: isize, y: isize, r: usize) -> Constraint {
        if x < 0 || y < 0 || x >= GRID_SIZE as isize || y >= GRID_SIZE as isize {
            Constraint::Edge
        } else {
            match grid[y as usize][x as usize] {
                Place::Empty => Constraint::Unknown,
                p @ Place::Filled { id, rotation: _, flipped: _ } => {
                    let tile = tiles.iter().find(|x| x.id == id).unwrap();
                    Constraint::Matches(p.edge(tile, r))
                }
            }
        }
    }

    fn check_for_monsters(image: &[Mask<{ GRID_SIZE * 8 }>; GRID_SIZE * 8]) -> usize {
        let nessie: [Mask<20>; 3] = [
            Mask::from_chars("..................#.".chars()),
            Mask::from_chars("#....##....##....###".chars()),
            Mask::from_chars(".#..#..#..#..#..#...".chars())
        ];
        let mut monsters_found = false;
        let mut not_monster: [Mask<{ 8 * GRID_SIZE }>; 8 * GRID_SIZE] = image.clone();
        for j in 0..(8 * GRID_SIZE) - 3 {
            for i in 0..(8 * GRID_SIZE) - 20 {
                let mut template = nessie.clone();
                for row in 0..3 {
                    for col in 0..20 {
                        template[row].0[col] &= image[j + row].0[i + col];
                    }
                }
                if template == nessie {
                    monsters_found = true;
                    for row in 0..3 {
                        for col in 0..20 {
                            not_monster[j + row].0[i + col] &= !nessie[row].0[col];
                        }
                    }
                }
            }
        }

        if !monsters_found {
            return 0;
        }

        let mut not_nessie = 0;
        for j in 0..GRID_SIZE * 8 {
            for i in 0..GRID_SIZE * 8 {
                if not_monster[j].0[i] {
                    not_nessie += 1;
                }
            }
        }

        not_nessie
    }

    let mut f = fs::File::open("20.input").unwrap();
    let mut input = String::new();
    f.read_to_string(&mut input).unwrap();
    let tiles: Vec<_> = input.split("\n\n").map(parse_tile).collect();
    let mut grid: Grid = [[Place::Empty; GRID_SIZE]; GRID_SIZE];

    let mut edge_counts = HashMap::new();
    for t in &tiles {
        for e in &t.edges {
            edge_counts.entry(*e).and_modify(|x| *x += 1).or_insert(1);
            edge_counts.entry(e.rev()).and_modify(|x| *x += 1).or_insert(1);
        }
    }

    let mut available: BTreeMap<usize, Tile> = BTreeMap::new();
    let mut tiles_by_id = HashMap::new();
    for t in &tiles {
        available.insert(t.id, t.clone());
        tiles_by_id.insert(t.id, t.clone());
    }

    let mut edge_checksum = 1;
    for t in &tiles {
        let edges: Vec<_> = t.edges.iter().map(|e| if 1 == *edge_counts.get(e).unwrap() && 1 == *edge_counts.get(&e.rev()).unwrap() { 1 } else { 0 }).collect();
        if edges.iter().sum::<usize>() == 2 {
            edge_checksum *= t.id;
            if grid[0][0] == Place::Empty {
                grid[0][0] = match edges[..] {
                    //[1, 1, 0, 0] => Place::Filled { id: t.id, rotation: 0, flipped: false  },
                    [0, 1, 1, 0] => Place::Filled { id: t.id, rotation: 2, flipped: false },
                    [0, 0, 1, 1] => Place::Filled { id: t.id, rotation: 1, flipped: false },
                    //[1, 0, 0, 1] => Place::Filled { id: t.id, rotation: 0, flipped: false },
                    _ => unreachable!()
                };
                available.remove(&t.id);
            }
        }
    }

    for j in 0..GRID_SIZE {
        for i in 0..GRID_SIZE {
            if Place::Empty != grid[j][i] {
                continue;
            }

            let constraints = [
                constraint(&grid, &tiles, i as isize, j as isize - 1, 2),
                constraint(&grid, &tiles, i as isize + 1, j as isize, 3),
                constraint(&grid, &tiles, i as isize, j as isize + 1, 0),
                constraint(&grid, &tiles, i as isize - 1, j as isize, 1),
            ];

            for t in available.values() {
                for rotation in 0..4 {
                    for flipped in [false, true].iter().copied() {
                        let place = Place::Filled { id: t.id, rotation, flipped };
                        let mut satisfied = true;
                        for k in 0..4 {
                            let edge = place.edge(t, k);
                            let is_border = 1 == *edge_counts.get(&edge).unwrap() && 1 == *edge_counts.get(&edge.rev()).unwrap();
                            satisfied &= match constraints[k] {
                                Constraint::Unknown => !is_border,
                                Constraint::Edge => is_border,
                                Constraint::Matches(m) => m == edge,
                            };

                            if !satisfied {
                                break;
                            }
                        }

                        if satisfied {
                            grid[j][i] = place;
                        }
                    }
                }
            }

            if let Place::Filled { id, rotation: _, flipped: _ } = grid[j][i] {
                available.remove(&id);
            } else {
                println!("Could not fill tile at ({}, {}), constraints were: {:?}", j, i, constraints);
                panic!();
            }
        }
    }
    display(&grid);
    println!("20.1: {}", edge_checksum);

    let mut image: [Mask<{ 8 * GRID_SIZE }>; 8 * GRID_SIZE] = [Mask::default(); 8 * GRID_SIZE];
    for j in 0..GRID_SIZE {
        for i in 0..GRID_SIZE {
            let id = match grid[j][i] {
                Place::Empty => panic!("I thought the grid was full!"),
                Place::Filled { id, .. } => id
            };
            let mut tile = tiles_by_id.get(&id).unwrap().clone();
            match grid[j][i] {
                Place::Filled { rotation, flipped, .. } => {
                    if flipped {
                        tile.flip();
                    }
                    for _ in 0..rotation {
                        tile.rotate();
                    }
                }
                _ => panic!("AAAAAAAA!")
            }
            for row in 0..8 {
                let image_span: &mut [bool] = &mut image[j * 8 + row].0[8 * i..8 * (i + 1)];
                image_span.copy_from_slice(&tile.image[row].0);
            }
        }
    }

    let mut choppiness = 0;
    for flipped in &[false, true] {
        let mut img = image.clone();
        if *flipped {
            flip(&mut img);
        }
        choppiness = cmp::max(choppiness, check_for_monsters(&img));
        for _ in 0..3 {
            rotate(&mut img);
            choppiness = cmp::max(choppiness, check_for_monsters(&img));
        }
    }
    println!("20.2: {}", choppiness);
}