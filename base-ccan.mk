CCAN_CFLAGS ?= $(ALL_CFLAGS)
# Blah, fix LDFLAGS

ifndef BASE_MK_MANUAL_CCAN
$(obj-all) : ccan/config.h
$(TARGETS) : ccan/libccan.a
ALL_CPPFLAGS += -Iccan
ALL_LDFLAGS  += -Lccan -lccan
endif


export CCAN_CFLAGS
export CCAN_LDFLAGS

$(eval $(call sub-make-no-clean,ccan/config.h))
$(eval $(call sub-make-no-clean,ccan/libccan.a))
.PHONY: ccan/clean
$(eval $(call sub-make-no-clean,ccan/clean))

.PHONY: dirclean
dirclean : clean ccan/clean
