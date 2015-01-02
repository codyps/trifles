all::

obj-usbreset = usbreset.c.o
obj-hub-ctrl = hub-ctrl.c.o
ldflags-hub-ctrl := $(shell pkg-config --libs libusb 2>/dev/null)
cflags-hub-ctrl  := $(shell pkg-config --cflags libusb 2>/dev/null)

obj-test-netlink = test-netlink.c.o
obj-set-qf-union = set_qf_union.c.o
obj-set-qu-union = set_qu_union.c.o
obj-set-to-dot = id_array_to_dot.c.o
obj-unix-test = test_unix_recvfrom.c.o
obj-pipe = pipe.c.o
obj-test-dep = test-dep.c.o
obj-utime = utime.c.o
obj-gkr-decrypt = gkr-decrypt.c.o
obj-hd = hd.c.o
obj-dripper = Dripper.c.o
obj-test-type-info = test_type.c.o
obj-static-array = static_array.c.o
obj-oops2line = oops2line.c.o
obj-interp-kmesg = interp-kmesg.c.o

obj-lsalsa = hw_params.c.o
ldflags-lsalsa = -lasound

obj-test-pm-timer = pm_timer.c.o
obj-debugfs-test = debugfs_test.c.o
obj-modll = mod_ll.c.o

obj-uinput = uinput.c.o
obj-comp_mask = comp_mask.c.o

parse-datetime.c.o: ALL_CFLAGS += -DTEST
obj-parse-datetime = parse-datetime.c.o

ALL_CFLAGS += -I.

TARGET_BIN = hd gkr-decrypt lsalsa test-pm-timer debugfs-test utime test-dep modll pipe unix-test set-qf-union set-qu-union set-to-dot dripper test-netlink usbreset hub-ctrl test-type-info uinput static-array oops2line interp-kmesg comp_mask

include base.mk
include base-ccan.mk
