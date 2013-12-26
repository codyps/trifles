CCAN_CFLAGS ?= $(C_CFLAGS)
# Blah, fix LDFLAGS

ifndef BASE_MK_MANUAL_CCAN
$(obj-all) : ccan
ALL_CPPFLAGS += -Iccan
ALL_LDFLAGS  += -Lccan -lccan
endif

.PHONY: ccan
ccan: FORCE
	$(MAKE) $(MAKE_ENV) CCAN_CFLAGS="$(CCAN_CFLAGS)" CCAN_LDFLAGS="$(CCAN_LDFLAGS)" --no-print-directory -C ccan $(MAKEFLAGS)

.PHONY: dirclean
dirclean: clean
	$(MAKE) $(MAKE_ENV) --no-print-directory -C ccan $(MAKEFLAGS) clean

