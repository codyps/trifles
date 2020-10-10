#![warn(rust_2018_idioms, missing_debug_implementations, missing_docs)]
//! `nib` provides useful abstractions for working with data that is described/structure in 4-bit
//! chunks.

use std::fmt;
use std::mem;
use std::slice;
use std::ops::Index;

/// A slice (`[T]`) over nibs (4-bit values)
///
/// Internally, it operates on an array of bytes, and interprets them as pairs of nibs. This is
/// intended to allow use of a `NibSlice` to examine binary structures that are composed of nibs.
///
/// For each byte, the nibble composed of the lower bits (mask = `0x0f`) is considered to come
/// before the nibble composed of the higher bits (mask = `0xf0`).
// NOTE: we can restructure this to shrink it a little, but we really want custom dynamic sized types.
// options: 
//   - [u8] (dst) -> transmute -> (nib_len, const* u8)
//   - (nib_len, const *u8) (non-dst)
pub struct NibSlice<'a> {
    exclude: Exclude,
    inner: &'a [u8],
}

impl<'a> NibSlice<'a> {
    /// Create a [`NibSlice`] from a slice of bytes and whether to exclude either end of the slice
    pub fn from_bytes_exclude(inner: &'a [u8], exclude: Exclude) -> Self {
        Self {
            inner,
            exclude,
        }
    }

    /// Create a [`NibSlice`] from a slice of bytes, excluding the last nibble in the slice
    pub fn from_bytes_skip_last(inner: &'a [u8]) -> Self {
        Self {
            exclude: Exclude::Last,
            inner,
        }
    }

    /// Create a [`NibSlice`] from a slice of bytes, including all nibbles in the given bytes
    ///
    /// The resulting [`NibSlice`] will have `.len()` equal to `2 * inner.len()`.
    pub fn from_bytes(inner: &'a [u8]) -> Self {
        Self::from_bytes_exclude(inner, Exclude::None_)
    }

    /// The number of nibbles in the [`NibSlice`]
    pub fn len(&self) -> usize {
        self.inner.len() * 2 - self.exclude.len_excluded()
    }
}

/// Formed as a return value to represent a single nibble in cases where a ref return is required
/// (like indexing).
///
/// Provides conversion to `u8`, which should be used:
///
///
/// # Typical Example using [`NibSlice`]
///
/// ```
/// use nib::{NibRef, NibSlice};
/// let ns = NibSlice::from_bytes(&[0x12, 0x34]);
/// let nr: &NibRef = &ns[2];
/// let n = u8::from(nr);
/// assert_eq!(n, 0x3);
/// ```
///
/// # Direct usage (uncommon)
///
/// ```
/// use nib::NibRef;
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

impl<'a> Index<usize> for NibSlice<'a> {
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

impl<'a> fmt::Debug for NibSlice<'a> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let mut dl = f.debug_list();

        dl.finish()
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

/// Which nibs are excluded from the [`NibSlice`] but are included in the internal `[u8]`
// NOTE: if we want to represent general bit chunks (rather than exactly 4-bit chunks) we'd need a
// pair of offsets that hold values between 0 and 7.
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub enum Exclude {
    /// the first (high) nibble in the slice is excluded
    First,
    /// the last (low) nibble in the slice is excluded
    Last,
    /// no nibbles in the byte slice are excluded
    None_,
    /// both the high nibble in the first byte and the low nibble in the last byte are excluded
    Both,
}

impl Exclude {
    /// Is the first nibble (high) excluded?
    pub fn is_first_excluded(self) -> bool {
        match self {
            Self::First | Self::Both => true,
            _ => false
        }
    }

    /// Is the last nibble (low) excluded?
    pub fn is_last_excluded(self) -> bool {
        match self {
            Self::Last | Self::Both => true,
            _ => false
        }
    }

    /// Number of nibbles to be excluded
    pub fn len_excluded(self) -> usize {
        match self {
            Self::Both => 2,
            Self::First | Self::Last => 1,
            Self::None_ => 0
        }
    }
}

