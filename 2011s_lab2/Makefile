TRASH =  $(TARGET).pdf \
	 $(TARGET).dvi \
	 $(TARGET).aux \
	 $(TARGET).log

TARGET = lab
SRC =   2n3904_1_09.spice.gen\
	2n3904_2_10.spice.gen\
	2n3904_2_11.spice.gen\
	2n3904_2_12.spice.gen\
	2n3904_3_13.spice.gen\
	2n3904_3_14.spice.gen\
	2n3904_3_15.spice.gen\
	2n3904_4_16.spice.gen\
	tip31_1_01.spice.gen\
	tip31_2_02.spice.gen\
	tip31_2_03.spice.gen\
	tip31_2_04.spice.gen\
	tip31_3_05.spice.gen\
	tip31_3_06.spice.gen\
	tip31_3_07.spice.gen\
	tip31_4_08.spice.gen
PLOTS=$(SRC:.spice.gen=.eps)
RM=rm -f

.SECONDARY:
.PHONY: all
all: $(TARGET).pdf ;

.PHONY: spice_gen
spice_gen: gen_spice2.py
	./gen_spice2.py

%.eps: %.spice.gen
	-ngspice -b $< -o $@.out

%.spice.gen: spice_gen ;

.PHONY: clean
clean:
	$(RM) *.gen *.eps *.out *.dvi *.pdf *.aux $(TRASH)

%.pdf : %.tex
	pdflatex -interaction=nonstopmode $<
	pdflatex -interaction=nonstopmode $<
