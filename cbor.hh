#pragma once
#include <vector>
#include <cstdlib>

namespace cbor {

enum Type {
	C_FALSE,
	C_TRUE,
	C_NULL,
	C_UNDEF,
	C_UINT,
	C_INT,
	C_BYTES,
	C_TEXT,
	C_BYTES_CHUNKED,
	C_TEXT_CHUNKED,
	C_ARRAY,
	C_MAP,
	C_TAG,
	C_SIMPLE,
	C_DOUBLE,
	C_INVALID,
};

struct Object {
	Type type;
	union {
		const unsigned char *bytes;
		const char *text;
		long sint;
		unsigned long uint;
		double dbl;
	} v;
};

Object decode(unsigned char *data, size_t ct)
{
	unsigned char c = *data;
	// major type
	switch (c & 0xe0) {
		case 0: // uint
		case 1: // negative int
		case 2: // byte string
		case 3: // text
		case 4: // array
		case 5: // map
		case 6: // tags
		case 7: // floats
			break;
	}
}

struct Buffer {
	std::vector<unsigned char> data;
};

bool write_bytes(Buffer &buf, unsigned char *data, size_t ct)
{
	buf.data.assign(data, data+ct);
	return true;
}

template<typename T, size_t N>
bool write_bytes(T &buf, unsigned char data[N])
{
	return write_bytes(buf, data, N);
}

template<typename T>
bool encode_null(T &buf)
{
	return write_bytes(buf, "\xe1");
}

}
