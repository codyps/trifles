CC = gcc
RM = rm -f

TARGETS = p1

all_SRC = 
obj = $(all_SRC:=.o)

srcdir = .
VPATH = $(srcdir)

.PHONY: all
all: build

p1 : p1.c.o

CFLAGS = -ggdb
override CFLAGS += -Wall -pipe -I$(srcdir)
LDFLAGS = -Wl,--as-needed -O2

.PHONY: rebuild
rebuild: | clean build 

.PHONY: build
build: $(TARGETS)

%.c.o : %.c
	$(CC) $(CFLAGS) -MMD -c -o $@ $<

$(TARGETS) : $(obj) |
	$(CC) $(LDFLAGS) -o $@ $^

.PHONY: clean
clean:
	$(RM) $(TARGETS) *.d *.o

-include $(wildcard *.d)
