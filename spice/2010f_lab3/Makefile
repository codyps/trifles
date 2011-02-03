

SRC=$(wildcard *.spice)
OBJ=$(SRC:=.out)

.PHONY:all
all: $(OBJ)

.PHONY:clean
clean:
	$(RM) $(OBJ)

%.out: % Makefile
	ngspice < $< > $@


