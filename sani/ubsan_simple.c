#include <assert.h>
#include <inttypes.h>
#include <limits.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#ifdef __cplusplus
#define EXTERN_C extern "C"
#else
#define EXTERN_C
#endif

#ifndef NORETURN
#define NORETURN __attribute__((__noreturn__))
#endif

#define USL_EXP(x) (x)->filename, (x)->line, (x)->column
#define USL_FMT "%s:%" PRIu32 ":%" PRIu32
struct ubsan_source_location {
	const char *filename;
	uint32_t line;
	uint32_t column;
};

enum ubsan_type_kind {
	/*
	 * struct utk_int_type_info {
	 *	u16 base_two_size: 15;
	 *	u16 is_signed: 1;
	 * }
	 *
	 * if (sizeof(value) =< sizeof(value_handle))
	 *  value_handle = value;
	 * else
	 *  value_handle = &value;
	 */
	utk_int = 0,

	/*
	 * struct utk_float_type_info {
	 *	u16 bit_width;
	 * }
	 *
	 * value_handle is set the same way as integer type, after casting the
	 * float to an int.
	 */
	utk_float = 1,

	/*
	 */
	utk_unknown = 0xffff
};

#define UTD_EXP(x) (x)->type_name, (x)->type_kind, (x)->type_info
#define UTD_FMT "%s (kind:%04" PRIx16 " , info:%04" PRIx16 ")"
struct ubsan_type_descriptor {
	/* one of enum ubsan_type_kind */
	uint16_t type_kind;

	/* interp varies based on type_kind, see individual decoding notes above */
	uint16_t type_info;

	/*
	 * used as a vla, with a minimum size of 1
	 * null terminated string
	 */
	char type_name[1];
};

struct ubsan_value_handle;

static const struct ubsan_source_location unknown_location = {
	"<unknown location>",
	0,
	0,
};

static uint_fast16_t
value_int_size(const struct ubsan_type_descriptor *desc)
{
	assert(desc->type_kind == utk_int);
	return 1 << (desc->type_info >> 1);
}

static uint_fast16_t
value_float_size(const struct ubsan_type_descriptor *desc)
{
	assert(desc->type_kind == utk_float);
	return desc->type_info;
}

static uint_fast16_t
value_size(const struct ubsan_type_descriptor *desc)
{
	switch (desc->type_kind) {
	case utk_int:
		return value_int_size(desc);
	case utk_float:
		return value_float_size(desc);
	default:
		return 0;
	}
}

static bool
value_is_inline(const struct ubsan_type_descriptor *desc)
{
	uint_fast16_t v = value_size(desc);
	return v && (v <= (sizeof(void *) * CHAR_BIT));
}

static bool
value_is_signed(const struct ubsan_type_descriptor *desc)
{
	assert(desc->type_kind == utk_int);
	return desc->type_info & 1;
}

static intmax_t
value_int(const struct ubsan_type_descriptor *desc, const struct ubsan_value_handle *vh)
{
	(void)vh;
	assert(value_is_signed(desc));
	if (value_is_inline(desc)) {
		return 3;
	} else {
		return 4;
	}
}

static uintmax_t
value_uint(const struct ubsan_type_descriptor *desc, const struct ubsan_value_handle *vh)
{
	(void)vh;
	assert(!value_is_signed(desc));
	if (value_is_inline(desc)) {
		return 1;
	} else {
		return 2;
	}
}

static long double
value_float(const struct ubsan_type_descriptor *desc, const struct ubsan_value_handle *vh)
{
	(void)vh;
	assert(desc->type_kind == utk_float);
	if (value_is_inline(desc)) {
		return 5;
	} else {
		return 6;
	}
}

static int
value_render(const struct ubsan_type_descriptor *desc, const struct ubsan_value_handle *vh,
		char *out, size_t out_len)
{
	(void)vh;
	switch (desc->type_kind) {
	case utk_int:
		if (value_is_signed(desc)) {
			return snprintf(out, out_len, "%s (aka int%" PRIdFAST16 "_t) = %jd",
					desc->type_name,
					value_int_size(desc),
					value_int(desc, vh));
		} else {
			return snprintf(out, out_len, "%s (aka uint%" PRIdFAST16 "_t) = %ju",
					desc->type_name,
					value_int_size(desc),
					value_uint(desc, vh));
		}
	case utk_float:
		return snprintf(out, out_len, "%s (aka float%" PRIdFAST16 "_t) = %Lf",
				desc->type_name,
				value_float_size(desc),
				value_float(desc, vh));
	case utk_unknown:
		return snprintf(out, out_len, "unknown{name=%s,info=%04" PRIx16 "}",
				desc->type_name,
				desc->type_info);
	default:
		return snprintf(out, out_len, "<unknown=%04" PRIx16 ">{name=%s,info=%04" PRIx16 "}",
				desc->type_kind,
				desc->type_name,
				desc->type_info);
	}
}

__attribute__((__format__(__printf__, 2, 3)))
static void ubsan_abort(const struct ubsan_source_location* location,
                        const char *fmt, ...)
{
	if (!location || !location->filename)
		location = &unknown_location;
	fprintf(stderr, "Undefined behavior at " USL_FMT  ": ",
			USL_EXP(location));
	va_list va;
	va_start(va, fmt);
	vfprintf(stderr, fmt, va);
	va_end(va);
	putc('\n', stderr);
}

struct ubsan_type_mismatch_data
{
	struct ubsan_source_location location;
	const struct ubsan_type_descriptor *type;
	uintptr_t alignment;
	unsigned char type_check_kind;
};

EXTERN_C
void __ubsan_handle_type_mismatch(void *data_raw,
                                  void *pointer_raw)
{
	struct ubsan_type_mismatch_data *data = data_raw;
	struct ubsan_value_handle *pointer = pointer_raw;
	(void) pointer;
	ubsan_abort(&data->location, "type mismatch: " UTD_FMT, UTD_EXP(data->type));
}

struct ubsan_overflow_data
{
	struct ubsan_source_location location;
	const struct ubsan_type_descriptor *type;
};

static void
ubsan_report_overflow(struct ubsan_overflow_data *data,
		struct ubsan_value_handle *lhs, struct ubsan_value_handle *rhs,
		const char *kind)
{
	char lb[value_render(data->type, lhs, NULL, 0) + 1];
	char rb[value_render(data->type, rhs, NULL, 0) + 1];

	value_render(data->type, lhs, lb, sizeof(lb));
	value_render(data->type, rhs, rb, sizeof(rb));

	ubsan_abort(&data->location, "%s overflow: lhs = (%s), rhs = (%s)", kind, lb, rb);
}

EXTERN_C
void __ubsan_handle_add_overflow(void* data_raw,
                                 void* lhs_raw,
                                 void* rhs_raw)
{
	ubsan_report_overflow(data_raw, lhs_raw, rhs_raw, "add");
}

EXTERN_C
void __ubsan_handle_sub_overflow(void* data_raw,
                                 void* lhs_raw,
                                 void* rhs_raw)
{
	ubsan_report_overflow(data_raw, lhs_raw, rhs_raw, "sub");
}

EXTERN_C
void __ubsan_handle_mul_overflow(void* data_raw,
                                 void* lhs_raw,
                                 void* rhs_raw)
{
	ubsan_report_overflow(data_raw, lhs_raw, rhs_raw, "mul");
}

EXTERN_C
void __ubsan_handle_negate_overflow(void* data_raw,
                                    void* old_value_raw)
{
	struct ubsan_overflow_data *data = data_raw;
	struct ubsan_overflow_data *old_value = old_value_raw;
	(void) old_value;
	ubsan_abort(&data->location, "negation overflow");
}

EXTERN_C
void __ubsan_handle_divrem_overflow(void* data_raw,
                                    void* lhs_raw,
                                    void* rhs_raw)
{
	ubsan_report_overflow(data_raw, lhs_raw, rhs_raw, "divrem");
}

struct ubsan_shift_out_of_bounds_data
{
	struct ubsan_source_location location;
	const struct ubsan_type_descriptor *lhs_type;
	const struct ubsan_type_descriptor *rhs_type;
};

EXTERN_C
void __ubsan_handle_shift_out_of_bounds(void* data_raw,
                                        void* lhs_raw,
                                        void* rhs_raw)
{
	struct ubsan_shift_out_of_bounds_data *data = data_raw;
	struct ubsan_value_handle *lhs = lhs_raw;
	struct ubsan_value_handle *rhs = rhs_raw;

	char lb[value_render(data->lhs_type, lhs, NULL, 0) + 1];
	char rb[value_render(data->rhs_type, rhs, NULL, 0) + 1];

	value_render(data->lhs_type, lhs, lb, sizeof(lb));
	value_render(data->rhs_type, rhs, rb, sizeof(rb));

	ubsan_abort(&data->location, "shift out of bounds: lhs = (%s), rhs = (%s)", lb, rb);
}

struct ubsan_out_of_bounds_data
{
	struct ubsan_source_location location;
	const struct ubsan_type_descriptor *array_type;
	const struct ubsan_type_descriptor *index_type;
};

EXTERN_C
void __ubsan_handle_out_of_bounds(void* data_raw,
                                  void* index_raw)
{
	struct ubsan_out_of_bounds_data *data = data_raw;
	struct ubsan_value_handle *index = index_raw;
	(void) index;
	ubsan_abort(&data->location, "out of bounds");
}

struct ubsan_unreachable_data
{
	struct ubsan_source_location location;
};

EXTERN_C
void __ubsan_handle_builtin_unreachable(void *data_raw)
{
	struct ubsan_unreachable_data *data = data_raw;
	ubsan_abort(&data->location, "reached unreachable");
}

EXTERN_C
void __ubsan_handle_missing_return(void *data_raw)
{
	struct ubsan_unreachable_data *data = data_raw;
	ubsan_abort(&data->location, "missing return");
}

struct ubsan_vla_bound_data
{
	struct ubsan_source_location location;
	const struct ubsan_type_descriptor *type;
};

EXTERN_C
void __ubsan_handle_vla_bound_not_positive(void* data_raw,
                                           void* bound_raw)
{
	struct ubsan_vla_bound_data *data = data_raw;
	struct ubsan_value_handle *bound = bound_raw;
	(void) bound;
	ubsan_abort(&data->location, "negative variable array length");
}

struct ubsan_float_cast_overflow_data {
	const struct ubsan_type_descriptor *from_type;
	const struct ubsan_type_descriptor *to_type;
};

struct ubsan_float_cast_overflow_data_v2 {
	struct ubsan_source_location location;
	const struct ubsan_type_descriptor *from_type;
	const struct ubsan_type_descriptor *to_type;
};

/*
 * we have to guess, no extra info is given (thanks developers!)
 *
 * First element is either: a pointer to a string, or a pointer to a type_desc.
 *
 * We have to assume we're allowed to dereference a pointer without knowing the underlying type.
 * This is all types of nasty, and probably is UB itself :)
 *
 * If the first 2 bytes look like a type_desc, then it is probably the old data
 * If they don't, it's probably v2.
 *
 * If more type_desc values are added, this will need to be updated.
 */
static bool data_looks_like_v1(void *data)
{
	uint8_t *v = *((void **)data);
	return (v[0] + v[1]) < 2 || v[0] == 0xff || v[1] == 0xff;
}

EXTERN_C
void __ubsan_handle_float_cast_overflow(void* data_raw,
                                        void* from_raw)
{
	struct ubsan_float_cast_overflow_data_v2 data;
	if (data_looks_like_v1(data_raw)) {
		struct ubsan_float_cast_overflow_data *d_v1 = data_raw;
		data.location = unknown_location;
		data.from_type = d_v1->from_type;
		data.to_type = d_v1->to_type;
	} else {
		data = *((struct ubsan_float_cast_overflow_data_v2 *)data_raw);
	}

	struct ubsan_value_handle *from = from_raw;
	(void) from;
	ubsan_abort(&data.location, "float cast overflow");
}

struct ubsan_invalid_value_data
{
	struct ubsan_source_location location;
	struct ubsan_type_descriptor *type;
};

EXTERN_C
void __ubsan_handle_load_invalid_value(void* data_raw,
                                       void* value_raw)
{
	struct ubsan_invalid_value_data *data = data_raw;
	struct ubsan_value_handle *value = value_raw;
	(void) value;
	ubsan_abort(&data->location, "invalid value load");
}

struct ubsan_function_type_mismatch_data
{
	struct ubsan_source_location location;
	const struct ubsan_type_descriptor *type;
};

EXTERN_C
void __ubsan_handle_function_type_mismatch(void* data_raw,
                                           void* value_raw)
{
	struct ubsan_function_type_mismatch_data *data = data_raw;
	struct ubsan_value_handle *value = value_raw;
	(void) value;
	ubsan_abort(&data->location, "function type mismatch");
}

struct ubsan_nonnull_return_data {
	struct ubsan_source_location loc;
	struct ubsan_source_location attr_loc;
};

void __ubsan_handle_nonnull_return(struct ubsan_nonnull_return_data *data)
{
	ubsan_abort(&data->loc, "nonnull return, attribute at " USL_FMT,
			USL_EXP(&data->attr_loc));
}

struct ubsan_cfi_bad_icall_data {
	struct ubsan_source_location loc;
	const struct ubsan_type_descriptor *type;
};

void __ubsan_handle_cfi_bad_icall(struct ubsan_cfi_bad_icall_data *data, struct ubsan_value_handle *function)
{
	(void)function;
	ubsan_abort(&data->loc, "cfi bad icall");
}
