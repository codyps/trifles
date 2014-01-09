CCAN_CFLAGS ?= $(C_CFLAGS)
# Blah, fix LDFLAGS

ifndef BASE_MK_MANUAL_CCAN
$(obj-all) : ccan
ALL_CPPFLAGS += -Iccan
ALL_LDFLAGS  += -Lccan -lccan
endif

ifndef V
	QUIET_SUBMAKE  = @ echo '  MAKE ' $@;
endif

.PHONY: ccan
ccan: FORCE
	$(QUIET_SUBMAKE)$(MAKE) $(MAKE_ENV) CCAN_CFLAGS="$(CCAN_CFLAGS)" CCAN_LDFLAGS="$(CCAN_LDFLAGS)" --no-print-directory -C $@ $(MAKEFLAGS)

.PHONY: ccan.clean
ccan.clean :
	$(QUIET_SUBMAKE)$(MAKE) --no-print-directory -C $(@:.clean=) $(MAKEFLAGS) clean

.PHONY: dirclean
dirclean : clean ccan.clean
