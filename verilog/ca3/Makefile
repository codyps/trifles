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

VFLAGS= -Wall -Wimplicit -Wportbind -Wsensitivity-entire-vector \
	-Wsensitivity-entire-array

%.v.out : %.v
	$(VERILOG) $(VFLAGS) -o $@ $<

.PHONY: test
test: $(SRC:=.test)

.PHONY: %.v.test
%.v.test : %.v.out
	./$<


