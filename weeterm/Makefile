TARGET = weeterm

SRC = $(wildcard *.c)

CFLAGS = -ggdb -pipe
override CFLAGS += -Wall
LDFLAGS = 
override LDFLAGS += -lcurses

CC = gcc
LD = gcc
RM = rm -f

.SUFFIXES:
.SUFFIXES: .c .o

.PHONY: all
all: build

.PHONY: build
build: $(TARGET)

.PHONY: clean
clean:
	$(RM) $(TARGET)

$(TARGET) : $(SRC)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^
