
#include <iostream>
#include <thread>
#include <atomic>

using namespace std;


static atomic_bool z(0);

struct OneOnExit {
	atomic_bool &a_;
	OneOnExit(atomic_bool &a)
		: a_(a)
	{}

	~OneOnExit() {
		a_.store(1);
		this_thread::sleep_for(chrono::seconds(1));
	}
} one_on_exit(z);

static void do_it() {
	for (;;) {
		if (z.load() == 0)
			continue;
		std::cout << "OH NO" << std::endl;
	}
}

int main(void) {
	std::thread t(do_it);
	t.detach();
	return 0;
}
