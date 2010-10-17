SRC = p1.v p7.v p7b.v p15.v \
      p11_12_test_half_adder.v \
      p11_12_test_full_adder.v \
      p11_12_test_4bit_adder.v \
      p11_12_test_16bit_adder.v

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


