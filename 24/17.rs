#![feature(custom_inner_attributes)] #![rustfmt::skip]
fn main() {
    let program = [0, 1, 5, 4, 3, 0];
    let mut reg = [729, 0, 0];
    let mut ip = 0;
    let mut o = Vec::new();
    while ip < program.len() - 1 {
        // println!("{} {} {} {:?}", ip, program[ip],program[ip+1], reg);
        match program[ip] {
            0 => adv(&mut reg, program[ip + 1], &mut ip, &mut o),
            1 => bxl(&mut reg, program[ip + 1], &mut ip, &mut o),
            2 => bst(&mut reg, program[ip + 1], &mut ip, &mut o),
            3 => jnz(&mut reg, program[ip + 1], &mut ip, &mut o),
            4 => bxc(&mut reg, program[ip + 1], &mut ip, &mut o),
            5 => out(&mut reg, program[ip + 1], &mut ip, &mut o),
            6 => bdv(&mut reg, program[ip + 1], &mut ip, &mut o),
            7 => cdv(&mut reg, program[ip + 1], &mut ip, &mut o),
            x => panic!("invalid instr: {}@{}", x, ip),
        }
    }
    println!("{:?} {:?}", reg, o);
}

fn adv(reg: &mut [u64; 3], arg: u8, ip: &mut usize,_o: &mut Vec<u64>) { reg[0] /= 1 << combo(arg, reg); *ip += 2; }
fn bxl(reg: &mut [u64; 3], arg: u8, ip: &mut usize,_o: &mut Vec<u64>) { reg[1] ^= arg as u64; *ip += 2; }
fn bst(reg: &mut [u64; 3], arg: u8, ip: &mut usize,_o: &mut Vec<u64>) { reg[1] = combo(arg, reg) & 7; *ip += 2; }
fn jnz(reg: &mut [u64; 3], arg: u8, ip: &mut usize,_o: &mut Vec<u64>) { if reg[0] != 0 { *ip = arg as usize; } else { *ip += 2; } }
fn bxc(reg: &mut [u64; 3],_arg: u8, ip: &mut usize,_o: &mut Vec<u64>) { reg[1] ^= reg[2] as u64; *ip += 2; }
fn out(reg: &mut [u64; 3], arg: u8, ip: &mut usize, o: &mut Vec<u64>) { o.push(combo(arg, reg) & 7); *ip += 2; }
fn bdv(reg: &mut [u64; 3], arg: u8, ip: &mut usize,_o: &mut Vec<u64>) { reg[1] = reg[0] / 1 << combo(arg, reg); *ip += 2; }
fn cdv(reg: &mut [u64; 3], arg: u8, ip: &mut usize,_o: &mut Vec<u64>) { reg[2] = reg[0] / 1 << combo(arg, reg); *ip += 2; }

fn combo(arg: u8, reg: &[u64; 3]) -> u64 {
    match arg {
        0..=3 => arg as u64,
        4 => reg[0], 5 => reg[1], 6 => reg[2],
        _ => panic!("Invalid combo op"),
    }
}
