TRASH =  $(TARGET).pdf \
	 $(TARGET).dvi \
	 $(TARGET).aux \
	 $(TARGET).log

TARGET = 1
SRC =	a1_1_dn914_0_10.spice.gen		\
	a1_2_dn914_-10_10.spice.gen		\
	a1_3_dn914_-10_0.spice.gen		\
	a1_4_dn4001_0_10.spice.gen	\
	a1_5_dn4001_-10_10.spice.gen	\
	a1_6_dn4001_-10_0.spice.gen	\
	a1_7_d6a05_0_10.spice.gen	\
	a1_8_d6a05_-10_10.spice.gen	\
	a1_9_d6a05_-10_0.spice.gen

PLOTS=$(SRC:.spice.gen=.eps)


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

%.pdf : %.dvi
	dvipdf $< $@

%.dvi : %.tex $(PLOTS) prelab.tex
	latex -interaction=nonstopmode $<
	latex -interaction=nonstopmode $<
