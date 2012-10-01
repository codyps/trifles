obj-m += hello.o
obj-m += debugfs-test.o

KDIR := /lib/modules/$(shell uname -r)/build
ifndef NODEBUG
KCPPFLAGS := -DDEBUG
endif

all:
	make -C $(KDIR) M=$(PWD) modules KCPPFLAGS=$(KCPPFLAGS)

clean:
	make -C $(KDIR) M=$(PWD) clean
