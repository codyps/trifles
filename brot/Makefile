.PHONY: all
all: build
	
.PHONY: build
build:
	$(MAKE) -f openmp.mk $@

.PHONY: rebuild
rebuild: | clean build

.PHONY: clean
clean:
	$(MAKE) -f openmp.mk $@

.PHONY: archive
VER:=$(shell git rev-parse --verify --short HEAD 2>/dev/null)
archive:
	git archive --prefix='rsock-g$(VER)/' HEAD > rsock-g$(VER).tar

