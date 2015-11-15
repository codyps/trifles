#include <stdio.h>
#include <math.h>
#include <complex.h>

struct goertzel_d {
	double sine, cosine, coeff, q1, q2;
};

struct goertzel_d goertzel_d_init(double sample_rate_hz,
		double target_freq_hz,
		unsigned block_sz)
{
	int k = (0.5 + ((block_sz * target_freq_hz)
				/ sample_rate_hz));
	double omega = (2.0 * M_PI * k) / block_sz;
	double cosine = cos(omega);
	return (struct goertzel_d) {
		.sine = sin(omega),
		.cosine = cosine,
		.coeff = 2 * cosine,
	};
}

/* Must only be called @block_sz times on a given state */
void goertzel_d_feed_one(struct goertzel_d *s, unsigned char sample)
{
	double q0 = s->coeff * s->q1 - s->q2 + sample;
	s->q2 = s->q1;
	s->q1 = q0;
}

void goertzel_d_feed(struct goertzel_d *s, unsigned char *samples, size_t sample_bytes)
{
	size_t i;
	for (i = 0; i < sample_bytes; i++)
		goertzel_d_feed_one(s, samples[i]);
}

/* Must only be called after @block_sz samples has been fed to a
 * state */
double goertzel_d_mag(struct goertzel_d *s)
{
	return s->q1 * s->q1
		+ s->q2 * s->q2
		- s->q1 * s->q2 * s->coeff;
}

complex double goertzel_d_cmag(struct goertzel_d *s)
{
	return s->q1 - s->q2 * s->cosine
		+ I * (s->q2 * s->sine);
}

/* test */

void sine_wave(double sample_rate_hz, double freq_hz, unsigned char *out, size_t out_len, unsigned half_peak_to_peak)
{
	double step = freq_hz * 2 * M_PI / sample_rate_hz;
	size_t i;
	for (i = 0; i < out_len; i++)
		out[i] = half_peak_to_peak * sin(step * i) + half_peak_to_peak;
}

void do_test(double offset)
{
	double sample_rate = 8000;
	size_t l = 205;
	double base_freq = 941;
	double probe_freq = base_freq + offset;
	unsigned char d[l];
	struct goertzel_d s = goertzel_d_init(sample_rate,
			base_freq, l);

	sine_wave(sample_rate, probe_freq, d, sizeof(d), 100);

	goertzel_d_feed(&s, d, sizeof(d));
	complex double c = goertzel_d_cmag(&s);
	double m = goertzel_d_mag(&s);
	printf("freq: %lf, mag: %lf => %lf, c: %lf + i%lf => %lf\n", probe_freq, m, sqrt(m), creal(c), cimag(c), cabs(c));
}

int main(int argc, char **argv)
{
	do_test(-150);
	do_test(-10);
	do_test(0);
	do_test(+150);
	return 0;
}
