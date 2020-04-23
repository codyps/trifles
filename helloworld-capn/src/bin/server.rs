use capnp::capability::Promise;
use capnp_rpc::pry;

#[derive(Default)]
struct MyGreeter {}

impl ::helloworld_capn::Server for MyGreeter {
    fn say_hello(&mut self,
        params: ::helloworld_capn::greeter::SayHelloParams,
        mut results: ::helloworld_capn::greeter::SayHelloResults)
        -> Promise<(), ::capnp::Error>
    {
        results.get().set_y(&format!("Hello {}!", pry!(pry!(params.get()).get_x())));

        Promise::ok(())
    }
}

#[async_std::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let addr = "[::1]:50022".parse()?;
    let listener = async_std::net::TcpListener::bind(&addr).await?;

    let mut greeter = greeter::ToClient::new(MyGreeter).into_client::<::capnp_rpc::Server>();

    while let mut incoming = listener.next().await {
        let socket = socket?;
        socket.set_nodelay(true)?;
        let (reader, writer) = socket.split();
        let network = twoparty::VatNetwork::new(reader, writer, rpc_twoparty_capnp::Side::Server, Default::default());
        let rpc_system = RpcSystem::new(Box::new(network), Some(calc.clone().client));
        spawner.spawn_local_obj
    }

    Ok(())
}
