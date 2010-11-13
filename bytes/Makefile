SRC = ifibin_to_ihex.c

CC = gcc
RM = rm -f

CFLAGS = -ggdb
override CFLAGS+= -Wall -pipe

BIN = ibin2ihex

.PHONY: all
all: build

.PHONY: build
build: $(BIN)

.PHONY: rebuild
rebuild: | clean $(BIN)

.PHONY: clean
clean:
	$(RM) $(BIN) $(wildcard rsock-g*.tar)

$(BIN): $(SRC)
	$(CC) $(CFLAGS) -o $@ $^

VER:=$(shell git rev-parse --verify --short HEAD 2>/dev/null)
TAR_NAME=$(BIN)-g$(VER)
.PHONY: archive
archive:
	git archive --prefix='$(TAR_NAME)/' HEAD > $(TAR_NAME).tar

