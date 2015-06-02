#![feature(libc)]
extern crate libc;

#[link(name = "foo")]
extern {
    fn foo() -> *const libc::c_void;
}

fn main() {
    unsafe {
        let f : extern fn () -> libc::c_int = std::mem::transmute(foo());
        println!("got f {}", f());
    }
}
