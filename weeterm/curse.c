#include <curses.h>
#include <unistd.h>

int main(int argc, char **argv)
{
	WINDOW *w = initscr();
	// raw();
	cbreak();
	noecho();
	keypad(stdscr, TRUE);

	int ct;
	int x, y;
	getmaxyx(w, y, x);
	for(ct = 0;;) {
		move(y-1,ct);
		refresh();
		int c = 'a'; //wgetch(w);
		if (c < 0)
			continue;
		if (c == '\n') {
			ct = 0;
			continue;
		}
		sleep(1);
		ct ++;
	}

	int ret = endwin();
	return ret;
}
