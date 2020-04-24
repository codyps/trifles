use std::io;
use std::io::Write;
use std::collections::VecDeque;

/// Try to write to the underlying writable, detect blocking and defer into an
/// internal buffer
/// 
/// Subsequent calls to write first attempt to flush the internal buffer,
/// followed by using the input
#[derive(Debug)]
pub struct DeferedBuf<W: Write> {
    w: W,
    buf: VecDeque<u8>,
}

impl<W: Write> DeferedBuf<W> {
    pub fn with_capacity(w: W, capacity: usize) -> Self {
        Self {
            w,
            buf: VecDeque::with_capacity(capacity),
        }
    }

    pub fn new(w: W) -> Self {
        Self {
            w,
            buf: VecDeque::new(),
        }
    }

    pub fn get_mut(&mut self) -> &mut W {
        &mut self.w
    }

    pub fn get_ref(&self) -> &W {
        &self.w
    }
}

impl<W: Write> Write for DeferedBuf<W> {
    fn write(&mut self, mut inb: &[u8]) -> io::Result<usize> {
        let wl = inb.len();

        // first, writeback
        let s = self.buf.as_slices();
        let mut dct = 0;
        for b in [s.0, s.1].into_iter().cloned() {
            if b.len() == 0 {
                continue;
            }
            match self.w.write(b) {
                Ok(v) => {
                    dct += v;
                    if v != b.len() {
                        self.buf.drain(..dct);
                        self.buf.extend(inb);
                        return Ok(wl);
                    }
                },
                Err(e) => {
                    // no space or other error, append our new buffer, and
                    // return this
                    self.buf.drain(..dct);
                    self.buf.extend(inb);
                    return Err(e);
                }
            }
        }

        self.buf.drain(..dct);

        // try to write our new data, fallback to buffering on any error
        match self.w.write(inb) {
            Ok(v) => {
                inb = &inb[v..];
                self.buf.extend(inb);
            },
            Err(e) => {
                self.buf.extend(inb);
                return Err(e);
            }
        }

        Ok(wl)
    } 

    fn flush(&mut self) -> io::Result<()> {
        let s = self.buf.as_slices();
        let mut dct = 0;
        for b in [s.0, s.1].into_iter().cloned() {
            if b.len() == 0 {
                continue;
            }

            match self.w.write(b) {
                Ok(v) => {
                    dct += v;
                    if v != b.len() {
                        self.buf.drain(..dct);
                        return Err(io::Error::from(io::ErrorKind::WouldBlock));
                    }
                },
                Err(e) => {
                    self.buf.drain(..dct);
                    return Err(e);
                }
            }
        }

        self.buf.drain(..dct);
        Ok(())
    }
}

#[test]
fn basic() {
    use partial_io::{PartialOp, PartialWrite};

    let writer = Vec::new();
    let ops = vec![PartialOp::Limited(1), PartialOp::Limited(1), PartialOp::Err(io::ErrorKind::WouldBlock)];
    let partial_writer = PartialWrite::new(writer, ops);

    let mut db = DeferedBuf::new(partial_writer);

    let r = db.write(&[1,2,3]).expect("1st write should not fail");
    assert_eq!(r, 3);
    assert_eq!(&db.buf, &[2,3]);
    let r = db.write(&[4,5]).expect("2nd write should not fail");
    assert_eq!(r, 2);
    assert_eq!(&db.buf, &[3,4,5]);

    let r = db.write(&[6]);
    assert!(r.is_err());
    assert_eq!(r.unwrap_err().kind(), io::ErrorKind::WouldBlock);
    assert_eq!(&db.buf, &[3,4,5,6]);

    let r = db.write(&[7,8]).expect("3rd write should not fail");
    assert_eq!(r, 2);
    assert_eq!(&db.buf, &[]);

    assert_eq!(&db.w.get_mut()[..], &[1,2,3,4,5,6,7,8]);
}