

SRC=$(wildcard *.spice)
OBJ=$(SRC:=.txt)

.PHONY:all
all: $(OBJ)

.PHONY:clean
clean:
	$(RM) $(OBJ)

%.txt: % Makefile
	ngspice -b $< | grep -A3 '^Transfer' > $@


