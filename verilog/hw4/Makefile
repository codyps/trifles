SRC = p15.v

OBJ = $(SRC:=.out)

VERILOG = iverilog
RM = rm -f

.SUFFIXES:
.PHONY: all clean build rebuild

all: build

build: $(OBJ)

rebuild: | clean build

clean:
	$(RM) $(OBJ) *.vcd

%.v.out : %.v
	$(VERILOG) -D__FILE__=$^ -o $@ $<

.PHONY: test
test: $(SRC:=.test)

.PHONY: %.v.test
%.v.test : %.v.out
	./$<


