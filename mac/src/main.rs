///
///
/// abcd_efgh
///
/// h: individual/group bit
///     0: individual (unicast)
///     1: group (multicast/broadcast)
/// g: universally/locally administered address bit
///     0: universally administered (burned in)
///     1: locally administered
struct Mac<'a> {
    bytes: &'a [u8],
}

impl<'a> Mac<'a>
{
    fn from_bytes(bytes: &'a [u8]) -> Self {
        Mac { bytes: bytes }
    }

    fn is_unicast(&self) -> bool {
        self.bytes[0] & (1 << 7) == 0
    }

    fn is_broadcast(&self) -> bool {
        !self.is_unicast()
    }

    fn is_locally_administered(&self) -> bool {
        match (self.bytes[0] & 0xf) {
            0x2,0x6,0xA,0xE => true,
            _ => false,
        }
    }

    fn to_locally_administered(&mut self) {
        self.bytes[0] = (self.bytes[0] | 0x02 & 0xfe);
    }
}


fn main() {
    println!("Hello, world!");
}
