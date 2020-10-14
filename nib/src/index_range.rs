
    pub fn index_range<B: ops::RangeBounds<usize>>(&self, bounds: B) -> NibSlice<'a> {
        let (b_start, exclude_first) = match bounds.start_bound() {
            ops::Bound::Included(v) => {
                let (bi, bx) = b(self.exclude, *v);
                (bi, bx)
            },
            ops::Bound::Excluded(v) => {
                let (bi, bx) = b(self.exclude, *v);
                (bi, bx)
            },
            ops::Bound::Unbounded => {
                (0, self.exclude.is_first_excluded())
            },
        };

        let (b_end, exclude_last) = match bounds.end_bound() {
            ops::Bound::Included(v) => {
                let (bi, bx) = b(self.exclude, *v);
                (bi, bx)
            },
            ops::Bound::Excluded(v) => {
                let (bi, bx) = b(self.exclude, *v);
                (bi, bx)
            },
            ops::Bound::Unbounded => {
                (self.len() >> 1, self.exclude.is_last_excluded())
            },
        };

        NibSlice {
            inner: &self.inner[b_start..b_end],
            exclude: Exclude::from_excludes(exclude_first, exclude_last),
        }
    }
