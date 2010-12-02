
RM=rm -f

CFLAGS += -ggdb
override CFLAGS+= -Wall -pipe -lX11 -I/usr/include/X11

.PHONY: all
all: build
	
.PHONY: build
build: $(BIN)

.PHONY: clean
clean:
	$(RM) $(BIN)

$(BIN): $(SRC)
	$(CC) $(CFLAGS) -o $@ --combine $<

