#ifndef TAG_PACK_H_
#define TAG_PACK_H_

#include <stdint.h>
#include <stddef.h>

/* Usage flow:
 * 1. start a container
 * 2. optionally add metadata to that container (id, name, version, etc.)
 * 3. add contents to the element (which may be more elements)
 * 4. end the container
 *
 * Allow quick buildup of an emitted structure, without requiring that data remain in memory.
 * Elements can contain a sequence other elements, a sequence of bytes (string), or an integer.
 *
 *
 * The more I write this, the more I think I should just use msgpack.
 */

/* TODO: convert int/uint to macros to avoid uintmax/intmax overhead when
 * unneeded */

typedef struct tag_packer tag_packer;

int tag_pack_uint(tag_packer *p, uintmax_t i);
int tag_pack_int(tag_packer *p, intmax_t i);
int tag_pack_bytes(tag_packer *p, void *data, size_t len);
int tag_pack_list_start(tag_packer *p);
int tag_pack_list_end(tag_packer *p);

#endif
