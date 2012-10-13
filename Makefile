all::

DESTDIR?=$(HOME)

obj-gkr-decrypt = gkr-decrypt.o
obj-hd = hd.o
obj-lsalsa = hw_params.o
lsalsa : ALL_LDFLAGS += -lasound
obj-test-pm-timer = pm_timer.o
obj-debugfs-test = debugfs_test.o

obj-parse-datetime = parse-datetime.o
parse-datetime.o: ALL_CFLAGS += -DTEST
parse-datetime : $(obj-parse-datetime)

TARGETS = hd gkr-decrypt lsalsa test-pm-timer debugfs-test

.PHONY: all
all:: $(TARGETS)

CC = $(CROSS_COMPILE)gcc
LD = $(CC)
RM = rm -f

CFLAGS ?= -ggdb -O0
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

TRACK_LDFLAGS = $(LINK):$(subst ','\'',$(ALL_LDFLAGS)) #')
.TRACK-LDFLAGS: FORCE
	@FLAGS='$(TRACK_LDFLAGS)'; \
	if test x"$$FLAGS" != x"`cat .TRACK-LDFLAGS 2>/dev/null`" ; then \
		echo 1>&2 "    * new link flags"; \
		echo "$$FLAGS" >.TRACK-LDFLAGS; \
	fi

%.o: %.c .TRACK-CFLAGS
	$(QUIET_CC)$(CC) -c -o $@ $< $(ALL_CFLAGS)

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
	$(RM) $(obj-$*) $* $(TRASH) .TRACK-CFLAGS .TRACK-LDFLAGS

clean:	$(foreach target,$(TARGETS),$(target).clean)

