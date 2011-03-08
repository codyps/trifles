#include <curses.h>
#include <unistd.h>

typedef struct chtype_vect {
	size_t str_len;
	size_t mem_len;
	chtype buf[];
} cv_t;

cv_t *sv_mk(size_t init_sz)
{
	cv_t *sv = malloc(sizeof(*cv) + init_sz);
	if (!cv)
		return 0;

	cv->str_len = 0;
	cv->mem_len = init_sz;
}

cv_t *cv_addch(cv_t *cv, const chtype i)
{
	if ((cv->str_len + 1) >= cv->mem_len) {
		
}

int main(int argc, char **argv)
{
	WINDOW *w = initscr();
	raw();
	noecho();
	keypad(stdscr, TRUE);

	int ct;
	int x, y;
	getmaxyx(w, y, x);
	printw("got x:%d, y:%d\n",x,y);
	for(ct = 0;;) {
		wmove(w,y-1,ct);
		refresh();
		int c = 'a'; //wgetch(w);
		if (c < 0)
			continue;
		if (c == '\n') {
			ct = 0;
			continue;
		}
		waddch(w,c);
		sleep(1);
		ct ++;
	}

	int ret = endwin();
	return ret;
}
