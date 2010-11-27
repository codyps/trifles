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
	/* Perform the carry for the later subtraction by updating y. */
	if (x->tv_nsec < y->tv_nsec) {
		long nsec = (y->tv_nsec - x->tv_nsec) + 1;
		y->tv_nsec -= nsec;
		y->tv_sec += nsec;
	}
	if (x->tv_nsec - y->tv_nsec > 1000000000) {
		long nsec = (x->tv_nsec - y->tv_nsec);
		y->tv_nsec += nsec;
		y->tv_sec -= nsec;
	}

	/* Compute the time remaining to wait.
	   tv_usec is certainly positive. */
	result->tv_sec = x->tv_sec - y->tv_sec;
	result->tv_nsec = x->tv_nsec - y->tv_nsec;

	/* Return 1 if result is negative. */
	return x->tv_sec < y->tv_sec;
}

void draw_pixels(size_t sz_x, size_t sz_y, int *data)
{
	unsigned int width, height,	/* window size */
	 x, y,			/* window position */
	 border_width,		/*border width in pixels */
	 display_width, display_height,	/* size of screen */
	 screen;		/* which screen */
	Window win;		/* initialization for a window */
	GC gc;
	XGCValues values;
	Display *display;
	XSizeHints size_hints;
	//Pixmap bitmap;
	//XPoint points[800];
	XSetWindowAttributes attr[1];
	unsigned long valuemask = 0;

	char *window_name = "Mandelbrot Set", *display_name = NULL;

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

	width = sz_x;
	height = sz_y;

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

	sleep(1);
	int i, j;
	for (i = 0; i < sz_x; i++)
		for (j = 0; j < sz_y; j++)
			if (data[i + j * sz_x] == 1) {
				struct timespec ts1, ts2, tsr;
				clock_gettime(CLOCK_MONOTONIC, &ts1);
				XDrawPoint(display, win, gc, j, i);
				clock_gettime(CLOCK_MONOTONIC, &ts2);
				timespec_subtract(&tsr, &ts1, &ts2);
				fprintf(stderr, "t: %lu %lu\n", 
					(unsigned long)tsr.tv_sec,
					tsr.tv_nsec);
			}

	XFlush(display);
	sleep(30);
}



int main(int argc, char **argv)
{
	/* Mandlebrot variables */
	unsigned i, j, k;
	Compl z, c;
	float lengthsq, temp;

	/* Calculate and draw points */
	int *srn_data = malloc(sizeof(*srn_data) * X_RESN * Y_RESN);
	if (!srn_data) {
		fprintf(stderr,"malloc error.\n");
		exit(1);
	}

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
				srn_data[i + j * X_RESN] = 1;
			} else {
				srn_data[i + j * X_RESN] = 0;
			}
		}
	}

	/* Drawing */
	draw_pixels(X_RESN, Y_RESN, srn_data);

	return 0;
}
