all::

DESTDIR?=$(HOME)

obj-utime = utime.o
obj-gkr-decrypt = gkr-decrypt.o
obj-hd = hd.o
obj-lsalsa = hw_params.o
lsalsa : ALL_LDFLAGS += -lasound
obj-test-pm-timer = pm_timer.o
obj-debugfs-test = debugfs_test.o

obj-parse-datetime = parse-datetime.o
parse-datetime.o: ALL_CFLAGS += -DTEST
parse-datetime : $(obj-parse-datetime)

TARGETS = hd gkr-decrypt lsalsa test-pm-timer debugfs-test utime

include base.mk
