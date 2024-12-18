#![feature(custom_inner_attributes)] #![rustfmt::skip]
fn main() {
    // let program = [0,3,5,4,3,0];
    let program = [2,4,1,1,7,5,1,5,4,0,0,3,5,5,3,0];
    // let reg = [117440, 0, 0];
    let mut out = Vec::new();
    run(&program, [64196994,0,0], &mut out);
    println!("{:?}", out);
    let a = solve(&program, program.len() - 1, 0);
    if let Some(a) = a {
        out.clear();
        run(&program, [a, 0, 0], &mut out);
        println!("{} {:?}", a, out);
    }
}

// dfs on 3-bit suffixes
// at least, for _my input_, the printed value only ever looks at the last 7 bits
// _but_ as things can only be u3s can just search directly and throw away
// irrelevant subtrees
fn solve(program: &[u8], index: usize, a: u64) -> Option<u64> {
    let mut out = Vec::new();
    for i in 0..8 {
        out.clear();
        let a = (a << 3) | i;
        run(program, [a, 0, 0], &mut out);
        if out[0] == program[index] {
            if index == 0 {
                return Some(a);
            } else  if let Some(r) = solve(program, index - 1, a) {
                return Some(r);
            }
        }
    }
    return None;
}

fn run(program: &[u8], mut reg: [u64;3], o: &mut Vec<u8>) {
    let mut ip = 0;
    while ip < program.len() - 1 {
        match program[ip] {
            0 => adv(&mut reg, program[ip + 1], &mut ip, o),
            1 => bxl(&mut reg, program[ip + 1], &mut ip, o),
            2 => bst(&mut reg, program[ip + 1], &mut ip, o),
            3 => jnz(&mut reg, program[ip + 1], &mut ip, o),
            4 => bxc(&mut reg, program[ip + 1], &mut ip, o),
            5 => out(&mut reg, program[ip + 1], &mut ip, o),
            6 => bdv(&mut reg, program[ip + 1], &mut ip, o),
            7 => cdv(&mut reg, program[ip + 1], &mut ip, o),
            x => panic!("invalid instr: {}@{}", x, ip),
        }
    }
}

fn adv(reg: &mut [u64; 3], arg: u8, ip: &mut usize,_o: &mut Vec<u8>) { reg[0] >>= combo(arg, reg); *ip += 2; }
fn bxl(reg: &mut [u64; 3], arg: u8, ip: &mut usize,_o: &mut Vec<u8>) { reg[1] ^= arg as u64; *ip += 2; }
fn bst(reg: &mut [u64; 3], arg: u8, ip: &mut usize,_o: &mut Vec<u8>) { reg[1] = combo(arg, reg) & 7; *ip += 2; }
fn jnz(reg: &mut [u64; 3], arg: u8, ip: &mut usize,_o: &mut Vec<u8>) { if reg[0] != 0 { *ip = arg as usize; } else { *ip += 2; } }
fn bxc(reg: &mut [u64; 3],_arg: u8, ip: &mut usize,_o: &mut Vec<u8>) { reg[1] ^= reg[2] as u64; *ip += 2; }
fn out(reg: &mut [u64; 3], arg: u8, ip: &mut usize, o: &mut Vec<u8>) { o.push((combo(arg, reg) & 7) as u8); *ip += 2; }
fn bdv(reg: &mut [u64; 3], arg: u8, ip: &mut usize,_o: &mut Vec<u8>) { reg[1] = reg[0] >> combo(arg, reg); *ip += 2; }
fn cdv(reg: &mut [u64; 3], arg: u8, ip: &mut usize,_o: &mut Vec<u8>) { reg[2] = reg[0] >> combo(arg, reg); *ip += 2; }

fn combo(arg: u8, reg: &[u64; 3]) -> u64 {
    match arg {
        0..=3 => arg as u64,
        4 => reg[0], 5 => reg[1], 6 => reg[2],
        _ => panic!("Invalid combo op"),
    }
}
