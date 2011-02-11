/* Sequential Mandelbrot program */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <complex.h>


//#include <cairo.h>


#define		X_RESN	80	/* x resolution */
#define		Y_RESN	50	/* y resolution */

typedef struct complextype {
	float real, imag;
} Compl;

int main(int argc, char **argv)
{
	/* Mandlebrot variables */

	/* drawing */
//	cairo_surface_t surface = cairo_image_surface_create (CAIRO_FORMAT_ARGB32, 120, 120);
//	cairo_t *cr = cairo_create (surface);

	/* Calculate and draw points */
	unsigned i;
	for (i = 0; i < X_RESN; i++) {
		unsigned j;
		for (j = 0; j < Y_RESN; j++) {
			complex double z = 0;
			complex double c = I*(i - 400.0)/200 + (j - 400.0)/200; /* scale factors for 800 x 800 window */

			double lengthsq, temp;
			unsigned k = 0;
			do {	/* iterate for pixel color */
				temp =
				    creal(z) * creal(z) - cimag(z) * cimag(z) + creal(c);
				z = I*(2*creal(z)*cimag(z) + cimag(c)) + temp;
				lengthsq = creal(z) * creal(z) + cimag(z) * cimag(z);
				k++;
			} while (lengthsq < 4.0 && k < 100);

			if (k == 100) {
				printf("*");
			}
		}
		printf("\n");
	}
	return 0;
}
