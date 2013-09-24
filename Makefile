all::

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

obj-lsalsa = hw_params.o
ldflags-lsalsa = -lasound

obj-test-pm-timer = pm_timer.o
obj-debugfs-test = debugfs_test.o
obj-modll = mod_ll.o

obj-parse-datetime = parse-datetime.o
parse-datetime.o: ALL_CFLAGS += -DTEST
parse-datetime : $(obj-parse-datetime)

TARGETS = hd gkr-decrypt lsalsa test-pm-timer debugfs-test utime test-dep modll pipe unix-test set-qf-union set-qu-union set-to-dot dripper

include base.mk
