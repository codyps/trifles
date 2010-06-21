CC = gcc
LD = gcc
RM = rm -f
SRC = rwt.c ben.c
OBJ = $(SRC:=.o)
rwt : $(OBJ)
	$(LD) -o $@ $^

%.c.o : %.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean :
	$(RM) rwt $(OBJ)
