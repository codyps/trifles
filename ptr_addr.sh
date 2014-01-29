#! /bin/sh

if [ -z "$CC" ]; then
	CC=gcc
fi


$CC ptr_addr.c -o p32 -m32
$CC ptr_addr.c -o p64 -m64

./p32
./p64
