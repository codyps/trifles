#! /bin/sh

if [ $# != 1 ]; then
	echo "usage: $0 <conpal>" >>/dev/stderr
	exit 1
fi

$1  | awk '{ N+=1; printf "URxvt.color"N-1": "; print $0 }'
