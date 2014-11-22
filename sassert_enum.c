#define static_assert(a, b) _Static_assert(a, b)
#define SA(a) static_assert(a, #a)

enum {
	F = 1,
	B = F + 1,
	SA(F > B)
};

SA(F > B);

int main(void)
{
	return 0;
}
