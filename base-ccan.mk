CCAN_CFLAGS ?= $(ALL_CFLAGS)
# Blah, fix LDFLAGS

ifndef BASE_MK_MANUAL_CCAN
$(obj-all) : ccan
ALL_CPPFLAGS += -Iccan
ALL_LDFLAGS  += -Lccan -lccan
endif

ifndef V
	QUIET_SUBMAKE  = @ echo '  MAKE ' $@;
endif

export CCAN_CFLAGS
export CCAN_LDFLAGS

.PHONY: ccan
ccan: FORCE
	$(QUIET_SUBMAKE)$(MAKE) $(MAKE_ENV) --no-print-directory -C $@ $(MAKEFLAGS)

.PHONY: ccan.clean
ccan.clean :
	$(QUIET_SUBMAKE)$(MAKE) --no-print-directory -C $(@:.clean=) $(MAKEFLAGS) clean

.PHONY: dirclean
dirclean : clean ccan.clean
