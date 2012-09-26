all::

ifndef DESTDIR
DESTDIR=./bin
endif

obj-gkr-decrypt = gkr-decrypt.o
gkr-decrypt: $(obj-gkr-decrypt)

obj-hd = hd.o
hd : $(obj-hd)

obj-lsalsa = hw_params.o
lsalsa : $(obj-lsalsa)
lsalsa : ALL_LDFLAGS += -lasound

obj-test-pm-timer = pm_timer.o
test-pm-timer : $(obj-test-pm-timer)

TARGETS = hd gkr-decrypt lsalsa test-pm-timer

.PHONY: all
all:: $(TARGETS)

CC = gcc
LD = $(CC)
RM = rm -f

CFLAGS ?= -ggdb -O0
ALL_CFLAGS  += --std=gnu99 -Wall $(CLFAGS)
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
	$(QUIET_CC)$(CC) $(ALL_CFLAGS) -c -o $@ $<

$(TARGETS) : .TRACK-LDFLAGS
	$(QUIET_LINK)$(LD) $(ALL_LDFLAGS) -o $@ $(filter-out .TRACK-CFLAGS,$(filter-out .TRACK-LDFLAGS,$^))

.PHONY: install %.install
%.install: %
	install $* $(DESTDIR)/$*
install: $(foreach target,$(TARGETS),$(target).install)


.PHONY: clean %.clean
TRASH = .TRACK-CFLAGS .TRACK-LDFLAGS
%.clean :
	$(RM) $(obj-$*) $* $(TRASH)

clean:	$(foreach target,$(TARGETS),$(target).clean)

