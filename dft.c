#include <math.h>
#include <complex.h>
#include <stddef.h>
#include <string.h>

/*
 * "Fast Fourier Transform Algorithms of Real-Valued ..."
 *	www.ti.com/lit/an/spra291/spra291.pdf
 *
 * "Fast Solutions to Real-Data Discrete Fourier Transform"
 *  http://www.springer.com/cda/content/document/cda_downloaddocument/9789048139163-c2.pdf?SGWID\x3d0-0-45-1123959-p173942904
 *  
 *  "A guided tour of the fast Fourier transform"
 *   http://www.astro.cornell.edu/~cordes/A6523/Bergland_Guided_Tour_FFT_1969.pdf
 */

/*
 * For real valued data, we can compute 2 DTFs using one evaluation of a
 * complex-valued DFT algorithm:
 *
 * x(n) = x1(n) + j * x2(n)
 *
 * then
 *
 * X1(k) = 1/2 ( X(k) + X\* (N - k) )
 * X2(k) = 1/(2 * j) ( X(k) - X\* (N - k) )
 */

/*
 * Bergland's algorithm
 * - N memory locations used
 * - in-place computation
 *
 * Paper is basically impossible to find without paying someone.
 */

/* Danielson-Lanczos Algorithm
 *  http://beige.ucs.indiana.edu/B673/node14.html
 */
void dl_ft(complex double f[], size_t n, int is)
{
	(void)f;
	(void)n;
	(void)is;
}

static complex double sin_cos(complex double x)
{
	return sin(creal(x)) + cos(cimag(x)) * I;
}

/*
 * slow impl from http://caxapa.ru/thumbs/455725/algorithms.pdf
 * O(n**2) operations, extra N storage.
 */
void ft(complex double f[], size_t n, int is)
{
	complex double h[n];
	const double ph0 = is * 2.0 * M_PI / n;
	size_t w;
	for (w = 0; w < n; w++) {
		complex double t = 0.0;
		size_t k;
		for (k = 0; k < n; k++) {
			t += f[k] * sin_cos(ph0 * k * w);
		}
		h[w] = t;
	}
	memcpy(f, h, n);
}



void sine_wave(double sample_rate_hz, double freq_hz, unsigned char *out, size_t out_len, unsigned half_peak_to_peak)
{
	double step = freq_hz * 2 * M_PI / sample_rate_hz;
	size_t i;
	for (i = 0; i < out_len; i++)
		out[i] = half_peak_to_peak * sin(step * i) + half_peak_to_peak;
}

int main(void)
{
	unsigned sample_rate_hz = 8000;
	unsigned char data[sample_rate_hz * 5];

	sine_wave(sample_rate_hz, 60, data, sizeof(data), 127);

	ft(
}
