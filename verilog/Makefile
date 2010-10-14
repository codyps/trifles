SRC = p1.v p7.v p7b.v p11_12.v p15.v
OBJ = $(SRC:=.out)

VERILOG = iverilog
RM = rm -f

.SUFFIXES:
.PHONY: all clean build rebuild

all: build

build: $(OBJ)

rebuild: | clean build

clean:
	$(RM) $(OBJ)

%.v.out : %.v
	$(VERILOG) -o $@ $<



