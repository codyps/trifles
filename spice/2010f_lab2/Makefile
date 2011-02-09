

SRC=$(wildcard *.spice)
OBJ=$(SRC:=.txt)

.PHONY:all
all: $(OBJ)

.PHONY:clean
clean:
	$(RM) $(OBJ)

.PHONY:rebuild
rebuild: | clean
	$(MAKE) $(MAKEFLAGS) all


%.txt: % Makefile
	ngspice -b $< 2>/dev/null | grep -A3 '^Transfer' > $@


