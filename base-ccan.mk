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

$(call sub-make ccan/config.h)
$(call sub-make ccan/libccan.a)
.PHONY: ccan/clean
$(call sub-make ccan/clean)


.PHONY: dirclean
dirclean : clean ccan.clean
