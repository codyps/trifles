typedef int (*bar_t)();

int bar(void) {
	return 42;
}

bar_t foo(void) {
	return bar;
}
