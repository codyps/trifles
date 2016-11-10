#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <arpa/inet.h> /* ntohl */
#include <inttypes.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/mman.h>

/* uImage types */
#define IH_TYPE_INVALID         0       /* Invalid Image                */
#define IH_TYPE_STANDALONE      1       /* Standalone Program           */
#define IH_TYPE_KERNEL          2       /* OS Kernel Image              */
#define IH_TYPE_RAMDISK         3       /* RAMDisk Image                */
#define IH_TYPE_MULTI           4       /* Multi-File Image             */
#define IH_TYPE_FIRMWARE        5       /* Firmware Image               */
#define IH_TYPE_SCRIPT          6       /* Script file                  */
#define IH_TYPE_FILESYSTEM      7       /* Filesystem Image (any type)  */
#define IH_TYPE_FLATDT          8       /* Binary Flat Device Tree Blob */
#define IH_TYPE_KWBIMAGE        9       /* Kirkwood Boot Image          */
#define IH_TYPE_IMXIMAGE        10      /* Freescale IMXBoot Image      */
#define IH_TYPE_UBLIMAGE        11      /* Davinci UBL Image            */
#define IH_TYPE_OMAPIMAGE       12      /* TI OMAP Config Header Image  */
#define IH_TYPE_AISIMAGE        13      /* TI Davinci AIS Image         */
#define IH_TYPE_KERNEL_NOLOAD   14      /* OS Kernel Image, can run from any load address */

#define IH_MAGIC        0x27051956      /* Image Magic Number           */

#define MIN(x, y) ({ \
	typeof(x) _min__x = (x); \
	typeof(y) _min__y = (y); \
	(void)(&_min__x == &_min__y); \
	(_min__x < _min__y) ? _min__x : _min__y; \
})

#define ALIGN_MASK(x, mask) (((x) + (mask)) & ~(mask))

/*
 * Legacy format image header,
 * all data in network byte order (aka natural aka bigendian).
 */
struct uimage_legacy_header {
        uint32_t       ih_magic;       /* Image Header Magic Number    */
        uint32_t       ih_hcrc;        /* Image Header CRC Checksum    */
        uint32_t       ih_time;        /* Image Creation Timestamp     */
        uint32_t       ih_size;        /* Image Data Size              */
        uint32_t       ih_load;        /* Data  Load  Address          */
        uint32_t       ih_ep;          /* Entry Point Address          */
        uint32_t       ih_dcrc;        /* Image Data CRC Checksum      */
        uint8_t        ih_os;          /* Operating System             */
        uint8_t        ih_arch;        /* CPU architecture             */
        uint8_t        ih_type;        /* Image Type                   */
        uint8_t        ih_comp;        /* Compression Type             */
        uint8_t        ih_name[32];    /* Image Name           */
};

static void ind(size_t indent, FILE *o)
{
	size_t i;
	for (i = 0; i < indent; i++)
		putc(' ', o);
}

static int show_header(const struct uimage_legacy_header *hdr, size_t size, size_t indent, FILE *o)
{
	ind(indent, o);
	fprintf(o,
		"name='%.32s',magic=%" PRIx32
		", crc=%" PRIx32 ", time=%" PRIx32
		", size=%" PRIx32 ", load=%" PRIx32 ", ep=%" PRIx32 ", dcrc=%" PRIx32
		", os=%u, arch=%u, type=%u, comp=%u\n",
		hdr->ih_name, hdr->ih_magic,
		hdr->ih_hcrc, hdr->ih_time,
		hdr->ih_size, hdr->ih_load,
		hdr->ih_ep, hdr->ih_dcrc,
		hdr->ih_os, hdr->ih_arch, hdr->ih_type, hdr->ih_comp);

	indent++;

	size_t sz = htonl(hdr->ih_size);
	if (sz != size) {
		ind(indent, o);
		fprintf(o, "size mismatch: header=%zu, file=%zu\n",
			sz, size);
		/* FIXME: do some handle to avoid invalid access */
	}
	sz = MIN(size, sz);

	if (hdr->ih_type == IH_TYPE_MULTI) {
		size_t i;
		const uint32_t *sizes = (const uint32_t *)((const char *)hdr + sizeof(*hdr));
		/* FIXME: avoid scanning off the end */
		for (i = 0; ; i++) {
			if (!sizes[i])
				break;
		}
		size_t ct = i;

		ind(indent, o);
		fprintf(o, "multi with %zu images\n", ct);
	
		/* FIXME: check alignment of images (to 4 byte boundaries) */
		const char *image = (const char *)&sizes[ct + 1];
		for (i = 0; i < ct; i++) {
			ind(indent, o);
			size_t tsz = ntohl(sizes[i]);
			fprintf(o, "%zu: bytes %zu\n", i, tsz);
			show_header((const struct uimage_legacy_header *)image, tsz, indent + 1, o);
			image += tsz;
			image = (const char *)ALIGN_MASK((uintptr_t)image, 4-1);
		}
	}

	return 0;
}

static const char opts[] = ":h";
static void usage_(const char *progname, int e)
{
	FILE *f = stdout;
	if (e != EXIT_SUCCESS)
		f = stderr;

	fprintf(f,
"Usage: %s [options] <uimage-file>\n"
"Options: [%s]\n"
"  -h     show this help text\n",
		progname, opts);

	exit(e);
}

#define PROGNAME (argc?argv[0]:"uimage-info")
#define usage(x) usage_(PROGNAME, x)
int main(int argc, char *argv[])
{
	int err = 0;
	int opt;
	while ((opt = getopt(argc, argv, opts)) != -1) {
		switch (opt) {
		case 'h':
			usage(EXIT_SUCCESS);
		default:
			fprintf(stderr, "Error: unrecognized argument: %c\n", optopt);
			err++;
		}
	}

	if (optind >= argc) {
		fprintf(stderr, "Error: a filename argument is required after options\n");
		err++;
	}

	if (err) {
		fprintf(stderr, "Exiting due to previous errors (%u), try `%s -h` for usage\n",
			err, PROGNAME);
		exit(EXIT_FAILURE);
	}

	const char *img_path = argv[optind];

	int fd = open(img_path, O_RDONLY);
	if (fd == -1) {
		fprintf(stderr, "Failed to open image '%s': %s\n", img_path, strerror(errno));
		exit(EXIT_FAILURE);
	}

	struct stat sb;
	int r = fstat(fd, &sb);
	if (r == -1) {
		fprintf(stderr, "Failed to stat image '%s': %s\n", img_path, strerror(errno));
		exit(EXIT_FAILURE);
	}

	if (sb.st_size < sizeof(struct uimage_legacy_header)) {
		fprintf(stderr, "Image file is too small '%s' is %zu bytes but minimal size is %zu bytes\n",
			img_path, sb.st_size, sizeof(struct uimage_legacy_header));
		exit(EXIT_FAILURE);
	}

	/* FIXME: avoid using mmap via reads */
	struct uimage_legacy_header *file = mmap(NULL, sb.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
	if (!file) {
		fprintf(stderr, "Failed to map image file '%s': %s\n", img_path, strerror(errno));
		exit(EXIT_FAILURE);
	}
	
	/* FIXME: need to fully validate, or have show() do incrimental validation */
	return show_header(file, sb.st_size, 0, stdout);
}
