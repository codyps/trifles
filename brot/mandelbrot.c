/* Sequential Mandelbrot program */

#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xos.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#define		X_RESN	800	/* x resolution */
#define		Y_RESN	800	/* y resolution */

typedef struct complextype {
	float real, imag;
} Compl;

typedef struct drawing_board {
	Window win;
	Display *display;
	int screen;
	GC gc;

	Pixmap main_map;
	int m_sz_x;
	int m_sz_y;
} db_t;

void draw_done(Display *display, Window win)
{
	XFlush(display);
	XSelectInput(display, win, ButtonPressMask | KeyPressMask);

	/* perform an events loop unit mouse button or keyis presses */
	{
		int done = 0;
		XEvent an_event;
		while (!done) {
			XNextEvent(display, &an_event);
			switch (an_event.type) {
			case KeyPress:
			case ButtonPress:
				done = 1;
			}
		}
		XCloseDisplay(display);
	}
}

int main()
{
	Window win;		/* initialization for a window */
	unsigned
	int width, height,	/* window size */
	 x, y,			/* window position */
	 border_width,		/*border width in pixels */
	 display_width, display_height,	/* size of screen */
	 screen;		/* which screen */

	char *window_name = "Mandelbrot Set", *display_name = NULL;
	GC gc;
	unsigned
	long valuemask = 0;
	XGCValues values;
	Display *display;
	XSizeHints size_hints;
	Pixmap bitmap;
	XPoint points[800];
	FILE *fp, *fopen();
	char str[100];

	XSetWindowAttributes attr[1];

	/* Mandlebrot variables */
	int i, j, k;
	Compl z, c;
	float lengthsq, temp;

	/* connect to Xserver */

	if ((display = XOpenDisplay(display_name)) == NULL) {
		fprintf(stderr, "drawon: cannot connect to X server %s\n",
			XDisplayName(display_name));
		exit(-1);
	}

	/* get screen size */

	screen = DefaultScreen(display);
	display_width = DisplayWidth(display, screen);
	display_height = DisplayHeight(display, screen);

	/* set window size */

	width = X_RESN;
	height = Y_RESN;

	/* set window position */

	x = 0;
	y = 0;

	/* create opaque window */

	border_width = 4;
	win = XCreateSimpleWindow(display, RootWindow(display, screen),
				  x, y, width, height, border_width,
				  BlackPixel(display, screen),
				  WhitePixel(display, screen));

	size_hints.flags = USPosition | USSize;
	size_hints.x = x;
	size_hints.y = y;
	size_hints.width = width;
	size_hints.height = height;
	size_hints.min_width = 300;
	size_hints.min_height = 300;

	XSetNormalHints(display, win, &size_hints);
	XStoreName(display, win, window_name);

	/* create graphics context */

	gc = XCreateGC(display, win, valuemask, &values);

	XSetBackground(display, gc, WhitePixel(display, screen));
	XSetForeground(display, gc, BlackPixel(display, screen));
	XSetLineAttributes(display, gc, 1, LineSolid, CapRound, JoinRound);

	attr[0].backing_store = Always;
	attr[0].backing_planes = 1;
	attr[0].backing_pixel = BlackPixel(display, screen);

	XChangeWindowAttributes(display, win,
				CWBackingStore | CWBackingPlanes |
				CWBackingPixel, attr);

	XMapWindow(display, win);
	XSync(display, 0);

	/* Calculate and draw points */

	for (i = 0; i < X_RESN; i++)
		for (j = 0; j < Y_RESN; j++) {

			z.real = z.imag = 0.0;

			/* scale factors for 800 x 800 window */
			c.real = ((float)j - (Y_RESN/2)) / (Y_RESN/4);
			c.imag = ((float)i - (Y_RESN/2)) / (X_RESN/4);
			k = 0;

			do {	/* iterate for pixel color */

				temp =
				    z.real * z.real - z.imag * z.imag + c.real;
				z.imag = 2.0 * z.real * z.imag + c.imag;
				z.real = temp;
				lengthsq = z.real * z.real + z.imag * z.imag;
				k++;

			} while (lengthsq < 4.0 && k < 100);

			if (k == 100)
				XDrawPoint(display, win, gc, j, i);

		}

	XFlush(display);

	draw_done(display, win);
	/* Program Finished */

	return 0;
}
