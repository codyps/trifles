#!/bin/sh

slots=16

if [ $# -eq 1 ]; then
	slots=$1
fi

ct=1;
while [ $ct -lt 33 ]; do
       	printf "dell%02d\n" "$ct"
	ct=$(($ct+1))
done
