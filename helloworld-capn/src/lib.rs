pub mod helloworld_capnp {
    include!(concat!(env!("OUT_DIR"), "/helloworld_capnp.rs"));
}

pub use helloworld_capnp::greeter::{Server, Client};
pub use helloworld_capnp::greeter;
