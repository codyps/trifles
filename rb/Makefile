TARGET = rb

CSOURCE= $(wildcard *.c)
HEADER = $(wildcard *.h)

OBJECTS= $(CSOURCE:=.o)

ALL_CFLAGS = -Wall $(CFLAGS)
ALL_LDFLAGS = $(ALL_CFLAGS) 

CC = gcc
LD = gcc
RM = rm -f

.SUFFIXES:
.SUFFIXES: .c .o

all: $(TARGET)

$(TARGET) : $(OBJECTS)
	$(LD) $(ALL_LDFLAGS) -o $@ $^

clean:
	$(RM) $(TARGET) $(OBJECTS)

%.c.o : %.c $(HEADER)
	$(CC) $(ALL_CFLAGS) -o $@ -c $<



.PHONY: all clean
