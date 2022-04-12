use lazy_static::lazy_static;
use std::sync::Mutex;

lazy_static! {
    static ref FOO: Mutex<Option<u64>> = Mutex::new(Some(2));
}

fn main() {
    let foo = FOO.lock().unwrap();

    let foo = if let Some(ref foo) = *foo {
        foo
    } else {
        println!("BAM");
        return;
    };

    println!("foo: {}", foo);
}
