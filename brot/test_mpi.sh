#!/bin/sh

if [ $# -ne 2 ]; then
	echo "usage: $0 <mpi program> <machinefile>" >> /dev/stderr
	exit 1
fi

outfile="mpi_`basename $1`.log"
mpirun=/usr/local/mpich/bin/mpirun
for ((th=2; th<=512; th=th+1)); do
	total_time=0;
	for ((iter=0; iter<10; iter=iter+1)); do
		t=`$mpirun -machinefile $2 -np $th $1`
		total_time=`echo scale=50\;$total_time + $t | bc`
		echo $total_time >> /dev/stderr
	done
	ave_time=`echo scale=50\; $total_time / $iter | bc`
	echo $ave_time
done > $outfile

