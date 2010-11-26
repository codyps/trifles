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
	int mx, my;
	getmaxyx(w, my, mx);
	for(ct = 0;;) {
		wmove(w, my-1,ct);
		wrefresh(w);
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
