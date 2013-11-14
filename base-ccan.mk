CCAN_CFLAGS ?= $(C_CFLAGS)

ifeq ($(findstring clang,$(CC)),)
CCAN_LD ?= ld
else
CCAN_LD ?= llvm-link
endif

ccan: FORCE
	$(MAKE) $(MAKE_ENV) CCAN_CFLAGS="$(CCAN_CFLAGS)" CCAN_LDFLAGS="$(CCAN_LDFLAGS)" \
		LD="$(CCAN_LD)" --no-print-directory -C ccan $(MAKEFLAGS)
dirclean: clean
	$(MAKE) $(MAKE_ENV) --no-print-directory -C ccan $(MAKEFLAGS) clean

