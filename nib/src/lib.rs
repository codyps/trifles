#![warn(rust_2018_idioms, missing_debug_implementations, missing_docs)]
//! `nib` provides useful abstractions for working with data that is described/structure in 4-bit
//! chunks.
//!
//!
//! ```
//! use quartet::NibSlice;
//! let nib_slice = NibSlice::from_bytes_skip_last(&[0x12, 0x34, 0x50]);
//! assert_eq!(nib_slice.index(1), 2);
//! ```

//use std::fmt;
use std::ops;

/// A slice (`[T]`) over nibs (4-bit values)
///
/// Internally, it operates on an array of bytes, and interprets them as pairs of nibs. This is
/// intended to allow use of a `NibSlice` to examine binary structures that are composed of nibs.
///
/// For each byte, the nibble composed of the lower bits (mask = `0x0f`) is considered to come
/// before the nibble composed of the higher bits (mask = `0xf0`).
#[derive(Clone, Copy, Debug)]
pub struct NibSlice<'a> {
    exclude: Exclude,
    inner: &'a [u8],
}

impl<'a> NibSlice<'a> {
    /// Create a [`NibSlice`] from a slice of bytes and whether to exclude either end of the slice
    pub fn from_bytes_exclude(inner: &'a [u8], exclude: Exclude) -> Self {
        if inner.len() == 0 {
            assert_eq!(exclude, Exclude::None_);
        }
        if inner.len() == 1 {
            assert_ne!(exclude, Exclude::Both);
        }

        Self {
            inner,
            exclude,
        }
    }

    /// Create a [`NibSlice`] from a slice of bytes, excluding the last nibble in the slice
    pub fn from_bytes_skip_last(inner: &'a [u8]) -> Self {
        Self::from_bytes_exclude(inner, Exclude::Last)
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

    /// Split the [`NibSlice`] into 2 [`NibSlice`]s at the nibble offset given
    pub fn split_at(&self, _offset: usize) -> (NibSlice<'a>, NibSlice<'a>) {
        unimplemented!()
    }

    /// Index, using various ranges, a `NibSlice` into `NibSlice`s that are sub-slices
    ///
    /// # Examples
    ///
    ///
    /// ```
    /// use quartet::{NibSlice, Exclude};
    /// let ns = NibSlice::from_bytes_exclude(&[0x12, 0x34, 0x56], Exclude::Both);
    /// let n = ns.index(2..4);
    ///
    /// assert_eq!(n, NibSlice::from_bytes(&[0x45]));
    /// ```
    pub fn index<S: SliceIndex<'a>>(&self, idx: S) -> S::Output {
        self.get(idx).unwrap()
    }

    /// Get the [`NibSlice`] refered to by the indexing value, or return `None` if index is out of
    /// range
    pub fn get<S: SliceIndex<'a>>(&self, idx: S) -> Option<S::Output> {
        idx.get(self)
    }

    /// If the slice refers to a single nibble, return that nibble as a byte. Panic if slice does
    /// not have exactly one nibble
    ///
    /// # Examples
    ///
    /// ```
    /// use quartet::{NibSlice, Exclude};
    ///
    /// let orig_s = NibSlice::from_bytes_exclude(&[0x02, 0x34], Exclude::First);
    /// let nib_s = orig_s.index(..1);
    /// assert_eq!(nib_s.len(), 1);
    ///
    /// let nib = nib_s.nibble();
    ///
    /// assert_eq!(nib, 0x2);
    /// ```
    pub fn nibble(&self) -> u8 {
        self.try_nibble().unwrap() 
    }

    /// If the slice refers to a single nibble, return that nibble as a byte. Return None if the
    /// slice does not have exactly one nibble
    ///
    /// # Examples
    ///
    /// ```
    /// use quartet::{NibSlice, Exclude};
    /// let orig_s = NibSlice::from_bytes_exclude(&[0x02, 0x34], Exclude::First);
    /// let nib_s = orig_s.index(..1);
    /// let nib = nib_s.try_nibble();
    /// assert_eq!(nib, Some(0x2));
    ///
    /// // more than 1 nibble
    /// assert_eq!(orig_s.index(1..3).try_nibble(), None);
    /// ```
    pub fn try_nibble(&self) -> Option<u8> {
        if self.len() != 1 {
            return None
        }

        let b = self.inner[0];
        Some(match self.exclude {
            Exclude::First => { b & 0xf },
            Exclude::Last => { b >> 4 },
            _ => panic!(),
        })
    }

    /// Create an iterator over the [`NibSlice`], where each item is a nibble
    pub fn iter(&self) -> Iter<'a> {
        Iter { inner: *self }
    }

    /// Decompose the [`NibSlice`] into byte-oriented parts
    ///
    /// The first and last members of the tuple are the non-byte aligned nibbles optionally at the
    /// start and end of the [`NibSlice`]. The middle member is the byte-aligned nibbles organized
    /// into bytes
    pub fn byte_parts(&self) -> (Option<u8>, &[u8], Option<u8>) {
        let (rem, first) = if self.exclude.is_first_excluded() {
            (&self.inner[1..], Some(self.inner[0] & 0x0f))
        } else {
            (self.inner, None)
        };

        let (rem, last) = if self.exclude.is_last_excluded() {
            let l = rem.len();
            (&rem[..l - 1], Some(rem[rem.len() - 1] >> 4))
        } else {
            (rem, None)
        };

        (first, rem, last)
    }
}

/// Iterate over a [`NibSlice`], returning a nibble for each item
#[derive(Debug)]
pub struct Iter<'a> {
    inner: NibSlice<'a>, 
}

impl<'a> Iterator for Iter<'a> {
    type Item = u8;

    fn next(&mut self) -> Option<Self::Item> {
        if self.inner.len() == 0 {
            return None;
        }

        let v = if self.inner.exclude.is_first_excluded() {
            let v = self.inner.inner[0] & 0x0f;
            self.inner.inner = &self.inner.inner[1..];
            self.inner.exclude = Exclude::from_excludes(false, self.inner.exclude.is_last_excluded());
            v
        } else {
            let v = self.inner.inner[0] >> 4;
            self.inner.exclude = Exclude::from_excludes(true, self.inner.exclude.is_last_excluded());
            v
        };

        if self.inner.inner.len() == 0 {
            self.inner.exclude = Exclude::None_;
        }
        if self.inner.inner.len() == 1 && self.inner.exclude == Exclude::Both {
            self.inner.exclude = Exclude::None_;
            self.inner.inner = &[];
        }

        Some(v)

        /*
        let n = self.inner.index(0);
        self.inner = self.inner.index(1..);
        Some(n)
        */
    }
}

impl PartialEq<NibSlice<'_>> for NibSlice<'_> {
    fn eq(&self, other: &NibSlice<'_>) -> bool {
        let i1 = self.iter();
        let i2 = other.iter();

        // NOTE: performance of this (doing a nibble-based comparison via an iterator) is probably
        // really bad. Ideally, we'd pick a faster method in cases where we have byte-alignment
        // (ie: where both slices have the same `exclude.is_first_excluded()` value. Should really
        // speed things up.
        i1.eq(i2)
    }
}

impl Eq for NibSlice<'_> {}

/// A helper trait used for indexing operations
///
/// This is modeled after `std::slice::SliceIndex`, which slight modification to return owned types
/// (as is required for our double-fat slice references).
pub trait SliceIndex<'a> {
    /// Type returned by this indexing
    type Output;

    /// Returns a shared reference to the output at this location, if in bounds.
    fn get(self, slice: &NibSlice<'a>) -> Option<Self::Output>;
}

// ```norust
//      ab | cd | ef
// ex:  .
// o:1:      ^
// 
// index: 2
// boffs: 1
// is_low: false
//
//      ab | cd | ef
// ex:  .          .
// o:3:           ^
// 
// index: 4
// boffs: 2
// is_low: false
// ```
fn b(exclude: Exclude, offs: usize) -> (usize, bool) {
    let index = offs + if exclude.is_first_excluded() { 1 } else { 0 };
    let b_idx = index >> 1;
    let is_low = index & 1 == 1;

    (b_idx, is_low)
}

/// Decompose a nibble offset into byte oriented terms.
///
/// Returns `(byte_offset, is_low)`. `byte_offset` is a offset into a `[u8]`. `is_low` is true when
/// the `offs` refers to the lower nibble in the byte located at `byte_offset`.
pub fn decompose_offset(exclude: Exclude, offs: usize) -> (usize, bool) {
    b(exclude, offs)
}

impl<'a> SliceIndex<'a> for usize {
    type Output = u8;

    fn get(self, slice: &NibSlice<'a>) -> Option<Self::Output> {
        if self >= slice.len() {
            return None;
        }

        let (b_idx, is_low) = b(slice.exclude, self);

        let b = &slice.inner[b_idx];
        Some(if is_low {
            b & 0x0f
        } else {
            b >> 4
        })
    }
}

impl<'a> SliceIndex<'a> for ops::Range<usize> {
    type Output = NibSlice<'a>;

    fn get(self, slice: &NibSlice<'a>) -> Option<Self::Output> {
        eprintln!("{:?} {:#x?}", self, slice);
        if self.start > self.end {
            eprintln!("1: {} {}", self.start, self.end);
            return None;
        }

        if self.end > slice.len() {
            eprintln!("2: {} {}", self.end, slice.len());
            return None;
        }

        let (b_start, exclude_first) = b(slice.exclude, self.start);
        let (b_end, end_is_low) = b(slice.exclude, self.end + 1);
        eprintln!("bs: {:?}, ef: {:?}, be: {:?}, eil: {:?}", b_start, exclude_first, b_end, end_is_low);

        /*
        let b_end = if b_start == b_end {
            b_end + 1
        } else {
            b_end
        };
        */

        Some(NibSlice::from_bytes_exclude(
            &slice.inner[b_start..b_end],
            Exclude::from_excludes(exclude_first, !end_is_low),
        ))
    }
}

impl<'a> SliceIndex<'a> for ops::RangeFrom<usize> {
    type Output = NibSlice<'a>;

    fn get(self, slice: &NibSlice<'a>) -> Option<Self::Output> {
        (self.start..slice.len()).get(slice)
    }
}

impl<'a> SliceIndex<'a> for ops::RangeTo<usize> {
    type Output = NibSlice<'a>;

    fn get(self, slice: &NibSlice<'a>) -> Option<Self::Output> {
        (0..self.end).get(slice)
    }
}

impl<'a> SliceIndex<'a> for ops::RangeFull {
    type Output = NibSlice<'a>;

    fn get(self, slice: &NibSlice<'a>) -> Option<Self::Output> {
        Some(*slice)
    }
}

impl<'a> SliceIndex<'a> for ops::RangeInclusive<usize> {
    type Output = NibSlice<'a>;

    fn get(self, slice: &NibSlice<'a>) -> Option<Self::Output> {
        (*self.start()..(*self.end() + 1)).get(slice)
    }
}

impl<'a> SliceIndex<'a> for ops::RangeToInclusive<usize> {
    type Output = NibSlice<'a>;

    fn get(self, slice: &NibSlice<'a>) -> Option<Self::Output> {
        (0..self.end + 1).get(slice)
    }
}

/*
impl<'a> TryFrom<NibSlice<'a> for u8 {
    type Error = ();

    fn try_from(value: NibSlice<'a>) -> Result<Self, Self::Error> {
        if value.len() != 1 {
            return Err(Self::Error);
        }

        match value.exclude {
            
        }
    }
}
*/

/*
impl<'a> fmt::Debug for NibSlice<'a> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let mut dl = f.debug_list();
        /*
        for i in self.iter() {
            dl.entry(&i);
        }
        */
        dl.finish()
    }
}
*/

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
        assert_eq!(3, ns.index(1));
    }

    #[test]
    #[should_panic]
    fn index_oob() {
        let ns = NibSlice::from_bytes_exclude(&[0x12, 0x34], Exclude::Both);
        assert_eq!(ns.len(), 2);

        // panic!
        let n = ns.index(2);
        assert_eq!(n, 0x4);
    }

    #[test]
    fn index_range() {
        let ns = NibSlice::from_bytes_exclude(&[0x12, 0x34, 0x56], Exclude::Both);
        assert_eq!(ns.len(), 4);

        let n = ns.index(1..3);
        println!("{:#x?}", n);

        assert_eq!(n, NibSlice::from_bytes_exclude(&[0x34], Exclude::None_));
        assert_eq!(n.len(), 2);
    }

    #[test]
    fn get_range_oob_exclude_both() {
        let ns = NibSlice::from_bytes_exclude(&[0x12, 0x34], Exclude::Both);
        assert_ne!(ns.len(), 4);

        let x = ns.get(1..3);
        assert_eq!(x, None);
    }

    #[test]
    #[should_panic]
    fn index_range_bad() {
        let ns = NibSlice::from_bytes_exclude(&[0x12, 0x34], Exclude::Both);
        assert_ne!(ns.len(), 4);

        let _ = ns.index(1..3);
    }

    #[test]
    fn index_2() {
        let ns = NibSlice::from_bytes_exclude(&[0x12, 0x04], Exclude::Both);
        eprintln!("n1: {:?}", ns.len());
        assert_eq!(ns.len(), 2);
        let n = ns.get(1..);
        eprintln!("n: {:?}", n.map(|x| x.len()));
        assert_eq!(n, Some(NibSlice::from_bytes_exclude(&[0x00], Exclude::First)));
    }

    #[test]
    fn index_to_1() {
        let orig_s = NibSlice::from_bytes_exclude(&[0x02, 0x34], Exclude::First);
        let nib_s = orig_s.index(..1);
        assert_eq!(nib_s.len(), 1);

        let nib = nib_s.nibble();

        assert_eq!(nib, 0x2);
    }

    #[test]
    fn index_middle() {
        let ns = NibSlice::from_bytes_exclude(&[0x12, 0x34, 0x56], Exclude::Both);
        let n = ns.index(2..4);
        assert_eq!(n, NibSlice::from_bytes(&[0x45]));
    }

    #[test]
    fn iter() {
        let ns = NibSlice::from_bytes_exclude(&[0x12, 0x34], Exclude::Both);

        let mut i = ns.iter();

        assert_eq!(i.next(), Some(2));
        assert_eq!(i.next(), Some(3));
        assert_eq!(i.next(), None);
        assert_eq!(i.next(), None);
        assert_eq!(i.next(), None);
        assert_eq!(i.next(), None);
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

    /// Given bools of what to include, generate an [`Exclude`] instance
    pub fn from_includes(include_first: bool, include_last: bool) -> Self {
        Self::from_excludes(!include_first, !include_last)
    }

    /// Given bools of what to exclude, generate an [`Exclude`] instance
    pub fn from_excludes(exclude_first: bool, exclude_last: bool) -> Self {
        match (exclude_first, exclude_last) {
            (true, true) => Exclude::Both,
            (false, true) => Exclude::Last,
            (true, false) => Exclude::First,
            (false, false) => Exclude::None_,
        }
    }
}

