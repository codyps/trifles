#!/bin/bash

set -euf -o pipefail

inf="$1"

if [ $# -eq 1 ]; then
	outf="$(dirname "$1")/roku.$(basename "$1")"
else
	outf="$2"
fi

ffmpeg -i "$1" -map 0:v -c:v copy -map 0:a -c:a:0 copy -map 0:a -c:a:1 flac "$outf"
