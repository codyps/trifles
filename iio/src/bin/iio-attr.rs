use std::fs;
use std::path::Path;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let dev_d = Path::new("/sys/bus/iio/devices/iio:device0");
    let attr = dev_d.join("in_angl_raw");
    let zero = dev_d.join("in_angl_set_zero");

    let d = std::time::Duration::from_millis(1);
    for _ in 0..20 {
        let mut a = fs::read(&attr)?;
        if a[a.len() - 1] == b'\n' {
            a.drain((a.len() - 1)..);
        }
        println!("{}", String::from_utf8_lossy(&a[..]));
        std::thread::sleep(d);
    }

    fs::write(&zero, b"1\n").unwrap();

    for _ in 0..200 {
        let a = fs::read(&attr);
        match a {
            Ok(mut a) => {
                if a[a.len() - 1] == b'\n' {
                    a.drain((a.len() - 1)..);
                }
                println!("{}", String::from_utf8_lossy(&a[..]));
            }
            Err(e) => {
                println!("ERROR: {}", e);
            }
        }
        std::thread::sleep(d);
    }

    Ok(())
}
