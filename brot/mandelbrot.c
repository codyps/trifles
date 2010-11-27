/* Sequential Mandelbrot program */

#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xos.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <time.h>

#define		X_RESN	400	/* x resolution */
#define		Y_RESN	400	/* y resolution */

typedef struct complextype {
	float real, imag;
} Compl;

int timespec_subtract (result, x, y)
	struct timespec *result, *x, *y;
{
	if (y->tv_nsec < x->tv_nsec) {
		result->tv_sec = y->tv_sec - x->tv_sec - 1;
		result->tv_nsec = 1000000000 + y->tv_nsec - x->tv_nsec;
	} else {
		result->tv_nsec = y->tv_nsec - x->tv_nsec;
		result->tv_sec = y->tv_sec - x->tv_sec;
	}

	if (y->tv_sec > x->tv_sec)
		return 1;
	else
		return 0;
}

typedef struct drawing_board {
	Window win;
	Display *display;
	int screen;
	GC gc;

	Pixmap main_map;
	int m_sz_x;
	int m_sz_y;
} db_t;

db_t *draw_init(size_t sz_x, size_t sz_y)
{
	db_t *d = malloc(sizeof(*d));
	if (!d)
		return NULL;

	/* connect to Xserver */
	if ((d->display = XOpenDisplay(NULL)) == NULL) {
		fprintf(stderr, "drawon: cannot connect to X server %s\n",
			XDisplayName(NULL));
		exit(-1);
	}

	d->screen = DefaultScreen(d->display);

	/* get screen size */

	//int display_width = DisplayWidth(d->display, d->screen);
	//int display_height = DisplayHeight(d->display, d->screen);

	/* create window */
	int x = 0, y = 0; /* position */
	int border_width = 4;
	d->win = XCreateSimpleWindow(d->display,
			          RootWindow(d->display, d->screen),
				  x, y, sz_x, sz_y, border_width,
				  BlackPixel(d->display, d->screen),
				  WhitePixel(d->display, d->screen));

	XSizeHints size_hints;
	size_hints.flags = USPosition | USSize;
	size_hints.x = x;
	size_hints.y = y;
	size_hints.width = sz_x;
	size_hints.height = sz_y;
	size_hints.min_width = 300;
	size_hints.min_height = 300;

	char *window_name = "Mandelbrot Set";
	XSetNormalHints(d->display, d->win, &size_hints);
	XStoreName(d->display, d->win, window_name);

	/* set up main gc */
	XGCValues values;
	unsigned long valuemask = 0;
	d->gc = XCreateGC(d->display, d->win, valuemask, &values);

	XSetForeground(d->display, d->gc,
			BlackPixel(d->display, d->screen));
	XSetBackground(d->display, d->gc,
			WhitePixel(d->display, d->screen));
	XSetLineAttributes(d->display, d->gc,
			1, LineSolid, CapRound, JoinRound);

	/* Funny attributes stuff */
	XSetWindowAttributes attr;
	attr.backing_store = Always;
	attr.backing_planes = 1;
	attr.backing_pixel = BlackPixel(d->display, d->screen);

	XChangeWindowAttributes(d->display, d->win,
				CWBackingStore | CWBackingPlanes |
				CWBackingPixel, &attr);

	XWindowAttributes gattr;
	XGetWindowAttributes(d->display, d->win, &gattr);

	XMapWindow(d->display, d->win);

	/* create main pixmap */
	d->main_map = XCreatePixmap(d->display, d->win, sz_x, sz_y,
			gattr.depth);
	d->m_sz_x = sz_x;
	d->m_sz_y = sz_y;

	GC bgc = XCreateGC(d->display, d->main_map, valuemask, &values);
	/* Color the pixmap white */
	XSetForeground(d->display, bgc,
			WhitePixel(d->display, d->screen));
	XSetLineAttributes(d->display, bgc,
			1, LineSolid, CapRound, JoinRound);
	XFillRectangle(d->display, d->main_map, bgc, 0, 0,
			d->m_sz_x, d->m_sz_y);

	/* set GC to BLACK for point drawing */

	XSync(d->display, 0);

	return d;
}

void draw_done(db_t *db)
{
	XFlush(db->display);
	XSelectInput(db->display, db->win, ButtonPressMask | KeyPressMask);

	/* perform an events loop unit mouse button or keyis presses */
	{
		int done = 0;
		XEvent an_event;
		while (!done) {
			XNextEvent(db->display, &an_event);
			switch (an_event.type) {
			case KeyPress:
			case ButtonPress:
				done = 1;
			}
		}
		XCloseDisplay(db->display);
	}
}

void draw_pixels(db_t *db, XPoint *pts, size_t n_pts)
{
	fprintf(stderr,"start -> ");
	XDrawPoints(db->display, db->main_map, db->gc, pts,
			n_pts, CoordModeOrigin);
	XDrawPoints(db->display, db->win, db->gc, pts,
			n_pts, CoordModeOrigin);

	/*
	XCopyArea(db->display, db->main_map, db->win, db->gc,
			0, 0, db->m_sz_x, db->m_sz_y, 0,0);
		*/
	fprintf(stderr,"done\n");
}

int main(int argc, char **argv)
{
	/* Mandlebrot variables */
	unsigned i, j, k;
	Compl z, c;
	float lengthsq, temp;

	db_t *db = draw_init(X_RESN, Y_RESN);

	/* Calculate and draw points */
	for (i = 0; i < X_RESN; i++) {
		c.imag = ((float)i - (float)X_RESN/2) / ((float)X_RESN)/4;
		for (j = 0; j < Y_RESN; j++) {

			z.real = z.imag = 0.0;
			/* scale factors for 800 x 800 window */
			c.real = ((float)j - (float)Y_RESN/2) / (float)Y_RESN/4;
			k = 0;

			/* noted as "iterate for pixel color" */
			do {
				temp =
				    z.real * z.real - z.imag * z.imag + c.real;
				z.imag = 2.0 * z.real * z.imag + c.imag;
				z.real = temp;
				lengthsq = z.real * z.real + z.imag * z.imag;
				k++;

			} while (lengthsq < 4.0 && k < 100);

			if (k == 100) {
				XPoint pt = { .x = i, .y = j };
				draw_pixels(db, &pt, 1);
			}
		}
	}

	/* wait for user input to quit */
	draw_done(db);

	return 0;
}
