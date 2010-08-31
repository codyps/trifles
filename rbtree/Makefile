CC     = gcc
RM     = rm -f
CFLAGS = -g -Wall -pipe

TARGET = rbtest
SRC    = $(wildcard *.c)
OBJ    = $(SRC:=.o)

all: build

rebuild : | clean build

build: $(TARGET)

%.c.o : %.c
	$(CC) $(CFLAGS) -c -o $@ $<

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^


clean:
	$(RM) $(OBJ) $(TARGET) $(wildcard *.png) $(wildcard *.dot)

test: junk.png
	gpicview $<

%.dot: $(TARGET)
	./$(TARGET) > $@

%.png : %.dot
	dot -Tpng -o $@ $<


.PHONY: all build clean test rebuild
