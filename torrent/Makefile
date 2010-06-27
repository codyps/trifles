CC = gcc
LD = gcc
RM = rm -f
CFLAGS = -g -Wall
SRC = rwt.c ben.c
OBJ = $(SRC:=.o)
rwt : $(OBJ)
	$(LD) -o $@ $^

.PHONY: all build clean test rebuild retest
all: build

build: rwt

%.c.o : %.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean :
	$(RM) rwt $(OBJ)

test : rwt
	./rwt test.torrent show

rebuild: | clean build
retest: | rebuild test
