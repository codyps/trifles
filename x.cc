#include <iostream>
using namespace std;

struct X {
	X() {
		cout << "c" << endl;
	}

	~X() {
		cout << "d" << endl;
	}
};

void foo(X &&x)
{
	cout << "foo" << endl;
}

int main(void)
{
	X x;
	foo(x);
	return 0;
}

