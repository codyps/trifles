CC = gcc
LD = gcc
RM = rm -f
SRC = rwt.c ben.c
OBJ = $(SRC:=.o)
rwt : $(OBJ)
	$(LD) -o $@ $^

all: build

build: rwt

%.c.o : %.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean :
	$(RM) rwt $(OBJ)

test : rwt
	./rwt test.torrent show

retest: | clean build test
