TRASH =  $(TARGET).pdf \
	 $(TARGET).dvi \
	 $(TARGET).aux \
	 $(TARGET).log

TARGET = lab
RM=rm -f

.SECONDARY:
.PHONY: all
all: $(TARGET).pdf

%.out %.eps: %.spice
	-ngspice -b $< -o $@.out

.PHONY: clean
clean:
	$(RM) *.gen *.eps *.out *.dvi *.pdf *.aux $(TRASH)

%.pdf : %.dvi
	dvipdf $< $@

%.dvi : %.tex
	latex -interaction=nonstopmode $<
	latex -interaction=nonstopmode $<
