#! /bin/sh

x1=2.7
x2=4.5
y1=8
y2=16

echo "scale=5; ($y2 - $y1) / ($x2 - $x1) * ( $1 - $x1) + $y1" | bc
