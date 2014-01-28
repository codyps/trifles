#! /bin/sh
gcc ptr_addr.c -o p32 -m32
gcc ptr_addr.c -o p64 -m64

./p32
./p64
