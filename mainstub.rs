# 2024 genr8eofl @ APGL3 LICENSE

use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();
    dbg!(args);
    let query = &args[1];
    println!("First argument {}", query);
}
