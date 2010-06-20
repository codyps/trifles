CC=gcc
LD=gcc
RM=rm -f
rwt : rwt.o
	$(LD) -o $@ $<

%.o : %.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean :
	$(RM) rwt rwt.o
