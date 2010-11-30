SRC = mandelbrot_omp.c
BIN = brot_omp

CC=gcc
override CFLAGS += -fopenmp

include common.mk
