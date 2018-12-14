extern crate typenum;

#[macro_use]
extern crate generic_array;

use typenum::{PartialQuot,Integer};
use generic_array::{ArrayLength,GenericArray};

pub struct A32<N: ArrayLength<u8>> {
    x: GenericArray<u32, PartialQuot<N, typenum::U4>>
}

pub trait Only2 {}

impl Only2 for typenum::U2 {}

pub fn only_2<N: ArrayLength<u8> + Only2>(v: &GenericArray<u8, N>)
{
    for i in v.iter() {
        println!("{}, ", i)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        only_2(&arr![u8; 1, 2]);
        only_2(&arr![u8; 1]);
    }
}
