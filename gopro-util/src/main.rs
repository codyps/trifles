#![macro_use]
extern crate clap;

use std::fs;

fn main() {
    let matches = app_from_crate!()
        .subcommand(SubCommand::with_name("create-combine-lists")
                    .arg(Arg::with_name("DIR")
                         .required(true)
                         .index(1)
                    )
        ).get_matches();


    if let Some(matches) = matches.subcommand_matches("create-combine-lists") {
        let mut bases = HashMap::new();
        let d = matches.value_of("DIR").unwrap();

        let paths = fs::read_dir(d);

        for p in paths {
            // check for a pattern match
            if !p.starts_with("G") {
                continue;
            }

            if !p.ends_with(".MP4") {
                continue;
            }

            // 0123456789AB
            // GX030293.MP4
            if p.len() != 0xc {
                continue;
            }

            let s = match p.to_str() {
                Some(s) => s,
                None => continue,
            }

            // P (x264) or X (x265)
            // note: we could probably mix these.
            let k = s[1];
            // GXaa1234 - aa - the index of clip
            let i = s[2..4];
            // GX01bbbb - bbbb - the number of the video (composed of clips)
            let n = s[4..8];
            
            bases.entry((k, n)).
        }
    }

    println!("Hello, world!");
}
