TARGET = wordstat

CSOURCE= $(wildcard *.c)
HEADER = $(wildcard *.h)

OBJECTS= $(CSOURCE:=.o)
TRASH  = gmon.out

ALL_CFLAGS = -ansi -pedantic -Wall $(CFLAGS)

CC = gcc
LD = gcc
RM = rm -f

.SUFFIXES:
.SUFFIXES: .c .o

all: $(TARGET)

$(TARGET) : $(OBJECTS)
	$(LD) $(ALL_CFLAGS) -o $@ $^

clean:
	$(RM) $(TARGET) $(OBJECTS) $(TRASH)

%.c.o : %.c $(HEADER)
	$(CC) $(ALL_CFLAGS) -c -o $@ $<

.PHONY: all clean
