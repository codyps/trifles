use std::fs;
use std::io::Read;
use std::convert::TryInto;
use std::path::Path;
use std::sync::Arc;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let running = Arc::new(std::sync::atomic::AtomicBool::new(true));

    let r = running.clone();
    ctrlc::set_handler(move || {
        r.store(false, std::sync::atomic::Ordering::Relaxed);
    })
    .expect("Error setting Ctrl-C handler");

    let mut iio_dev = fs::File::open("/dev/iio:device0").unwrap();

    let cfg_d = Path::new("/sys/kernel/config/iio");


    let dev_d = Path::new("/sys/bus/iio/devices/iio:device0");

    match fs::create_dir(cfg_d.join("triggers/hrtimer/inst0")) {
        Ok(()) => {},
        Err(e) => {
            if e.kind() != std::io::ErrorKind::AlreadyExists {
                panic!(e);
            }
        }
    }

    let buffer_enable = dev_d.join("buffer/enable");
    fs::write(&buffer_enable, b"0\n").unwrap();
    fs::write(dev_d.join("scan_elements/in_angl_en"), b"1\n").unwrap();
    fs::write(dev_d.join("scan_elements/in_timestamp_en"), b"1\n").unwrap();
    fs::write(dev_d.join("trigger/current_trigger"), b"inst0\n").unwrap();
    fs::write(&buffer_enable, b"1\n").unwrap();

    let mut buf = [0u8;16];
    while running.load(std::sync::atomic::Ordering::Relaxed) {
        let r = iio_dev.read(&mut buf)?;
        let buf = &buf[..r];

        let enc = u16::from_ne_bytes(buf[..2].try_into().unwrap()) & ((1 << 12) - 1);
        let ts = u64::from_ne_bytes(buf[8..16].try_into().unwrap());

        println!("{}: {}", ts, enc);
    }

    fs::write(&buffer_enable, b"0\n").unwrap();

    Ok(())
}
