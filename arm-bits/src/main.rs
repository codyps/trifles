
enum ElemKind {
    Bit(u8),
    Range{start: u8, end: u8},
}

struct Elem {
    name: &'static str,
    kind: ElemKind,
};

impl Elem {
    pub fn bit(name: &'static str, bit: u8) -> Self {
        Elem {
            name: name,
            kind: ElemKind::Bit(bit)
        }
    }


}

struct FmtBits<'a> {
    
}

fn main() {
    println!("Hello, world!");
}
