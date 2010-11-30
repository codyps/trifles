SRC = mandelbrot.c

CC=gcc
RM=rm -f

CFLAGS = -ggdb
override CFLAGS+= -Wall -pipe -fopenmp -lX11 -I/usr/include/X11 -L/usr/lib -lm

BIN = brot

.PHONY: all
all: build
	
.PHONY: build
build: $(BIN)

.PHONY: rebuild
rebuild: | clean $(BIN)

.PHONY: clean
clean:
	$(RM) $(BIN)

$(BIN): $(SRC)
	$(CC) $(CFLAGS) -o $@ --combine $<

.PHONY: archive
VER:=$(shell git rev-parse --verify --short HEAD 2>/dev/null)
archive:
	git archive --prefix='rsock-g$(VER)/' HEAD > rsock-g$(VER).tar

