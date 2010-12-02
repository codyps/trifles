#!/bin/sh

if [ $# -ne 1 ]; then
	echo "usage: $0 <omp program>" >> /dev/stderr
	exit 1
fi


sch="dynamic guided static"
for i in $sch; do
	OMP_SCHEDULE=$i $1
done
