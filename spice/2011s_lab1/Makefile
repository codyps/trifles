TRASH =  $(TARGET).pdf \
	 $(TARGET).dvi \
	 $(TARGET).aux \
	 $(TARGET).log

TARGET = doc
SRC =	a1_1_d_0_10.spice.gen		\
	a1_2_d_-10_10.spice.gen		\
	a1_3_d_-10_0.spice.gen		\
	a1_4_1n4001_0_10.spice.gen	\
	a1_5_1n4001_-10_10.spice.gen	\
	a1_6_1n4001_-10_0.spice.gen	\
	a1_7_6a05_0_10.spice.gen	\
	a1_8_6a05_-10_10.spice.gen	\
	a1_9_6a05_-10_0.spice.gen

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
	$(RM) *.gen *.eps *.out *.dvi *.pdf $(TRASH)

%.pdf : %.dvi
	dvipdf $< $@

%.dvi : %.tex $(PLOTS)
	latex -interaction=nonstopmode $<
	latex -interaction=nonstopmode $<
