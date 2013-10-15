
ccan: FORCE
	@$(MAKE) $(MAKEFLAGS) $(MAKE_ENV) LD="ld" --no-print-directory -C ccan
dirclean: clean
	@$(MAKE) $(MAKEFLAGS) $(MAKE_ENV) --no-print-directory -C ccan clean

