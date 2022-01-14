fn main() -> Result<(), zbus::Error> {
    let connection = zbus::Connection::new_system()?;

    let res = connection.call_method(
        Some("org.freedesktop.systemd1"),
        "/org/freedesktop/systemd1",
        Some("org.freedesktop.systemd1.Manager"),
        "StartUnit",
        &("foo.service", "fail"),
    )?;

    dbg!(res);
    Ok(())
}
