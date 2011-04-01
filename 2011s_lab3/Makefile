TRASH =  $(TARGET).pdf \
	 $(TARGET).dvi \
	 $(TARGET).aux \
	 $(TARGET).log

TARGET = lab
SIM_SRC = a1_p1.spice \
          a1_p2.spice
PLT_SRC = 1.plot \
	  2.plot \
	  3.plot \
	  4.plot

xOBJ =	$(SIM_SRC:.spice=.eps) \
	$(PLT_SRC:.plot=.tex)
OBJ  =  $(addprefix include/, $(xOBJ))
RM = rm -f

.SECONDARY:
.PHONY: all
all: $(TARGET).pdf ;

include/%.eps : %.spice
	-ngspice -b $< -o $@.out

include/%.tex : %.plot
	gnuplot $<

.PHONY: clean
clean:
	$(RM) *.gen *.eps *.out *.dvi *.pdf *.aux $(TRASH) $(OBJ)

%.pdf : %.dvi
	dvipdf $< $@

%.dvi : %.tex $(OBJ)
	latex -interaction=nonstopmode $<
	latex -interaction=nonstopmode $<
