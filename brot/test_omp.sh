#!/bin/sh

if [ $# -ne 1 ]; then
	echo "usage: $0 <omp program>" >> /dev/stderr
	exit 1
fi


sch="dynamic guided static"
for s in $sch; do
	for ((th=1; th<=16; th=th+1)); do
		total_time=0;
		for ((iter=0; iter<500; iter=iter+1)); do
			t=`OMP_SCHEDULE=$s OMP_NUM_THREADS=$th $1`
			total_time=`echo scale=50\;$total_time + $t | bc`
		done
		ave_time=`echo scale=50\; $total_time / $iter | bc`
		echo $ave_time
	done > omp_$s.log
done
