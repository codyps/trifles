#![feature(macro_rules)]

macro_rules! typed ( ($e:expr : $t:ty) => ({ let x: $t = $e; x }) )
