CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)gcc
RM = rm -f

MAKEFLAGS += -Rr --no-print-directory

ifndef V
	QUIET_CC = @ echo '    ' CC $@;
	QUIET_LD = @ echo '    ' LD $@;
endif

.PHONY: all
all: build

TARGETS = p1 p2
p1: p1.c.o
p2: p2.c.o
p2.c.o : config.h

srcdir = .
VPATH = $(srcdir)

CFLAGS           += -ggdb
override CFLAGS  += -Wall -Wextra -Werror -pipe
LDFLAGS          += -Wl,--as-needed -O2
override LDFLAGS +=

.PHONY: rebuild
rebuild: | clean build

.PHONY: build
build: $(TARGETS)

%.c.o : %.c
	$(QUIET_CC)$(CC) $(CFLAGS) -MMD -c -o $@ $<

$(TARGETS) :
	$(QUIET_LD)$(LD) -o $@ $^ $(LDFLAGS)

.PHONY: clean
clean:
	$(RM) $(TARGETS) *.d *.o


ID = 000000000
.PHONY: test
test: p2
	./p2 cdma256teststream.txt $(ID)

-include $(wildcard *.d)
