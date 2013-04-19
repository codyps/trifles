all::

obj-pipe = pipe.o
obj-test-dep = test-dep.o
obj-utime = utime.o
obj-gkr-decrypt = gkr-decrypt.o
obj-hd = hd.o

obj-lsalsa = hw_params.o
ldflags-lsalsa = -lasound

obj-test-pm-timer = pm_timer.o
obj-debugfs-test = debugfs_test.o
obj-modll = mod_ll.o

obj-parse-datetime = parse-datetime.o
parse-datetime.o: ALL_CFLAGS += -DTEST
parse-datetime : $(obj-parse-datetime)

TARGETS = hd gkr-decrypt lsalsa test-pm-timer debugfs-test utime test-dep modll pipe

include base.mk

.PHONY: install-dnuma
install-dnuma:
	mkdir -p $(BINDIR) &&	\
	cp debugfs-test   $(BINDIR)/dnuma &&	\
	cp bin/dnuma-test $(BINDIR)/dnuma-test
