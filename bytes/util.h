#ifndef UTIL_H_

#define DEBUG(...) do { \
	if (debug > 0)  \
		error_at_line(0, errno, __FILE__, __LINE__, __VA_ARGS);\
} while(0)
#define WARN(...) error_at_line(0, errno, __FILE__, __LINE__, __VA_ARGS__)
#define ERROR(status, ...) error_at_line(status, errno, __FILE__, __LINE__, __VA_ARGS__)

__attribute__((format(printf,5,6)))
void error_at_line(int status, int errnum, const char *filename,
                   unsigned int linenum, const char *format, ...);

#endif
