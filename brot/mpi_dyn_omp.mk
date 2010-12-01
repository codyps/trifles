SRC = mandelbrot_dyn.c
BIN = brot_mpi_dyn_omp

override CFLAGS += -fopenmp
CC=/usr/local/mpich/bin/mpicc

include common.mk
