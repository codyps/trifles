fn main() {
    let a = Some(30);
    let b = Some(12);
    let c = Some(1);

    if let Some(a) = a && let Some(b) = b && let Some(c) = c {
        println!("{a} {b} {c}");
    } else {
        println!("whoops");
    }
}
