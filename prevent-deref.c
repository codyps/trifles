struct X {
	int x;
	struct Y y;
};

int foo(struct X *y)
{
	struct X x = *y;
	return x.x;
}
