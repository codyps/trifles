CC = gcc
LD = $(CC)
CFLAGS = -Wall -g
LDFLAGS = $(CFLAGS)
RM = rm -f
TARGET = stest
SRC = $(wildcard *.c)
OBJ = $(SRC:=.o)

all: build

build: $(TARGET)

%.c.o : %.c
	$(CC) $(CFLAGS) -c -o $@ $<

$(TARGET): $(OBJ)
	$(LD) $(LDFLAGS) -o $@ $^

clean:
	$(RM) $(OBJ) $(TARGET)

.PHONY: all build clean
