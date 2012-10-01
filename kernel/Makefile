obj-m += hello.o
obj-m += debugfs-test.o

KDIR := /lib/modules/$(shell uname -r)/build
ifdef DEBUG
KCPPFLAGS := DEBUG
endif

all:
	make -C $(KDIR) M=$(PWD) modules KCPPFLAGS=$(KCPPFLAGS)

clean:
	make -C $(KDIR) M=$(PWD) clean
