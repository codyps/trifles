
/// Formed as a return value to represent a single nibble in cases where a ref return is required
/// (like indexing).
///
/// Provides conversion to `u8`, which should be used:
///
///
/// # Typical Example using [`NibSlice`]
///
/// ```
/// use quartet::{NibRef, NibSlice};
/// let ns = NibSlice::from_bytes(&[0x12, 0x34]);
/// let nr: &NibRef = &ns[2];
/// let n = u8::from(nr);
/// assert_eq!(n, 0x3);
/// ```
///
/// # Direct usage (uncommon)
///
/// ```
/// use quartet::NibRef;
/// let v = 0x12;
/// let nr: &NibRef = NibRef::from_high(&v);
/// let n = u8::from(nr);
/// assert_eq!(n, 0x1);
/// ```
pub struct NibRef {
    // WARNING: we abuse the `len` field to hold an indication of which nibble (high or low) this
    // represents. Using `derive()` for anything that treats this as a normal slice will be wrong.
    inner: [u8],
}

impl NibRef {
    fn is_high(&self) -> bool {
        self.inner.len() == 1
    }

    /// Construct a [`NibRef`] that refers to the high (first) nibble of the byte
    pub fn from_high(v: &u8) -> &Self {
        unsafe { mem::transmute(slice::from_raw_parts(v as *const _, 1)) }
    }

    /// Construct a [`NibRef`] that refers to the low (second) nibble of the byte
    pub fn from_low(v: &u8) -> &Self {
        unsafe { mem::transmute(slice::from_raw_parts(v as *const _, 0)) }
    }
}

impl fmt::Debug for NibRef {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}", u8::from(self))
    }
}

impl From<&NibRef> for u8 {
    fn from(nr: &NibRef) -> Self {
        let v = unsafe { slice::from_raw_parts(nr.inner.as_ptr(), 1) }[0];
        if nr.is_high() {
            v >> 4
        } else {
            v & 0x0f
        }
    }
}

impl<'a> ops::Index<usize> for NibSlice<'a> {
    type Output = NibRef;

    fn index(&self, index: usize) -> &Self::Output {
        assert!(index < self.len());
        let index = index + if self.exclude.is_first_excluded() { 1 } else { 0 };
        let b_idx = index >> 1;
        let is_high = index & 1 == 0;

        let b = &self.inner[b_idx];
        if is_high {
            NibRef::from_high(b)
        } else {
            NibRef::from_low(b)
        }
    }
}

#[cfg(test)]
mod test_nibref {
    use super::*;

    #[test]
    fn low_works() {
        let v = 0xab;
        let a = NibRef::from_low(&v);
        assert_eq!(u8::from(a), 0x0b);
    }

    #[test]
    fn high_works() {
        let v = 0xab;
        let a = NibRef::from_high(&v);
        assert_eq!(u8::from(a), 0x0a);
    }
}

#[cfg(test)]
mod test_nibslice {
    use super::*;
    
    #[test]
    fn build_ok() {
        let ns = NibSlice::from_bytes_exclude(&[0xab, 0xcd], Exclude::Last);
        assert_eq!(ns.len(), 3);
    }

    #[test]
    fn index_single() {
        let ns = NibSlice::from_bytes_exclude(&[0x12, 0x34], Exclude::First);
        assert_eq!(ns.len(), 3);

        let n = &ns[1];
        assert_eq!(u8::from(n), 0x3);
    }

    #[test]
    #[should_panic]
    fn index_oob() {
        let ns = NibSlice::from_bytes_exclude(&[0x12, 0x34], Exclude::Both);
        assert_eq!(ns.len(), 2);

        // panic!
        let n = &ns[2];
        assert_eq!(u8::from(n), 0x4);
    }
}

