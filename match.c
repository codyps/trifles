#define _GNU_SOURCE 1
#define DEBUG 1
#include <stddef.h>
#include <stdio.h>
#include <fnmatch.h>
#include <string.h>
#include <stdlib.h>

#define pr_err(...) printf(__VA_ARGS__)
#define pr_warn(...) printf(__VA_ARGS__)
#define pr_devel(...) printf(__VA_ARGS__)

#define dev_name(d) ((d)->name)

static int root_wait = 0;

static int glob_match(const char *pat, const char *str)
{
    return !fnmatch(pat, str, 0);
}

struct device {
    struct device *parent;
    const char *name;
};


/*** ***/
struct pathcmp {
	const char *path;
	size_t len;
};

/**
 * match_dev_by_syspath - callback for finding a block device using it's syspath
 * @dev:	device passed in by the caller
 * @data:	opaque pointer to the desired struct pathcmp  to match
 *
 * Returns 1 if the device matches, and 0 otherwise.
 */
static int match_dev_by_syspath(struct device *dev, const void *data)
{
	struct device *d;
	const struct pathcmp *cmp = data;
	const char *elem_end = cmp->path + cmp->len;
	size_t elem_ct = 0;
	const char *slash_start;

#ifdef DEBUGAAA
	{
		char buf[PATH_MAX];
		syspath(dev, buf, sizeof(buf));
		pr_devel("1 - syspath: %s\n", buf);
		pr_devel("2 - matcher: %s\n", cmp->path);
	}
#endif

	/*
	 * Iterate through the elements of the path in reverse to match the
	 * traversal of the device structures (which follows the parent of each
	 * device upwards).
	 */
	for (d = dev; d; d = d->parent, elem_ct++, elem_end = slash_start) {
		size_t elem_len;
		const char *n, *elem_start;

		if (elem_end <= cmp->path) {
			pr_devel("rejected due to running out of path to compare %zu\n", elem_ct);
			return 0;
		}

		/*
		 * elem_end points to the last found '/' or to 1 past the end
		 * of the syspath (if this is element 0), so we must not search
		 * it for the next '/'
		 */
		slash_start = memrchr(cmp->path, '/', (elem_end - cmp->path - 1));

		if (!slash_start) {
			pr_err("VFS: bad SYSPATH, does not begin with '/' (after %zu elements parsed)\n",
					elem_ct);
			goto invalid;
		}

		elem_start = slash_start + 1;
		n = dev_name(d);
		elem_len = elem_end - elem_start;

		/*
		 * This only occurs if someone does "//", which is invalid (we
		 * require normalized paths), so let's reject it
		 */
		if (elem_len == 0) {
			pr_err("VFS: bad SYSPATH, contains '//' near element -%zu", elem_ct);
			goto invalid;
		}

		{
			char pat[elem_len + 1];
			memcpy(pat, elem_start, elem_len);
			pat[elem_len] = '\0';
			if (!glob_match(pat, n)) {
				pr_devel("mismatch at elem %zu: %zu != %zu, '%.*s' != '%s' \n",
						elem_ct, elem_len, strlen(n),
						(int)elem_len, elem_start, n);
				return 0;
			}
		}
	}

	if (elem_end != cmp->path) {
		pr_devel("matched on suffix, not total after %zu elems\n", elem_ct);
		return 0;
	}

	return 1;
invalid:
	pr_err("VFS: SYSPATH= is invalid.\n"
	       "Expected SYSPATH=/<full-sys-path>\n");
	if (root_wait)
		pr_err("Disabling rootwait; root= is invalid.\n");
	root_wait = 0;
	return 0;
}

static void *memdup(const void *d, size_t len)
{
    void *p = malloc(len);
    if (!p)
	return p;
    memcpy(p, d, len);
    return p;
}

int main(void)
{
    const char *syspath = "/platform/ocp/48060000.mmc/mmc0/mmc0:aaaa/mmcblk0/mmcblk0p11";
    const char *matcher = "/platform/ocp/48060000.mmc/*/*/*/mmcblk*p11";


    struct device *d = NULL;
    const char *pos = syspath + 1;
    for (;;) {
        const char *next = strchrnul(pos, '/');
        struct device *n = malloc(sizeof(struct device));
        n->name = memdup(pos, next - pos + 1);
	((char *)n->name)[next - pos] = '\0';
	printf("append '%s'\n", n->name);
        n->parent = d;
        d = n;

        if (*next == '\0')
            break;
	pos = next + 1;
    }

    struct pathcmp p = {
        .path = matcher,
        .len = strlen(matcher),
    };
    int r = match_dev_by_syspath(d, &p);

    printf("match: %d\n", r);

    while (d) {
	struct device *u = d->parent;
	free((void *)d->name);
	free(d);
	d = u;
    }

    return 0;
}
