TRASH =  $(TARGET).pdf \
	 $(TARGET).dvi \
	 $(TARGET).aux \
	 $(TARGET).log

TARGET = lab
SRC = 	a2_01_TIM31_1.spice.gen \
	a2_02_TIM31_2.spice.gen	\
	a2_03_TIM31_2.spice.gen	\
	a2_04_TIM31_2.spice.gen	\
	a2_05_TIM31_3.spice.gen	\
	a2_06_TIM31_3.spice.gen	\
	a2_07_TIM31_3.spice.gen	\
	a2_08_TIM31_4.spice.gen	\
	a2_09_2n3904_1.spice.gen	\
	a2_10_2n3904_2.spice.gen	\
	a2_11_2n3904_2.spice.gen	\
	a2_12_2n3904_2.spice.gen	\
	a2_13_2n3904_3.spice.gen	\
	a2_14_2n3904_3.spice.gen	\
	a2_15_2n3904_3.spice.gen	\
	a2_16_2n3904_4.spice.gen

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
