#include <curses.h>
#include <ctype.h>
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
		wmove(w, my-1, ct);
		wrefresh(w);
		int c = wgetch(w);

		switch(c) {
		case KEY_BACKSPACE:
			if (ct > 0) {
				ct --;
				wmove(w, my-1, ct);
				waddch(w, ' ');
			}
			break;
		case KEY_ENTER:
		case '\n':
			ct = 0;
			/* XXX: remove line */
			break;
		default:
			if (isascii(c)) {
				waddch(w, c);
				ct++;
			}
		}
	}

	int ret = endwin();
	return ret;
}
