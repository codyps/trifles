fn main() {
        ::capnpc::CompilerCommand::new().file("helloworld.capnp").run().unwrap();
}
