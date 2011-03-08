
__attribute__((format(printf,5,6)))
void error_at_line(int status, int errnum, const char *filename,
                   unsigned int linenum, const char *format, ...)
{
	va_list ap;
	va_start(ap, format);
	fflush(stdout);

	fprintf(stderr, "%s:%u :", filename, linenum);

	if (errnum)
		fprintf(stderr, "%s : ", strerror(errnum));

	vfprintf(stderr, format, ap);

	fputc('\n',stderr);

	fflush(stderr);

	va_end(ap);
	if (status)
		exit(status);
}
