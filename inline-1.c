inline int f(int y, ...)
{
	int f = y * y * y;
	return f;
}

int main(void)
{
	return f(1);
}
