# Usage:
#
# == For use by the one who runs 'make' ==
# $(V)              when defined, prints the commands that are run.
# $(CFLAGS)         expected to be overridden by the user or build system.
# $(LDFLAGS)        same as CFLAGS, except for LD.
#
# == Required in the makefile ==
# all::		    place this target at the top.
# $(obj-sometarget) the list of objects (generated by CC) that make up a target
#                   (in the list TARGET).
# $(TARGETS)        a list of binaries (the output of LD).
#
# == Optional (for use in the makefile) ==
# $(NO_INSTALL)     when defined, no install target is emitted.
# $(ALL_CFLAGS)     non-overriden flags. Append (+=) things that are absolutely
#                   required for the build to work into this.
# $(ALL_LDFLAGS)    same as ALL_CFLAGS, except for LD.
#		    example for adding some library:
#
#			sometarget: ALL_LDFLAGS += -lrt
#
# $(CROSS_COMPILE)  a prefix on gcc. "CROSS_COMPILE=arm-linux-" (note the trailing '-')

# TODO:
# - install disable per target.
# - flag tracking per target.'.obj.o.cmd'
# - flag tracking that easily allows adding extra variables.
# - profile guided optimization support.
# - build with different flags placed into different output directories.

.PHONY: all
all:: $(TARGETS)

CC = $(CROSS_COMPILE)gcc
LD = $(CC)
RM = rm -f

ifdef DEBUG
OPT=-O0
else
OPT=-Os
endif

ifndef NO_LTO
CFLAGS  ?= -flto
LDFLAGS ?= $(ALL_CFLAGS) $(OPT) -fwhole-program
else
CFLAGS ?= $(OPT)
endif

CFLAGS += -ggdb

ALL_CFLAGS  += --std=gnu99 -Wall $(CFLAGS)
ALL_LDFLAGS += $(LDFLAGS)

ifndef V
	QUIET_CC   = @ echo '   CC  ' $@;
	QUIET_LINK = @ echo '   LINK' $@;
	QUIET_LSS  = @ echo '   LSS ' $@;
	QUIET_SYM  = @ echo '   SYM ' $@;
endif

.SECONDARY:
.PHONY: FORCE

### Detect prefix changes
## Use "#')" to hack around vim highlighting.
TRACK_CFLAGS = $(CC):$(subst ','\'',$(ALL_CFLAGS)) #')
.TRACK-CFLAGS: FORCE
	@FLAGS='$(TRACK_CFLAGS)'; \
	if test x"$$FLAGS" != x"`cat .TRACK-CFLAGS 2>/dev/null`" ; then \
		echo 1>&2 "    * new build flags or prefix"; \
		echo "$$FLAGS" >.TRACK-CFLAGS; \
	fi

TRACK_LDFLAGS = $(LD):$(subst ','\'',$(ALL_LDFLAGS)) #')
.TRACK-LDFLAGS: FORCE
	@FLAGS='$(TRACK_LDFLAGS)'; \
	if test x"$$FLAGS" != x"`cat .TRACK-LDFLAGS 2>/dev/null`" ; then \
		echo 1>&2 "    * new link flags"; \
		echo "$$FLAGS" >.TRACK-LDFLAGS; \
	fi

%.o .%.o.d: %.c .TRACK-CFLAGS
	$(QUIET_CC)$(CC) -MMD -MF .$@.d -c -o $@ $< $(ALL_CFLAGS)

.SECONDEXPANSION:
$(TARGETS) : .TRACK-LDFLAGS $$(obj-$$@)
	$(QUIET_LINK)$(LD) -o $@ $(filter-out .TRACK-CFLAGS,$(filter-out .TRACK-LDFLAGS,$^)) $(ALL_LDFLAGS)

ifdef NO_INSTALL
.PHONY: install %.install
%.install: %
	install $* $(DESTDIR)/bin/$*
install: $(foreach target,$(TARGETS),$(target).install)
endif

.PHONY: clean %.clean
%.clean :
	$(RM) $(obj-$*) $* $(TRASH) .TRACK-CFLAGS .TRACK-LDFLAGS $(patsubst %.o,.%.o.d,$(obj-$*))

clean:	$(foreach target,$(TARGETS),$(target).clean)

-include $(patsubst %.o,.%.o.d,$(foreach target,$(TARGETS),$(obj-$target)))
