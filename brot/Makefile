SUB_PROJ=openmp.mk mpi_static.mk mpi_dyn.mk mpi_dyn_omp.mk

.PHONY: all
all: build
	
.PHONY: build
build: $(SUB_PROJ:=.build)

.PHONY: %.build
%.build: %
	$(MAKE) -f $^ build

.PHONY: rebuild
rebuild: | clean build

.PHONY: clean
clean: $(SUB_PROJ:=.clean)

.PHONY: %.clean
%.clean: %
	$(MAKE) -f $^ clean

.PHONY: archive
VER:=$(shell git rev-parse --verify --short HEAD 2>/dev/null)
archive:
	git archive --prefix='rsock-g$(VER)/' HEAD > rsock-g$(VER).tar

