#![warn(rust_2018_idioms)]
#![no_std]

use core::ops::Add;

/// Emit transitions (any change in value) only after some time has passed since the previous
/// transision
#[derive(Debug)]
pub struct Holdoff<V, T, D> {
    prev_value: Option<V>,
    next_notify_min_time: Option<T>,
    holdoff_duration: D,
}

impl<V: PartialEq + Clone, T: PartialOrd + Add<D, Output = T>, D: Copy> Holdoff<V, T, D> {
    pub fn new(holdoff_duration: D) -> Self {
        Self {
            prev_value: None,
            next_notify_min_time: None,
            holdoff_duration,
        }
    }

    pub fn push(&mut self, new_value: V, current_time: T) -> Option<()> {
        let new_value = Some(new_value);
        // never emit an event if the value is unchanged
        if self.prev_value == new_value {
            return None;
        }

        match self.next_notify_min_time.as_ref() {
            None => {
                // if we've never notified, allow it
            }
            Some(nnmt) if nnmt <= &current_time => {
                // if we're after the minimum time, allow it
            }
            _ => return None,
        }

        // emit allowed, update bookeeping
        self.next_notify_min_time = Some(current_time + self.holdoff_duration);
        self.prev_value = new_value;

        Some(())
    }
}

/// Emit a change from `false` to `true` only after some time since the last transision from
/// `false` to `true`. No other edges are emitted.
///
/// This ignores changes to `false` if they occur durring the holdoff window (iow: does not
/// consider them to be changes in the value at all). For an event to be emitted, a negative edge
/// must occur outside of the holdoff followed by a positive edge any time after the negative edge.
#[derive(Debug)]
pub struct PositiveEdgeHoldoff<T, D> {
    prev_value: Option<bool>,
    next_notify_min_time: Option<T>,
    holdoff_duration: D,
}

impl<T: PartialOrd + Add<D, Output = T>, D: Copy> PositiveEdgeHoldoff<T, D> {
    pub fn new(holdoff_duration: D) -> Self {
        Self {
            prev_value: None,
            next_notify_min_time: None,
            holdoff_duration,
        }
    }

    pub fn push(&mut self, new_value: bool, current_time: T) -> Option<()> {
        // ignore entirely if the value is unchanged
        if self.prev_value == Some(new_value) {
            return None;
        }

        // ignore value entirely if we haven't passed the holdoff
        match self.next_notify_min_time.as_ref() {
            None => {
                // if we've never notified, allow it
            }
            Some(nnmt) if nnmt <= &current_time => {
                // if we're after the minimum time, allow it
            }
            _ => return None,
        }

        // on negative edge. update previous value, but don't update time or emit event
        if !new_value {
            self.prev_value = Some(new_value);
            return None;
        }

        // emit allowed, update bookeeping
        self.next_notify_min_time = Some(current_time + self.holdoff_duration);
        self.prev_value = Some(new_value);

        Some(())
    }
}
