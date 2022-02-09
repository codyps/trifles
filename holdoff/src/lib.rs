#![warn(rust_2018_idioms)]
#![no_std]

use core::ops::Add;

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
