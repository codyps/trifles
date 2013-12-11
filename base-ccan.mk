CCAN_CFLAGS ?= $(C_CFLAGS)
CCAN_LD ?= ld

ifndef BASE_MK_MANUAL_CCAN
$(obj-all) : ccan
ALL_CPPFLAGS += -Iccan
endif

.PHONY: ccan
ccan: FORCE
	$(MAKE) $(MAKE_ENV) CCAN_CFLAGS="$(CCAN_CFLAGS)" CCAN_LDFLAGS="$(CCAN_LDFLAGS)" \
		LD="$(CCAN_LD)" --no-print-directory -C ccan $(MAKEFLAGS)

.PHONY: dirclean
dirclean: clean
	$(MAKE) $(MAKE_ENV) --no-print-directory -C ccan $(MAKEFLAGS) clean

