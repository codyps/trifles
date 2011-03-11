TRASH =  $(TARGET).pdf \
	 $(TARGET).dvi \
	 $(TARGET).aux \
	 $(TARGET).log

TARGET = lab
SRC = p1.spice \
      p2.spice \
      p3.spice \
      p4.spice \
      p5.spice \
      p6.spice

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

%.pdf : %.tex $(PLOTS)
	pdflatex -interaction=nonstopmode $<
	pdflatex -interaction=nonstopmode $<
