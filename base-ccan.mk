CCAN_CFLAGS ?= $(ALL_CFLAGS)
# Blah, fix LDFLAGS

ifndef BASE_MK_MANUAL_CCAN
$(obj-all) : ccan/config.h
$(TARGETS) : ccan/libccan.a
ALL_CPPFLAGS += -Iccan
ALL_LDFLAGS  += -Lccan -lccan
endif

ifndef V
	QUIET_SUBMAKE  = @ echo '  MAKE ' $@;
endif

export CCAN_CFLAGS
export CCAN_LDFLAGS

define sub-make
$1 : FORCE
	$$(QUIET_SUBMAKE)$$(MAKE) $$(MAKE_ENV) $$(MFLAGS) --no-print-directory -C $$(dir $$@) $$(notdir $$@)
endef

$(eval $(call sub-make-no-clean,ccan/config.h))
$(eval $(call sub-make-no-clean,ccan/libccan.a))
.PHONY: ccan/clean
$(eval $(call sub-make-no-clean,ccan/clean))

.PHONY: dirclean
dirclean : clean ccan/clean
