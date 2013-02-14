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
# - output directory support ("make O=blah")
# - build with different flags placed into different output directories.
# - library building (shared & static)

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
LDFLAGS ?= $(ALL_CFLAGS) $(OPT) -fuse-linker-plugin
else
CFLAGS ?= $(OPT)
endif

CFLAGS += -ggdb3

ALL_CFLAGS += -std=gnu99 -Wall
ALL_CFLAGS += -Wundef -Wshadow
ALL_CFLAGS += -Wbad-function-cast -Wcast-align
ALL_CFLAGS += -Wstrict-prototypes -Wmissing-prototypes
ALL_CFLAGS += -Wnested-externs -Wwrite-strings
ALL_CFLAGS += -Wunsafe-loop-optimizations
ALL_CFLAGS += -Wnormalized=id
ALL_CFLAGS  += -pipe $(CFLAGS)
ALL_LDFLAGS += -Wl,--build-id
ALL_LDFLAGS += $(LDFLAGS)

ifndef V
	QUIET_CC   = @ echo '   CC  ' $@;
	QUIET_LINK = @ echo '   LINK' $@;
	QUIET_LSS  = @ echo '   LSS ' $@;
	QUIET_SYM  = @ echo '   SYM ' $@;
endif

.SECONDARY:
.PHONY: FORCE

obj-to-dep = $(foreach obj,$(1),$(dir $(obj)).$(notdir $(obj)))

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

#.%.o.d %.o: %.c .TRACK-CFLAGS
%.o: %.c .TRACK-CFLAGS
	$(QUIET_CC)$(CC) -MMD -MF "$(call obj-to-dep,$@)" -c -o "$@" "$<" $(ALL_CFLAGS)

.SECONDEXPANSION:
$(TARGETS) : .TRACK-LDFLAGS $$(obj-$$@)
	$(QUIET_LINK)$(LD) -o $@ $(obj-$@) $(ALL_LDFLAGS)

ifndef NO_INSTALL
PREFIX  ?= $(HOME)   # link against things here
DESTDIR ?= $(PREFIX) # install into here
BINDIR  ?= $(DESTDIR)/bin
.PHONY: install %.install
%.install: %
	install $* $(BINDIR)/$*
install: $(foreach target,$(TARGETS),$(target).install)
endif

TRASH = .TRACK-CFLAGS .TRACK-LDFLAGS
.PHONY: clean %.clean
%.clean :
	$(RM) $(obj-$*) $* $(TRASH) $(call obj-to-dep,$(obj-$*))

clean:	$(addsuffix .clean,$(TARGETS))

ALL_OBJ = $(foreach target,$(TARGETS),$(obj-$(target)))
deps = $(call obj-to-dep,$(ALL_OBJ))
-include $(deps)