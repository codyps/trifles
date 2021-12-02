

#[derive(Debug)]
struct Cds {
    path: PathBuf,
}

impl Cds {
    fn new(path: &Path) -> Result<Self, Error> {
        let path = path.join("cds-v1");
        std::fs::create_dir_all(&path).map_err(|e| Error::CreateOutputDir {
            path: path.clone(),
            e,
        })?;

        Ok(Self { path })
    }

    fn store(&self, data: &[u8]) -> Result<(PathBuf, bool), Error> {
        let mut hash = blake2::Blake2b::new();
        hash.update(&data);
        let hash = hash.finalize();
        let hex_hash = hex::encode(hash);
        let hex = hex_hash.as_bytes();

        let base = Path::new(str::from_utf8(&hex[0..1]).unwrap())
            .join(str::from_utf8(&hex[1..2]).unwrap());
        let d = self.path.join(base);

        std::fs::create_dir_all(&d).map_err(|e| Error::CdsCreateDir { path: d.clone(), e })?;

        let f = d.join(str::from_utf8(&hex[2..]).unwrap());
        let exists = f.exists();
        if !exists {
            fs::write(&f, data).map_err(|e| Error::CdsWrite { path: f.clone(), e })?;
        } else {
            // TODO: revalidate, maybe?
        }

        Ok((f, exists))
    }
}
