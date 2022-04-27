#! /usr/bin/bash
set -euf -o pipefail

crates_api_root="https://crates.io/api/v1/crates"
crates_dl_root="https://static.crates.io/crates"
name="crates.io"
index_name="$name-index"
index_url="https://github.com/rust-lang/crates.io-index"
if [ -e "$index_name" ]; then
	git -C "$index_name" remote rm origin
	git -C "$index_name" remote add origin "$index_url"
	git -C "$index_name" fetch origin master --depth 1
	git -C "$index_name" reset --hard FETCH_HEAD
else
	git clone "$index_url" "$index_name" --depth 1
fi

crates="$(find "$index_name" -name '[a-z0-9]*' -type f)"

crates_ct="$(echo "$crates" | wc -l)"
c=0

for i in $crates; do
	enc_crate_name="${i#"$index_name/"}"

	crate_name="${enc_crate_name##*/}"

	# TODO: use `jq` to extract the version numbers 
	versions="$(<"$i" jq -r ".vers")"

	for crate_version in $versions; do

		crate_tar_gz_d="$name-crate/$enc_crate_name"
		crate_tar_gz="$crate_tar_gz_d/$crate_version.tar.gz"

		if ! [ -e "$crate_tar_gz" ]; then
			mkdir -p "$crate_tar_gz_d"
			echo "Fetch $crate_name-$crate_version"
			rm -f "$crate_tar_gz.tmp"
			# > GET /crates/rmodbus/rmodbus-0.3.9.crate HTTP/2
			# > Host: static.crates.io
			# > accept: */*
			# > user-agent: fetch-crates.io (cpschafer@gmail.com)

			#curl -f -H "User-Agent: fetch-crates.io (cpschafer@gmail.com)" -L \
			#	-o "$crate_tar_gz.tmp" "$crates_dl_root/$crate_name/$crate_name-$crate_version.crate"
			
			sleep 1
			crate_dl_url="$crates_api_root/$crate_name/$crate_version/download"
			if ! curl '-#' -f -H "User-Agent: fetch-crates.io (cpschafer@gmail.com)" -L \
				-o "$crate_tar_gz.tmp" "$crate_dl_url"; then
				>&2 echo "failed to fetch $crate_dl_url"
				continue;
			fi

			if ! [ -s "$crate_tar_gz.tmp" ]; then
				>&2 echo "fetched a zero size file"
				exit 1
			fi
			mv "$crate_tar_gz.tmp" "$crate_tar_gz"
		fi

		# extract the crate (if not already extracted)
		crate_src_d="$name-src/$enc_crate_name"
		crate_src="$crate_src_d/$crate_version"

		if ! [ -e "$crate_src" ]; then
			echo "Extract $crate_name-$crate_version"
			rm -rf "$crate_src.tmp"
			rm -rf "$crate_src"
			mkdir -p "$crate_src.tmp"
			# note: some crates fail to extract with gnu tar,
			# forust-0.1.0 fails due to gunzip complaining about
			# unexpected end of file
			bsdtar xf "$crate_tar_gz" -C "$crate_src.tmp"
			mv "$crate_src.tmp" "$crate_src"
		fi
	done
done

