
ccan: FORCE
	$(MAKE) $(MAKE_ENV) LD="ld" --no-print-directory -C ccan $(MAKEFLAGS)
dirclean: clean
	$(MAKE) $(MAKE_ENV) --no-print-directory -C ccan $(MAKEFLAGS) clean

