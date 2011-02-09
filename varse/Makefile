TARGET=varse
SRC=parse.c
OBJ=$(SRC:=.o)

CC=gcc
RM=rm -f

OPTFLAGS=-march=native -O2

CFLAGS=$(OPTFLAGS) -ggdb -flto
override CFLAGS+=-pipe -Wall

LDFLAGS=-fwhole-program $(OPTFLAGS) -ggdb
override LDFLAGS+=-Wl,--as-needed -Wl,-O1

all: $(TARGET)

%.c.o : %.o
	$(CC) $(CFLAGS) -c -o $@ $<


$(TARGET):
	$(CC) $(LDFLAGS) -o $@ 

clean:
	$(RM) $(OBJ) $(TARGET)
