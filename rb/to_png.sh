#!/bin/sh

if [ $# -ne 1 ]; then
	echo "usage: $0 <graphviz-file>"
	exit 1
fi

exec dot $1 -Tpng -o $1.png
