use tokio::net;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error + 'static>> {
    let sock = net::UdpSocket::bind("0.0.0.0:0").await?;
    sock.set_broadcast(true)?;

    let addr = "192.168.6.255:2000";
    let buf = b"hello\r\n";
    loop {
        sock.send_to(&buf[..], addr).await?;
        tokio::time::sleep(tokio::time::Duration::from_millis(100)).await;
    }
}
