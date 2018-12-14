#! /bin/sh

echo "cd: $(cd "$(dirname "$0")" && pwd)"
echo "rl: $(dirname "$(readlink -f "$0")")"
echo "rp: $(dirname "$(realpath "$0")")"
