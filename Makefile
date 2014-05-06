all::

obj-usbreset = usbreset.o
obj-hub-ctrl = hub-ctrl.o
ldflags-hub-ctrl := $(shell pkg-config --libs libusb 2>/dev/null)
cflags-hub-ctrl  := $(shell pkg-config --cflags libusb 2>/dev/null)

obj-test-netlink = test-netlink.o
obj-set-qf-union = set_qf_union.o
obj-set-qu-union = set_qu_union.o
obj-set-to-dot = id_array_to_dot.o
obj-unix-test = test_unix_recvfrom.o
obj-pipe = pipe.o
obj-test-dep = test-dep.o
obj-utime = utime.o
obj-gkr-decrypt = gkr-decrypt.o
obj-hd = hd.o
obj-dripper = Dripper.o
obj-test-type-info = test_type.o
obj-static-array = static_array.o
obj-oops2line = oops2line.o
obj-interp-kmesg = interp-kmesg.o

obj-lsalsa = hw_params.o
ldflags-lsalsa = -lasound

obj-test-pm-timer = pm_timer.o
obj-debugfs-test = debugfs_test.o
obj-modll = mod_ll.o

obj-uinput = uinput.o

parse-datetime.o: ALL_CFLAGS += -DTEST
obj-parse-datetime = parse-datetime.o

ALL_CFLAGS += -I.

TARGETS = hd gkr-decrypt lsalsa test-pm-timer debugfs-test utime test-dep modll pipe unix-test set-qf-union set-qu-union set-to-dot dripper test-netlink usbreset hub-ctrl test-type-info uinput static-array oops2line interp-kmesg

include base.mk
