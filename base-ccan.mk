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

$(eval $(call sub-make,ccan/config.h))
$(eval $(call sub-make,ccan/libccan.a))
.PHONY: ccan/clean
$(eval $(call sub-make,ccan/clean))

.PHONY: dirclean
dirclean : clean ccan/clean
