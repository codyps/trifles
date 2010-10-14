SRC = p1.v
OBJ = $(SRC:=.out)

VERILOG = iverilog
RM = rm -f

.SUFFIXES:
.PHONY: all clean build rebuild

all: build

build: $(OBJ)

rebuild: | clean build

clean:
	$(RM) $(TARGET)

%.v.out : %.v
	$(VERILOG) -o $@ $<



