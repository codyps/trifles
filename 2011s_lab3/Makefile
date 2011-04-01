TRASH =  $(TARGET).pdf \
	 $(TARGET).dvi \
	 $(TARGET).aux \
	 $(TARGET).log

TARGET = lab
SRC = a1_p1.spice \
      a1_p2.spice


PLOTS=$(SRC:.spice=.eps)
RM=rm -f

.SECONDARY:
.PHONY: all
all: $(TARGET).pdf ;

%.eps: %.spice
	-ngspice -b $< -o $@.out

.PHONY: clean
clean:
	$(RM) *.gen *.eps *.out *.dvi *.pdf *.aux $(TRASH)

%.pdf : %.dvi
	dvipdf $< $@

%.dvi : %.tex
	latex -interaction=nonstopmode $<
	latex -interaction=nonstopmode $<
