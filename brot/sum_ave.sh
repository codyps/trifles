#! /bin/sh

sum=0;
for i in $*; do
       	echo $i; sum=`echo $i + $sum | bc`;
done; 

echo scale=10\; $sum / 7 | bc
