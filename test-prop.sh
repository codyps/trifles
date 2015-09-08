#! /bin/sh

cd "$(dirname "$0")"

gdbus-codegen --c-namespace=login1 --generate-c-code=login1 --interface-prefix=org.freedesktop.login1 login1.xml

: ${CC:=gcc}
: ${CFLAGS:=-Wall -Wextra -O2 -Wno-unused-parameter}

$CC $CFLAGS $(pkg-config --libs --cflags glib-2.0 gio-2.0 gio-unix-2.0) \
	-o test-prop test-prop-glib.c login1.c
