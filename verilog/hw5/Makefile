SRC = $(wildcard *.v)

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


proper: |clean
	$(RM) *.vcd

#mrproper: |proper
#	$(RM) *.png

%.v.out : %.v
	$(VERILOG) -D__FILE__=$^ -Wall -o $@ $<

.PHONY: test
test: $(SRC:=.test)

.PHONY: %.v.test
%.v.test : %.v.out
	./$<


