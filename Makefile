CC = gcc
CCLD = gcc
RM = rm

CFLAGS=-g -O2 -Wall -Wextra
LDFLAGS=-Wl,--as-needed

gkr-decrypt : gkr-decrypt.c.o

%.c.o : %.c
	$(CC) $(CFLAGS) -c -o $@ $<

% :
	$(CCLD) $(CFLAGS) $(LDFLAGS) -o $@ $<
