SRC = mandelbrot_omp.c

CC=gcc
RM=rm -f

CFLAGS = -ggdb
override CFLAGS+= -Wall -pipe -fopenmp -lX11 -I/usr/include/X11 -L/usr/lib -lm

BIN = brot_omp

.PHONY: all
all: build
	
.PHONY: build
build: $(BIN)

.PHONY: clean
clean:
	$(RM) $(BIN)

$(BIN): $(SRC)
	$(CC) $(CFLAGS) -o $@ --combine $<

