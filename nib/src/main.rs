
struct NibA {
    v: u8,
}

struct NibB {
    a: bool,
    b: bool,
    c: bool,
    d: bool
}

impl From<u8> for NibA {
    fn from(v: u8) -> Self {
        assert_eq!(v & 0xf0, 0);
        NibA { v }
    }
}

impl From<u8> for NibB {
    fn from(v: u8) -> Self {
        assert_eq!(v & 0xf0, 0);
        NibB {
            a: v & 0b1000 == 0b1000,
            b: v & 0b0100 == 0b0100,
            c: v & 0b0010 == 0b0010,
            d: v & 0b0001 == 0b0001,
        }
    }
}

fn main() {
    let va = [NibA::from(2), NibA::from(1)];

    println!("{}", std::mem::size_of_val(&va));
}
