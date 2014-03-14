

const int *a; // the thing pointed to is const
const int b;  // @b is const
int *const c; // @c is const
const int *const d; // both @d and the thing pointed too are const

int main(void)
{
	a = 0;
	b = 0;
	c = 0;
	d = 0;
}
